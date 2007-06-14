Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbXFNX2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbXFNX2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbXFNX22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:28:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53386 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbXFNX21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:28:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel internal errnos
Date: Fri, 15 Jun 2007 01:35:14 +0200
User-Agent: KMail/1.9.5
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <87hcplvdkl.wl%takeuchi_satoru@jp.fujitsu.com> <200706141426.45522.rjw@sisk.pl> <20070614125843.GA78@tv-sign.ru>
In-Reply-To: <20070614125843.GA78@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150135.15364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 June 2007 14:58, Oleg Nesterov wrote:
> On 06/14, Rafael J. Wysocki wrote:
> >
> > Sorry for being late, I've just realized that you are discussing the freezer
> > here. ;-)
> 
> my fault, I was going to cc you but forgot, sorry!

No problem. :-)

> > On Wednesday, 13 June 2007 17:15, Oleg Nesterov wrote:
> >
> > > > @@ -105,7 +105,11 @@ static int recalc_sigpending_tsk(struct 
> > > >  		set_tsk_thread_flag(t, TIF_SIGPENDING);
> > > >  		return 1;
> > > >  	}
> > > > -	clear_tsk_thread_flag(t, TIF_SIGPENDING);
> > > > +	/*
> > > > +	 * We must never clear the flag in another thread, or in current
> > > > +	 * when it's possible the current syscall is returning -ERESTART*.
> > > > +	 * So we don't clear it here, and only callers who know they should do.
> > > > +	 */
> > > >  	return 0;
> > > >  }
> > > 
> > > This breaks cancel_freezing(). Somehow we should clear TIF_SIGPENDING for
> > > kernel threads. Otherwise we may have subtle failures if try_to_freeze_tasks()
> > > fails.
> > 
> > Well, the only code path in which we'd want to call cancel_freezing() for kernel
> > threads is when the freezing of kernel threads.  However, this only happens if
> > one of the kernel threads declares itself as freezable and the fails to call
> > try_to_freeze(), which is a bug.
> 
> But this happens? We know a lot of reasons why try_to_freeze() can fail just
> because some kthread waits for already frozen task.
> 
> >                                   Thus I don't think that we need to worry
> > about that case too much.
> 
> Well, we can have very subtle problems because a kernel thread may run with
> TIF_SIGPENDING forever. This means in particualar that any wait_event_interruptible()
> can't succeed. I think this is worse than explicit failure (like -ERESSTART... leak),
> because it is hard to reproduce/debug.
> 
> > Moreover, I'm not sure that it's a good idea at all to send signals to kernel
> > threads from the freezer, since in fact we only need to wake them up to make
> > them call try_to_freeze() (after we've set TIF_FREEZE for them).
> 
> Yes! I completely agree.

Hmm, what about the appended patch, then?

I've tested it a bit on a UP system.

Greetings,
Rafael


---
 include/linux/freezer.h |    9 -----
 include/linux/sched.h   |   12 +++++++
 include/linux/wait.h    |    6 +--
 kernel/power/process.c  |   76 ++++++++++++++++++++++++++++++++++--------------
 4 files changed, 70 insertions(+), 33 deletions(-)

Index: linux-2.6.22-rc4-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/kernel/power/process.c	2007-06-15 01:05:33.000000000 +0200
+++ linux-2.6.22-rc4-mm2/kernel/power/process.c	2007-06-15 01:33:52.000000000 +0200
@@ -75,19 +75,67 @@ void refrigerator(void)
 	__set_current_state(save);
 }
 
-static void freeze_task(struct task_struct *p)
+static void send_fake_signal(struct task_struct *p)
 {
 	unsigned long flags;
 
+	if (p->state == TASK_STOPPED)
+		force_sig_specific(SIGSTOP, p);
+	spin_lock_irqsave(&p->sighand->siglock, flags);
+	signal_wake_up(p, p->state == TASK_STOPPED);
+	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+}
+
+/**
+ *	freeze_user_process - freeze user space process @p.
+ *
+ *	Kernel threads should not have TIF_FREEZE set at this point, so we must
+ *	ensure that either p->mm is not NULL *and* PF_BORROWED_MM is unset, or
+ *	TIF_FRREZE is left unset.  The task_lock() is necessary to prevent races
+ *	with exit_mm() or use_mm()/unuse_mm() from occuring.
+ */
+static int freeze_user_process(struct task_struct *p)
+{
+	int ret = 1;
+
+	task_lock(p);
+	if (!p->mm || (p->flags & PF_BORROWED_MM)) {
+		ret = 0;
+	} else if (!freezing(p)) {
+		rmb();
+		if (!frozen(p)) {
+			set_freeze_flag(p);
+			task_unlock(p);
+			send_fake_signal(p);
+			return ret;
+		}
+	}
+	task_unlock(p);
+	return ret;
+}
+
+/**
+ *	freeze_task - freeze taks @p, regardless of whether or not it is a
+ *		      user space process.
+ *
+ *	The task_lock() is necessary to prevent races with use_mm()/unuse_mm()
+ *	from occuring.
+ */
+static void freeze_task(struct task_struct *p)
+{
 	if (!freezing(p)) {
 		rmb();
 		if (!frozen(p)) {
 			set_freeze_flag(p);
-			if (p->state == TASK_STOPPED)
-				force_sig_specific(SIGSTOP, p);
-			spin_lock_irqsave(&p->sighand->siglock, flags);
-			signal_wake_up(p, p->state == TASK_STOPPED);
-			spin_unlock_irqrestore(&p->sighand->siglock, flags);
+			task_lock(p);
+			/* We don't want to send signals to kernel threads */
+			if (p->mm && !(p->flags & PF_BORROWED_MM)) {
+				task_unlock(p);
+				send_fake_signal(p);
+			} else {
+				task_unlock(p);
+				wake_up_state(p, TASK_INTERRUPTIBLE);
+			}
 		}
 	}
 }
