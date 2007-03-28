Return-Path: <linux-kernel-owner+w=401wt.eu-S934070AbXC1XsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbXC1XsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934046AbXC1Xrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:47:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:6051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934070AbXC1Xrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:47:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,342,1170662400"; 
   d="scan'208"; a="218216353:sNHT164394258"
Date: Wed, 28 Mar 2007 16:44:57 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 3/3] libata: handle AN interrupt
Message-Id: <20070328164457.a675a7d2.kristen.c.accardi@intel.com>
In-Reply-To: <20070328230108.597741522@intel.com>
References: <20070328230108.597741522@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When we get an SDB FIS with the 'N' bit set, we should send
an event to user space to indicate that there has been a
media change.  The ahci host controller will send the
event via KOBJ_CHANGE uevent.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-mm/drivers/ata/ahci.c
===================================================================
--- 2.6-mm.orig/drivers/ata/ahci.c
+++ 2.6-mm/drivers/ata/ahci.c
@@ -1164,6 +1164,26 @@ static void ahci_host_intr(struct ata_po
 		return;
 	}
 
+	if (status & PORT_IRQ_SDB_FIS) {
+		/*
+		 * if this is an ATAPI device with AN turned on,
+		 * then we should interrogate the device to
+		 * determine the cause of the interrupt
+		 *
+		 * for AN - this we should check the SDB FIS
+		 * and find the I and N bits set
+		 */
+		const u32 *f = pp->rx_fis + RX_FIS_SDB;
+
+		/* check the 'N' bit in word 0 of the FIS */
+		if (f[0] & (1 << 15)) {
+			int port_addr =  ((f[0] & 0x00000f00) >> 8);
+			struct ata_device *adev = &ap->device[port_addr];
+			ata_port_printk(ap, KERN_INFO, "N bit set on SDB FIS!\n");
+			if (adev->flags & ATA_DFLAG_AN)
+				ata_async_notify(adev);
+		}
+	}
 	if (ap->sactive)
 		qc_active = readl(port_mmio + PORT_SCR_ACT);
 	else
Index: 2.6-mm/include/linux/libata.h
===================================================================
--- 2.6-mm.orig/include/linux/libata.h
+++ 2.6-mm/include/linux/libata.h
@@ -492,6 +492,7 @@ struct ata_device {
 	/* ACPI objects info */
 	acpi_handle obj_handle;
 #endif
+	struct work_struct	async_notify;
 };
 
 /* Offset into struct ata_device.  Fields above it are maintained
@@ -826,6 +827,7 @@ extern void ata_scsi_slave_destroy(struc
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
+extern void ata_async_notify(struct ata_device *atadev);
 extern int ata_do_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev);
 extern u8 ata_irq_on(struct ata_port *ap);
 extern u8 ata_dummy_irq_on(struct ata_port *ap);
Index: 2.6-mm/drivers/ata/libata-core.c
===================================================================
--- 2.6-mm.orig/drivers/ata/libata-core.c
+++ 2.6-mm/drivers/ata/libata-core.c
@@ -1576,6 +1576,26 @@ static void ata_dev_config_ncq(struct at
 		snprintf(desc, desc_sz, "NCQ (depth %d/%d)", hdepth, ddepth);
 }
 
+static void async_notify_thread(struct work_struct *work)
+{
+	struct ata_device *atadev =
+		container_of(work, struct ata_device, async_notify);
+
+	/*
+	 * TBD - who should send this event?  I couldn't find an
+	 * easy way to map an ata_device to a genhd device, so
+	 * decided maybe the ata host should send the event and
+	 * allow user space to figure out what happened?
+	 */
+	kobject_uevent(&atadev->ap->host->dev->kobj, KOBJ_CHANGE);
+}
+
+void ata_async_notify(struct ata_device *atadev)
+{
+	schedule_work(&atadev->async_notify);
+}
+
+
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -1761,6 +1781,7 @@ int ata_dev_configure(struct ata_device 
 				goto err_out_nosup;
 			}
 			dev->flags |= ATA_DFLAG_AN;
+			INIT_WORK(&dev->async_notify, async_notify_thread);
 		}
 
 		if (ata_id_cdb_intr(dev->id)) {
@@ -6650,6 +6671,7 @@ EXPORT_SYMBOL_GPL(ata_dummy_irq_on);
 EXPORT_SYMBOL_GPL(ata_irq_ack);
 EXPORT_SYMBOL_GPL(ata_dummy_irq_ack);
 EXPORT_SYMBOL_GPL(ata_dev_try_classify);
+EXPORT_SYMBOL_GPL(ata_async_notify);
 
 EXPORT_SYMBOL_GPL(ata_cable_40wire);
 EXPORT_SYMBOL_GPL(ata_cable_80wire);

-- 
