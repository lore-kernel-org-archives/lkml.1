Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbZKSEsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbZKSEsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 23:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbZKSEse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 23:48:34 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:37787 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbZKSEsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 23:48:32 -0500
Subject: Re: [PATCH] cleanup sched_yield (sys)call nesting.
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Jean Delvare <khali@linux-fr.org>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0911182233510.24119@localhost.localdomain>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com>
	 <20091107210147.3e754278@hyperion.delvare>
	 <4AF7148C.9090706@thebigcorporation.com>
	 <20091112211255.09cd884a@hyperion.delvare>
	 <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
	 <20091116155606.GC29479@sirena.org.uk>
	 <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com>
	 <20091118010520.4cd397d4@lxorguk.ukuu.org.uk>
	 <c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com>
	 <20091118175202.490989d8@hyperion.delvare>
	 <1258577194.12429.86.camel@sven.thebigcorporation.com>
	 <alpine.LFD.2.00.0911182153010.24119@localhost.localdomain>
	 <1258578290.12429.108.camel@sven.thebigcorporation.com>
	 <alpine.LFD.2.00.0911182233510.24119@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 20:48:35 -0800
Message-Id: <1258606116.25022.57.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 22:34 +0100, Thomas Gleixner wrote:
> On Wed, 18 Nov 2009, Sven-Thorsten Dietrich wrote:
> 
> > On Wed, 2009-11-18 at 21:56 +0100, Thomas Gleixner wrote:
> > > On Wed, 18 Nov 2009, Sven-Thorsten Dietrich wrote:
> > > > On Wed, 2009-11-18 at 17:52 +0100, Jean Delvare wrote:
> > > > > On Wed, 18 Nov 2009 17:28:53 +0100, Leon Woestenberg wrote:
> > > > > > On Wed, Nov 18, 2009 at 2:05 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > > > > > Our timers are very efficient and some day we will need to make jiffies a
> > > > > > > function and stop the timer ticking for best performance. At that point
> > > > > > > timers are probably the most efficient way to do much of this.
> > > > > >
> > > > > > The problem with I2C bitbanged is the stringent timing, we need a way
> > > > > > to have fine-grained sleeping
> > > > > > mixed with real-time tasks in order to make this work.
> > > > > 
> > > > > FWIW, the problem that was initially reported has nothing to do with
> > > > > this. i2c-algo-bit used mdelay() during transactions, not yield().
> > > > > yield() is used only in once place, _between_ transactions attempts.
> > > > > There are no strict timing constraints there.
> > > > > 
> > > > 
> > > > I agree that dropping out sched_yield entirely should maybe start by
> > > > deprecating / flagging as a warning in sched_rt.c.
> > > 
> > > Errm, that's unrelated to sched_rt.c. 
> > > 
> > > yield() in the kernel in general is needs to be deprecated.
> > >  
> > > > This is just a minimal cleanup I stumbled across while looking at it -
> > > > to get away from the uglyness of calling into the syscall interface from
> > > > inside the Kernel.
> > > 
> > > And why exactly is that ugly ?
> > 
> > Calling from a function returning void into a non-void function and then
> > ignoring the return code ?
>  
> Care to read what I wrote further down ?
> 
> >> Which is completely irrelevant because the return code is always 0. 
> 


We are trying to get rid of __sched_yield calls from-inside-the-Kernel,
but sys_sched_yield() from user-space will remain.

This patch breaks out the in-Kernel interface for the yield()
functionality and deprecates it explicitly.

The sys_sched_yield() variety, however is not deprecated.

The objective is to deprecate *only* the in-kernel calls to
sched_yield(), in hopes of reducing new calls to sched_yield() being
added.

Eventually, when the in-Kernel calls are gone, the __sched_yield() would
be removed, and the first 2 hunks would essentially be reverted, leaving
only the user-space caller sys_sched_yield. 

For the time being we add 2 lines and 2 braces of bulk, in hopes that
elsewhere this eliminates more __sched_yield() calls being added while
we work to eliminate the ones that exist already.

In regards to the return code, maybe we can talk about returning an
error when an RT task calls sys_sched_yield(). But that is another
topic.

Thanks,

Sven



Subject: Deprecate in-Kernel use of __sched_yield()
From: Sven-Thorsten Dietrich <sdietrich@suse.de>

Break out the syscall interface from the deprecated in-kernel
sched_yield() interface that is to be removed.

Acked-by: Sven-Thorsten Dietrich <sdietrich@suse.de>

---
 kernel/sched.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.31-openSUSE-11.2/kernel/sched.c
===================================================================
--- linux-2.6.31-openSUSE-11.2.orig/kernel/sched.c
+++ linux-2.6.31-openSUSE-11.2/kernel/sched.c
@@ -6566,12 +6566,12 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t
 }
 
 /**
- * sys_sched_yield - yield the current processor to other threads.
+ * do_sched_yield - yield the current processor to other threads.
  *
  * This function yields the current CPU to other tasks. If there are no
  * other threads running on this CPU then this function will return.
  */
-SYSCALL_DEFINE0(sched_yield)
+static inline void do_sched_yield(void) 
 {
 	struct rq *rq = this_rq_lock();
 
@@ -6588,7 +6588,11 @@ SYSCALL_DEFINE0(sched_yield)
 	preempt_enable_no_resched();
 
 	schedule();
+}
 
+SYSCALL_DEFINE0(sched_yield)
+{
+	do_sched_yield();
 	return 0;
 }
 
@@ -6670,10 +6674,10 @@ EXPORT_SYMBOL(cond_resched_softirq);
  * This is a shortcut for kernel-space yielding - it marks the
  * thread runnable and calls sys_sched_yield().
  */
-void __sched yield(void)
+void __sched __deprecated yield(void)
 {
 	set_current_state(TASK_RUNNING);
-	sys_sched_yield();
+	do_sched_yield();
 }
 EXPORT_SYMBOL(yield);
 


