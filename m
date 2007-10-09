Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbXJIGBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbXJIGBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXJIGBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:01:05 -0400
Received: from www.tglx.de ([62.245.132.106]:44645 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbXJIGBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:01:04 -0400
Date: Tue, 9 Oct 2007 08:00:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vasily Averin <vvs@sw.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, devel@openvz.org
Subject: Re: irq0 stops working
In-Reply-To: <470B1119.8040207@sw.ru>
Message-ID: <alpine.LFD.0.9999.0710090752540.25146@localhost.localdomain>
References: <470B1119.8040207@sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Vasily Averin wrote:
> On one of our servers timer interrupts (i.e irq0) are stops working. As result
> any kernel timers do not triggers and tasks waiting some signals from timers
> hangs forever.

Which kernel version ?
 
> Most noticeable effect of this situation is that any write operations to disk
> are stalled, and nobody can log in on the node.
> 
> At the same time node all existing shells works away. I'm able to read
> interrupts statistic from /proc/interrupts file and it shows that all other
> interrupts are changed when these devices are accessed: disk on sata controller,
> network, cdrom on ide controller, keyboard, serial console, LOC interrupts.
> 
> Also I've found that disable of irqbalance service on the node helps to
> workaround this issue, however of course it fixes nothing.

Well, it's at least a hint. Can you try the patch below please ?

	tglx

diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index 6d48a4e..248987a 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -360,7 +360,7 @@ void stop_timer_interrupt(void)
 
 static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
 };
@@ -403,6 +403,7 @@ void __init time_init(void)
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
 
+	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
 
