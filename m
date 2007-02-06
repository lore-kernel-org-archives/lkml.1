Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbXBFNde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbXBFNde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXBFNde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:33:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56280 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752118AbXBFNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:33:32 -0500
Date: Tue, 6 Feb 2007 13:46:23 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: [PATCH] pata_acpi driver
Message-ID: <20070206134623.0dc3f566@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

An ACPI[1] firmware driver for motherboard PATA ports.

Drives conventional IDE interface ports that have ACPI methods for
firmware control. Generally this means the motherboard ide0/ide1 PATA
ports, regardless of controller. It may not cover some controllers in
non-legacy mode however.

This is linked near the end so that with built in drivers it will grab
only ports that lack native drivers. The libata-acpi code is designed
to be reusable as we will want to borrow a couple of bits for VIA and
Nvidia cable detect.

Give it a test, see what it does. I don't entirely trust this code as it
worked first time on my machine and that makes me suspicious..

Alan
[1] Another Crap Proposal Intel ;)

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/ata/Kconfig linux-2.6.20-rc6-mm3/drivers/ata/Kconfig
--- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/Kconfig	2007-01-31 14:20:39.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/ata/Kconfig	2007-02-05 22:43:06.000000000 +0000
@@ -174,6 +174,15 @@
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
+config PATA_ACPI
+	tristate "ACPI firmware driver for PATA"
+	depends on ACPI && PCI && SATA_ACPI
+	help
+	  This option enables an ACPI method driver which drives
+	  motherboard PATA controller interfaces through the ACPI
+	  firmware in the BIOS. This driver can sometimes handle
+	  otherwise unsupported hardware.
+
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/ata/libata-acpi.c linux-2.6.20-rc6-mm3/drivers/ata/libata-acpi.c
--- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/libata-acpi.c	2007-01-31 14:20:39.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/ata/libata-acpi.c	2007-02-05 22:21:39.000000000 +0000
@@ -15,7 +15,7 @@
 #include <linux/libata.h>
 #include <linux/pci.h>
 #include "libata.h"
-
+#include "libata-acpi.h"
 #include <acpi/acpi_bus.h>
 #include <acpi/acnames.h>
 #include <acpi/acnamesp.h>
@@ -696,3 +696,91 @@
 }
 
 
