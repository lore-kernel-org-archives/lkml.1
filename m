Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYCYCvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYCYCvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYCYCu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:50:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37172 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYCYCu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:50:57 -0400
Date: Mon, 24 Mar 2008 22:50:56 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       richard.zhao@amd.com, henry.su@amd.com
Subject: [git patches] libata fixes
Message-ID: <20080325025055.GA25025@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c         |    6 ++-
 drivers/ata/libata-core.c  |   48 ++++++++++++--------
 drivers/ata/libata-scsi.c  |   14 ++++-
 drivers/ata/pata_it821x.c  |    2 +-
 drivers/ata/sata_promise.c |  109 +++++++++++++++++++++++++++++++++++--------
 include/linux/libata.h     |    8 +++-
 6 files changed, 141 insertions(+), 46 deletions(-)

Jeff Garzik (1):
      [libata] ahci: SB600 workaround is suspect... play it safe for now

Mikael Pettersson (1):
      sata_promise: fix hardreset hotplug events, take 2

Tejun Heo (4):
      libata: implement ata_qc_raw_nbytes()
      pata_it821x: use raw nbytes in check_atapi_dma
      libata: assume no device is attached if both IDENTIFYs are aborted
      libata: improve HPA error handling

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 17ee6ed..b1eb4e2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -433,6 +433,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci_sb600 */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
+				 AHCI_HFLAG_32BIT_ONLY |
 				 AHCI_HFLAG_SECT255 | AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
 		.link_flags	= AHCI_LFLAG_COMMON,
