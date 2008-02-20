Return-Path: <linux-kernel-owner+w=401wt.eu-S1764178AbYBTRZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764178AbYBTRZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYBTRZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:25:42 -0500
Received: from havoc.gtf.org ([69.61.125.42]:33147 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbYBTRZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:25:39 -0500
Date: Wed, 20 Feb 2008 12:25:37 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080220172537.GA20908@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note: Tejun's change is a feature addition, but one that is IMO
important for debugging and serious-bug workarounds.  It's
self-contained and should not affect anyone not using the new parm.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/kernel-parameters.txt |   35 ++++
 drivers/ata/libata-core.c           |  380 ++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-eh.c             |    8 +-
 drivers/ata/libata-scsi.c           |    2 +-
 drivers/ata/libata.h                |    1 +
 drivers/ata/pata_legacy.c           |   44 ++--
 drivers/ata/sata_mv.c               |    9 +-
 include/linux/libata.h              |    2 +-
 8 files changed, 448 insertions(+), 33 deletions(-)

Harvey Harrison (2):
      ata: fix sparse warnings in pata_legacy.c
      ata: fix sparse warning in libata.h

Martin Michlmayr (1):
      sata_mv: Define module alias for platform device

Randy Dunlap (1):
      libata: fix kernel-doc parameter warning

Saeed Bishara (2):
      sata_mv: use hpriv->base instead of the host->iomap
      sata_mv: remove iounmap in mv_platform_remove and use devm_iomap

Tejun Heo (1):
      libata: implement libata.force module parameter

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7278295..9a5b665 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -950,6 +950,41 @@ and is between 256 and 4096 characters. It is defined in the file
 			when set.
 			Format: <int>
 
+	libata.force=	[LIBATA] Force configurations.  The format is comma
+			separated list of "[ID:]VAL" where ID is
+			PORT[:DEVICE].  PORT and DEVICE are decimal numbers
+			matching port, link or device.  Basically, it matches
+			the ATA ID string printed on console by libata.  If
+			the whole ID part is omitted, the last PORT and DEVICE
+			values are used.  If ID hasn't been specified yet, the
+			configuration applies to all ports, links and devices.
+
+			If only DEVICE is omitted, the parameter applies to
+			the port and all links and devices behind it.  DEVICE
+			number of 0 either selects the first device or the
+			first fan-out link behind PMP device.  It does not
+			select the host link.  DEVICE number of 15 selects the
+			host link and device attached to it.
+
+			The VAL specifies the configuration to force.  As long
+			as there's no ambiguity shortcut notation is allowed.
+			For example, both 1.5 and 1.5G would work for 1.5Gbps.
+			The following configurations can be forced.
+
+			* Cable type: 40c, 80c, short40c, unk, ign or sata.
+			  Any ID with matching PORT is used.
+
+			* SATA link speed limit: 1.5Gbps or 3.0Gbps.
+
+			* Transfer mode: pio[0-7], mwdma[0-4] and udma[0-7].
+			  udma[/][16,25,33,44,66,100,133] notation is also
+			  allowed.
+
+			* [no]ncq: Turn on or off NCQ.
+
+			If there are multiple matching configurations changing
+			the same attribute, the last one is used.
+
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
 			See Documentation/ramdisk.txt.
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index def3682..60d1bb5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -87,6 +87,28 @@ static struct workqueue_struct *ata_wq;
 
 struct workqueue_struct *ata_aux_wq;
 
+struct ata_force_param {
+	const char	*name;
+	unsigned int	cbl;
+	int		spd_limit;
+	unsigned long	xfer_mask;
+	unsigned int	horkage_on;
+	unsigned int	horkage_off;
+};
+
+struct ata_force_ent {
+	int			port;
+	int			device;
+	struct ata_force_param	param;
+};
+
+static struct ata_force_ent *ata_force_tbl;
+static int ata_force_tbl_size;
+
+static char ata_force_param_buf[PAGE_SIZE] __initdata;
+module_param_string(force, ata_force_param_buf, sizeof(ata_force_param_buf), 0444);
+MODULE_PARM_DESC(force, "Force ATA configurations including cable type, link speed and transfer mode (see Documentation/kernel-parameters.txt for details)");
+
 int atapi_enabled = 1;
 module_param(atapi_enabled, int, 0444);
 MODULE_PARM_DESC(atapi_enabled, "Enable discovery of ATAPI devices (0=off, 1=on)");
@@ -130,6 +152,179 @@ MODULE_VERSION(DRV_VERSION);
 
 
 /**
+ *	ata_force_cbl - force cable type according to libata.force
+ *	@link: ATA link of interest
+ *
+ *	Force cable type according to libata.force and whine about it.
+ *	The last entry which has matching port number is used, so it
+ *	can be specified as part of device force parameters.  For
+ *	example, both "a:40c,1.00:udma4" and "1.00:40c,udma4" have the
+ *	same effect.
+ *
+ *	LOCKING:
+ *	EH context.
+ */
+void ata_force_cbl(struct ata_port *ap)
+{
+	int i;
+
+	for (i = ata_force_tbl_size - 1; i >= 0; i--) {
+		const struct ata_force_ent *fe = &ata_force_tbl[i];
+
+		if (fe->port != -1 && fe->port != ap->print_id)
+			continue;
+
+		if (fe->param.cbl == ATA_CBL_NONE)
+			continue;
+
+		ap->cbl = fe->param.cbl;
+		ata_port_printk(ap, KERN_NOTICE,
+				"FORCE: cable set to %s\n", fe->param.name);
+		return;
+	}
+}
+
+/**
+ *	ata_force_spd_limit - force SATA spd limit according to libata.force
+ *	@link: ATA link of interest
+ *
+ *	Force SATA spd limit according to libata.force and whine about
+ *	it.  When only the port part is specified (e.g. 1:), the limit
+ *	applies to all links connected to both the host link and all
+ *	fan-out ports connected via PMP.  If the device part is
+ *	specified as 0 (e.g. 1.00:), it specifies the first fan-out
+ *	link not the host link.  Device number 15 always points to the
+ *	host link whether PMP is attached or not.
+ *
+ *	LOCKING:
+ *	EH context.
+ */
+static void ata_force_spd_limit(struct ata_link *link)
+{
+	int linkno, i;
+
+	if (ata_is_host_link(link))
+		linkno = 15;
+	else
+		linkno = link->pmp;
+
+	for (i = ata_force_tbl_size - 1; i >= 0; i--) {
+		const struct ata_force_ent *fe = &ata_force_tbl[i];
+
+		if (fe->port != -1 && fe->port != link->ap->print_id)
+			continue;
+
+		if (fe->device != -1 && fe->device != linkno)
+			continue;
+
+		if (!fe->param.spd_limit)
+			continue;
+
+		link->hw_sata_spd_limit = (1 << fe->param.spd_limit) - 1;
+		ata_link_printk(link, KERN_NOTICE,
+			"FORCE: PHY spd limit set to %s\n", fe->param.name);
+		return;
+	}
+}
+
+/**
+ *	ata_force_xfermask - force xfermask according to libata.force
+ *	@dev: ATA device of interest
+ *
+ *	Force xfer_mask according to libata.force and whine about it.
+ *	For consistency with link selection, device number 15 selects
+ *	the first device connected to the host link.
+ *
+ *	LOCKING:
+ *	EH context.
+ */
+static void ata_force_xfermask(struct ata_device *dev)
+{
+	int devno = dev->link->pmp + dev->devno;
+	int alt_devno = devno;
+	int i;
+
+	/* allow n.15 for the first device attached to host port */
+	if (ata_is_host_link(dev->link) && devno == 0)
+		alt_devno = 15;
+
+	for (i = ata_force_tbl_size - 1; i >= 0; i--) {
+		const struct ata_force_ent *fe = &ata_force_tbl[i];
+		unsigned long pio_mask, mwdma_mask, udma_mask;
+
+		if (fe->port != -1 && fe->port != dev->link->ap->print_id)
+			continue;
+
+		if (fe->device != -1 && fe->device != devno &&
+		    fe->device != alt_devno)
+			continue;
+
+		if (!fe->param.xfer_mask)
+			continue;
+
+		ata_unpack_xfermask(fe->param.xfer_mask,
+				    &pio_mask, &mwdma_mask, &udma_mask);
+		if (udma_mask)
+			dev->udma_mask = udma_mask;
+		else if (mwdma_mask) {
+			dev->udma_mask = 0;
+			dev->mwdma_mask = mwdma_mask;
+		} else {
+			dev->udma_mask = 0;
+			dev->mwdma_mask = 0;
+			dev->pio_mask = pio_mask;
+		}
+
+		ata_dev_printk(dev, KERN_NOTICE,
+			"FORCE: xfer_mask set to %s\n", fe->param.name);
+		return;
+	}
+}
+
+/**
+ *	ata_force_horkage - force horkage according to libata.force
+ *	@dev: ATA device of interest
+ *
+ *	Force horkage according to libata.force and whine about it.
+ *	For consistency with link selection, device number 15 selects
+ *	the first device connected to the host link.
+ *
+ *	LOCKING:
+ *	EH context.
+ */
+static void ata_force_horkage(struct ata_device *dev)
+{
+	int devno = dev->link->pmp + dev->devno;
+	int alt_devno = devno;
+	int i;
+
+	/* allow n.15 for the first device attached to host port */
+	if (ata_is_host_link(dev->link) && devno == 0)
+		alt_devno = 15;
+
+	for (i = 0; i < ata_force_tbl_size; i++) {
+		const struct ata_force_ent *fe = &ata_force_tbl[i];
+
+		if (fe->port != -1 && fe->port != dev->link->ap->print_id)
+			continue;
+
+		if (fe->device != -1 && fe->device != devno &&
+		    fe->device != alt_devno)
+			continue;
+
+		if (!(~dev->horkage & fe->param.horkage_on) &&
+		    !(dev->horkage & fe->param.horkage_off))
+			continue;
+
+		dev->horkage |= fe->param.horkage_on;
+		dev->horkage &= ~fe->param.horkage_off;
+
+		ata_dev_printk(dev, KERN_NOTICE,
+			"FORCE: horkage modified (%s)\n", fe->param.name);
+	}
+}
+
+/**
  *	ata_tf_to_fis - Convert ATA taskfile to SATA FIS structure
  *	@tf: Taskfile to convert
  *	@pmp: Port multiplier port
@@ -2067,6 +2262,7 @@ int ata_dev_configure(struct ata_device *dev)
 
 	/* set horkage */
 	dev->horkage |= ata_dev_blacklisted(dev);
+	ata_force_horkage(dev);
 
 	/* let ACPI work its magic */
 	rc = ata_acpi_on_devcfg(dev);
@@ -3150,6 +3346,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 			mode_mask = ATA_DMA_MASK_CFA;
 
 		ata_dev_xfermask(dev);
+		ata_force_xfermask(dev);
 
 		pio_mask = ata_pack_xfermask(dev->pio_mask, 0, 0);
 		dma_mask = ata_pack_xfermask(0, dev->mwdma_mask, dev->udma_mask);
@@ -6497,7 +6694,8 @@ void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp)
  */
 int sata_link_init_spd(struct ata_link *link)
 {
-	u32 scontrol, spd;
+	u32 scontrol;
+	u8 spd;
 	int rc;
 
 	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
@@ -6508,6 +6706,8 @@ int sata_link_init_spd(struct ata_link *link)
 	if (spd)
 		link->hw_sata_spd_limit &= (1 << spd) - 1;
 
+	ata_force_spd_limit(link);
+
 	link->sata_spd_limit = link->hw_sata_spd_limit;
 
 	return 0;
@@ -7218,10 +7418,187 @@ int ata_pci_device_resume(struct pci_dev *pdev)
 
 #endif /* CONFIG_PCI */
 
+static int __init ata_parse_force_one(char **cur,
+				      struct ata_force_ent *force_ent,
+				      const char **reason)
+{
+	/* FIXME: Currently, there's no way to tag init const data and
+	 * using __initdata causes build failure on some versions of
+	 * gcc.  Once __initdataconst is implemented, add const to the
+	 * following structure.
+	 */
+	static struct ata_force_param force_tbl[] __initdata = {
+		{ "40c",	.cbl		= ATA_CBL_PATA40 },
+		{ "80c",	.cbl		= ATA_CBL_PATA80 },
+		{ "short40c",	.cbl		= ATA_CBL_PATA40_SHORT },
+		{ "unk",	.cbl		= ATA_CBL_PATA_UNK },
+		{ "ign",	.cbl		= ATA_CBL_PATA_IGN },
+		{ "sata",	.cbl		= ATA_CBL_SATA },
+		{ "1.5Gbps",	.spd_limit	= 1 },
+		{ "3.0Gbps",	.spd_limit	= 2 },
+		{ "noncq",	.horkage_on	= ATA_HORKAGE_NONCQ },
+		{ "ncq",	.horkage_off	= ATA_HORKAGE_NONCQ },
+		{ "pio0",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 0) },
+		{ "pio1",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 1) },
+		{ "pio2",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 2) },
+		{ "pio3",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 3) },
+		{ "pio4",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 4) },
+		{ "pio5",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 5) },
+		{ "pio6",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 6) },
+		{ "mwdma0",	.xfer_mask	= 1 << (ATA_SHIFT_MWDMA + 0) },
+		{ "mwdma1",	.xfer_mask	= 1 << (ATA_SHIFT_MWDMA + 1) },
+		{ "mwdma2",	.xfer_mask	= 1 << (ATA_SHIFT_MWDMA + 2) },
+		{ "mwdma3",	.xfer_mask	= 1 << (ATA_SHIFT_MWDMA + 3) },
+		{ "mwdma4",	.xfer_mask	= 1 << (ATA_SHIFT_MWDMA + 4) },
+		{ "udma0",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 0) },
+		{ "udma16",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 0) },
+		{ "udma/16",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 0) },
+		{ "udma1",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 1) },
+		{ "udma25",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 1) },
+		{ "udma/25",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 1) },
+		{ "udma2",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 2) },
+		{ "udma33",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 2) },
+		{ "udma/33",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 2) },
+		{ "udma3",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 3) },
+		{ "udma44",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 3) },
+		{ "udma/44",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 3) },
+		{ "udma4",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 4) },
+		{ "udma66",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 4) },
+		{ "udma/66",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 4) },
+		{ "udma5",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 5) },
+		{ "udma100",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 5) },
+		{ "udma/100",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 5) },
+		{ "udma6",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 6) },
+		{ "udma133",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 6) },
+		{ "udma/133",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 6) },
+		{ "udma7",	.xfer_mask	= 1 << (ATA_SHIFT_UDMA + 7) },
+	};
+	char *start = *cur, *p = *cur;
+	char *id, *val, *endp;
+	const struct ata_force_param *match_fp = NULL;
+	int nr_matches = 0, i;
+
+	/* find where this param ends and update *cur */
+	while (*p != '\0' && *p != ',')
+		p++;
+
+	if (*p == '\0')
+		*cur = p;
+	else
+		*cur = p + 1;
+
+	*p = '\0';
+
+	/* parse */
+	p = strchr(start, ':');
+	if (!p) {
+		val = strstrip(start);
+		goto parse_val;
+	}
+	*p = '\0';
+
+	id = strstrip(start);
+	val = strstrip(p + 1);
+
+	/* parse id */
+	p = strchr(id, '.');
+	if (p) {
+		*p++ = '\0';
+		force_ent->device = simple_strtoul(p, &endp, 10);
+		if (p == endp || *endp != '\0') {
+			*reason = "invalid device";
+			return -EINVAL;
+		}
+	}
+
+	force_ent->port = simple_strtoul(id, &endp, 10);
+	if (p == endp || *endp != '\0') {
+		*reason = "invalid port/link";
+		return -EINVAL;
+	}
+
+ parse_val:
+	/* parse val, allow shortcuts so that both 1.5 and 1.5Gbps work */
+	for (i = 0; i < ARRAY_SIZE(force_tbl); i++) {
+		const struct ata_force_param *fp = &force_tbl[i];
+
+		if (strncasecmp(val, fp->name, strlen(val)))
+			continue;
+
+		nr_matches++;
+		match_fp = fp;
+
+		if (strcasecmp(val, fp->name) == 0) {
+			nr_matches = 1;
+			break;
+		}
+	}
+
+	if (!nr_matches) {
+		*reason = "unknown value";
+		return -EINVAL;
+	}
+	if (nr_matches > 1) {
+		*reason = "ambigious value";
+		return -EINVAL;
+	}
+
+	force_ent->param = *match_fp;
+
+	return 0;
+}
+
+static void __init ata_parse_force_param(void)
+{
+	int idx = 0, size = 1;
+	int last_port = -1, last_device = -1;
+	char *p, *cur, *next;
+
+	/* calculate maximum number of params and allocate force_tbl */
+	for (p = ata_force_param_buf; *p; p++)
+		if (*p == ',')
+			size++;
+
+	ata_force_tbl = kzalloc(sizeof(ata_force_tbl[0]) * size, GFP_KERNEL);
+	if (!ata_force_tbl) {
+		printk(KERN_WARNING "ata: failed to extend force table, "
+		       "libata.force ignored\n");
+		return;
+	}
+
+	/* parse and populate the table */
+	for (cur = ata_force_param_buf; *cur != '\0'; cur = next) {
+		const char *reason = "";
+		struct ata_force_ent te = { .port = -1, .device = -1 };
+
+		next = cur;
+		if (ata_parse_force_one(&next, &te, &reason)) {
+			printk(KERN_WARNING "ata: failed to parse force "
+			       "parameter \"%s\" (%s)\n",
+			       cur, reason);
+			continue;
+		}
+
+		if (te.port == -1) {
+			te.port = last_port;
+			te.device = last_device;
+		}
+
+		ata_force_tbl[idx++] = te;
+
+		last_port = te.port;
+		last_device = te.device;
+	}
+
+	ata_force_tbl_size = idx;
+}
 
 static int __init ata_init(void)
 {
 	ata_probe_timeout *= HZ;
+
+	ata_parse_force_param();
+
 	ata_wq = create_workqueue("ata");
 	if (!ata_wq)
 		return -ENOMEM;
@@ -7238,6 +7615,7 @@ static int __init ata_init(void)
 
 static void __exit ata_exit(void)
 {
+	kfree(ata_force_tbl);
 	destroy_workqueue(ata_wq);
 	destroy_workqueue(ata_aux_wq);
 }
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 4e31071..698ce2c 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2393,9 +2393,11 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 	}
 
 	/* PDIAG- should have been released, ask cable type if post-reset */
