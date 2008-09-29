Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYI2EjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYI2EjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 00:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYI2Ei7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 00:38:59 -0400
Received: from havoc.gtf.org ([69.61.125.42]:36122 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbYI2Eiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 00:38:54 -0400
Date: Mon, 29 Sep 2008 00:38:53 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata push for 2.6.28
Message-ID: <20080929043853.GA10358@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since I'm going on vacation through October 12, please hold this in
queue for when 2.6.27 is released, and the 2.6.28 merge window opens.

Nothing major...  disk shock protection support and Tejun's slave-link
work.  The more interesting stuff is actually in Jens' 2.6.28 block
tree.

Thanks!

	Jeff



Please pull from 'upstream-2.6.28' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-2.6.28

to receive the following updates:

 drivers/ata/Kconfig           |    2 +-
 drivers/ata/ahci.c            |   25 ++--
 drivers/ata/ata_piix.c        |  184 ++++++---------------
 drivers/ata/libata-core.c     |  252 ++++++++++++++++++++++++----
 drivers/ata/libata-eh.c       |  362 ++++++++++++++++++++++++++++++++++++++---
 drivers/ata/libata-scsi.c     |  108 ++++++++++++
 drivers/ata/libata.h          |    3 +
 drivers/ata/pata_bf54x.c      |   34 +++-
 drivers/ata/pata_sil680.c     |    2 +-
 drivers/ata/sata_fsl.c        |   26 ++--
 drivers/ata/sata_inic162x.c   |    8 +-
 drivers/ata/sata_mv.c         |   28 ++--
 drivers/ata/sata_nv.c         |   16 +-
 drivers/ata/sata_promise.c    |   16 +-
 drivers/ata/sata_qstor.c      |   12 +-
 drivers/ata/sata_sil.c        |   16 +-
 drivers/ata/sata_sil24.c      |   12 +-
 drivers/ata/sata_sis.c        |   28 ++--
 drivers/ata/sata_svw.c        |   10 +-
 drivers/ata/sata_uli.c        |   24 ++--
 drivers/ata/sata_via.c        |   24 ++--
 drivers/ata/sata_vsc.c        |   10 +-
 drivers/scsi/libsas/sas_ata.c |    8 +-
 include/linux/ata.h           |    9 +
 include/linux/libata.h        |   66 ++++----
 25 files changed, 923 insertions(+), 362 deletions(-)

Ben Dooks (1):
      PATA: RPC now selects HAVE_PATA_PLATFORM for pata platform driver

Elias Oltmanns (2):
      [libata] Introduce ata_id_has_unload()
      libata: Implement disk shock protection support

Herton Ronaldo Krzesinski (1):
      ata_piix: add Hercules EC-900 mini-notebook to ich_laptop short cable list

Kumar Gala (1):
      pata_sil680: convert CONFIG_PPC_MERGE to CONFIG_PPC

Richard Kennedy (1):
      libata: reorder ata_device to remove 8 bytes of padding on 64 bits

Seth Heasley (1):
      ata_piix: IDE Mode SATA patch for Intel Ibex Peak DeviceIDs

Sonic Zhang (1):
      [libata] pata_bf54x: Add proper PM operation

Tejun Heo (6):
      libata: make SCR access ops per-link
      libata: reimplement link iterator
      libata: misc updates to prepare for slave link
      libata: implement slave_link
      ata_piix: drop merged SCR access and use slave_link instead
      libata-eh: clear UNIT ATTENTION after reset

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 11c8c19..f17cd4b 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -663,7 +663,7 @@ config HAVE_PATA_PLATFORM
 
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
-	depends on EMBEDDED || ARCH_RPC || PPC || HAVE_PATA_PLATFORM
+	depends on EMBEDDED || PPC || HAVE_PATA_PLATFORM
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 2e1a7cb..aeadd00 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -267,8 +267,8 @@ struct ahci_port_priv {
 					 	 * per PM slot */
 };
 
-static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int ahci_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
@@ -316,6 +316,7 @@ static struct device_attribute *ahci_shost_attrs[] = {
 
 static struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
+	&dev_attr_unload_heads,
 	NULL
 };
 
@@ -820,10 +821,10 @@ static unsigned ahci_scr_offset(struct ata_port *ap, unsigned int sc_reg)
 	return 0;
 }
 
-static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
-	void __iomem *port_mmio = ahci_port_base(ap);
-	int offset = ahci_scr_offset(ap, sc_reg);
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	int offset = ahci_scr_offset(link->ap, sc_reg);
 
 	if (offset) {
 		*val = readl(port_mmio + offset);
@@ -832,10 +833,10 @@ static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return -EINVAL;
 }
 
-static int ahci_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
-	void __iomem *port_mmio = ahci_port_base(ap);
-	int offset = ahci_scr_offset(ap, sc_reg);
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	int offset = ahci_scr_offset(link->ap, sc_reg);
 
 	if (offset) {
 		writel(val, port_mmio + offset);
@@ -973,7 +974,7 @@ static void ahci_disable_alpm(struct ata_port *ap)
 	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
 
 	/* go ahead and clean out PhyRdy Change from Serror too */
-	ahci_scr_write(ap, SCR_ERROR, ((1 << 16) | (1 << 18)));
+	ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
 
 	/*
  	 * Clear flag to indicate that we should ignore all PhyRdy
@@ -1937,8 +1938,8 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	ata_ehi_push_desc(host_ehi, "irq_stat 0x%08x", irq_stat);
 
 	/* AHCI needs SError cleared; otherwise, it might lock up */
-	ahci_scr_read(ap, SCR_ERROR, &serror);
-	ahci_scr_write(ap, SCR_ERROR, serror);
+	ahci_scr_read(&ap->link, SCR_ERROR, &serror);
+	ahci_scr_write(&ap->link, SCR_ERROR, serror);
 	host_ehi->serror |= serror;
 
 	/* some controllers set IRQ_IF_ERR on device errors, ignore it */
@@ -2027,7 +2028,7 @@ static void ahci_port_intr(struct ata_port *ap)
 	if ((hpriv->flags & AHCI_HFLAG_NO_HOTPLUG) &&
 		(status & PORT_IRQ_PHYRDY)) {
 		status &= ~PORT_IRQ_PHYRDY;
-		ahci_scr_write(ap, SCR_ERROR, ((1 << 16) | (1 << 18)));
+		ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
 	}
 
 	if (unlikely(status & PORT_IRQ_ERROR)) {
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index e6b4606..e9e32ed 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -165,8 +165,10 @@ static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static int ich_pata_cable_detect(struct ata_port *ap);
 static u8 piix_vmw_bmdma_status(struct ata_port *ap);
-static int piix_sidpr_scr_read(struct ata_port *ap, unsigned int reg, u32 *val);
-static int piix_sidpr_scr_write(struct ata_port *ap, unsigned int reg, u32 val);
+static int piix_sidpr_scr_read(struct ata_link *link,
+			       unsigned int reg, u32 *val);
+static int piix_sidpr_scr_write(struct ata_link *link,
+				unsigned int reg, u32 val);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int piix_pci_device_resume(struct pci_dev *pdev);
@@ -278,12 +280,15 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b28, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
-
 	{ }	/* terminate list */
 };
 
@@ -582,6 +587,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
+	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
 	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
 	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
@@ -885,23 +891,9 @@ static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev)
  * Serial ATA Index/Data Pair Superset Registers access
  *
  * Beginning from ICH8, there's a sane way to access SCRs using index
