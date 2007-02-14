Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbXBNIaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbXBNIaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbXBNIaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:30:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55771 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbXBNIaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:30:23 -0500
Date: Wed, 14 Feb 2007 09:26:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070214082642.GA17096@elte.hu>
References: <20070213142010.GA638@elte.hu> <Pine.LNX.4.64.0702131900280.32055@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702132041560.32055@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702132041560.32055@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.9 required=5.9 tests=ALL_TRUSTED,BAYES_05 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0279]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > There's another problem AFAICS:
> > 
> > - We woke up one of the cachemiss_loop threads in pick_new_async_thread
> > 
> > - The threads wakes up, mark itself as busy, and look at the ->work 
> >   pointer hoping to find something to work on
> > 
> > But we never set that pointer to a userspace atom AFAICS. Me blind? :)
> 
> I still don't see at->work ever set to a valid userspace atom 
> though...

yeah - i havent added support for 'submit syslet from within a syslet' 
support yet :-)

note that current normal syslet operation (both async and sync alike) 
does not need at->work at all. When we cachemiss then the new head task 
just wants to return a NULL pointer to user-space, to signal that work 
is continuing in the background. A ready 'cachemiss' thread is really 
not there to do cachemisses, it is a 'new head task in the waiting'. The 
name comes from Tux and i guess it's time for a rename :)

but i do plan a SYSLET_ASYNC_CONTINUE flag, roughly along the patch i've 
attached below: this would skip to the linearly next syslet and would 
let the original syslet execute in the. I have not fully thought this 
through though (let alone tested it ;) - can you see any hole in this 
approach? This would in essence allow the following construct:

   syslet1 &
   syslet2 &
   syslet3 &
   syslet4 &

submitted in parallel, straight to cachemiss threads, from a syslet 
itself.

there's yet another work submission variant that makes sense to do, a 
true syslet vector submission: to do a loop over syslet atoms in 
sys_async_exec(). That would have the added advantage of enabling 
caching. If one vector component generates a cachemiss then the head 
would continue with the next vector. (this too needs at->work alike 
communication between ex-head and new-head)

maybe the latter would be the cleaner approach - SYSLET_ASYNC_CONTINUE 
has no effect in cachemiss context, so it only makes sense if the 
submitted syslet is a pure vector of parallel atoms. Alternatively, 
SYSLET_ASYNC_CONTINUE would have to be made work from cachemiss contexts 
too. (because that makes sense too, to start new async execution from 
another async context.)

another not yet clear area is when there's no cachemiss thread 
available. Right now SYSLET_ASYNC_CONTINUE will just fail - which makes 
it nondeterministic.

	Ingo

---
 include/linux/async.h  |   13 +++++++++++--
 include/linux/sched.h  |    3 +--
 include/linux/syslet.h |   20 +++++++++++++-------
 kernel/async.c         |   43 +++++++++++++++++++++++++++++--------------
 kernel/sched.c         |    2 +-
 5 files changed, 56 insertions(+), 27 deletions(-)

 # *DOCUMENTATION*
Index: linux/include/linux/async.h
===================================================================
--- linux.orig/include/linux/async.h
+++ linux/include/linux/async.h
@@ -1,15 +1,23 @@
 #ifndef _LINUX_ASYNC_H
 #define _LINUX_ASYNC_H
+
+#include <linux/compiler.h>
+
 /*
  * The syslet subsystem - asynchronous syscall execution support.
  *
  * Generic kernel API definitions:
  */
 
+struct syslet_uatom;
+struct async_thread;
+struct async_head;
+
 #ifdef CONFIG_ASYNC_SUPPORT
 extern void async_init(struct task_struct *t);
 extern void async_exit(struct task_struct *t);
