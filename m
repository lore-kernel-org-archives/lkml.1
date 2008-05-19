Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbYESW5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbYESW5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbYESW5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:57:39 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33087 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYESW5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:57:33 -0400
Date: Mon, 19 May 2008 18:57:32 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20080519225732.GA21589@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sata_mv, sata_promise and PMP fixes

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-acpi.c   |   75 ++++++++++------
 drivers/ata/libata-core.c   |   40 +++++----
 drivers/ata/libata-eh.c     |  207 +++++++++++++++++++++++-------------------
 drivers/ata/libata-pmp.c    |   44 +++++-----
 drivers/ata/libata-scsi.c   |    6 --
 drivers/ata/pata_ali.c      |   10 +-
 drivers/ata/pata_amd.c      |   14 ++--
 drivers/ata/pata_at32.c     |    2 -
 drivers/ata/pata_bf54x.c    |    5 +-
 drivers/ata/pata_cypress.c  |    8 +-
 drivers/ata/pata_legacy.c   |   50 +++++-----
 drivers/ata/pata_ns87410.c  |    6 +-
 drivers/ata/pata_ns87415.c  |    4 +-
 drivers/ata/pata_qdi.c      |   16 ++--
 drivers/ata/pata_sl82c105.c |    2 +-
 drivers/ata/pata_via.c      |   14 ++--
 drivers/ata/pata_winbond.c  |    6 +-
 drivers/ata/sata_mv.c       |  163 +++++++++++++++++++---------------
 drivers/ata/sata_promise.c  |  148 +++++++++++++++----------------
 drivers/ata/sata_sil24.c    |   11 +++
 include/linux/libata.h      |    6 +-
 21 files changed, 453 insertions(+), 384 deletions(-)

Christophe Jaillet (1):
      avr32/pata: avoid unnecessary memset (updated after comments)

Harvey Harrison (1):
      ata: remove FIT() macro

Jeff Garzik (1):
      drivers/ata: trim trailing whitespace

Mark Lord (10):
      sata_mv: always do softreset
      sata_mv: fis irq register fixes
      sata_mv: group genIIe flags
      sata_mv: async notify for genIIe only
      sata_mv: don't blindly enable IRQs
      sata_mv: consolidate main_irq_mask updates
      sata_mv: fix pmp drives not found
      sata_mv: disregard masked irqs
      sata_mv: cache main_irq_mask register in hpriv
      sata_mv: ensure empty request queue for FBS-NCQ EH

Matthew Garrett (1):
      Fixups to ATA ACPI hotplug

Mikael Pettersson (3):
      sata_promise: fix irq clearing buglets
      sata_promise: mmio access cleanups
      sata_promise: other cleanups

Sonic Zhang (1):
      pata-bf54x: Set ATAPI HSM to control IDE device terminate sequence.

Tejun Heo (10):
      libata: fix sata_link_hardreset() @online out parameter handling
      libata: reorganize ata_eh_reset() no reset method path
      libata: move reset freeze/thaw handling into ata_eh_reset()
      libata: kill hotplug related race condition
      libata: ignore recovered PHY errors
      libata: increase PMP register access timeout to 3s
      libata: make sure PMP notification is turned off during recovery
      libata: don't schedule LPM action seperately during probing
      sata_sil24: don't use NCQ if marvell 4140 PMP is attached
      libata: ignore SIMG4726 config pseudo device

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 70b77e0..dbf6ca7 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -118,8 +118,8 @@ static void ata_acpi_associate_ide_port(struct ata_port *ap)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
-static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
-				    u32 event)
+static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device
+				    *dev, u32 event)
 {
 	char event_string[12];
 	char *envp[] = { event_string, NULL };
@@ -127,6 +127,9 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 	struct kobject *kobj = NULL;
 	int wait = 0;
 	unsigned long flags;
+	acpi_handle handle, tmphandle;
+	unsigned long sta;
+	acpi_status status;
 
 	if (!ap)
 		ap = dev->link->ap;
@@ -134,32 +137,57 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 
 	spin_lock_irqsave(ap->lock, flags);
 
+	if (dev)
+		handle = dev->acpi_handle;
+	else
+		handle = ap->acpi_handle;
+
+	status = acpi_get_handle(handle, "_EJ0", &tmphandle);
+	if (ACPI_FAILURE(status)) {
+		/* This device is not ejectable */
+		spin_unlock_irqrestore(ap->lock, flags);
+		return;
+	}
+
+	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+	if (ACPI_FAILURE(status)) {
+		printk ("Unable to determine bay status\n");
+		spin_unlock_irqrestore(ap->lock, flags);
+		return;
+	}
+
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		ata_ehi_push_desc(ehi, "ACPI event");
-		ata_ehi_hotplugged(ehi);
-		ata_port_freeze(ap);
-		break;
-
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		ata_ehi_push_desc(ehi, "ACPI event");
-		if (dev)
-			dev->flags |= ATA_DFLAG_DETACH;
-		else {
-			struct ata_link *tlink;
-			struct ata_device *tdev;
-
-			ata_port_for_each_link(tlink, ap)
-				ata_link_for_each_dev(tdev, tlink)
-					tdev->flags |= ATA_DFLAG_DETACH;
+		if (!sta) {
+                /* Device has been unplugged */
+			if (dev)
+				dev->flags |= ATA_DFLAG_DETACH;
+			else {
+				struct ata_link *tlink;
+				struct ata_device *tdev;
+
+				ata_port_for_each_link(tlink, ap) {
+					ata_link_for_each_dev(tdev, tlink) {
+						tdev->flags |=
+							ATA_DFLAG_DETACH;
+					}
+				}
+			}
+			ata_port_schedule_eh(ap);
+			wait = 1;
+		} else {
+			ata_ehi_hotplugged(ehi);
+			ata_port_freeze(ap);
 		}
-
-		ata_port_schedule_eh(ap);
-		wait = 1;
-		break;
 	}
 
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	if (wait)
+		ata_port_wait_eh(ap);
+
 	if (dev) {
 		if (dev->sdev)
 			kobj = &dev->sdev->sdev_gendev.kobj;
@@ -170,11 +198,6 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 		sprintf(event_string, "BAY_EVENT=%d", event);
 		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
 	}
-
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	if (wait)
-		ata_port_wait_eh(ap);
 }
 
 static void ata_acpi_dev_notify(acpi_handle handle, u32 event, void *data)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 927b692..3c89f20 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2126,6 +2126,13 @@ int ata_dev_configure(struct ata_device *dev)
 	dev->horkage |= ata_dev_blacklisted(dev);
 	ata_force_horkage(dev);
 
+	if (dev->horkage & ATA_HORKAGE_DISABLE) {
+		ata_dev_printk(dev, KERN_INFO,
+			       "unsupported device, disabling\n");
+		ata_dev_disable(dev);
+		return 0;
+	}
+
 	/* let ACPI work its magic */
 	rc = ata_acpi_on_devcfg(dev);
 	if (rc)
@@ -3490,22 +3497,11 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 	if ((rc = sata_link_debounce(link, params, deadline)))
 		return rc;
 
-	/* Clear SError.  PMP and some host PHYs require this to
-	 * operate and clearing should be done before checking PHY
-	 * online status to avoid race condition (hotplugging between
-	 * link resume and status check).
-	 */
+	/* clear SError, some PHYs require this even for SRST to work */
 	if (!(rc = sata_scr_read(link, SCR_ERROR, &serror)))
 		rc = sata_scr_write(link, SCR_ERROR, serror);
-	if (rc == 0 || rc == -EINVAL) {
-		unsigned long flags;
 
-		spin_lock_irqsave(link->ap->lock, flags);
-		link->eh_info.serror = 0;
-		spin_unlock_irqrestore(link->ap->lock, flags);
-		rc = 0;
-	}
-	return rc;
+	return rc != -EINVAL ? rc : 0;
 }
 
 /**
@@ -3653,9 +3649,13 @@ int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
 	if (check_ready)
 		rc = ata_wait_ready(link, deadline, check_ready);
  out:
-	if (rc && rc != -EAGAIN)
+	if (rc && rc != -EAGAIN) {
+		/* online is set iff link is online && reset succeeded */
+		if (online)
+			*online = false;
 		ata_link_printk(link, KERN_ERR,
 				"COMRESET failed (errno=%d)\n", rc);
+	}
 	DPRINTK("EXIT, rc=%d\n", rc);
 	return rc;
 }
@@ -3700,8 +3700,14 @@ int sata_std_hardreset(struct ata_link *link, unsigned int *class,
  */
 void ata_std_postreset(struct ata_link *link, unsigned int *classes)
 {
+	u32 serror;
+
 	DPRINTK("ENTER\n");
 
+	/* reset complete, clear SError */
+	if (!sata_scr_read(link, SCR_ERROR, &serror))
+		sata_scr_write(link, SCR_ERROR, serror);
+
 	/* print link status */
 	sata_print_link_status(link);
 
@@ -3894,8 +3900,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "SAMSUNG CD-ROM SN-124", "N001",	ATA_HORKAGE_NODMA },
 	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
 	/* Odd clown on sil3726/4726 PMPs */
-	{ "Config  Disk",	NULL,		ATA_HORKAGE_NODMA |
-						ATA_HORKAGE_SKIP_PM },
+	{ "Config  Disk",	NULL,		ATA_HORKAGE_DISABLE },
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
@@ -5616,7 +5621,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 			spin_lock_irqsave(ap->lock, flags);
 
 			ehi->probe_mask |= ATA_ALL_DEVICES;
-			ehi->action |= ATA_EH_RESET;
+			ehi->action |= ATA_EH_RESET | ATA_EH_LPM;
 			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
 
 			ap->pflags &= ~ATA_PFLAG_INITIALIZING;
@@ -5649,7 +5654,6 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 		struct ata_port *ap = host->ports[i];
 
 		ata_scsi_scan_host(ap, 1);
-		ata_lpm_schedule(ap, ap->pm_policy);
 	}
 
 	return 0;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 62e0331..7894d83 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1308,12 +1308,7 @@ static void ata_eh_analyze_serror(struct ata_link *link)
 	unsigned int err_mask = 0, action = 0;
 	u32 hotplug_mask;
 
-	if (serror & SERR_PERSISTENT) {
-		err_mask |= AC_ERR_ATA_BUS;
-		action |= ATA_EH_RESET;
-	}
-	if (serror &
-	    (SERR_DATA_RECOVERED | SERR_COMM_RECOVERED | SERR_DATA)) {
+	if (serror & (SERR_PERSISTENT | SERR_DATA)) {
 		err_mask |= AC_ERR_ATA_BUS;
 		action |= ATA_EH_RESET;
 	}
@@ -2047,19 +2042,11 @@ static int ata_do_reset(struct ata_link *link, ata_reset_fn_t reset,
 			unsigned int *classes, unsigned long deadline)
 {
 	struct ata_device *dev;
-	int rc;
 
 	ata_link_for_each_dev(dev, link)
 		classes[dev->devno] = ATA_DEV_UNKNOWN;
 
-	rc = reset(link, classes, deadline);
-
-	/* convert all ATA_DEV_UNKNOWN to ATA_DEV_NONE */
-	ata_link_for_each_dev(dev, link)
-		if (classes[dev->devno] == ATA_DEV_UNKNOWN)
-			classes[dev->devno] = ATA_DEV_NONE;
-
-	return rc;
+	return reset(link, classes, deadline);
 }
 
 static int ata_eh_followup_srst_needed(struct ata_link *link,
@@ -2096,9 +2083,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	ata_reset_fn_t reset;
 	unsigned long flags;
 	u32 sstatus;
-	int rc;
+	int nr_known, rc;
 
-	/* about to reset */
+	/*
+	 * Prepare to reset
+	 */
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags |= ATA_PFLAG_RESETTING;
 	spin_unlock_irqrestore(ap->lock, flags);
@@ -2124,16 +2113,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			ap->ops->set_piomode(ap, dev);
 	}
 
-	if (!softreset && !hardreset) {
-		if (verbose)
-			ata_link_printk(link, KERN_INFO, "no reset method "
-					"available, skipping reset\n");
-		if (!(lflags & ATA_LFLAG_ASSUME_CLASS))
-			lflags |= ATA_LFLAG_ASSUME_ATA;
-		goto done;
-	}
-
 	/* prefer hardreset */
+	reset = NULL;
 	ehc->i.action &= ~ATA_EH_RESET;
 	if (hardreset) {
 		reset = hardreset;
@@ -2141,11 +2122,6 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	} else if (softreset) {
 		reset = softreset;
 		ehc->i.action = ATA_EH_SOFTRESET;
-	} else {
-		ata_link_printk(link, KERN_ERR, "BUG: no reset method, "
-				"please report to linux-ide@vger.kernel.org\n");
-		dump_stack();
-		return -EINVAL;
 	}
 
 	if (prereset) {
@@ -2165,55 +2141,71 @@ int ata_eh_reset(struct ata_link *link, int classify,
 					"prereset failed (errno=%d)\n", rc);
 			goto out;
 		}
-	}
 
-	/* prereset() might have cleared ATA_EH_RESET */
-	if (!(ehc->i.action & ATA_EH_RESET)) {
-		/* prereset told us not to reset, bang classes and return */
-		ata_link_for_each_dev(dev, link)
-			classes[dev->devno] = ATA_DEV_NONE;
-		rc = 0;
-		goto out;
+		/* prereset() might have cleared ATA_EH_RESET.  If so,
+		 * bang classes and return.
+		 */
+		if (reset && !(ehc->i.action & ATA_EH_RESET)) {
+			ata_link_for_each_dev(dev, link)
+				classes[dev->devno] = ATA_DEV_NONE;
+			rc = 0;
+			goto out;
+		}
 	}
 
  retry:
+	/*
+	 * Perform reset
+	 */
+	if (ata_is_host_link(link))
+		ata_eh_freeze_port(ap);
+
 	deadline = jiffies + ata_eh_reset_timeouts[try++];
 