+int ata_acpi_gtm(const struct ata_port *ap, void *handle, struct acpi_gtm *gtm)
+{
+	acpi_status status;
+	struct acpi_buffer output;
+	
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+	
+	status = acpi_evaluate_object(handle, "_GTM", NULL, &output);
+	
+	if (ACPI_FAILURE(status)) {
+		ata_port_printk(ap, KERN_ERR, "ACPI get timing mode failed.\n");
+		return -EINVAL;
+	}
+	if (output.length < sizeof(struct acpi_gtm) || output.pointer == NULL) {
+		ata_port_printk(ap, KERN_ERR, "ACPI get timing provided invalid data.\n");
+		return -EINVAL;
+	}
+	memcpy(gtm, output.pointer, sizeof(struct acpi_gtm));
+	kfree(output.pointer);
+	return 0;
+}
+
+int ata_acpi_stm(const struct ata_port *ap, void *handle, struct acpi_gtm *stm)
+{
+	acpi_status status;
+	struct acpi_object_list         input;
+	union acpi_object               in_params[3];
+
+	in_params[0].type = ACPI_TYPE_BUFFER;
+	in_params[0].buffer.length = sizeof(struct acpi_gtm);
+	in_params[0].buffer.pointer = (u8 *)stm;
+	/* Buffers for id may need byteswapping ? */
+	in_params[1].type = ACPI_TYPE_BUFFER;
+	in_params[1].buffer.length = 512;
+	in_params[1].buffer.pointer = (u8 *)ap->device[0].id;
+	in_params[2].type = ACPI_TYPE_BUFFER;
+	in_params[2].buffer.length = 512;
+	in_params[1].buffer.pointer = (u8 *)ap->device[1].id;
+	
+	input.count = 3;
+	input.pointer = in_params;
+	
+	status = acpi_evaluate_object(handle, "_STM", &input, NULL);
+	
+	if (ACPI_FAILURE(status)) {
+		ata_port_printk(ap, KERN_ERR, "ACPI set timing mode failed.\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void *ata_pata_find_handle(struct device *dev, int port)
+{
+	acpi_handle handle, *chan_handle;
+	acpi_integer devfn;
+
+	if (noacpi)
+		return NULL;
+	if (pata_get_dev_handle(dev, &handle, &devfn) < 0)
+		return NULL;
+	chan_handle = acpi_get_child(handle, port);
+	if (chan_handle == NULL)
+		return NULL;
+	return chan_handle;
+}
+
+void *ata_pata_acpi_handle(const struct ata_port *ap)
+{
+	return ata_pata_find_handle(ap->host->dev, ap->port_no);
+}
+
+int ata_pata_acpi_present(struct pci_dev *pdev)
+{
+	int present = 0;
+	
+	if(ata_pata_find_handle(&pdev->dev, 0))
+		present |= 1;
+	if(ata_pata_find_handle(&pdev->dev, 1))
+		present |= 2;
+	return present;
+}
+
+
+EXPORT_SYMBOL_GPL(ata_acpi_gtm);
+EXPORT_SYMBOL_GPL(ata_acpi_stm);
+EXPORT_SYMBOL_GPL(ata_pata_acpi_handle);
+EXPORT_SYMBOL_GPL(ata_pata_acpi_present);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/ata/libata-acpi.h linux-2.6.20-rc6-mm3/drivers/ata/libata-acpi.h
--- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/libata-acpi.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.20-rc6-mm3/drivers/ata/libata-acpi.h	2007-02-05 22:21:55.000000000 +0000
@@ -0,0 +1,47 @@
+/*
+ *  libata-acpi.h - helper library for ATA ACPI drivers
+ *
+ *  Copyright 2007 Red Hat, Inc.  All rights reserved.
+ *  Copyright 2007 Alan Cox
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ *  libata documentation is available via 'make {ps|pdf}docs',
+ *  as Documentation/DocBook/libata.*
+ *
+ */
+
+#ifndef __LIBATA_ACPI_H__
+#define __LIBATA_ACPI_H__
+
+struct acpi_drive
+{
+	u32 pio;
+	u32 dma;
+};
+
+struct acpi_gtm {
+	struct acpi_drive drive[2];
+	u32 flags;
+};
+
+extern int ata_acpi_gtm(const struct ata_port *p, void *handle, struct acpi_gtm *gtm);
+extern int ata_acpi_stm(const struct ata_port *ap, void *handle, struct acpi_gtm *stm);
+extern void *ata_pata_acpi_handle(const struct ata_port *ap);
+extern int ata_pata_acpi_present(struct pci_dev *pdev);
+
+#endif
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/ata/Makefile linux-2.6.20-rc6-mm3/drivers/ata/Makefile
--- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/Makefile	2007-01-31 14:20:39.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/ata/Makefile	2007-02-05 21:15:04.000000000 +0000
@@ -60,6 +60,8 @@
 obj-$(CONFIG_PATA_TRIFLEX)	+= pata_triflex.o
 obj-$(CONFIG_PATA_IXP4XX_CF)	+= pata_ixp4xx_cf.o
 obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
+# Should be last but two libata driver
+obj-$(CONFIG_PATA_ACPI)		+= pata_acpi.o
 # Should be last but one libata driver
 obj-$(CONFIG_ATA_GENERIC)	+= ata_generic.o
 # Should be last libata driver
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/ata/pata_acpi.c linux-2.6.20-rc6-mm3/drivers/ata/pata_acpi.c
--- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/pata_acpi.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.20-rc6-mm3/drivers/ata/pata_acpi.c	2007-02-06 11:31:55.000000000 +0000
@@ -0,0 +1,398 @@
+/*
+ *	ACPI PATA driver
+ *
+ *	(c) 2007 Red Hat  <alan@redhat.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <scsi/scsi_host.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acnames.h>
+#include <acpi/acnamesp.h>
+#include <acpi/acparser.h>
+#include <acpi/acexcep.h>
+#include <acpi/acmacros.h>
+#include <acpi/actypes.h>
+
+#include <linux/libata.h>
+#include <linux/ata.h>
+
+#include "libata-acpi.h"
+
+#define DRV_NAME	"pata_acpi"
+#define DRV_VERSION	"0.0.1"
+
+struct pata_acpi {
+	void *handle;
+	struct acpi_gtm gtm;
+	void *last;
+};
+
+/**
+ *	pacpi_pre_reset	-	check for 40/80 pin
+ *	@ap: Port
+ *
+ *	Perform the PATA port setup we need.
+ */
+
+static int pacpi_pre_reset(struct ata_port *ap)
+{
+	struct pata_acpi *acpi = ap->private_data;
+	int i;
+	
+	if (acpi->handle == NULL || ata_acpi_gtm(ap, acpi->handle, &acpi->gtm) < 0)
+		return -ENODEV;
+	ap->cbl = ATA_CBL_PATA40;
+
+	/* If the firmware proposed mode is UDMA3 or better then we know
+	   it is 80wire, or 40wire short */
+	for (i = 0; i < 2; i++) {
+		if (acpi->gtm.flags & (1 << 2 * i))	/* UDMA in use ? */
+			if (acpi->gtm.drive[i].dma < 55)	/* 60nS is UDMA2 */
+				ap->cbl = ATA_CBL_PATA80;
+	}
+	return ata_std_prereset(ap);
+}
+
+/**
+ *	pacpi_error_handler - Setup and error handler
+ *	@ap: Port to handle
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void pacpi_error_handler(struct ata_port *ap)
+{
+	return ata_bmdma_drive_eh(ap, pacpi_pre_reset, ata_std_softreset,
+				  NULL, ata_std_postreset);
+}
+
+/* Welcome to ACPI, bring a bucket */
+static const unsigned int pio_cycle[7] = {
+	600, 383, 240, 180, 120, 100, 80
+};
+static const unsigned int mwdma_cycle[5] = {
+	480, 150, 120, 100, 80
+};
+static const unsigned int udma_cycle[7] = {
+	120, 80, 60, 45, 30, 20, 15
+};
+
+/**
+ *	pacpi_mode_filter	-	filter non ACPI modes
+ *	@adev: ATA device
+ *	@mask: proposed modes
+ *
+ *	Try the modes available and see which ones the ACPI method will
+ *	set up sensibly. From this we get a mask of ACPI modes we can use
+ */
+
+static unsigned long pacpi_mode_filter(const struct ata_port *ap, struct ata_device *adev, unsigned long mask)
+{
+	int unit = adev->devno;
+	struct pata_acpi *acpi = ap->private_data;
+	int i;
+	u32 t;
+	
+	/* We always use the 0 slot for crap hardware */
+	if (!(acpi->gtm.flags & 0x10))
+		unit = 0;
+
+	/* In order to generate a valid mode mask as we need cycle through
+	   trying each proposed speed in turn */
+   
+	/* Start by scanning for PIO modes */
+	for (i = 0; i < 7; i++) {
+		acpi->gtm.drive[unit].pio = pio_cycle[i];
+		ata_acpi_stm(ap, acpi->handle, &acpi->gtm);
+		ata_acpi_gtm(ap, acpi->handle, &acpi->gtm);
+		t = acpi->gtm.drive[unit].pio;
+		if (t == 0xFFFFFFFF || (i &&  t >= pio_cycle[i-1]))
+			mask &= ~(1 << (i + ATA_SHIFT_PIO));
+	}
+	
+	/* Select MWDMA */
+	acpi->gtm.flags &= ~(1 << (2 * unit));
+	
+	/* Scan for MWDMA modes */
+	for (i = 0; i < 5; i++) {
+		u32 t;
+		acpi->gtm.drive[unit].dma = mwdma_cycle[i];
+		ata_acpi_stm(ap, acpi->handle, &acpi->gtm);
+		ata_acpi_gtm(ap, acpi->handle, &acpi->gtm);
+		
+		t = acpi->gtm.drive[unit].dma;
+
+		if (t == 0xFFFFFFFF || (i && t >= mwdma_cycle[i-1]))
+			mask &= ~ (1 << (i + ATA_SHIFT_MWDMA));
+	}
+
+	/* Select UDMA */
+	acpi->gtm.flags |= (1 << (2 * unit));
+	
+	/* Scan for UDMA modes */
+	for (i = 0; i < 7; i++) {
+		u32 t;
+		acpi->gtm.drive[unit].dma = udma_cycle[i];
+		ata_acpi_stm(ap, acpi->handle, &acpi->gtm);
+		ata_acpi_gtm(ap, acpi->handle, &acpi->gtm);
+		
+		t = acpi->gtm.drive[unit].dma;
+
+		if (t == 0xFFFFFFFF || (i && t >= udma_cycle[i-1]))
+			mask &= ~ (1 << (i + ATA_SHIFT_UDMA));
+	}
+	
+	/* And finally we can hand back the list of speeds that actually are
+	   supported by the BIOS */
+	return ata_pci_default_filter(ap, adev, mask);
+}
+
+/**
+ *	pacpi_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ */
+
+static void pacpi_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	int unit = adev->devno;
+	struct pata_acpi *acpi = ap->private_data;
+
+	if(!(acpi->gtm.flags & 0x10))
+		unit = 0;
+
+	/* Now stuff the nS values into the structure */
+	acpi->gtm.drive[unit].pio = pio_cycle[adev->pio_mode - XFER_PIO_0];
+	ata_acpi_stm(ap, acpi->handle, &acpi->gtm);
+	/* See what mode we actually got */
+	ata_acpi_gtm(ap, acpi->handle, &acpi->gtm);
+}
+
+/**
+ *	pacpi_set_dmamode	-	set initial DMA mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ */
+
+static void pacpi_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	int unit = adev->devno;
+	struct pata_acpi *acpi = ap->private_data;
+
+	if(!(acpi->gtm.flags & 0x10))
+		unit = 0;
+
+	/* Now stuff the nS values into the structure */
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		acpi->gtm.drive[unit].dma = udma_cycle[adev->dma_mode - XFER_UDMA_0];
+		acpi->gtm.flags |= (1 << (2 * unit));
+	} else {
+		acpi->gtm.drive[unit].dma = mwdma_cycle[adev->dma_mode - XFER_MW_DMA_0];
+		acpi->gtm.flags &= ~(1 << (2 * unit));
+	}
+	ata_acpi_stm(ap, acpi->handle, &acpi->gtm);
+	/* See what mode we actually got */
+	ata_acpi_gtm(ap, acpi->handle, &acpi->gtm);
+}
+
+/**
+ *	pacpi_qc_issue_prot	-	command issue
+ *	@qc: command pending
+ *
+ *	Called when the libata layer is about to issue a command. We wrap
+ *	this interface so that we can load the correct ATA timings if
+ *	neccessary. 
+ */
+
+static unsigned int pacpi_qc_issue_prot(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_device *adev = qc->dev;
+	struct pata_acpi *acpi = ap->private_data;
+
+	if (acpi->gtm.flags & 0x10)
+		return ata_qc_issue_prot(qc);
+		
+	if (adev != acpi->last) {
+		pacpi_set_piomode(ap, adev);
+		if (adev->dma_mode)
+			pacpi_set_dmamode(ap, adev);
+		acpi->last = adev;
+	}
+	return ata_qc_issue_prot(qc);
+}
+
+/**
+ *	pacpi_port_start	-	port setup
+ *	@ap: ATA port being set up
+ *
+ *	Use the port_start hook to maintain private control structures
+ */
+
+static int pacpi_port_start(struct ata_port *ap)
+{
+	struct pata_acpi *acpi;
+	
+	int ret = ata_port_start(ap);
+	if (ret < 0)
+		return ret;
+
+	acpi = ap->private_data = kzalloc(sizeof(struct pata_acpi), GFP_KERNEL);
+	if (ap->private_data == NULL) {
+		ata_port_stop(ap);
+		return -ENOMEM;
+	}
+	acpi->handle = ata_pata_acpi_handle(ap);
+	return ret;
+}
+
+/**
+ *	pacpi_port_stop	-	port shutdown
+ *	@ap: ATA port being removed
+ *
+ *	Release the private objects we added in pacpi_port_start
+ */
+
+static void pacpi_port_stop(struct ata_port *ap) {
+	kfree(ap->private_data);
+	ap->private_data = NULL;	/* We want an OOPS if we reuse this
+					   too late! */
+	ata_port_stop(ap);
+}
+
+
+
+static struct scsi_host_template pacpi_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= ata_scsi_queuecmd,
+	.can_queue		= ATA_DEF_QUEUE,
+	.this_id		= ATA_SHT_THIS_ID,
+	.sg_tablesize		= LIBATA_MAX_PRD,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+	.proc_name		= DRV_NAME,
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	/* Use standard CHS mapping rules */
+	.bios_param		= ata_std_bios_param,
+	.resume			= ata_scsi_device_resume,
+	.suspend		= ata_scsi_device_suspend,
+};
+
+static const struct ata_port_operations pacpi_ops = {
+	.port_disable		= ata_port_disable,
+	.set_piomode		= pacpi_set_piomode,
+	.set_dmamode		= pacpi_set_dmamode,
+	.mode_filter		= pacpi_mode_filter,
+
+	/* Task file is PCI ATA format, use helpers */
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.check_status		= ata_check_status,
+	.exec_command		= ata_exec_command,
+	.dev_select		= ata_std_dev_select,
+
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= pacpi_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+
+	/* BMDMA handling is PCI ATA format, use helpers */
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+	.qc_prep		= ata_qc_prep,
+	.qc_issue		= pacpi_qc_issue_prot,
+	.data_xfer		= ata_pio_data_xfer,
+
+	/* Timeout handling */
+	.irq_handler		= ata_interrupt,
+	.irq_clear		= ata_bmdma_irq_clear,
+
+	/* Generic PATA PCI ATA helpers */
+	.port_start		= pacpi_port_start,
+	.port_stop		= pacpi_port_stop,
+	.host_stop		= ata_host_stop,
+};
+
+
+/**
+ *	pacpi_init_one - Register ACPI ATA PCI device with kernel services
+ *	@pdev: PCI device to register
+ *	@ent: Entry in pacpi_pci_tbl matching with @pdev
+ *
+ *	Called from kernel PCI layer.
+ *
+ *	LOCKING:
+ *	Inherited from PCI layer (may sleep).
+ *
+ *	RETURNS:
+ *	Zero on success, or -ERRNO value.
+ */
+
+static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	static struct ata_port_info info = {
+		.sht		= &pacpi_sht,
+		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+
+		.pio_mask	= 0x1f,
+		.mwdma_mask	= 0x07,
+		.udma_mask 	= 0x3f,
+
+		.port_ops	= &pacpi_ops,
+	};
+	struct ata_port_info *port_info[2] = { &info };
+	int n_port = 1;
+	
+	if (!ata_pata_acpi_present(pdev))
+		return -ENODEV;
+	return ata_pci_init_one(pdev, port_info, n_port);
+}
+
+static const struct pci_device_id pacpi_pci_tbl[] = {
+	{ PCI_ANY_ID,		PCI_ANY_ID,			   PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 1},
+	{ }	/* terminate list */
+};
+
+static struct pci_driver pacpi_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= pacpi_pci_tbl,
+	.probe			= pacpi_init_one,
+	.remove			= ata_pci_remove_one,
+	.suspend		= ata_pci_device_suspend,
+	.resume			= ata_pci_device_resume,
+};
+
+static int __init pacpi_init(void)
+{
+	return pci_register_driver(&pacpi_pci_driver);
+}
+
+static void __exit pacpi_exit(void)
+{
+	pci_unregister_driver(&pacpi_pci_driver);
+}
+
+module_init(pacpi_init);
+module_exit(pacpi_exit);
+
+MODULE_AUTHOR("Alan Cox");
+MODULE_DESCRIPTION("SCSI low-level driver for ATA in ACPI mode");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, pacpi_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
+