-	if (ata_is_host_link(link) && ap->ops->cable_detect &&
-	    (ehc->i.flags & ATA_EHI_DID_RESET))
-		ap->cbl = ap->ops->cable_detect(ap);
+	if ((ehc->i.flags & ATA_EHI_DID_RESET) && ata_is_host_link(link)) {
+		if (ap->ops->cable_detect)
+			ap->cbl = ap->ops->cable_detect(ap);
+		ata_force_cbl(ap);
+	}
 
 	/* Configure new devices forward such that user doesn't see
 	 * device detection messages backwards.
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index dd41b1a..f888bab 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -828,7 +828,7 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 
 /**
  *	atapi_drain_needed - Check whether data transfer may overflow
- *	@request: request to be checked
+ *	@rq: request to be checked
  *
  *	ATAPI commands which transfer variable length data to host
  *	might overflow due to application error or hardare bug.  This
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 409ffb9..6036ded 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -61,6 +61,7 @@ extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
 extern int libata_allow_tpm;
+extern void ata_force_cbl(struct ata_port *ap);
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index d2177f7..50fe08e 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -774,14 +774,14 @@ static struct ata_port_operations opti82c46x_port_ops = {
 static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ata_timing t;
-	struct legacy_data *qdi = ap->host->private_data;
+	struct legacy_data *ld_qdi = ap->host->private_data;
 	int active, recovery;
 	u8 timing;
 
 	/* Get the timing data in cycles */
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	if (qdi->fast) {
+	if (ld_qdi->fast) {
 		active = 8 - FIT(t.active, 1, 8);
 		recovery = 18 - FIT(t.recover, 3, 18);
 	} else {
@@ -790,9 +790,9 @@ static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	}
 	timing = (recovery << 4) | active | 0x08;
 
-	qdi->clock[adev->devno] = timing;
+	ld_qdi->clock[adev->devno] = timing;
 
-	outb(timing, qdi->timing);
+	outb(timing, ld_qdi->timing);
 }
 
 /**
@@ -808,14 +808,14 @@ static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
 static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ata_timing t;
-	struct legacy_data *qdi = ap->host->private_data;
+	struct legacy_data *ld_qdi = ap->host->private_data;
 	int active, recovery;
 	u8 timing;
 
 	/* Get the timing data in cycles */
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	if (qdi->fast) {
+	if (ld_qdi->fast) {
 		active = 8 - FIT(t.active, 1, 8);
 		recovery = 18 - FIT(t.recover, 3, 18);
 	} else {
@@ -824,12 +824,12 @@ static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	}
 	timing = (recovery << 4) | active | 0x08;
 
-	qdi->clock[adev->devno] = timing;
+	ld_qdi->clock[adev->devno] = timing;
 
-	outb(timing, qdi->timing + 2 * ap->port_no);
+	outb(timing, ld_qdi->timing + 2 * ap->port_no);
 	/* Clear the FIFO */
 	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, qdi->timing + 3);
