Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbXDKIy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbXDKIy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXDKIx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:53:56 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1562 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXDKIxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:53:25 -0400
Date: Wed, 11 Apr 2007 12:30:20 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] ALPHA: more fixes for specific machine types
Message-ID: <20070411123020.G17547@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

arch/alpha/kernel/sys_sx164.c

	Earlier firmware revisions need MVI fix as well.

arch/alpha/kernel/sys_nautilus.c

	On UP1500 firmware reports wrong AGP IRQ (10 instead of 5).
	This causes interrupt storm if there is a PCI device that
	uses IRQ 5.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

--- linux.orig/arch/alpha/kernel/sys_sx164.c	Thu Jun  1 13:46:21 2006
+++ linux/arch/alpha/kernel/sys_sx164.c	Thu Jun  1 13:46:11 2006
@@ -132,7 +132,7 @@ sx164_init_arch(void)
 
 	if (amask(AMASK_MAX) != 0
 	    && alpha_using_srm
-	    && (cpu->pal_revision & 0xffff) == 0x117) {
+	    && (cpu->pal_revision & 0xffff) <= 0x117) {
 		__asm__ __volatile__(
 		"lda	$16,8($31)\n"
 		"call_pal 9\n"		/* Allow PALRES insns in kernel mode */
--- linux.orig/arch/alpha/kernel/sys_nautilus.c	Tue Apr 10 13:59:43 2007
+++ linux/arch/alpha/kernel/sys_nautilus.c	Tue Apr 10 14:29:55 2007
@@ -70,6 +70,12 @@ nautilus_map_irq(struct pci_dev *dev, u8
 	/* Preserve the IRQ set up by the console.  */
 
 	u8 irq;
+	/* UP1500: AGP INTA is actually routed to IRQ 5, not IRQ 10 as
+	   console reports. Check the device id of AGP bridge to distinguish
+	   UP1500 from UP1000/1100. Note: 'pin' is 2 due to bridge swizzle. */
+	if (slot == 1 && pin == 2 &&
+	    dev->bus->self && dev->bus->self->device == 0x700f)
+		return 5;
 	pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
 	return irq;
 }
