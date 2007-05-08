Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbXEHGia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbXEHGia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbXEHGiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:38:25 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38030 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbXEHGiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:38:22 -0400
Date: Tue, 8 May 2007 02:38:20 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata reset sequence update
Message-ID: <20070508063820.GA13469@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This has been testing in -mm for a while, but I wanted to send it
separated from the main libata update, since it has a chance of
breakage.

Most notably, a cumulative timeout (deadline) helps the code from diving
into overly-long reset sequences.

Please pull from 'reset-seq' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git reset-seq

to receive the following updates:

 drivers/ata/ahci.c             |   28 +++---
 drivers/ata/ata_piix.c         |    6 +-
 drivers/ata/libata-core.c      |  225 ++++++++++++++++++++++++---------------
 drivers/ata/libata-eh.c        |   62 ++++++++----
 drivers/ata/pata_amd.c         |   11 +-
 drivers/ata/pata_artop.c       |   11 ++-
 drivers/ata/pata_atiixp.c      |    4 +-
 drivers/ata/pata_cs5535.c      |    1 +
 drivers/ata/pata_efar.c        |    5 +-
 drivers/ata/pata_hpt366.c      |    4 +-
 drivers/ata/pata_hpt37x.c      |    9 +-
 drivers/ata/pata_hpt3x2n.c     |    5 +-
 drivers/ata/pata_it8213.c      |    6 +-
 drivers/ata/pata_jmicron.c     |    7 +-
 drivers/ata/pata_marvell.c     |    7 +-
 drivers/ata/pata_mpiix.c       |    5 +-
 drivers/ata/pata_ns87410.c     |    6 +-
 drivers/ata/pata_oldpiix.c     |    6 +-
 drivers/ata/pata_opti.c        |    6 +-
 drivers/ata/pata_optidma.c     |    5 +-
 drivers/ata/pata_pdc2027x.c    |    5 +-
 drivers/ata/pata_serverworks.c |    4 +-
 drivers/ata/pata_sil680.c      |    6 +-
 drivers/ata/pata_sis.c         |    8 +-
 drivers/ata/pata_sl82c105.c    |    5 +-
 drivers/ata/pata_triflex.c     |    6 +-
 drivers/ata/pata_via.c         |    5 +-
 drivers/ata/sata_inic162x.c    |   15 ++-
 drivers/ata/sata_nv.c          |    5 +-
 drivers/ata/sata_sil24.c       |   10 +-
 drivers/ata/sata_via.c         |    5 +-
 include/linux/libata.h         |   40 +++-----
 32 files changed, 321 insertions(+), 212 deletions(-)

Jeff Garzik (1):
      [libata reset-seq] build and merge fixes

Tejun Heo (4):
      libata: add deadline support to prereset and reset methods
      libata: improve 0xff status handling
      libata: improve ata_std_prereset()
      libata: reimplement reset sequencing

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 34c5534..d961789 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -874,7 +874,8 @@ static int ahci_clo(struct ata_port *ap)
 	return 0;
 }
 
-static int ahci_softreset(struct ata_port *ap, unsigned int *class)
+static int ahci_softreset(struct ata_port *ap, unsigned int *class,
+			  unsigned long deadline)
 {
 	struct ahci_port_priv *pp = ap->private_data;
 	void __iomem *port_mmio = ahci_port_base(ap);
@@ -959,15 +960,13 @@ static int ahci_softreset(struct ata_port *ap, unsigned int *class)
 	 */
 	msleep(150);
 
-	*class = ATA_DEV_NONE;
-	if (ata_port_online(ap)) {
-		if (ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT)) {
-			rc = -EIO;
-			reason = "device not ready";
-			goto fail;
-		}
-		*class = ahci_dev_classify(ap);
+	rc = ata_wait_ready(ap, deadline);
+	/* link occupied, -ENODEV too is an error */
+	if (rc) {
+		reason = "device not ready";
+		goto fail;
 	}
+	*class = ahci_dev_classify(ap);
 
 	DPRINTK("EXIT, class=%u\n", *class);
 	return 0;
@@ -979,7 +978,8 @@ static int ahci_softreset(struct ata_port *ap, unsigned int *class)
 	return rc;
 }
 
-static int ahci_hardreset(struct ata_port *ap, unsigned int *class)
+static int ahci_hardreset(struct ata_port *ap, unsigned int *class,
+			  unsigned long deadline)
 {
 	struct ahci_port_priv *pp = ap->private_data;
 	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
@@ -995,7 +995,7 @@ static int ahci_hardreset(struct ata_port *ap, unsigned int *class)
 	tf.command = 0x80;
 	ata_tf_to_fis(&tf, d2h_fis, 0);
 
-	rc = sata_std_hardreset(ap, class);
+	rc = sata_std_hardreset(ap, class, deadline);
 
 	ahci_start_engine(ap);
 
@@ -1008,7 +1008,8 @@ static int ahci_hardreset(struct ata_port *ap, unsigned int *class)
 	return rc;
 }
 