- * and data register pair located at BAR5.  This creates an
- * interesting problem of mapping two SCRs to one port.
- *
- * Although they have separate SCRs, the master and slave aren't
- * independent enough to be treated as separate links - e.g. softreset
- * resets both.  Also, there's no protocol defined for hard resetting
- * singled device sharing the virtual port (no defined way to acquire
- * device signature).  This is worked around by merging the SCR values
- * into one sensible value and requesting follow-up SRST after
- * hardreset.
- *
- * SCR merging is perfomed in nibbles which is the unit contents in
- * SCRs are organized.  If two values are equal, the value is used.
- * When they differ, merge table which lists precedence of possible
- * values is consulted and the first match or the last entry when
- * nothing matches is used.  When there's no merge table for the
- * specific nibble, value from the first port is used.
+ * and data register pair located at BAR5 which means that we have
+ * separate SCRs for master and slave.  This is handled using libata
+ * slave_link facility.
  */
 static const int piix_sidx_map[] = {
 	[SCR_STATUS]	= 0,
@@ -909,120 +901,38 @@ static const int piix_sidx_map[] = {
 	[SCR_CONTROL]	= 1,
 };
 
-static void piix_sidpr_sel(struct ata_device *dev, unsigned int reg)
+static void piix_sidpr_sel(struct ata_link *link, unsigned int reg)
 {
-	struct ata_port *ap = dev->link->ap;
+	struct ata_port *ap = link->ap;
 	struct piix_host_priv *hpriv = ap->host->private_data;
 
-	iowrite32(((ap->port_no * 2 + dev->devno) << 8) | piix_sidx_map[reg],
+	iowrite32(((ap->port_no * 2 + link->pmp) << 8) | piix_sidx_map[reg],
 		  hpriv->sidpr + PIIX_SIDPR_IDX);
 }
 
-static int piix_sidpr_read(struct ata_device *dev, unsigned int reg)
-{
-	struct piix_host_priv *hpriv = dev->link->ap->host->private_data;
-
-	piix_sidpr_sel(dev, reg);
-	return ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
-}
-
-static void piix_sidpr_write(struct ata_device *dev, unsigned int reg, u32 val)
-{
-	struct piix_host_priv *hpriv = dev->link->ap->host->private_data;
-
-	piix_sidpr_sel(dev, reg);
-	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
-}
-
-static u32 piix_merge_scr(u32 val0, u32 val1, const int * const *merge_tbl)
-{
-	u32 val = 0;
-	int i, mi;
-
-	for (i = 0, mi = 0; i < 32 / 4; i++) {
-		u8 c0 = (val0 >> (i * 4)) & 0xf;
-		u8 c1 = (val1 >> (i * 4)) & 0xf;
-		u8 merged = c0;
-		const int *cur;
-
-		/* if no merge preference, assume the first value */
-		cur = merge_tbl[mi];
-		if (!cur)
-			goto done;
-		mi++;
-
-		/* if two values equal, use it */
-		if (c0 == c1)
-			goto done;
-
-		/* choose the first match or the last from the merge table */
-		while (*cur != -1) {
-			if (c0 == *cur || c1 == *cur)
-				break;
-			cur++;
-		}
-		if (*cur == -1)
-			cur--;
-		merged = *cur;
-	done:
-		val |= merged << (i * 4);
-	}
-
-	return val;
-}
-
-static int piix_sidpr_scr_read(struct ata_port *ap, unsigned int reg, u32 *val)
+static int piix_sidpr_scr_read(struct ata_link *link,
+			       unsigned int reg, u32 *val)
 {
-	const int * const sstatus_merge_tbl[] = {
-		/* DET */ (const int []){ 1, 3, 0, 4, 3, -1 },
-		/* SPD */ (const int []){ 2, 1, 0, -1 },
-		/* IPM */ (const int []){ 6, 2, 1, 0, -1 },
-		NULL,
-	};
-	const int * const scontrol_merge_tbl[] = {
-		/* DET */ (const int []){ 1, 0, 4, 0, -1 },
-		/* SPD */ (const int []){ 0, 2, 1, 0, -1 },
-		/* IPM */ (const int []){ 0, 1, 2, 3, 0, -1 },
-		NULL,
-	};
-	u32 v0, v1;
+	struct piix_host_priv *hpriv = link->ap->host->private_data;
 
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
-	if (!(ap->flags & ATA_FLAG_SLAVE_POSS)) {
-		*val = piix_sidpr_read(&ap->link.device[0], reg);
-		return 0;
-	}
-
-	v0 = piix_sidpr_read(&ap->link.device[0], reg);
-	v1 = piix_sidpr_read(&ap->link.device[1], reg);
-
-	switch (reg) {
-	case SCR_STATUS:
-		*val = piix_merge_scr(v0, v1, sstatus_merge_tbl);
-		break;
-	case SCR_ERROR:
-		*val = v0 | v1;
-		break;
-	case SCR_CONTROL:
-		*val = piix_merge_scr(v0, v1, scontrol_merge_tbl);
-		break;
-	}
-
+	piix_sidpr_sel(link, reg);
+	*val = ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
 	return 0;
 }
 
-static int piix_sidpr_scr_write(struct ata_port *ap, unsigned int reg, u32 val)
+static int piix_sidpr_scr_write(struct ata_link *link,
+				unsigned int reg, u32 val)
 {
+	struct piix_host_priv *hpriv = link->ap->host->private_data;
+
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
-	piix_sidpr_write(&ap->link.device[0], reg, val);
-
-	if (ap->flags & ATA_FLAG_SLAVE_POSS)
-		piix_sidpr_write(&ap->link.device[1], reg, val);
-
+	piix_sidpr_sel(link, reg);
+	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
 	return 0;
 }
 
@@ -1363,28 +1273,28 @@ static const int *__devinit piix_init_sata_map(struct pci_dev *pdev,
 	return map;
 }
 
-static void __devinit piix_init_sidpr(struct ata_host *host)
+static int __devinit piix_init_sidpr(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct piix_host_priv *hpriv = host->private_data;
-	struct ata_device *dev0 = &host->ports[0]->link.device[0];
+	struct ata_link *link0 = &host->ports[0]->link;
 	u32 scontrol;
-	int i;
+	int i, rc;
 
 	/* check for availability */
 	for (i = 0; i < 4; i++)
 		if (hpriv->map[i] == IDE)
-			return;
+			return 0;
 
 	if (!(host->ports[0]->flags & PIIX_FLAG_SIDPR))
-		return;
+		return 0;
 
 	if (pci_resource_start(pdev, PIIX_SIDPR_BAR) == 0 ||
 	    pci_resource_len(pdev, PIIX_SIDPR_BAR) != PIIX_SIDPR_LEN)
-		return;
+		return 0;
 
 	if (pcim_iomap_regions(pdev, 1 << PIIX_SIDPR_BAR, DRV_NAME))
-		return;
+		return 0;
 
 	hpriv->sidpr = pcim_iomap_table(pdev)[PIIX_SIDPR_BAR];
 
@@ -1392,7 +1302,7 @@ static void __devinit piix_init_sidpr(struct ata_host *host)
 	 * Give it a test drive by inhibiting power save modes which
 	 * we'll do anyway.
 	 */
-	scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
+	piix_sidpr_scr_read(link0, SCR_CONTROL, &scontrol);
 
 	/* if IPM is already 3, SCR access is probably working.  Don't
 	 * un-inhibit power save modes as BIOS might have inhibited
@@ -1400,18 +1310,30 @@ static void __devinit piix_init_sidpr(struct ata_host *host)
 	 */
 	if ((scontrol & 0xf00) != 0x300) {
 		scontrol |= 0x300;
-		piix_sidpr_write(dev0, SCR_CONTROL, scontrol);
-		scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
+		piix_sidpr_scr_write(link0, SCR_CONTROL, scontrol);
+		piix_sidpr_scr_read(link0, SCR_CONTROL, &scontrol);
 
 		if ((scontrol & 0xf00) != 0x300) {
 			dev_printk(KERN_INFO, host->dev, "SCR access via "
 				   "SIDPR is available but doesn't work\n");
-			return;
+			return 0;
 		}
 	}
 
-	host->ports[0]->ops = &piix_sidpr_sata_ops;
-	host->ports[1]->ops = &piix_sidpr_sata_ops;
+	/* okay, SCRs available, set ops and ask libata for slave_link */
+	for (i = 0; i < 2; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		ap->ops = &piix_sidpr_sata_ops;
+
+		if (ap->flags & ATA_FLAG_SLAVE_POSS) {
+			rc = ata_slave_link_init(ap);
+			if (rc)
+				return rc;
+		}
+	}
+
+	return 0;
 }
 
 static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
@@ -1521,7 +1443,9 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	/* initialize controller */
 	if (port_flags & ATA_FLAG_SATA) {
 		piix_init_pcs(host, piix_map_db_table[ent->driver_data]);
-		piix_init_sidpr(host);
+		rc = piix_init_sidpr(host);
+		if (rc)
+			return rc;
 	}
 
 	/* apply IOCFG bit18 quirk */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 79e3a8e..1ee9499 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -163,6 +163,67 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 
+/*
+ * Iterator helpers.  Don't use directly.
+ *
+ * LOCKING:
+ * Host lock or EH context.
+ */
+struct ata_link *__ata_port_next_link(struct ata_port *ap,
+				      struct ata_link *link, bool dev_only)
+{
+	/* NULL link indicates start of iteration */
+	if (!link) {
+		if (dev_only && sata_pmp_attached(ap))
+			return ap->pmp_link;
+		return &ap->link;
+	}
+
+	/* we just iterated over the host master link, what's next? */
+	if (link == &ap->link) {
+		if (!sata_pmp_attached(ap)) {
+			if (unlikely(ap->slave_link) && !dev_only)
+				return ap->slave_link;
+			return NULL;
+		}
+		return ap->pmp_link;
+	}
+
+	/* slave_link excludes PMP */
+	if (unlikely(link == ap->slave_link))
+		return NULL;
+
+	/* iterate to the next PMP link */
+	if (++link < ap->pmp_link + ap->nr_pmp_links)
+		return link;
+	return NULL;
+}
+
+/**
+ *	ata_dev_phys_link - find physical link for a device
+ *	@dev: ATA device to look up physical link for
+ *
+ *	Look up physical link which @dev is attached to.  Note that
+ *	this is different from @dev->link only when @dev is on slave
+ *	link.  For all other cases, it's the same as @dev->link.
+ *
+ *	LOCKING:
+ *	Don't care.
+ *
+ *	RETURNS:
+ *	Pointer to the found physical link.
+ */
+struct ata_link *ata_dev_phys_link(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+
+	if (!ap->slave_link)
+		return dev->link;
+	if (!dev->devno)
+		return &ap->link;
+	return ap->slave_link;
+}
+
 /**
  *	ata_force_cbl - force cable type according to libata.force
  *	@ap: ATA port of interest
@@ -206,7 +267,8 @@ void ata_force_cbl(struct ata_port *ap)
  *	the host link and all fan-out ports connected via PMP.  If the
  *	device part is specified as 0 (e.g. 1.00:), it specifies the
  *	first fan-out link not the host link.  Device number 15 always
- *	points to the host link whether PMP is attached or not.
+ *	points to the host link whether PMP is attached or not.  If the
+ *	controller has slave link, device number 16 points to it.
  *
  *	LOCKING:
  *	EH context.
@@ -214,12 +276,11 @@ void ata_force_cbl(struct ata_port *ap)
 static void ata_force_link_limits(struct ata_link *link)
 {
 	bool did_spd = false;
-	int linkno, i;
+	int linkno = link->pmp;
+	int i;
 
 	if (ata_is_host_link(link))
-		linkno = 15;
-	else
-		linkno = link->pmp;
+		linkno += 15;
 
 	for (i = ata_force_tbl_size - 1; i >= 0; i--) {
 		const struct ata_force_ent *fe = &ata_force_tbl[i];
@@ -266,9 +327,9 @@ static void ata_force_xfermask(struct ata_device *dev)
 	int alt_devno = devno;
 	int i;
 
-	/* allow n.15 for the first device attached to host port */
-	if (ata_is_host_link(dev->link) && devno == 0)
-		alt_devno = 15;
+	/* allow n.15/16 for devices attached to host port */
+	if (ata_is_host_link(dev->link))
+		alt_devno += 15;
 
 	for (i = ata_force_tbl_size - 1; i >= 0; i--) {
 		const struct ata_force_ent *fe = &ata_force_tbl[i];
@@ -320,9 +381,9 @@ static void ata_force_horkage(struct ata_device *dev)
 	int alt_devno = devno;
 	int i;
 
-	/* allow n.15 for the first device attached to host port */
-	if (ata_is_host_link(dev->link) && devno == 0)
-		alt_devno = 15;
+	/* allow n.15/16 for devices attached to host port */
+	if (ata_is_host_link(dev->link))
+		alt_devno += 15;
 
 	for (i = 0; i < ata_force_tbl_size; i++) {
 		const struct ata_force_ent *fe = &ata_force_tbl[i];
@@ -2681,7 +2742,7 @@ static void sata_print_link_status(struct ata_link *link)
 		return;
 	sata_scr_read(link, SCR_CONTROL, &scontrol);
 
-	if (ata_link_online(link)) {
+	if (ata_phys_link_online(link)) {
 		tmp = (sstatus >> 4) & 0xf;
 		ata_link_printk(link, KERN_INFO,
 				"SATA link up %s (SStatus %X SControl %X)\n",
@@ -3372,6 +3433,12 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 	unsigned long nodev_deadline = ata_deadline(start, ATA_TMOUT_FF_WAIT);
 	int warned = 0;
 
+	/* Slave readiness can't be tested separately from master.  On
+	 * M/S emulation configuration, this function should be called
+	 * only on the master and it will handle both master and slave.
+	 */
+	WARN_ON(link == link->ap->slave_link);
+
 	if (time_after(nodev_deadline, deadline))
 		nodev_deadline = deadline;
 
@@ -3593,7 +3660,7 @@ int ata_std_prereset(struct ata_link *link, unsigned long deadline)
 	}
 
 	/* no point in trying softreset on offline link */
-	if (ata_link_offline(link))
+	if (ata_phys_link_offline(link))
 		ehc->i.action &= ~ATA_EH_SOFTRESET;
 
 	return 0;
@@ -3671,7 +3738,7 @@ int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
 	if (rc)
 		goto out;
 	/* if link is offline nothing more to do */
-	if (ata_link_offline(link))
+	if (ata_phys_link_offline(link))
 		goto out;
 
 	/* Link is online.  From this point, -ENODEV too is an error. */
@@ -4868,10 +4935,8 @@ int sata_scr_valid(struct ata_link *link)
 int sata_scr_read(struct ata_link *link, int reg, u32 *val)
 {
 	if (ata_is_host_link(link)) {
-		struct ata_port *ap = link->ap;
-
 		if (sata_scr_valid(link))
-			return ap->ops->scr_read(ap, reg, val);
+			return link->ap->ops->scr_read(link, reg, val);
 		return -EOPNOTSUPP;
 	}
 
@@ -4897,10 +4962,8 @@ int sata_scr_read(struct ata_link *link, int reg, u32 *val)
 int sata_scr_write(struct ata_link *link, int reg, u32 val)
 {
 	if (ata_is_host_link(link)) {
-		struct ata_port *ap = link->ap;
-
 		if (sata_scr_valid(link))
-			return ap->ops->scr_write(ap, reg, val);
+			return link->ap->ops->scr_write(link, reg, val);
 		return -EOPNOTSUPP;
 	}
 
@@ -4925,13 +4988,12 @@ int sata_scr_write(struct ata_link *link, int reg, u32 val)
 int sata_scr_write_flush(struct ata_link *link, int reg, u32 val)
 {
 	if (ata_is_host_link(link)) {
-		struct ata_port *ap = link->ap;
 		int rc;
 
 		if (sata_scr_valid(link)) {
-			rc = ap->ops->scr_write(ap, reg, val);
+			rc = link->ap->ops->scr_write(link, reg, val);
 			if (rc == 0)
-				rc = ap->ops->scr_read(ap, reg, &val);
+				rc = link->ap->ops->scr_read(link, reg, &val);
 			return rc;
 		}
 		return -EOPNOTSUPP;
@@ -4941,7 +5003,7 @@ int sata_scr_write_flush(struct ata_link *link, int reg, u32 val)
 }
 
 /**
- *	ata_link_online - test whether the given link is online
+ *	ata_phys_link_online - test whether the given link is online
  *	@link: ATA link to test
  *
  *	Test whether @link is online.  Note that this function returns
@@ -4952,20 +5014,20 @@ int sata_scr_write_flush(struct ata_link *link, int reg, u32 val)
  *	None.
  *
  *	RETURNS:
- *	1 if the port online status is available and online.
+ *	True if the port online status is available and online.
  */
-int ata_link_online(struct ata_link *link)
+bool ata_phys_link_online(struct ata_link *link)
 {
 	u32 sstatus;
 
 	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
 	    (sstatus & 0xf) == 0x3)
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
 /**
- *	ata_link_offline - test whether the given link is offline
+ *	ata_phys_link_offline - test whether the given link is offline
  *	@link: ATA link to test
  *
  *	Test whether @link is offline.  Note that this function
@@ -4976,16 +5038,68 @@ int ata_link_online(struct ata_link *link)
  *	None.
  *
  *	RETURNS:
- *	1 if the port offline status is available and offline.
+ *	True if the port offline status is available and offline.
  */
-int ata_link_offline(struct ata_link *link)
+bool ata_phys_link_offline(struct ata_link *link)
 {
 	u32 sstatus;
 
 	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
 	    (sstatus & 0xf) != 0x3)
-		return 1;
-	return 0;
+		return true;
+	return false;
+}
+
+/**
+ *	ata_link_online - test whether the given link is online
+ *	@link: ATA link to test
+ *
+ *	Test whether @link is online.  This is identical to
+ *	ata_phys_link_online() when there's no slave link.  When
+ *	there's a slave link, this function should only be called on
+ *	the master link and will return true if any of M/S links is
+ *	online.
+ *
+ *	LOCKING:
+ *	None.
+ *
+ *	RETURNS:
+ *	True if the port online status is available and online.
+ */
+bool ata_link_online(struct ata_link *link)
+{
+	struct ata_link *slave = link->ap->slave_link;
+
+	WARN_ON(link == slave);	/* shouldn't be called on slave link */
+
+	return ata_phys_link_online(link) ||
+		(slave && ata_phys_link_online(slave));
+}
+
+/**
+ *	ata_link_offline - test whether the given link is offline
+ *	@link: ATA link to test
+ *
+ *	Test whether @link is offline.  This is identical to
+ *	ata_phys_link_offline() when there's no slave link.  When
+ *	there's a slave link, this function should only be called on
+ *	the master link and will return true if both M/S links are
+ *	offline.
+ *
+ *	LOCKING:
+ *	None.
+ *
+ *	RETURNS:
+ *	True if the port offline status is available and offline.
+ */
+bool ata_link_offline(struct ata_link *link)
+{
+	struct ata_link *slave = link->ap->slave_link;
+
+	WARN_ON(link == slave);	/* shouldn't be called on slave link */
+
+	return ata_phys_link_offline(link) &&
+		(!slave || ata_phys_link_offline(slave));
 }
 
 #ifdef CONFIG_PM
@@ -5127,11 +5241,11 @@ int ata_port_start(struct ata_port *ap)
  */
 void ata_dev_init(struct ata_device *dev)
 {
-	struct ata_link *link = dev->link;
+	struct ata_link *link = ata_dev_phys_link(dev);
 	struct ata_port *ap = link->ap;
 	unsigned long flags;
 
-	/* SATA spd limit is bound to the first device */
+	/* SATA spd limit is bound to the attached device, reset together */
 	link->sata_spd_limit = link->hw_sata_spd_limit;
 	link->sata_spd = 0;
 
@@ -5264,6 +5378,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
 	INIT_LIST_HEAD(&ap->eh_done_q);
 	init_waitqueue_head(&ap->eh_wait_q);
+	init_completion(&ap->park_req_pending);
 	init_timer_deferrable(&ap->fastdrain_timer);
 	ap->fastdrain_timer.function = ata_eh_fastdrain_timerfn;
 	ap->fastdrain_timer.data = (unsigned long)ap;
@@ -5294,6 +5409,7 @@ static void ata_host_release(struct device *gendev, void *res)
 			scsi_host_put(ap->scsi_host);
 
 		kfree(ap->pmp_link);
+		kfree(ap->slave_link);
 		kfree(ap);
 		host->ports[i] = NULL;
 	}
@@ -5414,6 +5530,68 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 	return host;
 }
 
+/**
+ *	ata_slave_link_init - initialize slave link
+ *	@ap: port to initialize slave link for
+ *
+ *	Create and initialize slave link for @ap.  This enables slave
+ *	link handling on the port.
+ *
+ *	In libata, a port contains links and a link contains devices.
+ *	There is single host link but if a PMP is attached to it,
+ *	there can be multiple fan-out links.  On SATA, there's usually
+ *	a single device connected to a link but PATA and SATA
+ *	controllers emulating TF based interface can have two - master
+ *	and slave.
+ *
+ *	However, there are a few controllers which don't fit into this
+ *	abstraction too well - SATA controllers which emulate TF
+ *	interface with both master and slave devices but also have
+ *	separate SCR register sets for each device.  These controllers
+ *	need separate links for physical link handling
+ *	(e.g. onlineness, link speed) but should be treated like a
+ *	traditional M/S controller for everything else (e.g. command
+ *	issue, softreset).
+ *
+ *	slave_link is libata's way of handling this class of
+ *	controllers without impacting core layer too much.  For
+ *	anything other than physical link handling, the default host
+ *	link is used for both master and slave.  For physical link
+ *	handling, separate @ap->slave_link is used.  All dirty details
+ *	are implemented inside libata core layer.  From LLD's POV, the
+ *	only difference is that prereset, hardreset and postreset are
+ *	called once more for the slave link, so the reset sequence
+ *	looks like the following.
+ *
+ *	prereset(M) -> prereset(S) -> hardreset(M) -> hardreset(S) ->
+ *	softreset(M) -> postreset(M) -> postreset(S)
+ *
+ *	Note that softreset is called only for the master.  Softreset
+ *	resets both M/S by definition, so SRST on master should handle
+ *	both (the standard method will work just fine).
+ *
+ *	LOCKING:
+ *	Should be called before host is registered.
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+int ata_slave_link_init(struct ata_port *ap)
+{
+	struct ata_link *link;
+
+	WARN_ON(ap->slave_link);
+	WARN_ON(ap->flags & ATA_FLAG_PMP);
+
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (!link)
+		return -ENOMEM;
+
+	ata_link_init(ap, link, 1);
+	ap->slave_link = link;
+	return 0;
+}
+
 static void ata_host_stop(struct device *gendev, void *res)
 {
 	struct ata_host *host = dev_get_drvdata(gendev);
@@ -5640,6 +5818,8 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 		/* init sata_spd_limit to the current value */
 		sata_link_init_spd(&ap->link);
+		if (ap->slave_link)
+			sata_link_init_spd(ap->slave_link);
 
 		/* print per-port info to dmesg */
 		xfer_mask = ata_pack_xfermask(ap->pio_mask, ap->mwdma_mask,
@@ -6260,10 +6440,12 @@ EXPORT_SYMBOL_GPL(ata_base_port_ops);
 EXPORT_SYMBOL_GPL(sata_port_ops);
 EXPORT_SYMBOL_GPL(ata_dummy_port_ops);
 EXPORT_SYMBOL_GPL(ata_dummy_port_info);
+EXPORT_SYMBOL_GPL(__ata_port_next_link);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
 EXPORT_SYMBOL_GPL(ata_host_init);
 EXPORT_SYMBOL_GPL(ata_host_alloc);
 EXPORT_SYMBOL_GPL(ata_host_alloc_pinfo);
+EXPORT_SYMBOL_GPL(ata_slave_link_init);
 EXPORT_SYMBOL_GPL(ata_host_start);
 EXPORT_SYMBOL_GPL(ata_host_register);
 EXPORT_SYMBOL_GPL(ata_host_activate);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c1db2f2..f2dd991 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -79,6 +79,8 @@ enum {
 	 */
 	ATA_EH_PRERESET_TIMEOUT		= 10000,
 	ATA_EH_FASTDRAIN_INTERVAL	=  3000,
+
+	ATA_EH_UA_TRIES			= 5,
 };
 
 /* The following table determines how we sequence resets.  Each entry
@@ -1357,6 +1359,37 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 }
 
 /**
+ *	atapi_eh_tur - perform ATAPI TEST_UNIT_READY
+ *	@dev: target ATAPI device
+ *	@r_sense_key: out parameter for sense_key
+ *
+ *	Perform ATAPI TEST_UNIT_READY.
+ *
+ *	LOCKING:
+ *	EH context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, AC_ERR_* mask on failure.
+ */
+static unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
+{
+	u8 cdb[ATAPI_CDB_LEN] = { TEST_UNIT_READY, 0, 0, 0, 0, 0 };
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	ata_tf_init(dev, &tf);
+
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.command = ATA_CMD_PACKET;
+	tf.protocol = ATAPI_PROT_NODATA;
+
+	err_mask = ata_exec_internal(dev, &tf, cdb, DMA_NONE, NULL, 0, 0);
+	if (err_mask == AC_ERR_DEV)
+		*r_sense_key = tf.feature >> 4;
+	return err_mask;
+}
+
+/**
  *	atapi_eh_request_sense - perform ATAPI REQUEST_SENSE
  *	@dev: device to perform REQUEST_SENSE to
  *	@sense_buf: result sense data buffer (SCSI_SENSE_BUFFERSIZE bytes long)
@@ -1756,7 +1789,7 @@ static unsigned int ata_eh_speed_down_verdict(struct ata_device *dev)
 static unsigned int ata_eh_speed_down(struct ata_device *dev,
 				unsigned int eflags, unsigned int err_mask)
 {
-	struct ata_link *link = dev->link;
+	struct ata_link *link = ata_dev_phys_link(dev);
 	int xfer_ok = 0;
 	unsigned int verdict;
 	unsigned int action = 0;
@@ -1880,7 +1913,8 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 
-		if (!(qc->flags & ATA_QCFLAG_FAILED) || qc->dev->link != link)
+		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
+		    ata_dev_phys_link(qc->dev) != link)
 			continue;
 
 		/* inherit upper level err_mask */
@@ -1967,6 +2001,23 @@ void ata_eh_autopsy(struct ata_port *ap)
 	ata_port_for_each_link(link, ap)
 		ata_eh_link_autopsy(link);
 
+	/* Handle the frigging slave link.  Autopsy is done similarly
+	 * but actions and flags are transferred over to the master
+	 * link and handled from there.
+	 */
+	if (ap->slave_link) {
+		struct ata_eh_context *mehc = &ap->link.eh_context;
+		struct ata_eh_context *sehc = &ap->slave_link->eh_context;
+
+		ata_eh_link_autopsy(ap->slave_link);
+
+		ata_eh_about_to_do(ap->slave_link, NULL, ATA_EH_ALL_ACTIONS);
+		mehc->i.action		|= sehc->i.action;
+		mehc->i.dev_action[1]	|= sehc->i.dev_action[1];
+		mehc->i.flags		|= sehc->i.flags;
+		ata_eh_done(ap->slave_link, NULL, ATA_EH_ALL_ACTIONS);
+	}
+
 	/* Autopsy of fanout ports can affect host link autopsy.
 	 * Perform host link autopsy last.
 	 */
@@ -2001,7 +2052,8 @@ static void ata_eh_link_report(struct ata_link *link)
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 
-		if (!(qc->flags & ATA_QCFLAG_FAILED) || qc->dev->link != link ||
+		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
+		    ata_dev_phys_link(qc->dev) != link ||
 		    ((qc->flags & ATA_QCFLAG_QUIET) &&
 		     qc->err_mask == AC_ERR_DEV))
 			continue;
@@ -2068,7 +2120,7 @@ static void ata_eh_link_report(struct ata_link *link)
 		char cdb_buf[70] = "";
 
 		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
-		    qc->dev->link != link || !qc->err_mask)
+		    ata_dev_phys_link(qc->dev) != link || !qc->err_mask)
 			continue;
 
 		if (qc->dma_dir != DMA_NONE) {
@@ -2160,12 +2212,14 @@ void ata_eh_report(struct ata_port *ap)
 }
 
 static int ata_do_reset(struct ata_link *link, ata_reset_fn_t reset,
-			unsigned int *classes, unsigned long deadline)
+			unsigned int *classes, unsigned long deadline,
+			bool clear_classes)
 {
 	struct ata_device *dev;
 
-	ata_link_for_each_dev(dev, link)
-		classes[dev->devno] = ATA_DEV_UNKNOWN;
+	if (clear_classes)
+		ata_link_for_each_dev(dev, link)
+			classes[dev->devno] = ATA_DEV_UNKNOWN;
 
 	return reset(link, classes, deadline);
 }
@@ -2187,17 +2241,20 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		 ata_reset_fn_t hardreset, ata_postreset_fn_t postreset)
 {
 	struct ata_port *ap = link->ap;
+	struct ata_link *slave = ap->slave_link;
 	struct ata_eh_context *ehc = &link->eh_context;
+	struct ata_eh_context *sehc = &slave->eh_context;
 	unsigned int *classes = ehc->classes;
 	unsigned int lflags = link->flags;
 	int verbose = !(ehc->i.flags & ATA_EHI_QUIET);
 	int max_tries = 0, try = 0;
+	struct ata_link *failed_link;
 	struct ata_device *dev;
 	unsigned long deadline, now;
 	ata_reset_fn_t reset;
 	unsigned long flags;
 	u32 sstatus;
-	int nr_known, rc;
+	int nr_unknown, rc;
 
 	/*
 	 * Prepare to reset
@@ -2252,8 +2309,30 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	}
 
 	if (prereset) {
-		rc = prereset(link,
-			      ata_deadline(jiffies, ATA_EH_PRERESET_TIMEOUT));
+		unsigned long deadline = ata_deadline(jiffies,
+						      ATA_EH_PRERESET_TIMEOUT);
+
+		if (slave) {
+			sehc->i.action &= ~ATA_EH_RESET;
+			sehc->i.action |= ehc->i.action;
+		}
+
+		rc = prereset(link, deadline);
+
+		/* If present, do prereset on slave link too.  Reset
+		 * is skipped iff both master and slave links report
+		 * -ENOENT or clear ATA_EH_RESET.
+		 */
+		if (slave && (rc == 0 || rc == -ENOENT)) {
+			int tmp;
+
+			tmp = prereset(slave, deadline);
+			if (tmp != -ENOENT)
+				rc = tmp;
+
+			ehc->i.action |= sehc->i.action;
+		}
+
 		if (rc) {
 			if (rc == -ENOENT) {
 				ata_link_printk(link, KERN_DEBUG,
@@ -2302,25 +2381,51 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		else
 			ehc->i.flags |= ATA_EHI_DID_SOFTRESET;
 
-		rc = ata_do_reset(link, reset, classes, deadline);
-		if (rc && rc != -EAGAIN)
+		rc = ata_do_reset(link, reset, classes, deadline, true);
+		if (rc && rc != -EAGAIN) {
+			failed_link = link;
 			goto fail;
+		}
+
+		/* hardreset slave link if existent */
+		if (slave && reset == hardreset) {
+			int tmp;
+
+			if (verbose)
+				ata_link_printk(slave, KERN_INFO,
+						"hard resetting link\n");
 
+			ata_eh_about_to_do(slave, NULL, ATA_EH_RESET);
+			tmp = ata_do_reset(slave, reset, classes, deadline,
+					   false);
+			switch (tmp) {
+			case -EAGAIN:
+				rc = -EAGAIN;
+			case 0:
+				break;
+			default:
+				failed_link = slave;
+				rc = tmp;
+				goto fail;
+			}
+		}
+
+		/* perform follow-up SRST if necessary */
 		if (reset == hardreset &&
 		    ata_eh_followup_srst_needed(link, rc, classes)) {
-			/* okay, let's do follow-up softreset */
 			reset = softreset;
 
 			if (!reset) {
 				ata_link_printk(link, KERN_ERR,
 						"follow-up softreset required "
 						"but no softreset avaliable\n");
+				failed_link = link;
 				rc = -EINVAL;
 				goto fail;
 			}
 
 			ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
-			rc = ata_do_reset(link, reset, classes, deadline);
+			rc = ata_do_reset(link, reset, classes, deadline, true);
 		}
 	} else {
 		if (verbose)
@@ -2341,7 +2446,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		dev->pio_mode = XFER_PIO_0;
 		dev->flags &= ~ATA_DFLAG_SLEEPING;
 
-		if (ata_link_offline(link))
+		if (ata_phys_link_offline(ata_dev_phys_link(dev)))
 			continue;
 
 		/* apply class override */
@@ -2354,6 +2459,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	/* record current link speed */
 	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0)
 		link->sata_spd = (sstatus >> 4) & 0xf;
+	if (slave && sata_scr_read(slave, SCR_STATUS, &sstatus) == 0)
+		slave->sata_spd = (sstatus >> 4) & 0xf;
 
 	/* thaw the port */
 	if (ata_is_host_link(link))
@@ -2366,12 +2473,17 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	 * reset and here.  This race is mediated by cross checking
 	 * link onlineness and classification result later.
 	 */
-	if (postreset)
+	if (postreset) {
 		postreset(link, classes);
+		if (slave)
+			postreset(slave, classes);
+	}
 
 	/* clear cached SError */
 	spin_lock_irqsave(link->ap->lock, flags);
 	link->eh_info.serror = 0;
+	if (slave)
+		slave->eh_info.serror = 0;
 	spin_unlock_irqrestore(link->ap->lock, flags);
 
 	/* Make sure onlineness and classification result correspond.
@@ -2381,19 +2493,21 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	 * link onlineness and classification result, those conditions
 	 * can be reliably detected and retried.
 	 */
-	nr_known = 0;
+	nr_unknown = 0;
 	ata_link_for_each_dev(dev, link) {
 		/* convert all ATA_DEV_UNKNOWN to ATA_DEV_NONE */
-		if (classes[dev->devno] == ATA_DEV_UNKNOWN)
+		if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
 			classes[dev->devno] = ATA_DEV_NONE;
-		else
-			nr_known++;
+			if (ata_phys_link_online(ata_dev_phys_link(dev)))
+				nr_unknown++;
+		}
 	}
 
-	if (classify && !nr_known && ata_link_online(link)) {
+	if (classify && nr_unknown) {
 		if (try < max_tries) {
 			ata_link_printk(link, KERN_WARNING, "link online but "
 				       "device misclassified, retrying\n");
+			failed_link = link;
 			rc = -EAGAIN;
 			goto fail;
 		}
@@ -2404,6 +2518,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 	/* reset successful, schedule revalidation */
 	ata_eh_done(link, NULL, ATA_EH_RESET);
+	if (slave)
+		ata_eh_done(slave, NULL, ATA_EH_RESET);
 	ehc->last_reset = jiffies;
 	ehc->i.action |= ATA_EH_REVALIDATE;
 
@@ -2411,6 +2527,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
  out:
 	/* clear hotplug flag */
 	ehc->i.flags &= ~ATA_EHI_HOTPLUGGED;
+	if (slave)
+		sehc->i.flags &= ~ATA_EHI_HOTPLUGGED;
 
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags &= ~ATA_PFLAG_RESETTING;
@@ -2431,7 +2549,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	if (time_before(now, deadline)) {
 		unsigned long delta = deadline - now;
 
-		ata_link_printk(link, KERN_WARNING,
+		ata_link_printk(failed_link, KERN_WARNING,
 			"reset failed (errno=%d), retrying in %u secs\n",
 			rc, DIV_ROUND_UP(jiffies_to_msecs(delta), 1000));
 
@@ -2439,13 +2557,92 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			delta = schedule_timeout_uninterruptible(delta);
 	}
 
-	if (rc == -EPIPE || try == max_tries - 1)
+	if (try == max_tries - 1) {
 		sata_down_spd_limit(link);
+		if (slave)
+			sata_down_spd_limit(slave);
+	} else if (rc == -EPIPE)
+		sata_down_spd_limit(failed_link);
+
 	if (hardreset)
 		reset = hardreset;
 	goto retry;
 }
 
+static inline void ata_eh_pull_park_action(struct ata_port *ap)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+	unsigned long flags;
+
+	/*
+	 * This function can be thought of as an extended version of
+	 * ata_eh_about_to_do() specially crafted to accommodate the
+	 * requirements of ATA_EH_PARK handling. Since the EH thread
+	 * does not leave the do {} while () loop in ata_eh_recover as
+	 * long as the timeout for a park request to *one* device on
+	 * the port has not expired, and since we still want to pick
+	 * up park requests to other devices on the same port or
+	 * timeout updates for the same device, we have to pull
+	 * ATA_EH_PARK actions from eh_info into eh_context.i
+	 * ourselves at the beginning of each pass over the loop.
+	 *
+	 * Additionally, all write accesses to &ap->park_req_pending
+	 * through INIT_COMPLETION() (see below) or complete_all()
+	 * (see ata_scsi_park_store()) are protected by the host lock.
+	 * As a result we have that park_req_pending.done is zero on
+	 * exit from this function, i.e. when ATA_EH_PARK actions for
+	 * *all* devices on port ap have been pulled into the
+	 * respective eh_context structs. If, and only if,
+	 * park_req_pending.done is non-zero by the time we reach
+	 * wait_for_completion_timeout(), another ATA_EH_PARK action
+	 * has been scheduled for at least one of the devices on port
+	 * ap and we have to cycle over the do {} while () loop in
+	 * ata_eh_recover() again.
+	 */
+
+	spin_lock_irqsave(ap->lock, flags);
+	INIT_COMPLETION(ap->park_req_pending);
+	ata_port_for_each_link(link, ap) {
+		ata_link_for_each_dev(dev, link) {
+			struct ata_eh_info *ehi = &link->eh_info;
+
+			link->eh_context.i.dev_action[dev->devno] |=
+				ehi->dev_action[dev->devno] & ATA_EH_PARK;
+			ata_eh_clear_action(link, dev, ehi, ATA_EH_PARK);
+		}
+	}
+	spin_unlock_irqrestore(ap->lock, flags);
+}
+
+static void ata_eh_park_issue_cmd(struct ata_device *dev, int park)
+{
+	struct ata_eh_context *ehc = &dev->link->eh_context;
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	ata_tf_init(dev, &tf);
+	if (park) {
+		ehc->unloaded_mask |= 1 << dev->devno;
+		tf.command = ATA_CMD_IDLEIMMEDIATE;
+		tf.feature = 0x44;
+		tf.lbal = 0x4c;
+		tf.lbam = 0x4e;
+		tf.lbah = 0x55;
+	} else {
+		ehc->unloaded_mask &= ~(1 << dev->devno);
+		tf.command = ATA_CMD_CHK_POWER;
+	}
+
+	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf.protocol |= ATA_PROT_NODATA;
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
+	if (park && (err_mask || tf.lbal != 0xc4)) {
+		ata_dev_printk(dev, KERN_ERR, "head unload failed!\n");
+		ehc->unloaded_mask &= ~(1 << dev->devno);
+	}
+}
+
 static int ata_eh_revalidate_and_attach(struct ata_link *link,
 					struct ata_device **r_failed_dev)
 {
@@ -2472,7 +2669,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 		if ((action & ATA_EH_REVALIDATE) && ata_dev_enabled(dev)) {
 			WARN_ON(dev->class == ATA_DEV_PMP);
 
-			if (ata_link_offline(link)) {
+			if (ata_phys_link_offline(ata_dev_phys_link(dev))) {
 				rc = -EIO;
 				goto err;
 			}
@@ -2610,6 +2807,53 @@ int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 	return rc;
 }
 
+/**
+ *	atapi_eh_clear_ua - Clear ATAPI UNIT ATTENTION after reset
+ *	@dev: ATAPI device to clear UA for
+ *
+ *	Resets and other operations can make an ATAPI device raise
+ *	UNIT ATTENTION which causes the next operation to fail.  This
+ *	function clears UA.
+ *
+ *	LOCKING:
+ *	EH context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+static int atapi_eh_clear_ua(struct ata_device *dev)
+{
+	int i;
+
+	for (i = 0; i < ATA_EH_UA_TRIES; i++) {
+		u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];
+		u8 sense_key = 0;
+		unsigned int err_mask;
+
+		err_mask = atapi_eh_tur(dev, &sense_key);
+		if (err_mask != 0 && err_mask != AC_ERR_DEV) {
+			ata_dev_printk(dev, KERN_WARNING, "TEST_UNIT_READY "
+				"failed (err_mask=0x%x)\n", err_mask);
+			return -EIO;
+		}
+
+		if (!err_mask || sense_key != UNIT_ATTENTION)
+			return 0;
+
+		err_mask = atapi_eh_request_sense(dev, sense_buffer, sense_key);
+		if (err_mask) {
+			ata_dev_printk(dev, KERN_WARNING, "failed to clear "
+				"UNIT ATTENTION (err_mask=0x%x)\n", err_mask);
+			return -EIO;
+		}
+	}
+
+	ata_dev_printk(dev, KERN_WARNING,
+		"UNIT ATTENTION persists after %d tries\n", ATA_EH_UA_TRIES);
+
+	return 0;
+}
+
 static int ata_link_nr_enabled(struct ata_link *link)
 {
 	struct ata_device *dev;
@@ -2697,7 +2941,7 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 			/* This is the last chance, better to slow
 			 * down than lose it.
 			 */
-			sata_down_spd_limit(dev->link);
+			sata_down_spd_limit(ata_dev_phys_link(dev));
 			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
 		}
 	}
@@ -2707,7 +2951,7 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 		ata_dev_disable(dev);
 
 		/* detach if offline */
-		if (ata_link_offline(dev->link))
+		if (ata_phys_link_offline(ata_dev_phys_link(dev)))
 			ata_eh_detach_dev(dev);
 
 		/* schedule probe if necessary */
@@ -2755,7 +2999,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	struct ata_device *dev;
 	int nr_failed_devs;
 	int rc;
-	unsigned long flags;
+	unsigned long flags, deadline;
 
 	DPRINTK("ENTER\n");
 
@@ -2829,6 +3073,56 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		}
 	}
 
+	do {
+		unsigned long now;
+
+		/*
+		 * clears ATA_EH_PARK in eh_info and resets
+		 * ap->park_req_pending
+		 */
+		ata_eh_pull_park_action(ap);
+
+		deadline = jiffies;
+		ata_port_for_each_link(link, ap) {
+			ata_link_for_each_dev(dev, link) {
+				struct ata_eh_context *ehc = &link->eh_context;
+				unsigned long tmp;
+
+				if (dev->class != ATA_DEV_ATA)
+					continue;
+				if (!(ehc->i.dev_action[dev->devno] &
+				      ATA_EH_PARK))
+					continue;
+				tmp = dev->unpark_deadline;
+				if (time_before(deadline, tmp))
+					deadline = tmp;
+				else if (time_before_eq(tmp, jiffies))
+					continue;
+				if (ehc->unloaded_mask & (1 << dev->devno))
+					continue;
+
+				ata_eh_park_issue_cmd(dev, 1);
+			}
+		}
+
+		now = jiffies;
+		if (time_before_eq(deadline, now))
+			break;
+
+		deadline = wait_for_completion_timeout(&ap->park_req_pending,
+						       deadline - now);
+	} while (deadline);
+	ata_port_for_each_link(link, ap) {
+		ata_link_for_each_dev(dev, link) {
+			if (!(link->eh_context.unloaded_mask &
+			      (1 << dev->devno)))
+				continue;
+
+			ata_eh_park_issue_cmd(dev, 0);
+			ata_eh_done(link, dev, ATA_EH_PARK);
+		}
+	}
+
 	/* the rest */
 	ata_port_for_each_link(link, ap) {
 		struct ata_eh_context *ehc = &link->eh_context;
@@ -2852,6 +3146,20 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			ehc->i.flags &= ~ATA_EHI_SETMODE;
 		}
 
+		/* If reset has been issued, clear UA to avoid
+		 * disrupting the current users of the device.
+		 */
+		if (ehc->i.flags & ATA_EHI_DID_RESET) {
+			ata_link_for_each_dev(dev, link) {
+				if (dev->class != ATA_DEV_ATAPI)
+					continue;
+				rc = atapi_eh_clear_ua(dev);
+				if (rc)
+					goto dev_fail;
+			}
+		}
+
+		/* configure link power saving */
 		if (ehc->i.action & ATA_EH_LPM)
 			ata_link_for_each_dev(dev, link)
 				ata_dev_enable_pm(dev, ap->pm_policy);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9d3ba4..fccd5e4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -183,6 +183,105 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
 		ata_scsi_lpm_show, ata_scsi_lpm_put);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
 
+static ssize_t ata_scsi_park_show(struct device *device,
+				  struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_link *link;
+	struct ata_device *dev;
+	unsigned long flags;
+	unsigned int uninitialized_var(msecs);
+	int rc = 0;
+
+	ap = ata_shost_to_port(sdev->host);
+
+	spin_lock_irqsave(ap->lock, flags);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (!dev) {
+		rc = -ENODEV;
+		goto unlock;
+	}
+	if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	link = dev->link;
+	if (ap->pflags & ATA_PFLAG_EH_IN_PROGRESS &&
+	    link->eh_context.unloaded_mask & (1 << dev->devno) &&
+	    time_after(dev->unpark_deadline, jiffies))
+		msecs = jiffies_to_msecs(dev->unpark_deadline - jiffies);
+	else
+		msecs = 0;
+
+unlock:
+	spin_unlock_irq(ap->lock);
+
+	return rc ? rc : snprintf(buf, 20, "%u\n", msecs);
+}
+
+static ssize_t ata_scsi_park_store(struct device *device,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_device *dev;
+	long int input;
+	unsigned long flags;
+	int rc;
+
+	rc = strict_strtol(buf, 10, &input);
+	if (rc || input < -2)
+		return -EINVAL;
+	if (input > ATA_TMOUT_MAX_PARK) {
+		rc = -EOVERFLOW;
+		input = ATA_TMOUT_MAX_PARK;
+	}
+
+	ap = ata_shost_to_port(sdev->host);
+
+	spin_lock_irqsave(ap->lock, flags);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (unlikely(!dev)) {
+		rc = -ENODEV;
+		goto unlock;
+	}
+	if (dev->class != ATA_DEV_ATA) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	if (input >= 0) {
+		if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
+			rc = -EOPNOTSUPP;
+			goto unlock;
+		}
+
+		dev->unpark_deadline = ata_deadline(jiffies, input);
+		dev->link->eh_info.dev_action[dev->devno] |= ATA_EH_PARK;
+		ata_port_schedule_eh(ap);
+		complete(&ap->park_req_pending);
+	} else {
+		switch (input) {
+		case -1:
+			dev->flags &= ~ATA_DFLAG_NO_UNLOAD;
+			break;
+		case -2:
+			dev->flags |= ATA_DFLAG_NO_UNLOAD;
+			break;
+		}
+	}
+unlock:
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return rc ? rc : len;
+}
+DEVICE_ATTR(unload_heads, S_IRUGO | S_IWUSR,
+	    ata_scsi_park_show, ata_scsi_park_store);
+EXPORT_SYMBOL_GPL(dev_attr_unload_heads);
+
 static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 {
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
@@ -269,6 +368,12 @@ DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_show,
 			ata_scsi_activity_store);
 EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
 
+struct device_attribute *ata_common_sdev_attrs[] = {
+	&dev_attr_unload_heads,
+	NULL
+};
+EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
+
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
 {
@@ -954,6 +1059,9 @@ static int atapi_drain_needed(struct request *rq)
 static int ata_scsi_dev_config(struct scsi_device *sdev,
 			       struct ata_device *dev)
 {
+	if (!ata_id_has_unload(dev->id))
+		dev->flags |= ATA_DFLAG_NO_UNLOAD;
+
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index ade5c75..e96de96 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -70,6 +70,7 @@ extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
 extern int libata_allow_tpm;
+extern struct ata_link *ata_dev_phys_link(struct ata_device *dev);
 extern void ata_force_cbl(struct ata_port *ap);
 extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
 extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
@@ -107,6 +108,8 @@ extern void ata_qc_issue(struct ata_queued_cmd *qc);
 extern void __ata_qc_complete(struct ata_queued_cmd *qc);
 extern int atapi_check_dma(struct ata_queued_cmd *qc);
 extern void swap_buf_le16(u16 *buf, unsigned int buf_words);
+extern bool ata_phys_link_online(struct ata_link *link);
+extern bool ata_phys_link_offline(struct ata_link *link);
 extern void ata_dev_init(struct ata_device *dev);
 extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
 extern int sata_link_init_spd(struct ata_link *link);
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index d393290..1266924 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1632,6 +1632,8 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	dev_set_drvdata(&pdev->dev, host);
+
 	return 0;
 }
 
@@ -1648,6 +1650,7 @@ static int __devexit bfin_atapi_remove(struct platform_device *pdev)
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
+	dev_set_drvdata(&pdev->dev, NULL);
 
 	peripheral_free_list(atapi_io_port);
 
@@ -1655,27 +1658,44 @@ static int __devexit bfin_atapi_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-int bfin_atapi_suspend(struct platform_device *pdev, pm_message_t state)
+static int bfin_atapi_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	return 0;
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	if (host)
+		return ata_host_suspend(host, state);
+	else
+		return 0;
 }
 
-int bfin_atapi_resume(struct platform_device *pdev)
+static int bfin_atapi_resume(struct platform_device *pdev)
 {
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int ret;
+
+	if (host) {
+		ret = bfin_reset_controller(host);
+		if (ret) {
+			printk(KERN_ERR DRV_NAME ": Error during HW init\n");
+			return ret;
+		}
+		ata_host_resume(host);
+	}
+
 	return 0;
 }
+#else
+#define bfin_atapi_suspend NULL
+#define bfin_atapi_resume NULL
 #endif
 
 static struct platform_driver bfin_atapi_driver = {
 	.probe			= bfin_atapi_probe,
 	.remove			= __devexit_p(bfin_atapi_remove),
+	.suspend		= bfin_atapi_suspend,
+	.resume			= bfin_atapi_resume,
 	.driver = {
 		.name		= DRV_NAME,
 		.owner		= THIS_MODULE,
-#ifdef CONFIG_PM
-		.suspend	= bfin_atapi_suspend,
-		.resume		= bfin_atapi_resume,
-#endif
 	},
 };
 
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index e970b22..a598bb3 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -230,7 +230,7 @@ static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 		tmpbyte & 1, tmpbyte & 0x30);
 
 	*try_mmio = 0;
-#ifdef CONFIG_PPC_MERGE
+#ifdef CONFIG_PPC
 	if (machine_is(cell))
 		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
 #endif
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 3924e72..1a56db9 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -469,10 +469,10 @@ static bool sata_fsl_qc_fill_rtf(struct ata_queued_cmd *qc)
 	return true;
 }
 
-static int sata_fsl_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
-			       u32 val)
+static int sata_fsl_scr_write(struct ata_link *link,
+			      unsigned int sc_reg_in, u32 val)
 {
-	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
+	struct sata_fsl_host_priv *host_priv = link->ap->host->private_data;
 	void __iomem *ssr_base = host_priv->ssr_base;
 	unsigned int sc_reg;
 
@@ -493,10 +493,10 @@ static int sata_fsl_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 	return 0;
 }
 
