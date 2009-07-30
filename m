Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbZG3O5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbZG3O5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZG3O5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:57:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60678 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZG3O5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:57:39 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/2] sched: fix race in cpupri introduced by cpumask_var
	changes
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, rostedt@goodmis.org, rusty@rustcorp.com.au,
       maxk@qualcomm.com, mingo@elte.hu
Date: Thu, 30 Jul 2009 10:57:28 -0400
Message-ID: <20090730145728.25226.92769.stgit@dev.haskins.net>
In-Reply-To: <20090730145623.25226.29033.stgit@dev.haskins.net>
References: <20090730145623.25226.29033.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
	Note: obsoletes c8cab1ddfafd112c82a69a6cc4ec608984eeac97,
	though it should be harmless to leave the old patch applied.
]

Background:

Several race conditions in the scheduler have cropped up recently,
which Steven and I have tracked down using ftrace.  The most recent
one turns out to be a race in how the scheduler determines a
suitable migration target for RT tasks, introduced recently with commit:

    commit 68e74568fbe5854952355e942acca51f138096d9
    Author: Rusty Russell <rusty@rustcorp.com.au>
    Date:   Tue Nov 25 02:35:13 2008 +1030

        sched: convert struct cpupri_vec cpumask_var_t.

The original design of cpupri allowed lockless readers to quickly
determine a best-estimate target.  Races between the pri_active
bitmap and the vec->mask were handled in the original code because
we would detect and return "0" when this occured.  The design was
predicated on the *effective* atomicity (*) of caching the result
of cpus_and() between the cpus_allowed and the vec->mask.

Commit 68e74568 changed the behavior such that vec->mask is accessed
multiple times.  This introduces a subtle race, the result of which
means we can have a result that returns "1", but with an empty bitmap.

*) yes, we know cpus_and() is not a locked operator across the entire
   composite array, but it is implicitly atomic on a per-word basis
   which is all the design required to work.

Implementation:

Rather than forgoing the lockless design, or reverting to a stack-based
cpumask_t, we simply check for when the race has been encountered and
continue processing in the event that the race is hit.  This renders the
removal race as if the priority bit had been atomically cleared as well,
and allows the algorithm to execute correctly.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_cpupri.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index aef68b6..0f052fc 100644
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
 