-extern void __async_schedule(struct task_struct *t);
+extern void
+__async_schedule(struct task_struct *t, struct syslet_uatom __user *next_uatom);
 #else /* !CONFIG_ASYNC_SUPPORT */
 static inline void async_init(struct task_struct *t)
 {
@@ -17,7 +25,8 @@ static inline void async_init(struct tas
 static inline void async_exit(struct task_struct *t)
 {
 }
-static inline void __async_schedule(struct task_struct *t)
+static inline void
+__async_schedule(struct task_struct *t, struct syslet_uatom __user *next_uatom)
 {
 }
 #endif /* !CONFIG_ASYNC_SUPPORT */
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -83,13 +83,12 @@ struct sched_param {
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
 #include <linux/task_io_accounting.h>
+#include <linux/async.h>
 
 #include <asm/processor.h>
 
 struct exec_domain;
 struct futex_pi_state;
-struct async_thread;
-struct async_head;
 /*
  * List of flags we want to share for kernel threads,
  * if only because they are not used by them anyway.
Index: linux/include/linux/syslet.h
===================================================================
--- linux.orig/include/linux/syslet.h
+++ linux/include/linux/syslet.h
@@ -56,10 +56,16 @@ struct syslet_uatom {
 #define SYSLET_ASYNC				0x00000001
 
 /*
+ * Queue this syslet asynchronously and continue executing the
+ * next linear atom:
+ */
+#define SYSLET_ASYNC_CONTINUE			0x00000002
+
+/*
  * Never queue this syslet asynchronously - even if synchronous
  * execution causes a context-switching:
  */
-#define SYSLET_SYNC				0x00000002
+#define SYSLET_SYNC				0x00000004
 
 /*
  * Do not queue the syslet in the completion ring when done.
@@ -70,7 +76,7 @@ struct syslet_uatom {
  * Some syscalls generate implicit completion events of their
  * own.
  */
-#define SYSLET_NO_COMPLETE			0x00000004
+#define SYSLET_NO_COMPLETE			0x00000008
 
 /*
  * Execution control: conditions upon the return code
@@ -78,10 +84,10 @@ struct syslet_uatom {
  * execution is stopped and the atom is put into the
  * completion ring:
  */
-#define SYSLET_STOP_ON_NONZERO			0x00000008
-#define SYSLET_STOP_ON_ZERO			0x00000010
-#define SYSLET_STOP_ON_NEGATIVE			0x00000020
-#define SYSLET_STOP_ON_NON_POSITIVE		0x00000040
+#define SYSLET_STOP_ON_NONZERO			0x00000010
+#define SYSLET_STOP_ON_ZERO			0x00000020
+#define SYSLET_STOP_ON_NEGATIVE			0x00000040
+#define SYSLET_STOP_ON_NON_POSITIVE		0x00000080
 
 #define SYSLET_STOP_MASK				\
 	(	SYSLET_STOP_ON_NONZERO		|	\
@@ -97,7 +103,7 @@ struct syslet_uatom {
  *
  * This is what allows true branches of execution within syslets.
  */
-#define SYSLET_SKIP_TO_NEXT_ON_STOP		0x00000080
+#define SYSLET_SKIP_TO_NEXT_ON_STOP		0x00000100
 
 /*
  * This is the (per-user-context) descriptor of the async completion
Index: linux/kernel/async.c
===================================================================
--- linux.orig/kernel/async.c
+++ linux/kernel/async.c
@@ -75,13 +75,14 @@ mark_async_thread_busy(struct async_thre
 
 static void
 __async_thread_init(struct task_struct *t, struct async_thread *at,
-		    struct async_head *ah)
+		    struct async_head *ah,
+		    struct syslet_uatom __user *work)
 {
 	INIT_LIST_HEAD(&at->entry);
 	at->exit = 0;
 	at->task = t;
 	at->ah = ah;
-	at->work = NULL;
+	at->work = work;
 
 	t->at = at;
 	ah->nr_threads++;
@@ -92,7 +93,7 @@ async_thread_init(struct task_struct *t,
 		  struct async_head *ah)
 {
 	spin_lock(&ah->lock);
-	__async_thread_init(t, at, ah);
+	__async_thread_init(t, at, ah, NULL);
 	__mark_async_thread_ready(at, ah);
 	spin_unlock(&ah->lock);
 }
@@ -130,8 +131,10 @@ pick_ready_cachemiss_thread(struct async
 	return at;
 }
 
-static void pick_new_async_head(struct async_head *ah,
-				struct task_struct *t, struct pt_regs *old_regs)
+static void
+pick_new_async_head(struct async_head *ah, struct task_struct *t,
+		    struct pt_regs *old_regs,
+		    struct syslet_uatom __user *next_uatom)
 {
 	struct async_thread *new_async_thread;
 	struct async_thread *async_ready;
@@ -158,28 +161,31 @@ static void pick_new_async_head(struct a
 
 	wake_up_process(new_task);
 
-	__async_thread_init(t, async_ready, ah);
+	__async_thread_init(t, async_ready, ah, next_uatom);
 	__mark_async_thread_busy(t->at, ah);
 
  out_unlock:
 	spin_unlock(&ah->lock);
 }
 
-void __async_schedule(struct task_struct *t)
+void
+__async_schedule(struct task_struct *t, struct syslet_uatom __user *next_uatom)
 {
 	struct async_head *ah = t->ah;
 	struct pt_regs *old_regs = task_pt_regs(t);
 
-	pick_new_async_head(ah, t, old_regs);
+	pick_new_async_head(ah, t, old_regs, next_uatom);
 }
 
-static void async_schedule(struct task_struct *t)
+static void
+async_schedule(struct task_struct *t, struct syslet_uatom __user *next_uatom)
 {
 	if (t->async_ready)
-		__async_schedule(t);
+		__async_schedule(t, next_uatom);
 }
 
-static long __exec_atom(struct task_struct *t, struct syslet_atom *atom)
+static long __exec_atom(struct task_struct *t, struct syslet_atom *atom,
+			struct syslet_uatom __user *uatom)
 {
 	struct async_thread *async_ready_save;
 	long ret;
@@ -189,8 +195,17 @@ static long __exec_atom(struct task_stru
 	 * (try to) switch user-space to another thread straight
 	 * away and execute the syscall asynchronously:
 	 */
-	if (unlikely(atom->flags & SYSLET_ASYNC))
-		async_schedule(t);
+	if (unlikely(atom->flags & (SYSLET_ASYNC | SYSLET_ASYNC_CONTINUE))) {
+		/*
+		 * If this is a parallel (vectored) submission straight to
+		 * a cachemiss context then the linearly next (uatom + 1)
+		 * uatom will be executed by this context.
+		 */
+		if (atom->flags & SYSLET_ASYNC_CONTINUE)
+			async_schedule(t, uatom + 1);
+		else
+			async_schedule(t, NULL);
+	}
 	/*
 	 * Does user-space want synchronous execution for this atom?:
 	 */
@@ -432,7 +447,7 @@ exec_atom(struct async_head *ah, struct 
 		return ERR_PTR(-EFAULT);
 
 	last_uatom = uatom;
-	ret = __exec_atom(t, &atom);
+	ret = __exec_atom(t, &atom, uatom);
 	if (unlikely(signal_pending(t) || need_resched()))
 		goto stop;
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3442,7 +3442,7 @@ asmlinkage void __sched schedule(void)
 		if (prev->state && !(preempt_count() & PREEMPT_ACTIVE) &&
 			(!(prev->state & TASK_INTERRUPTIBLE) ||
 				!signal_pending(prev)))
-			__async_schedule(prev);
+			__async_schedule(prev, NULL);
 	}
 
 need_resched:

