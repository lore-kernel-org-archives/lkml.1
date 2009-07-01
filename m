Return-Path: <linux-kernel-owner+w=401wt.eu-S1765285AbZGABB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765285AbZGABB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761498AbZGAAfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:00 -0400
Received: from kroah.org ([198.145.64.141]:60420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761479AbZGAAe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:30 2009
Message-Id: <20090701002430.420296635@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 055/108] x86: hpet: Mark per cpu interrupts IRQF_TIMER to prevent resume failure
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=x86-hpet-mark-per-cpu-interrupts-irqf_timer-to-prevent-resume-failure.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 507fa3a3d80365c595113a5ac3232309e3dbf5d8 upstream.

timer interrupts are excluded from being disabled during suspend. The
clock events code manages the disabling of clock events on its own
because the timer interrupt needs to be functional before the resume
code reenables the device interrupts.

The hpet per cpu timers request their interrupt without setting the
IRQF_TIMER flag so suspend_device_irqs() disables them as well which
results in a fatal resume failure on the boot CPU.

Adding IRQF_TIMER to the interupt flags when requesting the hpet per
cpu timer interrupts solves the problem.

Reported-by: Benjamin S. <sbenni@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Benjamin S. <sbenni@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -510,7 +510,8 @@ static int hpet_setup_irq(struct hpet_de
 {
 
 	if (request_irq(dev->irq, hpet_interrupt_handler,
-			IRQF_DISABLED|IRQF_NOBALANCING, dev->name, dev))
+			IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
+			dev->name, dev))
 		return -1;
 
 	disable_irq(dev->irq);


