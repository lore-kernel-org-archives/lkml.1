Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYGNVkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYGNVkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbYGNVke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:40:34 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48795 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbYGNVka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:40:30 -0400
Date: Mon, 14 Jul 2008 17:40:28 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for .27
Message-ID: <20080714214028.GA15225@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c         |  331 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-core.c  |   56 +++++---
 drivers/ata/libata-eh.c    |  219 +++++++++++++++++++++++-------
 drivers/ata/libata-pmp.c   |   13 +--
 drivers/ata/libata-scsi.c  |   99 +++++++++++++-
 drivers/ata/libata-sff.c   |   15 +-
 drivers/ata/libata.h       |    2 +
 drivers/ata/pata_bf54x.c   |    6 +-
 drivers/ata/pata_legacy.c  |   10 +-
 drivers/ata/pata_qdi.c     |    2 +-
 drivers/ata/pata_scc.c     |    2 +-
 drivers/ata/pata_winbond.c |    2 +-
 drivers/ata/sata_svw.c     |   38 +++--
 include/linux/libata.h     |   55 ++++++--
 14 files changed, 716 insertions(+), 134 deletions(-)

Harvey Harrison (1):
      ata: endianness annotations in pata drivers

Kristen Carlson Accardi (1):
      libata/ahci: enclosure management support

Matthew Wilcox (2):
      [libata] Add support for VPD page b1
      AHCI: Remove an unnecessary flush from ahci_qc_issue

Pavel Machek (1):
      [libata] sata_svw: update code comments relating to data corruption

Tejun Heo (5):
      libata: consistently use msecs for time durations
      libata: improve EH retry delay handling
      libata: use ULONG_MAX to terminate reset timeout table
      libata: improve EH internal command timeout handling
      libata-eh: update atapi_eh_request_sense() to take @dev instead of @qc

Zhang Rui (1):
      AHCI: speed up resume

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5e6468a..dc7596f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -56,6 +56,12 @@ MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)
 static int ahci_enable_alpm(struct ata_port *ap,
 		enum link_pm policy);
 static void ahci_disable_alpm(struct ata_port *ap);