-	/* shut up during boot probing */
-	if (verbose)
-		ata_link_printk(link, KERN_INFO, "%s resetting link\n",
-				reset == softreset ? "soft" : "hard");
+	if (reset) {
+		if (verbose)
+			ata_link_printk(link, KERN_INFO, "%s resetting link\n",
+					reset == softreset ? "soft" : "hard");
 
-	/* mark that this EH session started with reset */
-	if (reset == hardreset)
-		ehc->i.flags |= ATA_EHI_DID_HARDRESET;
-	else
-		ehc->i.flags |= ATA_EHI_DID_SOFTRESET;
+		/* mark that this EH session started with reset */
+		if (reset == hardreset)
+			ehc->i.flags |= ATA_EHI_DID_HARDRESET;
+		else
+			ehc->i.flags |= ATA_EHI_DID_SOFTRESET;
 
-	rc = ata_do_reset(link, reset, classes, deadline);
+		rc = ata_do_reset(link, reset, classes, deadline);
 
-	if (reset == hardreset &&
-	    ata_eh_followup_srst_needed(link, rc, classify, classes)) {
-		/* okay, let's do follow-up softreset */
-		reset = softreset;
+		if (reset == hardreset &&
+		    ata_eh_followup_srst_needed(link, rc, classify, classes)) {
+			/* okay, let's do follow-up softreset */
+			reset = softreset;
 
-		if (!reset) {
-			ata_link_printk(link, KERN_ERR,
-					"follow-up softreset required "
-					"but no softreset avaliable\n");
-			rc = -EINVAL;
-			goto fail;
+			if (!reset) {
+				ata_link_printk(link, KERN_ERR,
+						"follow-up softreset required "
+						"but no softreset avaliable\n");
+				rc = -EINVAL;
+				goto fail;
+			}
+
+			ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
+			rc = ata_do_reset(link, reset, classes, deadline);
 		}
 
-		ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
-		rc = ata_do_reset(link, reset, classes, deadline);
+		/* -EAGAIN can happen if we skipped followup SRST */
+		if (rc && rc != -EAGAIN)
+			goto fail;
+	} else {
+		if (verbose)
+			ata_link_printk(link, KERN_INFO, "no reset method "
+					"available, skipping reset\n");
+		if (!(lflags & ATA_LFLAG_ASSUME_CLASS))
+			lflags |= ATA_LFLAG_ASSUME_ATA;
 	}
 
-	/* -EAGAIN can happen if we skipped followup SRST */
-	if (rc && rc != -EAGAIN)
-		goto fail;
-
- done:
+	/*
+	 * Post-reset processing
+	 */
 	ata_link_for_each_dev(dev, link) {
 		/* After the reset, the device state is PIO 0 and the
 		 * controller state is undefined.  Reset also wakes up
@@ -2236,9 +2228,53 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0)
 		link->sata_spd = (sstatus >> 4) & 0xf;
 
+	/* thaw the port */
+	if (ata_is_host_link(link))
+		ata_eh_thaw_port(ap);
+
+	/* postreset() should clear hardware SError.  Although SError
+	 * is cleared during link resume, clearing SError here is
+	 * necessary as some PHYs raise hotplug events after SRST.
+	 * This introduces race condition where hotplug occurs between
+	 * reset and here.  This race is mediated by cross checking
+	 * link onlineness and classification result later.
+	 */
 	if (postreset)
 		postreset(link, classes);
 
+	/* clear cached SError */
+	spin_lock_irqsave(link->ap->lock, flags);
+	link->eh_info.serror = 0;
+	spin_unlock_irqrestore(link->ap->lock, flags);
+
+	/* Make sure onlineness and classification result correspond.
+	 * Hotplug could have happened during reset and some
+	 * controllers fail to wait while a drive is spinning up after
+	 * being hotplugged causing misdetection.  By cross checking
+	 * link onlineness and classification result, those conditions
+	 * can be reliably detected and retried.
+	 */
+	nr_known = 0;
+	ata_link_for_each_dev(dev, link) {
+		/* convert all ATA_DEV_UNKNOWN to ATA_DEV_NONE */
+		if (classes[dev->devno] == ATA_DEV_UNKNOWN)
+			classes[dev->devno] = ATA_DEV_NONE;
+		else
+			nr_known++;
+	}
+
+	if (classify && !nr_known && ata_link_online(link)) {
+		if (try < max_tries) {
+			ata_link_printk(link, KERN_WARNING, "link online but "
+				       "device misclassified, retrying\n");
+			rc = -EAGAIN;
+			goto fail;
+		}
+		ata_link_printk(link, KERN_WARNING,
+			       "link online but device misclassified, "
+			       "device detection might fail\n");
+	}
+
 	/* reset successful, schedule revalidation */
 	ata_eh_done(link, NULL, ATA_EH_RESET);
 	ehc->i.action |= ATA_EH_REVALIDATE;
@@ -2587,7 +2623,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	struct ata_link *link;
 	struct ata_device *dev;
 	int nr_failed_devs, nr_disabled_devs;
-	int reset, rc;
+	int rc;
 	unsigned long flags;
 
 	DPRINTK("ENTER\n");
@@ -2630,7 +2666,6 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	rc = 0;
 	nr_failed_devs = 0;
 	nr_disabled_devs = 0;
-	reset = 0;
 
 	/* if UNLOADING, finish immediately */
 	if (ap->pflags & ATA_PFLAG_UNLOADING)
@@ -2644,40 +2679,24 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		if (ata_eh_skip_recovery(link))
 			ehc->i.action = 0;
 
-		/* do we need to reset? */
-		if (ehc->i.action & ATA_EH_RESET)
-			reset = 1;
-
 		ata_link_for_each_dev(dev, link)
 			ehc->classes[dev->devno] = ATA_DEV_UNKNOWN;
 	}
 
 	/* reset */
-	if (reset) {
-		/* if PMP is attached, this function only deals with
-		 * downstream links, port should stay thawed.
-		 */
-		if (!sata_pmp_attached(ap))
-			ata_eh_freeze_port(ap);
-
-		ata_port_for_each_link(link, ap) {
-			struct ata_eh_context *ehc = &link->eh_context;
+	ata_port_for_each_link(link, ap) {
+		struct ata_eh_context *ehc = &link->eh_context;
 
-			if (!(ehc->i.action & ATA_EH_RESET))
-				continue;
+		if (!(ehc->i.action & ATA_EH_RESET))
+			continue;
 
-			rc = ata_eh_reset(link, ata_link_nr_vacant(link),
-					  prereset, softreset, hardreset,
-					  postreset);
-			if (rc) {
-				ata_link_printk(link, KERN_ERR,
-						"reset failed, giving up\n");
-				goto out;
-			}
+		rc = ata_eh_reset(link, ata_link_nr_vacant(link),
+				  prereset, softreset, hardreset, postreset);
+		if (rc) {
+			ata_link_printk(link, KERN_ERR,
+					"reset failed, giving up\n");
+			goto out;
 		}
-
-		if (!sata_pmp_attached(ap))
-			ata_eh_thaw_port(ap);
 	}
 
 	/* the rest */
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index ff1822a..0f9386d 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -48,7 +48,7 @@ static unsigned int sata_pmp_read(struct ata_link *link, int reg, u32 *r_val)
 	tf.device = link->pmp;
 
 	err_mask = ata_exec_internal(pmp_dev, &tf, NULL, DMA_NONE, NULL, 0,
-				     SATA_PMP_SCR_TIMEOUT);
+				     SATA_PMP_RW_TIMEOUT);
 	if (err_mask)
 		return err_mask;
 
@@ -88,7 +88,7 @@ static unsigned int sata_pmp_write(struct ata_link *link, int reg, u32 val)
 	tf.lbah = (val >> 24) & 0xff;
 
 	return ata_exec_internal(pmp_dev, &tf, NULL, DMA_NONE, NULL, 0,
-				 SATA_PMP_SCR_TIMEOUT);
+				 SATA_PMP_RW_TIMEOUT);
 }
 
 /**
@@ -257,19 +257,6 @@ static int sata_pmp_configure(struct ata_device *dev, int print_info)
 		goto fail;
 	}
 
-	/* turn off notification till fan-out ports are reset and configured */
-	if (gscr[SATA_PMP_GSCR_FEAT_EN] & SATA_PMP_FEAT_NOTIFY) {
-		gscr[SATA_PMP_GSCR_FEAT_EN] &= ~SATA_PMP_FEAT_NOTIFY;
-
-		err_mask = sata_pmp_write(dev->link, SATA_PMP_GSCR_FEAT_EN,
-					  gscr[SATA_PMP_GSCR_FEAT_EN]);
-		if (err_mask) {
-			rc = -EIO;
-			reason = "failed to write GSCR_FEAT_EN";
-			goto fail;
-		}
-	}
-
 	if (print_info) {
 		ata_dev_printk(dev, KERN_INFO, "Port Multiplier %s, "
 			       "0x%04x:0x%04x r%d, %d ports, feat 0x%x/0x%x\n",
@@ -700,8 +687,6 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 	if (ehc->i.action & ATA_EH_RESET) {
 		struct ata_link *tlink;
 
-		ata_eh_freeze_port(ap);
-
 		/* reset */
 		rc = ata_eh_reset(link, 0, prereset, softreset, hardreset,
 				  postreset);
@@ -711,8 +696,6 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 			goto fail;
 		}
 
-		ata_eh_thaw_port(ap);
-
 		/* PMP is reset, SErrors cannot be trusted, scan all */
 		ata_port_for_each_link(tlink, ap) {
 			struct ata_eh_context *ehc = &tlink->eh_context;
@@ -864,6 +847,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 	struct ata_link *pmp_link = &ap->link;
 	struct ata_device *pmp_dev = pmp_link->device;
 	struct ata_eh_context *pmp_ehc = &pmp_link->eh_context;
+	u32 *gscr = pmp_dev->gscr;
 	struct ata_link *link;
 	struct ata_device *dev;
 	unsigned int err_mask;
@@ -901,6 +885,22 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 	if (rc)
 		goto pmp_fail;
 
+	/* PHY event notification can disturb reset and other recovery
+	 * operations.  Turn it off.
+	 */
+	if (gscr[SATA_PMP_GSCR_FEAT_EN] & SATA_PMP_FEAT_NOTIFY) {
+		gscr[SATA_PMP_GSCR_FEAT_EN] &= ~SATA_PMP_FEAT_NOTIFY;
+
+		err_mask = sata_pmp_write(pmp_link, SATA_PMP_GSCR_FEAT_EN,
+					  gscr[SATA_PMP_GSCR_FEAT_EN]);
+		if (err_mask) {
+			ata_link_printk(pmp_link, KERN_WARNING,
+				"failed to disable NOTIFY (err_mask=0x%x)\n",
+				err_mask);
+			goto pmp_fail;
+		}
+	}
+
 	/* handle disabled links */
 	rc = sata_pmp_eh_handle_disabled_links(ap);
 	if (rc)
@@ -923,10 +923,10 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 
 	/* enable notification */
 	if (pmp_dev->flags & ATA_DFLAG_AN) {
-		pmp_dev->gscr[SATA_PMP_GSCR_FEAT_EN] |= SATA_PMP_FEAT_NOTIFY;
+		gscr[SATA_PMP_GSCR_FEAT_EN] |= SATA_PMP_FEAT_NOTIFY;
 
-		err_mask = sata_pmp_write(pmp_dev->link, SATA_PMP_GSCR_FEAT_EN,
-					  pmp_dev->gscr[SATA_PMP_GSCR_FEAT_EN]);
+		err_mask = sata_pmp_write(pmp_link, SATA_PMP_GSCR_FEAT_EN,
+					  gscr[SATA_PMP_GSCR_FEAT_EN]);
 		if (err_mask) {
 			ata_dev_printk(pmp_dev, KERN_ERR, "failed to write "
 				       "PMP_FEAT_EN (Emask=0x%x)\n", err_mask);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3ce4392..aeb6e01 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1082,12 +1082,6 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 	if (((cdb[4] >> 4) & 0xf) != 0)
 		goto invalid_fld;       /* power conditions not supported */
 
-	if (qc->dev->horkage & ATA_HORKAGE_SKIP_PM) {
-		/* the device lacks PM support, finish without doing anything */
-		scmd->result = SAM_STAT_GOOD;
-		return 1;
-	}
-
 	if (cdb[4] & 0x1) {
 		tf->nsect = 1;	/* 1 sector, lba=0 */
 
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index fcabe46..0f3e659 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -177,11 +177,11 @@ static void ali_program_modes(struct ata_port *ap, struct ata_device *adev, stru
 	u8 udma;
 
 	if (t != NULL) {
-		t->setup = FIT(t->setup, 1, 8) & 7;
-		t->act8b = FIT(t->act8b, 1, 8) & 7;
-		t->rec8b = FIT(t->rec8b, 1, 16) & 15;
-		t->active = FIT(t->active, 1, 8) & 7;
-		t->recover = FIT(t->recover, 1, 16) & 15;
+		t->setup = clamp_val(t->setup, 1, 8) & 7;
+		t->act8b = clamp_val(t->act8b, 1, 8) & 7;
+		t->rec8b = clamp_val(t->rec8b, 1, 16) & 15;
+		t->active = clamp_val(t->active, 1, 8) & 7;
+		t->recover = clamp_val(t->recover, 1, 16) & 15;
 
 		pci_write_config_byte(pdev, cas, t->setup);
 		pci_write_config_byte(pdev, cbt, (t->act8b << 4) | t->rec8b);
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 26665c3..57dd00f 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -84,32 +84,32 @@ static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offse
 
 	/* Configure the address set up timing */
 	pci_read_config_byte(pdev, offset + 0x0C, &t);
-	t = (t & ~(3 << ((3 - dn) << 1))) | ((FIT(at.setup, 1, 4) - 1) << ((3 - dn) << 1));
+	t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(at.setup, 1, 4) - 1) << ((3 - dn) << 1));
 	pci_write_config_byte(pdev, offset + 0x0C , t);
 
 	/* Configure the 8bit I/O timing */
 	pci_write_config_byte(pdev, offset + 0x0E + (1 - (dn >> 1)),
-		((FIT(at.act8b, 1, 16) - 1) << 4) | (FIT(at.rec8b, 1, 16) - 1));
+		((clamp_val(at.act8b, 1, 16) - 1) << 4) | (clamp_val(at.rec8b, 1, 16) - 1));
 
 	/* Drive timing */
 	pci_write_config_byte(pdev, offset + 0x08 + (3 - dn),
-		((FIT(at.active, 1, 16) - 1) << 4) | (FIT(at.recover, 1, 16) - 1));
+		((clamp_val(at.active, 1, 16) - 1) << 4) | (clamp_val(at.recover, 1, 16) - 1));
 
 	switch (clock) {
 		case 1:
-		t = at.udma ? (0xc0 | (FIT(at.udma, 2, 5) - 2)) : 0x03;
+		t = at.udma ? (0xc0 | (clamp_val(at.udma, 2, 5) - 2)) : 0x03;
 		break;
 
 		case 2:
-		t = at.udma ? (0xc0 | amd_cyc2udma[FIT(at.udma, 2, 10)]) : 0x03;
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 2, 10)]) : 0x03;
 		break;
 
 		case 3:
-		t = at.udma ? (0xc0 | amd_cyc2udma[FIT(at.udma, 1, 10)]) : 0x03;
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 1, 10)]) : 0x03;
 		break;
 
 		case 4:
-		t = at.udma ? (0xc0 | amd_cyc2udma[FIT(at.udma, 1, 15)]) : 0x03;
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 1, 15)]) : 0x03;
 		break;
 
 		default:
diff --git a/drivers/ata/pata_at32.c b/drivers/ata/pata_at32.c
index 5e10438..82fb6e2 100644
--- a/drivers/ata/pata_at32.c
+++ b/drivers/ata/pata_at32.c
@@ -291,8 +291,6 @@ static int __init pata_at32_probe(struct platform_device *pdev)
 	if (!info)
 		return -ENOMEM;
 
-	memset(info, 0, sizeof(struct at32_ide_info));
-
 	info->irq = irq;
 	info->cs  = board->cs;
 
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 9ab8973..5551610 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -911,7 +911,10 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 	/* Reset all transfer count */
 	ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base) | TFRCNT_RST);
 
-		/* Set transfer length to buffer len */
+	/* Set ATAPI state machine contorl in terminate sequence */
+	ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base) | END_ON_TERM);
+
+	/* Set transfer length to buffer len */
 	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		ATAPI_SET_XFER_LEN(base, (sg_dma_len(sg) >> 1));
 	}
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index a9c3218..2ff6260 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -62,14 +62,14 @@ static void cy82c693_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		return;
 	}
 
-	time_16 = FIT(t.recover, 0, 15) | (FIT(t.active, 0, 15) << 4);
-	time_8 = FIT(t.act8b, 0, 15) | (FIT(t.rec8b, 0, 15) << 4);
+	time_16 = clamp_val(t.recover, 0, 15) | (clamp_val(t.active, 0, 15) << 4);
+	time_8 = clamp_val(t.act8b, 0, 15) | (clamp_val(t.rec8b, 0, 15) << 4);
 
 	if (adev->devno == 0) {
 		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
 
 		addr &= ~0x0F;	/* Mask bits */
-		addr |= FIT(t.setup, 0, 15);
+		addr |= clamp_val(t.setup, 0, 15);
 
 		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
 		pci_write_config_byte(pdev, CY82_IDE_MASTER_IOR, time_16);
@@ -79,7 +79,7 @@ static void cy82c693_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
 
 		addr &= ~0xF0;	/* Mask bits */
-		addr |= (FIT(t.setup, 0, 15) << 4);
+		addr |= (clamp_val(t.setup, 0, 15) << 4);
 
 		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
 		pci_write_config_byte(pdev, CY82_IDE_SLAVE_IOR, time_16);
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 7af4b29..fe7cc8e 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -343,8 +343,8 @@ static void ht6560a_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	/* Get the timing data in cycles. For now play safe at 50Mhz */
 	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
 
-	active = FIT(t.active, 2, 15);
-	recover = FIT(t.recover, 4, 15);
+	active = clamp_val(t.active, 2, 15);
+	recover = clamp_val(t.recover, 4, 15);
 
 	inb(0x3E6);
 	inb(0x3E6);
@@ -377,8 +377,8 @@ static void ht6560b_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	/* Get the timing data in cycles. For now play safe at 50Mhz */
 	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
 
-	active = FIT(t.active, 2, 15);
-	recover = FIT(t.recover, 2, 16);
+	active = clamp_val(t.active, 2, 15);
+	recover = clamp_val(t.recover, 2, 16);
 	recover &= 0x15;
 
 	inb(0x3E6);
@@ -462,9 +462,9 @@ static void opti82c611a_set_piomode(struct ata_port *ap,
 		ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
 	}
 
-	active = FIT(t.active, 2, 17) - 2;
-	recover = FIT(t.recover, 1, 16) - 1;
-	setup = FIT(t.setup, 1, 4) - 1;
+	active = clamp_val(t.active, 2, 17) - 2;
+	recover = clamp_val(t.recover, 1, 16) - 1;
+	setup = clamp_val(t.setup, 1, 4) - 1;
 
 	/* Select the right timing bank for write timing */
 	rc = ioread8(ap->ioaddr.lbal_addr);
@@ -541,9 +541,9 @@ static void opti82c46x_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
 	}
 
-	active = FIT(t.active, 2, 17) - 2;
-	recover = FIT(t.recover, 1, 16) - 1;
-	setup = FIT(t.setup, 1, 4) - 1;
+	active = clamp_val(t.active, 2, 17) - 2;
+	recover = clamp_val(t.recover, 1, 16) - 1;
+	setup = clamp_val(t.setup, 1, 4) - 1;
 
 	/* Select the right timing bank for write timing */
 	rc = ioread8(ap->ioaddr.lbal_addr);
@@ -624,11 +624,11 @@ static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (ld_qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
@@ -658,11 +658,11 @@ static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (ld_qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
@@ -695,11 +695,11 @@ static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (ld_qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 	ld_qdi->clock[adev->devno] = timing;
@@ -830,8 +830,8 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	else
 		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
-	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
+	active = (clamp_val(t.active, 3, 17) - 1) & 0x0F;
+	recovery = (clamp_val(t.recover, 1, 15) + 1) & 0x0F;
 	timing = (active << 4) | recovery;
 	winbond_writecfg(ld_winbond->timing, timing, reg);
 
@@ -842,7 +842,7 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		reg |= 0x08;	/* FIFO off */
 	if (!ata_pio_need_iordy(adev))
 		reg |= 0x02;	/* IORDY off */
-	reg |= (FIT(t.setup, 0, 3) << 6);
+	reg |= (clamp_val(t.setup, 0, 3) << 6);
 	winbond_writecfg(ld_winbond->timing, timing + 1, reg);
 }
 
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 76d2455..be756b7 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -91,9 +91,9 @@ static void ns87410_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		return;
 	}
 
-	at.active = FIT(at.active, 2, 16) - 2;
-	at.setup = FIT(at.setup, 1, 4) - 1;
-	at.recover = FIT(at.recover, 1, 12) - 1;
+	at.active = clamp_val(at.active, 2, 16) - 2;
+	at.setup = clamp_val(at.setup, 1, 4) - 1;
+	at.recover = clamp_val(at.recover, 1, 12) - 1;
 
 	idetcr = (at.setup << 6) | (recoverbits[at.recover] << 3) | activebits[at.active];
 
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index ae92b00..e0aa7ea 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -66,8 +66,8 @@ static void ns87415_set_mode(struct ata_port *ap, struct ata_device *adev, u8 mo
 
 	ata_timing_compute(adev, adev->pio_mode, &t, T, 0);
 
-	clocking = 17 - FIT(t.active, 2, 17);
-	clocking |= (16 - FIT(t.recover, 1, 16)) << 4;
+	clocking = 17 - clamp_val(t.active, 2, 17);
+	clocking |= (16 - clamp_val(t.recover, 1, 16)) << 4;
  	/* Use the same timing for read and write bytes */
 	clocking |= (clocking << 8);
 	pci_write_config_word(dev, timing, clocking);
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index bf45cf0..97e5b09 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -60,11 +60,11 @@ static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
@@ -84,11 +84,11 @@ static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 70d94fb..69877bd 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -216,7 +216,7 @@ static int sl82c105_qc_defer(struct ata_queued_cmd *qc)
 	struct ata_port *alt = host->ports[1 ^ qc->ap->port_no];
 	int rc;
 
-	/* First apply the usual rules */	
+	/* First apply the usual rules */
 	rc = ata_std_qc_defer(qc);
 	if (rc != 0)
 		return rc;
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 2fea6cb..708ed14 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -259,15 +259,15 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 
 		pci_read_config_byte(pdev, 0x4C, &setup);
 		setup &= ~(3 << shift);
-		setup |= FIT(t.setup, 1, 4) << shift;	/* 1,4 or 1,4 - 1  FIXME */
+		setup |= clamp_val(t.setup, 1, 4) << shift;	/* 1,4 or 1,4 - 1  FIXME */
 		pci_write_config_byte(pdev, 0x4C, setup);
 	}
 
 	/* Load the PIO mode bits */
 	pci_write_config_byte(pdev, 0x4F - ap->port_no,
-		((FIT(t.act8b, 1, 16) - 1) << 4) | (FIT(t.rec8b, 1, 16) - 1));
+		((clamp_val(t.act8b, 1, 16) - 1) << 4) | (clamp_val(t.rec8b, 1, 16) - 1));
 	pci_write_config_byte(pdev, 0x48 + offset,
-		((FIT(t.active, 1, 16) - 1) << 4) | (FIT(t.recover, 1, 16) - 1));
+		((clamp_val(t.active, 1, 16) - 1) << 4) | (clamp_val(t.recover, 1, 16) - 1));
 
 	/* Load the UDMA bits according to type */
 	switch(udma_type) {
@@ -275,16 +275,16 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 			/* BUG() ? */
 			/* fall through */
 		case 33:
-			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 5) - 2)) : 0x03;
+			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 5) - 2)) : 0x03;
 			break;
 		case 66:
-			ut = t.udma ? (0xe8 | (FIT(t.udma, 2, 9) - 2)) : 0x0f;
+			ut = t.udma ? (0xe8 | (clamp_val(t.udma, 2, 9) - 2)) : 0x0f;
 			break;
 		case 100:
-			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 9) - 2)) : 0x07;
+			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
 			break;
 		case 133:
-			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 9) - 2)) : 0x07;
+			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
 			break;
 	}
 
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 6e52a35..474528f 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -75,8 +75,8 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	else
 		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
-	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
+	active = (clamp_val(t.active, 3, 17) - 1) & 0x0F;
+	recovery = (clamp_val(t.recover, 1, 15) + 1) & 0x0F;
 	timing = (active << 4) | recovery;
 	winbond_writecfg(winbond->config, timing, reg);
 
