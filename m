Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbXJLQ7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbXJLQ7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbXJLQ7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:59:38 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:44499 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbXJLQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:59:37 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2007 12:59:36 EDT
Date: Fri, 12 Oct 2007 17:59:25 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-arch@vger.kernel.org, linux-mips@linux-mips.org
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] defxx: Discardable strings for init and exit sections
Message-ID: <Pine.LNX.4.64N.0710121751220.21684@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Move strings eligible for discarding to their respective sections.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 This patch together with the string discarding infrastructure sent 
separately is an example of how resulting code looks like.  It builds (for 
MIPS), it works, saving about 500 bytes of run-time memory.

  Maciej

patch-mips-2.6.23-rc5-20070904-defxx-inexitstr-3
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/net/defxx.c linux-mips-2.6.23-rc5-20070904/drivers/net/defxx.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/net/defxx.c	2007-09-04 04:55:41.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/net/defxx.c	2007-10-12 09:45:01.000000000 +0000
@@ -228,7 +228,7 @@
 #define DRV_VERSION "v1.10"
 #define DRV_RELDATE "2006/12/14"
 
-static char version[] __devinitdata =
+static const char version[] __devinitstr =
 	DRV_NAME ": " DRV_VERSION " " DRV_RELDATE
 	"  Lawrence V. Stefani and others\n";
 
