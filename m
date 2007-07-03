Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbXGCOsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbXGCOsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXGCOsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:48:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47955 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753789AbXGCOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:48:08 -0400
Date: Tue, 3 Jul 2007 15:54:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: [PATCH] libata_acpi: A different strategy for using ACPI
 information
Message-ID: <20070703155417.11d81c75@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of BIOSen simply return the BIOS set modes via the ACPI methods and
pass back the values you give it across suspend/resume. Thus instead of
trying to do clever stuff with this data we instead use it as a way to
take a sneak peak at cable type information when viable. This should help
us catch more of the laptops that do weird stuff, the VIA SATA bridges
and the totally horked Nvidia cable handling.

For now its only used by the VIA and AMD/NV driver until we get a better
idea of whether this is a sensible idea or not.

Opinions ?

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-acpi.c linux-2.6.22-rc6-mm1/drivers/ata/libata-acpi.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-acpi.c	2007-07-02 20:50:11.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/libata-acpi.c	2007-07-02 21:02:24.000000000 +0100
@@ -296,6 +296,44 @@
 }
 
 /**
+ * ata_acpi_cbl_80wire		-	Check for 80 wire cable
+ * @ap: Port to check
+ *
+ * Return 1 if the ACPI mode data for this port indicates the BIOS selected
+ * an 80wire mode.
+ */
+
+int ata_acpi_cbl_80wire(struct ata_port *ap)
+{
+	struct ata_acpi_gtm gtm;
+	int valid = 0;
+	
+	/* No _GTM data, no information */
+	if (ata_acpi_gtm(ap, &gtm) < 0)
+		return 0;
+		
+	/* Split timing, DMA enabled */
+	if ((gtm.flags & 0x11) == 0x11 && gtm.drive[0].dma < 55)
+		valid |= 1;
+	if ((gtm.flags & 0x14) == 0x14 && gtm.drive[1].dma < 55)
+		valid |= 2;
+	/* Shared timing, DMA enabled */
+	if ((gtm.flags & 0x11) == 0x01 && gtm.drive[0].dma < 55)
+		valid |= 1;
+	if ((gtm.flags & 0x14) == 0x04 && gtm.drive[0].dma < 55)
+		valid |= 2;
+
+	/* Drive check */
+	if ((valid & 1) && ata_dev_enabled(&ap->device[0]))
+		return 1;
+	if ((valid & 2) && ata_dev_enabled(&ap->device[1]))
+		return 1;
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
+
+/**
  * taskfile_load_raw - send taskfile registers to host controller
  * @dev: target ATA device
  * @gtf: raw ATA taskfile register set (0x1f1 - 0x1f7)
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/include/linux/libata.h linux-2.6.22-rc6-mm1/include/linux/libata.h
--- linux.vanilla-2.6.22-rc6-mm1/include/linux/libata.h	2007-07-02 20:50:14.000000000 +0100
+++ linux-2.6.22-rc6-mm1/include/linux/libata.h	2007-07-02 21:29:18.000000000 +0100
@@ -867,6 +872,13 @@
 				  ATA_TIMING_CYCLE | ATA_TIMING_UDMA,
 };
 
+/* libata-acpi.c */
+#ifdef CONFIG_ATA_ACPI
+extern int ata_acpi_cbl_80wire(struct ata_port *ap);
+#else
+static inline int ata_acpi_cbl_80wire(struct ata_port *ap) { return 0; }
+#endif
+
 
 #ifdef CONFIG_PCI
 struct pci_bits {
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_amd.c linux-2.6.22-rc6-mm1/drivers/ata/pata_amd.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_amd.c	2007-07-02 20:50:11.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/pata_amd.c	2007-07-02 21:03:00.000000000 +0100
@@ -268,6 +268,9 @@
  	pci_read_config_word(pdev, 0x62 - 2 * ap->port_no, &udma);
  	if ((udma & 0xC4) == 0xC4 || (udma & 0xC400) == 0xC400)
 		cbl = ATA_CBL_PATA80;
+	/* And a triple check across suspend/resume with ACPI around */
+	if (ata_acpi_cbl_80wire(ap))
+		cbl = ATA_CBL_PATA80;
 	return cbl;
 }
 
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_via.c linux-2.6.22-rc6-mm1/drivers/ata/pata_via.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_via.c	2007-07-02 20:48:49.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/pata_via.c	2007-07-02 21:04:59.000000000 +0100
@@ -180,6 +180,9 @@
 	   two drives */
 	if (ata66 & (0x10100000 >> (16 * ap->port_no)))
 		return ATA_CBL_PATA80;
+	/* Check with ACPI so we can spot BIOS reported SATA bridges */
+	if (ata_acpi_cbl_80wire(ap))
+		return ATA_CBL_PATA80;
 	return ATA_CBL_PATA40;
 }
 