@@ -125,22 +173,8 @@ static int try_to_freeze_tasks(int freez
 					cancel_freezing(p);
 					continue;
 				}
-				/*
-				 * Kernel threads should not have TIF_FREEZE set
-				 * at this point, so we must ensure that either
-				 * p->mm is not NULL *and* PF_BORROWED_MM is
-				 * unset, or TIF_FRREZE is left unset.
-				 * The task_lock() is necessary to prevent races
-				 * with exit_mm() or use_mm()/unuse_mm() from
-				 * occuring.
-				 */
-				task_lock(p);
-				if (!p->mm || (p->flags & PF_BORROWED_MM)) {
-					task_unlock(p);
+				if (!freeze_user_process(p))
 					continue;
-				}
-				freeze_task(p);
-				task_unlock(p);
 			} else {
 				freeze_task(p);
 			}
Index: linux-2.6.22-rc4-mm2/include/linux/sched.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/sched.h	2007-06-15 01:05:33.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/linux/sched.h	2007-06-15 01:05:41.000000000 +0200
@@ -1797,6 +1797,18 @@ static inline void inc_syscw(struct task
 }
 #endif
 
+#ifdef CONFIG_PM
+static inline int freezing(struct task_struct *p)
+{
+	return unlikely(test_tsk_thread_flag(p, TIF_FREEZE));
+}
+#else
+static inline int freezing(struct task_struct *p)
+{
+	return 0;
+}
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-2.6.22-rc4-mm2/include/linux/freezer.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/freezer.h	2007-06-15 01:05:33.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/linux/freezer.h	2007-06-15 01:05:41.000000000 +0200
@@ -15,14 +15,6 @@ static inline int frozen(struct task_str
 }
 
 /*
- * Check if there is a request to freeze a process
- */
-static inline int freezing(struct task_struct *p)
-{
-	return test_tsk_thread_flag(p, TIF_FREEZE);
-}
-
-/*
  * Request that a process be frozen
  */
 static inline void set_freeze_flag(struct task_struct *p)
@@ -128,7 +120,6 @@ static inline void set_freezable(void)
 
 #else
 static inline int frozen(struct task_struct *p) { return 0; }
-static inline int freezing(struct task_struct *p) { return 0; }
 static inline void set_freeze_flag(struct task_struct *p) {}
 static inline void clear_freeze_flag(struct task_struct *p) {}
 static inline int thaw_process(struct task_struct *p) { return 1; }
Index: linux-2.6.22-rc4-mm2/include/linux/wait.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/wait.h	2007-06-15 01:05:33.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/linux/wait.h	2007-06-15 01:05:41.000000000 +0200
@@ -240,7 +240,7 @@ do {									\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
 		if (condition)						\
 			break;						\
-		if (!signal_pending(current)) {				\
+		if (!signal_pending(current) && !freezing(current)) {	\
 			schedule();					\
 			continue;					\
 		}							\
@@ -281,7 +281,7 @@ do {									\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
 		if (condition)						\
 			break;						\
-		if (!signal_pending(current)) {				\
+		if (!signal_pending(current) && !freezing(current)) {				\
 			ret = schedule_timeout(ret);			\
 			if (!ret)					\
 				break;					\
@@ -327,7 +327,7 @@ do {									\
 					TASK_INTERRUPTIBLE);		\
 		if (condition)						\
 			break;						\
-		if (!signal_pending(current)) {				\
+		if (!signal_pending(current) && !freezing(current)) {				\
 			schedule();					\
 			continue;					\
 		}							\