+static ssize_t ahci_led_show(struct ata_port *ap, char *buf);
+static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
+			      size_t size);
+static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
+					ssize_t size);
+#define MAX_SLOTS 8
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -98,6 +104,8 @@ enum {
 	HOST_IRQ_STAT		= 0x08, /* interrupt status */
 	HOST_PORTS_IMPL		= 0x0c, /* bitmap of implemented ports */
 	HOST_VERSION		= 0x10, /* AHCI spec. version compliancy */
+	HOST_EM_LOC		= 0x1c, /* Enclosure Management location */
+	HOST_EM_CTL		= 0x20, /* Enclosure Management Control */
 
 	/* HOST_CTL bits */
 	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
@@ -105,6 +113,7 @@ enum {
 	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
 
 	/* HOST_CAP bits */
+	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
 	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
 	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
 	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
@@ -202,6 +211,11 @@ enum {
 					  ATA_FLAG_IPM,
 
 	ICH_MAP				= 0x90, /* ICH MAP register */
+
+	/* em_ctl bits */
+	EM_CTL_RST			= (1 << 9), /* Reset */
+	EM_CTL_TM			= (1 << 8), /* Transmit Message */
+	EM_CTL_ALHD			= (1 << 26), /* Activity LED */
 };
 
 struct ahci_cmd_hdr {
@@ -219,12 +233,21 @@ struct ahci_sg {
 	__le32			flags_size;
 };
 
+struct ahci_em_priv {
+	enum sw_activity blink_policy;
+	struct timer_list timer;
+	unsigned long saved_activity;
+	unsigned long activity;
+	unsigned long led_state;
+};
+
 struct ahci_host_priv {
 	unsigned int		flags;		/* AHCI_HFLAG_* */
 	u32			cap;		/* cap to use */
 	u32			port_map;	/* port map to use */
 	u32			saved_cap;	/* saved initial cap */
 	u32			saved_port_map;	/* saved initial port_map */
+	u32 			em_loc; /* enclosure management location */
 };
 
 struct ahci_port_priv {
@@ -240,6 +263,8 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
 	u32 			intr_mask;	/* interrupts to enable */
+	struct ahci_em_priv	em_priv[MAX_SLOTS];/* enclosure management info
+					 	 * per PM slot */
 };
 
 static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
@@ -277,9 +302,20 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
 static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
+static ssize_t ahci_activity_show(struct ata_device *dev, char *buf);
+static ssize_t ahci_activity_store(struct ata_device *dev,
+				   enum sw_activity val);
+static void ahci_init_sw_activity(struct ata_link *link);
 
 static struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
+	&dev_attr_em_message_type,
+	&dev_attr_em_message,
+	NULL
+};
+
+static struct device_attribute *ahci_sdev_attrs[] = {
+	&dev_attr_sw_activity,
 	NULL
 };
 
@@ -289,6 +325,7 @@ static struct scsi_host_template ahci_sht = {
 	.sg_tablesize		= AHCI_MAX_SG,
 	.dma_boundary		= AHCI_DMA_BOUNDARY,
 	.shost_attrs		= ahci_shost_attrs,
+	.sdev_attrs		= ahci_sdev_attrs,
 };
 
 static struct ata_port_operations ahci_ops = {
@@ -316,6 +353,10 @@ static struct ata_port_operations ahci_ops = {
 
 	.enable_pm		= ahci_enable_alpm,
 	.disable_pm		= ahci_disable_alpm,
+	.em_show		= ahci_led_show,
+	.em_store		= ahci_led_store,
+	.sw_activity_show	= ahci_activity_show,
+	.sw_activity_store	= ahci_activity_store,
 #ifdef CONFIG_PM
 	.port_suspend		= ahci_port_suspend,
 	.port_resume		= ahci_port_resume,
@@ -561,6 +602,11 @@ static struct pci_driver ahci_pci_driver = {
 #endif
 };
 
+static int ahci_em_messages = 1;
+module_param(ahci_em_messages, int, 0444);
+/* add other LED protocol types when they become supported */
+MODULE_PARM_DESC(ahci_em_messages,
+	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");
 
 static inline int ahci_nr_ports(u32 cap)
 {
@@ -1031,11 +1077,28 @@ static void ahci_power_down(struct ata_port *ap)
 
 static void ahci_start_port(struct ata_port *ap)
 {
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ata_link *link;
+	struct ahci_em_priv *emp;
+
 	/* enable FIS reception */
 	ahci_start_fis_rx(ap);
 
 	/* enable DMA */
 	ahci_start_engine(ap);
+
+	/* turn on LEDs */
+	if (ap->flags & ATA_FLAG_EM) {
+		ata_port_for_each_link(link, ap) {
+			emp = &pp->em_priv[link->pmp];
+			ahci_transmit_led_message(ap, emp->led_state, 4);
+		}
+	}
+
+	if (ap->flags & ATA_FLAG_SW_ACTIVITY)
+		ata_port_for_each_link(link, ap)
+			ahci_init_sw_activity(link);
+
 }
 
 static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
@@ -1079,12 +1142,15 @@ static int ahci_reset_controller(struct ata_host *host)
 			readl(mmio + HOST_CTL); /* flush */
 		}
 
-		/* reset must complete within 1 second, or
+		/*
+		 * to perform host reset, OS should set HOST_RESET
+		 * and poll until this bit is read to be "0".
+		 * reset must complete within 1 second, or
 		 * the hardware should be considered fried.
 		 */
-		ssleep(1);
+		tmp = ata_wait_register(mmio + HOST_CTL, HOST_RESET,
+					HOST_RESET, 10, 1000);
 
-		tmp = readl(mmio + HOST_CTL);
 		if (tmp & HOST_RESET) {
 			dev_printk(KERN_ERR, host->dev,
 				   "controller reset failed (0x%x)\n", tmp);
@@ -1116,6 +1182,230 @@ static int ahci_reset_controller(struct ata_host *host)
 	return 0;
 }
 
+static void ahci_sw_activity(struct ata_link *link)
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+
+	if (!(link->flags & ATA_LFLAG_SW_ACTIVITY))
+		return;
+
+	emp->activity++;
+	if (!timer_pending(&emp->timer))
+		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(10));
+}
+
+static void ahci_sw_activity_blink(unsigned long arg)
+{
+	struct ata_link *link = (struct ata_link *)arg;
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+	unsigned long led_message = emp->led_state;
+	u32 activity_led_state;
+
+	led_message &= 0xffff0000;
+	led_message |= ap->port_no | (link->pmp << 8);
+
+	/* check to see if we've had activity.  If so,
+	 * toggle state of LED and reset timer.  If not,
+	 * turn LED to desired idle state.
+	 */
+	if (emp->saved_activity != emp->activity) {
+		emp->saved_activity = emp->activity;
+		/* get the current LED state */
+		activity_led_state = led_message & 0x00010000;
+
+		if (activity_led_state)
+			activity_led_state = 0;
+		else
+			activity_led_state = 1;
+
+		/* clear old state */
+		led_message &= 0xfff8ffff;
+
+		/* toggle state */
+		led_message |= (activity_led_state << 16);
+		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(100));
+	} else {
+		/* switch to idle */
+		led_message &= 0xfff8ffff;
+		if (emp->blink_policy == BLINK_OFF)
+			led_message |= (1 << 16);
+	}
+	ahci_transmit_led_message(ap, led_message, 4);
+}
+
+static void ahci_init_sw_activity(struct ata_link *link)
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+
+	/* init activity stats, setup timer */
+	emp->saved_activity = emp->activity = 0;
+	setup_timer(&emp->timer, ahci_sw_activity_blink, (unsigned long)link);
+
+	/* check our blink policy and set flag for link if it's enabled */
+	if (emp->blink_policy)
+		link->flags |= ATA_LFLAG_SW_ACTIVITY;
+}
+
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
+static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
+					ssize_t size)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	u32 em_ctl;
+	u32 message[] = {0, 0};
+	unsigned int flags;
+	int pmp;
+	struct ahci_em_priv *emp;
+
+	/* get the slot number from the message */
+	pmp = (state & 0x0000ff00) >> 8;
+	if (pmp < MAX_SLOTS)
+		emp = &pp->em_priv[pmp];
+	else
+		return -EINVAL;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	/*
+	 * if we are still busy transmitting a previous message,
+	 * do not allow
+	 */
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if (em_ctl & EM_CTL_TM) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		return -EINVAL;
+	}
+
+	/*
+	 * create message header - this is all zero except for
+	 * the message size, which is 4 bytes.
+	 */
+	message[0] |= (4 << 8);
+
+	/* ignore 0:4 of byte zero, fill in port info yourself */
+	message[1] = ((state & 0xfffffff0) | ap->port_no);
+
+	/* write message to EM_LOC */
+	writel(message[0], mmio + hpriv->em_loc);
+	writel(message[1], mmio + hpriv->em_loc+4);
+
+	/* save off new led state for port/slot */
+	emp->led_state = message[1];
+
+	/*
+	 * tell hardware to transmit the message
+	 */
+	writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
+
+	spin_unlock_irqrestore(ap->lock, flags);
+	return size;
+}
+
+static ssize_t ahci_led_show(struct ata_port *ap, char *buf)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ata_link *link;
+	struct ahci_em_priv *emp;
+	int rc = 0;
+
+	ata_port_for_each_link(link, ap) {
+		emp = &pp->em_priv[link->pmp];
+		rc += sprintf(buf, "%lx\n", emp->led_state);
+	}
+	return rc;
+}
+
+static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
+				size_t size)
+{
+	int state;
+	int pmp;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp;
+
+	state = simple_strtoul(buf, NULL, 0);
+
+	/* get the slot number from the message */
+	pmp = (state & 0x0000ff00) >> 8;
+	if (pmp < MAX_SLOTS)
+		emp = &pp->em_priv[pmp];
+	else
+		return -EINVAL;
+
+	/* mask off the activity bits if we are in sw_activity
+	 * mode, user should turn off sw_activity before setting
+	 * activity led through em_message
+	 */
+	if (emp->blink_policy)
+		state &= 0xfff8ffff;
+
+	return ahci_transmit_led_message(ap, state, size);
+}
+
+static ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
+{
+	struct ata_link *link = dev->link;
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+	u32 port_led_state = emp->led_state;
+
+	/* save the desired Activity LED behavior */
+	if (val == OFF) {
+		/* clear LFLAG */
+		link->flags &= ~(ATA_LFLAG_SW_ACTIVITY);
+
+		/* set the LED to OFF */
+		port_led_state &= 0xfff80000;
+		port_led_state |= (ap->port_no | (link->pmp << 8));
+		ahci_transmit_led_message(ap, port_led_state, 4);
+	} else {
+		link->flags |= ATA_LFLAG_SW_ACTIVITY;
+		if (val == BLINK_OFF) {
+			/* set LED to ON for idle */
+			port_led_state &= 0xfff80000;
+			port_led_state |= (ap->port_no | (link->pmp << 8));
+			port_led_state |= 0x00010000; /* check this */
+			ahci_transmit_led_message(ap, port_led_state, 4);
+		}
+	}
+	emp->blink_policy = val;
+	return 0;
+}
+
+static ssize_t ahci_activity_show(struct ata_device *dev, char *buf)
+{
+	struct ata_link *link = dev->link;
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+
+	/* display the saved value of activity behavior for this
+	 * disk.
+	 */
+	return sprintf(buf, "%d\n", emp->blink_policy);
+}
+
 static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
 			   int port_no, void __iomem *mmio,
 			   void __iomem *port_mmio)
@@ -1846,7 +2136,8 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 	if (qc->tf.protocol == ATA_PROT_NCQ)
 		writel(1 << qc->tag, port_mmio + PORT_SCR_ACT);
 	writel(1 << qc->tag, port_mmio + PORT_CMD_ISSUE);
-	readl(port_mmio + PORT_CMD_ISSUE);	/* flush */
+
+	ahci_sw_activity(qc->dev->link);
 
 	return 0;
 }
@@ -2154,7 +2445,8 @@ static void ahci_print_info(struct ata_host *host)
 	dev_printk(KERN_INFO, &pdev->dev,
 		"flags: "
 		"%s%s%s%s%s%s%s"
-		"%s%s%s%s%s%s%s\n"
+		"%s%s%s%s%s%s%s"
+		"%s\n"
 		,
 
 		cap & (1 << 31) ? "64bit " : "",
@@ -2171,7 +2463,8 @@ static void ahci_print_info(struct ata_host *host)
 		cap & (1 << 17) ? "pmp " : "",
 		cap & (1 << 15) ? "pio " : "",
 		cap & (1 << 14) ? "slum " : "",
-		cap & (1 << 13) ? "part " : ""
+		cap & (1 << 13) ? "part " : "",
+		cap & (1 << 6) ? "ems ": ""
 		);
 }
 
@@ -2291,6 +2584,24 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;
 
