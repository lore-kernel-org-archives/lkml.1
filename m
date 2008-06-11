Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbYFKGyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbYFKGyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 02:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYFKGxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 02:53:54 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:14939 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbYFKGxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:53:53 -0400
X-SourceIP: 80.56.237.116
Subject: Re: [PATCH -rt 6/5] cpu-hotplug: cpu_down vs preempt-rt
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20080610111832.969119014@chello.nl>
References: <20080610111259.766940257@chello.nl>
	 <20080610111832.969119014@chello.nl>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 08:53:45 +0200
Message-Id: <1213167225.31518.64.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because 5/5 has a horrible bug...

We should only do __mmdrop() from rcu, not mmdrop().

---
Index: linux-2.6.24.7.noarch/include/linux/sched.h
===================================================================
--- linux-2.6.24.7.noarch.orig/include/linux/sched.h
+++ linux-2.6.24.7.noarch/include/linux/sched.h
@@ -1832,6 +1832,7 @@ extern struct mm_struct * mm_alloc(void)
 /* mmdrop drops the mm and the page tables */
 extern void FASTCALL(__mmdrop(struct mm_struct *));
 extern void FASTCALL(__mmdrop_delayed(struct mm_struct *));
+extern void FASTCALL(__mmdrop_rcu(struct mm_struct *));
 
 static inline void mmdrop(struct mm_struct * mm)
 {
@@ -1845,6 +1846,12 @@ static inline void mmdrop_delayed(struct
 		__mmdrop_delayed(mm);
 }
 
+static inline void mmdrop_rcu(struct mm_struct * mm)
+{
+	if (atomic_dec_and_test(&mm->mm_count))
+		__mmdrop_rcu(mm);
+}
+
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
 /* Grab a reference to a task's mm, if it is not already going away */
Index: linux-2.6.24.7.noarch/kernel/fork.c
===================================================================
--- linux-2.6.24.7.noarch.orig/kernel/fork.c
+++ linux-2.6.24.7.noarch/kernel/fork.c
@@ -431,6 +431,18 @@ void fastcall __mmdrop(struct mm_struct 
 	free_mm(mm);
 }
 
+#ifdef CONFIG_PREEMPT_RT
+static void ___mmdrop_rcu(struct rcu_head *head)
+{
+	__mmdrop(container_of(head, struct mm_struct, rcu_head));
+}
+
+void fastcall __mmdrop_rcu(struct mm_struct *mm)
+{
+	call_rcu_preempt_online(&mm->rcu_head, ___mmdrop_rcu);
+}
+#endif
+
 /*
  * Decrement the use count and release all resources for an mm.
  */
Index: linux-2.6.24.7.noarch/kernel/sched.c
===================================================================
--- linux-2.6.24.7.noarch.orig/kernel/sched.c
+++ linux-2.6.24.7.noarch/kernel/sched.c
@@ -5888,15 +5888,6 @@ void sched_idle_next(void)
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-#ifdef CONFIG_PREEMPT_RT
-void mmdrop_rcu(struct rcu_head *head)
-{
-	struct mm_struct *mm = container_of(head, struct mm_struct, rcu_head);
-
-	mmdrop(mm);
-}
-#endif
-
 /*
  * Ensures that the idle task is using init_mm right before its cpu goes
  * offline.
@@ -5910,7 +5901,7 @@ void idle_task_exit(void)
 	if (mm != &init_mm)
 		switch_mm(mm, &init_mm, current);
 #ifdef CONFIG_PREEMPT_RT
-	call_rcu_preempt_online(&mm->rcu_head, mmdrop_rcu);
+	mmdrop_rcu(mm);
 #else
 	mmdrop(mm);
 #endif


