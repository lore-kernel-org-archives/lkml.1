Return-Path: <linux-kernel-owner+w=401wt.eu-S938435AbXHHTMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938435AbXHHTMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965081AbXHHTLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:11:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:52038 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965033AbXHHTL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:11:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,237,1183359600"; 
   d="scan'208";a="276322311"
Date: Wed, 8 Aug 2007 12:08:38 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 4/4] libata: send event when AN received
Message-Id: <20070808120838.63d2ba1f.kristen.c.accardi@intel.com>
In-Reply-To: <20070808190613.616085010@localhost.localdomain>
References: <20070808190613.616085010@localhost.localdomain>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When we get an SDB FIS with the 'N' bit set, we should send
an event to user space to indicate that there has been a
media change.  This will be done via the scsi device. 

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-git/drivers/ata/ahci.c
===================================================================
--- 2.6-git.orig/drivers/ata/ahci.c
+++ 2.6-git/drivers/ata/ahci.c
@@ -1359,6 +1359,28 @@ static void ahci_port_intr(struct ata_po
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
+			struct ata_device *adev;
+			if (port_addr < ATA_MAX_DEVICES) {
+				adev = &ap->device[port_addr];
+				if (adev->flags & ATA_DFLAG_AN)
+					ata_scsi_media_change_notify(adev);
+			}
+		}
+	}
 	if (ap->sactive)
 		qc_active = readl(port_mmio + PORT_SCR_ACT);
 	else
Index: 2.6-git/include/linux/libata.h
===================================================================
--- 2.6-git.orig/include/linux/libata.h
+++ 2.6-git/include/linux/libata.h
@@ -737,6 +737,7 @@ extern void ata_host_init(struct ata_hos
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
+extern void ata_scsi_media_change_notify(struct ata_device *atadev);
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
Index: 2.6-git/drivers/ata/libata-scsi.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-scsi.c
+++ 2.6-git/drivers/ata/libata-scsi.c
@@ -3099,6 +3099,22 @@ static void ata_scsi_remove_dev(struct a
 }
 
 /**
+ *	ata_scsi_media_change_notify - send media change event
+ *	@atadev: Pointer to the disk device with media change event
+ *
+ *	Tell the block layer to send a media change notification
+ *	event.
+ *
+ * 	LOCKING:
+ * 	interrupt context, may not sleep.
+ */
+void ata_scsi_media_change_notify(struct ata_device *atadev)
+{
+	scsi_device_event_notify(atadev->sdev, SDEV_MEDIA_CHANGE);
+}
+EXPORT_SYMBOL_GPL(ata_scsi_media_change_notify);
+
+/**
  *	ata_scsi_hotplug - SCSI part of hotplug
  *	@work: Pointer to ATA port to perform SCSI hotplug on
  *

-- 