-static int sata_fsl_scr_read(struct ata_port *ap, unsigned int sc_reg_in,
-			u32 *val)
+static int sata_fsl_scr_read(struct ata_link *link,
+			     unsigned int sc_reg_in, u32 *val)
 {
-	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
+	struct sata_fsl_host_priv *host_priv = link->ap->host->private_data;
 	void __iomem *ssr_base = host_priv->ssr_base;
 	unsigned int sc_reg;
 
@@ -645,12 +645,12 @@ static int sata_fsl_port_start(struct ata_port *ap)
 	 * Workaround for 8315DS board 3gbps link-up issue,
 	 * currently limit SATA port to GEN1 speed
 	 */
-	sata_fsl_scr_read(ap, SCR_CONTROL, &temp);
+	sata_fsl_scr_read(&ap->link, SCR_CONTROL, &temp);
 	temp &= ~(0xF << 4);
 	temp |= (0x1 << 4);
-	sata_fsl_scr_write(ap, SCR_CONTROL, temp);
+	sata_fsl_scr_write(&ap->link, SCR_CONTROL, temp);
 
-	sata_fsl_scr_read(ap, SCR_CONTROL, &temp);
+	sata_fsl_scr_read(&ap->link, SCR_CONTROL, &temp);
 	dev_printk(KERN_WARNING, dev, "scr_control, speed limited to %x\n",
 			temp);
 #endif
@@ -868,7 +868,7 @@ issue_srst:
 			ioread32(CQ + hcr_base),
 			ioread32(CA + hcr_base), ioread32(CC + hcr_base));
 
