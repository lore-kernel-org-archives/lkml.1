Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbXKOSFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbXKOSFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbXKOSFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:05:39 -0500
Received: from delta.dailydns.net ([204.16.247.150]:52649 "EHLO
	delta.dailydns.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406AbXKOSFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:05:38 -0500
X-Greylist: delayed 4202 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2007 13:05:38 EST
Date: Thu, 15 Nov 2007 18:55:29 +0200
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64: fix a deadlock in set_rtc_mmss()
Message-ID: <20071115165528.GA25520@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - delta.dailydns.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch is valid only for 2.6.23.x, guessing from the recent arch/ changes 
in 2.6.24-rc.

set_rtc_mmss() was used to be called from interrupt context in 2.6.22,
however in 2.6.23, it is called from a timer context, where interrupts
are enabled. This patch ensures that rtc_interrupt() won't dead-lock 
with set_rtc_mmss().

--
BUG: spinlock recursion on CPU#1, swapper/0

lock: ffffffff8063ffe0, .magic: dead4ead, .owner: swapper/0, .owner_cpu: 1

Call Trace:
<IRQ>  [<ffffffff80361297>] spin_bug+0xa7/0x100
[<ffffffff803614d5>] _raw_spin_lock+0x145/0x150
[<ffffffff80228751>] inc_nr_running+0x31/0x40
[<ffffffff8024b4a0>] sync_cmos_clock+0x0/0xc0
[<ffffffff804fa839>] _spin_lock+0x9/0x10
[<ffffffff803ae770>] rtc_interrupt+0x10/0xe0
[<ffffffff80258975>] handle_IRQ_event+0x35/0x70
[<ffffffff80259f6c>] handle_edge_irq+0xcc/0x150
[<ffffffff8020e600>] do_IRQ+0x80/0x100
[<ffffffff8020c441>] ret_from_intr+0x0/0xa
[<ffffffff8020f4e7>] update_persistent_clock+0x47/0x1f0
[<ffffffff8024b54d>] sync_cmos_clock+0xad/0xc0
[<ffffffff8023aa58>] run_timer_softirq+0x178/0x1e0
[<ffffffff802370e4>] __do_softirq+0x74/0xe0
[<ffffffff8020d0bc>] call_softirq+0x1c/0x30
[<ffffffff8020e52d>] do_softirq+0x3d/0x90
[<ffffffff80237065>] irq_exit+0x45/0x50
[<ffffffff802182a5>] smp_apic_timer_interrupt+0x55/0x70
[<ffffffff8020b050>] default_idle+0x0/0x50
[<ffffffff8020cb66>] apic_timer_interrupt+0x66/0x70
<EOI>  [<ffffffff8020b07d>] default_idle+0x2d/0x50
[<ffffffff8020a922>] enter_idle+0x22/0x30
[<ffffffff8020b0fc>] cpu_idle+0x5c/0x80
[<ffffffff806c0298>] start_secondary+0x258/0x360

Signed-off-by: Dan Aloni <da-x@monatomic.org>

---
commit df9b0fba29fec2479d4c106ccdc3524fd8a61be8
tree 85b6a0f6285ab4f363291ca429ff86557a839378
parent 1915566e8113fc9cd1c6c0b9d1f5e7ee99080850
author Dan Aloni <da-x@monatomic.org> Thu, 15 Nov 2007 15:11:39 +0200
committer Dan Aloni <da-x@monatomic.org> Thu, 15 Nov 2007 15:11:39 +0200

 arch/x86_64/kernel/time.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index 6241b50..8414236 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -87,13 +87,14 @@ static int set_rtc_mmss(unsigned long nowtime)
 	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char control, freq_select;
+	unsigned long flags;
 
 /*
  * IRQs are disabled when we're called from the timer interrupt,
  * no need for spin_lock_irqsave()
  */
 
-	spin_lock(&rtc_lock);
+	spin_lock_irqsave(&rtc_lock, flags);
 
 /*
  * Tell the clock it's being set and stop it.
@@ -143,7 +144,7 @@ static int set_rtc_mmss(unsigned long nowtime)
 	CMOS_WRITE(control, RTC_CONTROL);
 	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
-	spin_unlock(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	return retval;
 }

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
