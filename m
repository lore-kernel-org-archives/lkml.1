Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbYJ1Epd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbYJ1Epd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYJ1EpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:45:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58356 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbYJ1EpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:45:19 -0400
Date: Tue, 28 Oct 2008 00:45:17 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20081028044517.GA7480@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


All bug fixes except for the one-line Promise PCI ID addition to ahci,
the zap-magic-numbers prep patch from David Milburn, and Alan's email
addr patch.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c              |   41 +++++++++++++++++++++++++----------
 drivers/ata/ata_generic.c       |    2 +-
 drivers/ata/ata_piix.c          |    2 +-
 drivers/ata/libata-core.c       |   35 +++++++++++++++++-------------
 drivers/ata/libata-eh.c         |   14 +++++++++++-
 drivers/ata/pata_acpi.c         |    2 +-
 drivers/ata/pata_ali.c          |    1 -
 drivers/ata/pata_amd.c          |    1 -
 drivers/ata/pata_artop.c        |    2 +-
 drivers/ata/pata_atiixp.c       |    1 -
 drivers/ata/pata_cmd640.c       |    1 -
 drivers/ata/pata_cmd64x.c       |    2 +-
 drivers/ata/pata_cs5530.c       |    1 -
 drivers/ata/pata_cs5535.c       |    2 +-
 drivers/ata/pata_cypress.c      |    2 +-
 drivers/ata/pata_efar.c         |    2 +-
 drivers/ata/pata_isapnp.c       |    2 +-
 drivers/ata/pata_it821x.c       |    7 ++---
 drivers/ata/pata_jmicron.c      |    2 +-
 drivers/ata/pata_legacy.c       |    2 +-
 drivers/ata/pata_marvell.c      |    2 +-
 drivers/ata/pata_mpiix.c        |    2 +-
 drivers/ata/pata_netcell.c      |    2 +-
 drivers/ata/pata_ninja32.c      |   44 ++++++++++++++++++++++++++++++--------
 drivers/ata/pata_ns87410.c      |    1 -
 drivers/ata/pata_ns87415.c      |    2 +-
 drivers/ata/pata_oldpiix.c      |    2 +-
 drivers/ata/pata_opti.c         |    1 -
 drivers/ata/pata_optidma.c      |    1 -
 drivers/ata/pata_pcmcia.c       |    2 +-
 drivers/ata/pata_pdc202xx_old.c |    2 +-
 drivers/ata/pata_platform.c     |    2 +-
 drivers/ata/pata_qdi.c          |    2 +-
 drivers/ata/pata_radisys.c      |    2 +-
 drivers/ata/pata_sc1200.c       |    2 +-
 drivers/ata/pata_scc.c          |    2 +-
 drivers/ata/pata_serverworks.c  |    1 -
 drivers/ata/pata_sil680.c       |    1 -
 drivers/ata/pata_sis.c          |    2 +-
 drivers/ata/pata_sl82c105.c     |    1 -
 drivers/ata/pata_triflex.c      |    2 +-
 drivers/ata/pata_via.c          |    1 -
 drivers/ata/pata_winbond.c      |    2 +-
 drivers/ata/sata_sil24.c        |    5 ++++
 44 files changed, 130 insertions(+), 80 deletions(-)

Alan Cox (2):
      ata: Switch all my stuff to a common address
      pata_ninja32: suspend/resume support

David Milburn (2):
      libata: ahci enclosure management led sync
      libata: ahci enclosure management bit mask

Mark Nelson (1):
      ahci: Add support for Promise PDC42819

Ondrej Zary (1):
      libata: Fix LBA48 on pata_it821x RAID volumes.

Randy Dunlap (1):
      libata: add missing kernel-doc

Tejun Heo (3):
      libata: fix device iteration bugs
      sata_sil24: configure max read request size to 4k
      libata: clear saved xfer_mode and ncq_enabled on device detach

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index aeadd00..a67b8e7 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -49,6 +49,17 @@
 #define DRV_NAME	"ahci"
 #define DRV_VERSION	"3.0"
 
