Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbZKRUqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbZKRUqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758271AbZKRUqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:46:39 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61365 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbZKRUqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:46:38 -0500
Subject: [PATCH] cleanup sched_yield (sys)call nesting.
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-i2c@vger.kernel.org,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091118175202.490989d8@hyperion.delvare>
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
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 12:46:34 -0800
Message-Id: <1258577194.12429.86.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 17:52 +0100, Jean Delvare wrote:
> On Wed, 18 Nov 2009 17:28:53 +0100, Leon Woestenberg wrote:
> > On Wed, Nov 18, 2009 at 2:05 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > Our timers are very efficient and some day we will need to make jiffies a
> > > function and stop the timer ticking for best performance. At that point
> > > timers are probably the most efficient way to do much of this.
> >
> > The problem with I2C bitbanged is the stringent timing, we need a way
> > to have fine-grained sleeping
> > mixed with real-time tasks in order to make this work.
> 
> FWIW, the problem that was initially reported has nothing to do with
> this. i2c-algo-bit used mdelay() during transactions, not yield().
> yield() is used only in once place, _between_ transactions attempts.
> There are no strict timing constraints there.
> 

I agree that dropping out sched_yield entirely should maybe start by
deprecating / flagging as a warning in sched_rt.c.

This is just a minimal cleanup I stumbled across while looking at it -
to get away from the uglyness of calling into the syscall interface from
inside the Kernel.

I'll generate something more substantial for discussion later.

Subject: clean up chaining in sched_yield()
From: Sven-Thorsten Dietrich <sdietrich@suse.de>

The call to sys_sched_yield for in-Kernel is messy.
and the return code from sys_sched_yield is ignored when called from
in-kernel.

Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>

diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..db2c0f9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6647,12 +6647,12 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
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
 
@@ -6669,6 +6669,11 @@ SYSCALL_DEFINE0(sched_yield)
 	preempt_enable_no_resched();
 
 	schedule();
+}
+
+SYSCALL_DEFINE0(sched_yield)
+{
+	do_sched_yield();
 
 	return 0;
 }
@@ -6746,7 +6751,7 @@ EXPORT_SYMBOL(__cond_resched_softirq);
 void __sched yield(void)
 {
 	set_current_state(TASK_RUNNING);
-	sys_sched_yield();
+	do_sched_yield();
 }
 EXPORT_SYMBOL(yield);
 


