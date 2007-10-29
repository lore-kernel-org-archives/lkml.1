Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbXJ2TAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbXJ2TAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbXJ2TAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:00:13 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59554 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbXJ2TAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:00:09 -0400
Date: Mon, 29 Oct 2007 15:00:08 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches 2/2] libata: add ALPM
Message-ID: <20071029190008.GA5287@havoc.gtf.org>
References: <20071029185337.GA5241@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029185337.GA5241@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


NOTE: This is on top of the 'upstream-linus' branch, in a linear
history.  If you pull this, you get BOTH this and upstream-linus.  If
you already pulled upstream-linus, you will get only what you see below.

This has been in -mm for a while, but didn't make the initial push due
to my own fault.

Hardware SATA link power management (ALPM) has a __significant__
positive impact on power saving.  At the min_power setting (maximize
power savings), there have been claimed of battery life being extended
by 30-60 minutes or more (on a 4-6 hour battery).

Please pull from 'alpm' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git alpm

to receive the following updates:

 .../scsi/link_power_management_policy.txt          |   19 ++
 drivers/ata/ahci.c                                 |  157 ++++++++++++++++-
 drivers/ata/libata-core.c                          |  196 +++++++++++++++++++-
 drivers/ata/libata-eh.c                            |    4 +
 drivers/ata/libata-scsi.c                          |   68 +++++++
 drivers/ata/libata.h                               |    2 +
 include/linux/ata.h                                |   21 ++
 include/linux/libata.h                             |   21 ++-
 8 files changed, 484 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/scsi/link_power_management_policy.txt

Kristen Carlson Accardi (2):
      [libata] Link power management infrastructure
      [libata] AHCI: add hw link power management support

diff --git a/Documentation/scsi/link_power_management_policy.txt b/Documentation/scsi/link_power_management_policy.txt
new file mode 100644
index 0000000..d18993d
--- /dev/null
+++ b/Documentation/scsi/link_power_management_policy.txt
@@ -0,0 +1,19 @@
+This parameter allows the user to set the link (interface) power management.
+There are 3 possible options:
+
+Value			Effect
+----------------------------------------------------------------------------
+min_power		Tell the controller to try to make the link use the
+			least possible power when possible.  This may
+			sacrifice some performance due to increased latency
+			when coming out of lower power states.
+
+max_performance		Generally, this means no power management.  Tell
+			the controller to have performance be a priority
+			over power management.
+
+medium_power		Tell the controller to enter a lower power state
+			when possible, but do not enter the lowest power
+			state, thus improving latency over min_power setting.
+
+
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c8ab947..ed9b407 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -49,6 +49,9 @@
 #define DRV_NAME	"ahci"
 #define DRV_VERSION	"3.0"
 