+	if (ahci_em_messages && (hpriv->cap & HOST_CAP_EMS)) {
+		u8 messages;
+		void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+		u32 em_loc = readl(mmio + HOST_EM_LOC);
+		u32 em_ctl = readl(mmio + HOST_EM_CTL);
+
+		messages = (em_ctl & 0x000f0000) >> 16;
+
+		/* we only support LED message type right now */
+		if ((messages & 0x01) && (ahci_em_messages == 1)) {
+			/* store em_loc */
+			hpriv->em_loc = ((em_loc >> 16) * 4);
+			pi.flags |= ATA_FLAG_EM;
+			if (!(em_ctl & EM_CTL_ALHD))
+				pi.flags |= ATA_FLAG_SW_ACTIVITY;
+		}
+	}
+
 	/* CAP.NP sometimes indicate the index of the last enabled
 	 * port, at other times, that of the last possible port, so
 	 * determining the maximum port number requires looking at
@@ -2304,6 +2615,9 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	host->iomap = pcim_iomap_table(pdev);
 	host->private_data = hpriv;
 
+	if (pi.flags & ATA_FLAG_EM)
+		ahci_reset_em(host);
+
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
@@ -2314,6 +2628,11 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* set initial link pm policy */
 		ap->pm_policy = NOT_AVAILABLE;
 
+		/* set enclosure management message type */
+		if (ap->flags & ATA_FLAG_EM)
+			ap->em_message_type = ahci_em_messages;
+
+
 		/* disabled/not-implemented port */
 		if (!(hpriv->port_map & (1 << i)))
 			ap->ops = &ata_dummy_port_ops;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 303fc0d..9bef1a8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -54,7 +54,6 @@
 #include <linux/completion.h>
 #include <linux/suspend.h>
 #include <linux/workqueue.h>
-#include <linux/jiffies.h>
 #include <linux/scatterlist.h>
 #include <linux/io.h>
 #include <scsi/scsi.h>
@@ -145,7 +144,7 @@ static int libata_dma_mask = ATA_DMA_MASK_ATA|ATA_DMA_MASK_ATAPI|ATA_DMA_MASK_CF
 module_param_named(dma, libata_dma_mask, int, 0444);
 MODULE_PARM_DESC(dma, "DMA enable/disable (0x1==ATA, 0x2==ATAPI, 0x4==CF)");
 
-static int ata_probe_timeout = ATA_TMOUT_INTERNAL / HZ;
+static int ata_probe_timeout;
 module_param(ata_probe_timeout, int, 0444);
 MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");
 
@@ -1533,7 +1532,7 @@ unsigned long ata_id_xfermask(const u16 *id)
  *	@ap: The ata_port to queue port_task for
  *	@fn: workqueue function to be scheduled
  *	@data: data for @fn to use
- *	@delay: delay time for workqueue function
+ *	@delay: delay time in msecs for workqueue function
  *
  *	Schedule @fn(@data) for execution after @delay jiffies using
  *	port_task.  There is one port_task per port and it's the
@@ -1552,7 +1551,7 @@ void ata_pio_queue_task(struct ata_port *ap, void *data, unsigned long delay)
 	ap->port_task_data = data;
 
 	/* may fail if ata_port_flush_task() in progress */
