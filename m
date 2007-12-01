Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbXLAAg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbXLAAg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 19:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbXLAAgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 19:36:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:46172 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbXLAAgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 19:36:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,236,1194249600"; 
   d="scan'208";a="410586788"
Date: Fri, 30 Nov 2007 16:34:43 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ata: ahci: Enclosure Management via LED rev2
Message-ID: <20071130163443.2feabc5d@appleyard>
In-Reply-To: <20071129121925.7d178915@appleyard>
References: <20071129121925.7d178915@appleyard>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enclosure Management via LED

This patch implements Enclosure Management via the LED protocol as specified
in AHCI specification.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
---
This revision makes the change to the comment requested by Mark Lord,
fixes some bugs in the bit shifting for writing the new led state,
and implements a show function so that led status can be read as
well as written.

 drivers/ata/ahci.c        |  184 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-scsi.c |    5 -
 include/linux/libata.h    |    2 
 3 files changed, 187 insertions(+), 4 deletions(-)

Index: 2.6-git/drivers/ata/ahci.c
===================================================================
--- 2.6-git.orig/drivers/ata/ahci.c	2007-11-30 12:04:12.000000000 -0800
+++ 2.6-git/drivers/ata/ahci.c	2007-11-30 18:02:19.000000000 -0800
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
@@ -572,6 +582,11 @@ static struct pci_driver ahci_pci_driver
 #endif
 };
 
+static int ahci_em_messages = 1;
+module_param(ahci_em_messages, int, 0444);
+/* add other LED protocol types when they become supported */
+MODULE_PARM_DESC(ahci_em_messages,
+	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");
 
 static inline int ahci_nr_ports(u32 cap)
 {
@@ -1079,6 +1094,148 @@ static int ahci_reset_controller(struct 
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
+	pp->led_state &= ~(7 << (3*led_num));
+
+	/*
+	 * create the actual message
+	 * This does not support Port Multiplier at this time
+	 * due to lack of hardware for testing
+	 * so the PM field is always zero.
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
+	pp->led_state = ((message[1] >> 16) & 0x01ff);
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
+static int ahci_led_show(struct device *dev, char *buf, int num)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
+	struct ahci_port_priv *pp = ap->private_data;
+
+	if (!atadev || !ata_dev_enabled(atadev))
+		return -EINVAL;
+
+	return sprintf(buf, "%d\n",
+		((pp->led_state & (7 << (3*num))) >> 3*num));
+}
+
+static int ahci_led_store(struct device *dev, const char *buf, int num)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
+	int state;
+
+	if (!atadev || !ata_dev_enabled(atadev))
+		return -EINVAL;
+
+	state = simple_strtoul(buf, NULL, 0);
+	if (state != 0 && state != 1)
+		return -EINVAL;
+
+	return ahci_transmit_led_message(ap, num, state);
+}
+
+static ssize_t ahci_led_locate_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	return ahci_led_show(dev, buf, 1);
+}
+
+static ssize_t ahci_led_locate_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	int rc = ahci_led_store(dev, buf, 1);
+	if (!rc)
+		return count;
+	return rc;
+}
+static DEVICE_ATTR(locate, S_IWUSR | S_IRUGO, ahci_led_locate_show,
+			ahci_led_locate_store);
+
+static ssize_t ahci_led_fault_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	return ahci_led_show(dev, buf, 2);
+}
+
+static ssize_t ahci_led_fault_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	int rc = ahci_led_store(dev, buf, 2);
+	if (!rc)
+		return count;
+	return rc;
+}
+static DEVICE_ATTR(fault, S_IWUSR | S_IRUGO, ahci_led_fault_show,
+			ahci_led_fault_store);
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
@@ -2175,7 +2332,8 @@ static void ahci_print_info(struct ata_h
 	dev_printk(KERN_INFO, &pdev->dev,
 		"flags: "
 		"%s%s%s%s%s%s%s"
-		"%s%s%s%s%s%s%s\n"
+		"%s%s%s%s%s%s%s"
+		"%s\n"
 		,
 
 		cap & (1 << 31) ? "64bit " : "",
@@ -2192,7 +2350,8 @@ static void ahci_print_info(struct ata_h
 		cap & (1 << 17) ? "pmp " : "",
 		cap & (1 << 15) ? "pio " : "",
 		cap & (1 << 14) ? "slum " : "",
-		cap & (1 << 13) ? "part " : ""
+		cap & (1 << 13) ? "part " : "",
+		cap & (1 << 6) ? "ems ": ""
 		);
 }
 
@@ -2328,6 +2487,27 @@ static int ahci_init_one(struct pci_dev 
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
Index: 2.6-git/drivers/ata/libata-scsi.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-scsi.c	2007-11-30 12:04:21.000000000 -0800
+++ 2.6-git/drivers/ata/libata-scsi.c	2007-11-30 15:31:12.000000000 -0800
@@ -55,7 +55,7 @@ typedef unsigned int (*ata_xlat_func_t)(
 
 static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 					const struct scsi_device *scsidev);
-static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
+struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
 static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun);
@@ -2622,7 +2622,7 @@ static int ata_scsi_dev_enabled(struct a
  *	RETURNS:
  *	Associated ATA device, or %NULL if not found.
  */
-static struct ata_device *
+struct ata_device *
 ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 {
 	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
@@ -2632,6 +2632,7 @@ ata_scsi_find_dev(struct ata_port *ap, c
 
 	return dev;
 }
+EXPORT_SYMBOL_GPL(ata_scsi_find_dev);
 
 /*
  *	ata_scsi_map_proto - Map pass-thru protocol value to taskfile value.
Index: 2.6-git/include/linux/libata.h
===================================================================
--- 2.6-git.orig/include/linux/libata.h	2007-11-30 12:04:21.000000000 -0800
+++ 2.6-git/include/linux/libata.h	2007-11-30 15:31:12.000000000 -0800
@@ -900,6 +900,8 @@ extern int ata_scsi_slave_config(struct 
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
+struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
+				      const struct scsi_device *scsidev);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern u8 ata_irq_on(struct ata_port *ap);