-static int ahci_vt8251_hardreset(struct ata_port *ap, unsigned int *class)
+static int ahci_vt8251_hardreset(struct ata_port *ap, unsigned int *class,
+				 unsigned long deadline)
 {
 	int rc;
 
@@ -1016,7 +1017,8 @@ static int ahci_vt8251_hardreset(struct ata_port *ap, unsigned int *class)
 
 	ahci_stop_engine(ap);
 
-	rc = sata_port_hardreset(ap, sata_ehc_deb_timing(&ap->eh_context));
+	rc = sata_port_hardreset(ap, sata_ehc_deb_timing(&ap->eh_context),
+				 deadline);
 
 	/* vt8251 needs SError cleared for the port to operate */
 	ahci_scr_write(ap, SCR_ERROR, ahci_scr_read(ap, SCR_ERROR));
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 55d306a..4a795fd 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -625,17 +625,18 @@ static int ich_pata_cable_detect(struct ata_port *ap)
 /**
  *	piix_pata_prereset - prereset for PATA host controller
  *	@ap: Target port
+ *	@deadline: deadline jiffies for the operation
  *
  *	LOCKING:
  *	None (inherited from caller).
  */
-static int piix_pata_prereset(struct ata_port *ap)
+static int piix_pata_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	if (!pci_test_config_bits(pdev, &piix_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 static void piix_pata_error_handler(struct ata_port *ap)
@@ -644,7 +645,6 @@ static void piix_pata_error_handler(struct ata_port *ap)
 			   ata_std_postreset);
 }
 
-
 static void piix_sata_error_handler(struct ata_port *ap)
 {
 	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset, NULL,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ca67484..a795088 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2979,23 +2979,71 @@ int ata_busy_sleep(struct ata_port *ap,
 	return 0;
 }
 
-static void ata_bus_post_reset(struct ata_port *ap, unsigned int devmask)
+/**
+ *	ata_wait_ready - sleep until BSY clears, or timeout
+ *	@ap: port containing status register to be polled
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Sleep until ATA Status register bit BSY clears, or timeout
+ *	occurs.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int ata_wait_ready(struct ata_port *ap, unsigned long deadline)
+{
+	unsigned long start = jiffies;
+	int warned = 0;
+
+	while (1) {
+		u8 status = ata_chk_status(ap);
+		unsigned long now = jiffies;
+
+		if (!(status & ATA_BUSY))
+			return 0;
+		if (status == 0xff)
+			return -ENODEV;
+		if (time_after(now, deadline))
+			return -EBUSY;
+
+		if (!warned && time_after(now, start + 5 * HZ) &&
+		    (deadline - now > 3 * HZ)) {
+			ata_port_printk(ap, KERN_WARNING,
+				"port is slow to respond, please be patient "
+				"(Status 0x%x)\n", status);
+			warned = 1;
+		}
+
+		msleep(50);
+	}
+}
+
+static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
+			      unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 	unsigned int dev0 = devmask & (1 << 0);
 	unsigned int dev1 = devmask & (1 << 1);
-	unsigned long timeout;
+	int rc, ret = 0;
 
 	/* if device 0 was found in ata_devchk, wait for its
 	 * BSY bit to clear
 	 */
-	if (dev0)
-		ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
+	if (dev0) {
+		rc = ata_wait_ready(ap, deadline);
+		if (rc) {
+			if (rc != -ENODEV)
+				return rc;
+			ret = rc;
+		}
+	}
 
 	/* if device 1 was found in ata_devchk, wait for
 	 * register access, then wait for BSY to clear
 	 */
-	timeout = jiffies + ATA_TMOUT_BOOT;
 	while (dev1) {
 		u8 nsect, lbal;
 
@@ -3004,14 +3052,18 @@ static void ata_bus_post_reset(struct ata_port *ap, unsigned int devmask)
 		lbal = ioread8(ioaddr->lbal_addr);
 		if ((nsect == 1) && (lbal == 1))
 			break;
-		if (time_after(jiffies, timeout)) {
-			dev1 = 0;
-			break;
-		}
+		if (time_after(jiffies, deadline))
+			return -EBUSY;
 		msleep(50);	/* give drive a breather */
 	}
-	if (dev1)
-		ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
+	if (dev1) {
+		rc = ata_wait_ready(ap, deadline);
+		if (rc) {
+			if (rc != -ENODEV)
+				return rc;
+			ret = rc;
+		}
+	}
 
 	/* is all this really necessary? */
 	ap->ops->dev_select(ap, 0);
@@ -3019,10 +3071,12 @@ static void ata_bus_post_reset(struct ata_port *ap, unsigned int devmask)
 		ap->ops->dev_select(ap, 1);
 	if (dev0)
 		ap->ops->dev_select(ap, 0);
+
+	return ret;
 }
 
-static unsigned int ata_bus_softreset(struct ata_port *ap,
-				      unsigned int devmask)
+static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
+			     unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
@@ -3052,11 +3106,9 @@ static unsigned int ata_bus_softreset(struct ata_port *ap,
 	 * pulldown resistor.
 	 */
 	if (ata_check_status(ap) == 0xFF)
-		return 0;
-
-	ata_bus_post_reset(ap, devmask);
+		return -ENODEV;
 
-	return 0;
+	return ata_bus_post_reset(ap, devmask, deadline);
 }
 
 /**
@@ -3085,6 +3137,7 @@ void ata_bus_reset(struct ata_port *ap)
 	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
 	u8 err;
 	unsigned int dev0, dev1 = 0, devmask = 0;
+	int rc;
 
 	DPRINTK("ENTER, host %u, port %u\n", ap->print_id, ap->port_no);
 
@@ -3106,9 +3159,11 @@ void ata_bus_reset(struct ata_port *ap)
 	ap->ops->dev_select(ap, 0);
 
 	/* issue bus reset */
-	if (ap->flags & ATA_FLAG_SRST)
-		if (ata_bus_softreset(ap, devmask))
+	if (ap->flags & ATA_FLAG_SRST) {
+		rc = ata_bus_softreset(ap, devmask, jiffies + 40 * HZ);
+		if (rc && rc != -ENODEV)
 			goto err_out;
+	}
 
 	/*
 	 * determine by signature whether we have ATA or ATAPI devices
@@ -3150,29 +3205,37 @@ err_out:
  *	sata_phy_debounce - debounce SATA phy status
  *	@ap: ATA port to debounce SATA phy status for
  *	@params: timing parameters { interval, duratinon, timeout } in msec
+ *	@deadline: deadline jiffies for the operation
  *
  *	Make sure SStatus of @ap reaches stable state, determined by
  *	holding the same value where DET is not 1 for @duration polled
  *	every @interval, before @timeout.  Timeout constraints the
- *	beginning of the stable state.  Because, after hot unplugging,
- *	DET gets stuck at 1 on some controllers, this functions waits
+ *	beginning of the stable state.  Because DET gets stuck at 1 on
+ *	some controllers after hot unplugging, this functions waits
  *	until timeout then returns 0 if DET is stable at 1.
  *
+ *	@timeout is further limited by @deadline.  The sooner of the
+ *	two is used.
+ *
  *	LOCKING:
  *	Kernel thread context (may sleep)
  *
  *	RETURNS:
  *	0 on success, -errno on failure.
  */
-int sata_phy_debounce(struct ata_port *ap, const unsigned long *params)
+int sata_phy_debounce(struct ata_port *ap, const unsigned long *params,
+		      unsigned long deadline)
 {
 	unsigned long interval_msec = params[0];
-	unsigned long duration = params[1] * HZ / 1000;
-	unsigned long timeout = jiffies + params[2] * HZ / 1000;
-	unsigned long last_jiffies;
+	unsigned long duration = msecs_to_jiffies(params[1]);
+	unsigned long last_jiffies, t;
 	u32 last, cur;
 	int rc;
 
+	t = jiffies + msecs_to_jiffies(params[2]);
+	if (time_before(t, deadline))
+		deadline = t;
+
 	if ((rc = sata_scr_read(ap, SCR_STATUS, &cur)))
 		return rc;
 	cur &= 0xf;
@@ -3188,7 +3251,7 @@ int sata_phy_debounce(struct ata_port *ap, const unsigned long *params)
 
 		/* DET stable? */
 		if (cur == last) {
-			if (cur == 1 && time_before(jiffies, timeout))
+			if (cur == 1 && time_before(jiffies, deadline))
 				continue;
 			if (time_after(jiffies, last_jiffies + duration))
 				return 0;
@@ -3199,8 +3262,8 @@ int sata_phy_debounce(struct ata_port *ap, const unsigned long *params)
 		last = cur;
 		last_jiffies = jiffies;
 
-		/* check timeout */
-		if (time_after(jiffies, timeout))
+		/* check deadline */
+		if (time_after(jiffies, deadline))
 			return -EBUSY;
 	}
 }
@@ -3209,6 +3272,7 @@ int sata_phy_debounce(struct ata_port *ap, const unsigned long *params)
  *	sata_phy_resume - resume SATA phy
  *	@ap: ATA port to resume SATA phy for
  *	@params: timing parameters { interval, duratinon, timeout } in msec
+ *	@deadline: deadline jiffies for the operation
  *
  *	Resume SATA phy of @ap and debounce it.
  *
@@ -3218,7 +3282,8 @@ int sata_phy_debounce(struct ata_port *ap, const unsigned long *params)
  *	RETURNS:
  *	0 on success, -errno on failure.
  */
-int sata_phy_resume(struct ata_port *ap, const unsigned long *params)
+int sata_phy_resume(struct ata_port *ap, const unsigned long *params,
+		    unsigned long deadline)
 {
 	u32 scontrol;
 	int rc;
@@ -3236,43 +3301,19 @@ int sata_phy_resume(struct ata_port *ap, const unsigned long *params)
 	 */
 	msleep(200);
 
-	return sata_phy_debounce(ap, params);
-}
-
-static void ata_wait_spinup(struct ata_port *ap)
-{
-	struct ata_eh_context *ehc = &ap->eh_context;
-	unsigned long end, secs;
-	int rc;
-
-	/* first, debounce phy if SATA */
-	if (ap->cbl == ATA_CBL_SATA) {
-		rc = sata_phy_debounce(ap, sata_deb_timing_hotplug);
-
-		/* if debounced successfully and offline, no need to wait */
-		if ((rc == 0 || rc == -EOPNOTSUPP) && ata_port_offline(ap))
-			return;
-	}
-
-	/* okay, let's give the drive time to spin up */
-	end = ehc->i.hotplug_timestamp + ATA_SPINUP_WAIT * HZ / 1000;
-	secs = ((end - jiffies) + HZ - 1) / HZ;
-
-	if (time_after(jiffies, end))
-		return;
-
-	if (secs > 5)
-		ata_port_printk(ap, KERN_INFO, "waiting for device to spin up "
-				"(%lu secs)\n", secs);
-
-	schedule_timeout_uninterruptible(end - jiffies);
+	return sata_phy_debounce(ap, params, deadline);
 }
 
 /**
  *	ata_std_prereset - prepare for reset
  *	@ap: ATA port to be reset
+ *	@deadline: deadline jiffies for the operation
  *
- *	@ap is about to be reset.  Initialize it.
+ *	@ap is about to be reset.  Initialize it.  Failure from
+ *	prereset makes libata abort whole reset sequence and give up
+ *	that port, so prereset should be best-effort.  It does its
+ *	best to prepare for reset sequence but if things go wrong, it
+ *	should just whine, not fail.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep)
@@ -3280,41 +3321,41 @@ static void ata_wait_spinup(struct ata_port *ap)
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ata_std_prereset(struct ata_port *ap)
+int ata_std_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	struct ata_eh_context *ehc = &ap->eh_context;
 	const unsigned long *timing = sata_ehc_deb_timing(ehc);
 	int rc;
 
-	/* handle link resume & hotplug spinup */
+	/* handle link resume */
 	if ((ehc->i.flags & ATA_EHI_RESUME_LINK) &&
 	    (ap->flags & ATA_FLAG_HRST_TO_RESUME))
 		ehc->i.action |= ATA_EH_HARDRESET;
 
-	if ((ehc->i.flags & ATA_EHI_HOTPLUGGED) &&
-	    (ap->flags & ATA_FLAG_SKIP_D2H_BSY))
-		ata_wait_spinup(ap);
-
 	/* if we're about to do hardreset, nothing more to do */
 	if (ehc->i.action & ATA_EH_HARDRESET)
 		return 0;
 
 	/* if SATA, resume phy */
 	if (ap->cbl == ATA_CBL_SATA) {
-		rc = sata_phy_resume(ap, timing);
-		if (rc && rc != -EOPNOTSUPP) {
-			/* phy resume failed */
+		rc = sata_phy_resume(ap, timing, deadline);
+		/* whine about phy resume failure but proceed */
+		if (rc && rc != -EOPNOTSUPP)
 			ata_port_printk(ap, KERN_WARNING, "failed to resume "
 					"link for reset (errno=%d)\n", rc);
-			return rc;
-		}
 	}
 
 	/* Wait for !BSY if the controller can wait for the first D2H
 	 * Reg FIS and we don't know that no device is attached.
 	 */
-	if (!(ap->flags & ATA_FLAG_SKIP_D2H_BSY) && !ata_port_offline(ap))
-		ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
+	if (!(ap->flags & ATA_FLAG_SKIP_D2H_BSY) && !ata_port_offline(ap)) {
+		rc = ata_wait_ready(ap, deadline);
+		if (rc) {
+			ata_port_printk(ap, KERN_WARNING, "device not ready "
+					"(errno=%d), forcing hardreset\n", rc);
+			ehc->i.action |= ATA_EH_HARDRESET;
+		}
+	}
 
 	return 0;
 }
