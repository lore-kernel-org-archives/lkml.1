Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbZDNFrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbZDNFrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 01:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZDNFrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 01:47:16 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:60153
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbZDNFrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 01:47:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkYCADLA40l8qNo9/2dsb2JhbAAIzSaDfAY
X-IronPort-AV: E=Sophos;i="4.40,183,1238947200"; 
   d="scan'208";a="466392438"
Subject: [REGRESSION] threaded interrupt handler support breaks (some) irq
	handling on AVR32
From: Ben Nizette <bn@niasdigital.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Apr 2009 15:46:48 +1000
Message-Id: <1239688008.29831.2.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing *correct* lkml address]

After pulling in Linus' latest this morning, a tap on the touchscreen of
my AVR32-based board caused the system to hang hard.  It's an ads7843
touchscreen controller driven by drivers/input/touchscreen/ads7846.c -
the tap triggers a pen-down IRQ.  Note that I made a small mod to that
driver; due to limitations of the AVR32's gpio interrupt controller I
have to do

@@ -1129,7 +1129,7 @@ static int __devinit ads7846_probe(struct spi_device
*spi)

        ts->last_msg = m;

-       if (request_irq(spi->irq, ads7846_irq, IRQF_TRIGGER_FALLING,
+       if (request_irq(spi->irq, ads7846_irq, IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
                        spi->dev.driver->name, ts)) {
                dev_dbg(&spi->dev, "irq %d busy?\n", spi->irq);
                err = -EBUSY;

This doesn't effect the driver operation as the irq handler checks the
logic level of the line anyway.

I've bisected the problem to

commit 3aa551c9b4c40018f0e261a178e3d25478dc04a9
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Mar 23 18:28:15 2009 +0100

    genirq: add threaded interrupt handler support

    Add support for threaded interrupt handlers:


Because this doesn't revert cleanly I did the bisection again just to be
sure and it came out the same.

Just before the hang,
~ # cat /proc/interrupts
           CPU0
  0:         42      intc  avr32_comparator
  1:          0      intc  atmel_lcdfb
  2:          1      intc  dw_dmac
  4:          4      intc  atmel_spi.1
  9:        555      intc  ttyS0
 21:          0      intc  rtc
 22:      34037      intc  tc_clkevt
 24:          0      intc  atmel_pwm
 25:       2439      intc  eth0
 28:        156      intc  atmel_mci.0
 31:          0      intc  atmel_usba_udc
131:          0      gpio  ads7846

Note it's that very last line which, when triggered, causes the hang.
As you can see, it's the only one connected through the gpio interrupt
chip.

﻿No sysrq action is possible because of the limited kinds of terminals I
can attach to this board.

Given the limited scope for debug (no logs or sysrq output available) I
can't think exactly what more I can tell you to help you get to the
bottom of it.  I'll do whatever I can though, it's perfectly repeatable.

Thanks,
	--Ben.



