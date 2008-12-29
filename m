Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYL2Mw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYL2Mw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYL2MwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:52:11 -0500
Received: from havoc.gtf.org ([69.61.125.42]:51488 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbYL2MwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:52:03 -0500
Date: Mon, 29 Dec 2008 07:52:00 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata push 1 of 2
Message-ID: <20081229125200.GA23307@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nothing major in this push, really.  Notes:

1) sata_sil DMA restrictions got removed by using a private chip
   DMA engine rather than the chip's IDE-compatible legacy DMA engine
   (it has two engines, yes).

   We need to watch for data corruption.

2) The [non-libata] DMI change was discussed upstream, and is a "better
   fix" for the DMI matching change added to ata_piix late in 2.6.28-rc.


3) As the title indicates, there is a second push coming, mostly 
   consisting of Alan PATA material.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c             |    8 +-
 drivers/ata/ata_generic.c      |    5 +-
 drivers/ata/ata_piix.c         |   21 ++---
 drivers/ata/libata-acpi.c      |   19 ++--
 drivers/ata/libata-core.c      |  204 ++++++++++++++++++++++++---------------
 drivers/ata/libata-eh.c        |  116 +++++++++++++----------
 drivers/ata/libata-pmp.c       |   22 ++--
 drivers/ata/libata-scsi.c      |   22 ++--
 drivers/ata/pata_bf54x.c       |    1 -
 drivers/ata/pata_it821x.c      |   34 +++----
 drivers/ata/pata_ixp4xx_cf.c   |   14 +--
 drivers/ata/pata_legacy.c      |   18 ++--
 drivers/ata/pata_oldpiix.c     |    1 -
 drivers/ata/pata_pdc2027x.c    |   29 +++----
 drivers/ata/pata_platform.c    |   14 +--
 drivers/ata/pata_radisys.c     |    1 -
 drivers/ata/pata_rz1000.c      |   16 ++--
 drivers/ata/pata_scc.c         |    1 -
 drivers/ata/pata_serverworks.c |    1 -
 drivers/ata/pata_sis.c         |    1 -
 drivers/ata/sata_mv.c          |    1 -
 drivers/ata/sata_sil.c         |   98 +++++++++++++++++++-
 drivers/firmware/dmi_scan.c    |   16 +++
 include/linux/dmi.h            |    3 +
 include/linux/libata.h         |   71 +++++++++++----
 25 files changed, 457 insertions(+), 280 deletions(-)

Jiri Slaby (2):
      DMI: add dmi_match
      [libata] ata_piix: cleanup dmi strings checking

Lubomir Bulej (1):
      libata: blacklist NCQ on OCZ CORE 2 SSD (resend)

Qinghuang Feng (1):
      [libata] Update kernel-doc comments to match source code

Robert Hancock (1):
      sata_sil: add Large Block Transfer support

Tejun Heo (3):
      libata: beef up iterators
      libata: when restoring SControl during detach do the PMP links first
      libata: perform port detach in EH

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a67b8e7..656448c 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1119,14 +1119,14 @@ static void ahci_start_port(struct ata_port *ap)
 
 	/* turn on LEDs */
 	if (ap->flags & ATA_FLAG_EM) {
-		ata_port_for_each_link(link, ap) {
+		ata_for_each_link(link, ap, EDGE) {
 			emp = &pp->em_priv[link->pmp];
 			ahci_transmit_led_message(ap, emp->led_state, 4);
 		}
 	}
 
 	if (ap->flags & ATA_FLAG_SW_ACTIVITY)
-		ata_port_for_each_link(link, ap)
+		ata_for_each_link(link, ap, EDGE)
 			ahci_init_sw_activity(link);
 
 }
@@ -1361,7 +1361,7 @@ static ssize_t ahci_led_show(struct ata_port *ap, char *buf)
 	struct ahci_em_priv *emp;
 	int rc = 0;
 
-	ata_port_for_each_link(link, ap) {
+	ata_for_each_link(link, ap, EDGE) {
 		emp = &pp->em_priv[link->pmp];
 		rc += sprintf(buf, "%lx\n", emp->led_state);
 	}
@@ -1941,7 +1941,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	u32 serror;
 
 	/* determine active link */
-	ata_port_for_each_link(link, ap)
+	ata_for_each_link(link, ap, EDGE)
 		if (ata_link_active(link))
 			break;
 	if (!link)
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 5c33767..dc48a63 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -57,10 +57,7 @@ static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 	if (pdev->vendor == PCI_VENDOR_ID_CENATEK)
 		dma_enabled = 0xFF;
 
-	ata_link_for_each_dev(dev, link) {
-		if (!ata_dev_enabled(dev))
-			continue;
-
+	ata_for_each_dev(dev, link, ENABLED) {
 		/* We don't really care */
 		dev->pio_mode = XFER_PIO_0;
 		dev->dma_mode = XFER_MW_DMA_0;
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index c11936e..5fdf167 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1072,20 +1072,13 @@ static int piix_broken_suspend(void)
 	 * matching is necessary because dmi_system_id.matches is
 	 * limited to four entries.
 	 */
-	if (dmi_get_system_info(DMI_SYS_VENDOR) &&
-	    dmi_get_system_info(DMI_PRODUCT_NAME) &&
-	    dmi_get_system_info(DMI_PRODUCT_VERSION) &&
-	    dmi_get_system_info(DMI_PRODUCT_SERIAL) &&
-	    dmi_get_system_info(DMI_BOARD_VENDOR) &&
-	    dmi_get_system_info(DMI_BOARD_NAME) &&
-	    dmi_get_system_info(DMI_BOARD_VERSION) &&
-	    !strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_NAME), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_VERSION), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_SERIAL), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_VENDOR), "TOSHIBA") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_NAME), "Portable PC") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_VERSION), "Version A0"))
+	if (dmi_match(DMI_SYS_VENDOR, "TOSHIBA") &&
+	    dmi_match(DMI_PRODUCT_NAME, "000000") &&
+	    dmi_match(DMI_PRODUCT_VERSION, "000000") &&
+	    dmi_match(DMI_PRODUCT_SERIAL, "000000") &&
+	    dmi_match(DMI_BOARD_VENDOR, "TOSHIBA") &&
+	    dmi_match(DMI_BOARD_NAME, "Portable PC") &&
+	    dmi_match(DMI_BOARD_VERSION, "Version A0"))
 		return 1;
 
 	return 0;
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index c012307..ef02e48 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -89,7 +89,7 @@ void ata_acpi_associate_sata_port(struct ata_port *ap)
 
 		ap->link.device->acpi_handle = NULL;
 