-		sata_fsl_scr_read(ap, SCR_ERROR, &Serror);
+		sata_fsl_scr_read(&ap->link, SCR_ERROR, &Serror);
 
 		DPRINTK("HStatus = 0x%x\n", ioread32(hcr_base + HSTATUS));
 		DPRINTK("HControl = 0x%x\n", ioread32(hcr_base + HCONTROL));
@@ -972,9 +972,9 @@ static void sata_fsl_error_intr(struct ata_port *ap)
 	 * Handle & Clear SError
 	 */
 
-	sata_fsl_scr_read(ap, SCR_ERROR, &SError);
+	sata_fsl_scr_read(&ap->link, SCR_ERROR, &SError);
 	if (unlikely(SError & 0xFFFF0000)) {
-		sata_fsl_scr_write(ap, SCR_ERROR, SError);
+		sata_fsl_scr_write(&ap->link, SCR_ERROR, SError);
 	}
 
 	DPRINTK("error_intr,hStat=0x%x,CE=0x%x,DE =0x%x,SErr=0x%x\n",
@@ -1091,7 +1091,7 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 
 	hstatus = ioread32(hcr_base + HSTATUS);
 
-	sata_fsl_scr_read(ap, SCR_ERROR, &SError);
+	sata_fsl_scr_read(&ap->link, SCR_ERROR, &SError);
 
 	if (unlikely(SError & 0xFFFF0000)) {
 		DPRINTK("serror @host_intr : 0x%x\n", SError);
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 5032c32..fbbd87c 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -269,9 +269,9 @@ static void inic_reset_port(void __iomem *port_base)
 	writeb(0xff, port_base + PORT_IRQ_STAT);
 }
 
-static int inic_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
+static int inic_scr_read(struct ata_link *link, unsigned sc_reg, u32 *val)
 {
-	void __iomem *scr_addr = inic_port_base(ap) + PORT_SCR;
+	void __iomem *scr_addr = inic_port_base(link->ap) + PORT_SCR;
 	void __iomem *addr;
 
 	if (unlikely(sc_reg >= ARRAY_SIZE(scr_map)))
@@ -286,9 +286,9 @@ static int inic_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
 	return 0;
 }
 
-static int inic_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val)
+static int inic_scr_write(struct ata_link *link, unsigned sc_reg, u32 val)
 {
-	void __iomem *scr_addr = inic_port_base(ap) + PORT_SCR;
+	void __iomem *scr_addr = inic_port_base(link->ap) + PORT_SCR;
 
 	if (unlikely(sc_reg >= ARRAY_SIZE(scr_map)))
 		return -EINVAL;
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index c815f8e..2b24ae5 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -493,10 +493,10 @@ struct mv_hw_ops {
 	void (*reset_bus)(struct ata_host *host, void __iomem *mmio);
 };
 
-static int mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val);
-static int mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
-static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val);
-static int mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
+static int mv_scr_read(struct ata_link *link, unsigned int sc_reg_in, u32 *val);
+static int mv_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val);
+static int mv5_scr_read(struct ata_link *link, unsigned int sc_reg_in, u32 *val);
+static int mv5_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val);
 static int mv_port_start(struct ata_port *ap);
 static void mv_port_stop(struct ata_port *ap);
 static int mv_qc_defer(struct ata_queued_cmd *qc);
