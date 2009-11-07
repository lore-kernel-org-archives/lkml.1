Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbZKGUtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbZKGUtB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 15:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZKGUs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 15:48:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:40681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbZKGUs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 15:48:57 -0500
Date: Sat, 7 Nov 2009 20:48:48 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yong.zhang0@gmail.com, tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, yong.zhang0@gmail.com, prarit@redhat.com
In-Reply-To: <1257563773-4620-1-git-send-email-yong.zhang0@gmail.com>
References: <1257563773-4620-1-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: try_one_irq() must be called with irq disabled
Message-ID: <tip-e7e7e0c084ef862d5754701108d4a038514d6314@git.kernel.org>
Git-Commit-ID: e7e7e0c084ef862d5754701108d4a038514d6314
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7e7e0c084ef862d5754701108d4a038514d6314
Gitweb:     http://git.kernel.org/tip/e7e7e0c084ef862d5754701108d4a038514d6314
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Sat, 7 Nov 2009 11:16:13 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 7 Nov 2009 21:44:45 +0100

genirq: try_one_irq() must be called with irq disabled

Prarit reported:
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
 #0:  (kernel/irq/spurious.c:21){+.-...}, at: [<ffffffff81070cf2>]
run_timer_softirq+0x1a9/0x315

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.32-rc5 #1
Call Trace:
 <IRQ>  [<ffffffff81093e94>] valid_state+0x187/0x1ae
 [<ffffffff81093fe4>] mark_lock+0x129/0x253
 [<ffffffff810951d4>] __lock_acquire+0x370/0xd5d
 [<ffffffff81095cb4>] lock_acquire+0xf3/0x12d
 [<ffffffff814cdadd>] _spin_lock+0x40/0x89
 [<ffffffff810c264e>] try_one_irq+0x32/0x138
 [<ffffffff810c2795>] poll_all_shared_irqs+0x41/0x6d
 [<ffffffff810c27dd>] poll_spurious_irqs+0x1c/0x49
 [<ffffffff81070d82>] run_timer_softirq+0x239/0x315
 [<ffffffff81068bd3>] __do_softirq+0x102/0x1ef
 [<ffffffff8101304c>] call_softirq+0x1c/0x30
 [<ffffffff81014b65>] do_softirq+0x59/0xca
 [<ffffffff810686ad>] irq_exit+0x58/0xae
 [<ffffffff81029b84>] smp_apic_timer_interrupt+0x94/0xba
 [<ffffffff81012a33>] apic_timer_interrupt+0x13/0x20

The reason is that try_one_irq() is called from hardirq context with
interrupts disabled and from softirq context (poll_all_shared_irqs())
with interrupts enabled.

Disable interrupts before calling it from poll_all_shared_irqs().

Reported-and-tested-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
LKML-Reference: <1257563773-4620-1-git-send-email-yong.zhang0@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/spurious.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 114e704..bd7273e 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -121,7 +121,9 @@ static void poll_all_shared_irqs(void)
 		if (!(status & IRQ_SPURIOUS_DISABLED))
 			continue;
 
+		local_irq_disable();
 		try_one_irq(i, desc);
+		local_irq_enable();
 	}
 }
 