@@ -1217,8 +1218,11 @@ static void ahci_dev_config(struct ata_device *dev)
 {
 	struct ahci_host_priv *hpriv = dev->link->ap->host->private_data;
 
-	if (hpriv->flags & AHCI_HFLAG_SECT255)
+	if (hpriv->flags & AHCI_HFLAG_SECT255) {
 		dev->max_sectors = 255;
+		ata_dev_printk(dev, KERN_INFO,
+			       "SB600 AHCI: limiting to 255 sectors per cmd\n");
+	}
 }
 
 static unsigned int ahci_dev_classify(struct ata_port *ap)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4bbe31f..c4248b3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1416,12 +1416,12 @@ static int ata_hpa_resize(struct ata_device *dev)
 	/* read native max address */
 	rc = ata_read_native_max_address(dev, &native_sectors);
 	if (rc) {
-		/* If HPA isn't going to be unlocked, skip HPA
-		 * resizing from the next try.
+		/* If device aborted the command or HPA isn't going to
+		 * be unlocked, skip HPA resizing.
 		 */
-		if (!ata_ignore_hpa) {
+		if (rc == -EACCES || !ata_ignore_hpa) {
 			ata_dev_printk(dev, KERN_WARNING, "HPA support seems "
-				       "broken, will skip HPA handling\n");
+				       "broken, skipping HPA handling\n");
 			dev->horkage |= ATA_HORKAGE_BROKEN_HPA;
 
 			/* we can continue if device aborted the command */
@@ -2092,24 +2092,34 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 				     id, sizeof(id[0]) * ATA_ID_WORDS, 0);
 	if (err_mask) {
 		if (err_mask & AC_ERR_NODEV_HINT) {
-			DPRINTK("ata%u.%d: NODEV after polling detection\n",
-				ap->print_id, dev->devno);
+			ata_dev_printk(dev, KERN_DEBUG,
+				       "NODEV after polling detection\n");
 			return -ENOENT;
 		}
 
-		/* Device or controller might have reported the wrong
-		 * device class.  Give a shot at the other IDENTIFY if
-		 * the current one is aborted by the device.
-		 */
-		if (may_fallback &&
-		    (err_mask == AC_ERR_DEV) && (tf.feature & ATA_ABORTED)) {
-			may_fallback = 0;
+		if ((err_mask == AC_ERR_DEV) && (tf.feature & ATA_ABORTED)) {
+			/* Device or controller might have reported
+			 * the wrong device class.  Give a shot at the
+			 * other IDENTIFY if the current one is
+			 * aborted by the device.
+			 */
+			if (may_fallback) {
+				may_fallback = 0;
 
-			if (class == ATA_DEV_ATA)
-				class = ATA_DEV_ATAPI;
-			else
-				class = ATA_DEV_ATA;
-			goto retry;
+				if (class == ATA_DEV_ATA)
+					class = ATA_DEV_ATAPI;
+				else
+					class = ATA_DEV_ATA;
+				goto retry;
+			}
+
+			/* Control reaches here iff the device aborted
+			 * both flavors of IDENTIFYs which happens
+			 * sometimes with phantom devices.
+			 */
+			ata_dev_printk(dev, KERN_DEBUG,
+				       "both IDENTIFYs aborted, assuming NODEV\n");
+			return -ENOENT;
 		}
 
 		rc = -EIO;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8f0e8f2..1579539 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -527,6 +527,14 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 	return qc;
 }
 
+static void ata_qc_set_pc_nbytes(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+
+	qc->extrabytes = scmd->request->extra_len;
+	qc->nbytes = scsi_bufflen(scmd) + qc->extrabytes;
+}
+
 /**
  *	ata_dump_status - user friendly display of error info
  *	@id: id of the port in question
@@ -2539,7 +2547,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	}
 
 	qc->tf.command = ATA_CMD_PACKET;
-	qc->nbytes = scsi_bufflen(scmd) + scmd->request->extra_len;
+	ata_qc_set_pc_nbytes(qc);
 
 	/* check whether ATAPI DMA is safe */
 	if (!using_pio && ata_check_atapi_dma(qc))
@@ -2550,7 +2558,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	 * want to set it properly, and for DMA where it is
 	 * effectively meaningless.
 	 */
-	nbytes = min(scmd->request->data_len, (unsigned int)63 * 1024);
+	nbytes = min(ata_qc_raw_nbytes(qc), (unsigned int)63 * 1024);
 
 	/* Most ATAPI devices which honor transfer chunk size don't
 	 * behave according to the spec when odd chunk size which
@@ -2876,7 +2884,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	 * TODO: find out if we need to do more here to
 	 *       cover scatter/gather case.
 	 */
-	qc->nbytes = scsi_bufflen(scmd) + scmd->request->extra_len;
+	ata_qc_set_pc_nbytes(qc);
 
 	/* request result TF and be quiet about device error */
 	qc->flags |= ATA_QCFLAG_RESULT_TF | ATA_QCFLAG_QUIET;
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 109ddd4..257951d 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -564,7 +564,7 @@ static int it821x_check_atapi_dma(struct ata_queued_cmd *qc)
 	struct it821x_dev *itdev = ap->private_data;
 
 	/* Only use dma for transfers to/from the media. */
-	if (qc->nbytes < 2048)
+	if (ata_qc_raw_nbytes(qc) < 2048)
 		return -EOPNOTSUPP;
 
 	/* No ATAPI DMA in smart mode */
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index f251a5f..11c1afe 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -46,7 +46,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.11"
+#define DRV_VERSION	"2.12"
 
 enum {
 	PDC_MAX_PORTS		= 4,
@@ -145,7 +145,9 @@ static int pdc_old_sata_check_atapi_dma(struct ata_queued_cmd *qc);
 static void pdc_irq_clear(struct ata_port *ap);
 static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc);
 static void pdc_freeze(struct ata_port *ap);
+static void pdc_sata_freeze(struct ata_port *ap);
 static void pdc_thaw(struct ata_port *ap);
+static void pdc_sata_thaw(struct ata_port *ap);
 static void pdc_pata_error_handler(struct ata_port *ap);
 static void pdc_sata_error_handler(struct ata_port *ap);
 static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
@@ -180,8 +182,8 @@ static const struct ata_port_operations pdc_sata_ops = {
 
 	.qc_prep		= pdc_qc_prep,
 	.qc_issue		= pdc_qc_issue_prot,
-	.freeze			= pdc_freeze,
-	.thaw			= pdc_thaw,
+	.freeze			= pdc_sata_freeze,
+	.thaw			= pdc_sata_thaw,
 	.error_handler		= pdc_sata_error_handler,
 	.post_internal_cmd	= pdc_post_internal_cmd,
 	.cable_detect		= pdc_sata_cable_detect,
@@ -205,8 +207,8 @@ static const struct ata_port_operations pdc_old_sata_ops = {
 
 	.qc_prep		= pdc_qc_prep,
 	.qc_issue		= pdc_qc_issue_prot,
-	.freeze			= pdc_freeze,
-	.thaw			= pdc_thaw,
+	.freeze			= pdc_sata_freeze,
+	.thaw			= pdc_sata_thaw,
 	.error_handler		= pdc_sata_error_handler,
 	.post_internal_cmd	= pdc_post_internal_cmd,
 	.cable_detect		= pdc_sata_cable_detect,
@@ -631,6 +633,41 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
 	}
 }
 
+static int pdc_is_sataii_tx4(unsigned long flags)
+{
+	const unsigned long mask = PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS;
+	return (flags & mask) == mask;
+}
+
+static unsigned int pdc_port_no_to_ata_no(unsigned int port_no,
+					  int is_sataii_tx4)
+{
+	static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
+	return is_sataii_tx4 ? sataii_tx4_port_remap[port_no] : port_no;
+}
+
+static unsigned int pdc_sata_nr_ports(const struct ata_port *ap)
+{
+	return (ap->flags & PDC_FLAG_4_PORTS) ? 4 : 2;
+}
+
+static unsigned int pdc_sata_ata_port_to_ata_no(const struct ata_port *ap)
+{
+	const struct ata_host *host = ap->host;
+	unsigned int nr_ports = pdc_sata_nr_ports(ap);
+	unsigned int i;
+
+	for(i = 0; i < nr_ports && host->ports[i] != ap; ++i)
+		;
+	BUG_ON(i >= nr_ports);
+	return pdc_port_no_to_ata_no(i, pdc_is_sataii_tx4(ap->flags));
+}
+
+static unsigned int pdc_sata_hotplug_offset(const struct ata_port *ap)
+{
+	return (ap->flags & PDC_FLAG_GEN_II) ? PDC2_SATA_PLUG_CSR : PDC_SATA_PLUG_CSR;
+}
+
 static void pdc_freeze(struct ata_port *ap)
 {
 	void __iomem *mmio = ap->ioaddr.cmd_addr;
@@ -643,6 +680,29 @@ static void pdc_freeze(struct ata_port *ap)
 	readl(mmio + PDC_CTLSTAT); /* flush */
 }
 
+static void pdc_sata_freeze(struct ata_port *ap)
+{
+	struct ata_host *host = ap->host;
+	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
+	unsigned int hotplug_offset = pdc_sata_hotplug_offset(ap);
+	unsigned int ata_no = pdc_sata_ata_port_to_ata_no(ap);
+	u32 hotplug_status;
+
+	/* Disable hotplug events on this port.
+	 *
+	 * Locking:
+	 * 1) hotplug register accesses must be serialised via host->lock
+	 * 2) ap->lock == &ap->host->lock
+	 * 3) ->freeze() and ->thaw() are called with ap->lock held
+	 */
+	hotplug_status = readl(host_mmio + hotplug_offset);
+	hotplug_status |= 0x11 << (ata_no + 16);
+	writel(hotplug_status, host_mmio + hotplug_offset);
+	readl(host_mmio + hotplug_offset); /* flush */
+
+	pdc_freeze(ap);
+}
+
 static void pdc_thaw(struct ata_port *ap)
 {
 	void __iomem *mmio = ap->ioaddr.cmd_addr;
@@ -658,6 +718,26 @@ static void pdc_thaw(struct ata_port *ap)
 	readl(mmio + PDC_CTLSTAT); /* flush */
 }
 
+static void pdc_sata_thaw(struct ata_port *ap)
+{
+	struct ata_host *host = ap->host;
+	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
+	unsigned int hotplug_offset = pdc_sata_hotplug_offset(ap);
+	unsigned int ata_no = pdc_sata_ata_port_to_ata_no(ap);
+	u32 hotplug_status;
+
+	pdc_thaw(ap);
+
+	/* Enable hotplug events on this port.
+	 * Locking: see pdc_sata_freeze().
+	 */
+	hotplug_status = readl(host_mmio + hotplug_offset);
+	hotplug_status |= 0x11 << ata_no;
+	hotplug_status &= ~(0x11 << (ata_no + 16));
+	writel(hotplug_status, host_mmio + hotplug_offset);
+	readl(host_mmio + hotplug_offset); /* flush */
+}
+
 static void pdc_common_error_handler(struct ata_port *ap, ata_reset_fn_t hardreset)
 {
 	if (!(ap->pflags & ATA_PFLAG_FROZEN))
@@ -765,19 +845,6 @@ static void pdc_irq_clear(struct ata_port *ap)
 	readl(mmio + PDC_INT_SEQMASK);
 }
 
-static int pdc_is_sataii_tx4(unsigned long flags)
-{
-	const unsigned long mask = PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS;
-	return (flags & mask) == mask;
-}
-
-static unsigned int pdc_port_no_to_ata_no(unsigned int port_no,
-					  int is_sataii_tx4)
-{
-	static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
-	return is_sataii_tx4 ? sataii_tx4_port_remap[port_no] : port_no;
-}
-
 static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
@@ -799,6 +866,8 @@ static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 
 	mmio_base = host->iomap[PDC_MMIO_BAR];
 
+	spin_lock(&host->lock);
+
 	/* read and clear hotplug flags for all ports */
 	if (host->ports[0]->flags & PDC_FLAG_GEN_II)
 		hotplug_offset = PDC2_SATA_PLUG_CSR;
@@ -814,11 +883,9 @@ static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 
 	if (mask == 0xffffffff && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 2\n");
-		return IRQ_NONE;
+		goto done_irq;
 	}
 
-	spin_lock(&host->lock);
-
 	mask &= 0xffff;		/* only 16 tags possible */
 	if (mask == 0 && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 3\n");
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a05f600..269cdba 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -463,6 +463,7 @@ struct ata_queued_cmd {
 	unsigned int		sect_size;
 
 	unsigned int		nbytes;
+	unsigned int		extrabytes;
 	unsigned int		curbytes;
 
 	struct scatterlist	*cursg;
@@ -1336,6 +1337,11 @@ static inline struct ata_queued_cmd *ata_qc_from_tag(struct ata_port *ap,
 	return NULL;
 }
 
+static inline unsigned int ata_qc_raw_nbytes(struct ata_queued_cmd *qc)
+{
+	return qc->nbytes - min(qc->extrabytes, qc->nbytes);
+}
+
 static inline void ata_tf_init(struct ata_device *dev, struct ata_taskfile *tf)
 {
 	memset(tf, 0, sizeof(*tf));
@@ -1354,7 +1360,7 @@ static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
 	qc->flags = 0;
 	qc->cursg = NULL;
 	qc->cursg_ofs = 0;
-	qc->nbytes = qc->curbytes = 0;
+	qc->nbytes = qc->extrabytes = qc->curbytes = 0;
 	qc->n_elem = 0;
 	qc->err_mask = 0;
 	qc->sect_size = ATA_SECT_SIZE;
