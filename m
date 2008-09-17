Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYIQTES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYIQTES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYIQTED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:04:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYIQTEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:04:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=O+qncQZGrRTGT96XT76b3cFmYjghJqrRzfagffncC7m3mndp69Be76xTs8lRecDcB
	0FyPsTgbjfSgcL48/hpEA==
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20080916084143.GC17287@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	 <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu>
	 <1221502142.19012.35.camel@bobble.smo.corp.google.com>
	 <20080916084143.GC17287@elte.hu>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 17 Sep 2008 12:03:07 -0700
Message-Id: <1221678187.13420.17.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-16 at 10:41 +0200, Ingo Molnar wrote:
> * Frank Mayhar <fmayhar@google.com> wrote:
> 
> > > the wider question is, shouldnt the UP case be just the same as the 
> > > SMP case? Especially the type assymetry struct thread_group_cputime 
> > > looks ugly. (and assymetries like that tend to be a constant source 
> > > of breakage like the one below.)
> > 
> > I'm not overly fond of this one, either; I did it at Roland's 
> > suggestion (it's all _his_ fault, yeah, _that's_ the ticket! :-); his 
> > opinion IIRC was that the UP case will perform better without the 
> > extra pointer dereferences.  I agree that it's a potential source of 
> > pain such as the one you point out.
> 
> i dont know ... 
> 
> lets try that simplification as a delta patch, ok? Please check the 
> before/after size of 'vmlinux' in a 'make defconfig' [with SMP disabled 
> after make defconfig] UP build. If there's visible size difference then 
> Roland's point holds.

I finally finished this.  Yeah, there's a visible size difference,
although it's small:

bobble ~/build/linux-2.6>size vmlinux
   text    data     bss     dec     hex filename
6417840  824160  578416 7820416  775480 vmlinux

bobble ~/build/up-simplify-tree>size vmlinux
   text    data     bss     dec     hex filename
6417999  824160  578416 7820575  77551f vmlinux

For a difference of 159 bytes.  Not big, but nonzero.  The delta patch
(relative to a tree containing all suggested changes _except_ this
simplification) follows:

--- ../linux-2.6/include/linux/sched.h	2008-09-16 14:39:26.000000000 -0700
+++ ./include/linux/sched.h	2008-09-17 10:28:33.000000000 -0700
@@ -454,15 +454,9 @@ struct task_cputime {
  * This structure contains the version of task_cputime, above, that is
  * used for thread group CPU clock calculations.
  */
-#ifdef CONFIG_SMP
 struct thread_group_cputime {
 	struct task_cputime *totals;
 };
-#else
-struct thread_group_cputime {
-	struct task_cputime totals;
-};
-#endif
 
 /*
  * NOTE! "signal_struct" does not have it's own
@@ -2124,10 +2118,8 @@ static inline int spin_needbreak(spinloc
 /*
  * Thread group CPU time accounting.
  */
-#ifdef CONFIG_SMP
 
-extern int thread_group_cputime_alloc_smp(struct task_struct *);
-extern void thread_group_cputime_smp(struct task_struct *, struct task_cputime *);
+extern int thread_group_cputime_alloc(struct task_struct *);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
@@ -2138,9 +2130,13 @@ static inline int thread_group_cputime_c
 {
 	if (curr->signal->cputime.totals)
 		return 0;
-	return thread_group_cputime_alloc_smp(curr);
+	return thread_group_cputime_alloc(curr);
 }
 
+#ifdef CONFIG_SMP
+
+extern void thread_group_cputime_smp(struct task_struct *, struct task_cputime *);
+
 static inline void thread_group_cputime_free(struct signal_struct *sig)
 {
 	free_percpu(sig->cputime.totals);
@@ -2161,31 +2157,15 @@ static inline void thread_group_cputime(
 
 #else /* CONFIG_SMP */
 
-static inline void thread_group_cputime_init(struct signal_struct *sig)
-{
-	sig->cputime.totals.utime = cputime_zero;
-	sig->cputime.totals.stime = cputime_zero;
-	sig->cputime.totals.sum_exec_runtime = 0;
-}
-
-static inline int thread_group_cputime_alloc(struct task_struct *tsk)
-{
-	return 0;
-}
-
 static inline void thread_group_cputime_free(struct signal_struct *sig)
 {
-}
-
-static inline int thread_group_cputime_clone_thread(struct task_struct *curr)
-{
-	return 0;
+	kfree(sig->cputime.totals);
 }
 
 static inline void thread_group_cputime(struct task_struct *tsk,
 					 struct task_cputime *cputime)
 {
-	*cputime = tsk->signal->cputime.totals;
+	*cputime = *(tsk->signal->cputime.totals);
 }
 
 #endif /* CONFIG_SMP */
--- ../linux-2.6/kernel/posix-cpu-timers.c	2008-09-17 11:18:56.000000000 -0700
+++ ./kernel/posix-cpu-timers.c	2008-09-17 11:19:20.000000000 -0700
@@ -16,7 +16,7 @@
  * via thread_group_cputime_clone_thread() when adding a second or subsequent
  * thread to a thread group.  Assumes interrupts are enabled when called.
  */
-int thread_group_cputime_alloc_smp(struct task_struct *tsk)
+int thread_group_cputime_alloc(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
 	struct task_cputime *cputime;
@@ -80,6 +80,40 @@ void thread_group_cputime_smp(
 	}
 }
 
+#else /* CONFIG_SMP */
+
+/*
+ * Allocate the thread_group_cputime structure appropriately for UP kernels
+ * and fill in the current values of the fields.  Called from copy_signal()
+ * via thread_group_cputime_clone_thread() when adding a second or subsequent
+ * thread to a thread group.  Assumes interrupts are enabled when called.
+ */
+int thread_group_cputime_alloc(struct task_struct *tsk)
+{
+	struct signal_struct *sig = tsk->signal;
+	struct task_cputime *cputime;
+
+	/*
+	 * If we have multiple threads and we don't already have a
+	 * per-CPU task_cputime struct (checked in the caller), allocate
+	 * one and fill it in with the times accumulated so far.  We're
+	 * UP but we may have slept in kmalloc so doublecheck to see if
+	 * another thread got in before us.
+	 */
+	cputime = kmalloc(sizeof(struct task_cputime), GFP_KERNEL);
+	if (cputime == NULL)
+		return -ENOMEM;
+	if (sig->cputime.totals) {
+		kfree(cputime);
+		return 0;
+	}
+	sig->cputime.totals = cputime;
+	cputime->utime = tsk->utime;
+	cputime->stime = tsk->stime;
+	cputime->sum_exec_runtime = tsk->se.sum_exec_runtime;
+	return 0;
+}
+
 #endif /* CONFIG_SMP */
 
 /*
--- ../linux-2.6/kernel/sched_stats.h	2008-09-17 10:30:06.000000000 -0700
+++ ./kernel/sched_stats.h	2008-09-17 10:31:31.000000000 -0700
@@ -354,21 +354,21 @@ static inline void thread_group_cputime_
 	struct thread_group_cputime *tgtimes,
 	cputime_t cputime)
 {
-	tgtimes->totals.utime = cputime_add(tgtimes->totals.utime, cputime);
+	tgtimes->totals->utime = cputime_add(tgtimes->totals->utime, cputime);
 }
 
 static inline void thread_group_cputime_account_system(
 	struct thread_group_cputime *tgtimes,
 	cputime_t cputime)
 {
-	tgtimes->totals.stime = cputime_add(tgtimes->totals.stime, cputime);
+	tgtimes->totals->stime = cputime_add(tgtimes->totals->stime, cputime);
 }
 
 static inline void thread_group_cputime_account_exec_runtime(
 	struct thread_group_cputime *tgtimes,
 	unsigned long long ns)
 {
-	tgtimes->totals.sum_exec_runtime += ns;
+	tgtimes->totals->sum_exec_runtime += ns;
 }
 
 #endif /* CONFIG_SMP */

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

