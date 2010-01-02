Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240Ab0ABAm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab0ABAm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 19:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828Ab0ABAm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 19:42:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab0ABAm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 19:42:56 -0500
Subject: Re: BUG during shutdown - bisected to commit e2912009
From: Peter Zijlstra <peterz@infradead.org>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Xiaotian Feng <dfeng@redhat.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <6041d2001001011627o5c494df4v37c0c466df3d444c@mail.gmail.com>
References: <6041d2001001011627o5c494df4v37c0c466df3d444c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jan 2010 01:42:00 +0100
Message-ID: <1262392920.32223.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-01 at 19:27 -0500, Marc Dionne wrote:
> I'm getting a BUG with current kernels from
> kernel/time/clockevents.c:263 when halting the system - a restart
> behaves normally.  I don't have a good camera handy at the moment to
> capture the call stack on screen, but the call sequence is:
> 
> clockevents_notify
> hrtimer_cpu_notify
> notifier_call_chain
> raw_notifier_call_chain
> _cpu_down
> disable_nonboot_cpus
> kernel_power_off
> sys_reboot
> 
> I bisected it down to commit e2912009: sched: Ensure set_task_cpu() is
> never called on blocked tasks.  There were a few commits tested along
> the way where I got a freeze (with the power still on) instead of a
> BUG. Reverting that commit from the current kernel doesn't look
> trivial, but the commit immediately preceding this one does halt fine.

We somehow seem to trip up the below patch, which doesn't really make
sense, as I can't find how task placement would affect the below error.

It seems to purely test against the hot-unplugged cpu, not a cpu the
task is running on.

---
commit bb6eddf7676e1c1f3e637aa93c5224488d99036f
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Dec 10 15:35:10 2009 +0100

    clockevents: Prevent clockevent_devices list corruption on cpu hotplug
    
    Xiaotian Feng triggered a list corruption in the clock events list on
    CPU hotplug and debugged the root cause.
    
    If a CPU registers more than one per cpu clock event device, then only
    the active clock event device is removed on CPU_DEAD. The unused
    devices are kept in the clock events device list.
    
    On CPU up the clock event devices are registered again, which means
    that we list_add an already enqueued list_head. That results in list
    corruption.
    
    Resolve this by removing all devices which are associated to the dead
    CPU on CPU_DEAD.
    
    Reported-by: Xiaotian Feng <dfeng@redhat.com>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Tested-by: Xiaotian Feng <dfeng@redhat.com>
    Cc: stable@kernel.org

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 20a8920..91db2e3 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -238,8 +238,9 @@ void clockevents_exchange_device(struct clock_event_device *old,
  */
 void clockevents_notify(unsigned long reason, void *arg)
 {
-	struct list_head *node, *tmp;
+	struct clock_event_device *dev, *tmp;
 	unsigned long flags;
+	int cpu;
 
 	spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
@@ -250,8 +251,19 @@ void clockevents_notify(unsigned long reason, void *arg)
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
 		 */
-		list_for_each_safe(node, tmp, &clockevents_released)
-			list_del(node);
+		list_for_each_entry_safe(dev, tmp, &clockevents_released, list)
+			list_del(&dev->list);
+		/*
+		 * Now check whether the CPU has left unused per cpu devices
+		 */
+		cpu = *((int *)arg);
+		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
+			if (cpumask_test_cpu(cpu, dev->cpumask) &&
+			    cpumask_weight(dev->cpumask) == 1) {
+				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
+				list_del(&dev->list);
+			}
+		}
 		break;
 	default:
 		break;