-	queue_delayed_work(ata_wq, &ap->port_task, delay);
+	queue_delayed_work(ata_wq, &ap->port_task, msecs_to_jiffies(delay));
 }
 
 /**
@@ -1612,6 +1611,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	struct ata_link *link = dev->link;
 	struct ata_port *ap = link->ap;
 	u8 command = tf->command;
+	int auto_timeout = 0;
 	struct ata_queued_cmd *qc;
 	unsigned int tag, preempted_tag;
 	u32 preempted_sactive, preempted_qc_active;
@@ -1684,8 +1684,14 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (!timeout)
-		timeout = ata_probe_timeout * 1000 / HZ;
+	if (!timeout) {
+		if (ata_probe_timeout)
+			timeout = ata_probe_timeout * 1000;
+		else {
+			timeout = ata_internal_cmd_timeout(dev, command);
+			auto_timeout = 1;
+		}
+	}
 
 	rc = wait_for_completion_timeout(&wait, msecs_to_jiffies(timeout));
 
@@ -1761,6 +1767,9 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
+	if ((err_mask & AC_ERR_TIMEOUT) && auto_timeout)
+		ata_internal_cmd_timed_out(dev, command);
+
 	return err_mask;
 }
 
@@ -3319,7 +3328,7 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 		   int (*check_ready)(struct ata_link *link))
 {
 	unsigned long start = jiffies;
-	unsigned long nodev_deadline = start + ATA_TMOUT_FF_WAIT;
+	unsigned long nodev_deadline = ata_deadline(start, ATA_TMOUT_FF_WAIT);
 	int warned = 0;
 
 	if (time_after(nodev_deadline, deadline))
@@ -3387,7 +3396,7 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
 				int (*check_ready)(struct ata_link *link))
 {
-	msleep(ATA_WAIT_AFTER_RESET_MSECS);
+	msleep(ATA_WAIT_AFTER_RESET);
 
 	return ata_wait_ready(link, deadline, check_ready);
 }
@@ -3417,13 +3426,13 @@ int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
 int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 		       unsigned long deadline)
 {
-	unsigned long interval_msec = params[0];
-	unsigned long duration = msecs_to_jiffies(params[1]);
+	unsigned long interval = params[0];
+	unsigned long duration = params[1];
 	unsigned long last_jiffies, t;
 	u32 last, cur;
 	int rc;
 
-	t = jiffies + msecs_to_jiffies(params[2]);
+	t = ata_deadline(jiffies, params[2]);
 	if (time_before(t, deadline))
 		deadline = t;
 
@@ -3435,7 +3444,7 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 	last_jiffies = jiffies;
 
 	while (1) {
-		msleep(interval_msec);
+		msleep(interval);
 		if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))
 			return rc;
 		cur &= 0xf;
@@ -3444,7 +3453,8 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 		if (cur == last) {
 			if (cur == 1 && time_before(jiffies, deadline))
 				continue;
-			if (time_after(jiffies, last_jiffies + duration))
+			if (time_after(jiffies,
+				       ata_deadline(last_jiffies, duration)))
 				return 0;
 			continue;
 		}
@@ -3636,7 +3646,8 @@ int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
 		if (check_ready) {
 			unsigned long pmp_deadline;
 
-			pmp_deadline = jiffies + ATA_TMOUT_PMP_SRST_WAIT;
+			pmp_deadline = ata_deadline(jiffies,
+						    ATA_TMOUT_PMP_SRST_WAIT);
 			if (time_after(pmp_deadline, deadline))
 				pmp_deadline = deadline;
 			ata_wait_ready(link, pmp_deadline, check_ready);
@@ -6073,8 +6084,6 @@ static void __init ata_parse_force_param(void)
 
 static int __init ata_init(void)
 {
-	ata_probe_timeout *= HZ;
-
 	ata_parse_force_param();
 
 	ata_wq = create_workqueue("ata");
@@ -6127,8 +6136,8 @@ int ata_ratelimit(void)
  *	@reg: IO-mapped register
  *	@mask: Mask to apply to read register value
  *	@val: Wait condition
- *	@interval_msec: polling interval in milliseconds
- *	@timeout_msec: timeout in milliseconds
+ *	@interval: polling interval in milliseconds
+ *	@timeout: timeout in milliseconds
  *
  *	Waiting for some bits of register to change is a common
  *	operation for ATA controllers.  This function reads 32bit LE
@@ -6146,10 +6155,9 @@ int ata_ratelimit(void)
  *	The final register value.
  */
 u32 ata_wait_register(void __iomem *reg, u32 mask, u32 val,
-		      unsigned long interval_msec,
-		      unsigned long timeout_msec)
+		      unsigned long interval, unsigned long timeout)
 {
-	unsigned long timeout;
+	unsigned long deadline;
 	u32 tmp;
 
 	tmp = ioread32(reg);
@@ -6158,10 +6166,10 @@ u32 ata_wait_register(void __iomem *reg, u32 mask, u32 val,
 	 * preceding writes reach the controller before starting to
 	 * eat away the timeout.
 	 */
-	timeout = jiffies + (timeout_msec * HZ) / 1000;
+	deadline = ata_deadline(jiffies, timeout);
 
-	while ((tmp & mask) == val && time_before(jiffies, timeout)) {
-		msleep(interval_msec);
+	while ((tmp & mask) == val && time_before(jiffies, deadline)) {
+		msleep(interval);
 		tmp = ioread32(reg);
 	}
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 7894d83..58bdc53 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -66,15 +66,19 @@ enum {
 	ATA_ECAT_DUBIOUS_TOUT_HSM	= 6,
 	ATA_ECAT_DUBIOUS_UNK_DEV	= 7,
 	ATA_ECAT_NR			= 8,
-};
 
-/* Waiting in ->prereset can never be reliable.  It's sometimes nice
- * to wait there but it can't be depended upon; otherwise, we wouldn't
- * be resetting.  Just give it enough time for most drives to spin up.
- */
-enum {
-	ATA_EH_PRERESET_TIMEOUT		= 10 * HZ,
-	ATA_EH_FASTDRAIN_INTERVAL	= 3 * HZ,
+	ATA_EH_CMD_DFL_TIMEOUT		=  5000,
+
+	/* always put at least this amount of time between resets */
+	ATA_EH_RESET_COOL_DOWN		=  5000,
+
+	/* Waiting in ->prereset can never be reliable.  It's
+	 * sometimes nice to wait there but it can't be depended upon;
+	 * otherwise, we wouldn't be resetting.  Just give it enough
+	 * time for most drives to spin up.
+	 */
+	ATA_EH_PRERESET_TIMEOUT		= 10000,
+	ATA_EH_FASTDRAIN_INTERVAL	=  3000,
 };
 
 /* The following table determines how we sequence resets.  Each entry
@@ -84,12 +88,59 @@ enum {
  * are mostly for error handling, hotplug and retarded devices.
  */
 static const unsigned long ata_eh_reset_timeouts[] = {
-	10 * HZ,	/* most drives spin up by 10sec */
-	10 * HZ,	/* > 99% working drives spin up before 20sec */
-	35 * HZ,	/* give > 30 secs of idleness for retarded devices */
-	5 * HZ,		/* and sweet one last chance */
-	/* > 1 min has elapsed, give up */
+	10000,	/* most drives spin up by 10sec */
+	10000,	/* > 99% working drives spin up before 20sec */
+	35000,	/* give > 30 secs of idleness for retarded devices */
+	 5000,	/* and sweet one last chance */
+	ULONG_MAX, /* > 1 min has elapsed, give up */
+};
+
+static const unsigned long ata_eh_identify_timeouts[] = {
+	 5000,	/* covers > 99% of successes and not too boring on failures */
+	10000,  /* combined time till here is enough even for media access */
+	30000,	/* for true idiots */
+	ULONG_MAX,
+};
+
+static const unsigned long ata_eh_other_timeouts[] = {
+	 5000,	/* same rationale as identify timeout */
+	10000,	/* ditto */
+	/* but no merciful 30sec for other commands, it just isn't worth it */
+	ULONG_MAX,
+};
+
+struct ata_eh_cmd_timeout_ent {
+	const u8		*commands;
+	const unsigned long	*timeouts;
+};
+
+/* The following table determines timeouts to use for EH internal
+ * commands.  Each table entry is a command class and matches the
+ * commands the entry applies to and the timeout table to use.
+ *
+ * On the retry after a command timed out, the next timeout value from
+ * the table is used.  If the table doesn't contain further entries,
+ * the last value is used.
+ *
+ * ehc->cmd_timeout_idx keeps track of which timeout to use per
+ * command class, so if SET_FEATURES times out on the first try, the
+ * next try will use the second timeout value only for that class.
+ */
+#define CMDS(cmds...)	(const u8 []){ cmds, 0 }
+static const struct ata_eh_cmd_timeout_ent
+ata_eh_cmd_timeout_table[ATA_EH_CMD_TIMEOUT_TABLE_SIZE] = {
+	{ .commands = CMDS(ATA_CMD_ID_ATA, ATA_CMD_ID_ATAPI),
+	  .timeouts = ata_eh_identify_timeouts, },
+	{ .commands = CMDS(ATA_CMD_READ_NATIVE_MAX, ATA_CMD_READ_NATIVE_MAX_EXT),
+	  .timeouts = ata_eh_other_timeouts, },
+	{ .commands = CMDS(ATA_CMD_SET_MAX, ATA_CMD_SET_MAX_EXT),
+	  .timeouts = ata_eh_other_timeouts, },
+	{ .commands = CMDS(ATA_CMD_SET_FEATURES),
+	  .timeouts = ata_eh_other_timeouts, },
+	{ .commands = CMDS(ATA_CMD_INIT_DEV_PARAMS),
+	  .timeouts = ata_eh_other_timeouts, },
 };
+#undef CMDS
 
 static void __ata_port_freeze(struct ata_port *ap);
 #ifdef CONFIG_PM
@@ -236,6 +287,73 @@ void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
 
 #endif /* CONFIG_PCI */
 
+static int ata_lookup_timeout_table(u8 cmd)
+{
+	int i;
+
+	for (i = 0; i < ATA_EH_CMD_TIMEOUT_TABLE_SIZE; i++) {
+		const u8 *cur;
+
+		for (cur = ata_eh_cmd_timeout_table[i].commands; *cur; cur++)
+			if (*cur == cmd)
+				return i;
+	}
+
+	return -1;
+}
+
+/**
+ *	ata_internal_cmd_timeout - determine timeout for an internal command
+ *	@dev: target device
+ *	@cmd: internal command to be issued
+ *
+ *	Determine timeout for internal command @cmd for @dev.
+ *
+ *	LOCKING:
+ *	EH context.
+ *
+ *	RETURNS:
+ *	Determined timeout.
+ */
+unsigned long ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd)
+{
+	struct ata_eh_context *ehc = &dev->link->eh_context;
+	int ent = ata_lookup_timeout_table(cmd);
+	int idx;
+
+	if (ent < 0)
+		return ATA_EH_CMD_DFL_TIMEOUT;
+
+	idx = ehc->cmd_timeout_idx[dev->devno][ent];
+	return ata_eh_cmd_timeout_table[ent].timeouts[idx];
+}
+
+/**
+ *	ata_internal_cmd_timed_out - notification for internal command timeout
+ *	@dev: target device
+ *	@cmd: internal command which timed out
+ *
+ *	Notify EH that internal command @cmd for @dev timed out.  This
+ *	function should be called only for commands whose timeouts are
+ *	determined using ata_internal_cmd_timeout().
+ *
+ *	LOCKING:
+ *	EH context.
+ */
+void ata_internal_cmd_timed_out(struct ata_device *dev, u8 cmd)
+{
+	struct ata_eh_context *ehc = &dev->link->eh_context;
+	int ent = ata_lookup_timeout_table(cmd);
+	int idx;
+
+	if (ent < 0)
+		return;
+
+	idx = ehc->cmd_timeout_idx[dev->devno][ent];
+	if (ata_eh_cmd_timeout_table[ent].timeouts[idx + 1] != ULONG_MAX)
+		ehc->cmd_timeout_idx[dev->devno][ent]++;
+}
+
 static void ata_ering_record(struct ata_ering *ering, unsigned int eflags,
 			     unsigned int err_mask)
 {
@@ -486,6 +604,9 @@ void ata_scsi_error(struct Scsi_Host *host)
 				if (ata_ncq_enabled(dev))
 					ehc->saved_ncq_enabled |= 1 << devno;
 			}
+
+			/* set last reset timestamp to some time in the past */
+			ehc->last_reset = jiffies - 60 * HZ;
 		}
 
 		ap->pflags |= ATA_PFLAG_EH_IN_PROGRESS;
@@ -641,7 +762,7 @@ void ata_eh_fastdrain_timerfn(unsigned long arg)
 		/* some qcs have finished, give it another chance */
 		ap->fastdrain_cnt = cnt;
 		ap->fastdrain_timer.expires =
-			jiffies + ATA_EH_FASTDRAIN_INTERVAL;
+			ata_deadline(jiffies, ATA_EH_FASTDRAIN_INTERVAL);
 		add_timer(&ap->fastdrain_timer);
 	}
 