@@ -1070,23 +1070,23 @@ static unsigned int mv_scr_offset(unsigned int sc_reg_in)
 	return ofs;
 }
 
-static int mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val)
+static int mv_scr_read(struct ata_link *link, unsigned int sc_reg_in, u32 *val)
 {
 	unsigned int ofs = mv_scr_offset(sc_reg_in);
 
 	if (ofs != 0xffffffffU) {
-		*val = readl(mv_ap_base(ap) + ofs);
+		*val = readl(mv_ap_base(link->ap) + ofs);
 		return 0;
 	} else
 		return -EINVAL;
 }
 
-static int mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
+static int mv_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val)
 {
 	unsigned int ofs = mv_scr_offset(sc_reg_in);
 
 	if (ofs != 0xffffffffU) {
-		writelfl(val, mv_ap_base(ap) + ofs);
+		writelfl(val, mv_ap_base(link->ap) + ofs);
 		return 0;
 	} else
 		return -EINVAL;
@@ -2251,11 +2251,11 @@ static unsigned int mv5_scr_offset(unsigned int sc_reg_in)
 	return ofs;
 }
 
-static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val)
+static int mv5_scr_read(struct ata_link *link, unsigned int sc_reg_in, u32 *val)
 {
-	struct mv_host_priv *hpriv = ap->host->private_data;
+	struct mv_host_priv *hpriv = link->ap->host->private_data;
 	void __iomem *mmio = hpriv->base;
-	void __iomem *addr = mv5_phy_base(mmio, ap->port_no);
+	void __iomem *addr = mv5_phy_base(mmio, link->ap->port_no);
 	unsigned int ofs = mv5_scr_offset(sc_reg_in);
 
 	if (ofs != 0xffffffffU) {
@@ -2265,11 +2265,11 @@ static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val)
 		return -EINVAL;
 }
 