+static int ahci_enable_alpm(struct ata_port *ap,
+		enum link_pm policy);
+static void ahci_disable_alpm(struct ata_port *ap);
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -99,6 +102,7 @@ enum {
 	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
 	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
 	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
+	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
 	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
 	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
 	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
@@ -155,6 +159,8 @@ enum {
 				  PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
 
 	/* PORT_CMD bits */
+	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
+	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
 	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
 	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
 	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
@@ -178,13 +184,14 @@ enum {
 	AHCI_HFLAG_MV_PATA		= (1 << 4), /* PATA port */
 	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
 	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
+	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
 
 	/* ap->flags bits */
-	AHCI_FLAG_NO_HOTPLUG		= (1 << 24), /* ignore PxSERR.DIAG.N */
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN,
+					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
+					  ATA_FLAG_IPM,
 	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
 };
 
@@ -254,6 +261,11 @@ static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 
+static struct class_device_attribute *ahci_shost_attrs[] = {
+	&class_device_attr_link_power_management_policy,
+	NULL
+};
+
 static struct scsi_host_template ahci_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -271,6 +283,7 @@ static struct scsi_host_template ahci_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+	.shost_attrs		= ahci_shost_attrs,
 };
 
 static const struct ata_port_operations ahci_ops = {
@@ -302,6 +315,8 @@ static const struct ata_port_operations ahci_ops = {
 	.port_suspend		= ahci_port_suspend,
 	.port_resume		= ahci_port_resume,
 #endif
+	.enable_pm		= ahci_enable_alpm,
+	.disable_pm		= ahci_disable_alpm,
 
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
@@ -836,6 +851,130 @@ static void ahci_power_up(struct ata_port *ap)
 	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
 }
 
+static void ahci_disable_alpm(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/* IPM bits should be disabled by libata-core */
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* disable ALPM and ASP */
+	cmd &= ~PORT_CMD_ASP;
+	cmd &= ~PORT_CMD_ALPE;
+
+	/* force the interface back to active */
+	cmd |= PORT_CMD_ICC_ACTIVE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* wait 10ms to be sure we've come out of any low power state */
+	msleep(10);
+
+	/* clear out any PhyRdy stuff from interrupt status */
+	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
+
+	/* go ahead and clean out PhyRdy Change from Serror too */
+	ahci_scr_write(ap, SCR_ERROR, ((1 << 16) | (1 << 18)));
+
+	/*
+ 	 * Clear flag to indicate that we should ignore all PhyRdy
+ 	 * state changes
+ 	 */
+	hpriv->flags &= ~AHCI_HFLAG_NO_HOTPLUG;
+
+	/*
+ 	 * Enable interrupts on Phy Ready.
+ 	 */
+	pp->intr_mask |= PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+ 	 * don't change the link pm policy - we can be called
+ 	 * just to turn of link pm temporarily
+ 	 */
+}
+
+static int ahci_enable_alpm(struct ata_port *ap,
+	enum link_pm policy)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 asp;
+
+	/* Make sure the host is capable of link power management */
+	if (!(hpriv->cap & HOST_CAP_ALPM))
+		return -EINVAL;
+
+	switch (policy) {
+	case MAX_PERFORMANCE:
+	case NOT_AVAILABLE:
+		/*
+ 		 * if we came here with NOT_AVAILABLE,
+ 		 * it just means this is the first time we
+ 		 * have tried to enable - default to max performance,
+ 		 * and let the user go to lower power modes on request.
+ 		 */
+		ahci_disable_alpm(ap);
+		return 0;
+	case MIN_POWER:
+		/* configure HBA to enter SLUMBER */
+		asp = PORT_CMD_ASP;
+		break;
+	case MEDIUM_POWER:
+		/* configure HBA to enter PARTIAL */
+		asp = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+ 	 * Disable interrupts on Phy Ready. This keeps us from
+ 	 * getting woken up due to spurious phy ready interrupts
+	 * TBD - Hot plug should be done via polling now, is
+	 * that even supported?
+ 	 */
+	pp->intr_mask &= ~PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+ 	 * Set a flag to indicate that we should ignore all PhyRdy
+ 	 * state changes since these can happen now whenever we
+ 	 * change link state
+ 	 */
+	hpriv->flags |= AHCI_HFLAG_NO_HOTPLUG;
+
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/*
+ 	 * Set ASP based on Policy
+ 	 */
+	cmd |= asp;
+
+	/*
+ 	 * Setting this bit will instruct the HBA to aggressively
+ 	 * enter a lower power link state when it's appropriate and
+ 	 * based on the value set above for ASP
+ 	 */
+	cmd |= PORT_CMD_ALPE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* IPM bits should be set by libata-core */
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static void ahci_power_down(struct ata_port *ap)
 {
@@ -1504,6 +1643,17 @@ static void ahci_port_intr(struct ata_port *ap)
 	if (unlikely(resetting))
 		status &= ~PORT_IRQ_BAD_PMP;
 
+	/* If we are getting PhyRdy, this is
+ 	 * just a power state change, we should
+ 	 * clear out this, plus the PhyRdy/Comm
+ 	 * Wake bits from Serror
+ 	 */
+	if ((hpriv->flags & AHCI_HFLAG_NO_HOTPLUG) &&
+		(status & PORT_IRQ_PHYRDY)) {
+		status &= ~PORT_IRQ_PHYRDY;
+		ahci_scr_write(ap, SCR_ERROR, ((1 << 16) | (1 << 18)));
+	}
+
 	if (unlikely(status & PORT_IRQ_ERROR)) {
 		ahci_error_intr(ap, status);
 		return;
@@ -2151,6 +2301,9 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
 				   0x100 + ap->port_no * 0x80, "port");
 
+		/* set initial link pm policy */
+		ap->pm_policy = NOT_AVAILABLE;
+
 		/* standard SATA port setup */
 		if (hpriv->port_map & (1 << i))
 			ap->ioaddr.cmd_addr = port_mmio;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3891cdc..513babe 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -620,6 +620,177 @@ void ata_dev_disable(struct ata_device *dev)
 	}
 }
 
+static int ata_dev_set_dipm(struct ata_device *dev, enum link_pm policy)
+{
+	struct ata_link *link = dev->link;
+	struct ata_port *ap = link->ap;
+	u32 scontrol;
+	unsigned int err_mask;
+	int rc;
+
+	/*
+	 * disallow DIPM for drivers which haven't set
+	 * ATA_FLAG_IPM.  This is because when DIPM is enabled,
+	 * phy ready will be set in the interrupt status on
+	 * state changes, which will cause some drivers to
+	 * think there are errors - additionally drivers will
+	 * need to disable hot plug.
+	 */
+	if (!(ap->flags & ATA_FLAG_IPM) || !ata_dev_enabled(dev)) {
+		ap->pm_policy = NOT_AVAILABLE;
+		return -EINVAL;
+	}
+
+	/*
+	 * For DIPM, we will only enable it for the
+	 * min_power setting.
+	 *
+	 * Why?  Because Disks are too stupid to know that
+	 * If the host rejects a request to go to SLUMBER
+	 * they should retry at PARTIAL, and instead it
+	 * just would give up.  So, for medium_power to
+	 * work at all, we need to only allow HIPM.
+	 */
+	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
+	if (rc)
+		return rc;
+
+	switch (policy) {
+	case MIN_POWER:
+		/* no restrictions on IPM transitions */
+		scontrol &= ~(0x3 << 8);
+		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
+		if (rc)
+			return rc;
+
+		/* enable DIPM */
+		if (dev->flags & ATA_DFLAG_DIPM)
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_ENABLE, SATA_DIPM);
+		break;
+	case MEDIUM_POWER:
+		/* allow IPM to PARTIAL */
+		scontrol &= ~(0x1 << 8);
+		scontrol |= (0x2 << 8);
+		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
+		if (rc)
+			return rc;
+
+		/* disable DIPM */
+		if (ata_dev_enabled(dev) && (dev->flags & ATA_DFLAG_DIPM))
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+		break;
+	case NOT_AVAILABLE:
+	case MAX_PERFORMANCE:
+		/* disable all IPM transitions */
+		scontrol |= (0x3 << 8);
+		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
+		if (rc)
+			return rc;
+
+		/* disable DIPM */
+		if (ata_dev_enabled(dev) && (dev->flags & ATA_DFLAG_DIPM))
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+		break;
+	}
+
+	/* FIXME: handle SET FEATURES failure */
+	(void) err_mask;
+
+	return 0;
+}
+
+/**
+ *	ata_dev_enable_pm - enable SATA interface power management
+ *	@device - device to enable ipm for
+ *	@policy - the link power management policy
+ *
+ *	Enable SATA Interface power management.  This will enable
+ *	Device Interface Power Management (DIPM) for min_power
+ * 	policy, and then call driver specific callbacks for
+ *	enabling Host Initiated Power management.
+ *
+ *	Locking: Caller.
+ *	Returns: -EINVAL if IPM is not supported, 0 otherwise.
+ */
+void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy)
+{
+	int rc = 0;
+	struct ata_port *ap = dev->link->ap;
+
+	/* set HIPM first, then DIPM */
+	if (ap->ops->enable_pm)
+		rc = ap->ops->enable_pm(ap, policy);
+	if (rc)
+		goto enable_pm_out;
+	rc = ata_dev_set_dipm(dev, policy);
+
+enable_pm_out:
+	if (rc)
+		ap->pm_policy = MAX_PERFORMANCE;
+	else
+		ap->pm_policy = policy;
+	return /* rc */;	/* hopefully we can use 'rc' eventually */
+}
+
+/**
+ *	ata_dev_disable_pm - disable SATA interface power management
+ *	@device - device to enable ipm for
+ *
+ *	Disable SATA Interface power management.  This will disable
+ *	Device Interface Power Management (DIPM) without changing
+ * 	policy,  call driver specific callbacks for disabling Host
+ * 	Initiated Power management.
+ *
+ *	Locking: Caller.
+ *	Returns: void
+ */
+static void ata_dev_disable_pm(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+
+	ata_dev_set_dipm(dev, MAX_PERFORMANCE);
+	if (ap->ops->disable_pm)
+		ap->ops->disable_pm(ap);
+}
+
+void ata_lpm_schedule(struct ata_port *ap, enum link_pm policy)
+{
+	ap->pm_policy = policy;
+	ap->link.eh_info.action |= ATA_EHI_LPM;
+	ap->link.eh_info.flags |= ATA_EHI_NO_AUTOPSY;
+	ata_port_schedule_eh(ap);
+}
+
+static void ata_lpm_enable(struct ata_host *host)
+{
+	struct ata_link *link;
+	struct ata_port *ap;
+	struct ata_device *dev;
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		ap = host->ports[i];
+		ata_port_for_each_link(link, ap) {
+			ata_link_for_each_dev(dev, link)
+				ata_dev_disable_pm(dev);
+		}
+	}
+}
+
+static void ata_lpm_disable(struct ata_host *host)
+{
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		ata_lpm_schedule(ap, ap->pm_policy);
+	}
+}
+
+
 /**
  *	ata_devchk - PATA device presence detection
  *	@ap: ATA channel to examine
@@ -2101,6 +2272,13 @@ int ata_dev_configure(struct ata_device *dev)
 	if (dev->flags & ATA_DFLAG_LBA48)
 		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
 
+	if (!(dev->horkage & ATA_HORKAGE_IPM)) {
+		if (ata_id_has_hipm(dev->id))
+			dev->flags |= ATA_DFLAG_HIPM;
+		if (ata_id_has_dipm(dev->id))
+			dev->flags |= ATA_DFLAG_DIPM;
+	}
+
 	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
 		/* Let the user know. We don't want to disallow opens for
 		   rescue purposes, or in case the vendor is just a blithering
@@ -2126,6 +2304,13 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
+	if (ata_dev_blacklisted(dev) & ATA_HORKAGE_IPM) {
+		dev->horkage |= ATA_HORKAGE_IPM;
+
+		/* reset link pm_policy for this port to no pm */
+		ap->pm_policy = MAX_PERFORMANCE;
+	}
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -6361,6 +6546,12 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 {
 	int rc;
 
+	/*
+	 * disable link pm on all ports before requesting
+	 * any pm activity
+	 */
+	ata_lpm_enable(host);
+
 	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
 	if (rc == 0)
 		host->dev->power.power_state = mesg;
@@ -6383,6 +6574,9 @@ void ata_host_resume(struct ata_host *host)
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
+
+	/* reenable link pm */
+	ata_lpm_disable(host);
 }
 #endif
 
