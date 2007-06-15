Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbXFOVlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbXFOVlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbXFOVlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:41:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXFOVln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:41:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel internal errnos
Date: Fri, 15 Jun 2007 23:48:11 +0200
User-Agent: KMail/1.9.5
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <87hcplvdkl.wl%takeuchi_satoru@jp.fujitsu.com> <200706150135.15364.rjw@sisk.pl> <20070615113127.GB84@tv-sign.ru>
In-Reply-To: <20070615113127.GB84@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706152348.12019.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 15 June 2007 13:31, Oleg Nesterov wrote:
> On 06/15, Rafael J. Wysocki wrote:
> >
> > +static void freeze_task(struct task_struct *p)
> > +{
> >  	if (!freezing(p)) {
> >  		rmb();
> >  		if (!frozen(p)) {
> >  			set_freeze_flag(p);
> > -			if (p->state == TASK_STOPPED)
> > -				force_sig_specific(SIGSTOP, p);
> > -			spin_lock_irqsave(&p->sighand->siglock, flags);
> > -			signal_wake_up(p, p->state == TASK_STOPPED);
> > -			spin_unlock_irqrestore(&p->sighand->siglock, flags);
> > +			task_lock(p);
> > +			/* We don't want to send signals to kernel threads */
> > +			if (p->mm && !(p->flags & PF_BORROWED_MM)) {
> > +				task_unlock(p);
> > +				send_fake_signal(p);
> > +			} else {
> > +				task_unlock(p);
> > +				wake_up_state(p, TASK_INTERRUPTIBLE);
> > +			}
> 
> I don't think this is enough. Note that recalc_sigpending() checks freezing().
> So a kernel thread still can get TIF_SIGPENDING if it does recalc_sigpending().

Yes, you're right, I have overlooked that.

Still, this can be prevented by changing recalc_sigpending_tsk() in the following way:

--- linux-2.6.22-rc4.orig/kernel/signal.c	2007-06-07 00:01:48.000000000 +0200
+++ linux-2.6.22-rc4/kernel/signal.c	2007-06-15 21:22:00.000000000 +0200
@@ -99,13 +99,13 @@ static inline int has_pending_signals(si
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
 	if (t->signal->group_stop_count > 0 ||
-	    (freezing(t)) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
 		return 1;
 	}
-	clear_tsk_thread_flag(t, TIF_SIGPENDING);
+	if (!freezing(t))
+		clear_tsk_thread_flag(t, TIF_SIGPENDING);
 	return 0;
 }
 
> > --- linux-2.6.22-rc4-mm2.orig/include/linux/wait.h	2007-06-15 01:05:33.000000000 +0200
> > +++ linux-2.6.22-rc4-mm2/include/linux/wait.h	2007-06-15 01:05:41.000000000 +0200
> > @@ -240,7 +240,7 @@ do {									\
> >  		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
> >  		if (condition)						\
> >  			break;						\
> > -		if (!signal_pending(current)) {				\
> > +		if (!signal_pending(current) && !freezing(current)) {	\
> >  			schedule();					\
> >  			continue;					\
> >  		}							\
> 
> Personally, I think we should not modify wait_event_interruptible() and friends.
> If a kernel thread wants to be frozen, it should take care about freezing()
> itself.

Yes, I agree, but wanted to get a working patch quickly. ;-)

I think we might define freezer-friendly versions of wait_event_interruptible()
and friends in <linux/freezer.h>, like this:

+#define wait_event_interruptible_ff(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition) && !freezing(current))				\
+		__wait_event_interruptible(wq, 				\
+				(condition) || freezing(current),	\
+				__ret);					\
+	if (!(condition) && freezing(current))				\
+		__ret = -ERESTARTSYS;					\
+	__ret;								\
+})

and make the freezable kernel threads use them instead of the ones defined
in <linux/wait.h>.  There are only a few threads that need that, BTW.
 
> OK, I guess I was too paranoid and you were right, it is better to ignore this
> minor problem for now.

Okay, but I still think we shouldn't send fake signals to kernel threads. :-)

I'd like to revisit it after 2.6.22 is out, if you don't mind.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
