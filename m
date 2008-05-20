Return-Path: <linux-kernel-owner+w=401wt.eu-S934096AbYETWNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbYETWNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759703AbYETWNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:13:00 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:50591 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546AbYETWM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:12:59 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 18:12:59 EDT
Message-ID: <48334B37.8090201@freemail.hu>
Date: Wed, 21 May 2008 00:05:43 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Paul Gortmaker <p_gortmaker@yahoo.com>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] smc-ultra: get rid of "eth%d" message
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print out the dev->name only after register_netdev(). If the
dev->name is printk()ed out before calling register_netdev()
the result will be "eth%d" in the dmesg instead of "eth0".

Signed-off-by: Márton Németh <nm127@freemail.hu>

---
--- linux-2.6.26-rc3/drivers/net/smc-ultra.c.orig	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.26-rc3/drivers/net/smc-ultra.c	2008-05-20 22:04:15.000000000 +0200
@@ -228,9 +228,6 @@ static int __init ultra_probe1(struct ne
 	for (i = 0; i < 6; i++)
 		dev->dev_addr[i] = inb(ioaddr + 8 + i);

-	printk("%s: %s at %#3x, %s", dev->name, model_name,
-	       ioaddr, print_mac(mac, dev->dev_addr));
-
 	/* Switch from the station address to the alternate register set and
 	   read the useful registers there. */
 	outb(0x80 | reg4, ioaddr + 4);
@@ -253,8 +250,10 @@ static int __init ultra_probe1(struct ne
 		irq = irqmap[((irqreg & 0x40) >> 4) + ((irqreg & 0x0c) >> 2)];

 		if (irq == 0) {
-			printk(", failed to detect IRQ line.\n");
-			retval =  -EAGAIN;
+			printk(KERN_ERR "%s at %#3x, %s, "
+			       "failed to detect IRQ line.\n", model_name,
+			       ioaddr, print_mac(mac, dev->dev_addr));
+			retval = -EAGAIN;
 			goto out;
 		}
 		dev->irq = irq;
@@ -280,22 +279,19 @@ static int __init ultra_probe1(struct ne

 	ei_status.mem = ioremap(dev->mem_start, (ei_status.stop_page - START_PG)*256);
 	if (!ei_status.mem) {
-		printk(", failed to ioremap.\n");
-		retval =  -ENOMEM;
+		printk(KERN_ERR "%s at %#3x, %s, failed to ioremap.\n",
+		       model_name, ioaddr, print_mac(mac, dev->dev_addr));
+		retval = -ENOMEM;
 		goto out;
 	}

 	dev->mem_end = dev->mem_start + (ei_status.stop_page - START_PG)*256;

 	if (piomode) {
-		printk(",%s IRQ %d programmed-I/O mode.\n",
-			   eeprom_irq ? "EEPROM" : "assigned ", dev->irq);
 		ei_status.block_input = &ultra_pio_input;
 		ei_status.block_output = &ultra_pio_output;
 		ei_status.get_8390_hdr = &ultra_pio_get_hdr;
 	} else {
-		printk(",%s IRQ %d memory %#lx-%#lx.\n", eeprom_irq ? "" : "assigned ",
-			   dev->irq, dev->mem_start, dev->mem_end-1);
 		ei_status.block_input = &ultra_block_input;
 		ei_status.block_output = &ultra_block_output;
 		ei_status.get_8390_hdr = &ultra_get_8390_hdr;
@@ -311,6 +307,21 @@ static int __init ultra_probe1(struct ne
 	retval = register_netdev(dev);
 	if (retval)
 		goto out;
+
+	if (piomode) {
+		printk(KERN_INFO "%s: %s at %#3x, %s,"
+			"%s IRQ %d programmed-I/O mode.\n",
+			dev->name, model_name, ioaddr,
+			print_mac(mac, dev->dev_addr),
+			eeprom_irq ? " EEPROM" : " assigned", dev->irq);
+	} else {
+		printk(KERN_INFO "%s: %s at %#3x, %s,"
+			"%s IRQ %d memory %#lx-%#lx.\n",
+			dev->name, model_name, ioaddr,
+			print_mac(mac, dev->dev_addr),
+			eeprom_irq ? "" : " assigned",
+			dev->irq, dev->mem_start, dev->mem_end-1);
+	}
 	return 0;
 out:
 	release_region(ioaddr, ULTRA_IO_EXTENT);