@@ -6925,6 +7119,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 		struct ata_port *ap = host->ports[i];
 
 		ata_scsi_scan_host(ap, 1);
+		ata_lpm_schedule(ap, ap->pm_policy);
 	}
 
 	return 0;
@@ -7321,7 +7516,6 @@ const struct ata_port_info ata_dummy_port_info = {
  * likely to change as new drivers are added and updated.
  * Do not depend on ABI/API stability.
  */
-
 EXPORT_SYMBOL_GPL(sata_deb_timing_normal);
 EXPORT_SYMBOL_GPL(sata_deb_timing_hotplug);
 EXPORT_SYMBOL_GPL(sata_deb_timing_long);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index ec55d63..fefea74 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2628,6 +2628,10 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			ehc->i.flags &= ~ATA_EHI_SETMODE;
 		}
 
+		if (ehc->i.action & ATA_EHI_LPM)
+			ata_link_for_each_dev(dev, link)
+				ata_dev_enable_pm(dev, ap->pm_policy);
+
 		/* this link is okay now */
 		ehc->i.flags = 0;
 		continue;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f752edd..93bd36c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -110,6 +110,74 @@ static struct scsi_transport_template ata_scsi_transport_template = {
 };
 
 
+static const struct {
+	enum link_pm	value;
+	const char	*name;
+} link_pm_policy[] = {
+	{ NOT_AVAILABLE, "max_performance" },
+	{ MIN_POWER, "min_power" },
+	{ MAX_PERFORMANCE, "max_performance" },
+	{ MEDIUM_POWER, "medium_power" },
+};
+
+const char *ata_scsi_lpm_get(enum link_pm policy)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(link_pm_policy); i++)
+		if (link_pm_policy[i].value == policy)
+			return link_pm_policy[i].name;
+
+	return NULL;
+}
+
+static ssize_t ata_scsi_lpm_put(struct class_device *class_dev,
+	const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	enum link_pm policy = 0;
+	int i;
+
+	/*
+	 * we are skipping array location 0 on purpose - this
+	 * is because a value of NOT_AVAILABLE is displayed
+	 * to the user as max_performance, but when the user
+	 * writes "max_performance", they actually want the
+	 * value to match MAX_PERFORMANCE.
+	 */
+	for (i = 1; i < ARRAY_SIZE(link_pm_policy); i++) {
+		const int len = strlen(link_pm_policy[i].name);
+		if (strncmp(link_pm_policy[i].name, buf, len) == 0 &&
+		   buf[len] == '\n') {
+			policy = link_pm_policy[i].value;
+			break;
+		}
+	}
+	if (!policy)
+		return -EINVAL;
+
+	ata_lpm_schedule(ap, policy);
+	return count;
+}
+
+static ssize_t
+ata_scsi_lpm_show(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	const char *policy =
+		ata_scsi_lpm_get(ap->pm_policy);
+
+	if (!policy)
+		return -EINVAL;
+
+	return snprintf(buf, 23, "%s\n", policy);
+}
+CLASS_DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
+		ata_scsi_lpm_show, ata_scsi_lpm_put);
+EXPORT_SYMBOL_GPL(class_device_attr_link_power_management_policy);
+
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
 {
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 90df58a..0e6cf3a 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -101,6 +101,8 @@ extern int sata_link_init_spd(struct ata_link *link);
 extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
+extern void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy);
+extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
diff --git a/include/linux/ata.h b/include/linux/ata.h
index e21c002..128dc7a 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -236,6 +236,7 @@ enum {
 
 	/* SETFEATURE Sector counts for SATA features */
 	SATA_AN			= 0x05,  /* Asynchronous Notification */
+	SATA_DIPM		= 0x03,  /* Device Initiated Power Management */
 
 	/* ATAPI stuff */
 	ATAPI_PKT_DMA		= (1 << 0),
@@ -378,6 +379,26 @@ struct ata_taskfile {
 
 #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
 
+static inline bool ata_id_has_hipm(const u16 *id)
+{
+	u16 val = id[76];
+
+	if (val == 0 || val == 0xffff)
+		return false;
+
+	return val & (1 << 9);
+}
+
+static inline bool ata_id_has_dipm(const u16 *id)
+{
+	u16 val = id[78];
+
+	if (val == 0 || val == 0xffff)
+		return false;
+
+	return val & (1 << 3);
+}
+
 static inline int ata_id_has_fua(const u16 *id)
 {
 	if ((id[84] & 0xC000) != 0x4000)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 439d40f..147ccc4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -133,6 +133,8 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
+	ATA_DFLAG_HIPM		= (1 << 8), /* device supports HIPM */
+	ATA_DFLAG_DIPM		= (1 << 9), /* device supports DIPM */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
@@ -186,6 +188,7 @@ enum {
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
 	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */
 	ATA_FLAG_PMP		= (1 << 19), /* controller supports PMP */
+	ATA_FLAG_IPM		= (1 << 20), /* driver can handle IPM */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
@@ -302,6 +305,7 @@ enum {
 	ATA_EHI_RESUME_LINK	= (1 << 1),  /* resume link (reset modifier) */
 	ATA_EHI_NO_AUTOPSY	= (1 << 2),  /* no autopsy */
 	ATA_EHI_QUIET		= (1 << 3),  /* be quiet */
+	ATA_EHI_LPM		= (1 << 4),  /* link power management action */
 
 	ATA_EHI_DID_SOFTRESET	= (1 << 16), /* already soft-reset this port */
 	ATA_EHI_DID_HARDRESET	= (1 << 17), /* already soft-reset this port */
@@ -333,6 +337,7 @@ enum {
 	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
 	ATA_HORKAGE_SKIP_PM	= (1 << 5),	/* Skip PM operations */
 	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
+	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
@@ -378,6 +383,18 @@ typedef int (*ata_reset_fn_t)(struct ata_link *link, unsigned int *classes,
 			      unsigned long deadline);
 typedef void (*ata_postreset_fn_t)(struct ata_link *link, unsigned int *classes);
 
+/*
+ * host pm policy: If you alter this, you also need to alter libata-scsi.c
+ * (for the ascii descriptions)
+ */
+enum link_pm {
+	NOT_AVAILABLE,
+	MIN_POWER,
+	MAX_PERFORMANCE,
+	MEDIUM_POWER,
+};
+extern struct class_device_attribute class_device_attr_link_power_management_policy;
+
 struct ata_ioports {
 	void __iomem		*cmd_addr;
 	void __iomem		*data_addr;
@@ -624,6 +641,7 @@ struct ata_port {
 
 	pm_message_t		pm_mesg;
 	int			*pm_result;
+	enum link_pm		pm_policy;
 
 	struct timer_list	fastdrain_timer;
 	unsigned long		fastdrain_cnt;
@@ -691,7 +709,8 @@ struct ata_port_operations {
 
 	int (*port_suspend) (struct ata_port *ap, pm_message_t mesg);
 	int (*port_resume) (struct ata_port *ap);
-
+	int (*enable_pm) (struct ata_port *ap, enum link_pm policy);
+	void (*disable_pm) (struct ata_port *ap);
 	int (*port_start) (struct ata_port *ap);
 	void (*port_stop) (struct ata_port *ap);
 