+/* Enclosure Management Control */
+#define EM_CTRL_MSG_TYPE              0x000f0000
+
+/* Enclosure Management LED Message Type */
+#define EM_MSG_LED_HBA_PORT           0x0000000f
+#define EM_MSG_LED_PMP_SLOT           0x0000ff00
+#define EM_MSG_LED_VALUE              0xffff0000
+#define EM_MSG_LED_VALUE_ACTIVITY     0x00070000
+#define EM_MSG_LED_VALUE_OFF          0xfff80000
+#define EM_MSG_LED_VALUE_ON           0x00010000
+
 static int ahci_skip_host_reset;
 module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
 MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
@@ -588,6 +599,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
 
+	/* Promise */
+	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -1220,18 +1234,20 @@ static void ahci_sw_activity_blink(unsigned long arg)
 	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
 	unsigned long led_message = emp->led_state;
 	u32 activity_led_state;
+	unsigned long flags;
 
-	led_message &= 0xffff0000;
+	led_message &= EM_MSG_LED_VALUE;
 	led_message |= ap->port_no | (link->pmp << 8);
 
 	/* check to see if we've had activity.  If so,
 	 * toggle state of LED and reset timer.  If not,
 	 * turn LED to desired idle state.
 	 */
+	spin_lock_irqsave(ap->lock, flags);
 	if (emp->saved_activity != emp->activity) {
 		emp->saved_activity = emp->activity;
 		/* get the current LED state */
-		activity_led_state = led_message & 0x00010000;
+		activity_led_state = led_message & EM_MSG_LED_VALUE_ON;
 
 		if (activity_led_state)
 			activity_led_state = 0;
@@ -1239,17 +1255,18 @@ static void ahci_sw_activity_blink(unsigned long arg)
 			activity_led_state = 1;
 
 		/* clear old state */
-		led_message &= 0xfff8ffff;
+		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
 
 		/* toggle state */
 		led_message |= (activity_led_state << 16);
 		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(100));
 	} else {
 		/* switch to idle */
-		led_message &= 0xfff8ffff;
+		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
 		if (emp->blink_policy == BLINK_OFF)
 			led_message |= (1 << 16);
 	}
+	spin_unlock_irqrestore(ap->lock, flags);
 	ahci_transmit_led_message(ap, led_message, 4);
 }
 
@@ -1294,7 +1311,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 	struct ahci_em_priv *emp;
 
 	/* get the slot number from the message */
-	pmp = (state & 0x0000ff00) >> 8;
+	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
 	if (pmp < MAX_SLOTS)
 		emp = &pp->em_priv[pmp];
 	else
@@ -1319,7 +1336,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 	message[0] |= (4 << 8);
 
 	/* ignore 0:4 of byte zero, fill in port info yourself */
-	message[1] = ((state & 0xfffffff0) | ap->port_no);
+	message[1] = ((state & ~EM_MSG_LED_HBA_PORT) | ap->port_no);
 
 	/* write message to EM_LOC */
 	writel(message[0], mmio + hpriv->em_loc);
@@ -1362,7 +1379,7 @@ static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 	state = simple_strtoul(buf, NULL, 0);
 
 	/* get the slot number from the message */
-	pmp = (state & 0x0000ff00) >> 8;
+	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
 	if (pmp < MAX_SLOTS)
 		emp = &pp->em_priv[pmp];
 	else
@@ -1373,7 +1390,7 @@ static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 	 * activity led through em_message
 	 */
 	if (emp->blink_policy)
-		state &= 0xfff8ffff;
+		state &= ~EM_MSG_LED_VALUE_ACTIVITY;
 
 	return ahci_transmit_led_message(ap, state, size);
 }
@@ -1392,16 +1409,16 @@ static ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
 		link->flags &= ~(ATA_LFLAG_SW_ACTIVITY);
 
 		/* set the LED to OFF */
-		port_led_state &= 0xfff80000;
+		port_led_state &= EM_MSG_LED_VALUE_OFF;
 		port_led_state |= (ap->port_no | (link->pmp << 8));
 		ahci_transmit_led_message(ap, port_led_state, 4);
 	} else {
 		link->flags |= ATA_LFLAG_SW_ACTIVITY;
 		if (val == BLINK_OFF) {
 			/* set LED to ON for idle */
-			port_led_state &= 0xfff80000;
+			port_led_state &= EM_MSG_LED_VALUE_OFF;
 			port_led_state |= (ap->port_no | (link->pmp << 8));
-			port_led_state |= 0x00010000; /* check this */
+			port_led_state |= EM_MSG_LED_VALUE_ON; /* check this */
 			ahci_transmit_led_message(ap, port_led_state, 4);
 		}
 	}