@@ -87,7 +87,7 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		reg |= 0x08;	/* FIFO off */
 	if (!ata_pio_need_iordy(adev))
 		reg |= 0x02;	/* IORDY off */
-	reg |= (FIT(t.setup, 0, 3) << 6);
+	reg |= (clamp_val(t.setup, 0, 3) << 6);
 	winbond_writecfg(winbond->config, timing + 1, reg);
 }
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index bb73b22..fb81f0c 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -72,7 +72,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_mv"
-#define DRV_VERSION	"1.20"
+#define DRV_VERSION	"1.21"
 
 enum {
 	/* BAR's are enumerated in terms of pci_resource_start() terms */
@@ -128,8 +128,13 @@ enum {
 	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_NO_ATAPI |
 				  ATA_FLAG_PIO_POLLING,
+
 	MV_6XXX_FLAGS		= MV_FLAG_IRQ_COALESCE,
 
+	MV_GENIIE_FLAGS		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
+				  ATA_FLAG_PMP | ATA_FLAG_ACPI_SATA |
+				  ATA_FLAG_NCQ | ATA_FLAG_AN,
+
 	CRQB_FLAG_READ		= (1 << 0),
 	CRQB_TAG_SHIFT		= 1,
 	CRQB_IOID_SHIFT		= 6,	/* CRQB Gen-II/IIE IO Id shift */
@@ -197,13 +202,6 @@ enum {
 	HC_MAIN_RSVD		= (0x7f << 25),	/* bits 31-25 */
 	HC_MAIN_RSVD_5		= (0x1fff << 19), /* bits 31-19 */
 	HC_MAIN_RSVD_SOC	= (0x3fffffb << 6),     /* bits 31-9, 7-6 */
-	HC_MAIN_MASKED_IRQS	= (TRAN_LO_DONE | TRAN_HI_DONE |
-				   PORTS_0_3_COAL_DONE | PORTS_4_7_COAL_DONE |
-				   PORTS_0_7_COAL_DONE | GPIO_INT | TWSI_INT |
-				   HC_MAIN_RSVD),
-	HC_MAIN_MASKED_IRQS_5	= (PORTS_0_3_COAL_DONE | PORTS_4_7_COAL_DONE |
-				   HC_MAIN_RSVD_5),
-	HC_MAIN_MASKED_IRQS_SOC = (PORTS_0_3_COAL_DONE | HC_MAIN_RSVD_SOC),
 
 	/* SATAHC registers */
 	HC_CFG_OFS		= 0,
@@ -221,6 +219,7 @@ enum {
 	SATA_STATUS_OFS		= 0x300,  /* ctrl, err regs follow status */
 	SATA_ACTIVE_OFS		= 0x350,
 	SATA_FIS_IRQ_CAUSE_OFS	= 0x364,
+	SATA_FIS_IRQ_AN		= (1 << 9),	/* async notification */
 
 	LTMODE_OFS		= 0x30c,
 	LTMODE_BIT8		= (1 << 8),	/* unknown, but necessary */
@@ -459,6 +458,7 @@ struct mv_port_signal {
 
 struct mv_host_priv {
 	u32			hp_flags;
+	u32			main_irq_mask;
 	struct mv_port_signal	signal[8];
 	const struct mv_hw_ops	*ops;
 	int			n_ports;
@@ -640,25 +640,19 @@ static const struct ata_port_info mv_port_info[] = {
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_6042 */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
-				  ATA_FLAG_PMP | ATA_FLAG_ACPI_SATA |
-				  ATA_FLAG_NCQ,
+		.flags		= MV_GENIIE_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_7042 */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
-				  ATA_FLAG_PMP | ATA_FLAG_ACPI_SATA |
-				  ATA_FLAG_NCQ,
+		.flags		= MV_GENIIE_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_soc */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
-				  ATA_FLAG_PMP | ATA_FLAG_ACPI_SATA |
-				  ATA_FLAG_NCQ | MV_FLAG_SOC,
+		.flags		= MV_GENIIE_FLAGS | MV_FLAG_SOC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
@@ -844,6 +838,33 @@ static void mv_set_edma_ptrs(void __iomem *port_mmio,
 		 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
 }
 
+static void mv_set_main_irq_mask(struct ata_host *host,
+				 u32 disable_bits, u32 enable_bits)
+{
+	struct mv_host_priv *hpriv = host->private_data;
+	u32 old_mask, new_mask;
+
+	old_mask = hpriv->main_irq_mask;
+	new_mask = (old_mask & ~disable_bits) | enable_bits;
+	if (new_mask != old_mask) {
+		hpriv->main_irq_mask = new_mask;
+		writelfl(new_mask, hpriv->main_irq_mask_addr);
+	}
+}
+
+static void mv_enable_port_irqs(struct ata_port *ap,
+				     unsigned int port_bits)
+{
+	unsigned int shift, hardport, port = ap->port_no;
+	u32 disable_bits, enable_bits;
+
+	MV_PORT_TO_SHIFT_AND_HARDPORT(port, shift, hardport);
+
+	disable_bits = (DONE_IRQ | ERR_IRQ) << shift;
+	enable_bits  = port_bits << shift;
+	mv_set_main_irq_mask(ap->host, disable_bits, enable_bits);
+}
+
 /**
  *      mv_start_dma - Enable eDMA engine
  *      @base: port base address
@@ -886,9 +907,11 @@ static void mv_start_dma(struct ata_port *ap, void __iomem *port_mmio,
 		mv_edma_cfg(ap, want_ncq);
 
 		/* clear FIS IRQ Cause */
-		writelfl(0, port_mmio + SATA_FIS_IRQ_CAUSE_OFS);
+		if (IS_GEN_IIE(hpriv))
+			writelfl(0, port_mmio + SATA_FIS_IRQ_CAUSE_OFS);
 
 		mv_set_edma_ptrs(port_mmio, hpriv, pp);
+		mv_enable_port_irqs(ap, DONE_IRQ|ERR_IRQ);
 
 		writelfl(EDMA_EN, port_mmio + EDMA_CMD_OFS);
 		pp->pp_flags |= MV_PP_FLAG_EDMA_EN;
@@ -1341,6 +1364,7 @@ out_port_free_dma_mem:
 static void mv_port_stop(struct ata_port *ap)
 {
 	mv_stop_edma(ap);
+	mv_enable_port_irqs(ap, 0);
 	mv_port_free_dma_mem(ap);
 }
 
@@ -1582,6 +1606,7 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 		 * shadow block, etc registers.
 		 */
 		mv_stop_edma(ap);
+		mv_enable_port_irqs(ap, ERR_IRQ);
 		mv_pmp_select(ap, qc->dev->link->pmp);
 		return ata_sff_qc_issue(qc);
 	}
@@ -1670,6 +1695,18 @@ static void mv_pmp_eh_prep(struct ata_port *ap, unsigned int pmp_map)
 	}
 }
 
+static int mv_req_q_empty(struct ata_port *ap)
+{
+	void __iomem *port_mmio = mv_ap_base(ap);
+	u32 in_ptr, out_ptr;
+
+	in_ptr  = (readl(port_mmio + EDMA_REQ_Q_IN_PTR_OFS)
+			>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
+	out_ptr = (readl(port_mmio + EDMA_REQ_Q_OUT_PTR_OFS)
+			>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
+	return (in_ptr == out_ptr);	/* 1 == queue_is_empty */
+}
+
 static int mv_handle_fbs_ncq_dev_err(struct ata_port *ap)
 {
 	struct mv_port_priv *pp = ap->private_data;
@@ -1703,7 +1740,7 @@ static int mv_handle_fbs_ncq_dev_err(struct ata_port *ap)
 			ap->qc_active, failed_links,
 			ap->nr_active_links);
 
-	if (ap->nr_active_links <= failed_links) {
+	if (ap->nr_active_links <= failed_links && mv_req_q_empty(ap)) {
 		mv_process_crpb_entries(ap, pp);
 		mv_stop_edma(ap);
 		mv_eh_freeze(ap);
@@ -1812,6 +1849,7 @@ static void mv_err_intr(struct ata_port *ap)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
 	u32 edma_err_cause, eh_freeze_mask, serr = 0;
+	u32 fis_cause = 0;
 	struct mv_port_priv *pp = ap->private_data;
 	struct mv_host_priv *hpriv = ap->host->private_data;
 	unsigned int action = 0, err_mask = 0;
@@ -1821,16 +1859,19 @@ static void mv_err_intr(struct ata_port *ap)
 
 	/*
 	 * Read and clear the SError and err_cause bits.
+	 * For GenIIe, if EDMA_ERR_TRANS_IRQ_7 is set, we also must read/clear
+	 * the FIS_IRQ_CAUSE register before clearing edma_err_cause.
 	 */
 	sata_scr_read(&ap->link, SCR_ERROR, &serr);
 	sata_scr_write_flush(&ap->link, SCR_ERROR, serr);
 
 	edma_err_cause = readl(port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+	if (IS_GEN_IIE(hpriv) && (edma_err_cause & EDMA_ERR_TRANS_IRQ_7)) {
+		fis_cause = readl(port_mmio + SATA_FIS_IRQ_CAUSE_OFS);
+		writelfl(~fis_cause, port_mmio + SATA_FIS_IRQ_CAUSE_OFS);
+	}
 	writelfl(~edma_err_cause, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-	ata_port_printk(ap, KERN_INFO, "%s: err_cause=%08x pp_flags=0x%x\n",
-			__func__, edma_err_cause, pp->pp_flags);
-
 	if (edma_err_cause & EDMA_ERR_DEV) {
 		/*
 		 * Device errors during FIS-based switching operation
@@ -1844,6 +1885,18 @@ static void mv_err_intr(struct ata_port *ap)
 	ata_ehi_clear_desc(ehi);
 	ata_ehi_push_desc(ehi, "edma_err_cause=%08x pp_flags=%08x",
 			  edma_err_cause, pp->pp_flags);
+
+	if (IS_GEN_IIE(hpriv) && (edma_err_cause & EDMA_ERR_TRANS_IRQ_7)) {
+		ata_ehi_push_desc(ehi, "fis_cause=%08x", fis_cause);
+		if (fis_cause & SATA_FIS_IRQ_AN) {
+			u32 ec = edma_err_cause &
+			       ~(EDMA_ERR_TRANS_IRQ_7 | EDMA_ERR_IRQ_TRANSIENT);
+			sata_async_notification(ap);
+			if (!ec)
+				return; /* Just an AN; no need for the nukes */
+			ata_ehi_push_desc(ehi, "SDB notify");
+		}
+	}
 	/*
 	 * All generations share these EDMA error cause bits:
 	 */
@@ -2162,20 +2215,20 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 	struct ata_host *host = dev_instance;
 	struct mv_host_priv *hpriv = host->private_data;
 	unsigned int handled = 0;
-	u32 main_irq_cause, main_irq_mask;
+	u32 main_irq_cause, pending_irqs;
 
 	spin_lock(&host->lock);
 	main_irq_cause = readl(hpriv->main_irq_cause_addr);
-	main_irq_mask  = readl(hpriv->main_irq_mask_addr);
+	pending_irqs   = main_irq_cause & hpriv->main_irq_mask;
 	/*
 	 * Deal with cases where we either have nothing pending, or have read
 	 * a bogus register value which can indicate HW removal or PCI fault.
 	 */
-	if ((main_irq_cause & main_irq_mask) && (main_irq_cause != 0xffffffffU)) {
-		if (unlikely((main_irq_cause & PCI_ERR) && HAS_PCI(host)))
+	if (pending_irqs && main_irq_cause != 0xffffffffU) {
+		if (unlikely((pending_irqs & PCI_ERR) && HAS_PCI(host)))
 			handled = mv_pci_error(host, hpriv->base);
 		else
-			handled = mv_host_intr(host, main_irq_cause);
+			handled = mv_host_intr(host, pending_irqs);
 	}
 	spin_unlock(&host->lock);
 	return IRQ_RETVAL(handled);
@@ -2373,7 +2426,6 @@ static void mv_reset_pci_bus(struct ata_host *host, void __iomem *mmio)
 	ZERO(MV_PCI_DISC_TIMER);
 	ZERO(MV_PCI_MSI_TRIGGER);
 	writel(0x000100ff, mmio + MV_PCI_XBAR_TMOUT_OFS);
-	ZERO(PCI_HC_MAIN_IRQ_MASK_OFS);
 	ZERO(MV_PCI_SERR_MASK);
 	ZERO(hpriv->irq_cause_ofs);
 	ZERO(hpriv->irq_mask_ofs);
@@ -2728,6 +2780,7 @@ static int mv_hardreset(struct ata_link *link, unsigned int *class,
 
 		rc = sata_link_hardreset(link, timing, deadline + extra,
 					 &online, NULL);
+		rc = online ? -EAGAIN : rc;
 		if (rc)
 			return rc;
 		sata_scr_read(link, SCR_STATUS, &sstatus);
@@ -2744,32 +2797,18 @@ static int mv_hardreset(struct ata_link *link, unsigned int *class,
 
 static void mv_eh_freeze(struct ata_port *ap)
 {
-	struct mv_host_priv *hpriv = ap->host->private_data;
-	unsigned int shift, hardport, port = ap->port_no;
-	u32 main_irq_mask;
-
-	/* FIXME: handle coalescing completion events properly */
-
 	mv_stop_edma(ap);
-	MV_PORT_TO_SHIFT_AND_HARDPORT(port, shift, hardport);
-
-	/* disable assertion of portN err, done events */
-	main_irq_mask = readl(hpriv->main_irq_mask_addr);
-	main_irq_mask &= ~((DONE_IRQ | ERR_IRQ) << shift);
-	writelfl(main_irq_mask, hpriv->main_irq_mask_addr);
+	mv_enable_port_irqs(ap, 0);
 }
 
 static void mv_eh_thaw(struct ata_port *ap)
 {
 	struct mv_host_priv *hpriv = ap->host->private_data;
-	unsigned int shift, hardport, port = ap->port_no;
+	unsigned int port = ap->port_no;
+	unsigned int hardport = mv_hardport_from_port(port);
 	void __iomem *hc_mmio = mv_hc_base_from_port(hpriv->base, port);
 	void __iomem *port_mmio = mv_ap_base(ap);
-	u32 main_irq_mask, hc_irq_cause;
-
-	/* FIXME: handle coalescing completion events properly */
-
-	MV_PORT_TO_SHIFT_AND_HARDPORT(port, shift, hardport);
+	u32 hc_irq_cause;
 
 	/* clear EDMA errors on this port */
 	writel(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
@@ -2779,10 +2818,7 @@ static void mv_eh_thaw(struct ata_port *ap)
 	hc_irq_cause &= ~((DEV_IRQ | DMA_IRQ) << hardport);
 	writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
 
-	/* enable assertion of portN err, done events */
-	main_irq_mask = readl(hpriv->main_irq_mask_addr);
-	main_irq_mask |= ((DONE_IRQ | ERR_IRQ) << shift);
-	writelfl(main_irq_mask, hpriv->main_irq_mask_addr);
+	mv_enable_port_irqs(ap, ERR_IRQ);
 }
 
 /**
@@ -3035,7 +3071,7 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 	}
 
 	/* global interrupt mask: 0 == mask everything */
-	writel(0, hpriv->main_irq_mask_addr);
+	mv_set_main_irq_mask(host, ~0, 0);
 
 	n_hc = mv_get_hc_count(host->ports[0]->flags);
 
@@ -3083,25 +3119,12 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 
 		/* and unmask interrupt generation for host regs */
 		writelfl(hpriv->unmask_all_irqs, mmio + hpriv->irq_mask_ofs);
-		if (IS_GEN_I(hpriv))
-			writelfl(~HC_MAIN_MASKED_IRQS_5,
-				 hpriv->main_irq_mask_addr);
-		else
-			writelfl(~HC_MAIN_MASKED_IRQS,
-				 hpriv->main_irq_mask_addr);
-
-		VPRINTK("HC MAIN IRQ cause/mask=0x%08x/0x%08x "
-			"PCI int cause/mask=0x%08x/0x%08x\n",
-			readl(hpriv->main_irq_cause_addr),
-			readl(hpriv->main_irq_mask_addr),
-			readl(mmio + hpriv->irq_cause_ofs),
-			readl(mmio + hpriv->irq_mask_ofs));
-	} else {
-		writelfl(~HC_MAIN_MASKED_IRQS_SOC,
-			 hpriv->main_irq_mask_addr);
-		VPRINTK("HC MAIN IRQ cause/mask=0x%08x/0x%08x\n",
-			readl(hpriv->main_irq_cause_addr),
-			readl(hpriv->main_irq_mask_addr));
+
+		/*
+		 * enable only global host interrupts for now.
+		 * The per-port interrupts get done later as ports are set up.
+		 */
+		mv_set_main_irq_mask(host, 0, PCI_ERR);
 	}
 done:
 	return rc;
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 5a10dc5..030665b 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -53,7 +53,15 @@ enum {
 	PDC_MMIO_BAR		= 3,
 	PDC_MAX_PRD		= LIBATA_MAX_PRD - 1, /* -1 for ASIC PRD bug workaround */
 
-	/* register offsets */
+	/* host register offsets (from host->iomap[PDC_MMIO_BAR]) */
+	PDC_INT_SEQMASK		= 0x40,	/* Mask of asserted SEQ INTs */
+	PDC_FLASH_CTL		= 0x44, /* Flash control register */
+	PDC_SATA_PLUG_CSR	= 0x6C, /* SATA Plug control/status reg */
+	PDC2_SATA_PLUG_CSR	= 0x60, /* SATAII Plug control/status reg */
+	PDC_TBG_MODE		= 0x41C, /* TBG mode (not SATAII) */
+	PDC_SLEW_CTL		= 0x470, /* slew rate control reg (not SATAII) */
+
+	/* per-port ATA register offsets (from ap->ioaddr.cmd_addr) */
 	PDC_FEATURE		= 0x04, /* Feature/Error reg (per port) */
 	PDC_SECTOR_COUNT	= 0x08, /* Sector count reg (per port) */
 	PDC_SECTOR_NUMBER	= 0x0C, /* Sector number reg (per port) */
@@ -63,14 +71,11 @@ enum {
 	PDC_COMMAND		= 0x1C, /* Command/status reg (per port) */
 	PDC_ALTSTATUS		= 0x38, /* Alternate-status/device-control reg (per port) */
 	PDC_PKT_SUBMIT		= 0x40, /* Command packet pointer addr */
-	PDC_INT_SEQMASK		= 0x40,	/* Mask of asserted SEQ INTs */
-	PDC_FLASH_CTL		= 0x44, /* Flash control register */
 	PDC_GLOBAL_CTL		= 0x48, /* Global control/status (per port) */
 	PDC_CTLSTAT		= 0x60,	/* IDE control and status (per port) */
-	PDC_SATA_PLUG_CSR	= 0x6C, /* SATA Plug control/status reg */
-	PDC2_SATA_PLUG_CSR	= 0x60, /* SATAII Plug control/status reg */
-	PDC_TBG_MODE		= 0x41C, /* TBG mode (not SATAII) */
-	PDC_SLEW_CTL		= 0x470, /* slew rate control reg (not SATAII) */
+
+	/* per-port SATA register offsets (from ap->ioaddr.scr_addr) */
+	PDC_PHYMODE4		= 0x14,
 
 	/* PDC_GLOBAL_CTL bit definitions */
 	PDC_PH_ERR		= (1 <<  8), /* PCI error while loading packet */
@@ -134,7 +139,7 @@ struct pdc_port_priv {
 
 static int pdc_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
 static int pdc_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
-static int pdc_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
+static int pdc_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int pdc_common_port_start(struct ata_port *ap);
 static int pdc_sata_port_start(struct ata_port *ap);
 static void pdc_qc_prep(struct ata_queued_cmd *qc);
@@ -332,12 +337,12 @@ static int pdc_sata_port_start(struct ata_port *ap)
 
 	/* fix up PHYMODE4 align timing */
 	if (ap->flags & PDC_FLAG_GEN_II) {
-		void __iomem *mmio = ap->ioaddr.scr_addr;
+		void __iomem *sata_mmio = ap->ioaddr.scr_addr;
 		unsigned int tmp;
 
-		tmp = readl(mmio + 0x014);
+		tmp = readl(sata_mmio + PDC_PHYMODE4);
 		tmp = (tmp & ~3) | 1;	/* set bits 1:0 = 0:1 */
-		writel(tmp, mmio + 0x014);
+		writel(tmp, sata_mmio + PDC_PHYMODE4);
 	}
 
 	return 0;
@@ -345,32 +350,32 @@ static int pdc_sata_port_start(struct ata_port *ap)
 
 static void pdc_reset_port(struct ata_port *ap)
 {
-	void __iomem *mmio = ap->ioaddr.cmd_addr + PDC_CTLSTAT;
+	void __iomem *ata_ctlstat_mmio = ap->ioaddr.cmd_addr + PDC_CTLSTAT;
 	unsigned int i;
 	u32 tmp;
 
 	for (i = 11; i > 0; i--) {
-		tmp = readl(mmio);
+		tmp = readl(ata_ctlstat_mmio);
 		if (tmp & PDC_RESET)
 			break;
 
 		udelay(100);
 
 		tmp |= PDC_RESET;
-		writel(tmp, mmio);
+		writel(tmp, ata_ctlstat_mmio);
 	}
 
 	tmp &= ~PDC_RESET;
-	writel(tmp, mmio);
-	readl(mmio);	/* flush */
+	writel(tmp, ata_ctlstat_mmio);
+	readl(ata_ctlstat_mmio);	/* flush */
 }
 
 static int pdc_pata_cable_detect(struct ata_port *ap)
 {
 	u8 tmp;
-	void __iomem *mmio = ap->ioaddr.cmd_addr + PDC_CTLSTAT + 0x03;
+	void __iomem *ata_mmio = ap->ioaddr.cmd_addr;
 
-	tmp = readb(mmio);
+	tmp = readb(ata_mmio + PDC_CTLSTAT + 3);
 	if (tmp & 0x01)
 		return ATA_CBL_PATA40;
 	return ATA_CBL_PATA80;
@@ -557,31 +562,25 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
 		pdc_fill_sg(qc);
-		/* fall through */
-
+		/*FALLTHROUGH*/
 	case ATA_PROT_NODATA:
 		i = pdc_pkt_header(&qc->tf, qc->ap->prd_dma,
 				   qc->dev->devno, pp->pkt);
-
 		if (qc->tf.flags & ATA_TFLAG_LBA48)
 			i = pdc_prep_lba48(&qc->tf, pp->pkt, i);
 		else
 			i = pdc_prep_lba28(&qc->tf, pp->pkt, i);
-
 		pdc_pkt_footer(&qc->tf, pp->pkt, i);
 		break;
-
 	case ATAPI_PROT_PIO:
 		pdc_fill_sg(qc);
 		break;
-
 	case ATAPI_PROT_DMA:
 		pdc_fill_sg(qc);
 		/*FALLTHROUGH*/
 	case ATAPI_PROT_NODATA:
 		pdc_atapi_pkt(qc);
 		break;
-
 	default:
 		break;
 	}
@@ -611,7 +610,7 @@ static unsigned int pdc_sata_ata_port_to_ata_no(const struct ata_port *ap)
 	unsigned int nr_ports = pdc_sata_nr_ports(ap);
 	unsigned int i;
 
-	for(i = 0; i < nr_ports && host->ports[i] != ap; ++i)
+	for (i = 0; i < nr_ports && host->ports[i] != ap; ++i)
 		;
 	BUG_ON(i >= nr_ports);
 	return pdc_port_no_to_ata_no(i, pdc_is_sataii_tx4(ap->flags));
@@ -624,14 +623,14 @@ static unsigned int pdc_sata_hotplug_offset(const struct ata_port *ap)
 
 static void pdc_freeze(struct ata_port *ap)
 {
-	void __iomem *mmio = ap->ioaddr.cmd_addr;
+	void __iomem *ata_mmio = ap->ioaddr.cmd_addr;
 	u32 tmp;
 
-	tmp = readl(mmio + PDC_CTLSTAT);
+	tmp = readl(ata_mmio + PDC_CTLSTAT);
 	tmp |= PDC_IRQ_DISABLE;
 	tmp &= ~PDC_DMA_ENABLE;
-	writel(tmp, mmio + PDC_CTLSTAT);
-	readl(mmio + PDC_CTLSTAT); /* flush */
+	writel(tmp, ata_mmio + PDC_CTLSTAT);
+	readl(ata_mmio + PDC_CTLSTAT); /* flush */
 }
 
 static void pdc_sata_freeze(struct ata_port *ap)
@@ -659,17 +658,17 @@ static void pdc_sata_freeze(struct ata_port *ap)
 
 static void pdc_thaw(struct ata_port *ap)
 {
-	void __iomem *mmio = ap->ioaddr.cmd_addr;
+	void __iomem *ata_mmio = ap->ioaddr.cmd_addr;
 	u32 tmp;
 
 	/* clear IRQ */
-	readl(mmio + PDC_INT_SEQMASK);
+	readl(ata_mmio + PDC_COMMAND);
 
 	/* turn IRQ back on */
-	tmp = readl(mmio + PDC_CTLSTAT);
+	tmp = readl(ata_mmio + PDC_CTLSTAT);
 	tmp &= ~PDC_IRQ_DISABLE;
-	writel(tmp, mmio + PDC_CTLSTAT);
-	readl(mmio + PDC_CTLSTAT); /* flush */
+	writel(tmp, ata_mmio + PDC_CTLSTAT);
+	readl(ata_mmio + PDC_CTLSTAT); /* flush */
 }
 
 static void pdc_sata_thaw(struct ata_port *ap)
@@ -743,11 +742,11 @@ static void pdc_error_intr(struct ata_port *ap, struct ata_queued_cmd *qc,
 	ata_port_abort(ap);
 }
 
-static inline unsigned int pdc_host_intr(struct ata_port *ap,
-					 struct ata_queued_cmd *qc)
+static unsigned int pdc_host_intr(struct ata_port *ap,
+				  struct ata_queued_cmd *qc)
 {
 	unsigned int handled = 0;
-	void __iomem *port_mmio = ap->ioaddr.cmd_addr;
+	void __iomem *ata_mmio = ap->ioaddr.cmd_addr;
 	u32 port_status, err_mask;
 
 	err_mask = PDC_ERR_MASK;
@@ -755,7 +754,7 @@ static inline unsigned int pdc_host_intr(struct ata_port *ap,
 		err_mask &= ~PDC1_ERR_MASK;
 	else
 		err_mask &= ~PDC2_ERR_MASK;
-	port_status = readl(port_mmio + PDC_GLOBAL_CTL);
+	port_status = readl(ata_mmio + PDC_GLOBAL_CTL);
 	if (unlikely(port_status & err_mask)) {
 		pdc_error_intr(ap, qc, port_status, err_mask);
 		return 1;
@@ -770,7 +769,6 @@ static inline unsigned int pdc_host_intr(struct ata_port *ap,
 		ata_qc_complete(qc);
 		handled = 1;
 		break;
-
 	default:
 		ap->stats.idle_irq++;
 		break;
@@ -781,10 +779,9 @@ static inline unsigned int pdc_host_intr(struct ata_port *ap,
 
 static void pdc_irq_clear(struct ata_port *ap)
 {
-	struct ata_host *host = ap->host;
-	void __iomem *mmio = host->iomap[PDC_MMIO_BAR];
+	void __iomem *ata_mmio = ap->ioaddr.cmd_addr;
 
-	readl(mmio + PDC_INT_SEQMASK);
+	readl(ata_mmio + PDC_COMMAND);
 }
 
 static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
@@ -794,7 +791,7 @@ static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 	u32 mask = 0;
 	unsigned int i, tmp;
 	unsigned int handled = 0;
-	void __iomem *mmio_base;
+	void __iomem *host_mmio;
 	unsigned int hotplug_offset, ata_no;
 	u32 hotplug_status;
 	int is_sataii_tx4;
@@ -806,7 +803,7 @@ static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 		return IRQ_NONE;
 	}
 
-	mmio_base = host->iomap[PDC_MMIO_BAR];
+	host_mmio = host->iomap[PDC_MMIO_BAR];
 
 	spin_lock(&host->lock);
 
@@ -815,26 +812,26 @@ static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 		hotplug_offset = PDC2_SATA_PLUG_CSR;
 	else
 		hotplug_offset = PDC_SATA_PLUG_CSR;
-	hotplug_status = readl(mmio_base + hotplug_offset);
+	hotplug_status = readl(host_mmio + hotplug_offset);
 	if (hotplug_status & 0xff)
-		writel(hotplug_status | 0xff, mmio_base + hotplug_offset);
+		writel(hotplug_status | 0xff, host_mmio + hotplug_offset);
 	hotplug_status &= 0xff;	/* clear uninteresting bits */
 
 	/* reading should also clear interrupts */
-	mask = readl(mmio_base + PDC_INT_SEQMASK);
+	mask = readl(host_mmio + PDC_INT_SEQMASK);
 
 	if (mask == 0xffffffff && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 2\n");
 		goto done_irq;
 	}
 
-	mask &= 0xffff;		/* only 16 tags possible */
+	mask &= 0xffff;		/* only 16 SEQIDs possible */
 	if (mask == 0 && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 3\n");
 		goto done_irq;
 	}
 
-	writel(mask, mmio_base + PDC_INT_SEQMASK);
+	writel(mask, host_mmio + PDC_INT_SEQMASK);
 
 	is_sataii_tx4 = pdc_is_sataii_tx4(host->ports[0]->flags);
 
@@ -875,23 +872,24 @@ done_irq:
 	return IRQ_RETVAL(handled);
 }
 
-static inline void pdc_packet_start(struct ata_queued_cmd *qc)
+static void pdc_packet_start(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct pdc_port_priv *pp = ap->private_data;
-	void __iomem *mmio = ap->host->iomap[PDC_MMIO_BAR];
+	void __iomem *host_mmio = ap->host->iomap[PDC_MMIO_BAR];
+	void __iomem *ata_mmio = ap->ioaddr.cmd_addr;
 	unsigned int port_no = ap->port_no;
 	u8 seq = (u8) (port_no + 1);
 
 	VPRINTK("ENTER, ap %p\n", ap);
 
-	writel(0x00000001, mmio + (seq * 4));
-	readl(mmio + (seq * 4));	/* flush */
+	writel(0x00000001, host_mmio + (seq * 4));
+	readl(host_mmio + (seq * 4));	/* flush */
 
 	pp->pkt[2] = seq;
 	wmb();			/* flush PRD, pkt writes */
-	writel(pp->pkt_dma, ap->ioaddr.cmd_addr + PDC_PKT_SUBMIT);
-	readl(ap->ioaddr.cmd_addr + PDC_PKT_SUBMIT); /* flush */
+	writel(pp->pkt_dma, ata_mmio + PDC_PKT_SUBMIT);
+	readl(ata_mmio + PDC_PKT_SUBMIT); /* flush */
 }
 
 static unsigned int pdc_qc_issue(struct ata_queued_cmd *qc)
@@ -909,11 +907,9 @@ static unsigned int pdc_qc_issue(struct ata_queued_cmd *qc)
 	case ATA_PROT_DMA:
 		pdc_packet_start(qc);
 		return 0;
-
 	default:
 		break;
 	}
-
 	return ata_sff_qc_issue(qc);
 }
 
@@ -987,7 +983,7 @@ static void pdc_ata_setup_port(struct ata_port *ap,
 
 static void pdc_host_init(struct ata_host *host)
 {
-	void __iomem *mmio = host->iomap[PDC_MMIO_BAR];
+	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
 	int is_gen2 = host->ports[0]->flags & PDC_FLAG_GEN_II;
 	int hotplug_offset;
 	u32 tmp;
@@ -1004,38 +1000,38 @@ static void pdc_host_init(struct ata_host *host)
 	 */
 
 	/* enable BMR_BURST, maybe change FIFO_SHD to 8 dwords */
-	tmp = readl(mmio + PDC_FLASH_CTL);
+	tmp = readl(host_mmio + PDC_FLASH_CTL);
 	tmp |= 0x02000;	/* bit 13 (enable bmr burst) */
 	if (!is_gen2)
 		tmp |= 0x10000;	/* bit 16 (fifo threshold at 8 dw) */
-	writel(tmp, mmio + PDC_FLASH_CTL);
+	writel(tmp, host_mmio + PDC_FLASH_CTL);
 
 	/* clear plug/unplug flags for all ports */
-	tmp = readl(mmio + hotplug_offset);
-	writel(tmp | 0xff, mmio + hotplug_offset);
+	tmp = readl(host_mmio + hotplug_offset);
+	writel(tmp | 0xff, host_mmio + hotplug_offset);
 
 	/* unmask plug/unplug ints */
-	tmp = readl(mmio + hotplug_offset);
-	writel(tmp & ~0xff0000, mmio + hotplug_offset);
+	tmp = readl(host_mmio + hotplug_offset);
+	writel(tmp & ~0xff0000, host_mmio + hotplug_offset);
 
 	/* don't initialise TBG or SLEW on 2nd generation chips */
 	if (is_gen2)
 		return;
 
 	/* reduce TBG clock to 133 Mhz. */
-	tmp = readl(mmio + PDC_TBG_MODE);
+	tmp = readl(host_mmio + PDC_TBG_MODE);
 	tmp &= ~0x30000; /* clear bit 17, 16*/
 	tmp |= 0x10000;  /* set bit 17:16 = 0:1 */
-	writel(tmp, mmio + PDC_TBG_MODE);
+	writel(tmp, host_mmio + PDC_TBG_MODE);
 
-	readl(mmio + PDC_TBG_MODE);	/* flush */
+	readl(host_mmio + PDC_TBG_MODE);	/* flush */
 	msleep(10);
 
 	/* adjust slew rate control register. */
-	tmp = readl(mmio + PDC_SLEW_CTL);
+	tmp = readl(host_mmio + PDC_SLEW_CTL);
 	tmp &= 0xFFFFF03F; /* clear bit 11 ~ 6 */
 	tmp  |= 0x00000900; /* set bit 11-9 = 100b , bit 8-6 = 100 */
-	writel(tmp, mmio + PDC_SLEW_CTL);
+	writel(tmp, host_mmio + PDC_SLEW_CTL);
 }
 
 static int pdc_ata_init_one(struct pci_dev *pdev,
@@ -1045,7 +1041,7 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 	const struct ata_port_info *pi = &pdc_port_info[ent->driver_data];
 	const struct ata_port_info *ppi[PDC_MAX_PORTS];
 	struct ata_host *host;
-	void __iomem *base;
+	void __iomem *host_mmio;
 	int n_ports, i, rc;
 	int is_sataii_tx4;
 
@@ -1062,7 +1058,7 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 		pcim_pin_device(pdev);
 	if (rc)
 		return rc;
-	base = pcim_iomap_table(pdev)[PDC_MMIO_BAR];
+	host_mmio = pcim_iomap_table(pdev)[PDC_MMIO_BAR];
 
 	/* determine port configuration and setup host */
 	n_ports = 2;
@@ -1072,7 +1068,7 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 		ppi[i] = pi;
 
 	if (pi->flags & PDC_FLAG_SATA_PATA) {
-		u8 tmp = readb(base + PDC_FLASH_CTL+1);
+		u8 tmp = readb(host_mmio + PDC_FLASH_CTL + 1);
 		if (!(tmp & 0x80))
 			ppi[n_ports++] = pi + 1;
 	}
@@ -1088,13 +1084,13 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 		unsigned int ata_no = pdc_port_no_to_ata_no(i, is_sataii_tx4);
-		unsigned int port_offset = 0x200 + ata_no * 0x80;
+		unsigned int ata_offset = 0x200 + ata_no * 0x80;
 		unsigned int scr_offset = 0x400 + ata_no * 0x100;
 
-		pdc_ata_setup_port(ap, base + port_offset, base + scr_offset);
+		pdc_ata_setup_port(ap, host_mmio + ata_offset, host_mmio + scr_offset);
 
 		ata_port_pbar_desc(ap, PDC_MMIO_BAR, -1, "mmio");
-		ata_port_pbar_desc(ap, PDC_MMIO_BAR, port_offset, "port");
+		ata_port_pbar_desc(ap, PDC_MMIO_BAR, ata_offset, "ata");
 	}
 
 	/* initialize adapter */
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 27a1101..8ee6b5b 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -899,14 +899,25 @@ static bool sil24_qc_fill_rtf(struct ata_queued_cmd *qc)
 
 static void sil24_pmp_attach(struct ata_port *ap)
 {
+	u32 *gscr = ap->link.device->gscr;
+
 	sil24_config_pmp(ap, 1);
 	sil24_init_port(ap);
+
+	if (sata_pmp_gscr_vendor(gscr) == 0x11ab &&
+	    sata_pmp_gscr_devid(gscr) == 0x4140) {
+		ata_port_printk(ap, KERN_INFO,
+			"disabling NCQ support due to sil24-mv4140 quirk\n");
+		ap->flags &= ~ATA_FLAG_NCQ;
+	}
 }
 
 static void sil24_pmp_detach(struct ata_port *ap)
 {
 	sil24_init_port(ap);
 	sil24_config_pmp(ap, 0);
+
+	ap->flags |= ATA_FLAG_NCQ;
 }
 
 static int sil24_pmp_hardreset(struct ata_link *link, unsigned int *class,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 0f17643..4a92fba 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -341,7 +341,7 @@ enum {
 	ATA_EH_PMP_TRIES	= 5,
 	ATA_EH_PMP_LINK_TRIES	= 3,
 
-	SATA_PMP_SCR_TIMEOUT	= 250,
+	SATA_PMP_RW_TIMEOUT	= 3000,		/* PMP read/write timeout */
 
 	/* Horkage types. May be set by libata or controller on drives
 	   (some horkage may be drive/controller pair dependant */
@@ -351,7 +351,7 @@ enum {
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
 	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
-	ATA_HORKAGE_SKIP_PM	= (1 << 5),	/* Skip PM operations */
+	ATA_HORKAGE_DISABLE	= (1 << 5),	/* Disable it */
 	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
 	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
 	ATA_HORKAGE_IVB		= (1 << 8),	/* cbl det validity bit bugs */
@@ -821,8 +821,6 @@ struct ata_timing {
 	unsigned short udma;		/* t2CYCTYP/2 */
 };
 
-#define FIT(v, vmin, vmax)	max_t(short, min_t(short, v, vmax), vmin)
-
 /*
  * Core layer - drivers/ata/libata-core.c
  */
