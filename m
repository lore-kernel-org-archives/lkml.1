Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbYAaO1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbYAaO1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbYAaO1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:27:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYAaO1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:27:42 -0500
Subject: [PATCH] hrtimer: fix hrtimer_init_sleeper() users
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Guillaume Chazarain <guichaz@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200801310042.07910.rjw@sisk.pl>
References: <200801302338.25365.rjw@sisk.pl>
	 <200801310042.07910.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 15:27:24 +0100
Message-Id: <1201789644.32654.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 00:42 +0100, Rafael J. Wysocki wrote:
> Update.
> 
> On Wednesday, 30 of January 2008, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > Recently I've been observing problems with unmounting the /home fs on reboot
> > and/or shutdown on two test boxes.
> > 
> > After some more investigation I've found that this is due to some KDE processes
> > stuck in D states after their owner has logged out.
> > 
> > This happens 100% of the time if there's a suspend/resume cycle before the user
> > logs out (ie. the user logs into KDE, works for some time, suspends the box to
> > RAM and resmes one or more times and then logs out).  Still, I also observe the
> > symptoms on a box that's never suspended.
> > 
> > I'm not sure how to debug this, so please advise.
> 
> After reverting:
> 
> commit 37bb6cb4097e29ffee970065b74499cbf10603a3
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Jan 25 21:08:32 2008 +0100
> 
>     hrtimer: unlock hrtimer_wakeup
> 
> I no longer get processes in the D state, but there still is a problem with
> artswrapper (this is an openSUSE 10.3 system, x86-64).  Namely,
> after a suspend/resume cycle and logging out/logging in the user,
> artswrapper gets stuck somewhere, apparently in the running (R) state.
> For this reason it blocks any subsequent attempts to suspend.
> 
> Here's the relevant trace (from show_state()):
> 
> [  522.474919] artswrapper   R  running task        0  4805      1
> [  522.474922]  ffff810074cd1f70 0000000000000082 0000000000000296 ffff810074cd1ed8
> [  522.474926]  ffffffff80311769 ffff810074cd1f20 ffffffff80701240 ffffffff80701240
> [  522.474930]  ffffffff80701240 ffffffff80701240 ffffffff80701240 ffffffff80701240
> [  522.474933] Call Trace:
> [  522.474940]  [<ffffffff80311769>] ? __up_read+0x8f/0x97
> [  522.474963]  [<ffffffff8020c5cf>] retint_careful+0xd/0x21
> 
> where, according to gdb,
> 
> (gdb) l *__up_read+0x8f
> 0xffffffff80311769 is in __up_read (/home/rafael/src/linux-2.6/lib/rwsem-spinlock.c:273).
> 268
> 269             if (--sem->activity == 0 && !list_empty(&sem->wait_list))
> 270                     sem = __rwsem_wake_one_writer(sem);
> 271
> 272             spin_unlock_irqrestore(&sem->wait_lock, flags);
> 273     }
> 274
> 275     /*
> 276      * release a write lock on the semaphore
> 277      */
> 
> What gives?

Well, let me give you something that worked for Guillaume :-)

---
Subject: hrtimer: fix hrtimer_init_sleeper() users

commit 37bb6cb4097e29ffee970065b74499cbf10603a3
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jan 25 21:08:32 2008 +0100

    hrtimer: unlock hrtimer_wakeup

Broke hrtimer_init_sleeper() users. It forgot to fix up the futex
caller of this function to detect the failed queueing and messed up
the do_nanosleep() caller in that it could leak a TASK_INTERRUPTIBLE
state.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/futex.c   |    2 ++
 kernel/hrtimer.c |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1312,6 +1312,8 @@ static int __sched do_nanosleep(struct h
 
 	} while (t->task && !signal_pending(current));
 
+	__set_current_state(TASK_RUNNING);
+
 	return t->task == NULL;
 }
 
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -1252,6 +1252,8 @@ static int futex_wait(u32 __user *uaddr,
 			t.timer.expires = *abs_time;
 
 			hrtimer_start(&t.timer, t.timer.expires, HRTIMER_MODE_ABS);
+			if (!hrtimer_active(&t->timer))
+				t->task = NULL;
 
 			/*
 			 * the timer could have already expired, in which