@@ -2612,7 +2629,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		u32 em_loc = readl(mmio + HOST_EM_LOC);
 		u32 em_ctl = readl(mmio + HOST_EM_CTL);
 
-		messages = (em_ctl & 0x000f0000) >> 16;
+		messages = (em_ctl & EM_CTRL_MSG_TYPE) >> 16;
 
 		/* we only support LED message type right now */
 		if ((messages & 0x01) && (ahci_em_messages == 1)) {
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 75a406f..5c33767 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -1,6 +1,6 @@
 /*
  *  ata_generic.c - Generic PATA/SATA controller driver.
- *  Copyright 2005 Red Hat Inc <alan@redhat.com>, all rights reserved.
+ *  Copyright 2005 Red Hat Inc, all rights reserved.
  *
  *  Elements from ide/pci/generic.c
  *	    Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index e9e32ed..52dc2d8 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -14,7 +14,7 @@
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003 Red Hat Inc <alan@redhat.com>
+ *  Copyright (C) 2003 Red Hat Inc
  *
  *
  *  This program is free software; you can redistribute it and/or modify
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8cb0b36..2ff633c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4156,29 +4156,33 @@ static int cable_is_40wire(struct ata_port *ap)
 	struct ata_link *link;
 	struct ata_device *dev;
 
-	/* If the controller thinks we are 40 wire, we are */
+	/* If the controller thinks we are 40 wire, we are. */
 	if (ap->cbl == ATA_CBL_PATA40)
 		return 1;
-	/* If the controller thinks we are 80 wire, we are */
+
+	/* If the controller thinks we are 80 wire, we are. */
 	if (ap->cbl == ATA_CBL_PATA80 || ap->cbl == ATA_CBL_SATA)
 		return 0;
-	/* If the system is known to be 40 wire short cable (eg laptop),
-	   then we allow 80 wire modes even if the drive isn't sure */
+
+	/* If the system is known to be 40 wire short cable (eg
+	 * laptop), then we allow 80 wire modes even if the drive
+	 * isn't sure.
+	 */
 	if (ap->cbl == ATA_CBL_PATA40_SHORT)
 		return 0;
-	/* If the controller doesn't know we scan
-
-	   - Note: We look for all 40 wire detects at this point.
-	     Any 80 wire detect is taken to be 80 wire cable
-	     because
-	     - In many setups only the one drive (slave if present)
-               will give a valid detect
-             - If you have a non detect capable drive you don't
-               want it to colour the choice
-        */
+
+	/* If the controller doesn't know, we scan.
+	 *
+	 * Note: We look for all 40 wire detects at this point.  Any
+	 *       80 wire detect is taken to be 80 wire cable because
+	 * - in many setups only the one drive (slave if present) will
+	 *   give a valid detect
+	 * - if you have a non detect capable drive you don't want it
+	 *   to colour the choice
+	 */
 	ata_port_for_each_link(link, ap) {
 		ata_link_for_each_dev(dev, link) {
-			if (!ata_is_40wire(dev))
+			if (ata_dev_enabled(dev) && !ata_is_40wire(dev))
 				return 0;
 		}
 	}
@@ -4553,6 +4557,7 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 /**
  *	ata_qc_new_init - Request an available ATA command, and initialize it
  *	@dev: Device from whom we request an available command structure
+ *	@tag: command tag
  *
  *	LOCKING:
  *	None.
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5d687d7..8077bdf 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -603,6 +603,9 @@ void ata_scsi_error(struct Scsi_Host *host)
 			ata_link_for_each_dev(dev, link) {
 				int devno = dev->devno;
 
+				if (!ata_dev_enabled(dev))
+					continue;
+
 				ehc->saved_xfer_mode[devno] = dev->xfer_mode;
 				if (ata_ncq_enabled(dev))
 					ehc->saved_ncq_enabled |= 1 << devno;
@@ -1161,6 +1164,7 @@ void ata_eh_detach_dev(struct ata_device *dev)
 {
 	struct ata_link *link = dev->link;
 	struct ata_port *ap = link->ap;
+	struct ata_eh_context *ehc = &link->eh_context;
 	unsigned long flags;
 
 	ata_dev_disable(dev);
@@ -1174,9 +1178,11 @@ void ata_eh_detach_dev(struct ata_device *dev)
 		ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
 	}
 
-	/* clear per-dev EH actions */
+	/* clear per-dev EH info */
 	ata_eh_clear_action(link, dev, &link->eh_info, ATA_EH_PERDEV_MASK);
 	ata_eh_clear_action(link, dev, &link->eh_context.i, ATA_EH_PERDEV_MASK);
+	ehc->saved_xfer_mode[dev->devno] = 0;
+	ehc->saved_ncq_enabled &= ~(1 << dev->devno);
 
 	spin_unlock_irqrestore(ap->lock, flags);
 }
