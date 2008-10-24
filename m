Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbYJXMsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbYJXMsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYJXMsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:48:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:19378 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbYJXMsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hR/j5pw4SDrhkcgs9pS6dIbb4xar/IrjA8nwRvSZbTpGIOwLkhyQyTZ3NQgUilKTis
         om9EQW6cpfvtaO1nvVt8kK/hN8u6xhH7fHkYC5+ppR0WPStRcwmuIl5OqqfdZd+3lzWd
         BnI1/UKU+GCpu+wbZ43cY+XTXJ1FFEzuDOwV0=
Message-ID: <331b791d0810240548u56506134ra65866f881ba5fc1@mail.gmail.com>
Date: Fri, 24 Oct 2008 14:48:11 +0200
From: "Thibaut BOYER" <tboyer.dev@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Does rt_down_timeout have a bug ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

IMHO, it seems there is a serious bug with rt_down_timeout. Every time
I call it, I got an exception because this function is apparently
empty !
I recompile the kernel (2.6.26.5-rt9) with a printk in the function
run_hrtimer_pending which print "NULL" because fn=NULL.

Here is the function I modified :

static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
{
	spin_lock_irq(&cpu_base->lock);

	while (!list_empty(&cpu_base->cb_pending)) {
		enum hrtimer_restart (*fn)(struct hrtimer *);
		struct hrtimer *timer;
		int restart;

		timer = list_entry(cpu_base->cb_pending.next,
				   struct hrtimer, cb_entry);

		debug_hrtimer_deactivate(timer);
		timer_stats_account_hrtimer(timer);
                if (timer)
                    fn = timer->function; // ***** <TB> *****
                else printk("TIMER NULL\n"); // ***** <TB> *****
		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
		spin_unlock_irq(&cpu_base->lock);
                // ***** <TB> *****
                if (fn == NULL)
                    printk("fn = null\n");
		else restart = fn(timer);
                // ***** </TB> *****
		spin_lock_irq(&cpu_base->lock);

		timer->state &= ~HRTIMER_STATE_CALLBACK;
		if (restart == HRTIMER_RESTART) {
			BUG_ON(hrtimer_active(timer));
			/*
			 * Enqueue the timer, allow reprogramming of the event
			 * device
			 */
			enqueue_hrtimer(timer, timer->base, 1);
		} else if (hrtimer_active(timer)) {
			/*
			 * If the timer was rearmed on another CPU, reprogram
			 * the event device.
			 */
			struct hrtimer_clock_base *base = timer->base;

			if (base->first == &timer->node &&
			    hrtimer_reprogram(timer, base)) {
				/*
				 * Timer is expired. Thus move it from tree to
				 * pending list again.
				 */
				__remove_hrtimer(timer, base,
						 HRTIMER_STATE_PENDING, 0);
				list_add_tail(&timer->cb_entry,
					      &base->cpu_base->cb_pending);
			}
		}
	}
	spin_unlock_irq(&cpu_base->lock);

	wake_up_timer_waiters(cpu_base);
}

-------------------------------------------------------------------------------------------------

Here is the dmesg :

fn = null
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<00000000>]
*pde = 00000000
Oops: 0000 [#1] PREEMPT
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in: cp16xx(P) e100 mii

Pid: 5, comm: sirq-timer/0 Tainted: P          (2.6.26.5-rt9-ipipe #2)
EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
EIP is at 0x0
EAX: dc11df0c EBX: 00000000 ECX: 00000001 EDX: 00000000
ESI: dc11df0c EDI: c0498e20 EBP: ddc29f58 ESP: ddc29f40
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 preempt:00000001
Process sirq-timer/0 (pid: 5, ti=ddc29000 task=ddc44d80 task.ti=ddc29000)
Stack: c0133e3a 00000000 c0498ea4 00000202 c050af80 fffffffd ddc29f6c c0134a38
       c050af80 ddc29f6c 00000202 ddc29fa0 c0126452 00000001 00000002 c050aab0
       ddc29f88 c013da9b ddc29fa0 00000046 00000002 00000002 c050aab0 fffffffd
Call Trace:
 [<c0133e3a>] ? run_hrtimer_pending+0x5a/0x110
 [<c0134a38>] ? hrtimer_run_pending+0x48/0xe0
 [<c0126452>] ? run_timer_softirq+0x82/0x2c0
 [<c013da9b>] ? trace_hardirqs_on+0xb/0x10
 [<c012298d>] ? ksoftirqd+0x10d/0x230
 [<c0122880>] ? ksoftirqd+0x0/0x230
 [<c0130716>] ? kthread+0x46/0x80
 [<c01306d0>] ? kthread+0x0/0x80
 [<c0103cf3>] ? kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:ddc29f40
---[ end trace ce167a848c96a955 ]---

Am I alone (in this case) ?
TIA

TB