@@ -527,14 +527,16 @@ static int __devinit dfx_register(struct
 
 	dev = alloc_fddidev(sizeof(*bp));
 	if (!dev) {
-		printk(KERN_ERR "%s: Unable to allocate fddidev, aborting\n",
+		printk(_di(KERN_ERR
+			   "%s: Unable to allocate fddidev, aborting\n"),
 		       print_name);
 		return -ENOMEM;
 	}
 
 	/* Enable PCI device. */
 	if (dfx_bus_pci && pci_enable_device(to_pci_dev(bdev))) {
-		printk(KERN_ERR "%s: Cannot enable PCI device, aborting\n",
+		printk(_di(KERN_ERR
+			   "%s: Cannot enable PCI device, aborting\n"),
 		       print_name);
 		goto err_out;
 	}
@@ -553,8 +555,8 @@ static int __devinit dfx_register(struct
 	else
 		region = request_region(bar_start, bar_len, print_name);
 	if (!region) {
-		printk(KERN_ERR "%s: Cannot reserve I/O resource "
-		       "0x%lx @ 0x%lx, aborting\n",
+		printk(_di(KERN_ERR "%s: Cannot reserve I/O resource "
+			   "0x%lx @ 0x%lx, aborting\n"),
 		       print_name, (long)bar_len, (long)bar_start);
 		err = -EBUSY;
 		goto err_out_disable;
@@ -564,7 +566,8 @@ static int __devinit dfx_register(struct
 	if (dfx_use_mmio) {
 		bp->base.mem = ioremap_nocache(bar_start, bar_len);
 		if (!bp->base.mem) {
-			printk(KERN_ERR "%s: Cannot map MMIO\n", print_name);
+			printk(_di(KERN_ERR "%s: Cannot map MMIO\n"),
+			       print_name);
 			err = -ENOMEM;
 			goto err_out_region;
 		}
@@ -594,7 +597,7 @@ static int __devinit dfx_register(struct
 	if (err)
 		goto err_out_kfree;
 
-	printk("%s: registered as %s\n", print_name, dev->name);
+	printk(_di("%s: registered as %s\n"), print_name, dev->name);
 	return 0;
 
 err_out_kfree:
@@ -670,7 +673,7 @@ static void __devinit dfx_bus_init(struc
 	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 	u8 val;
 
-	DBG_printk("In dfx_bus_init...\n");
+	DBG_printk(_di("In dfx_bus_init...\n"));
 
 	/* Initialize a pointer back to the net_device struct */
 	bp->dev = dev;
@@ -814,7 +817,7 @@ static void __devinit dfx_bus_uninit(str
 	int dfx_bus_eisa = DFX_BUS_EISA(bdev);
 	u8 val;
 
-	DBG_printk("In dfx_bus_uninit...\n");
+	DBG_printk(_de("In dfx_bus_uninit...\n"));
 
 	/* Uninitialize adapter based on bus type */
 
@@ -870,7 +873,7 @@ static void __devinit dfx_bus_config_che
 	int	status;				/* return code from adapter port control call */
 	u32	host_data;			/* LW data returned from port control call */
 
-	DBG_printk("In dfx_bus_config_check...\n");
+	DBG_printk(_di("In dfx_bus_config_check...\n"));
 
 	/* Configuration check only valid for EISA adapter */
 
@@ -973,9 +976,9 @@ static int __devinit dfx_driver_init(str
 	char *top_v, *curr_v;		/* virtual addrs into memory block */
 	dma_addr_t top_p, curr_p;	/* physical addrs into memory block */
 	u32 data, le32;			/* host data register value */
-	char *board_name = NULL;
+	const char *board_name = NULL;
 
-	DBG_printk("In dfx_driver_init...\n");
+	DBG_printk(_di("In dfx_driver_init...\n"));
 
 	/* Initialize bus-specific hardware registers */
 
@@ -1018,8 +1021,8 @@ static int __devinit dfx_driver_init(str
 
 	if (dfx_hw_port_ctrl_req(bp, PI_PCTRL_M_MLA, PI_PDATA_A_MLA_K_LO, 0,
 				 &data) != DFX_K_SUCCESS) {
-		printk("%s: Could not read adapter factory MAC address!\n",
-		       print_name);
+		printk(_di("%s: Could not read "
+			   "adapter factory MAC address!\n"), print_name);
 		return(DFX_K_FAILURE);
 	}
 	le32 = cpu_to_le32(data);
@@ -1027,8 +1030,8 @@ static int __devinit dfx_driver_init(str
 
 	if (dfx_hw_port_ctrl_req(bp, PI_PCTRL_M_MLA, PI_PDATA_A_MLA_K_HI, 0,
 				 &data) != DFX_K_SUCCESS) {
-		printk("%s: Could not read adapter factory MAC address!\n",
-		       print_name);
+		printk(_di("%s: Could not read "
+			   "adapter factory MAC address!\n"), print_name);
 		return(DFX_K_FAILURE);
 	}
 	le32 = cpu_to_le32(data);
@@ -1043,14 +1046,14 @@ static int __devinit dfx_driver_init(str
 
 	memcpy(dev->dev_addr, bp->factory_mac_addr, FDDI_K_ALEN);
 	if (dfx_bus_tc)
-		board_name = "DEFTA";
+		board_name = _di("DEFTA");
 	if (dfx_bus_eisa)
-		board_name = "DEFEA";
+		board_name = _di("DEFEA");
 	if (dfx_bus_pci)
-		board_name = "DEFPA";
-	pr_info("%s: %s at %saddr = 0x%llx, IRQ = %d, "
-		"Hardware addr = %02X-%02X-%02X-%02X-%02X-%02X\n",
-		print_name, board_name, dfx_use_mmio ? "" : "I/O ",
+		board_name = _di("DEFPA");
+	printk(_di(KERN_INFO "%s: %s at %saddr = 0x%llx, IRQ = %d, "
+		   "Hardware addr = %02X-%02X-%02X-%02X-%02X-%02X\n"),
+		print_name, board_name, dfx_use_mmio ? "" : _di("I/O "),
 		(long long)bar_start, dev->irq,
 		dev->dev_addr[0], dev->dev_addr[1], dev->dev_addr[2],
 		dev->dev_addr[3], dev->dev_addr[4], dev->dev_addr[5]);
@@ -1072,8 +1075,8 @@ static int __devinit dfx_driver_init(str
 						   &bp->kmalloced_dma,
 						   GFP_ATOMIC);
 	if (top_v == NULL) {
-		printk("%s: Could not allocate memory for host buffers "
-		       "and structures!\n", print_name);
+		printk(_di("%s: Could not allocate memory for host buffers "
+			   "and structures!\n"), print_name);
 		return(DFX_K_FAILURE);
 	}
 	memset(top_v, 0, alloc_size);	/* zero out memory before continuing */
@@ -1132,17 +1135,26 @@ static int __devinit dfx_driver_init(str
 
 	/* Display virtual and physical addresses if debug driver */
 
-	DBG_printk("%s: Descriptor block virt = %0lX, phys = %0X\n",
+	DBG_printk(_di("%s: Descriptor block "
+		       "virt = %0lX, phys = %0X\n"),
 		   print_name,
 		   (long)bp->descr_block_virt, bp->descr_block_phys);
-	DBG_printk("%s: Command Request buffer virt = %0lX, phys = %0X\n",
-		   print_name, (long)bp->cmd_req_virt, bp->cmd_req_phys);
-	DBG_printk("%s: Command Response buffer virt = %0lX, phys = %0X\n",
-		   print_name, (long)bp->cmd_rsp_virt, bp->cmd_rsp_phys);
-	DBG_printk("%s: Receive buffer block virt = %0lX, phys = %0X\n",
-		   print_name, (long)bp->rcv_block_virt, bp->rcv_block_phys);
-	DBG_printk("%s: Consumer block virt = %0lX, phys = %0X\n",
-		   print_name, (long)bp->cons_block_virt, bp->cons_block_phys);
+	DBG_printk(_di("%s: Command Request buffer "
+		       "virt = %0lX, phys = %0X\n"),
+		   print_name,
+		   (long)bp->cmd_req_virt, bp->cmd_req_phys);
+	DBG_printk(_di("%s: Command Response buffer "
+		       "virt = %0lX, phys = %0X\n"),
+		   print_name,
+		   (long)bp->cmd_rsp_virt, bp->cmd_rsp_phys);
+	DBG_printk(_di("%s: Receive buffer block "
+		       "virt = %0lX, phys = %0X\n"),
+		   print_name,
+		   (long)bp->rcv_block_virt, bp->rcv_block_phys);
+	DBG_printk(_di("%s: Consumer block "
+		       "virt = %0lX, phys = %0X\n"),
+		   print_name,
+		   (long)bp->cons_block_virt, bp->cons_block_phys);
 
 	return(DFX_K_SUCCESS);
 }
