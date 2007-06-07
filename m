Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbXFGP3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbXFGP3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761517AbXFGP3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:29:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54909 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754594AbXFGP3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:29:06 -0400
Date: Thu, 7 Jun 2007 16:34:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [FOR DISCUSSION]: Improve behaviour of spurious IRQ detect
Message-ID: <20070607163409.05e8e9ab@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we handle spurious IRQ activity based upon seeing a lot of
invalid interrupts, and we clear things back on the base of lots of valid
interrupts.

Unfortunately in some cases you get legitimate invalid interrupts caused
by timing asynchronicity between the PCI bus and the APIC bus when
disabling interrupts and pulling other tricks. In this case although the
spurious IRQs are not a problem our unhandled counters didn't clear and
they act as a slow running timebomb. (This is effectively what the serial
port/tty problem that was fixed by clearing counters when registering a
handler showed up)

Its easy enough to add a second parameter - time. This means that if we
see a regular stream of harmless spurious interrupts which are not
harming processing we don't go off and do something stupid like disable
the IRQ after a month of running. OTOH lockups and performance killers
show up a lot more than 10/second

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc4-mm2/kernel/irq/spurious.c linux-2.6.22-rc4-mm2/kernel/irq/spurious.c
--- linux.vanilla-2.6.22-rc4-mm2/kernel/irq/spurious.c	2007-06-07 14:26:01.000000000 +0100
+++ linux-2.6.22-rc4-mm2/kernel/irq/spurious.c	2007-06-07 14:38:22.000000000 +0100
@@ -172,7 +172,15 @@
 		    irqreturn_t action_ret)
 {
 	if (unlikely(action_ret != IRQ_HANDLED)) {
-		desc->irqs_unhandled++;
+		/* If we are seeing only the odd spurious IRQ caused by
+		   bus asynchronicity then don't eventually trigger an error,
+		   otherwise the couter becomes a doomsday timer for otherwise
+		   working systems */
+		if (jiffies - desc->last_unhandled > HZ/10)
+			desc->irqs_unhandled = 1;
+		else
+			desc->irqs_unhandled++;
+		desc->last_unhandled = jiffies;
 		if (unlikely(action_ret != IRQ_NONE))
 			report_bad_irq(irq, desc, action_ret);
 	}
--- linux.vanilla-2.6.22-rc4-mm2/include/linux/irq.h	2007-06-07 14:26:01.000000000 +0100
+++ linux-2.6.22-rc4-mm2/include/linux/irq.h	2007-06-07 14:38:07.000000000 +0100
@@ -161,6 +161,7 @@
 	unsigned int		wake_depth;	/* nested wake enables */
 	unsigned int		irq_count;	/* For detecting broken IRQs */
 	unsigned int		irqs_unhandled;
+	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	spinlock_t		lock;
 #ifdef CONFIG_SMP
 	cpumask_t		affinity;
