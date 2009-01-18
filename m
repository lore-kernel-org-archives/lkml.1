Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbZARJXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbZARJXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 04:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762503AbZARJXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 04:23:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:52748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZARJX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 04:23:27 -0500
Message-ID: <4972F4E5.3030203@kernel.org>
Date: Sun, 18 Jan 2009 01:22:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peer Chen <pchen@nvidia.com>, Yinghai Lu <yinghai@kernel.org>,
       jeff@garzik.org, Kuan Luo <kluo@nvidia.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sata_nv: sgpio for nvidia mcp55
References: <20061031104055.GA8898@infradead.org>	 <15F501D1A78BD343BE8F4D8DB854566B0C8DDCF5@hkemmail01.nvidia.com>	 <86802c440711062009t7e98d27fqdfb466b9843da060@mail.gmail.com> <86802c440901180120u3e60e73dm53a37b7cd9034915@mail.gmail.com>
In-Reply-To: <86802c440901180120u3e60e73dm53a37b7cd9034915@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: new features

based on patch on
    http://marc.info/?l=linux-ide&m=116289338705418&w=2

1. update the patch for 2.6.19 to latest upstream ( 2.6.28?)
2. fix shared sgpio to support several mcp55 + io55, so every mcp55 have
   seperate spinlock
3. use scratch_source as numbering of sgpio instead of address of struct,
   so could go through kexec/kdump

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/ata/sata_nv.c |  534 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 534 insertions(+)

Index: linux-2.6/drivers/ata/sata_nv.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_nv.c
+++ linux-2.6/drivers/ata/sata_nv.c
@@ -200,6 +200,167 @@ enum {
 
 };
 