@@ -2787,6 +2793,9 @@ int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 
 	/* if data transfer is verified, clear DUBIOUS_XFER on ering top */
 	ata_link_for_each_dev(dev, link) {
+		if (!ata_dev_enabled(dev))
+			continue;
+
 		if (!(dev->flags & ATA_DFLAG_DUBIOUS_XFER)) {
 			struct ata_ering_entry *ent;
 
@@ -2808,6 +2817,9 @@ int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 		u8 saved_xfer_mode = ehc->saved_xfer_mode[dev->devno];
 		u8 saved_ncq = !!(ehc->saved_ncq_enabled & (1 << dev->devno));
 
+		if (!ata_dev_enabled(dev))
+			continue;
+
 		if (dev->xfer_mode != saved_xfer_mode ||
 		    ata_ncq_enabled(dev) != saved_ncq)
 			dev->flags |= ATA_DFLAG_DUBIOUS_XFER;
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index eb919c1..e2e332d 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -1,7 +1,7 @@
 /*
  *	ACPI PATA driver
  *
- *	(c) 2007 Red Hat  <alan@redhat.com>
+ *	(c) 2007 Red Hat
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 5ca70fa..73c466e 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -1,7 +1,6 @@
 /*
  * pata_ali.c 	- ALI 15x3 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * based in part upon
  * linux/drivers/ide/pci/alim15x3.c		Version 0.17	2003/01/02
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 57dd00f..0ec9c7d 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -1,7 +1,6 @@
 /*
  * pata_amd.c 	- AMD PATA for new ATA layer
  *			  (C) 2005-2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  *  Based on pata-sil680. Errata information is taken from data sheets
  *  and the amd74xx.c driver by Vojtech Pavlik. Nvidia SATA devices are
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 0f513bc..6b3092c 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -1,7 +1,7 @@
 /*
  *    pata_artop.c - ARTOP ATA controller driver
  *
- *	(C) 2006 Red Hat <alan@redhat.com>
+ *	(C) 2006 Red Hat
  *	(C) 2007 Bartlomiej Zolnierkiewicz
  *
  *    Based in part on drivers/ide/pci/aec62xx.c
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index e8a0d99..0e2cde8 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -1,7 +1,6 @@
 /*
  * pata_atiixp.c 	- ATI PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * Based on
  *
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 2de30b9..34a3942 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -1,7 +1,6 @@
 /*
  * pata_cmd640.c 	- CMD640 PCI PATA for new ATA layer
  *			  (C) 2007 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * Based upon
  *  linux/drivers/ide/pci/cmd640.c		Version 1.02  Sep 01, 1996
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index ddd09b7..3167d8f 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -1,7 +1,7 @@
 /*
  * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Based upon
  * linux/drivers/ide/pci/cmd64x.c		Version 1.30	Sept 10, 2002
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 0c4b271..bba4533 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -1,7 +1,6 @@
 /*
  * pata-cs5530.c 	- CS5530 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * based upon cs5530.c by Mark Lord.
  *
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index f1b6556..1b2d4a0 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -1,7 +1,7 @@
 /*
  * pata-cs5535.c 	- CS5535 PATA for new ATA layer
  *			  (C) 2005-2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * based upon cs5535.c from AMD <Jens.Altmann@amd.com> as cleaned up and
  * made readable and Linux style by Wolfgang Zuleger <wolfgang.zuleger@gmx.de
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 2ff6260..d546425 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -1,7 +1,7 @@
 /*
  * pata_cypress.c 	- Cypress PATA for new ATA layer
  *			  (C) 2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox
  *
  * Based heavily on
  * linux/drivers/ide/pci/cy82c693.c		Version 0.40	Sep. 10, 2002
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 9fba829..ac6392e 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -1,7 +1,7 @@
 /*
  *    pata_efar.c - EFAR PIIX clone controller driver
  *
- *	(C) 2005 Red Hat <alan@redhat.com>
+ *	(C) 2005 Red Hat
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 6a111ba..15cdb91 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -1,7 +1,7 @@
 
 /*
  *   pata-isapnp.c - ISA PnP PATA controller driver.
- *   Copyright 2005/2006 Red Hat Inc <alan@redhat.com>, all rights reserved.
+ *   Copyright 2005/2006 Red Hat Inc, all rights reserved.
  *
  *   Based in part on ide-pnp.c by Andrey Panin <pazke@donpac.ru>
  */
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 0221c9a..860ede5 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -1,7 +1,7 @@
 /*
  * pata_it821x.c 	- IT821x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *			  (C) 2007 Bartlomiej Zolnierkiewicz
  *
  * based upon
@@ -10,7 +10,7 @@
  *
  * linux/drivers/ide/pci/it821x.c		Version 0.09	December 2004
  *
- * Copyright (C) 2004		Red Hat <alan@redhat.com>
+ * Copyright (C) 2004		Red Hat
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *  Based in part on the ITE vendor provided SCSI driver.
@@ -557,9 +557,8 @@ static unsigned int it821x_read_id(struct ata_device *adev,
 	if (strstr(model_num, "Integrated Technology Express")) {
 		/* Set feature bits the firmware neglects */
 		id[49] |= 0x0300;	/* LBA, DMA */
-		id[82] |= 0x0400;	/* LBA48 */
 		id[83] &= 0x7FFF;
-		id[83] |= 0x4000;	/* Word 83 is valid */
+		id[83] |= 0x4400;	/* Word 83 is valid and LBA48 */
 		id[86] |= 0x0400;	/* LBA48 on */
 		id[ATA_ID_MAJOR_VER] |= 0x1F;
 	}
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 73b7596..38cf1ab 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -4,7 +4,7 @@
  *			driven by AHCI in the usual configuration although
  *			this driver can handle other setups if we need it.
  *
- *	(c) 2006 Red Hat  <alan@redhat.com>
+ *	(c) 2006 Red Hat
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index bc037ff..930c220 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -1,6 +1,6 @@
 /*
  *   pata-legacy.c - Legacy port PATA/SATA controller driver.
- *   Copyright 2005/2006 Red Hat <alan@redhat.com>, all rights reserved.
+ *   Copyright 2005/2006 Red Hat, all rights reserved.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 0d87eec..76e399b 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -5,7 +5,7 @@
  *	isn't making full use of the device functionality but it is
  *	easy to get working.
  *
- *	(c) 2006 Red Hat  <alan@redhat.com>
+ *	(c) 2006 Red Hat
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 7d7e3fd..7c8faa4 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -1,7 +1,7 @@
 /*
  * pata_mpiix.c 	- Intel MPIIX PATA for new ATA layer
  *			  (C) 2005-2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * The MPIIX is different enough to the PIIX4 and friends that we give it
  * a separate driver. The old ide/pci code handles this by just not tuning
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index d9719c8..9dc05e1 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -1,7 +1,7 @@
 /*
  *    pata_netcell.c - Netcell PATA driver
  *
- *	(c) 2006 Red Hat  <alan@redhat.com>
+ *	(c) 2006 Red Hat
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index 565e67c..4e466ea 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -1,7 +1,6 @@
 /*
  * pata_ninja32.c 	- Ninja32 PATA for new ATA layer
  *			  (C) 2007 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * Note: The controller like many controllers has shared timings for
  * PIO and DMA. We thus flip to the DMA timings in dma_start and flip back
@@ -45,7 +44,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_ninja32"
-#define DRV_VERSION "0.0.1"
+#define DRV_VERSION "0.1.1"
 
 
 /**
@@ -89,6 +88,17 @@ static struct ata_port_operations ninja32_port_ops = {
 	.set_piomode	= ninja32_set_piomode,
 };
 
+static void ninja32_program(void __iomem *base)
+{
+	iowrite8(0x05, base + 0x01);	/* Enable interrupt lines */
+	iowrite8(0xBE, base + 0x02);	/* Burst, ?? setup */
+	iowrite8(0x01, base + 0x03);	/* Unknown */
+	iowrite8(0x20, base + 0x04);	/* WAIT0 */
+	iowrite8(0x8f, base + 0x05);	/* Unknown */
+	iowrite8(0xa4, base + 0x1c);	/* Unknown */
+	iowrite8(0x83, base + 0x1d);	/* BMDMA control: WAIT0 */
+}
+
 static int ninja32_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	struct ata_host *host;
@@ -134,18 +144,28 @@ static int ninja32_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	ap->ioaddr.bmdma_addr = base;
 	ata_sff_std_ports(&ap->ioaddr);
 
-	iowrite8(0x05, base + 0x01);	/* Enable interrupt lines */
-	iowrite8(0xBE, base + 0x02);	/* Burst, ?? setup */
-	iowrite8(0x01, base + 0x03);	/* Unknown */
-	iowrite8(0x20, base + 0x04);	/* WAIT0 */
-	iowrite8(0x8f, base + 0x05);	/* Unknown */
-	iowrite8(0xa4, base + 0x1c);	/* Unknown */
-	iowrite8(0x83, base + 0x1d);	/* BMDMA control: WAIT0 */
+	ninja32_program(base);
 	/* FIXME: Should we disable them at remove ? */
 	return ata_host_activate(host, dev->irq, ata_sff_interrupt,
 				 IRQF_SHARED, &ninja32_sht);
 }
 
+#ifdef CONFIG_PM
+
+static int ninja32_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+	ninja32_program(host->iomap[0]);
+	ata_host_resume(host);
+	return 0;			
+}
+#endif
+
 static const struct pci_device_id ninja32[] = {
 	{ 0x1145, 0xf021, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ 0x1145, 0xf024, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
@@ -156,7 +176,11 @@ static struct pci_driver ninja32_pci_driver = {
 	.name 		= DRV_NAME,
 	.id_table	= ninja32,
 	.probe 		= ninja32_init_one,
-	.remove		= ata_pci_remove_one
+	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend	= ata_pci_device_suspend,
+	.resume		= ninja32_reinit_one,
+#endif
 };
 
 static int __init ninja32_init(void)
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index be756b7..40d411c 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -1,7 +1,6 @@
 /*
  * pata_ns87410.c 	- National Semiconductor 87410 PATA for new ATA layer
  *			  (C) 2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index e0aa7ea..89bf5f8 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -1,7 +1,7 @@
 /*
  *    pata_ns87415.c - NS87415 (non PARISC) PATA
  *
- *	(C) 2005 Red Hat <alan@redhat.com>
+ *	(C) 2005 Red Hat <alan@lxorguk.ukuu.org.uk>
  *
  *    This is a fairly generic MWDMA controller. It has some limitations
  *    as it requires timing reloads on PIO/DMA transitions but it is otherwise
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index df64f24..c0dbc46 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -1,7 +1,7 @@
 /*
  *    pata_oldpiix.c - Intel PATA/SATA controllers
  *
- *	(C) 2005 Red Hat <alan@redhat.com>
+ *	(C) 2005 Red Hat
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index fb2cf66..e4fa4d5 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -1,7 +1,6 @@
 /*
  * pata_opti.c 	- ATI PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * Based on
  *  linux/drivers/ide/pci/opti621.c		Version 0.7	Sept 10, 2002
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 4cd7444..93bb6e9 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -1,7 +1,6 @@
 /*
  * pata_optidma.c 	- Opti DMA PATA for new ATA layer
  *			  (C) 2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  *	The Opti DMA controllers are related to the older PIO PCI controllers
  *	and indeed the VLB ones. The main differences are that the timing
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 02b596b..271cb64 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -1,6 +1,6 @@
 /*
  *   pata_pcmcia.c - PCMCIA PATA controller driver.
- *   Copyright 2005-2006 Red Hat Inc <alan@redhat.com>, all rights reserved.
+ *   Copyright 2005-2006 Red Hat Inc, all rights reserved.
  *   PCMCIA ident update Copyright 2006 Marcin Juszkiewicz
  *						<openembedded@hrw.one.pl>
  *
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index d267306..799a6a0 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -1,7 +1,7 @@
 /*
  * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *			  (C) 2007 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 8f65ad6..77e4e3b 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -5,7 +5,7 @@
  *
  * Based on pata_pcmcia:
  *
- *   Copyright 2005-2006 Red Hat Inc <alan@redhat.com>, all rights reserved.
+ *   Copyright 2005-2006 Red Hat Inc, all rights reserved.
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 63b7a1c..3080f37 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -1,6 +1,6 @@
 /*
  *    pata_qdi.c - QDI VLB ATA controllers
- *	(C) 2006 Red Hat <alan@redhat.com>
+ *	(C) 2006 Red Hat
  *
  * This driver mostly exists as a proof of concept for non PCI devices under
  * libata. While the QDI6580 was 'neat' in 1993 it is no longer terribly
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 1c0d9fa..0b0aa45 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -1,7 +1,7 @@
 /*
  *    pata_radisys.c - Intel PATA/SATA controllers
  *
- *	(C) 2006 Red Hat <alan@redhat.com>
+ *	(C) 2006 Red Hat <alan@lxorguk.ukuu.org.uk>
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 0278fd2..9a4bdca 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -1,5 +1,5 @@
 /*
- * New ATA layer SC1200 driver		Alan Cox <alan@redhat.com>
+ * New ATA layer SC1200 driver		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * TODO: Mode selection filtering
  * TODO: Can't enable second channel until ATA core has serialize
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 16673d1..cf3707e 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -8,7 +8,7 @@
  *  Copyright 2003-2005 Jeff Garzik
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003 Red Hat Inc <alan@redhat.com>
+ *  Copyright (C) 2003 Red Hat Inc
  *
  * and drivers/ata/ahci.c:
  *  Copyright 2004-2005 Red Hat, Inc.
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index ffd26d0..72e41c9 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -1,7 +1,6 @@
 /*
  * pata_serverworks.c 	- Serverworks PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * based upon
  *
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index a598bb3..83580a5 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -1,7 +1,6 @@
 /*
  * pata_sil680.c 	- SIL680 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * based upon
  *
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 26345d7..d342366 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -1,7 +1,7 @@
 /*
  *    pata_sis.c - SiS ATA driver
  *
- *	(C) 2005 Red Hat <alan@redhat.com>
+ *	(C) 2005 Red Hat
  *	(C) 2007 Bartlomiej Zolnierkiewicz
  *
  *    Based upon linux/drivers/ide/pci/sis5513.c
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 69877bd..1b0e7b6 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -1,7 +1,6 @@
 /*
  * pata_sl82c105.c 	- SL82C105 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  * Based in part on linux/drivers/ide/pci/sl82c105.c
  * 		SL82C105/Winbond 553 IDE driver
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index b181261..ef95975 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -1,7 +1,7 @@
 /*
  * pata_triflex.c 	- Compaq PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
+ *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * based upon
  *
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 8fdb2ce..681169c 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -1,7 +1,6 @@
 /*
  * pata_via.c 	- VIA PATA for new ATA layer
  *			  (C) 2005-2006 Red Hat Inc
- *			  Alan Cox <alan@redhat.com>
  *
  *  Documentation
  *	Most chipset documentation available under NDA only
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index a7606b0..319e164 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -1,6 +1,6 @@
 /*
  *    pata_winbond.c - Winbond VLB ATA controllers
- *	(C) 2006 Red Hat <alan@redhat.com>
+ *	(C) 2006 Red Hat
  *
  *    Support for the Winbond 83759A when operating in advanced mode.
  *    Multichip mode is not currently supported.
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 4621807..ccee930 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1329,6 +1329,11 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
+	/* Set max read request size to 4096.  This slightly increases
+	 * write throughput for pci-e variants.
+	 */
+	pcie_set_readrq(pdev, 4096);
+
 	sil24_init_controller(host);
 
 	pci_set_master(pdev);
