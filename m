Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbYD2Ntj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbYD2Ntj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYD2Ntb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:49:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38668 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751704AbYD2Nta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:49:30 -0400
Date: Tue, 29 Apr 2008 14:41:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, paulkf@microgate.com
Subject: [PATCH] char serial: Switch drivers to ioremap_nocache
Message-ID: <20080429144156.3de249de@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple search/replace except for synclink.c where I noticed a real bug
and fixed it too. It was doing NULL + offset, then checking for NULL if
the remap failed.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/applicom.c linux-2.6.25-mm1/drivers/char/applicom.c
--- linux.vanilla-2.6.25-mm1/drivers/char/applicom.c	2008-04-28 11:36:41.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/applicom.c	2008-04-28 10:10:34.000000000 +0100
@@ -199,7 +199,7 @@
 		if (pci_enable_device(dev))
 			return -EIO;
 
-		RamIO = ioremap(pci_resource_start(dev, 0), LEN_RAM_IO);
+		RamIO = ioremap_nocache(pci_resource_start(dev, 0), LEN_RAM_IO);
 
 		if (!RamIO) {
 			printk(KERN_INFO "ac.o: Failed to ioremap PCI memory "
@@ -254,7 +254,7 @@
 	/* Now try the specified ISA cards */
 
 	for (i = 0; i < MAX_ISA_BOARD; i++) {
-		RamIO = ioremap(mem + (LEN_RAM_IO * i), LEN_RAM_IO);
+		RamIO = ioremap_nocache(mem + (LEN_RAM_IO * i), LEN_RAM_IO);
 
 		if (!RamIO) {
 			printk(KERN_INFO "ac.o: Failed to ioremap the ISA card's memory space (slot #%d)\n", i + 1);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/istallion.c linux-2.6.25-mm1/drivers/char/istallion.c
--- linux.vanilla-2.6.25-mm1/drivers/char/istallion.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/istallion.c	2008-04-28 10:05:37.000000000 +0100
@@ -3257,7 +3257,7 @@
  */
 	EBRDINIT(brdp);
 
-	brdp->membase = ioremap(brdp->memaddr, brdp->memsize);
+	brdp->membase = ioremap_nocache(brdp->memaddr, brdp->memsize);
 	if (brdp->membase == NULL) {
 		retval = -ENOMEM;
 		goto err_reg;
@@ -3414,7 +3414,7 @@
  */
 	EBRDINIT(brdp);
 
-	brdp->membase = ioremap(brdp->memaddr, brdp->memsize);
+	brdp->membase = ioremap_nocache(brdp->memaddr, brdp->memsize);
 	if (brdp->membase == NULL) {
 		retval = -ENOMEM;
 		goto err_reg;
@@ -3665,7 +3665,7 @@
  */
 	for (i = 0; (i < stli_eisamempsize); i++) {
 		brdp->memaddr = stli_eisamemprobeaddrs[i];
-		brdp->membase = ioremap(brdp->memaddr, brdp->memsize);
+		brdp->membase = ioremap_nocache(brdp->memaddr, brdp->memsize);
 		if (brdp->membase == NULL)
 			continue;
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/moxa.c linux-2.6.25-mm1/drivers/char/moxa.c
--- linux.vanilla-2.6.25-mm1/drivers/char/moxa.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/moxa.c	2008-04-28 10:05:50.000000000 +0100
@@ -937,7 +937,7 @@
 		goto err;
 	}
 
-	board->basemem = ioremap(pci_resource_start(pdev, 2), 0x4000);
+	board->basemem = ioremap_nocache(pci_resource_start(pdev, 2), 0x4000);
 	if (board->basemem == NULL) {
 		dev_err(&pdev->dev, "can't remap io space 2\n");
 		goto err_reg;
@@ -1042,7 +1042,7 @@
 			brd->numPorts = type[i] == MOXA_BOARD_C218_ISA ? 8 :
 					numports[i];
 			brd->busType = MOXA_BUS_TYPE_ISA;
-			brd->basemem = ioremap(baseaddr[i], 0x4000);
+			brd->basemem = ioremap_nocache(baseaddr[i], 0x4000);
 			if (!brd->basemem) {
 				printk(KERN_ERR "MOXA: can't remap %lx\n",
 						baseaddr[i]);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/nozomi.c linux-2.6.25-mm1/drivers/char/nozomi.c
--- linux.vanilla-2.6.25-mm1/drivers/char/nozomi.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/nozomi.c	2008-04-28 10:05:57.000000000 +0100
@@ -1407,7 +1407,7 @@
 	/* Find out what card type it is */
 	nozomi_get_card_type(dc);
 
-	dc->base_addr = ioremap(start, dc->card_type);
+	dc->base_addr = ioremap_nocache(start, dc->card_type);
 	if (!dc->base_addr) {
 		dev_err(&pdev->dev, "Unable to map card MMIO\n");
 		ret = -ENODEV;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/sx.c linux-2.6.25-mm1/drivers/char/sx.c
--- linux.vanilla-2.6.25-mm1/drivers/char/sx.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/sx.c	2008-04-28 10:06:21.000000000 +0100
@@ -2543,7 +2543,7 @@
 		goto err_flag;
 	}
 	board->base2 =
-	board->base = ioremap(board->hw_base, SI2_EISA_WINDOW_LEN);
+	board->base = ioremap_nocache(board->hw_base, SI2_EISA_WINDOW_LEN);
 	if (!board->base) {
 		dev_err(dev, "can't remap memory\n");
 		goto err_reg;
@@ -2620,7 +2620,7 @@
 
 	pci_read_config_dword(pdev, PCI_BASE_ADDRESS_0, &hwbase);
 	hwbase &= PCI_BASE_ADDRESS_MEM_MASK;
-	rebase = ioremap(hwbase, 0x80);
+	rebase = ioremap_nocache(hwbase, 0x80);
 	t = readl(rebase + CNTRL_REG_OFFSET);
 	if (t != CNTRL_REG_GOODVALUE) {
 		printk(KERN_DEBUG "sx: performing cntrl reg fix: %08x -> "
@@ -2764,7 +2764,7 @@
 		if (!request_region(board->hw_base, board->hw_len, "sx"))
 			continue;
 		board->base2 =
-		board->base = ioremap(board->hw_base, board->hw_len);
+		board->base = ioremap_nocache(board->hw_base, board->hw_len);
 		if (!board->base)
 			goto err_sx_reg;
 		board->flags &= ~SX_BOARD_TYPE;
@@ -2788,7 +2788,7 @@
 		if (!request_region(board->hw_base, board->hw_len, "sx"))
 			continue;
 		board->base2 =
-		board->base = ioremap(board->hw_base, board->hw_len);
+		board->base = ioremap_nocache(board->hw_base, board->hw_len);
 		if (!board->base)
 			goto err_si_reg;
 		board->flags &= ~SX_BOARD_TYPE;
@@ -2811,7 +2811,7 @@
 		if (!request_region(board->hw_base, board->hw_len, "sx"))
 			continue;
 		board->base2 =
-		board->base = ioremap(board->hw_base, board->hw_len);
+		board->base = ioremap_nocache(board->hw_base, board->hw_len);
 		if (!board->base)
 			goto err_si1_reg;
 		board->flags &= ~SX_BOARD_TYPE;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/synclink.c linux-2.6.25-mm1/drivers/char/synclink.c
--- linux.vanilla-2.6.25-mm1/drivers/char/synclink.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/synclink.c	2008-04-28 10:08:03.000000000 +0100
@@ -4153,7 +4153,8 @@
 		}
 		info->lcr_mem_requested = true;
 
-		info->memory_base = ioremap(info->phys_memory_base,0x40000);
+		info->memory_base = ioremap_nocache(info->phys_memory_base,
+								0x40000);
 		if (!info->memory_base) {
 			printk( "%s(%d):Cant map shared memory on device %s MemAddr=%08X\n",
 				__FILE__,__LINE__,info->device_name, info->phys_memory_base );
@@ -4166,12 +4167,14 @@
 			goto errout;
 		}
 		
-		info->lcr_base = ioremap(info->phys_lcr_base,PAGE_SIZE) + info->lcr_offset;
+		info->lcr_base = ioremap_nocache(info->phys_lcr_base,
+								PAGE_SIZE);
 		if (!info->lcr_base) {
 			printk( "%s(%d):Cant map LCR memory on device %s MemAddr=%08X\n",
 				__FILE__,__LINE__,info->device_name, info->phys_lcr_base );
 			goto errout;
 		}
+		info->lcr_base += info->lcr_offset;
 		
 	} else {
 		/* claim DMA channel */
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/synclink_gt.c linux-2.6.25-mm1/drivers/char/synclink_gt.c
--- linux.vanilla-2.6.25-mm1/drivers/char/synclink_gt.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/synclink_gt.c	2008-04-28 10:08:18.000000000 +0100
@@ -3355,7 +3355,7 @@
 	else
 		info->reg_addr_requested = true;
 
-	info->reg_addr = ioremap(info->phys_reg_addr, SLGT_REG_SIZE);
+	info->reg_addr = ioremap_nocache(info->phys_reg_addr, SLGT_REG_SIZE);
 	if (!info->reg_addr) {
 		DBGERR(("%s cant map device registers, addr=%08X\n",
 			info->device_name, info->phys_reg_addr));
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/synclinkmp.c linux-2.6.25-mm1/drivers/char/synclinkmp.c
--- linux.vanilla-2.6.25-mm1/drivers/char/synclinkmp.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/synclinkmp.c	2008-04-28 10:09:02.000000000 +0100
@@ -3647,7 +3647,8 @@
 	else
 		info->sca_statctrl_requested = true;
 
-	info->memory_base = ioremap(info->phys_memory_base,SCA_MEM_SIZE);
+	info->memory_base = ioremap_nocache(info->phys_memory_base,
+								SCA_MEM_SIZE);
 	if (!info->memory_base) {
 		printk( "%s(%d):%s Cant map shared memory, MemAddr=%08X\n",
 			__FILE__,__LINE__,info->device_name, info->phys_memory_base );
@@ -3655,7 +3656,7 @@
 		goto errout;
 	}
 
-	info->lcr_base = ioremap(info->phys_lcr_base,PAGE_SIZE);
+	info->lcr_base = ioremap_nocache(info->phys_lcr_base, PAGE_SIZE);
 	if (!info->lcr_base) {
 		printk( "%s(%d):%s Cant map LCR memory, MemAddr=%08X\n",
 			__FILE__,__LINE__,info->device_name, info->phys_lcr_base );
@@ -3664,7 +3665,7 @@
 	}
 	info->lcr_base += info->lcr_offset;
 
-	info->sca_base = ioremap(info->phys_sca_base,PAGE_SIZE);
+	info->sca_base = ioremap_nocache(info->phys_sca_base, PAGE_SIZE);
 	if (!info->sca_base) {
 		printk( "%s(%d):%s Cant map SCA memory, MemAddr=%08X\n",
 			__FILE__,__LINE__,info->device_name, info->phys_sca_base );
@@ -3673,7 +3674,8 @@
 	}
 	info->sca_base += info->sca_offset;
 
-	info->statctrl_base = ioremap(info->phys_statctrl_base,PAGE_SIZE);
+	info->statctrl_base = ioremap_nocache(info->phys_statctrl_base,
+								PAGE_SIZE);
 	if (!info->statctrl_base) {
 		printk( "%s(%d):%s Cant map SCA Status/Control memory, MemAddr=%08X\n",
 			__FILE__,__LINE__,info->device_name, info->phys_statctrl_base );