+/* sgpio
+ * Sgpio defines
+ * SGPIO state defines
+ */
+#define NV_SGPIO_STATE_RESET		0
+#define NV_SGPIO_STATE_OPERATIONAL	1
+#define NV_SGPIO_STATE_ERROR		2
+
+/* SGPIO command opcodes */
+#define NV_SGPIO_CMD_RESET		0
+#define NV_SGPIO_CMD_READ_PARAMS	1
+#define NV_SGPIO_CMD_READ_DATA		2
+#define NV_SGPIO_CMD_WRITE_DATA	3
+
+/* SGPIO command status defines */
+#define NV_SGPIO_CMD_OK		0
+#define NV_SGPIO_CMD_ACTIVE		1
+#define NV_SGPIO_CMD_ERR		2
+
+#define NV_SGPIO_UPDATE_TICK		90
+#define NV_SGPIO_MIN_UPDATE_DELTA	33
+#define NV_CNTRLR_SHARE_INIT		2
+#define NV_SGPIO_MAX_ACTIVITY_ON	20
+#define NV_SGPIO_MIN_FORCE_OFF		5
+#define NV_SGPIO_PCI_CSR_OFFSET	0x58
+#define NV_SGPIO_PCI_CB_OFFSET		0x5C
+#define NV_SGPIO_DFLT_CB_SIZE		256
+#define NV_ON 1
+#define NV_OFF 0
+
+static inline u8 bf_extract(u8 value, u8 offset, u8 bit_count)
+{
+	return (((u8)(value)) >> (offset)) & ((1 << (bit_count)) - 1);
+}
+
+static inline u8 bf_ins(u8 value, u8 ins, u8 offset, u8 bit_count)
+{
+	return	((value) & ~((((1 << (bit_count)) - 1)) << (offset))) |
+						(((u8)(ins)) << (offset));
+}
+
+static inline u32 bf_extract_u32(u32 value, u8 offset, u8 bit_count)
+{
+	return (((u32)(value)) >> (offset)) & ((1 << (bit_count)) - 1);
+}
+static inline u32 bf_ins_u32(u32 value, u32 ins, u8 offset, u8 bit_count)
+{
+	return	((value) & ~((((1 << (bit_count)) - 1)) << (offset))) |
+						(((u32)(ins)) << (offset));
+}
+
+#define GET_SGPIO_STATUS(v)	bf_extract(v, 0, 2)
+#define GET_CMD_STATUS(v)	bf_extract(v, 3, 2)
+#define GET_CMD(v)		bf_extract(v, 5, 3)
+#define SET_CMD(v, cmd)	bf_ins(v, cmd, 5, 3)
+
+#define GET_ENABLE(v)		bf_extract(v, 23, 1)
+#define SET_ENABLE(v)		bf_ins_u32(v, 1, 23, 1)
+
+/* Needs to have a u8 bit-field insert. */
+#define GET_ACTIVITY(v)		bf_extract(v, 5, 3)
+#define SET_ACTIVITY(v, on_off)	bf_ins(v, on_off, 5, 3)
+
+union nv_sgpio_nvcr {
+	struct {
+		u8	init_cnt;
+		u8	cb_size;
+		u8	cbver;
+		u8	rsvd;
+	} bit;
+	u32	all;
+};
+
+union nv_sgpio_tx {
+	u8	tx_port[4];
+	u32	all;
+};
+
+struct nv_sgpio_cb {
+	u64			scratch_space;
+	union nv_sgpio_nvcr	nvcr;
+	u32			cr0;
+	u32                     rsvd[4];
+	union nv_sgpio_tx       tx[2];
+};
+
+struct nv_sgpio_host_share {
+	spinlock_t	*plock;
+	unsigned long   *ptstamp;
+};
+
+struct nv_sgpio_host_flags {
+	u8	sgpio_enabled:1;
+	u8	need_update:1;
+	u8	rsvd:6;
+};
+
+struct nv_host_sgpio {
+	struct nv_sgpio_host_flags	flags;
+	u8				*pcsr;
+	struct nv_sgpio_cb		*pcb;
+	struct nv_sgpio_host_share	share;
+	struct timer_list		sgpio_timer;
+};
+
+struct nv_sgpio_port_flags {
+	u8	last_state:1;
+	u8	recent_activity:1;
+	u8	rsvd:6;
+};
+
+struct nv_sgpio_led {
+	struct nv_sgpio_port_flags	flags;
+	u8				force_off;
+	u8				last_cons_active;
+};
+
+struct nv_port_sgpio {
+	struct nv_sgpio_led	activity;
+};
+
+/* 1 mcp55 and 3 io55, 0 is not used */
+#define NR_SGPIO 5
+static spinlock_t nv_sgpio_lock[NR_SGPIO];
+static unsigned long nv_sgpio_tstamp[NR_SGPIO];
+static unsigned long nv_sgpio_share[NR_SGPIO] = {
+	[0 ... NR_SGPIO-1] = 0
+};
+
+static inline u8 nv_sgpio_get_func(struct ata_host *host)
+{
+	u8 devfn = (to_pci_dev(host->dev))->devfn;
+
+	return PCI_FUNC(devfn);
+}
+
+static inline u8 nv_sgpio_tx_host_offset(struct ata_host *host)
+{
+	return nv_sgpio_get_func(host)/NV_CNTRLR_SHARE_INIT;
+}
+
+static inline u8 nv_sgpio_calc_tx_offset(u8 cntrlr, u8 channel)
+{
+	return sizeof(union nv_sgpio_tx) - (NV_CNTRLR_SHARE_INIT *
+		(cntrlr % NV_CNTRLR_SHARE_INIT)) - channel - 1;
+}
+
+static inline u8 nv_sgpio_tx_port_offset(struct ata_port *ap)
+{
+	u8 cntrlr = nv_sgpio_get_func(ap->host);
+	return nv_sgpio_calc_tx_offset(cntrlr, ap->port_no);
+}
+
+static inline u8 nv_sgpio_capable(const struct pci_device_id *ent)
+{
+	if (ent->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2)
+		return 1;
+	else
+		return 0;
+}
+
 /* ADMA Physical Region Descriptor - one SG segment */
 struct nv_adma_prd {
 	__le64			addr;
@@ -240,6 +401,7 @@ struct nv_adma_cpb {
 
 
 struct nv_adma_port_priv {
+	struct nv_port_sgpio	port_sgpio;
 	struct nv_adma_cpb	*cpb;
 	dma_addr_t		cpb_dma;
 	struct nv_adma_prd	*aprd;
@@ -254,6 +416,12 @@ struct nv_adma_port_priv {
 
 struct nv_host_priv {
 	unsigned long		type;
+	unsigned long		host_flags;
+	struct nv_host_sgpio	host_sgpio;
+};
+
+struct nv_port_priv {
+	struct nv_port_sgpio	port_sgpio;
 };
 
 struct defer_queue {
@@ -271,6 +439,8 @@ enum ncq_saw_flag_list {
 };
 
 struct nv_swncq_port_priv {
+	struct nv_port_sgpio	port_sgpio;
+
 	struct ata_prd	*prd;	 /* our SG list */
 	dma_addr_t	prd_dma; /* and its DMA mapping */
 	void __iomem	*sactive_block;
@@ -311,6 +481,10 @@ static int nv_nf2_hardreset(struct ata_l
 			    unsigned long deadline);
 static void nv_ck804_freeze(struct ata_port *ap);
 static void nv_ck804_thaw(struct ata_port *ap);
+static int nv_port_start(struct ata_port *ap);
+static void nv_port_stop(struct ata_port *ap);
+static void nv_host_stop(struct ata_host *host);
+static unsigned int nv_qc_issue(struct ata_queued_cmd *qc);
 static int nv_adma_slave_config(struct scsi_device *sdev);
 static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static void nv_adma_qc_prep(struct ata_queued_cmd *qc);
@@ -374,6 +548,17 @@ static const struct pci_device_id nv_pci
 	{ } /* terminate list */
 };
 
+/* SGPIO function prototypes */
+static void nv_sgpio_init(struct pci_dev *pdev, struct ata_host *host);
+static void nv_sgpio_reset(u8 *pcsr);
+static void nv_sgpio_set_timer(struct timer_list *ptimer,
+				unsigned int timeout_msec);
+static void nv_sgpio_timer_handler(unsigned long ptr);
+static void nv_sgpio_host_cleanup(struct nv_host_priv *host);
+static u8 nv_sgpio_update_led(struct nv_sgpio_led *led, u8 *on_off);
+static void nv_sgpio_clear_all_leds(struct ata_port *ap);
+static u8 nv_sgpio_send_cmd(struct nv_host_priv *host, u8 cmd);
+
 static struct pci_driver nv_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= nv_pci_tbl,
@@ -409,6 +594,10 @@ static struct ata_port_operations nv_com
 	.inherits		= &ata_bmdma_port_ops,
 	.scr_read		= nv_scr_read,
 	.scr_write		= nv_scr_write,
+	.qc_issue               = nv_qc_issue,
+	.port_start		= nv_port_start,
+	.port_stop		= nv_port_stop,
+	.host_stop		= nv_host_stop,
 };
 
 /* OSDL bz11195 reports that link doesn't come online after hardreset
@@ -1395,6 +1584,8 @@ static unsigned int nv_adma_qc_issue(str
 	void __iomem *mmio = pp->ctl_block;
 	int curr_ncq = (qc->tf.protocol == ATA_PROT_NCQ);
 
+	pp->port_sgpio.activity.flags.recent_activity = NV_ON;
+
 	VPRINTK("ENTER\n");
 
 	/* We can't handle result taskfile with NCQ commands, since
@@ -1673,6 +1864,34 @@ static void nv_adma_error_handler(struct
 	ata_sff_error_handler(ap);
 }
 
+static int nv_port_start(struct ata_port *ap)
+{
+	struct device *dev = ap->host->dev;
+	struct nv_port_priv *pp;
+	int rc;
+
+	rc = ata_sff_port_start(ap);
+	if (rc)
+		return rc;
+
+	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
+	if (!pp)
+		return -ENOMEM;
+
+	ap->private_data = pp;
+
+	return 0;
+}
+
+static unsigned int nv_qc_issue(struct ata_queued_cmd *qc)
+{
+       struct nv_port_priv *port = qc->ap->private_data;
+
+       port->port_sgpio.activity.flags.recent_activity = NV_ON;
+
+       return ata_sff_qc_issue(qc);
+}
+
 static void nv_swncq_qc_to_dq(struct ata_port *ap, struct ata_queued_cmd *qc)
 {
 	struct nv_swncq_port_priv *pp = ap->private_data;
@@ -2017,6 +2236,8 @@ static unsigned int nv_swncq_qc_issue(st
 	struct ata_port *ap = qc->ap;
 	struct nv_swncq_port_priv *pp = ap->private_data;
 
+	pp->port_sgpio.activity.flags.recent_activity = NV_ON;
+
 	if (qc->tf.protocol != ATA_PROT_NCQ)
 		return ata_sff_qc_issue(qc);
 
@@ -2404,6 +2625,9 @@ static int nv_init_one(struct pci_dev *p
 	} else if (type == SWNCQ)
 		nv_swncq_host_init(host);
 
+	if (nv_sgpio_capable(ent))
+		nv_sgpio_init(pdev, host);
+
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ipriv->irq_handler,
 				 IRQF_SHARED, ipriv->sht);
@@ -2459,11 +2683,19 @@ static int nv_pci_device_resume(struct p
 }
 #endif
 
+static void nv_port_stop(struct ata_port *ap)
+{
+	nv_sgpio_clear_all_leds(ap);
+}
+
 static void nv_ck804_host_stop(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct nv_host_priv *phost = host->private_data;
 	u8 regval;
 
+	nv_sgpio_host_cleanup(phost);
+
 	/* disable SATA space for CK804 */
 	pci_read_config_byte(pdev, NV_MCP_SATA_CFG_20, &regval);
 	regval &= ~NV_MCP_SATA_CFG_20_SATA_SPACE_EN;
@@ -2487,6 +2719,308 @@ static void nv_adma_host_stop(struct ata
 	nv_ck804_host_stop(host);
 }
 
+static void nv_host_stop(struct ata_host *host)
+{
+	struct nv_host_priv *phost = host->private_data;
+
+	nv_sgpio_host_cleanup(phost);
+}
+
+static void nv_sgpio_init(struct pci_dev *pdev, struct ata_host *host)
+{
+	u16 csr_add;
+	u32 cb_add, temp32;
+	struct nv_host_priv *phost = host->private_data;
+	struct nv_host_sgpio *host_sgpio;
+	u8 pro = 0;
+	unsigned int share_sgpio;
+	int i;
+
+	pci_read_config_word(pdev, NV_SGPIO_PCI_CSR_OFFSET, &csr_add);
+	pci_read_config_dword(pdev, NV_SGPIO_PCI_CB_OFFSET, &cb_add);
+
+	if (csr_add == 0 || cb_add == 0)
+		return;
+
+	if (cb_add <= 0x80000 || cb_add >= 0x9FC00)
+		return;
+
+	pci_read_config_byte(pdev, 0xA4, &pro);
+	if (!(pro & 0x40))
+		return;
+
+	temp32 = csr_add;
+	if (temp32 <= 0x200 || temp32 >= 0xFFFE)
+		return;
+
+	dev_printk(KERN_DEBUG, &pdev->dev, "CSR 0x%x CB 0x%x\n",
+			 csr_add, cb_add);
+
+	host_sgpio = &phost->host_sgpio;
+	host_sgpio->pcsr = (void *)(unsigned long)temp32;
+	host_sgpio->pcb = ioremap(cb_add, 256);
+
+	if (host_sgpio->pcb->nvcr.bit.init_cnt != 0x2 ||
+			host_sgpio->pcb->nvcr.bit.cbver != 0x0)
+		return;
+
+	share_sgpio = host_sgpio->pcb->scratch_space;
+	if (share_sgpio == 0 || share_sgpio > (NR_SGPIO - 1)) {
+		/* find one good position */
+		for (i = 1; i < NR_SGPIO; i++) {
+			if (!nv_sgpio_share[i]) {
+				share_sgpio = i;
+				break;
+			}
+		}
+		if (share_sgpio == 0 || share_sgpio > (NR_SGPIO - 1)) {
+			printk(KERN_WARNING "NR_SGPIO %d is too small\n",
+				 NR_SGPIO);
+			return;
+		}
+	}
+
+	if (!nv_sgpio_share[share_sgpio]) {
+		/* also handle kexec path:
+		 * scratch_space is set, but not get nv_sgpio_share yet
+		 */
+		spin_lock_init(&nv_sgpio_lock[share_sgpio]);
+		host_sgpio->share.plock = &nv_sgpio_lock[share_sgpio];
+		host_sgpio->share.ptstamp = &nv_sgpio_tstamp[share_sgpio];
+		nv_sgpio_share[share_sgpio] =
+			(unsigned long)&host_sgpio->share;
+		host_sgpio->pcb->scratch_space = share_sgpio;
+		spin_lock(host_sgpio->share.plock);
+		nv_sgpio_reset(host_sgpio->pcsr);
+		host_sgpio->pcb->cr0 =
+			SET_ENABLE(host_sgpio->pcb->cr0);
+		spin_unlock(host_sgpio->share.plock);
+	} else {
+		host_sgpio->share = *(struct nv_sgpio_host_share *)
+				nv_sgpio_share[share_sgpio];
+	}
+
+	dev_printk(KERN_DEBUG, &pdev->dev, "using sgpio %d\n", share_sgpio);
+	host_sgpio->flags.sgpio_enabled = 1;
+
+	init_timer(&host_sgpio->sgpio_timer);
+	host_sgpio->sgpio_timer.data = (unsigned long)host;
+	nv_sgpio_set_timer(&host_sgpio->sgpio_timer,
+				NV_SGPIO_UPDATE_TICK);
+}
+
+static void nv_sgpio_set_timer(struct timer_list *ptimer,
+			       unsigned int timeout_msec)
+{
+	if (!ptimer)
+		return;
+	ptimer->function = nv_sgpio_timer_handler;
+	ptimer->expires = msecs_to_jiffies(timeout_msec) + jiffies;
+	add_timer(ptimer);
+}
+
+static void nv_sgpio_timer_handler(unsigned long context)
+{
+
+	struct ata_host *host = (struct ata_host *)context;
+	struct nv_host_priv *phost;
+	u8 count, host_offset, port_offset;
+	union nv_sgpio_tx tx;
+	u8 on_off;
+	unsigned long mask = 0xFFFF;
+	struct nv_port_priv *port;
+	struct nv_host_sgpio *host_sgpio;
+
+	if (!host)
+		goto err_out;
+
+	phost = (struct nv_host_priv *)host->private_data;
+
+	host_sgpio = &phost->host_sgpio;
+	if (!host_sgpio->flags.sgpio_enabled)
+		goto err_out;
+
+	host_offset = nv_sgpio_tx_host_offset(host);
+
+	spin_lock(host_sgpio->share.plock);
+	tx = host_sgpio->pcb->tx[host_offset];
+	spin_unlock(host_sgpio->share.plock);
+
+	for (count = 0; count < host->n_ports; count++) {
+		struct ata_port *ap;
+
+		ap = host->ports[count];
+
+		if (!(ap && !(ap->flags & ATA_FLAG_DISABLED)))
+			continue;
+
+		port = (struct nv_port_priv *)ap->private_data;
+		if (!port)
+			continue;
+		port_offset = nv_sgpio_tx_port_offset(ap);
+		on_off = GET_ACTIVITY(tx.tx_port[port_offset]);
+		if (nv_sgpio_update_led(&port->port_sgpio.activity, &on_off)) {
+			tx.tx_port[port_offset] =
+				SET_ACTIVITY(tx.tx_port[port_offset], on_off);
+			host_sgpio->flags.need_update = 1;
+	       }
+	}
+
+	if (host_sgpio->flags.need_update) {
+		spin_lock(host_sgpio->share.plock);
+		if (nv_sgpio_get_func(host)
+			% NV_CNTRLR_SHARE_INIT == 0) {
+			host_sgpio->pcb->tx[host_offset].all &= mask;
+			mask = mask << 16;
+			tx.all &= mask;
+		} else {
+			tx.all &= mask;
+			mask = mask << 16;
+			host_sgpio->pcb->tx[host_offset].all &= mask;
+		}
+		host_sgpio->pcb->tx[host_offset].all |= tx.all;
+		spin_unlock(host_sgpio->share.plock);
+
+		if (nv_sgpio_send_cmd(phost, NV_SGPIO_CMD_WRITE_DATA)) {
+			host_sgpio->flags.need_update = 0;
+			return;
+		}
+	} else {
+		nv_sgpio_set_timer(&host_sgpio->sgpio_timer,
+				NV_SGPIO_UPDATE_TICK);
+	}
+err_out:
+	return;
+}
+
+static u8 nv_sgpio_send_cmd(struct nv_host_priv *host, u8 cmd)
+{
+	u8 csr;
+	unsigned long *ptstamp;
+	struct nv_host_sgpio *host_sgpio;
+
+	host_sgpio = &host->host_sgpio;
+	spin_lock(host_sgpio->share.plock);
+	ptstamp = host_sgpio->share.ptstamp;
+	if (jiffies_to_msecs(jiffies - *ptstamp) >= NV_SGPIO_MIN_UPDATE_DELTA) {
+		csr = inb((unsigned long)host_sgpio->pcsr);
+		if ((GET_SGPIO_STATUS(csr) != NV_SGPIO_STATE_OPERATIONAL) ||
+		    (GET_CMD_STATUS(csr) == NV_SGPIO_CMD_ACTIVE)) {
+			;
+		} else {
+			host_sgpio->pcb->cr0 =
+				SET_ENABLE(host_sgpio->pcb->cr0);
+			csr = 0;
+			csr = SET_CMD(csr, cmd);
+			outb(csr, (unsigned long)host_sgpio->pcsr);
+			*ptstamp = jiffies;
+		}
+		spin_unlock(host_sgpio->share.plock);
+		nv_sgpio_set_timer(&host_sgpio->sgpio_timer,
+			NV_SGPIO_UPDATE_TICK);
+		return 1;
+	} else {
+		spin_unlock(host_sgpio->share.plock);
+		nv_sgpio_set_timer(&host_sgpio->sgpio_timer,
+				(NV_SGPIO_MIN_UPDATE_DELTA -
+				jiffies_to_msecs(jiffies - *ptstamp)));
+		return 0;
+	}
+}
+
+static u8 nv_sgpio_update_led(struct nv_sgpio_led *led, u8 *on_off)
+{
+	u8 need_update = 0;
+
+	if (led->force_off > 0) {
+		led->force_off--;
+	} else if (led->flags.recent_activity ^ led->flags.last_state) {
+		*on_off = led->flags.recent_activity;
+		led->flags.last_state = led->flags.recent_activity;
+		need_update = 1;
+	} else if ((led->flags.recent_activity == NV_ON) &&
+		   (led->flags.last_state == NV_ON) &&
+		   (led->last_cons_active >= NV_SGPIO_MAX_ACTIVITY_ON)) {
+		*on_off = NV_OFF;
+		led->flags.last_state = NV_OFF;
+		led->force_off = NV_SGPIO_MIN_FORCE_OFF;
+		need_update = 1;
+	}
+
+	if (*on_off == NV_ON)
+		led->last_cons_active++;
+	else
+		led->last_cons_active = 0;
+
+	led->flags.recent_activity = NV_OFF;
+	return need_update;
+}
+
+static void nv_sgpio_reset(u8  *pcsr)
+{
+	u8 csr;
+
+	csr = inb((unsigned long)pcsr);
+	if (GET_SGPIO_STATUS(csr) == NV_SGPIO_STATE_RESET) {
+		csr = 0;
+		csr = SET_CMD(csr, NV_SGPIO_CMD_RESET);
+		outb(csr, (unsigned long)pcsr);
+	}
+	csr = 0;
+	csr = SET_CMD(csr, NV_SGPIO_CMD_READ_PARAMS);
+	outb(csr, (unsigned long)pcsr);
+}
+
+static void nv_sgpio_host_cleanup(struct nv_host_priv *host)
+{
+	u8 csr;
+	struct nv_host_sgpio *host_sgpio;
+
+	if (!host)
+		return;
+
+	host_sgpio = &host->host_sgpio;
+	if (host_sgpio->flags.sgpio_enabled) {
+		spin_lock(host_sgpio->share.plock);
+		host_sgpio->pcb->cr0 = SET_ENABLE(host_sgpio->pcb->cr0);
+		csr = 0;
+		csr = SET_CMD(csr, NV_SGPIO_CMD_WRITE_DATA);
+		outb(csr, (unsigned long)host_sgpio->pcsr);
+		spin_unlock(host_sgpio->share.plock);
+
+		if (timer_pending(&host_sgpio->sgpio_timer))
+			del_timer(&host_sgpio->sgpio_timer);
+		host_sgpio->flags.sgpio_enabled = 0;
+		host_sgpio->pcb->scratch_space = 0;
+	}
+}
+
+static void nv_sgpio_clear_all_leds(struct ata_port *ap)
+{
+	struct nv_port_priv *port = ap->private_data;
+	struct nv_host_priv *host;
+	u8 host_offset, port_offset;
+	struct nv_host_sgpio *host_sgpio;
+
+	if (!port || !ap->host)
+		return;
+	if (!ap->host->private_data)
+		return;
+
+	host = ap->host->private_data;
+	host_sgpio = &host->host_sgpio;
+	if (!host_sgpio->flags.sgpio_enabled)
+		return;
+
+	host_offset = nv_sgpio_tx_host_offset(ap->host);
+	port_offset = nv_sgpio_tx_port_offset(ap);
+
+	spin_lock(host_sgpio->share.plock);
+	host_sgpio->pcb->tx[host_offset].tx_port[port_offset] = 0;
+	host_sgpio->flags.need_update = 1;
+	spin_unlock(host_sgpio->share.plock);
+}
+
 static int __init nv_init(void)
 {
 	return pci_register_driver(&nv_pci_driver);