-static int mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
+static int mv5_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val)
 {
-	struct mv_host_priv *hpriv = ap->host->private_data;
+	struct mv_host_priv *hpriv = link->ap->host->private_data;
 	void __iomem *mmio = hpriv->base;
-	void __iomem *addr = mv5_phy_base(mmio, ap->port_no);
+	void __iomem *addr = mv5_phy_base(mmio, link->ap->port_no);
 	unsigned int ofs = mv5_scr_offset(sc_reg_in);
 
 	if (ofs != 0xffffffffU) {
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 1e1f3f3..88fd4ae 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -302,8 +302,8 @@ static void nv_ck804_host_stop(struct ata_host *host);
 static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance);
 static irqreturn_t nv_nf2_interrupt(int irq, void *dev_instance);
 static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance);
-static int nv_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int nv_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int nv_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int nv_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 
 static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
@@ -1492,21 +1492,21 @@ static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance)
 	return ret;
 }
 
-static int nv_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int nv_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
 
-	*val = ioread32(ap->ioaddr.scr_addr + (sc_reg * 4));
+	*val = ioread32(link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
-static int nv_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int nv_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
 
-	iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	iowrite32(val, link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
@@ -2184,9 +2184,9 @@ static void nv_swncq_host_interrupt(struct ata_port *ap, u16 fis)
 	if (!pp->qc_active)
 		return;
 
-	if (ap->ops->scr_read(ap, SCR_ERROR, &serror))
+	if (ap->ops->scr_read(&ap->link, SCR_ERROR, &serror))
 		return;
-	ap->ops->scr_write(ap, SCR_ERROR, serror);
+	ap->ops->scr_write(&ap->link, SCR_ERROR, serror);
 
 	if (ata_stat & ATA_ERR) {
 		ata_ehi_clear_desc(ehi);
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 030665b..750d8cd 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -137,8 +137,8 @@ struct pdc_port_priv {
 	dma_addr_t		pkt_dma;
 };
 
-static int pdc_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int pdc_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int pdc_sata_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int pdc_sata_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int pdc_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int pdc_common_port_start(struct ata_port *ap);
 static int pdc_sata_port_start(struct ata_port *ap);
@@ -386,19 +386,21 @@ static int pdc_sata_cable_detect(struct ata_port *ap)
 	return ATA_CBL_SATA;
 }
 
-static int pdc_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int pdc_sata_scr_read(struct ata_link *link,
+			     unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+	*val = readl(link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
-static int pdc_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int pdc_sata_scr_write(struct ata_link *link,
+			      unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	writel(val, link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
@@ -731,7 +733,7 @@ static void pdc_error_intr(struct ata_port *ap, struct ata_queued_cmd *qc,
 	if (sata_scr_valid(&ap->link)) {
 		u32 serror;
 
-		pdc_sata_scr_read(ap, SCR_ERROR, &serror);
+		pdc_sata_scr_read(&ap->link, SCR_ERROR, &serror);
 		ehi->serror |= serror;
 	}
 
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 1600107..a000c86 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -111,8 +111,8 @@ struct qs_port_priv {
 	qs_state_t		state;
 };
 
-static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int qs_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int qs_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int qs_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int qs_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int qs_port_start(struct ata_port *ap);
 static void qs_host_stop(struct ata_host *host);
@@ -242,11 +242,11 @@ static int qs_prereset(struct ata_link *link, unsigned long deadline)
 	return ata_sff_prereset(link, deadline);
 }
 
-static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int qs_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 8));
+	*val = readl(link->ap->ioaddr.scr_addr + (sc_reg * 8));
 	return 0;
 }
 
@@ -256,11 +256,11 @@ static void qs_error_handler(struct ata_port *ap)
 	ata_std_error_handler(ap);
 }
 
-static int qs_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int qs_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	writel(val, ap->ioaddr.scr_addr + (sc_reg * 8));
+	writel(val, link->ap->ioaddr.scr_addr + (sc_reg * 8));
 	return 0;
 }
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 88bf421..031d7b7 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -115,8 +115,8 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int sil_pci_device_resume(struct pci_dev *pdev);
 #endif
 static void sil_dev_config(struct ata_device *dev);
-static int sil_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int sil_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int sil_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int sil_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int sil_set_mode(struct ata_link *link, struct ata_device **r_failed);
 static void sil_freeze(struct ata_port *ap);
 static void sil_thaw(struct ata_port *ap);
@@ -317,9 +317,9 @@ static inline void __iomem *sil_scr_addr(struct ata_port *ap,
 	return NULL;
 }
 
-static int sil_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int sil_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
-	void __iomem *mmio = sil_scr_addr(ap, sc_reg);
+	void __iomem *mmio = sil_scr_addr(link->ap, sc_reg);
 
 	if (mmio) {
 		*val = readl(mmio);
@@ -328,9 +328,9 @@ static int sil_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return -EINVAL;
 }
 
-static int sil_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int sil_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
-	void __iomem *mmio = sil_scr_addr(ap, sc_reg);
+	void __iomem *mmio = sil_scr_addr(link->ap, sc_reg);
 
 	if (mmio) {
 		writel(val, mmio);
@@ -352,8 +352,8 @@ static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
 		 * controllers continue to assert IRQ as long as
 		 * SError bits are pending.  Clear SError immediately.
 		 */
-		sil_scr_read(ap, SCR_ERROR, &serror);
-		sil_scr_write(ap, SCR_ERROR, serror);
+		sil_scr_read(&ap->link, SCR_ERROR, &serror);
+		sil_scr_write(&ap->link, SCR_ERROR, serror);
 
 		/* Sometimes spurious interrupts occur, double check
 		 * it's PHYRDY CHG.
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 84ffcc2..4621807 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -340,8 +340,8 @@ struct sil24_port_priv {
 };
 
 static void sil24_dev_config(struct ata_device *dev);
-static int sil24_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val);
-static int sil24_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val);
+static int sil24_scr_read(struct ata_link *link, unsigned sc_reg, u32 *val);
+static int sil24_scr_write(struct ata_link *link, unsigned sc_reg, u32 val);
 static int sil24_qc_defer(struct ata_queued_cmd *qc);
 static void sil24_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc);
@@ -504,9 +504,9 @@ static int sil24_scr_map[] = {
 	[SCR_ACTIVE]	= 3,
 };
 
-static int sil24_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
+static int sil24_scr_read(struct ata_link *link, unsigned sc_reg, u32 *val)
 {
-	void __iomem *scr_addr = sil24_port_base(ap) + PORT_SCONTROL;
+	void __iomem *scr_addr = sil24_port_base(link->ap) + PORT_SCONTROL;
 
 	if (sc_reg < ARRAY_SIZE(sil24_scr_map)) {
 		void __iomem *addr;
@@ -517,9 +517,9 @@ static int sil24_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
 	return -EINVAL;
 }
 
-static int sil24_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val)
+static int sil24_scr_write(struct ata_link *link, unsigned sc_reg, u32 val)
 {
-	void __iomem *scr_addr = sil24_port_base(ap) + PORT_SCONTROL;
+	void __iomem *scr_addr = sil24_port_base(link->ap) + PORT_SCONTROL;
 
 	if (sc_reg < ARRAY_SIZE(sil24_scr_map)) {
 		void __iomem *addr;
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 1010b30..9c43b4e 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -64,8 +64,8 @@ enum {
 };
 
 static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int sis_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int sis_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int sis_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 
 static const struct pci_device_id sis_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x0180), sis_180 },	/* SiS 964/180 */
@@ -134,10 +134,11 @@ static unsigned int get_scr_cfg_addr(struct ata_port *ap, unsigned int sc_reg)
 	return addr;
 }
 
-static u32 sis_scr_cfg_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static u32 sis_scr_cfg_read(struct ata_link *link,
+			    unsigned int sc_reg, u32 *val)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
+	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
+	unsigned int cfg_addr = get_scr_cfg_addr(link->ap, sc_reg);
 	u32 val2 = 0;
 	u8 pmr;
 
@@ -158,10 +159,11 @@ static u32 sis_scr_cfg_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return 0;
 }
 
