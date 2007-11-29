Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbXK2Ruu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbXK2Ruu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932121AbXK2Ruh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:50:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:47339 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760880AbXK2Ruf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:50:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,230,1194249600"; 
   d="scan'208";a="408056836"
Date: Thu, 29 Nov 2007 09:48:02 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] ata: ahci: Enclosure Management via LED
Message-ID: <20071129094802.49e729ed@appleyard>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements Enclosure Management via the LED protocol.  See
the AHCI 1.1 spec for details.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
---
Here's a new version of the Enclosure management patch I sent a few
weeks ago.  I tried to incorporate all the feedback, although I'm
still checking on whether it's ok to use these capability bits on
a 1.0 ahci device.  Please let me know if there are additional
changes needed.

 drivers/ata/ahci.c        |  152 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-scsi.c |    5 +-
 include/linux/libata.h    |    2 +
 3 files changed, 155 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 2c686b4..5f22132 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -44,6 +44,7 @@
 #include <linux/dmi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <linux/libata.h>
 
 #define DRV_NAME	"ahci"
@@ -92,6 +93,8 @@ enum {
 	HOST_IRQ_STAT		= 0x08, /* interrupt status */
 	HOST_PORTS_IMPL		= 0x0c, /* bitmap of implemented ports */
 	HOST_VERSION		= 0x10, /* AHCI spec. version compliancy */
+	HOST_EM_LOC		= 0x1c, /* Enclosure Management location */
+	HOST_EM_CTL		= 0x20, /* Enclosure Management Control */
 
 	/* HOST_CTL bits */
 	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
@@ -99,6 +102,7 @@ enum {
 	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
 
 	/* HOST_CAP bits */
+	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
 	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
 	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
 	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
@@ -193,6 +197,10 @@ enum {
 					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
 					  ATA_FLAG_IPM,
 	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
+
+	/* em_ctl bits */
+	EM_CTL_RST			= (1 << 9), /* Reset */
+	EM_CTL_TM			= (1 << 8), /* Transmit Message */
 };
 
 struct ahci_cmd_hdr {
@@ -216,6 +224,7 @@ struct ahci_host_priv {
 	u32			port_map;	/* port map to use */
 	u32			saved_cap;	/* saved initial cap */
 	u32			saved_port_map;	/* saved initial port_map */
+	u32 			em_loc; /* enclosure management location */
 };
 
 struct ahci_port_priv {
@@ -231,6 +240,7 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
 	u32 			intr_mask;	/* interrupts to enable */
+	u16			led_state;	/* saved current led state */
 };
 
 static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
@@ -572,6 +582,11 @@ static struct pci_driver ahci_pci_driver = {
 #endif
 };
 
+static int ahci_em_messages = 1;
+module_param(ahci_em_messages, int, 0444);
+/* add other LED protocol types when they become supported */
+MODULE_PARM_DESC(ahci_em_messages,
+	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");
 
 static inline int ahci_nr_ports(u32 cap)
 {
@@ -1082,6 +1097,116 @@ static int ahci_reset_controller(struct ata_host *host)
 	return 0;
 }
 
+/****** LED Enclosure Management routines ********/
+static int ahci_reset_em(struct ata_host *host)
+{
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	u32 em_ctl;
+
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if ((em_ctl & EM_CTL_TM) || (em_ctl & EM_CTL_RST))
+		return -EINVAL;
+
+	writel(em_ctl | EM_CTL_RST, mmio + HOST_EM_CTL);
+	return 0;
+}
+
+static int ahci_transmit_led_message(struct ata_port *ap, int led_num,
+			int state)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 em_ctl;
+	u32 message[] = {0, 0};
+	unsigned int flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	/*
+	 * if we are still busy transmitting a previous message,
+	 * do not allow
+	 */
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if (em_ctl & EM_CTL_TM) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		return -EINVAL;
+	}
+
+	/*
+	 * create message header - this is all zero except for
+	 * the message size, which is 4 bytes.
+	 */
+	message[0] |= (4 << 8);
+
+	pp->led_state &= ~(9 << (3*led_num));
+
+	/*
+	 * create the actual message
+	 * XXX will need Port Multiplier support
+	 */
+	message[1] = (ap->port_no | (pp->led_state << 16));
+
+	/* LED bit locations are determined by the led_num */
+	message[1] |= (state << (16 + (3*led_num)));
+
+	/* write message to EM_LOC */
+	writel(message[0], mmio + hpriv->em_loc);
+	writel(message[1], mmio + hpriv->em_loc+4);
+
+	/* save off new led state */
+	pp->led_state = ((message[1] >> 16) & 0x00ff);
+
+	/*
+	 * tell hardware to transmit the message
+	 */
+	writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
+
+	spin_unlock_irqrestore(ap->lock, flags);
+	return 0;
+}
+
+static ssize_t ahci_led_store(struct device *dev, const char *buf, int num)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
+	int state;
+	int rc;
+
+	if (!atadev || !ata_dev_enabled(atadev))
+		return -EINVAL;
+
+	state = simple_strtoul(buf, NULL, 0);
+	if (state != 0 && state != 1)
+		return -EINVAL;
+
+	rc = ahci_transmit_led_message(ap, num, state);
+	if (!rc)
+		return count;
+	return rc;
+}
+
+static ssize_t ahci_led_locate_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	ahci_led_store(dev, buf, 1);
+}
+static DEVICE_ATTR(locate, S_IWUSR | S_IRUGO, NULL, ahci_led_locate_store);
+
+static ssize_t ahci_led_fault_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	ahci_led_store(dev, buf, 2);
+}
+static DEVICE_ATTR(fault, S_IWUGO, NULL, ahci_led_fault_store);
+
+static struct device_attribute *ahci_em_led_attrs[] = {
+	&dev_attr_locate,
+	&dev_attr_fault,
+	NULL
+};
+
 static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
 			   int port_no, void __iomem *mmio,
 			   void __iomem *port_mmio)
