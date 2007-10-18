Return-Path: <linux-kernel-owner+w=401wt.eu-S1764083AbXJRAas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764083AbXJRAas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763727AbXJRAaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:30:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:16871 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761190AbXJRAaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:30:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="176984648"
Date: Wed, 17 Oct 2007 17:24:15 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata: ahci: Enable enclosure management via LED
Message-Id: <20071017172415.c8c1b800.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enable enclosure management via LED

As described in the AHCI spec, some AHCI controllers may support 
Enclosure management via a variety of protocols.  This patch
adds support for the LED message type that is specified in 
AHCI 1.1 and higher.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

---
 drivers/ata/ahci.c        |  153 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-scsi.c |    5 -
 include/linux/libata.h    |    3 
 3 files changed, 157 insertions(+), 4 deletions(-)

Index: 2.6-git/drivers/ata/ahci.c
===================================================================
--- 2.6-git.orig/drivers/ata/ahci.c	2007-10-16 16:31:55.000000000 -0700
+++ 2.6-git/drivers/ata/ahci.c	2007-10-17 18:17:28.000000000 -0700
@@ -43,6 +43,7 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <linux/libata.h>
 
 #define DRV_NAME	"ahci"
@@ -88,6 +89,8 @@ enum {
 	HOST_IRQ_STAT		= 0x08, /* interrupt status */
 	HOST_PORTS_IMPL		= 0x0c, /* bitmap of implemented ports */
 	HOST_VERSION		= 0x10, /* AHCI spec. version compliancy */
+	HOST_EM_LOC		= 0x1c, /* Enclosure Management location */
+	HOST_EM_CTL		= 0x20, /* Enclosure Management Control */
 
 	/* HOST_CTL bits */
 	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
@@ -95,6 +98,7 @@ enum {
 	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
 
 	/* HOST_CAP bits */
+	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
 	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
 	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
 	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
@@ -185,6 +189,10 @@ enum {
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
 					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN,
 	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
+
+	/* em_ctl bits */
+	EM_CTL_RST			= (1 << 9), /* Reset */
+	EM_CTL_TM			= (1 << 8), /* Transmit Message */
 };
 
 struct ahci_cmd_hdr {
@@ -208,6 +216,7 @@ struct ahci_host_priv {
 	u32			port_map;	/* port map to use */
 	u32			saved_cap;	/* saved initial cap */
 	u32			saved_port_map;	/* saved initial port_map */
+	u32 			em_loc; /* enclosure management location */
 };
 
 struct ahci_port_priv {
@@ -223,6 +232,7 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
 	u32 			intr_mask;	/* interrupts to enable */
+	u16			led_state;	/* saved current led state */
 };
 
 static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
@@ -521,6 +531,9 @@ static struct pci_driver ahci_pci_driver
 #endif
 };
 
+static int ahci_em_messages = 1;
+module_param(ahci_em_messages, int, 0444);
+MODULE_PARM_DESC(ahci_em_messages, "Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED, 2 = SAF-TE, 3 = SES-2, 4 = SGPIO)");
 
 static inline int ahci_nr_ports(u32 cap)
 {
@@ -902,6 +915,120 @@ static int ahci_reset_controller(struct 
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
+	u32 message[] = {0,0};
+
+	/*
+ 	 * if we are still busy transmitting a previous message,
+ 	 * do not allow
+ 	 */
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if (em_ctl & EM_CTL_TM)
+		return -EINVAL;
+
+	/*
+ 	 * create message header - this is all zero except for
+ 	 * the message size, which is 4 bytes.
+ 	 */
+	message[0] |= (4 << 8);
+
+	pp->led_state &= ~(9 << (3*led_num));
+
+	/*
+ 	 * create the actual message
+ 	 * XXX will need Port Multiplier support
+ 	 */
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
+ 	 * tell hardware to transmit the message
+ 	 */
+	writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
+	return 0;
+}
+
+static ssize_t ahci_led_locate_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
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
+	rc = ahci_transmit_led_message(ap, 1, state);
+	if (!rc)
+		return count;
+	return rc;
+}
+static DEVICE_ATTR(locate, S_IWUGO, NULL, ahci_led_locate_store);
+
+static ssize_t ahci_led_fault_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
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
+	rc = ahci_transmit_led_message(ap, 2, state);
+	if (!rc)
+		return count;
+	return rc;
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
@@ -1934,7 +2061,7 @@ static void ahci_print_info(struct ata_h
 	dev_printk(KERN_INFO, &pdev->dev,
 		"flags: "
 		"%s%s%s%s%s%s%s"
-		"%s%s%s%s%s%s%s\n"
+		"%s%s%s%s%s%s%s%s\n"
 	       	,
 
 		cap & (1 << 31) ? "64bit " : "",
@@ -1951,7 +2078,8 @@ static void ahci_print_info(struct ata_h
 		cap & (1 << 17) ? "pmp " : "",
 		cap & (1 << 15) ? "pio " : "",
 		cap & (1 << 14) ? "slum " : "",
-		cap & (1 << 13) ? "part " : ""
+		cap & (1 << 13) ? "part " : "",
+		cap & (1 << 6) ? "ems ": ""
 		);
 }
 
@@ -2036,6 +2164,27 @@ static int ahci_init_one(struct pci_dev 
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
Index: 2.6-git/include/linux/libata.h
===================================================================
--- 2.6-git.orig/include/linux/libata.h	2007-10-16 16:31:55.000000000 -0700
+++ 2.6-git/include/linux/libata.h	2007-10-16 16:32:16.000000000 -0700
@@ -185,6 +185,7 @@ enum {
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
 	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */
 	ATA_FLAG_PMP		= (1 << 19), /* controller supports PMP */
+	ATA_FLAG_EM		= (1 << 20), /* Enclosure Management support */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
@@ -870,6 +871,8 @@ extern int ata_scsi_slave_config(struct 
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
+struct ata_device * ata_scsi_find_dev(struct ata_port *ap,
+					    const struct scsi_device *scsidev);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern u8 ata_irq_on(struct ata_port *ap);
Index: 2.6-git/drivers/ata/libata-scsi.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-scsi.c	2007-10-16 16:31:55.000000000 -0700
+++ 2.6-git/drivers/ata/libata-scsi.c	2007-10-16 16:33:20.000000000 -0700
@@ -55,7 +55,7 @@ typedef unsigned int (*ata_xlat_func_t)(
 
 static struct ata_device * __ata_scsi_find_dev(struct ata_port *ap,
 					const struct scsi_device *scsidev);
-static struct ata_device * ata_scsi_find_dev(struct ata_port *ap,
+struct ata_device * ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
 static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun);
@@ -2544,7 +2544,7 @@ static int ata_scsi_dev_enabled(struct a
  *	RETURNS:
  *	Associated ATA device, or %NULL if not found.
  */
-static struct ata_device *
+struct ata_device *
 ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 {
 	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
@@ -2554,6 +2554,7 @@ ata_scsi_find_dev(struct ata_port *ap, c
 
 	return dev;
 }
+EXPORT_SYMBOL_GPL(ata_scsi_find_dev);
 
 /*
  *	ata_scsi_map_proto - Map pass-thru protocol value to taskfile value.
