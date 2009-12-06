Return-Path: <linux-kernel-owner+w=401wt.eu-S934243AbZLFSEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbZLFSEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934174AbZLFSED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:04:03 -0500
Received: from www.tglx.de ([62.245.132.106]:33232 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934154AbZLFSD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:03:29 -0500
Message-Id: <20091206111957.920379257@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:03:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 16/23] sched: Convert cpupri lock to raw_spinlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline;
	filename=sched-convert-cpupri-lock-to-core-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched_cpupri.c |   10 +++++-----
 kernel/sched_cpupri.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/kernel/sched_cpupri.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_cpupri.c
+++ linux-2.6-tip/kernel/sched_cpupri.c
@@ -135,26 +135,26 @@ void cpupri_set(struct cpupri *cp, int c
 	if (likely(newpri != CPUPRI_INVALID)) {
 		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
 
-		spin_lock_irqsave(&vec->lock, flags);
+		raw_spin_lock_irqsave(&vec->lock, flags);
 
 		cpumask_set_cpu(cpu, vec->mask);
 		vec->count++;
 		if (vec->count == 1)
 			set_bit(newpri, cp->pri_active);
 
-		spin_unlock_irqrestore(&vec->lock, flags);
+		raw_spin_unlock_irqrestore(&vec->lock, flags);
 	}
 	if (likely(oldpri != CPUPRI_INVALID)) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
 
-		spin_lock_irqsave(&vec->lock, flags);
+		raw_spin_lock_irqsave(&vec->lock, flags);
 
 		vec->count--;
 		if (!vec->count)
 			clear_bit(oldpri, cp->pri_active);
 		cpumask_clear_cpu(cpu, vec->mask);
 
-		spin_unlock_irqrestore(&vec->lock, flags);
+		raw_spin_unlock_irqrestore(&vec->lock, flags);
 	}
 
 	*currpri = newpri;
@@ -180,7 +180,7 @@ int cpupri_init(struct cpupri *cp, bool 
 	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
 		struct cpupri_vec *vec = &cp->pri_to_cpu[i];
 
-		spin_lock_init(&vec->lock);
+		raw_spin_lock_init(&vec->lock);
 		vec->count = 0;
 		if (!zalloc_cpumask_var(&vec->mask, gfp))
 			goto cleanup;
Index: linux-2.6-tip/kernel/sched_cpupri.h
===================================================================
--- linux-2.6-tip.orig/kernel/sched_cpupri.h
+++ linux-2.6-tip/kernel/sched_cpupri.h
@@ -12,7 +12,7 @@
 /* values 2-101 are RT priorities 0-99 */
 
 struct cpupri_vec {
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	int        count;
 	cpumask_var_t mask;
 };