-static int sis_scr_cfg_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int sis_scr_cfg_write(struct ata_link *link,
+			     unsigned int sc_reg, u32 val)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
+	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
+	unsigned int cfg_addr = get_scr_cfg_addr(link->ap, sc_reg);
 	u8 pmr;
 
 	if (sc_reg == SCR_ERROR) /* doesn't exist in PCI cfg space */
@@ -178,8 +180,9 @@ static int sis_scr_cfg_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 	return 0;
 }
 
-static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int sis_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
+	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 pmr;
 
@@ -187,7 +190,7 @@ static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 		return -EINVAL;
 
 	if (ap->flags & SIS_FLAG_CFGSCR)
-		return sis_scr_cfg_read(ap, sc_reg, val);
+		return sis_scr_cfg_read(link, sc_reg, val);
 
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
@@ -202,8 +205,9 @@ static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return 0;
 }
 
-static int sis_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int sis_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
+	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 pmr;
 
@@ -213,7 +217,7 @@ static int sis_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
 	if (ap->flags & SIS_FLAG_CFGSCR)
-		return sis_scr_cfg_write(ap, sc_reg, val);
+		return sis_scr_cfg_write(link, sc_reg, val);
 	else {
 		iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4));
 		if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index fb13b82..609d147 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -123,20 +123,22 @@ static int k2_sata_check_atapi_dma(struct ata_queued_cmd *qc)
 	}
 }
 
-static int k2_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int k2_sata_scr_read(struct ata_link *link,
+			    unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+	*val = readl(link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
 
-static int k2_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int k2_sata_scr_write(struct ata_link *link,
+			     unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	writel(val, link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index db529b8..019575b 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -57,8 +57,8 @@ struct uli_priv {
 };
 
 static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static int uli_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int uli_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int uli_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int uli_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 
 static const struct pci_device_id uli_pci_tbl[] = {
 	{ PCI_VDEVICE(AL, 0x5289), uli_5289 },
@@ -107,39 +107,39 @@ static unsigned int get_scr_cfg_addr(struct ata_port *ap, unsigned int sc_reg)
 	return hpriv->scr_cfg_addr[ap->port_no] + (4 * sc_reg);
 }
 
-static u32 uli_scr_cfg_read(struct ata_port *ap, unsigned int sc_reg)
+static u32 uli_scr_cfg_read(struct ata_link *link, unsigned int sc_reg)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
+	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
+	unsigned int cfg_addr = get_scr_cfg_addr(link->ap, sc_reg);
 	u32 val;
 
 	pci_read_config_dword(pdev, cfg_addr, &val);
 	return val;
 }
 
-static void uli_scr_cfg_write(struct ata_port *ap, unsigned int scr, u32 val)
+static void uli_scr_cfg_write(struct ata_link *link, unsigned int scr, u32 val)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned int cfg_addr = get_scr_cfg_addr(ap, scr);
+	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
+	unsigned int cfg_addr = get_scr_cfg_addr(link->ap, scr);
 
 	pci_write_config_dword(pdev, cfg_addr, val);
 }
 
-static int uli_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int uli_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
 
-	*val = uli_scr_cfg_read(ap, sc_reg);
+	*val = uli_scr_cfg_read(link, sc_reg);
 	return 0;
 }
 
-static int uli_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int uli_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL) //SCR_CONTROL=2, SCR_ERROR=1, SCR_STATUS=0
 		return -EINVAL;
 
-	uli_scr_cfg_write(ap, sc_reg, val);
+	uli_scr_cfg_write(link, sc_reg, val);
 	return 0;
 }
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 96deeb3..1cfa745 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -68,8 +68,8 @@ enum {
 };
 
 static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static int svia_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-static int svia_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int svia_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int svia_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static void svia_noop_freeze(struct ata_port *ap);
 static int vt6420_prereset(struct ata_link *link, unsigned long deadline);
 static int vt6421_pata_cable_detect(struct ata_port *ap);
@@ -152,19 +152,19 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, svia_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
-static int svia_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int svia_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	*val = ioread32(ap->ioaddr.scr_addr + (4 * sc_reg));
+	*val = ioread32(link->ap->ioaddr.scr_addr + (4 * sc_reg));
 	return 0;
 }
 
-static int svia_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int svia_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	iowrite32(val, ap->ioaddr.scr_addr + (4 * sc_reg));
+	iowrite32(val, link->ap->ioaddr.scr_addr + (4 * sc_reg));
 	return 0;
 }
 
@@ -210,20 +210,20 @@ static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
 		goto skip_scr;
 
 	/* Resume phy.  This is the old SATA resume sequence */
-	svia_scr_write(ap, SCR_CONTROL, 0x300);
-	svia_scr_read(ap, SCR_CONTROL, &scontrol); /* flush */
+	svia_scr_write(link, SCR_CONTROL, 0x300);
+	svia_scr_read(link, SCR_CONTROL, &scontrol); /* flush */
 
 	/* wait for phy to become ready, if necessary */
 	do {
 		msleep(200);
-		svia_scr_read(ap, SCR_STATUS, &sstatus);
+		svia_scr_read(link, SCR_STATUS, &sstatus);
 		if ((sstatus & 0xf) != 1)
 			break;
 	} while (time_before(jiffies, timeout));
 
 	/* open code sata_print_link_status() */
