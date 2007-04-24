Return-Path: <linux-kernel-owner+w=401wt.eu-S1030950AbXDXADo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030950AbXDXADo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161159AbXDXADC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:03:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:18189 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030937AbXDXAC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,443,1170662400"; 
   d="scan'208"; a="235480165:sNHT109040190"
Date: Mon, 23 Apr 2007 17:00:24 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 7/7] libata: send event when AN received
Message-Id: <20070423170024.73b74a37.kristen.c.accardi@intel.com>
In-Reply-To: <20070424074856.005152262@intel.com>
References: <20070424074856.005152262@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When we get an SDB FIS with the 'N' bit set, we should send
an event to user space to indicate that there has been a
media change.  This will be done via the block device. 

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-git/drivers/ata/ahci.c
===================================================================
--- 2.6-git.orig/drivers/ata/ahci.c
+++ 2.6-git/drivers/ata/ahci.c
@@ -1147,6 +1147,25 @@ static void ahci_host_intr(struct ata_po
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
+			if (adev->flags & ATA_DFLAG_AN)
+				ata_scsi_media_change_notify(adev);
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
@@ -3057,6 +3057,22 @@ static void ata_scsi_remove_dev(struct a
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
+	genhd_media_change_notify(atadev->sdev->disk);
+}
+EXPORT_SYMBOL_GPL(ata_scsi_media_change_notify);
+
+/**
  *	ata_scsi_hotplug - SCSI part of hotplug
  *	@work: Pointer to ATA port to perform SCSI hotplug on
  *

-- 
