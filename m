Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZHBNNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZHBNNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZHBNNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:13:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:33808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbZHBNNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:13:24 -0400
Date: Sun, 2 Aug 2009 13:13:00 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090729042526.438281019@goodmis.org>
References: <20090729042526.438281019@goodmis.org>
Subject: [tip:sched/core] sched: Add new prio to cpupri before removing old prio
Message-ID: <tip-c3a2ae3d93c0f10d29c071f599764d00b8de00cb@git.kernel.org>
Git-Commit-ID: c3a2ae3d93c0f10d29c071f599764d00b8de00cb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:13:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3a2ae3d93c0f10d29c071f599764d00b8de00cb
Gitweb:     http://git.kernel.org/tip/c3a2ae3d93c0f10d29c071f599764d00b8de00cb
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 29 Jul 2009 00:21:23 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 14:26:09 +0200

sched: Add new prio to cpupri before removing old prio

We need to add the new prio to the cpupri accounting before
removing the old prio. This is because removing the old prio
first will open a race window where the cpu will be removed
from pri_active. In this case the cpu will not be visible for
RT push and pulls. This could cause a RT task to not migrate
appropriately, and create a very large latency.

This bug was found with the use of ftrace sched events and
trace_printk.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090729042526.438281019@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_cpupri.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index d014efb..0f052fc 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -127,21 +127,11 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 
 	/*
 	 * If the cpu was currently mapped to a different value, we
-	 * first need to unmap the old value
+	 * need to map it to the new value then remove the old value.
+	 * Note, we must add the new value first, otherwise we risk the
+	 * cpu being cleared from pri_active, and this cpu could be
+	 * missed for a push or pull.
 	 */
-	if (likely(oldpri != CPUPRI_INVALID)) {
-		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
-
-		spin_lock_irqsave(&vec->lock, flags);
-
-		vec->count--;
-		if (!vec->count)
-			clear_bit(oldpri, cp->pri_active);
-		cpumask_clear_cpu(cpu, vec->mask);
-
-		spin_unlock_irqrestore(&vec->lock, flags);
-	}
-
 	if (likely(newpri != CPUPRI_INVALID)) {
 		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
 
@@ -154,6 +144,18 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 
 		spin_unlock_irqrestore(&vec->lock, flags);
 	}
+	if (likely(oldpri != CPUPRI_INVALID)) {
+		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
+
+		spin_lock_irqsave(&vec->lock, flags);
+
+		vec->count--;
+		if (!vec->count)
+			clear_bit(oldpri, cp->pri_active);
+		cpumask_clear_cpu(cpu, vec->mask);
+
+		spin_unlock_irqrestore(&vec->lock, flags);
+	}
 
 	*currpri = newpri;
 }
