Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbZIKAcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbZIKAcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZIKA3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:29:06 -0400
Received: from kroah.org ([198.145.64.141]:38058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbZIKA3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:10 2009
Message-Id: <20090911002409.986396768@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:22:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/22] sparc64: Kill spurious NMI watchdog triggers by increasing limit to 30 seconds.
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=sparc64-kill-spurious-nmi-watchdog-triggers-by-increasing-limit-to-30-seconds.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit e6617c6ec28a17cf2f90262b835ec05b9b861400 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/nmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -103,7 +103,7 @@ notrace __kprobes void perfctr_irq(int i
 	}
 	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
 		local_inc(&__get_cpu_var(alert_counter));
-		if (local_read(&__get_cpu_var(alert_counter)) == 5 * nmi_hz)
+		if (local_read(&__get_cpu_var(alert_counter)) == 30 * nmi_hz)
 			die_nmi("BUG: NMI Watchdog detected LOCKUP",
 				regs, panic_on_timeout);
 	} else {