@@ -2178,7 +2303,8 @@ static void ahci_print_info(struct ata_host *host)
 	dev_printk(KERN_INFO, &pdev->dev,
 		"flags: "
 		"%s%s%s%s%s%s%s"
-		"%s%s%s%s%s%s%s\n"
+		"%s%s%s%s%s%s%s"
+		"%s\n"
 		,
 
 		cap & (1 << 31) ? "64bit " : "",
@@ -2195,7 +2321,8 @@ static void ahci_print_info(struct ata_host *host)
 		cap & (1 << 17) ? "pmp " : "",
 		cap & (1 << 15) ? "pio " : "",
 		cap & (1 << 14) ? "slum " : "",
-		cap & (1 << 13) ? "part " : ""
+		cap & (1 << 13) ? "part " : "",
+		cap & (1 << 6) ? "ems ": ""
 		);
 }
 
@@ -2331,6 +2458,27 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ahci_init_controller(host);
 	ahci_print_info(host);
 
+	if (ahci_em_messages && (hpriv->cap & HOST_CAP_EMS)) {
+		u8 messages;
+		void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+		u32 em_loc = readl(mmio + HOST_EM_LOC);
+		u32 em_ctl = readl(mmio + HOST_EM_CTL);
+
+		messages = (em_ctl & 0x000f0000) >> 16;
+
+		/* we only support LED message type right now */
+		if ((messages & 0x01) && (ahci_em_messages == 1)) {
+			/* store em_loc */
+			hpriv->em_loc = ((em_loc >> 16) * 4);
+
+			/* reset the LEDs */
+			ahci_reset_em(host);
+
+			/* modify sht to add led sysfs files */
+			ahci_sht.sdev_attrs = ahci_em_led_attrs;
+		}
+	}
+
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_sht);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index fad236d..a49dc19 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -55,7 +55,7 @@ typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
 
 static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 					const struct scsi_device *scsidev);
-static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
+struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
 static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun);
@@ -2593,7 +2593,7 @@ static int ata_scsi_dev_enabled(struct ata_device *dev)
  *	RETURNS:
  *	Associated ATA device, or %NULL if not found.
  */
-static struct ata_device *
+struct ata_device *
 ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 {
 	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
@@ -2603,6 +2603,7 @@ ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 
 	return dev;
 }
+EXPORT_SYMBOL_GPL(ata_scsi_find_dev);
 
 /*
  *	ata_scsi_map_proto - Map pass-thru protocol value to taskfile value.
diff --git a/include/linux/libata.h b/include/linux/libata.h
index ef52a07..1ccbd83 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -900,6 +900,8 @@ extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
+struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
+				      const struct scsi_device *scsidev);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern u8 ata_irq_on(struct ata_port *ap);
-- 
1.5.3.4