@@ -681,7 +802,8 @@ static void ata_eh_set_pending(struct ata_port *ap, int fastdrain)
 
 	/* activate fast drain */
 	ap->fastdrain_cnt = cnt;
-	ap->fastdrain_timer.expires = jiffies + ATA_EH_FASTDRAIN_INTERVAL;
+	ap->fastdrain_timer.expires =
+		ata_deadline(jiffies, ATA_EH_FASTDRAIN_INTERVAL);
 	add_timer(&ap->fastdrain_timer);
 }
 
@@ -1238,6 +1360,7 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
  *	atapi_eh_request_sense - perform ATAPI REQUEST_SENSE
  *	@dev: device to perform REQUEST_SENSE to
  *	@sense_buf: result sense data buffer (SCSI_SENSE_BUFFERSIZE bytes long)
+ *	@dfl_sense_key: default sense key to use
  *
  *	Perform ATAPI REQUEST_SENSE after the device reported CHECK
  *	SENSE.  This function is EH helper.
@@ -1248,13 +1371,13 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
  *	RETURNS:
  *	0 on success, AC_ERR_* mask on failure
  */
-static unsigned int atapi_eh_request_sense(struct ata_queued_cmd *qc)
+static unsigned int atapi_eh_request_sense(struct ata_device *dev,
+					   u8 *sense_buf, u8 dfl_sense_key)
 {
-	struct ata_device *dev = qc->dev;
-	unsigned char *sense_buf = qc->scsicmd->sense_buffer;
+	u8 cdb[ATAPI_CDB_LEN] =
+		{ REQUEST_SENSE, 0, 0, 0, SCSI_SENSE_BUFFERSIZE, 0 };
 	struct ata_port *ap = dev->link->ap;
 	struct ata_taskfile tf;
-	u8 cdb[ATAPI_CDB_LEN];
 
 	DPRINTK("ATAPI request sense\n");
 
@@ -1265,15 +1388,11 @@ static unsigned int atapi_eh_request_sense(struct ata_queued_cmd *qc)
 	 * for the case where they are -not- overwritten
 	 */
 	sense_buf[0] = 0x70;
-	sense_buf[2] = qc->result_tf.feature >> 4;
+	sense_buf[2] = dfl_sense_key;
 
 	/* some devices time out if garbage left in tf */
 	ata_tf_init(dev, &tf);
 
-	memset(cdb, 0, ATAPI_CDB_LEN);
-	cdb[0] = REQUEST_SENSE;
-	cdb[4] = SCSI_SENSE_BUFFERSIZE;
-
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.command = ATA_CMD_PACKET;
 
@@ -1445,7 +1564,9 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 
 	case ATA_DEV_ATAPI:
 		if (!(qc->ap->pflags & ATA_PFLAG_FROZEN)) {
-			tmp = atapi_eh_request_sense(qc);
+			tmp = atapi_eh_request_sense(qc->dev,
+						qc->scsicmd->sense_buffer,
+						qc->result_tf.feature >> 4);
 			if (!tmp) {
 				/* ATA_QCFLAG_SENSE_VALID is used to
 				 * tell atapi_qc_complete() that sense
@@ -2071,13 +2192,12 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		 ata_prereset_fn_t prereset, ata_reset_fn_t softreset,
 		 ata_reset_fn_t hardreset, ata_postreset_fn_t postreset)
 {
-	const int max_tries = ARRAY_SIZE(ata_eh_reset_timeouts);
 	struct ata_port *ap = link->ap;
 	struct ata_eh_context *ehc = &link->eh_context;
 	unsigned int *classes = ehc->classes;
 	unsigned int lflags = link->flags;
 	int verbose = !(ehc->i.flags & ATA_EHI_QUIET);
-	int try = 0;
+	int max_tries = 0, try = 0;
 	struct ata_device *dev;
 	unsigned long deadline, now;
 	ata_reset_fn_t reset;
@@ -2088,11 +2208,20 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	/*
 	 * Prepare to reset
 	 */
+	while (ata_eh_reset_timeouts[max_tries] != ULONG_MAX)
+		max_tries++;
+
+	now = jiffies;
+	deadline = ata_deadline(ehc->last_reset, ATA_EH_RESET_COOL_DOWN);
+	if (time_before(now, deadline))
+		schedule_timeout_uninterruptible(deadline - now);
+
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags |= ATA_PFLAG_RESETTING;
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
+	ehc->last_reset = jiffies;
 
 	ata_link_for_each_dev(dev, link) {
 		/* If we issue an SRST then an ATA drive (not ATAPI)
@@ -2125,7 +2254,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	}
 
 	if (prereset) {
-		rc = prereset(link, jiffies + ATA_EH_PRERESET_TIMEOUT);
+		rc = prereset(link,
+			      ata_deadline(jiffies, ATA_EH_PRERESET_TIMEOUT));
 		if (rc) {
 			if (rc == -ENOENT) {
 				ata_link_printk(link, KERN_DEBUG,
@@ -2157,10 +2287,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	/*
 	 * Perform reset
 	 */
+	ehc->last_reset = jiffies;
 	if (ata_is_host_link(link))
 		ata_eh_freeze_port(ap);
 
-	deadline = jiffies + ata_eh_reset_timeouts[try++];
+	deadline = ata_deadline(jiffies, ata_eh_reset_timeouts[try++]);
 
 	if (reset) {
 		if (verbose)
@@ -2277,6 +2408,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 	/* reset successful, schedule revalidation */
 	ata_eh_done(link, NULL, ATA_EH_RESET);
+	ehc->last_reset = jiffies;
 	ehc->i.action |= ATA_EH_REVALIDATE;
 
 	rc = 0;
@@ -2303,9 +2435,9 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	if (time_before(now, deadline)) {
 		unsigned long delta = deadline - now;
 
-		ata_link_printk(link, KERN_WARNING, "reset failed "
-				"(errno=%d), retrying in %u secs\n",
-				rc, (jiffies_to_msecs(delta) + 999) / 1000);
+		ata_link_printk(link, KERN_WARNING,
+			"reset failed (errno=%d), retrying in %u secs\n",
+			rc, DIV_ROUND_UP(jiffies_to_msecs(delta), 1000));
 
 		while (delta)
 			delta = schedule_timeout_uninterruptible(delta);
@@ -2583,8 +2715,11 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 			ata_eh_detach_dev(dev);
 
 		/* schedule probe if necessary */
-		if (ata_eh_schedule_probe(dev))
+		if (ata_eh_schedule_probe(dev)) {
 			ehc->tries[dev->devno] = ATA_EH_DEV_TRIES;
+			memset(ehc->cmd_timeout_idx[dev->devno], 0,
+			       sizeof(ehc->cmd_timeout_idx[dev->devno]));
+		}
 
 		return 1;
 	} else {
@@ -2622,7 +2757,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 {
 	struct ata_link *link;
 	struct ata_device *dev;
-	int nr_failed_devs, nr_disabled_devs;
+	int nr_failed_devs;
 	int rc;
 	unsigned long flags;
 
@@ -2665,7 +2800,6 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
  retry:
 	rc = 0;
 	nr_failed_devs = 0;
-	nr_disabled_devs = 0;
 
 	/* if UNLOADING, finish immediately */
 	if (ap->pflags & ATA_PFLAG_UNLOADING)
@@ -2732,8 +2866,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 
 dev_fail:
 		nr_failed_devs++;
-		if (ata_eh_handle_dev_fail(dev, rc))
-			nr_disabled_devs++;
+		ata_eh_handle_dev_fail(dev, rc);
 
 		if (ap->pflags & ATA_PFLAG_FROZEN) {
 			/* PMP reset requires working host port.
@@ -2745,18 +2878,8 @@ dev_fail:
 		}
 	}
 
-	if (nr_failed_devs) {
-		if (nr_failed_devs != nr_disabled_devs) {
-			ata_port_printk(ap, KERN_WARNING, "failed to recover "
-					"some devices, retrying in 5 secs\n");
-			ssleep(5);
-		} else {
-			/* no device left to recover, repeat fast */
-			msleep(500);
-		}
-
+	if (nr_failed_devs)
 		goto retry;
-	}
 
  out:
 	if (rc && r_failed_link)
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 7daf4c0..b65db30 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -727,19 +727,12 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 		}
 
 		if (tries) {
-			int sleep = ehc->i.flags & ATA_EHI_DID_RESET;
-
 			/* consecutive revalidation failures? speed down */
 			if (reval_failed)
 				sata_down_spd_limit(link);
 			else
 				reval_failed = 1;
 
-			ata_dev_printk(dev, KERN_WARNING,
-				       "retrying reset%s\n",
-				       sleep ? " in 5 secs" : "");
-			if (sleep)
-				ssleep(5);
 			ehc->i.action |= ATA_EH_RESET;
 			goto retry;
 		} else {
@@ -785,7 +778,8 @@ static int sata_pmp_eh_handle_disabled_links(struct ata_port *ap)
 		 * SError.N working.
 		 */
 		sata_link_hardreset(link, sata_deb_timing_normal,
-				jiffies + ATA_TMOUT_INTERNAL_QUICK, NULL, NULL);
+				ata_deadline(jiffies, ATA_TMOUT_INTERNAL_QUICK),
+				NULL, NULL);
 
 		/* unconditionally clear SError.N */
 		rc = sata_scr_write(link, SCR_ERROR, SERR_PHYRDY_CHG);
@@ -990,10 +984,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 		goto retry;
 
 	if (--pmp_tries) {
-		ata_port_printk(ap, KERN_WARNING,
-				"failed to recover PMP, retrying in 5 secs\n");
 		pmp_ehc->i.action |= ATA_EH_RESET;
-		ssleep(5);
 		goto retry;
 	}
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 57a4364..479c29e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -190,6 +190,85 @@ static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 	scsi_build_sense_buffer(0, cmd->sense_buffer, sk, asc, ascq);
 }
 
+static ssize_t
+ata_scsi_em_message_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	if (ap->ops->em_store && (ap->flags & ATA_FLAG_EM))
+		return ap->ops->em_store(ap, buf, count);
+	return -EINVAL;
+}
+
+static ssize_t
+ata_scsi_em_message_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+
+	if (ap->ops->em_show && (ap->flags & ATA_FLAG_EM))
+		return ap->ops->em_show(ap, buf);
+	return -EINVAL;
+}
+DEVICE_ATTR(em_message, S_IRUGO | S_IWUGO,
+		ata_scsi_em_message_show, ata_scsi_em_message_store);
+EXPORT_SYMBOL_GPL(dev_attr_em_message);
+
+static ssize_t
+ata_scsi_em_message_type_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+
+	return snprintf(buf, 23, "%d\n", ap->em_message_type);
+}
+DEVICE_ATTR(em_message_type, S_IRUGO,
+		  ata_scsi_em_message_type_show, NULL);
+EXPORT_SYMBOL_GPL(dev_attr_em_message_type);
+
+static ssize_t
+ata_scsi_activity_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
+
+	if (ap->ops->sw_activity_show && (ap->flags & ATA_FLAG_SW_ACTIVITY))
+		return ap->ops->sw_activity_show(atadev, buf);
+	return -EINVAL;
+}
+
+static ssize_t
+ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
+	enum sw_activity val;
+	int rc;
+
+	if (ap->ops->sw_activity_store && (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
+		val = simple_strtoul(buf, NULL, 0);
+		switch (val) {
+		case OFF: case BLINK_ON: case BLINK_OFF:
+			rc = ap->ops->sw_activity_store(atadev, val);
+			if (!rc)
+				return count;
+			else
+				return rc;
+		}
+	}
+	return -EINVAL;
+}
+DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_show,
+			ata_scsi_activity_store);
+EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
+
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
 {
@@ -1778,7 +1857,9 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 	const u8 pages[] = {
 		0x00,	/* page 0x00, this page */
 		0x80,	/* page 0x80, unit serial no page */
-		0x83	/* page 0x83, device ident page */
+		0x83,	/* page 0x83, device ident page */
+		0x89,	/* page 0x89, ata info page */
+		0xb1,	/* page 0xb1, block device characteristics page */
 	};
 
 	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
@@ -1899,6 +1980,19 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
+{
+	rbuf[1] = 0xb1;
+	rbuf[3] = 0x3c;
+	if (ata_id_major_version(args->id) > 7) {
+		rbuf[4] = args->id[217] >> 8;
+		rbuf[5] = args->id[217];
+		rbuf[7] = args->id[168] & 0xf;
+	}
+
+	return 0;
+}
+
 /**
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
@@ -2920,6 +3014,9 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		case 0x89:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_89);
 			break;
+		case 0xb1:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b1);
+			break;
 		default:
 			ata_scsi_invalid_field(cmd, done);
 			break;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index c0908c2..304fdc6 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -345,8 +345,8 @@ void ata_sff_dma_pause(struct ata_port *ap)
 /**
  *	ata_sff_busy_sleep - sleep until BSY clears, or timeout
  *	@ap: port containing status register to be polled
- *	@tmout_pat: impatience timeout
- *	@tmout: overall timeout
+ *	@tmout_pat: impatience timeout in msecs
+ *	@tmout: overall timeout in msecs
  *
  *	Sleep until ATA Status register bit BSY clears,
  *	or a timeout occurs.
@@ -365,7 +365,7 @@ int ata_sff_busy_sleep(struct ata_port *ap,
 
 	status = ata_sff_busy_wait(ap, ATA_BUSY, 300);
 	timer_start = jiffies;
-	timeout = timer_start + tmout_pat;
+	timeout = ata_deadline(timer_start, tmout_pat);
 	while (status != 0xff && (status & ATA_BUSY) &&
 	       time_before(jiffies, timeout)) {
 		msleep(50);
@@ -377,7 +377,7 @@ int ata_sff_busy_sleep(struct ata_port *ap,
 				"port is slow to respond, please be patient "
 				"(Status 0x%x)\n", status);
 
-	timeout = timer_start + tmout;
+	timeout = ata_deadline(timer_start, tmout);
 	while (status != 0xff && (status & ATA_BUSY) &&
 	       time_before(jiffies, timeout)) {
 		msleep(50);
@@ -390,7 +390,7 @@ int ata_sff_busy_sleep(struct ata_port *ap,
 	if (status & ATA_BUSY) {
 		ata_port_printk(ap, KERN_ERR, "port failed to respond "
 				"(%lu secs, Status 0x%x)\n",
-				tmout / HZ, status);
+				DIV_ROUND_UP(tmout, 1000), status);
 		return -EBUSY;
 	}
 
@@ -1888,7 +1888,7 @@ int ata_sff_wait_after_reset(struct ata_link *link, unsigned int devmask,
 	unsigned int dev1 = devmask & (1 << 1);
 	int rc, ret = 0;
 
-	msleep(ATA_WAIT_AFTER_RESET_MSECS);
+	msleep(ATA_WAIT_AFTER_RESET);
 
 	/* always check readiness of the master device */
 	rc = ata_sff_wait_ready(link, deadline);
@@ -2371,7 +2371,8 @@ void ata_bus_reset(struct ata_port *ap)
 
 	/* issue bus reset */
 	if (ap->flags & ATA_FLAG_SRST) {
-		rc = ata_bus_softreset(ap, devmask, jiffies + 40 * HZ);
+		rc = ata_bus_softreset(ap, devmask,
+				       ata_deadline(jiffies, 40000));
 		if (rc && rc != -ENODEV)
 			goto err_out;
 	}
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 1cf803a..f6f9c28 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -151,6 +151,8 @@ extern void ata_scsi_dev_rescan(struct work_struct *work);
 extern int ata_bus_probe(struct ata_port *ap);
 
 /* libata-eh.c */
+extern unsigned long ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
+extern void ata_internal_cmd_timed_out(struct ata_device *dev, u8 cmd);
 extern enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 extern void ata_scsi_error(struct Scsi_Host *host);
 extern void ata_port_wait_eh(struct ata_port *ap);
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 5551610..d393290 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1011,7 +1011,7 @@ static void bfin_bus_post_reset(struct ata_port *ap, unsigned int devmask)
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 	unsigned int dev0 = devmask & (1 << 0);
 	unsigned int dev1 = devmask & (1 << 1);
-	unsigned long timeout;
+	unsigned long deadline;
 
 	/* if device 0 was found in ata_devchk, wait for its
 	 * BSY bit to clear
@@ -1022,7 +1022,7 @@ static void bfin_bus_post_reset(struct ata_port *ap, unsigned int devmask)
 	/* if device 1 was found in ata_devchk, wait for
 	 * register access, then wait for BSY to clear
 	 */
-	timeout = jiffies + ATA_TMOUT_BOOT;
+	deadline = ata_deadline(jiffies, ATA_TMOUT_BOOT);
 	while (dev1) {
 		u8 nsect, lbal;
 
@@ -1031,7 +1031,7 @@ static void bfin_bus_post_reset(struct ata_port *ap, unsigned int devmask)
 		lbal = read_atapi_register(base, ATA_REG_LBAL);
 		if ((nsect == 1) && (lbal == 1))
 			break;
-		if (time_after(jiffies, timeout)) {
+		if (time_after(jiffies, deadline)) {
 			dev1 = 0;
 			break;
 		}
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index fe7cc8e..bc037ff 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -305,7 +305,7 @@ static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
 			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			u32 pad;
+			__le32 pad;
 			if (rw == READ) {
 				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
@@ -746,14 +746,12 @@ static unsigned int vlb32_data_xfer(struct ata_device *adev, unsigned char *buf,
 			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			u32 pad;
+			__le32 pad;
 			if (rw == WRITE) {
 				memcpy(&pad, buf + buflen - slop, slop);
-				pad = le32_to_cpu(pad);
-				iowrite32(pad, ap->ioaddr.data_addr);
+				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
 			} else {
-				pad = ioread32(ap->ioaddr.data_addr);
-				pad = cpu_to_le32(pad);
+				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
 			}
 		}
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 97e5b09..63b7a1c 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -137,7 +137,7 @@ static unsigned int qdi_data_xfer(struct ata_device *dev, unsigned char *buf,
 			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			u32 pad;
+			__le32 pad;
 			if (rw == READ) {
 				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index bbf5aa3..16673d1 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -696,7 +696,7 @@ static void scc_bmdma_stop (struct ata_queued_cmd *qc)
 
 		if (reg & INTSTS_BMSINT) {
 			unsigned int classes;
-			unsigned long deadline = jiffies + ATA_TMOUT_BOOT;
+			unsigned long deadline = ata_deadline(jiffies, ATA_TMOUT_BOOT);
 			printk(KERN_WARNING "%s: Internal Bus Error\n", DRV_NAME);
 			out_be32(bmid_base + SCC_DMA_INTST, INTSTS_BMSINT);
 			/* TBD: SW reset */
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 474528f..a7606b0 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -105,7 +105,7 @@ static unsigned int winbond_data_xfer(struct ata_device *dev,
 			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			u32 pad;
+			__le32 pad;
 			if (rw == READ) {
 				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 16aa683..fb13b82 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -253,21 +253,29 @@ static void k2_bmdma_start_mmio(struct ata_queued_cmd *qc)
 	/* start host DMA transaction */
 	dmactl = readb(mmio + ATA_DMA_CMD);
 	writeb(dmactl | ATA_DMA_START, mmio + ATA_DMA_CMD);
-	/* There is a race condition in certain SATA controllers that can
-	   be seen when the r/w command is given to the controller before the
-	   host DMA is started. On a Read command, the controller would initiate
-	   the command to the drive even before it sees the DMA start. When there
-	   are very fast drives connected to the controller, or when the data request
-	   hits in the drive cache, there is the possibility that the drive returns a part
-	   or all of the requested data to the controller before the DMA start is issued.
-	   In this case, the controller would become confused as to what to do with the data.
-	   In the worst case when all the data is returned back to the controller, the
-	   controller could hang. In other cases it could return partial data returning
-	   in data corruption. This problem has been seen in PPC systems and can also appear
-	   on an system with very fast disks, where the SATA controller is sitting behind a
-	   number of bridges, and hence there is significant latency between the r/w command
-	   and the start command. */
-	/* issue r/w command if the access is to ATA*/
+	/* This works around possible data corruption.
+
+	   On certain SATA controllers that can be seen when the r/w
+	   command is given to the controller before the host DMA is
+	   started.
+
+	   On a Read command, the controller would initiate the
+	   command to the drive even before it sees the DMA
+	   start. When there are very fast drives connected to the
+	   controller, or when the data request hits in the drive
+	   cache, there is the possibility that the drive returns a
+	   part or all of the requested data to the controller before
+	   the DMA start is issued.  In this case, the controller
+	   would become confused as to what to do with the data.  In
+	   the worst case when all the data is returned back to the
+	   controller, the controller could hang. In other cases it
+	   could return partial data returning in data
+	   corruption. This problem has been seen in PPC systems and
+	   can also appear on an system with very fast disks, where
+	   the SATA controller is sitting behind a number of bridges,
+	   and hence there is significant latency between the r/w
+	   command and the start command. */
+	/* issue r/w command if the access is to ATA */
 	if (qc->tf.protocol == ATA_PROT_DMA)
 		ap->ops->sff_exec_command(ap, &qc->tf);
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e57e5d0..5b247b8 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -27,6 +27,7 @@
 #define __LINUX_LIBATA_H__
 
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
@@ -115,7 +116,7 @@ enum {
 	/* tag ATA_MAX_QUEUE - 1 is reserved for internal commands */
 	ATA_MAX_QUEUE		= 32,
 	ATA_TAG_INTERNAL	= ATA_MAX_QUEUE - 1,
-	ATA_SHORT_PAUSE		= (HZ >> 6) + 1,
+	ATA_SHORT_PAUSE		= 16,
 
 	ATAPI_MAX_DRAIN		= 16 << 10,
 
@@ -168,6 +169,7 @@ enum {
 	ATA_LFLAG_ASSUME_CLASS	= ATA_LFLAG_ASSUME_ATA | ATA_LFLAG_ASSUME_SEMB,
 	ATA_LFLAG_NO_RETRY	= (1 << 5), /* don't retry this link */
 	ATA_LFLAG_DISABLED	= (1 << 6), /* link is disabled */
+	ATA_LFLAG_SW_ACTIVITY	= (1 << 7), /* keep activity stats */
 
 	/* struct ata_port flags */
 	ATA_FLAG_SLAVE_POSS	= (1 << 0), /* host supports slave dev */
@@ -190,6 +192,10 @@ enum {
 	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */
 	ATA_FLAG_PMP		= (1 << 19), /* controller supports PMP */
 	ATA_FLAG_IPM		= (1 << 20), /* driver can handle IPM */
+	ATA_FLAG_EM		= (1 << 21), /* driver supports enclosure
+					      * management */
+	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
+					      * led */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
@@ -234,17 +240,16 @@ enum {
 	/* bits 24:31 of host->flags are reserved for LLD specific flags */
 
 	/* various lengths of time */
-	ATA_TMOUT_BOOT		= 30 * HZ,	/* heuristic */
-	ATA_TMOUT_BOOT_QUICK	= 7 * HZ,	/* heuristic */
-	ATA_TMOUT_INTERNAL	= 30 * HZ,
-	ATA_TMOUT_INTERNAL_QUICK = 5 * HZ,
+	ATA_TMOUT_BOOT		= 30000,	/* heuristic */
+	ATA_TMOUT_BOOT_QUICK	=  7000,	/* heuristic */
+	ATA_TMOUT_INTERNAL_QUICK = 5000,
 
 	/* FIXME: GoVault needs 2s but we can't afford that without
 	 * parallel probing.  800ms is enough for iVDR disk
 	 * HHD424020F7SV00.  Increase to 2secs when parallel probing
 	 * is in place.
 	 */
-	ATA_TMOUT_FF_WAIT	= 4 * HZ / 5,
+	ATA_TMOUT_FF_WAIT	=  800,
 
 	/* Spec mandates to wait for ">= 2ms" before checking status
 	 * after reset.  We wait 150ms, because that was the magic
@@ -256,14 +261,14 @@ enum {
 	 *
 	 * Old drivers/ide uses the 2mS rule and then waits for ready.
 	 */
-	ATA_WAIT_AFTER_RESET_MSECS = 150,
+	ATA_WAIT_AFTER_RESET	=  150,
 
 	/* If PMP is supported, we have to do follow-up SRST.  As some
 	 * PMPs don't send D2H Reg FIS after hardreset, LLDs are
 	 * advised to wait only for the following duration before
 	 * doing SRST.
 	 */
-	ATA_TMOUT_PMP_SRST_WAIT	= 1 * HZ,
+	ATA_TMOUT_PMP_SRST_WAIT	= 1000,
 
 	/* ATA bus states */
 	BUS_UNKNOWN		= 0,
@@ -340,6 +345,11 @@ enum {
 
 	SATA_PMP_RW_TIMEOUT	= 3000,		/* PMP read/write timeout */
 
+	/* This should match the actual table size of
+	 * ata_eh_cmd_timeout_table in libata-eh.c.
+	 */
+	ATA_EH_CMD_TIMEOUT_TABLE_SIZE = 5,
+
 	/* Horkage types. May be set by libata or controller on drives
 	   (some horkage may be drive/controller pair dependant */
 
@@ -441,6 +451,15 @@ enum link_pm {
 	MEDIUM_POWER,
 };
 extern struct device_attribute dev_attr_link_power_management_policy;
+extern struct device_attribute dev_attr_em_message_type;
+extern struct device_attribute dev_attr_em_message;
+extern struct device_attribute dev_attr_sw_activity;
+
+enum sw_activity {
+	OFF,
+	BLINK_ON,
+	BLINK_OFF,
+};
 
 #ifdef CONFIG_ATA_SFF
 struct ata_ioports {
@@ -597,10 +616,14 @@ struct ata_eh_info {
 struct ata_eh_context {
 	struct ata_eh_info	i;
 	int			tries[ATA_MAX_DEVICES];
+	int			cmd_timeout_idx[ATA_MAX_DEVICES]
+					       [ATA_EH_CMD_TIMEOUT_TABLE_SIZE];
 	unsigned int		classes[ATA_MAX_DEVICES];
 	unsigned int		did_probe_mask;
 	unsigned int		saved_ncq_enabled;
 	u8			saved_xfer_mode[ATA_MAX_DEVICES];
+	/* timestamp for the last reset attempt or success */
+	unsigned long		last_reset;
 };
 
 struct ata_acpi_drive
@@ -692,6 +715,7 @@ struct ata_port {
 	struct timer_list	fastdrain_timer;
 	unsigned long		fastdrain_cnt;
 
+	int			em_message_type;
 	void			*private_data;
 
 #ifdef CONFIG_ATA_ACPI
@@ -783,6 +807,12 @@ struct ata_port_operations {
 	u8   (*bmdma_status)(struct ata_port *ap);
 #endif /* CONFIG_ATA_SFF */
 
+	ssize_t (*em_show)(struct ata_port *ap, char *buf);
+	ssize_t (*em_store)(struct ata_port *ap, const char *message,
+			    size_t size);
+	ssize_t (*sw_activity_show)(struct ata_device *dev, char *buf);
+	ssize_t (*sw_activity_store)(struct ata_device *dev,
+				     enum sw_activity val);
 	/*
 	 * Obsolete
 	 */
@@ -895,8 +925,7 @@ extern void ata_host_resume(struct ata_host *host);
 #endif
 extern int ata_ratelimit(void);
 extern u32 ata_wait_register(void __iomem *reg, u32 mask, u32 val,
-			     unsigned long interval_msec,
-			     unsigned long timeout_msec);
+			     unsigned long interval, unsigned long timeout);
 extern int atapi_cmd_type(u8 opcode);
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
 			  u8 pmp, int is_cmd, u8 *fis);
@@ -1389,6 +1418,12 @@ static inline int ata_check_ready(u8 status)
 	return 0;
 }
 
+static inline unsigned long ata_deadline(unsigned long from_jiffies,
+					 unsigned long timeout_msecs)
+{
+	return from_jiffies + msecs_to_jiffies(timeout_msecs);
+}
+
 
 /**************************************************************************
  * PMP - drivers/ata/libata-pmp.c