-		ata_port_for_each_link(link, ap) {
+		ata_for_each_link(link, ap, EDGE) {
 			acpi_integer adr = SATA_ADR(ap->port_no, link->pmp);
 
 			link->device->acpi_handle =
@@ -129,8 +129,8 @@ static void ata_acpi_detach_device(struct ata_port *ap, struct ata_device *dev)
 		struct ata_link *tlink;
 		struct ata_device *tdev;
 
-		ata_port_for_each_link(tlink, ap)
-			ata_link_for_each_dev(tdev, tlink)
+		ata_for_each_link(tlink, ap, EDGE)
+			ata_for_each_dev(tdev, tlink, ALL)
 				tdev->flags |= ATA_DFLAG_DETACH;
 	}
 
@@ -588,12 +588,9 @@ int ata_acpi_cbl_80wire(struct ata_port *ap, const struct ata_acpi_gtm *gtm)
 {
 	struct ata_device *dev;
 
-	ata_link_for_each_dev(dev, &ap->link) {
+	ata_for_each_dev(dev, &ap->link, ENABLED) {
 		unsigned long xfer_mask, udma_mask;
 
-		if (!ata_dev_enabled(dev))
-			continue;
-
 		xfer_mask = ata_acpi_gtm_xfermask(dev, gtm);
 		ata_unpack_xfermask(xfer_mask, NULL, NULL, &udma_mask);
 
@@ -893,7 +890,7 @@ void ata_acpi_on_resume(struct ata_port *ap)
 		 * use values set by _STM.  Cache _GTF result and
 		 * schedule _GTF.
 		 */
-		ata_link_for_each_dev(dev, &ap->link) {
+		ata_for_each_dev(dev, &ap->link, ALL) {
 			ata_acpi_clear_gtf(dev);
 			if (ata_dev_enabled(dev) &&
 			    ata_dev_get_GTF(dev, NULL) >= 0)
@@ -904,7 +901,7 @@ void ata_acpi_on_resume(struct ata_port *ap)
 		 * there's no reason to evaluate IDE _GTF early
 		 * without _STM.  Clear cache and schedule _GTF.
 		 */
-		ata_link_for_each_dev(dev, &ap->link) {
+		ata_for_each_dev(dev, &ap->link, ALL) {
 			ata_acpi_clear_gtf(dev);
 			if (ata_dev_enabled(dev))
 				dev->flags |= ATA_DFLAG_ACPI_PENDING;
@@ -932,8 +929,8 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 	if (state.event == PM_EVENT_ON)
 		acpi_bus_set_power(ap->acpi_handle, ACPI_STATE_D0);
 
-	ata_link_for_each_dev(dev, &ap->link) {
-		if (dev->acpi_handle && ata_dev_enabled(dev))
+	ata_for_each_dev(dev, &ap->link, ENABLED) {
+		if (dev->acpi_handle)
 			acpi_bus_set_power(dev->acpi_handle,
 				state.event == PM_EVENT_ON ?
 					ACPI_STATE_D0 : ACPI_STATE_D3);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bc6695e..fecca42 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -163,43 +163,119 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 
-/*
- * Iterator helpers.  Don't use directly.
+/**
+ *	ata_link_next - link iteration helper
+ *	@link: the previous link, NULL to start
+ *	@ap: ATA port containing links to iterate
+ *	@mode: iteration mode, one of ATA_LITER_*
+ *
+ *	LOCKING:
+ *	Host lock or EH context.
  *
- * LOCKING:
- * Host lock or EH context.
+ *	RETURNS:
+ *	Pointer to the next link.
  */
-struct ata_link *__ata_port_next_link(struct ata_port *ap,
-				      struct ata_link *link, bool dev_only)
+struct ata_link *ata_link_next(struct ata_link *link, struct ata_port *ap,
+			       enum ata_link_iter_mode mode)
 {
+	BUG_ON(mode != ATA_LITER_EDGE &&
+	       mode != ATA_LITER_PMP_FIRST && mode != ATA_LITER_HOST_FIRST);
+
 	/* NULL link indicates start of iteration */
-	if (!link) {
-		if (dev_only && sata_pmp_attached(ap))
-			return ap->pmp_link;
-		return &ap->link;
-	}
+	if (!link)
+		switch (mode) {
+		case ATA_LITER_EDGE:
+		case ATA_LITER_PMP_FIRST:
+			if (sata_pmp_attached(ap))
+				return ap->pmp_link;
+			/* fall through */
+		case ATA_LITER_HOST_FIRST:
+			return &ap->link;
+		}
 
-	/* we just iterated over the host master link, what's next? */
-	if (link == &ap->link) {
-		if (!sata_pmp_attached(ap)) {
-			if (unlikely(ap->slave_link) && !dev_only)
+	/* we just iterated over the host link, what's next? */
+	if (link == &ap->link)
+		switch (mode) {
+		case ATA_LITER_HOST_FIRST:
+			if (sata_pmp_attached(ap))
+				return ap->pmp_link;
+			/* fall through */
+		case ATA_LITER_PMP_FIRST:
+			if (unlikely(ap->slave_link))
 				return ap->slave_link;
+			/* fall through */
+		case ATA_LITER_EDGE:
 			return NULL;
 		}
-		return ap->pmp_link;
-	}
 
 	/* slave_link excludes PMP */
 	if (unlikely(link == ap->slave_link))
 		return NULL;
 
-	/* iterate to the next PMP link */
+	/* we were over a PMP link */
 	if (++link < ap->pmp_link + ap->nr_pmp_links)
 		return link;
+
+	if (mode == ATA_LITER_PMP_FIRST)
+		return &ap->link;
+
 	return NULL;
 }
 
 /**
+ *	ata_dev_next - device iteration helper
+ *	@dev: the previous device, NULL to start
+ *	@link: ATA link containing devices to iterate
+ *	@mode: iteration mode, one of ATA_DITER_*
+ *
+ *	LOCKING:
+ *	Host lock or EH context.
+ *
+ *	RETURNS:
+ *	Pointer to the next device.
+ */
+struct ata_device *ata_dev_next(struct ata_device *dev, struct ata_link *link,
+				enum ata_dev_iter_mode mode)
+{
+	BUG_ON(mode != ATA_DITER_ENABLED && mode != ATA_DITER_ENABLED_REVERSE &&
+	       mode != ATA_DITER_ALL && mode != ATA_DITER_ALL_REVERSE);
+
+	/* NULL dev indicates start of iteration */
+	if (!dev)
+		switch (mode) {
+		case ATA_DITER_ENABLED:
+		case ATA_DITER_ALL:
+			dev = link->device;
+			goto check;
+		case ATA_DITER_ENABLED_REVERSE:
+		case ATA_DITER_ALL_REVERSE:
+			dev = link->device + ata_link_max_devices(link) - 1;
+			goto check;
+		}
+
+ next:
+	/* move to the next one */
+	switch (mode) {
+	case ATA_DITER_ENABLED:
+	case ATA_DITER_ALL:
+		if (++dev < link->device + ata_link_max_devices(link))
+			goto check;
+		return NULL;
+	case ATA_DITER_ENABLED_REVERSE:
+	case ATA_DITER_ALL_REVERSE:
+		if (--dev >= link->device)
+			goto check;
+		return NULL;
+	}
+
+ check:
+	if ((mode == ATA_DITER_ENABLED || mode == ATA_DITER_ENABLED_REVERSE) &&
+	    !ata_dev_enabled(dev))
+		goto next;
+	return dev;
+}
+
+/**
  *	ata_dev_phys_link - find physical link for a device
  *	@dev: ATA device to look up physical link for
  *
@@ -1107,8 +1183,8 @@ static void ata_lpm_enable(struct ata_host *host)
 
 	for (i = 0; i < host->n_ports; i++) {
 		ap = host->ports[i];
-		ata_port_for_each_link(link, ap) {
-			ata_link_for_each_dev(dev, link)
+		ata_for_each_link(link, ap, EDGE) {
+			ata_for_each_dev(dev, link, ALL)
 				ata_dev_disable_pm(dev);
 		}
 	}
@@ -2594,11 +2670,11 @@ int ata_bus_probe(struct ata_port *ap)
 
 	ata_port_probe(ap);
 
-	ata_link_for_each_dev(dev, &ap->link)
+	ata_for_each_dev(dev, &ap->link, ALL)
 		tries[dev->devno] = ATA_PROBE_MAX_TRIES;
 
  retry:
-	ata_link_for_each_dev(dev, &ap->link) {
+	ata_for_each_dev(dev, &ap->link, ALL) {
 		/* If we issue an SRST then an ATA drive (not ATAPI)
 		 * may change configuration and be in PIO0 timing. If
 		 * we do a hard reset (or are coming from power on)
@@ -2620,7 +2696,7 @@ int ata_bus_probe(struct ata_port *ap)
 	/* reset and determine device classes */
 	ap->ops->phy_reset(ap);
 
-	ata_link_for_each_dev(dev, &ap->link) {
+	ata_for_each_dev(dev, &ap->link, ALL) {
 		if (!(ap->flags & ATA_FLAG_DISABLED) &&
 		    dev->class != ATA_DEV_UNKNOWN)
 			classes[dev->devno] = dev->class;
@@ -2636,7 +2712,7 @@ int ata_bus_probe(struct ata_port *ap)
 	   specific sequence bass-ackwards so that PDIAG- is released by
 	   the slave device */
 
-	ata_link_for_each_dev_reverse(dev, &ap->link) {
+	ata_for_each_dev(dev, &ap->link, ALL_REVERSE) {
 		if (tries[dev->devno])
 			dev->class = classes[dev->devno];
 
@@ -2653,24 +2729,19 @@ int ata_bus_probe(struct ata_port *ap)
 	if (ap->ops->cable_detect)
 		ap->cbl = ap->ops->cable_detect(ap);
 
-	/* We may have SATA bridge glue hiding here irrespective of the
-	   reported cable types and sensed types */
-	ata_link_for_each_dev(dev, &ap->link) {
-		if (!ata_dev_enabled(dev))
-			continue;
-		/* SATA drives indicate we have a bridge. We don't know which
-		   end of the link the bridge is which is a problem */
+	/* We may have SATA bridge glue hiding here irrespective of
+	 * the reported cable types and sensed types.  When SATA
+	 * drives indicate we have a bridge, we don't know which end
+	 * of the link the bridge is which is a problem.
+	 */
+	ata_for_each_dev(dev, &ap->link, ENABLED)
 		if (ata_id_is_sata(dev->id))
 			ap->cbl = ATA_CBL_SATA;
-	}
 
 	/* After the identify sequence we can now set up the devices. We do
 	   this in the normal order so that the user doesn't get confused */
 
-	ata_link_for_each_dev(dev, &ap->link) {
-		if (!ata_dev_enabled(dev))
-			continue;
-
+	ata_for_each_dev(dev, &ap->link, ENABLED) {
 		ap->link.eh_context.i.flags |= ATA_EHI_PRINTINFO;
 		rc = ata_dev_configure(dev);
 		ap->link.eh_context.i.flags &= ~ATA_EHI_PRINTINFO;
@@ -2683,9 +2754,8 @@ int ata_bus_probe(struct ata_port *ap)
 	if (rc)
 		goto fail;
 
-	ata_link_for_each_dev(dev, &ap->link)
-		if (ata_dev_enabled(dev))
-			return 0;
+	ata_for_each_dev(dev, &ap->link, ENABLED)
+		return 0;
 
 	/* no device present, disable port */
 	ata_port_disable(ap);
@@ -3331,13 +3401,10 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 	int rc = 0, used_dma = 0, found = 0;
 
 	/* step 1: calculate xfer_mask */
-	ata_link_for_each_dev(dev, link) {
+	ata_for_each_dev(dev, link, ENABLED) {
 		unsigned long pio_mask, dma_mask;
 		unsigned int mode_mask;
 
-		if (!ata_dev_enabled(dev))
-			continue;
-
 		mode_mask = ATA_DMA_MASK_ATA;
 		if (dev->class == ATA_DEV_ATAPI)
 			mode_mask = ATA_DMA_MASK_ATAPI;
@@ -3366,10 +3433,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 		goto out;
 
 	/* step 2: always set host PIO timings */
-	ata_link_for_each_dev(dev, link) {
-		if (!ata_dev_enabled(dev))
-			continue;
-
+	ata_for_each_dev(dev, link, ENABLED) {
 		if (dev->pio_mode == 0xff) {
 			ata_dev_printk(dev, KERN_WARNING, "no PIO support\n");
 			rc = -EINVAL;
@@ -3383,8 +3447,8 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 	}
 
 	/* step 3: set host DMA timings */
-	ata_link_for_each_dev(dev, link) {
-		if (!ata_dev_enabled(dev) || !ata_dma_enabled(dev))
+	ata_for_each_dev(dev, link, ENABLED) {
+		if (!ata_dma_enabled(dev))
 			continue;
 
 		dev->xfer_mode = dev->dma_mode;
@@ -3394,11 +3458,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 	}
 
 	/* step 4: update devices' xfer mode */
-	ata_link_for_each_dev(dev, link) {
-		/* don't update suspended devices' xfer mode */
-		if (!ata_dev_enabled(dev))
-			continue;
-
+	ata_for_each_dev(dev, link, ENABLED) {
 		rc = ata_dev_set_mode(dev);
 		if (rc)
 			goto out;
@@ -4048,6 +4108,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "Maxtor 7V300F0",	"VA111630",	ATA_HORKAGE_NONCQ },
 	{ "ST380817AS",		"3.42",		ATA_HORKAGE_NONCQ },
 	{ "ST3160023AS",	"3.42",		ATA_HORKAGE_NONCQ },
+	{ "OCZ CORE_SSD",	"02.10104",	ATA_HORKAGE_NONCQ },
 
 	/* Seagate NCQ + FLUSH CACHE firmware bug */
 	{ "ST31500341AS",	"SD15",		ATA_HORKAGE_NONCQ |
@@ -4263,9 +4324,9 @@ static int cable_is_40wire(struct ata_port *ap)
 	 * - if you have a non detect capable drive you don't want it
 	 *   to colour the choice
 	 */
-	ata_port_for_each_link(link, ap) {
-		ata_link_for_each_dev(dev, link) {
-			if (ata_dev_enabled(dev) && !ata_is_40wire(dev))
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, link, ENABLED) {
+			if (!ata_is_40wire(dev))
 				return 0;
 		}
 	}
@@ -4672,7 +4733,6 @@ static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
 /**
  *	ata_qc_new_init - Request an available ATA command, and initialize it
  *	@dev: Device from whom we request an available command structure
- *	@tag: command tag
  *
  *	LOCKING:
  *	None.
@@ -5218,7 +5278,7 @@ static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
 		}
 
 		ap->pflags |= ATA_PFLAG_PM_PENDING;
-		__ata_port_for_each_link(link, ap) {
+		ata_for_each_link(link, ap, HOST_FIRST) {
 			link->eh_info.action |= action;
 			link->eh_info.flags |= ehi_flags;
 		}
@@ -6047,8 +6107,6 @@ int ata_host_activate(struct ata_host *host, int irq,
 static void ata_port_detach(struct ata_port *ap)
 {
 	unsigned long flags;
-	struct ata_link *link;
-	struct ata_device *dev;
 
 	if (!ap->ops->error_handler)
 		goto skip_eh;
@@ -6056,28 +6114,15 @@ static void ata_port_detach(struct ata_port *ap)
 	/* tell EH we're leaving & flush EH */
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags |= ATA_PFLAG_UNLOADING;
+	ata_port_schedule_eh(ap);
 	spin_unlock_irqrestore(ap->lock, flags);
 
+	/* wait till EH commits suicide */
 	ata_port_wait_eh(ap);
 
-	/* EH is now guaranteed to see UNLOADING - EH context belongs
-	 * to us.  Restore SControl and disable all existing devices.
-	 */
-	__ata_port_for_each_link(link, ap) {
-		sata_scr_write(link, SCR_CONTROL, link->saved_scontrol & 0xff0);
-		ata_link_for_each_dev(dev, link)
-			ata_dev_disable(dev);
-	}
+	/* it better be dead now */
+	WARN_ON(!(ap->pflags & ATA_PFLAG_UNLOADED));
 
-	/* Final freeze & EH.  All in-flight commands are aborted.  EH
-	 * will be skipped and retrials will be terminated with bad
-	 * target.
-	 */
-	spin_lock_irqsave(ap->lock, flags);
-	ata_port_freeze(ap);	/* won't be thawed */
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	ata_port_wait_eh(ap);
 	cancel_rearming_delayed_work(&ap->hotplug_task);
 
  skip_eh:
@@ -6528,7 +6573,8 @@ EXPORT_SYMBOL_GPL(ata_base_port_ops);
 EXPORT_SYMBOL_GPL(sata_port_ops);
 EXPORT_SYMBOL_GPL(ata_dummy_port_ops);
 EXPORT_SYMBOL_GPL(ata_dummy_port_info);
-EXPORT_SYMBOL_GPL(__ata_port_next_link);
+EXPORT_SYMBOL_GPL(ata_link_next);
+EXPORT_SYMBOL_GPL(ata_dev_next);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
 EXPORT_SYMBOL_GPL(ata_host_init);
 EXPORT_SYMBOL_GPL(ata_host_alloc);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 32da9a9..8147a83 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -422,7 +422,7 @@ static void ata_eh_clear_action(struct ata_link *link, struct ata_device *dev,
 
 	if (!dev) {
 		ehi->action &= ~action;
-		ata_link_for_each_dev(tdev, link)
+		ata_for_each_dev(tdev, link, ALL)
 			ehi->dev_action[tdev->devno] &= ~action;
 	} else {
 		/* doesn't make sense for port-wide EH actions */
@@ -430,7 +430,7 @@ static void ata_eh_clear_action(struct ata_link *link, struct ata_device *dev,
 
 		/* break ehi->action into ehi->dev_action */
 		if (ehi->action & action) {
-			ata_link_for_each_dev(tdev, link)
+			ata_for_each_dev(tdev, link, ALL)
 				ehi->dev_action[tdev->devno] |=
 					ehi->action & action;
 			ehi->action &= ~action;
@@ -491,6 +491,31 @@ enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd)
 	return ret;
 }
 
+static void ata_eh_unload(struct ata_port *ap)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+	unsigned long flags;
+
+	/* Restore SControl IPM and SPD for the next driver and
+	 * disable attached devices.
+	 */
+	ata_for_each_link(link, ap, PMP_FIRST) {
+		sata_scr_write(link, SCR_CONTROL, link->saved_scontrol & 0xff0);
+		ata_for_each_dev(dev, link, ALL)
+			ata_dev_disable(dev);
+	}
+
+	/* freeze and set UNLOADED */
+	spin_lock_irqsave(ap->lock, flags);
+
+	ata_port_freeze(ap);			/* won't be thawed */
+	ap->pflags &= ~ATA_PFLAG_EH_PENDING;	/* clear pending from freeze */
+	ap->pflags |= ATA_PFLAG_UNLOADED;
+
+	spin_unlock_irqrestore(ap->lock, flags);
+}
+
 /**
  *	ata_scsi_error - SCSI layer error handler callback
  *	@host: SCSI host on which error occurred
@@ -592,7 +617,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 		/* fetch & clear EH info */
 		spin_lock_irqsave(ap->lock, flags);
 
-		__ata_port_for_each_link(link, ap) {
+		ata_for_each_link(link, ap, HOST_FIRST) {
 			struct ata_eh_context *ehc = &link->eh_context;
 			struct ata_device *dev;
 
@@ -600,12 +625,9 @@ void ata_scsi_error(struct Scsi_Host *host)
 			link->eh_context.i = link->eh_info;
 			memset(&link->eh_info, 0, sizeof(link->eh_info));
 
-			ata_link_for_each_dev(dev, link) {
+			ata_for_each_dev(dev, link, ENABLED) {
 				int devno = dev->devno;
 
-				if (!ata_dev_enabled(dev))
-					continue;
-
 				ehc->saved_xfer_mode[devno] = dev->xfer_mode;
 				if (ata_ncq_enabled(dev))
 					ehc->saved_ncq_enabled |= 1 << devno;
@@ -621,8 +643,13 @@ void ata_scsi_error(struct Scsi_Host *host)
 		/* invoke EH, skip if unloading or suspended */
 		if (!(ap->pflags & (ATA_PFLAG_UNLOADING | ATA_PFLAG_SUSPENDED)))
 			ap->ops->error_handler(ap);
-		else
+		else {
+			/* if unloading, commence suicide */
+			if ((ap->pflags & ATA_PFLAG_UNLOADING) &&
+			    !(ap->pflags & ATA_PFLAG_UNLOADED))
+				ata_eh_unload(ap);
 			ata_eh_finish(ap);
+		}
 
 		/* process port suspend request */
 		ata_eh_handle_port_suspend(ap);
@@ -644,7 +671,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 		}
 
 		/* this run is complete, make sure EH info is clear */
-		__ata_port_for_each_link(link, ap)
+		ata_for_each_link(link, ap, HOST_FIRST)
 			memset(&link->eh_info, 0, sizeof(link->eh_info));
 
 		/* Clear host_eh_scheduled while holding ap->lock such
@@ -1025,7 +1052,7 @@ int sata_async_notification(struct ata_port *ap)
 		struct ata_link *link;
 
 		/* check and notify ATAPI AN */
-		ata_port_for_each_link(link, ap) {
+		ata_for_each_link(link, ap, EDGE) {
 			if (!(sntf & (1 << link->pmp)))
 				continue;
 
@@ -2005,7 +2032,7 @@ void ata_eh_autopsy(struct ata_port *ap)
 {
 	struct ata_link *link;
 
-	ata_port_for_each_link(link, ap)
+	ata_for_each_link(link, ap, EDGE)
 		ata_eh_link_autopsy(link);
 
 	/* Handle the frigging slave link.  Autopsy is done similarly
@@ -2219,7 +2246,7 @@ void ata_eh_report(struct ata_port *ap)
 {
 	struct ata_link *link;
 
-	__ata_port_for_each_link(link, ap)
+	ata_for_each_link(link, ap, HOST_FIRST)
 		ata_eh_link_report(link);
 }
 
@@ -2230,7 +2257,7 @@ static int ata_do_reset(struct ata_link *link, ata_reset_fn_t reset,
 	struct ata_device *dev;
 
 	if (clear_classes)
-		ata_link_for_each_dev(dev, link)
+		ata_for_each_dev(dev, link, ALL)
 			classes[dev->devno] = ATA_DEV_UNKNOWN;
 
 	return reset(link, classes, deadline);
@@ -2294,7 +2321,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 	ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
 
-	ata_link_for_each_dev(dev, link) {
+	ata_for_each_dev(dev, link, ALL) {
 		/* If we issue an SRST then an ATA drive (not ATAPI)
 		 * may change configuration and be in PIO0 timing. If
 		 * we do a hard reset (or are coming from power on)
@@ -2355,7 +2382,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 						"port disabled. ignoring.\n");
 				ehc->i.action &= ~ATA_EH_RESET;
 
-				ata_link_for_each_dev(dev, link)
+				ata_for_each_dev(dev, link, ALL)
 					classes[dev->devno] = ATA_DEV_NONE;
 
 				rc = 0;
@@ -2369,7 +2396,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		 * bang classes and return.
 		 */
 		if (reset && !(ehc->i.action & ATA_EH_RESET)) {
-			ata_link_for_each_dev(dev, link)
+			ata_for_each_dev(dev, link, ALL)
 				classes[dev->devno] = ATA_DEV_NONE;
 			rc = 0;
 			goto out;
@@ -2454,7 +2481,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	/*
 	 * Post-reset processing
 	 */
-	ata_link_for_each_dev(dev, link) {
+	ata_for_each_dev(dev, link, ALL) {
 		/* After the reset, the device state is PIO 0 and the
 		 * controller state is undefined.  Reset also wakes up
 		 * drives from sleeping mode.
@@ -2510,7 +2537,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	 * can be reliably detected and retried.
 	 */
 	nr_unknown = 0;
-	ata_link_for_each_dev(dev, link) {
+	ata_for_each_dev(dev, link, ALL) {
 		/* convert all ATA_DEV_UNKNOWN to ATA_DEV_NONE */
 		if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
 			classes[dev->devno] = ATA_DEV_NONE;
@@ -2619,8 +2646,8 @@ static inline void ata_eh_pull_park_action(struct ata_port *ap)
 
 	spin_lock_irqsave(ap->lock, flags);
 	INIT_COMPLETION(ap->park_req_pending);
-	ata_port_for_each_link(link, ap) {
-		ata_link_for_each_dev(dev, link) {
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, link, ALL) {
 			struct ata_eh_info *ehi = &link->eh_info;
 
 			link->eh_context.i.dev_action[dev->devno] |=
@@ -2675,7 +2702,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 	 * be done backwards such that PDIAG- is released by the slave
 	 * device before the master device is identified.
 	 */
-	ata_link_for_each_dev_reverse(dev, link) {
+	ata_for_each_dev(dev, link, ALL_REVERSE) {
 		unsigned int action = ata_eh_dev_action(dev);
 		unsigned int readid_flags = 0;
 
@@ -2744,7 +2771,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 	/* Configure new devices forward such that user doesn't see
 	 * device detection messages backwards.
 	 */
-	ata_link_for_each_dev(dev, link) {
+	ata_for_each_dev(dev, link, ALL) {
 		if (!(new_mask & (1 << dev->devno)) ||
 		    dev->class == ATA_DEV_PMP)
 			continue;
@@ -2793,10 +2820,7 @@ int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 	int rc;
 
 	/* if data transfer is verified, clear DUBIOUS_XFER on ering top */
-	ata_link_for_each_dev(dev, link) {
-		if (!ata_dev_enabled(dev))
-			continue;
-
+	ata_for_each_dev(dev, link, ENABLED) {
 		if (!(dev->flags & ATA_DFLAG_DUBIOUS_XFER)) {
 			struct ata_ering_entry *ent;
 
@@ -2813,14 +2837,11 @@ int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 		rc = ata_do_set_mode(link, r_failed_dev);
 
 	/* if transfer mode has changed, set DUBIOUS_XFER on device */
-	ata_link_for_each_dev(dev, link) {
+	ata_for_each_dev(dev, link, ENABLED) {
 		struct ata_eh_context *ehc = &link->eh_context;
 		u8 saved_xfer_mode = ehc->saved_xfer_mode[dev->devno];
 		u8 saved_ncq = !!(ehc->saved_ncq_enabled & (1 << dev->devno));
 
-		if (!ata_dev_enabled(dev))
-			continue;
-
 		if (dev->xfer_mode != saved_xfer_mode ||
 		    ata_ncq_enabled(dev) != saved_ncq)
 			dev->flags |= ATA_DFLAG_DUBIOUS_XFER;
@@ -2881,9 +2902,8 @@ static int ata_link_nr_enabled(struct ata_link *link)
 	struct ata_device *dev;
 	int cnt = 0;
 
-	ata_link_for_each_dev(dev, link)
-		if (ata_dev_enabled(dev))
-			cnt++;
+	ata_for_each_dev(dev, link, ENABLED)
+		cnt++;
 	return cnt;
 }
 
@@ -2892,7 +2912,7 @@ static int ata_link_nr_vacant(struct ata_link *link)
 	struct ata_device *dev;
 	int cnt = 0;
 
-	ata_link_for_each_dev(dev, link)
+	ata_for_each_dev(dev, link, ALL)
 		if (dev->class == ATA_DEV_UNKNOWN)
 			cnt++;
 	return cnt;
@@ -2918,7 +2938,7 @@ static int ata_eh_skip_recovery(struct ata_link *link)
 		return 0;
 
 	/* skip if class codes for all vacant slots are ATA_DEV_NONE */
-	ata_link_for_each_dev(dev, link) {
+	ata_for_each_dev(dev, link, ALL) {
 		if (dev->class == ATA_DEV_UNKNOWN &&
 		    ehc->classes[dev->devno] != ATA_DEV_NONE)
 			return 0;
@@ -3026,7 +3046,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	DPRINTK("ENTER\n");
 
 	/* prep for recovery */
-	ata_port_for_each_link(link, ap) {
+	ata_for_each_link(link, ap, EDGE) {
 		struct ata_eh_context *ehc = &link->eh_context;
 
 		/* re-enable link? */
@@ -3038,7 +3058,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			ata_eh_done(link, NULL, ATA_EH_ENABLE_LINK);
 		}
 
-		ata_link_for_each_dev(dev, link) {
+		ata_for_each_dev(dev, link, ALL) {
 			if (link->flags & ATA_LFLAG_NO_RETRY)
 				ehc->tries[dev->devno] = 1;
 			else
@@ -3068,19 +3088,19 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		goto out;
 
 	/* prep for EH */
-	ata_port_for_each_link(link, ap) {
+	ata_for_each_link(link, ap, EDGE) {
 		struct ata_eh_context *ehc = &link->eh_context;
 
 		/* skip EH if possible. */
 		if (ata_eh_skip_recovery(link))
 			ehc->i.action = 0;
 
-		ata_link_for_each_dev(dev, link)
+		ata_for_each_dev(dev, link, ALL)
 			ehc->classes[dev->devno] = ATA_DEV_UNKNOWN;
 	}
 
 	/* reset */
-	ata_port_for_each_link(link, ap) {
+	ata_for_each_link(link, ap, EDGE) {
 		struct ata_eh_context *ehc = &link->eh_context;
 
 		if (!(ehc->i.action & ATA_EH_RESET))
@@ -3105,8 +3125,8 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		ata_eh_pull_park_action(ap);
 
 		deadline = jiffies;
-		ata_port_for_each_link(link, ap) {
-			ata_link_for_each_dev(dev, link) {
+		ata_for_each_link(link, ap, EDGE) {
+			ata_for_each_dev(dev, link, ALL) {
 				struct ata_eh_context *ehc = &link->eh_context;
 				unsigned long tmp;
 
@@ -3134,8 +3154,8 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		deadline = wait_for_completion_timeout(&ap->park_req_pending,
 						       deadline - now);
 	} while (deadline);
-	ata_port_for_each_link(link, ap) {
-		ata_link_for_each_dev(dev, link) {
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, link, ALL) {
 			if (!(link->eh_context.unloaded_mask &
 			      (1 << dev->devno)))
 				continue;
@@ -3146,7 +3166,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	}
 
 	/* the rest */
-	ata_port_for_each_link(link, ap) {
+	ata_for_each_link(link, ap, EDGE) {
 		struct ata_eh_context *ehc = &link->eh_context;
 
 		/* revalidate existing devices and attach new ones */
@@ -3172,7 +3192,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		 * disrupting the current users of the device.
 		 */
 		if (ehc->i.flags & ATA_EHI_DID_RESET) {
-			ata_link_for_each_dev(dev, link) {
+			ata_for_each_dev(dev, link, ALL) {
 				if (dev->class != ATA_DEV_ATAPI)
 					continue;
 				rc = atapi_eh_clear_ua(dev);
@@ -3183,7 +3203,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 
 		/* configure link power saving */
 		if (ehc->i.action & ATA_EH_LPM)
-			ata_link_for_each_dev(dev, link)
+			ata_for_each_dev(dev, link, ALL)
 				ata_dev_enable_pm(dev, ap->pm_policy);
 
 		/* this link is okay now */
@@ -3288,7 +3308,7 @@ void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 	rc = ata_eh_recover(ap, prereset, softreset, hardreset, postreset,
 			    NULL);
 	if (rc) {
-		ata_link_for_each_dev(dev, &ap->link)
+		ata_for_each_dev(dev, &ap->link, ALL)
 			ata_dev_disable(dev);
 	}
 
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index b65db30..98ca07a 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -321,7 +321,7 @@ static void sata_pmp_quirks(struct ata_port *ap)
 
 	if (vendor == 0x1095 && devid == 0x3726) {
 		/* sil3726 quirks */
-		ata_port_for_each_link(link, ap) {
+		ata_for_each_link(link, ap, EDGE) {
 			/* Class code report is unreliable and SRST
 			 * times out under certain configurations.
 			 */
@@ -336,7 +336,7 @@ static void sata_pmp_quirks(struct ata_port *ap)
 		}
 	} else if (vendor == 0x1095 && devid == 0x4723) {
 		/* sil4723 quirks */
-		ata_port_for_each_link(link, ap) {
+		ata_for_each_link(link, ap, EDGE) {
 			/* class code report is unreliable */
 			if (link->pmp < 2)
 				link->flags |= ATA_LFLAG_ASSUME_ATA;
@@ -348,7 +348,7 @@ static void sata_pmp_quirks(struct ata_port *ap)
 		}
 	} else if (vendor == 0x1095 && devid == 0x4726) {
 		/* sil4726 quirks */
-		ata_port_for_each_link(link, ap) {
+		ata_for_each_link(link, ap, EDGE) {
 			/* Class code report is unreliable and SRST
 			 * times out under certain configurations.
 			 * Config device can be at port 0 or 5 and
@@ -450,7 +450,7 @@ int sata_pmp_attach(struct ata_device *dev)
 	if (ap->ops->pmp_attach)
 		ap->ops->pmp_attach(ap);
 
-	ata_port_for_each_link(tlink, ap)
+	ata_for_each_link(tlink, ap, EDGE)
 		sata_link_init_spd(tlink);
 
 	ata_acpi_associate_sata_port(ap);
@@ -487,7 +487,7 @@ static void sata_pmp_detach(struct ata_device *dev)
 	if (ap->ops->pmp_detach)
 		ap->ops->pmp_detach(ap);
 
-	ata_port_for_each_link(tlink, ap)
+	ata_for_each_link(tlink, ap, EDGE)
 		ata_eh_detach_dev(tlink->device);
 
 	spin_lock_irqsave(ap->lock, flags);
@@ -700,7 +700,7 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 		}
 
 		/* PMP is reset, SErrors cannot be trusted, scan all */
-		ata_port_for_each_link(tlink, ap) {
+		ata_for_each_link(tlink, ap, EDGE) {
 			struct ata_eh_context *ehc = &tlink->eh_context;
 
 			ehc->i.probe_mask |= ATA_ALL_DEVICES;
@@ -768,7 +768,7 @@ static int sata_pmp_eh_handle_disabled_links(struct ata_port *ap)
 
 	spin_lock_irqsave(ap->lock, flags);
 
-	ata_port_for_each_link(link, ap) {
+	ata_for_each_link(link, ap, EDGE) {
 		if (!(link->flags & ATA_LFLAG_DISABLED))
 			continue;
 
@@ -852,7 +852,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 	int cnt, rc;
 
 	pmp_tries = ATA_EH_PMP_TRIES;
-	ata_port_for_each_link(link, ap)
+	ata_for_each_link(link, ap, EDGE)
 		link_tries[link->pmp] = ATA_EH_PMP_LINK_TRIES;
 
  retry:
@@ -861,7 +861,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 		rc = ata_eh_recover(ap, ops->prereset, ops->softreset,
 				    ops->hardreset, ops->postreset, NULL);
 		if (rc) {
-			ata_link_for_each_dev(dev, &ap->link)
+			ata_for_each_dev(dev, &ap->link, ALL)
 				ata_dev_disable(dev);
 			return rc;
 		}
@@ -870,7 +870,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 			return 0;
 
 		/* new PMP online */
-		ata_port_for_each_link(link, ap)
+		ata_for_each_link(link, ap, EDGE)
 			link_tries[link->pmp] = ATA_EH_PMP_LINK_TRIES;
 
 		/* fall through */
@@ -942,7 +942,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 	}
 
 	cnt = 0;
-	ata_port_for_each_link(link, ap) {
+	ata_for_each_link(link, ap, EDGE) {
 		if (!(gscr_error & (1 << link->pmp)))
 			continue;
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 47c7afc..0b2e14f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3229,12 +3229,12 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 		return;
 
  repeat:
-	ata_port_for_each_link(link, ap) {
-		ata_link_for_each_dev(dev, link) {
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, link, ENABLED) {
 			struct scsi_device *sdev;
 			int channel = 0, id = 0;
 
-			if (!ata_dev_enabled(dev) || dev->sdev)
+			if (dev->sdev)
 				continue;
 
 			if (ata_is_host_link(link))
@@ -3255,9 +3255,9 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 	 * failure occurred, scan would have failed silently.  Check
 	 * whether all devices are attached.
 	 */
-	ata_port_for_each_link(link, ap) {
-		ata_link_for_each_dev(dev, link) {
-			if (ata_dev_enabled(dev) && !dev->sdev)
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, link, ENABLED) {
+			if (!dev->sdev)
 				goto exit_loop;
 		}
 	}
@@ -3381,7 +3381,7 @@ static void ata_scsi_handle_link_detach(struct ata_link *link)
 	struct ata_port *ap = link->ap;
 	struct ata_device *dev;
 
-	ata_link_for_each_dev(dev, link) {
+	ata_for_each_dev(dev, link, ALL) {
 		unsigned long flags;
 
 		if (!(dev->flags & ATA_DFLAG_DETACHED))
@@ -3496,7 +3496,7 @@ static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 	if (devno == SCAN_WILD_CARD) {
 		struct ata_link *link;
 
-		ata_port_for_each_link(link, ap) {
+		ata_for_each_link(link, ap, EDGE) {
 			struct ata_eh_info *ehi = &link->eh_info;
 			ehi->probe_mask |= ATA_ALL_DEVICES;
 			ehi->action |= ATA_EH_RESET;
@@ -3544,11 +3544,11 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 
 	spin_lock_irqsave(ap->lock, flags);
 
-	ata_port_for_each_link(link, ap) {
-		ata_link_for_each_dev(dev, link) {
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, link, ENABLED) {
 			struct scsi_device *sdev = dev->sdev;
 
-			if (!ata_dev_enabled(dev) || !sdev)
+			if (!sdev)
 				continue;
 			if (scsi_device_get(sdev))
 				continue;
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 1266924..1050fed 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -356,7 +356,6 @@ static void bfin_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	bfin_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: um
- *	@udma: udma mode, 0 - 6
  *
  *	Set UDMA mode for device.
  *
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 860ede5..f828a29 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -465,24 +465,22 @@ static int it821x_smart_set_mode(struct ata_link *link, struct ata_device **unus
 {
 	struct ata_device *dev;
 
-	ata_link_for_each_dev(dev, link) {
-		if (ata_dev_enabled(dev)) {
-			/* We don't really care */
-			dev->pio_mode = XFER_PIO_0;
-			dev->dma_mode = XFER_MW_DMA_0;
-			/* We do need the right mode information for DMA or PIO
-			   and this comes from the current configuration flags */
-			if (ata_id_has_dma(dev->id)) {
-				ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
-				dev->xfer_mode = XFER_MW_DMA_0;
-				dev->xfer_shift = ATA_SHIFT_MWDMA;
-				dev->flags &= ~ATA_DFLAG_PIO;
-			} else {
-				ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
-				dev->xfer_mode = XFER_PIO_0;
-				dev->xfer_shift = ATA_SHIFT_PIO;
-				dev->flags |= ATA_DFLAG_PIO;
-			}
+	ata_for_each_dev(dev, link, ENABLED) {
+		/* We don't really care */
+		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = XFER_MW_DMA_0;
+		/* We do need the right mode information for DMA or PIO
+		   and this comes from the current configuration flags */
+		if (ata_id_has_dma(dev->id)) {
+			ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
+			dev->xfer_mode = XFER_MW_DMA_0;
+			dev->xfer_shift = ATA_SHIFT_MWDMA;
+			dev->flags &= ~ATA_DFLAG_PIO;
+		} else {
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+			dev->xfer_mode = XFER_PIO_0;
+			dev->xfer_shift = ATA_SHIFT_PIO;
+			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
 	return 0;
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 2014253..b173c15 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -30,14 +30,12 @@ static int ixp4xx_set_mode(struct ata_link *link, struct ata_device **error)
 {
 	struct ata_device *dev;
 
-	ata_link_for_each_dev(dev, link) {
-		if (ata_dev_enabled(dev)) {
-			ata_dev_printk(dev, KERN_INFO, "configured for PIO0\n");
-			dev->pio_mode = XFER_PIO_0;
-			dev->xfer_mode = XFER_PIO_0;
-			dev->xfer_shift = ATA_SHIFT_PIO;
-			dev->flags |= ATA_DFLAG_PIO;
-		}
+	ata_for_each_dev(dev, link, ENABLED) {
+		ata_dev_printk(dev, KERN_INFO, "configured for PIO0\n");
+		dev->pio_mode = XFER_PIO_0;
+		dev->xfer_mode = XFER_PIO_0;
+		dev->xfer_shift = ATA_SHIFT_PIO;
+		dev->flags |= ATA_DFLAG_PIO;
 	}
 	return 0;
 }
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 930c220..6c1d778 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -194,15 +194,12 @@ static int legacy_set_mode(struct ata_link *link, struct ata_device **unused)
 {
 	struct ata_device *dev;
 
-	ata_link_for_each_dev(dev, link) {
-		if (ata_dev_enabled(dev)) {
-			ata_dev_printk(dev, KERN_INFO,
-						"configured for PIO\n");
-			dev->pio_mode = XFER_PIO_0;
-			dev->xfer_mode = XFER_PIO_0;
-			dev->xfer_shift = ATA_SHIFT_PIO;
-			dev->flags |= ATA_DFLAG_PIO;
-		}
+	ata_for_each_dev(dev, link, ENABLED) {
+		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+		dev->pio_mode = XFER_PIO_0;
+		dev->xfer_mode = XFER_PIO_0;
+		dev->xfer_shift = ATA_SHIFT_PIO;
+		dev->flags |= ATA_DFLAG_PIO;
 	}
 	return 0;
 }
@@ -641,7 +638,6 @@ static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	qdi6580dp_set_piomode		-	PIO setup for dual channel
  *	@ap: Port
  *	@adev: Device
- *	@irq: interrupt line
  *
  *	In dual channel mode the 6580 has one clock per channel and we have
  *	to software clockswitch in qc_issue.
@@ -1028,7 +1024,7 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 	/* Nothing found means we drop the port as its probably not there */
 
 	ret = -ENODEV;
-	ata_link_for_each_dev(dev, &ap->link) {
+	ata_for_each_dev(dev, &ap->link, ALL) {
 		if (!ata_dev_absent(dev)) {
 			legacy_host[probe->slot] = host;
 			ld->platform_dev = pdev;
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index c0dbc46..2c1a91c 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -116,7 +116,6 @@ static void oldpiix_set_piomode (struct ata_port *ap, struct ata_device *adev)
  *	oldpiix_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
- *	@isich: True if the device is an ICH and has IOCFG registers
  *
  *	Set MWDMA mode for device, in host controller PCI config space.
  *
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 0e1c2c1..e94efcc 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -281,7 +281,6 @@ static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long
  *	pdc2027x_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port to configure
  *	@adev: um
- *	@pio: PIO mode, 0 - 4
  *
  *	Set PIO mode for device.
  *
@@ -326,7 +325,6 @@ static void pdc2027x_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	pdc2027x_set_dmamode - Initialize host controller PATA UDMA timings
  *	@ap: Port to configure
  *	@adev: um
- *	@udma: udma mode, XFER_UDMA_0 to XFER_UDMA_6
  *
  *	Set UDMA mode for device.
  *
@@ -406,23 +404,20 @@ static int pdc2027x_set_mode(struct ata_link *link, struct ata_device **r_failed
 	if (rc < 0)
 		return rc;
 
-	ata_link_for_each_dev(dev, link) {
-		if (ata_dev_enabled(dev)) {
+	ata_for_each_dev(dev, link, ENABLED) {
+		pdc2027x_set_piomode(ap, dev);
 
-			pdc2027x_set_piomode(ap, dev);
+		/*
+		 * Enable prefetch if the device support PIO only.
+		 */
+		if (dev->xfer_shift == ATA_SHIFT_PIO) {
+			u32 ctcr1 = ioread32(dev_mmio(ap, dev, PDC_CTCR1));
+			ctcr1 |= (1 << 25);
+			iowrite32(ctcr1, dev_mmio(ap, dev, PDC_CTCR1));
 
-			/*
-			 * Enable prefetch if the device support PIO only.
-			 */
-			if (dev->xfer_shift == ATA_SHIFT_PIO) {
-				u32 ctcr1 = ioread32(dev_mmio(ap, dev, PDC_CTCR1));
-				ctcr1 |= (1 << 25);
-				iowrite32(ctcr1, dev_mmio(ap, dev, PDC_CTCR1));
-
-				PDPRINTK("Turn on prefetch\n");
-			} else {
-				pdc2027x_set_dmamode(ap, dev);
-			}
+			PDPRINTK("Turn on prefetch\n");
+		} else {
+			pdc2027x_set_dmamode(ap, dev);
 		}
 	}
 	return 0;
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 77e4e3b..6afa07a 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -34,14 +34,12 @@ static int pata_platform_set_mode(struct ata_link *link, struct ata_device **unu
 {
 	struct ata_device *dev;
 
-	ata_link_for_each_dev(dev, link) {
-		if (ata_dev_enabled(dev)) {
-			/* We don't really care */
-			dev->pio_mode = dev->xfer_mode = XFER_PIO_0;
-			dev->xfer_shift = ATA_SHIFT_PIO;
-			dev->flags |= ATA_DFLAG_PIO;
-			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
-		}
+	ata_for_each_dev(dev, link, ENABLED) {
+		/* We don't really care */
+		dev->pio_mode = dev->xfer_mode = XFER_PIO_0;
+		dev->xfer_shift = ATA_SHIFT_PIO;
+		dev->flags |= ATA_DFLAG_PIO;
+		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 	}
 	return 0;
 }
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 0b0aa45..695d44a 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -81,7 +81,6 @@ static void radisys_set_piomode (struct ata_port *ap, struct ata_device *adev)
  *	radisys_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
- *	@isich: True if the device is an ICH and has IOCFG registers
  *
  *	Set MWDMA mode for device, in host controller PCI config space.
  *
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 7dfd1f3..46d6bc1 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -38,15 +38,13 @@ static int rz1000_set_mode(struct ata_link *link, struct ata_device **unused)
 {
 	struct ata_device *dev;
 
-	ata_link_for_each_dev(dev, link) {
-		if (ata_dev_enabled(dev)) {
-			/* We don't really care */
-			dev->pio_mode = XFER_PIO_0;
-			dev->xfer_mode = XFER_PIO_0;
-			dev->xfer_shift = ATA_SHIFT_PIO;
-			dev->flags |= ATA_DFLAG_PIO;
-			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
-		}
+	ata_for_each_dev(dev, link, ENABLED) {
+		/* We don't really care */
+		dev->pio_mode = XFER_PIO_0;
+		dev->xfer_mode = XFER_PIO_0;
+		dev->xfer_shift = ATA_SHIFT_PIO;
+		dev->flags |= ATA_DFLAG_PIO;
+		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 	}
 	return 0;
 }
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index cf3707e..d447f1c 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -210,7 +210,6 @@ static void scc_set_piomode (struct ata_port *ap, struct ata_device *adev)
  *	scc_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: um
- *	@udma: udma mode, 0 - 6
  *
  *	Set UDMA mode for device.
  *
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 72e41c9..8d2fd9d 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -138,7 +138,6 @@ static struct sv_cable_table cable_detect[] = {
 /**
  *	serverworks_cable_detect	-	cable detection
  *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection according to the device and subvendor
  *	identifications
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index e4be55e..27ceb42 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -112,7 +112,6 @@ static int sis_133_cable_detect(struct ata_port *ap)
 /**
  *	sis_66_cable_detect	-	check for 40/80 pin
  *	@ap: Port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection on the UDMA66, UDMA100 and early UDMA133
  *	SiS IDE controllers.
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 2b24ae5..8691863 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1836,7 +1836,6 @@ static void mv_unexpected_intr(struct ata_port *ap, int edma_was_enabled)
 /**
  *      mv_err_intr - Handle error interrupts on the port
  *      @ap: ATA channel to manipulate
- *      @qc: affected command (non-NCQ), or NULL
  *
  *      Most cases require a full reset of the chip's state machine,
  *      which also performs a COMRESET.
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 031d7b7..564c142 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -46,7 +46,9 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_sil"
-#define DRV_VERSION	"2.3"
+#define DRV_VERSION	"2.4"
+
+#define SIL_DMA_BOUNDARY	0x7fffffffUL
 
 enum {
 	SIL_MMIO_BAR		= 5,
@@ -118,6 +120,10 @@ static void sil_dev_config(struct ata_device *dev);
 static int sil_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int sil_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int sil_set_mode(struct ata_link *link, struct ata_device **r_failed);
+static void sil_qc_prep(struct ata_queued_cmd *qc);
+static void sil_bmdma_setup(struct ata_queued_cmd *qc);
+static void sil_bmdma_start(struct ata_queued_cmd *qc);
+static void sil_bmdma_stop(struct ata_queued_cmd *qc);
 static void sil_freeze(struct ata_port *ap);
 static void sil_thaw(struct ata_port *ap);
 
@@ -167,13 +173,22 @@ static struct pci_driver sil_pci_driver = {
 };
 
 static struct scsi_host_template sil_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
+	ATA_BASE_SHT(DRV_NAME),
+	/** These controllers support Large Block Transfer which allows
+	    transfer chunks up to 2GB and which cross 64KB boundaries,
+	    therefore the DMA limits are more relaxed than standard ATA SFF. */
+	.dma_boundary		= SIL_DMA_BOUNDARY,
+	.sg_tablesize		= ATA_MAX_PRD
 };
 
 static struct ata_port_operations sil_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 	.dev_config		= sil_dev_config,
 	.set_mode		= sil_set_mode,
+	.bmdma_setup            = sil_bmdma_setup,
+	.bmdma_start            = sil_bmdma_start,
+	.bmdma_stop		= sil_bmdma_stop,
+	.qc_prep		= sil_qc_prep,
 	.freeze			= sil_freeze,
 	.thaw			= sil_thaw,
 	.scr_read		= sil_scr_read,
@@ -249,6 +264,83 @@ module_param(slow_down, int, 0444);
 MODULE_PARM_DESC(slow_down, "Sledgehammer used to work around random problems, by limiting commands to 15 sectors (0=off, 1=on)");
 
 
+static void sil_bmdma_stop(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *mmio_base = ap->host->iomap[SIL_MMIO_BAR];
+	void __iomem *bmdma2 = mmio_base + sil_port[ap->port_no].bmdma2;
+
+	/* clear start/stop bit - can safely always write 0 */
+	iowrite8(0, bmdma2);
+
+	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
+	ata_sff_dma_pause(ap);
+}
+
+static void sil_bmdma_setup(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *bmdma = ap->ioaddr.bmdma_addr;
+
+	/* load PRD table addr. */
+	iowrite32(ap->prd_dma, bmdma + ATA_DMA_TABLE_OFS);
+
+	/* issue r/w command */
+	ap->ops->sff_exec_command(ap, &qc->tf);
+}
+
+static void sil_bmdma_start(struct ata_queued_cmd *qc)
+{
+	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
+	struct ata_port *ap = qc->ap;
+	void __iomem *mmio_base = ap->host->iomap[SIL_MMIO_BAR];
+	void __iomem *bmdma2 = mmio_base + sil_port[ap->port_no].bmdma2;
+	u8 dmactl = ATA_DMA_START;
+
+	/* set transfer direction, start host DMA transaction
+	   Note: For Large Block Transfer to work, the DMA must be started
+	   using the bmdma2 register. */
+	if (!rw)
+		dmactl |= ATA_DMA_WR;
+	iowrite8(dmactl, bmdma2);
+}
+
+/* The way God intended PCI IDE scatter/gather lists to look and behave... */
+static void sil_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct scatterlist *sg;
+	struct ata_port *ap = qc->ap;
+	struct ata_prd *prd, *last_prd = NULL;
+	unsigned int si;
+
+	prd = &ap->prd[0];
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		/* Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		u32 addr = (u32) sg_dma_address(sg);
+		u32 sg_len = sg_dma_len(sg);
+
+		prd->addr = cpu_to_le32(addr);
+		prd->flags_len = cpu_to_le32(sg_len);
+		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, sg_len);
+
+		last_prd = prd;
+		prd++;
+	}
+
+	if (likely(last_prd))
+		last_prd->flags_len |= cpu_to_le32(ATA_PRD_EOT);
+}
+
+static void sil_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	sil_fill_sg(qc);
+}
+
 static unsigned char sil_get_device_cache_line(struct pci_dev *pdev)
 {
 	u8 cache_line = 0;
@@ -278,7 +370,7 @@ static int sil_set_mode(struct ata_link *link, struct ata_device **r_failed)
 	if (rc)
 		return rc;
 
-	ata_link_for_each_dev(dev, link) {
+	ata_for_each_dev(dev, link, ALL) {
 		if (!ata_dev_enabled(dev))
 			dev_mode[dev->devno] = 0;	/* PIO0/1/2 */
 		else if (dev->flags & ATA_DFLAG_PIO)
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 4a597d8..78b989d 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -582,3 +582,19 @@ int dmi_walk(void (*decode)(const struct dmi_header *))
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dmi_walk);
+
+/**
+ * dmi_match - compare a string to the dmi field (if exists)
+ *
+ * Returns true if the requested field equals to the str (including NULL).
+ */
+bool dmi_match(enum dmi_field f, const char *str)
+{
+	const char *info = dmi_get_system_info(f);
+
+	if (info == NULL || str == NULL)
+		return info == str;
+
+	return !strcmp(info, str);
+}
+EXPORT_SYMBOL_GPL(dmi_match);
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index 2bfda17..3416190 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -47,6 +47,7 @@ extern int dmi_name_in_vendors(const char *str);
 extern int dmi_name_in_serial(const char *str);
 extern int dmi_available;
 extern int dmi_walk(void (*decode)(const struct dmi_header *));
+extern bool dmi_match(enum dmi_field f, const char *str);
 
 #else
 
@@ -61,6 +62,8 @@ static inline int dmi_name_in_serial(const char *s) { return 0; }
 #define dmi_available 0
 static inline int dmi_walk(void (*decode)(const struct dmi_header *))
 	{ return -1; }
+static inline bool dmi_match(enum dmi_field f, const char *str)
+	{ return false; }
 
 #endif
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index ed3f26e..3449de5 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -213,10 +213,11 @@ enum {
 	ATA_PFLAG_FROZEN	= (1 << 2), /* port is frozen */
 	ATA_PFLAG_RECOVERED	= (1 << 3), /* recovery action performed */
 	ATA_PFLAG_LOADING	= (1 << 4), /* boot/loading probe */
-	ATA_PFLAG_UNLOADING	= (1 << 5), /* module is unloading */
 	ATA_PFLAG_SCSI_HOTPLUG	= (1 << 6), /* SCSI hotplug scheduled */
 	ATA_PFLAG_INITIALIZING	= (1 << 7), /* being initialized, don't touch */
 	ATA_PFLAG_RESETTING	= (1 << 8), /* reset in progress */
+	ATA_PFLAG_UNLOADING	= (1 << 9), /* driver is being unloaded */
+	ATA_PFLAG_UNLOADED	= (1 << 10), /* driver is unloaded */
 
 	ATA_PFLAG_SUSPENDED	= (1 << 17), /* port is suspended (power) */
 	ATA_PFLAG_PM_PENDING	= (1 << 18), /* PM operation pending */
@@ -1285,26 +1286,62 @@ static inline int ata_link_active(struct ata_link *link)
 	return ata_tag_valid(link->active_tag) || link->sactive;
 }
 
-extern struct ata_link *__ata_port_next_link(struct ata_port *ap,
-					     struct ata_link *link,
-					     bool dev_only);
+/*
+ * Iterators
+ *
+ * ATA_LITER_* constants are used to select link iteration mode and
+ * ATA_DITER_* device iteration mode.
+ *
+ * For a custom iteration directly using ata_{link|dev}_next(), if
+ * @link or @dev, respectively, is NULL, the first element is
+ * returned.  @dev and @link can be any valid device or link and the
+ * next element according to the iteration mode will be returned.
+ * After the last element, NULL is returned.
+ */
+enum ata_link_iter_mode {
+	ATA_LITER_EDGE,		/* if present, PMP links only; otherwise,
+				 * host link.  no slave link */
+	ATA_LITER_HOST_FIRST,	/* host link followed by PMP or slave links */
+	ATA_LITER_PMP_FIRST,	/* PMP links followed by host link,
+				 * slave link still comes after host link */
+};
 
-#define __ata_port_for_each_link(link, ap) \
-	for ((link) = __ata_port_next_link((ap), NULL, false); (link); \
-	     (link) = __ata_port_next_link((ap), (link), false))
+enum ata_dev_iter_mode {
+	ATA_DITER_ENABLED,
+	ATA_DITER_ENABLED_REVERSE,
+	ATA_DITER_ALL,
+	ATA_DITER_ALL_REVERSE,
+};
 
-#define ata_port_for_each_link(link, ap) \
-	for ((link) = __ata_port_next_link((ap), NULL, true); (link); \
-	     (link) = __ata_port_next_link((ap), (link), true))
+extern struct ata_link *ata_link_next(struct ata_link *link,
+				      struct ata_port *ap,
+				      enum ata_link_iter_mode mode);
 
-#define ata_link_for_each_dev(dev, link) \
-	for ((dev) = (link)->device; \
-	     (dev) < (link)->device + ata_link_max_devices(link) || ((dev) = NULL); \
-	     (dev)++)
+extern struct ata_device *ata_dev_next(struct ata_device *dev,
+				       struct ata_link *link,
+				       enum ata_dev_iter_mode mode);
+
+/*
+ * Shortcut notation for iterations
+ *
+ * ata_for_each_link() iterates over each link of @ap according to
+ * @mode.  @link points to the current link in the loop.  @link is
+ * NULL after loop termination.  ata_for_each_dev() works the same way
+ * except that it iterates over each device of @link.
+ *
+ * Note that the mode prefixes ATA_{L|D}ITER_ shouldn't need to be
+ * specified when using the following shorthand notations.  Only the
+ * mode itself (EDGE, HOST_FIRST, ENABLED, etc...) should be
+ * specified.  This not only increases brevity but also makes it
+ * impossible to use ATA_LITER_* for device iteration or vice-versa.
+ */
+#define ata_for_each_link(link, ap, mode) \
+	for ((link) = ata_link_next(NULL, (ap), ATA_LITER_##mode); (link); \
+	     (link) = ata_link_next((link), (ap), ATA_LITER_##mode))
 
-#define ata_link_for_each_dev_reverse(dev, link) \
-	for ((dev) = (link)->device + ata_link_max_devices(link) - 1; \
-	     (dev) >= (link)->device || ((dev) = NULL); (dev)--)
+#define ata_for_each_dev(dev, link, mode) \
+	for ((dev) = ata_dev_next(NULL, (link), ATA_DITER_##mode); (dev); \
+	     (dev) = ata_dev_next((dev), (link), ATA_DITER_##mode))
 
 /**
  *	ata_ncq_enabled - Test whether NCQ is enabled