@@ -3323,6 +3364,7 @@ int ata_std_prereset(struct ata_port *ap)
  *	ata_std_softreset - reset host port via ATA SRST
  *	@ap: port to reset
  *	@classes: resulting classes of attached devices
+ *	@deadline: deadline jiffies for the operation
  *
  *	Reset host port using ATA SRST.
  *
@@ -3332,10 +3374,12 @@ int ata_std_prereset(struct ata_port *ap)
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ata_std_softreset(struct ata_port *ap, unsigned int *classes)
+int ata_std_softreset(struct ata_port *ap, unsigned int *classes,
+		      unsigned long deadline)
 {
 	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
-	unsigned int devmask = 0, err_mask;
+	unsigned int devmask = 0;
+	int rc;
 	u8 err;
 
 	DPRINTK("ENTER\n");
@@ -3356,11 +3400,11 @@ int ata_std_softreset(struct ata_port *ap, unsigned int *classes)
 
 	/* issue bus reset */
 	DPRINTK("about to softreset, devmask=%x\n", devmask);
-	err_mask = ata_bus_softreset(ap, devmask);
-	if (err_mask) {
-		ata_port_printk(ap, KERN_ERR, "SRST failed (err_mask=0x%x)\n",
-				err_mask);
-		return -EIO;
+	rc = ata_bus_softreset(ap, devmask, deadline);
+	/* if link is occupied, -ENODEV too is an error */
+	if (rc && (rc != -ENODEV || sata_scr_valid(ap))) {
+		ata_port_printk(ap, KERN_ERR, "SRST failed (errno=%d)\n", rc);
+		return rc;
 	}
 
 	/* determine by signature whether we have ATA or ATAPI devices */
@@ -3377,6 +3421,7 @@ int ata_std_softreset(struct ata_port *ap, unsigned int *classes)
  *	sata_port_hardreset - reset port via SATA phy reset
  *	@ap: port to reset
  *	@timing: timing parameters { interval, duratinon, timeout } in msec
+ *	@deadline: deadline jiffies for the operation
  *
  *	SATA phy-reset host port using DET bits of SControl register.
  *
@@ -3386,7 +3431,8 @@ int ata_std_softreset(struct ata_port *ap, unsigned int *classes)
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int sata_port_hardreset(struct ata_port *ap, const unsigned long *timing)
+int sata_port_hardreset(struct ata_port *ap, const unsigned long *timing,
+			unsigned long deadline)
 {
 	u32 scontrol;
 	int rc;
@@ -3425,7 +3471,7 @@ int sata_port_hardreset(struct ata_port *ap, const unsigned long *timing)
 	msleep(1);
 
 	/* bring phy back */
-	rc = sata_phy_resume(ap, timing);
+	rc = sata_phy_resume(ap, timing, deadline);
  out:
 	DPRINTK("EXIT, rc=%d\n", rc);
 	return rc;
@@ -3435,6 +3481,7 @@ int sata_port_hardreset(struct ata_port *ap, const unsigned long *timing)
  *	sata_std_hardreset - reset host port via SATA phy reset
  *	@ap: port to reset
  *	@class: resulting class of attached device
+ *	@deadline: deadline jiffies for the operation
  *
  *	SATA phy-reset host port using DET bits of SControl register,
  *	wait for !BSY and classify the attached device.
@@ -3445,7 +3492,8 @@ int sata_port_hardreset(struct ata_port *ap, const unsigned long *timing)
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int sata_std_hardreset(struct ata_port *ap, unsigned int *class)
+int sata_std_hardreset(struct ata_port *ap, unsigned int *class,
+		       unsigned long deadline)
 {
 	const unsigned long *timing = sata_ehc_deb_timing(&ap->eh_context);
 	int rc;
@@ -3453,7 +3501,7 @@ int sata_std_hardreset(struct ata_port *ap, unsigned int *class)
 	DPRINTK("ENTER\n");
 
 	/* do hardreset */
-	rc = sata_port_hardreset(ap, timing);
+	rc = sata_port_hardreset(ap, timing, deadline);
 	if (rc) {
 		ata_port_printk(ap, KERN_ERR,
 				"COMRESET failed (errno=%d)\n", rc);
@@ -3470,10 +3518,12 @@ int sata_std_hardreset(struct ata_port *ap, unsigned int *class)
 	/* wait a while before checking status, see SRST for more info */
 	msleep(150);
 
-	if (ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT)) {
+	rc = ata_wait_ready(ap, deadline);
+	/* link occupied, -ENODEV too is an error */
+	if (rc) {
 		ata_port_printk(ap, KERN_ERR,
-				"COMRESET failed (device not ready)\n");
-		return -EIO;
+				"COMRESET failed (errno=%d)\n", rc);
+		return rc;
 	}
 
 	ap->ops->dev_select(ap, 0);	/* probably unnecessary */
@@ -6793,6 +6843,7 @@ EXPORT_SYMBOL_GPL(ata_port_disable);
 EXPORT_SYMBOL_GPL(ata_ratelimit);
 EXPORT_SYMBOL_GPL(ata_wait_register);
 EXPORT_SYMBOL_GPL(ata_busy_sleep);
+EXPORT_SYMBOL_GPL(ata_wait_ready);
 EXPORT_SYMBOL_GPL(ata_port_queue_task);
 EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 2bff9ad..8256655 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -50,6 +50,28 @@ enum {
 	ATA_EH_SPDN_FALLBACK_TO_PIO	= (1 << 2),
 };
 
+/* Waiting in ->prereset can never be reliable.  It's sometimes nice
+ * to wait there but it can't be depended upon; otherwise, we wouldn't
+ * be resetting.  Just give it enough time for most drives to spin up.
+ */
+enum {
+	ATA_EH_PRERESET_TIMEOUT		= 10 * HZ,
+};
+
+/* The following table determines how we sequence resets.  Each entry
+ * represents timeout for that try.  The first try can be soft or
+ * hardreset.  All others are hardreset if available.  In most cases
+ * the first reset w/ 10sec timeout should succeed.  Following entries
+ * are mostly for error handling, hotplug and retarded devices.
+ */
+static const unsigned long ata_eh_reset_timeouts[] = {
+	10 * HZ,	/* most drives spin up by 10sec */
+	10 * HZ,	/* > 99% working drives spin up before 20sec */
+	35 * HZ,	/* give > 30 secs of idleness for retarded devices */
+	5 * HZ,		/* and sweet one last chance */
+	/* > 1 min has elapsed, give up */
+};
+
 static void __ata_port_freeze(struct ata_port *ap);
 static void ata_eh_finish(struct ata_port *ap);
 #ifdef CONFIG_PM
@@ -1558,14 +1580,14 @@ static void ata_eh_report(struct ata_port *ap)
 }
 
 static int ata_do_reset(struct ata_port *ap, ata_reset_fn_t reset,
-			unsigned int *classes)
+			unsigned int *classes, unsigned long deadline)
 {
 	int i, rc;
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++)
 		classes[i] = ATA_DEV_UNKNOWN;
 
-	rc = reset(ap, classes);
+	rc = reset(ap, classes, deadline);
 	if (rc)
 		return rc;
 
@@ -1603,8 +1625,9 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 {
 	struct ata_eh_context *ehc = &ap->eh_context;
 	unsigned int *classes = ehc->classes;
-	int tries = ATA_EH_RESET_TRIES;
 	int verbose = !(ehc->i.flags & ATA_EHI_QUIET);
+	int try = 0;
+	unsigned long deadline;
 	unsigned int action;
 	ata_reset_fn_t reset;
 	int i, did_followup_srst, rc;
@@ -1624,7 +1647,7 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 		ehc->i.action |= ATA_EH_HARDRESET;
 
 	if (prereset) {
-		rc = prereset(ap);
+		rc = prereset(ap, jiffies + ATA_EH_PRERESET_TIMEOUT);
 		if (rc) {
 			if (rc == -ENOENT) {
 				ata_port_printk(ap, KERN_DEBUG,
@@ -1665,6 +1688,8 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 	}
 
  retry:
+	deadline = jiffies + ata_eh_reset_timeouts[try++];
+
 	/* shut up during boot probing */
 	if (verbose)
 		ata_port_printk(ap, KERN_INFO, "%s resetting port\n",
@@ -1676,7 +1701,7 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 	else
 		ehc->i.flags |= ATA_EHI_DID_SOFTRESET;
 
-	rc = ata_do_reset(ap, reset, classes);
+	rc = ata_do_reset(ap, reset, classes, deadline);
 
 	did_followup_srst = 0;
 	if (reset == hardreset &&
@@ -1693,7 +1718,7 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 		}
 
 		ata_eh_about_to_do(ap, NULL, ATA_EH_RESET_MASK);
-		rc = ata_do_reset(ap, reset, classes);
+		rc = ata_do_reset(ap, reset, classes, deadline);
 
 		if (rc == 0 && classify &&
 		    classes[0] == ATA_DEV_UNKNOWN) {
@@ -1703,22 +1728,21 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 		}
 	}
 
-	if (rc && --tries) {
-		const char *type;
+	if (rc && try < ARRAY_SIZE(ata_eh_reset_timeouts)) {
+		unsigned long now = jiffies;
 
-		if (reset == softreset) {
-			if (did_followup_srst)
-				type = "follow-up soft";
-			else
-				type = "soft";
-		} else
-			type = "hard";
+		if (time_before(now, deadline)) {
+			unsigned long delta = deadline - jiffies;
 
-		ata_port_printk(ap, KERN_WARNING,
-				"%sreset failed, retrying in 5 secs\n", type);
-		ssleep(5);
+			ata_port_printk(ap, KERN_WARNING, "reset failed "
+				"(errno=%d), retrying in %u secs\n",
+				rc, (jiffies_to_msecs(delta) + 999) / 1000);
+
+			schedule_timeout_uninterruptible(delta);
+		}
 
-		if (reset == hardreset)
+		if (reset == hardreset &&
+		    try == ARRAY_SIZE(ata_eh_reset_timeouts) - 1)
 			sata_down_spd_limit(ap);
 		if (hardreset)
 			reset = hardreset;
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 536ee89..67c7e87 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -121,12 +121,13 @@ static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offse
 /**
  *	amd_probe_init		-	perform reset handling
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Reset sequence checking enable bits to see which ports are
  *	active.
  */
 
-static int amd_pre_reset(struct ata_port *ap)
+static int amd_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits amd_enable_bits[] = {
 		{ 0x40, 1, 0x02, 0x02 },
@@ -138,8 +139,7 @@ static int amd_pre_reset(struct ata_port *ap)
 	if (!pci_test_config_bits(pdev, &amd_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	return ata_std_prereset(ap);
-
+	return ata_std_prereset(ap, deadline);
 }
 
 static void amd_error_handler(struct ata_port *ap)
@@ -227,7 +227,8 @@ static void amd133_set_dmamode(struct ata_port *ap, struct ata_device *adev)
  *	space for us.
  */
 
-static int nv_pre_reset(struct ata_port *ap) {
+static int nv_pre_reset(struct ata_port *ap, unsigned long deadline)
+{
 	static const struct pci_bits nv_enable_bits[] = {
 		{ 0x50, 1, 0x02, 0x02 },
 		{ 0x50, 1, 0x01, 0x01 }
@@ -238,7 +239,7 @@ static int nv_pre_reset(struct ata_port *ap) {
 	if (!pci_test_config_bits(pdev, &nv_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 static void nv_error_handler(struct ata_port *ap)
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 00e9ec3..ef51940 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -39,7 +39,7 @@
 
 static int clock = 0;
 
-static int artop6210_pre_reset(struct ata_port *ap)
+static int artop6210_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	const struct pci_bits artop_enable_bits[] = {
@@ -49,7 +49,8 @@ static int artop6210_pre_reset(struct ata_port *ap)
 
 	if (!pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
@@ -70,12 +71,13 @@ static void artop6210_error_handler(struct ata_port *ap)
 /**
  *	artop6260_pre_reset	-	check for 40/80 pin
  *	@ap: Port
+ *	@deadline: deadline jiffies for the operation
  *
  *	The ARTOP hardware reports the cable detect bits in register 0x49.
  *	Nothing complicated needed here.
  */
 
-static int artop6260_pre_reset(struct ata_port *ap)
+static int artop6260_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits artop_enable_bits[] = {
 		{ 0x4AU, 1U, 0x02UL, 0x02UL },	/* port 0 */
@@ -87,7 +89,8 @@ static int artop6260_pre_reset(struct ata_port *ap)
 	/* Odd numbered device ids are the units with enable bits (the -R cards) */
 	if (pdev->device % 1 && !pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 39c871a..2151538 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -33,7 +33,7 @@ enum {
 	ATIIXP_IDE_UDMA_MODE 	= 0x56
 };
 
-static int atiixp_pre_reset(struct ata_port *ap)
+static int atiixp_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits atiixp_enable_bits[] = {
 		{ 0x48, 1, 0x01, 0x00 },
@@ -44,7 +44,7 @@ static int atiixp_pre_reset(struct ata_port *ap)
 	if (!pci_test_config_bits(pdev, &atiixp_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 static void atiixp_error_handler(struct ata_port *ap)
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 08cccc9..22006ae 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -72,6 +72,7 @@
 /**
  *	cs5535_cable_detect	-	detect cable type
  *	@ap: Port to detect on
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection for ATA66 capable cable. Return a libata
  *	cable type.
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index a321685..d0f52e0 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -27,12 +27,13 @@
 /**
  *	efar_pre_reset	-	Enable bits
  *	@ap: Port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection for the EFAR ATA interface. This is
  *	different to the PIIX arrangement
  */
 
-static int efar_pre_reset(struct ata_port *ap)
+static int efar_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits efar_enable_bits[] = {
 		{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
@@ -43,7 +44,7 @@ static int efar_pre_reset(struct ata_port *ap)
 	if (!pci_test_config_bits(pdev, &efar_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 93cfa6d..e64e05e 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -220,7 +220,7 @@ static int hpt36x_cable_detect(struct ata_port *ap)
 	return ATA_CBL_PATA80;
 }
 
-static int hpt36x_pre_reset(struct ata_port *ap)
+static int hpt36x_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits hpt36x_enable_bits[] = {
 		{ 0x50, 1, 0x04, 0x04 },
@@ -231,7 +231,7 @@ static int hpt36x_pre_reset(struct ata_port *ap)
 	if (!pci_test_config_bits(pdev, &hpt36x_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 41d8312..1614e8c 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -307,11 +307,12 @@ static unsigned long hpt370a_filter(struct ata_device *adev, unsigned long mask)
 /**
  *	hpt37x_pre_reset	-	reset the hpt37x bus
  *	@ap: ATA port to reset
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform the initial reset handling for the 370/372 and 374 func 0
  */
 
-static int hpt37x_pre_reset(struct ata_port *ap)
+static int hpt37x_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	u8 scr2, ata66;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
@@ -338,7 +339,7 @@ static int hpt37x_pre_reset(struct ata_port *ap)
 	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
 	udelay(100);
 
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
@@ -353,7 +354,7 @@ static void hpt37x_error_handler(struct ata_port *ap)
 	ata_bmdma_drive_eh(ap, hpt37x_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
 }
 
-static int hpt374_pre_reset(struct ata_port *ap)
+static int hpt374_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits hpt37x_enable_bits[] = {
 		{ 0x50, 1, 0x04, 0x04 },
@@ -388,7 +389,7 @@ static int hpt374_pre_reset(struct ata_port *ap)
 	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
 	udelay(100);
 
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 6a34521..ea1037d 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -148,13 +148,14 @@ static int hpt3x2n_cable_detect(struct ata_port *ap)
  *	Reset the hardware and state machine,
  */
 
-static int hpt3xn_pre_reset(struct ata_port *ap)
+static int hpt3xn_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	/* Reset the state machine */
 	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
 	udelay(100);
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 011306e..17bf9f3 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -24,12 +24,13 @@
 /**
  *	it8213_pre_reset	-	check for 40/80 pin
  *	@ap: Port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Filter out ports by the enable bits before doing the normal reset
  *	and probe.
  */
 
-static int it8213_pre_reset(struct ata_port *ap)
+static int it8213_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits it8213_enable_bits[] = {
 		{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
@@ -37,7 +38,8 @@ static int it8213_pre_reset(struct ata_port *ap)
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	if (!pci_test_config_bits(pdev, &it8213_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 43763c9..1daf78a 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -30,16 +30,17 @@ typedef enum {
 /**
  *	jmicron_pre_reset	-	check for 40/80 pin
  *	@ap: Port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform the PATA port setup we need.
-
+ *
  *	On the Jmicron 361/363 there is a single PATA port that can be mapped
  *	either as primary or secondary (or neither). We don't do any policy
  *	and setup here. We assume that has been done by init_one and the
  *	BIOS.
  */
 
-static int jmicron_pre_reset(struct ata_port *ap)
+static int jmicron_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 control;
@@ -102,7 +103,7 @@ static int jmicron_pre_reset(struct ata_port *ap)
 		ap->cbl = ATA_CBL_SATA;
 		break;
 	}
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index d9b94a1..837b7fe 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -25,11 +25,12 @@
 /**
  *	marvell_pre_reset	-	check for 40/80 pin
  *	@ap: Port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform the PATA port setup we need.
  */
 
-static int marvell_pre_reset(struct ata_port *ap)
+static int marvell_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 devices;
@@ -52,7 +53,8 @@ static int marvell_pre_reset(struct ata_port *ap)
 	if ((pdev->device == 0x6145) && (ap->port_no == 0) &&
 	    (!(devices & 0x10)))	/* PATA enable ? */
 		return -ENOENT;
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 static int marvell_cable_detect(struct ata_port *ap)
@@ -67,6 +69,7 @@ static int marvell_cable_detect(struct ata_port *ap)
 	case 1: /* Legacy SATA port */
 		return ATA_CBL_SATA;
 	}
+
 	BUG();
 	return 0;	/* Our BUG macro needs the right markup */
 }
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 987c5fa..3bfbd49 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -46,14 +46,15 @@ enum {
 	SECONDARY = (1 << 14)
 };
 
-static int mpiix_pre_reset(struct ata_port *ap)
+static int mpiix_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const struct pci_bits mpiix_enable_bits = { 0x6D, 1, 0x80, 0x80 };
 
 	if (!pci_test_config_bits(pdev, &mpiix_enable_bits))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 078aeda..ebc58a9 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -33,11 +33,12 @@
 /**
  *	ns87410_pre_reset		-	probe begin
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Check enabled ports
  */
 
-static int ns87410_pre_reset(struct ata_port *ap)
+static int ns87410_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const struct pci_bits ns87410_enable_bits[] = {
@@ -47,7 +48,8 @@ static int ns87410_pre_reset(struct ata_port *ap)
 
 	if (!pci_test_config_bits(pdev, &ns87410_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index dea4690..4d75d32 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -30,11 +30,12 @@
 /**
  *	oldpiix_pre_reset		-	probe begin
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Set up cable type and use generic probe init
  */
 
-static int oldpiix_pre_reset(struct ata_port *ap)
+static int oldpiix_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const struct pci_bits oldpiix_enable_bits[] = {
@@ -44,7 +45,8 @@ static int oldpiix_pre_reset(struct ata_port *ap)
 
 	if (!pci_test_config_bits(pdev, &oldpiix_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index 13b63e2..0af8a2c 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -47,11 +47,12 @@ enum {
 /**
  *	opti_pre_reset		-	probe begin
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Set up cable type and use generic probe init
  */
 
-static int opti_pre_reset(struct ata_port *ap)
+static int opti_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const struct pci_bits opti_enable_bits[] = {
@@ -61,7 +62,8 @@ static int opti_pre_reset(struct ata_port *ap)
 
 	if (!pci_test_config_bits(pdev, &opti_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index b70e04c..2843e48 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -48,11 +48,12 @@ static int pci_clock;	/* 0 = 33 1 = 25 */
 /**
  *	optidma_pre_reset		-	probe begin
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Set up cable type and use generic probe init
  */
 
-static int optidma_pre_reset(struct ata_port *ap)
+static int optidma_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const struct pci_bits optidma_enable_bits = {
@@ -62,7 +63,7 @@ static int optidma_pre_reset(struct ata_port *ap)
 	if (ap->port_no && !pci_test_config_bits(pdev, &optidma_enable_bits))
 		return -ENOENT;
 
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index a61cbc1..0d2cc49 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -301,6 +301,7 @@ static inline int pdc2027x_port_enabled(struct ata_port *ap)
 /**
  *	pdc2027x_prereset - prereset for PATA host controller
  *	@ap: Target port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Probeinit including cable detection.
  *
@@ -308,12 +309,12 @@ static inline int pdc2027x_port_enabled(struct ata_port *ap)
  *	None (inherited from caller).
  */
 
-static int pdc2027x_prereset(struct ata_port *ap)
+static int pdc2027x_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	/* Check whether port enabled */
 	if (!pdc2027x_port_enabled(ap))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 3956ef2..b6e0203 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -139,12 +139,14 @@ static struct sv_cable_table cable_detect[] = {
 /**
  *	serverworks_cable_detect	-	cable detection
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection according to the device and subvendor
  *	identifications
  */
 
-static int serverworks_cable_detect(struct ata_port *ap) {
+static int serverworks_cable_detect(struct ata_port *ap)
+{
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct sv_cable_table *cb = cable_detect;
 
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 6770820..a5886f0 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -94,11 +94,13 @@ static int sil680_cable_detect(struct ata_port *ap) {
 /**
  *	sil680_bus_reset	-	reset the SIL680 bus
  *	@ap: ATA port to reset
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform the SIL680 housekeeping when doing an ATA bus reset
  */
 
-static int sil680_bus_reset(struct ata_port *ap,unsigned int *classes)
+static int sil680_bus_reset(struct ata_port *ap,unsigned int *classes,
+			    unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned long addr = sil680_selreg(ap, 0);
@@ -108,7 +110,7 @@ static int sil680_bus_reset(struct ata_port *ap,unsigned int *classes)
 	pci_write_config_byte(pdev, addr, reset | 0x03);
 	udelay(25);
 	pci_write_config_byte(pdev, addr, reset);
-	return ata_std_softreset(ap, classes);
+	return ata_std_softreset(ap, classes, deadline);
 }
 
 static void sil680_error_handler(struct ata_port *ap)
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index a3fbcee..f5838cc 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -88,6 +88,7 @@ static int sis_port_base(struct ata_device *adev)
 /**
  *	sis_133_cable_detect	-	check for 40/80 pin
  *	@ap: Port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection for the later UDMA133 capable
  *	SiS chipset.
@@ -108,6 +109,7 @@ static int sis_133_cable_detect(struct ata_port *ap)
 /**
  *	sis_66_cable_detect	-	check for 40/80 pin
  *	@ap: Port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection on the UDMA66, UDMA100 and early UDMA133
  *	SiS IDE controllers.
@@ -130,11 +132,12 @@ static int sis_66_cable_detect(struct ata_port *ap)
 /**
  *	sis_pre_reset		-	probe begin
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Set up cable type and use generic probe init
  */
 
-static int sis_pre_reset(struct ata_port *ap)
+static int sis_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits sis_enable_bits[] = {
 		{ 0x4aU, 1U, 0x02UL, 0x02UL },	/* port 0 */
@@ -145,7 +148,8 @@ static int sis_pre_reset(struct ata_port *ap)
 
 	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index da9e22b..9aeffdb 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -44,11 +44,12 @@ enum {
 /**
  *	sl82c105_pre_reset		-	probe begin
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Set up cable type and use generic probe init
  */
 
-static int sl82c105_pre_reset(struct ata_port *ap)
+static int sl82c105_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits sl82c105_enable_bits[] = {
 		{ 0x40, 1, 0x01, 0x01 },
@@ -58,7 +59,7 @@ static int sl82c105_pre_reset(struct ata_port *ap)
 
 	if (ap->port_no && !pci_test_config_bits(pdev, &sl82c105_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index e618ffd..349887b 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -48,11 +48,12 @@
 /**
  *	triflex_prereset		-	probe begin
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Set up cable type and use generic probe init
  */
 
-static int triflex_prereset(struct ata_port *ap)
+static int triflex_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits triflex_enable_bits[] = {
 		{ 0x80, 1, 0x01, 0x01 },
@@ -63,7 +64,8 @@ static int triflex_prereset(struct ata_port *ap)
 
 	if (!pci_test_config_bits(pdev, &triflex_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 96b7179..362beb2 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -154,7 +154,7 @@ static int via_cable_detect(struct ata_port *ap) {
 	return ATA_CBL_PATA40;
 }
 
-static int via_pre_reset(struct ata_port *ap)
+static int via_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	const struct via_isa_bridge *config = ap->host->private_data;
 
@@ -167,7 +167,8 @@ static int via_pre_reset(struct ata_port *ap)
 		if (!pci_test_config_bits(pdev, &via_enable_bits[ap->port_no]))
 			return -ENOENT;
 	}
-	return ata_std_prereset(ap);
+
+	return ata_std_prereset(ap, deadline);
 }
 
 
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index f099a1d..b3b62e9 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -420,7 +420,8 @@ static void inic_thaw(struct ata_port *ap)
  * SRST and SControl hardreset don't give valid signature on this
  * controller.  Only controller specific hardreset mechanism works.
  */
-static int inic_hardreset(struct ata_port *ap, unsigned int *class)
+static int inic_hardreset(struct ata_port *ap, unsigned int *class,
+			  unsigned long deadline)
 {
 	void __iomem *port_base = inic_port_base(ap);
 	void __iomem *idma_ctl = port_base + PORT_IDMA_CTL;
@@ -437,7 +438,7 @@ static int inic_hardreset(struct ata_port *ap, unsigned int *class)
 	msleep(1);
 	writew(val & ~IDMA_CTL_RST_ATA, idma_ctl);
 
-	rc = sata_phy_resume(ap, timing);
+	rc = sata_phy_resume(ap, timing, deadline);
 	if (rc) {
 		ata_port_printk(ap, KERN_WARNING, "failed to resume "
 				"link after reset (errno=%d)\n", rc);
@@ -451,10 +452,12 @@ static int inic_hardreset(struct ata_port *ap, unsigned int *class)
 		/* wait a while before checking status */
 		msleep(150);
 
-		if (ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT)) {
-			ata_port_printk(ap, KERN_WARNING,
-					"device busy after hardreset\n");
-			return -EIO;
+		rc = ata_wait_ready(ap, deadline);
+		/* link occupied, -ENODEV too is an error */
+		if (rc) {
+			ata_port_printk(ap, KERN_WARNING, "device not ready "
+					"after hardreset (errno=%d)\n", rc);
+			return rc;
 		}
 
 		ata_tf_read(ap, &tf);
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 0216974..e2e795e 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1405,7 +1405,8 @@ static void nv_ck804_thaw(struct ata_port *ap)
 	writeb(mask, mmio_base + NV_INT_ENABLE_CK804);
 }
 
-static int nv_hardreset(struct ata_port *ap, unsigned int *class)
+static int nv_hardreset(struct ata_port *ap, unsigned int *class,
+			unsigned long deadline)
 {
 	unsigned int dummy;
 
@@ -1413,7 +1414,7 @@ static int nv_hardreset(struct ata_port *ap, unsigned int *class)
 	 * some controllers.  Don't classify on hardreset.  For more
 	 * info, see http://bugme.osdl.org/show_bug.cgi?id=3352
 	 */
-	return sata_std_hardreset(ap, &dummy);
+	return sata_std_hardreset(ap, &dummy, deadline);
 }
 
 static void nv_error_handler(struct ata_port *ap)
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index e6223ba..b97ee9f 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -534,7 +534,8 @@ static int sil24_init_port(struct ata_port *ap)
 	return 0;
 }
 
-static int sil24_softreset(struct ata_port *ap, unsigned int *class)
+static int sil24_softreset(struct ata_port *ap, unsigned int *class,
+			   unsigned long deadline)
 {
 	void __iomem *port = ap->ioaddr.cmd_addr;
 	struct sil24_port_priv *pp = ap->private_data;
@@ -566,7 +567,7 @@ static int sil24_softreset(struct ata_port *ap, unsigned int *class)
 
 	mask = (PORT_IRQ_COMPLETE | PORT_IRQ_ERROR) << PORT_IRQ_RAW_SHIFT;
 	irq_stat = ata_wait_register(port + PORT_IRQ_STAT, mask, 0x0,
-				     100, ATA_TMOUT_BOOT / HZ * 1000);
+				     100, jiffies_to_msecs(deadline - jiffies));
 
 	writel(irq_stat, port + PORT_IRQ_STAT); /* clear IRQs */
 	irq_stat >>= PORT_IRQ_RAW_SHIFT;
@@ -594,7 +595,8 @@ static int sil24_softreset(struct ata_port *ap, unsigned int *class)
 	return -EIO;
 }
 
-static int sil24_hardreset(struct ata_port *ap, unsigned int *class)
+static int sil24_hardreset(struct ata_port *ap, unsigned int *class,
+			   unsigned long deadline)
 {
 	void __iomem *port = ap->ioaddr.cmd_addr;
 	const char *reason;
@@ -615,7 +617,7 @@ static int sil24_hardreset(struct ata_port *ap, unsigned int *class)
 	/* SStatus oscillates between zero and valid status after
 	 * DEV_RST, debounce it.
 	 */
-	rc = sata_phy_debounce(ap, sata_deb_timing_long);
+	rc = sata_phy_debounce(ap, sata_deb_timing_long, deadline);
 	if (rc) {
 		reason = "PHY debouncing failed";
 		goto err;
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 1d855f5..305ab7c 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -268,6 +268,7 @@ static void svia_noop_freeze(struct ata_port *ap)
 /**
  *	vt6420_prereset - prereset for vt6420
  *	@ap: target ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	SCR registers on vt6420 are pieces of shit and may hang the
  *	whole machine completely if accessed with the wrong timing.
@@ -284,7 +285,7 @@ static void svia_noop_freeze(struct ata_port *ap)
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-static int vt6420_prereset(struct ata_port *ap)
+static int vt6420_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	struct ata_eh_context *ehc = &ap->eh_context;
 	unsigned long timeout = jiffies + (HZ * 5);
@@ -329,7 +330,7 @@ static int vt6420_prereset(struct ata_port *ap)
 
  skip_scr:
 	/* wait for !BSY */
-	ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
+	ata_wait_ready(ap, deadline);
 
 	return 0;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d8cfc72..7906d75 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -296,18 +296,8 @@ enum {
 
 	/* how hard are we gonna try to probe/recover devices */
 	ATA_PROBE_MAX_TRIES	= 3,
-	ATA_EH_RESET_TRIES	= 3,
 	ATA_EH_DEV_TRIES	= 3,
 
-	/* Drive spinup time (time from power-on to the first D2H FIS)
-	 * in msecs - 8s currently.  Failing to get ready in this time
-	 * isn't critical.  It will result in reset failure for
-	 * controllers which can't wait for the first D2H FIS.  libata
-	 * will retry, so it just has to be long enough to spin up
-	 * most devices.
-	 */
-	ATA_SPINUP_WAIT		= 8000,
-
 	/* Horkage types. May be set by libata or controller on drives
 	   (some horkage may be drive/controller pair dependant */
 
@@ -348,8 +338,9 @@ struct ata_queued_cmd;
 
 /* typedefs */
 typedef void (*ata_qc_cb_t) (struct ata_queued_cmd *qc);
-typedef int (*ata_prereset_fn_t)(struct ata_port *ap);
-typedef int (*ata_reset_fn_t)(struct ata_port *ap, unsigned int *classes);
+typedef int (*ata_prereset_fn_t)(struct ata_port *ap, unsigned long deadline);
+typedef int (*ata_reset_fn_t)(struct ata_port *ap, unsigned int *classes,
+			      unsigned long deadline);
 typedef void (*ata_postreset_fn_t)(struct ata_port *ap, unsigned int *classes);
 
 struct ata_ioports {
@@ -494,7 +485,6 @@ struct ata_eh_info {
 	unsigned int		dev_action[ATA_MAX_DEVICES]; /* dev EH action */
 	unsigned int		flags;		/* ATA_EHI_* flags */
 
-	unsigned long		hotplug_timestamp;
 	unsigned int		probe_mask;
 
 	char			desc[ATA_EH_DESC_LEN];
@@ -688,13 +678,17 @@ extern void __sata_phy_reset(struct ata_port *ap);
 extern void sata_phy_reset(struct ata_port *ap);
 extern void ata_bus_reset(struct ata_port *ap);
 extern int sata_set_spd(struct ata_port *ap);
-extern int sata_phy_debounce(struct ata_port *ap, const unsigned long *param);
-extern int sata_phy_resume(struct ata_port *ap, const unsigned long *param);
-extern int ata_std_prereset(struct ata_port *ap);
-extern int ata_std_softreset(struct ata_port *ap, unsigned int *classes);
-extern int sata_port_hardreset(struct ata_port *ap,
-			       const unsigned long *timing);
-extern int sata_std_hardreset(struct ata_port *ap, unsigned int *class);
+extern int sata_phy_debounce(struct ata_port *ap, const unsigned long *param,
+			     unsigned long deadline);
+extern int sata_phy_resume(struct ata_port *ap, const unsigned long *param,
+			   unsigned long deadline);
+extern int ata_std_prereset(struct ata_port *ap, unsigned long deadline);
+extern int ata_std_softreset(struct ata_port *ap, unsigned int *classes,
+			     unsigned long deadline);
+extern int sata_port_hardreset(struct ata_port *ap, const unsigned long *timing,
+			       unsigned long deadline);
+extern int sata_std_hardreset(struct ata_port *ap, unsigned int *class,
+			      unsigned long deadline);
 extern void ata_std_postreset(struct ata_port *ap, unsigned int *classes);
 extern void ata_port_disable(struct ata_port *);
 extern void ata_std_ports(struct ata_ioports *ioaddr);
@@ -750,6 +744,7 @@ extern void ata_host_resume(struct ata_host *host);
 extern int ata_ratelimit(void);
 extern int ata_busy_sleep(struct ata_port *ap,
 			  unsigned long timeout_pat, unsigned long timeout);
+extern int ata_wait_ready(struct ata_port *ap, unsigned long deadline);
 extern void ata_port_queue_task(struct ata_port *ap, work_func_t fn,
 				void *data, unsigned long delay);
 extern u32 ata_wait_register(void __iomem *reg, u32 mask, u32 val,
@@ -919,12 +914,7 @@ extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 
 static inline void __ata_ehi_hotplugged(struct ata_eh_info *ehi)
 {
-	if (ehi->flags & ATA_EHI_HOTPLUGGED)
-		return;
-
 	ehi->flags |= ATA_EHI_HOTPLUGGED | ATA_EHI_RESUME_LINK;
-	ehi->hotplug_timestamp = jiffies;
-
 	ehi->action |= ATA_EH_SOFTRESET;
 	ehi->probe_mask |= (1 << ATA_MAX_DEVICES) - 1;
 }