-	svia_scr_read(ap, SCR_STATUS, &sstatus);
-	svia_scr_read(ap, SCR_CONTROL, &scontrol);
+	svia_scr_read(link, SCR_STATUS, &sstatus);
+	svia_scr_read(link, SCR_CONTROL, &scontrol);
 
 	online = (sstatus & 0xf) == 0x3;
 
@@ -232,7 +232,7 @@ static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
 			online ? "up" : "down", sstatus, scontrol);
 
 	/* SStatus is read one more time */
-	svia_scr_read(ap, SCR_STATUS, &sstatus);
+	svia_scr_read(link, SCR_STATUS, &sstatus);
 
 	if (!online) {
 		/* tell EH to bail */
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index f3d635c..c57cdff 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -98,20 +98,22 @@ enum {
 			      VSC_SATA_INT_PHY_CHANGE),
 };
 
-static int vsc_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
+static int vsc_sata_scr_read(struct ata_link *link,
+			     unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+	*val = readl(link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
 
-static int vsc_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int vsc_sata_scr_write(struct ata_link *link,
+			      unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
 		return -EINVAL;
-	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	writel(val, link->ap->ioaddr.scr_addr + (sc_reg * 4));
 	return 0;
 }
 
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 48ee8c7..e187298 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -294,10 +294,10 @@ static void sas_ata_post_internal(struct ata_queued_cmd *qc)
 	}
 }
 
-static int sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
+static int sas_ata_scr_write(struct ata_link *link, unsigned int sc_reg_in,
 			      u32 val)
 {
-	struct domain_device *dev = ap->private_data;
+	struct domain_device *dev = link->ap->private_data;
 
 	SAS_DPRINTK("STUB %s\n", __func__);
 	switch (sc_reg_in) {
@@ -319,10 +319,10 @@ static int sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 	return 0;
 }
 
-static int sas_ata_scr_read(struct ata_port *ap, unsigned int sc_reg_in,
+static int sas_ata_scr_read(struct ata_link *link, unsigned int sc_reg_in,
 			    u32 *val)
 {
-	struct domain_device *dev = ap->private_data;
+	struct domain_device *dev = link->ap->private_data;
 
 	SAS_DPRINTK("STUB %s\n", __func__);
 	switch (sc_reg_in) {
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 8a12d71..a26ebd2 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -667,6 +667,15 @@ static inline int ata_id_has_dword_io(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_has_unload(const u16 *id)
+{
+	if (ata_id_major_version(id) >= 7 &&
+	    (id[ATA_ID_CFSSE] & 0xC000) == 0x4000 &&
+	    id[ATA_ID_CFSSE] & (1 << 13))
+		return 1;
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 225bfc5..947cf84 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -146,6 +146,7 @@ enum {
 	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
 	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
+	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
 	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 24),
@@ -244,6 +245,7 @@ enum {
 	ATA_TMOUT_BOOT		= 30000,	/* heuristic */
 	ATA_TMOUT_BOOT_QUICK	=  7000,	/* heuristic */
 	ATA_TMOUT_INTERNAL_QUICK = 5000,
+	ATA_TMOUT_MAX_PARK	= 30000,
 
 	/* FIXME: GoVault needs 2s but we can't afford that without
 	 * parallel probing.  800ms is enough for iVDR disk
@@ -319,8 +321,11 @@ enum {
 	ATA_EH_RESET		= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
 	ATA_EH_ENABLE_LINK	= (1 << 3),
 	ATA_EH_LPM		= (1 << 4),  /* link power management action */
+	ATA_EH_PARK		= (1 << 5), /* unload heads and stop I/O */
 
-	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE,
+	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PARK,
+	ATA_EH_ALL_ACTIONS	= ATA_EH_REVALIDATE | ATA_EH_RESET |
+				  ATA_EH_ENABLE_LINK | ATA_EH_LPM,
 
 	/* ata_eh_info->flags */
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
@@ -452,6 +457,7 @@ enum link_pm {
 	MEDIUM_POWER,
 };
 extern struct device_attribute dev_attr_link_power_management_policy;
+extern struct device_attribute dev_attr_unload_heads;
 extern struct device_attribute dev_attr_em_message_type;
 extern struct device_attribute dev_attr_em_message;
 extern struct device_attribute dev_attr_sw_activity;
@@ -554,8 +560,8 @@ struct ata_ering {
 struct ata_device {
 	struct ata_link		*link;
 	unsigned int		devno;		/* 0 or 1 */
-	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	unsigned int		horkage;	/* List of broken features */
+	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	struct scsi_device	*sdev;		/* attached SCSI device */
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
@@ -564,6 +570,7 @@ struct ata_device {
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
 	unsigned int		class;		/* ATA_DEV_xxx */
+	unsigned long		unpark_deadline;
 
 	u8			pio_mode;
 	u8			dma_mode;
@@ -621,6 +628,7 @@ struct ata_eh_context {
 					       [ATA_EH_CMD_TIMEOUT_TABLE_SIZE];
 	unsigned int		classes[ATA_MAX_DEVICES];
 	unsigned int		did_probe_mask;
+	unsigned int		unloaded_mask;
 	unsigned int		saved_ncq_enabled;
 	u8			saved_xfer_mode[ATA_MAX_DEVICES];
 	/* timestamp for the last reset attempt or success */
@@ -688,7 +696,8 @@ struct ata_port {
 	unsigned int		qc_active;
 	int			nr_active_links; /* #links with active qcs */
 
-	struct ata_link		link;	/* host default link */
+	struct ata_link		link;		/* host default link */
+	struct ata_link		*slave_link;	/* see ata_slave_link_init() */
 
 	int			nr_pmp_links;	/* nr of available PMP links */
 	struct ata_link		*pmp_link;	/* array of PMP links */
@@ -709,6 +718,7 @@ struct ata_port {
 	struct list_head	eh_done_q;
 	wait_queue_head_t	eh_wait_q;
 	int			eh_tries;
+	struct completion	park_req_pending;
 
 	pm_message_t		pm_mesg;
 	int			*pm_result;
@@ -772,8 +782,8 @@ struct ata_port_operations {
 	/*
 	 * Optional features
 	 */
-	int  (*scr_read)(struct ata_port *ap, unsigned int sc_reg, u32 *val);
-	int  (*scr_write)(struct ata_port *ap, unsigned int sc_reg, u32 val);
+	int  (*scr_read)(struct ata_link *link, unsigned int sc_reg, u32 *val);
+	int  (*scr_write)(struct ata_link *link, unsigned int sc_reg, u32 val);
 	void (*pmp_attach)(struct ata_port *ap);
 	void (*pmp_detach)(struct ata_port *ap);
 	int  (*enable_pm)(struct ata_port *ap, enum link_pm policy);
@@ -895,6 +905,7 @@ extern void ata_port_disable(struct ata_port *);
 extern struct ata_host *ata_host_alloc(struct device *dev, int max_ports);
 extern struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 			const struct ata_port_info * const * ppi, int n_ports);
+extern int ata_slave_link_init(struct ata_port *ap);
 extern int ata_host_start(struct ata_host *host);
 extern int ata_host_register(struct ata_host *host,
 			     struct scsi_host_template *sht);
@@ -920,8 +931,8 @@ extern int sata_scr_valid(struct ata_link *link);
 extern int sata_scr_read(struct ata_link *link, int reg, u32 *val);
 extern int sata_scr_write(struct ata_link *link, int reg, u32 val);
 extern int sata_scr_write_flush(struct ata_link *link, int reg, u32 val);
-extern int ata_link_online(struct ata_link *link);
-extern int ata_link_offline(struct ata_link *link);
+extern bool ata_link_online(struct ata_link *link);
+extern bool ata_link_offline(struct ata_link *link);
 #ifdef CONFIG_PM
 extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
 extern void ata_host_resume(struct ata_host *host);
@@ -1098,6 +1109,7 @@ extern void ata_std_error_handler(struct ata_port *ap);
  */
 extern const struct ata_port_operations ata_base_port_ops;
 extern const struct ata_port_operations sata_port_ops;
+extern struct device_attribute *ata_common_sdev_attrs[];
 
 #define ATA_BASE_SHT(drv_name)					\
 	.module			= THIS_MODULE,			\
@@ -1112,7 +1124,8 @@ extern const struct ata_port_operations sata_port_ops;
 	.proc_name		= drv_name,			\
 	.slave_configure	= ata_scsi_slave_config,	\
 	.slave_destroy		= ata_scsi_slave_destroy,	\
-	.bios_param		= ata_std_bios_param
+	.bios_param		= ata_std_bios_param,		\
+	.sdev_attrs		= ata_common_sdev_attrs
 
 #define ATA_NCQ_SHT(drv_name)					\
 	ATA_BASE_SHT(drv_name),					\
@@ -1134,7 +1147,7 @@ static inline bool sata_pmp_attached(struct ata_port *ap)
 
 static inline int ata_is_host_link(const struct ata_link *link)
 {
-	return link == &link->ap->link;
+	return link == &link->ap->link || link == link->ap->slave_link;
 }
 #else /* CONFIG_SATA_PMP */
 static inline bool sata_pmp_supported(struct ata_port *ap)
@@ -1167,7 +1180,7 @@ static inline int sata_srst_pmp(struct ata_link *link)
 	printk("%sata%u: "fmt, lv, (ap)->print_id , ##args)
 
 #define ata_link_printk(link, lv, fmt, args...) do { \
-	if (sata_pmp_attached((link)->ap)) \
+	if (sata_pmp_attached((link)->ap) || (link)->ap->slave_link)	\
 		printk("%sata%u.%02u: "fmt, lv, (link)->ap->print_id,	\
 		       (link)->pmp , ##args); \
 	else \
@@ -1265,34 +1278,17 @@ static inline int ata_link_active(struct ata_link *link)
 	return ata_tag_valid(link->active_tag) || link->sactive;
 }
 
-static inline struct ata_link *ata_port_first_link(struct ata_port *ap)
-{
-	if (sata_pmp_attached(ap))
-		return ap->pmp_link;
-	return &ap->link;
-}
-
-static inline struct ata_link *ata_port_next_link(struct ata_link *link)
-{
-	struct ata_port *ap = link->ap;
-
-	if (ata_is_host_link(link)) {
-		if (!sata_pmp_attached(ap))
-			return NULL;
-		return ap->pmp_link;
-	}
-
-	if (++link < ap->nr_pmp_links + ap->pmp_link)
-		return link;
-	return NULL;
-}
+extern struct ata_link *__ata_port_next_link(struct ata_port *ap,
+					     struct ata_link *link,
+					     bool dev_only);
 
-#define __ata_port_for_each_link(lk, ap) \
-	for ((lk) = &(ap)->link; (lk); (lk) = ata_port_next_link(lk))
+#define __ata_port_for_each_link(link, ap) \
+	for ((link) = __ata_port_next_link((ap), NULL, false); (link); \
+	     (link) = __ata_port_next_link((ap), (link), false))
 
 #define ata_port_for_each_link(link, ap) \
-	for ((link) = ata_port_first_link(ap); (link); \
-	     (link) = ata_port_next_link(link))
+	for ((link) = __ata_port_next_link((ap), NULL, true); (link); \
+	     (link) = __ata_port_next_link((ap), (link), true))
 
 #define ata_link_for_each_dev(dev, link) \
 	for ((dev) = (link)->device; \
