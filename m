Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZHBNMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZHBNMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZHBNMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:12:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:33767 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZHBNMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:12:49 -0400
Date: Sun, 2 Aug 2009 13:12:10 GMT
From: tip-bot for Gregory Haskins <ghaskins@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, rusty@rustcorp.com.au, srostedt@redhat.com,
       tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, a.p.zijlstra@chello.nl, srostedt@redhat.com,
       tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
In-Reply-To: <20090730145728.25226.92769.stgit@dev.haskins.net>
References: <20090730145728.25226.92769.stgit@dev.haskins.net>
Subject: [tip:sched/core] sched: Fix race in cpupri introduced by cpumask_var changes
Message-ID: <tip-07903af152b0597d94e9b0030746b63c4664e787@git.kernel.org>
Git-Commit-ID: 07903af152b0597d94e9b0030746b63c4664e787
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:12:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07903af152b0597d94e9b0030746b63c4664e787
Gitweb:     http://git.kernel.org/tip/07903af152b0597d94e9b0030746b63c4664e787
Author:     Gregory Haskins <ghaskins@novell.com>
AuthorDate: Thu, 30 Jul 2009 10:57:28 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 14:23:29 +0200

sched: Fix race in cpupri introduced by cpumask_var changes

Background:

Several race conditions in the scheduler have cropped up
recently, which Steven and I have tracked down using ftrace.
The most recent one turns out to be a race in how the scheduler
determines a suitable migration target for RT tasks, introduced
recently with commit:

    commit 68e74568fbe5854952355e942acca51f138096d9
    Date:   Tue Nov 25 02:35:13 2008 +1030

        sched: convert struct cpupri_vec cpumask_var_t.

The original design of cpupri allowed lockless readers to
quickly determine a best-estimate target.  Races between the
pri_active bitmap and the vec->mask were handled in the
original code because we would detect and return "0" when this
occured.  The design was predicated on the *effective*
atomicity (*) of caching the result of cpus_and() between the
cpus_allowed and the vec->mask.

Commit 68e74568 changed the behavior such that vec->mask is
accessed multiple times.  This introduces a subtle race, the
result of which means we can have a result that returns "1",
but with an empty bitmap.

*) yes, we know cpus_and() is not a locked operator across the
   entire composite array, but it is implicitly atomic on a
   per-word basis which is all the design required to work.

Implementation:

Rather than forgoing the lockless design, or reverting to a
stack-based cpumask_t, we simply check for when the race has
been encountered and continue processing in the event that the
race is hit.  This renders the removal race as if the priority
bit had been atomically cleared as well, and allows the
algorithm to execute correctly.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090730145728.25226.92769.stgit@dev.haskins.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_cpupri.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index e6c2517..d014efb 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -81,8 +81,21 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
 
-		if (lowest_mask)
+		if (lowest_mask) {
 			cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
+
+			/*
+			 * We have to ensure that we have at least one bit
+			 * still set in the array, since the map could have
+			 * been concurrently emptied between the first and
+			 * second reads of vec->mask.  If we hit this
+			 * condition, simply act as though we never hit this
+			 * priority level and continue on.
+			 */
+			if (cpumask_any(lowest_mask) >= nr_cpu_ids)
+				continue;
+		}
+
 		return 1;
 	}
 
