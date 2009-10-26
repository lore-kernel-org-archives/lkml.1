Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZJZSfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZJZSfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZJZSfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:35:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbZJZSfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:35:02 -0400
Date: Mon, 26 Oct 2009 14:35:06 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20091026183411.16310.35933.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: use spin_lock_irqsave in try_one_irq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting 2.6.32-rc5 on some IBM systems results in

Disabling IRQ #19

=================================
[ INFO: inconsistent lock state ]
2.6.32-rc5 #1
---------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&irq_desc_lock_class){?.-...}, at: [<ffffffff810c264e>] try_one_irq+0x32/0x138
{IN-HARDIRQ-W} state was registered at:
  [<ffffffff81095160>] __lock_acquire+0x2fc/0xd5d
  [<ffffffff81095cb4>] lock_acquire+0xf3/0x12d
  [<ffffffff814cdadd>] _spin_lock+0x40/0x89
  [<ffffffff810c3389>] handle_level_irq+0x30/0x105
  [<ffffffff81014e0e>] handle_irq+0x95/0xb7
  [<ffffffff810141bd>] do_IRQ+0x6a/0xe0
  [<ffffffff81012813>] ret_from_intr+0x0/0x16
irq event stamp: 195096
hardirqs last  enabled at (195096): [<ffffffff814cd7f7>] _spin_unlock_irq+0x3a/0x5c
hardirqs last disabled at (195095): [<ffffffff814cdbdd>] _spin_lock_irq+0x29/0x95
softirqs last  enabled at (195088): [<ffffffff81068c92>] __do_softirq+0x1c1/0x1ef
softirqs last disabled at (195093): [<ffffffff8101304c>] call_softirq+0x1c/0x30
 
other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (kernel/irq/spurious.c:21){+.-...}, at: [<ffffffff81070cf2>] run_timer_softirq+0x1a9/0x315

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.32-rc5 #1
Call Trace:
 <IRQ>  [<ffffffff81093e94>] valid_state+0x187/0x1ae
 [<ffffffff81096c7b>] ? check_usage_backwards+0x0/0xa3
 [<ffffffff81093fe4>] mark_lock+0x129/0x253
 [<ffffffff810951d4>] __lock_acquire+0x370/0xd5d
 [<ffffffff810c264e>] ? try_one_irq+0x32/0x138
 [<ffffffff8109329d>] ? save_trace+0x4e/0xcd
 [<ffffffff81095cb4>] lock_acquire+0xf3/0x12d
 [<ffffffff810c264e>] ? try_one_irq+0x32/0x138
 [<ffffffff81070cf2>] ? run_timer_softirq+0x1a9/0x315
 [<ffffffff810c264e>] ? try_one_irq+0x32/0x138
 [<ffffffff814cdadd>] _spin_lock+0x40/0x89
 [<ffffffff810c264e>] ? try_one_irq+0x32/0x138
 [<ffffffff810c264e>] try_one_irq+0x32/0x138
 [<ffffffff810c2795>] poll_all_shared_irqs+0x41/0x6d
 [<ffffffff810c27dd>] poll_spurious_irqs+0x1c/0x49
 [<ffffffff81070d82>] run_timer_softirq+0x239/0x315
 [<ffffffff81070cf2>] ? run_timer_softirq+0x1a9/0x315
 [<ffffffff810c27c1>] ? poll_spurious_irqs+0x0/0x49
 [<ffffffff81068bd3>] __do_softirq+0x102/0x1ef
 [<ffffffff8108eccf>] ? tick_dev_program_event+0x46/0xcc
 [<ffffffff8101304c>] call_softirq+0x1c/0x30
 [<ffffffff81014b65>] do_softirq+0x59/0xca
 [<ffffffff810686ad>] irq_exit+0x58/0xae
 [<ffffffff81029b84>] smp_apic_timer_interrupt+0x94/0xba
 [<ffffffff81012a33>] apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff8101a7b5>] ? mwait_idle+0x8c/0xb5
 [<ffffffff8101a7ac>] ? mwait_idle+0x83/0xb5
 [<ffffffff81010e55>] ? cpu_idle+0xbe/0x100
 [<ffffffff814c4270>] ? start_secondary+0x219/0x270

This happens because the &desc->lock is taken with spin_lock_irqsave and
just a spin_lock.  In the try_one_irq(), this lock really should be a
spin_lock_irqsave().

I have not yet narrowed down the reason for the spurious interrupt (although
I suspect it maybe to do with the radeon driver).

Successfully tested by me.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

--- linux-2.6.31.x86_64.orig/kernel/irq/spurious.c	2009-09-09 18:13:59.000000000 -0400
+++ linux-2.6.31.x86_64/kernel/irq/spurious.c	2009-10-26 10:55:56.709845786 -0400
@@ -27,8 +27,9 @@ static int try_one_irq(int irq, struct i
 {
 	struct irqaction *action;
 	int ok = 0, work = 0;
+	unsigned long flags;
 
-	spin_lock(&desc->lock);
+	spin_lock_irqsave(&desc->lock, flags);
 	/* Already running on another processor */
 	if (desc->status & IRQ_INPROGRESS) {
 		/*
@@ -37,13 +38,13 @@ static int try_one_irq(int irq, struct i
 		 */
 		if (desc->action && (desc->action->flags & IRQF_SHARED))
 			desc->status |= IRQ_PENDING;
-		spin_unlock(&desc->lock);
+		spin_unlock_irqrestore(&desc->lock, flags);
 		return ok;
 	}
 	/* Honour the normal IRQ locking */
 	desc->status |= IRQ_INPROGRESS;
 	action = desc->action;
-	spin_unlock(&desc->lock);
+	spin_unlock_irqrestore(&desc->lock, flags);
 
 	while (action) {
 		/* Only shared IRQ handlers are safe to call */
@@ -56,7 +57,7 @@ static int try_one_irq(int irq, struct i
 	}
 	local_irq_disable();
 	/* Now clean up the flags */
-	spin_lock(&desc->lock);
+	spin_lock_irqsave(&desc->lock, flags);
 	action = desc->action;
 
 	/*
@@ -68,9 +69,9 @@ static int try_one_irq(int irq, struct i
 		 * Perform real IRQ processing for the IRQ we deferred
 		 */
 		work = 1;
-		spin_unlock(&desc->lock);
+		spin_unlock_irqrestore(&desc->lock, flags);
 		handle_IRQ_event(irq, action);
-		spin_lock(&desc->lock);
+		spin_lock_irqsave(&desc->lock, flags);
 		desc->status &= ~IRQ_PENDING;
 	}
 	desc->status &= ~IRQ_INPROGRESS;
@@ -80,7 +81,7 @@ static int try_one_irq(int irq, struct i
 	 */
 	if (work && desc->chip && desc->chip->end)
 		desc->chip->end(irq);
-	spin_unlock(&desc->lock);
+	spin_unlock_irqrestore(&desc->lock, flags);
 
 	return ok;
 }