+		outb(0x5F, ld_qdi->timing + 3);
 }
 
 /**
@@ -845,14 +845,14 @@ static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ata_timing t;
-	struct legacy_data *qdi = ap->host->private_data;
+	struct legacy_data *ld_qdi = ap->host->private_data;
 	int active, recovery;
 	u8 timing;
 
 	/* Get the timing data in cycles */
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	if (qdi->fast) {
+	if (ld_qdi->fast) {
 		active = 8 - FIT(t.active, 1, 8);
 		recovery = 18 - FIT(t.recover, 3, 18);
 	} else {
@@ -860,11 +860,11 @@ static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		recovery = 15 - FIT(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
-	qdi->clock[adev->devno] = timing;
-	outb(timing, qdi->timing + 2 * adev->devno);
+	ld_qdi->clock[adev->devno] = timing;
+	outb(timing, ld_qdi->timing + 2 * adev->devno);
 	/* Clear the FIFO */
 	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, qdi->timing + 3);
+		outb(0x5F, ld_qdi->timing + 3);
 }
 
 /**
@@ -879,12 +879,12 @@ static unsigned int qdi_qc_issue_prot(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct ata_device *adev = qc->dev;
-	struct legacy_data *qdi = ap->host->private_data;
+	struct legacy_data *ld_qdi = ap->host->private_data;
 
-	if (qdi->clock[adev->devno] != qdi->last) {
+	if (ld_qdi->clock[adev->devno] != ld_qdi->last) {
 		if (adev->pio_mode) {
-			qdi->last = qdi->clock[adev->devno];
-			outb(qdi->clock[adev->devno], qdi->timing +
+			ld_qdi->last = ld_qdi->clock[adev->devno];
+			outb(ld_qdi->clock[adev->devno], ld_qdi->timing +
 							2 * ap->port_no);
 		}
 	}
@@ -1037,12 +1037,12 @@ static u8 winbond_readcfg(unsigned long port, u8 reg)
 static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ata_timing t;
-	struct legacy_data *winbond = ap->host->private_data;
+	struct legacy_data *ld_winbond = ap->host->private_data;
 	int active, recovery;
 	u8 reg;
 	int timing = 0x88 + (ap->port_no * 4) + (adev->devno * 2);
 
-	reg = winbond_readcfg(winbond->timing, 0x81);
+	reg = winbond_readcfg(ld_winbond->timing, 0x81);
 
 	/* Get the timing data in cycles */
 	if (reg & 0x40)		/* Fast VLB bus, assume 50MHz */
@@ -1053,7 +1053,7 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
 	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
 	timing = (active << 4) | recovery;
-	winbond_writecfg(winbond->timing, timing, reg);
+	winbond_writecfg(ld_winbond->timing, timing, reg);
 
 	/* Load the setup timing */
 
@@ -1063,7 +1063,7 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	if (!ata_pio_need_iordy(adev))
 		reg |= 0x02;	/* IORDY off */
 	reg |= (FIT(t.setup, 0, 3) << 6);
-	winbond_writecfg(winbond->timing, timing + 1, reg);
+	winbond_writecfg(ld_winbond->timing, timing + 1, reg);
 }
 
 static int winbond_port(struct platform_device *dev,
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 1c1fbf3..6ebebde 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -870,7 +870,7 @@ static void mv_start_dma(struct ata_port *ap, void __iomem *port_mmio,
 		struct mv_host_priv *hpriv = ap->host->private_data;
 		int hard_port = mv_hardport_from_port(ap->port_no);
 		void __iomem *hc_mmio = mv_hc_base_from_port(
-				ap->host->iomap[MV_PRIMARY_BAR], hard_port);
+					mv_host_base(ap->host), hard_port);
 		u32 hc_irq_cause, ipending;
 
 		/* clear EDMA event indicators, if any */
@@ -2947,7 +2947,8 @@ static int mv_platform_probe(struct platform_device *pdev)
 	hpriv->n_ports = n_ports;
 
 	host->iomap = NULL;
-	hpriv->base = ioremap(res->start, res->end - res->start + 1);
+	hpriv->base = devm_ioremap(&pdev->dev, res->start,
+				   res->end - res->start + 1);
 	hpriv->base -= MV_SATAHC0_REG_BASE;
 
 	rc = mv_create_dma_pools(hpriv, &pdev->dev);
@@ -2979,11 +2980,8 @@ static int __devexit mv_platform_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ata_host *host = dev_get_drvdata(dev);
-	struct mv_host_priv *hpriv = host->private_data;
-	void __iomem *base = hpriv->base;
 
 	ata_host_detach(host);
-	iounmap(base);
 	return 0;
 }
 
@@ -3194,6 +3192,7 @@ MODULE_DESCRIPTION("SCSI low-level driver for Marvell SATA controllers");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, mv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:sata_mv");
 
 #ifdef CONFIG_PCI
 module_param(msi, int, 0444);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2e098f9..ce7603a 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1197,7 +1197,7 @@ static inline struct ata_link *ata_port_next_link(struct ata_link *link)
 		return ap->pmp_link;
 	}
 
-	if (++link - ap->pmp_link < ap->nr_pmp_links)
+	if (++link < ap->nr_pmp_links + ap->pmp_link)
 		return link;
 	return NULL;
 }
