Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZICJgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZICJgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 05:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbZICJgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 05:36:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55577
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754794AbZICJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 05:36:20 -0400
Date: Thu, 03 Sep 2009 02:36:35 -0700 (PDT)
Message-Id: <20090903.023635.110571297.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090623.171735.154729801.davem@davemloft.net>
References: <87bpog3clx.fsf@basil.nowhere.org>
	<20090622.022752.219499742.davem@davemloft.net>
	<20090623.171735.154729801.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 23 Jun 2009 17:17:35 -0700 (PDT)

> I'm not exactly sure what to do about this.

As a followup I'm going to push the following to Linus and -stable to
work around the problem for the time being.

>From e6617c6ec28a17cf2f90262b835ec05b9b861400 Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@davemloft.net>
Date: Thu, 3 Sep 2009 02:35:20 -0700
Subject: [PATCH] sparc64: Kill spurious NMI watchdog triggers by increasing limit to 30 seconds.

This is a compromise and a temporary workaround for bootup NMI
watchdog triggers some people see with qla2xxx devices present.

This happens when, for example:

CPU 0 is in the driver init and looping submitting mailbox commands to
load the firmware, then waiting for completion.

CPU 1 is receiving the device interrupts.  CPU 1 is where the NMI
watchdog triggers.

CPU 0 is submitting mailbox commands fast enough that by the time CPU
1 returns from the device interrupt handler, a new one is pending.
This sequence runs for more than 5 seconds.

The problematic case is CPU 1's timer interrupt running when the
barrage of device interrupts begin.  Then we have:

	timer interrupt
	return for softirq checking
	pending, thus enable interrupts

		 qla2xxx interrupt
		 return
		 qla2xxx interrupt
		 return
		 ... 5+ seconds pass
		 final qla2xxx interrupt for fw load
		 return

	run timer softirq
	return

At some point in the multi-second qla2xxx interrupt storm we trigger
the NMI watchdog on CPU 1 from the NMI interrupt handler.

The timer softirq, once we get back to running it, is smart enough to
run the timer work enough times to make up for the missed timer
interrupts.

However, the NMI watchdogs (both x86 and sparc) use the timer
interrupt count to notice the cpu is wedged.  But in the above
scenerio we'll receive only one such timer interrupt even if we last
all the way back to running the timer softirq.

The default watchdog trigger point is only 5 seconds, which is pretty
low (the softwatchdog triggers at 60 seconds).  So increase it to 30
seconds for now.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/nmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/nmi.c b/arch/sparc/kernel/nmi.c
index 2c0cc72..b75bf50 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -103,7 +103,7 @@ notrace __kprobes void perfctr_irq(int irq, struct pt_regs *regs)
 	}
 	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
 		local_inc(&__get_cpu_var(alert_counter));
-		if (local_read(&__get_cpu_var(alert_counter)) == 5 * nmi_hz)
+		if (local_read(&__get_cpu_var(alert_counter)) == 30 * nmi_hz)
 			die_nmi("BUG: NMI Watchdog detected LOCKUP",
 				regs, panic_on_timeout);
 	} else {
-- 
1.6.4.2

