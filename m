Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZDVHHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZDVHHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZDVHHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:07:37 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43924 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZDVHHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:07:36 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/6] Char: cyclades, cache HW version
Date: Wed, 22 Apr 2009 09:06:39 +0200
Message-Id: <1240384003-25499-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240384003-25499-1-git-send-email-jirislaby@gmail.com>
References: <1240384003-25499-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store HW version locally to not read it all the time in interrupts
and alike.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c  |   32 +++++++++++---------------------
 include/linux/cyclades.h |    1 +
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 2cbf741..cf191cc 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -668,8 +668,7 @@ static void cy_send_xchar(struct tty_struct *tty, char ch);
 #define Z_FPGA_CHECK(card) \
 	((readl(&(card).ctl_addr.p9060->init_ctrl) & (1<<17)) != 0)
 
-#define ISZLOADED(card)	(((ZO_V1 == readl(&(card).ctl_addr.p9060->mail_box_0)) \
-			|| Z_FPGA_CHECK(card)) && \
+#define ISZLOADED(card)	((ZO_V1 == (card).hw_ver || Z_FPGA_CHECK(card)) && \
 			(ZFIRM_ID == readl(&((struct FIRM_ID __iomem *) \
 			((card).base_addr+ID_ADDRESS))->signature)))
 
@@ -1393,8 +1392,6 @@ cyz_fetch_msg(struct cyclades_card *cinfo,
 	unsigned long loc_doorbell;
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
-	if (!ISZLOADED(*cinfo))
-		return -1;
 	zfw_ctrl = cinfo->base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 	board_ctrl = &zfw_ctrl->board_ctrl;
 
@@ -1619,10 +1616,8 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 	static struct BOARD_CTRL __iomem *board_ctrl;
 	static struct CH_CTRL __iomem *ch_ctrl;
 	static struct BUF_CTRL __iomem *buf_ctrl;
-	__u32 channel;
+	__u32 channel, param, fw_ver;
 	__u8 cmd;
-	__u32 param;
-	__u32 hw_ver, fw_ver;
 	int special_count;
 	int delta_count;
 
@@ -1630,7 +1625,6 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 	zfw_ctrl = cinfo->base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 	board_ctrl = &zfw_ctrl->board_ctrl;
 	fw_ver = readl(&board_ctrl->fw_version);
-	hw_ver = readl(&cinfo->ctl_addr.p9060->mail_box_0);
 
 	while (cyz_fetch_msg(cinfo, &channel, &cmd, &param) == 1) {
 		special_count = 0;
@@ -2388,11 +2382,9 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 		struct FIRM_ID __iomem *firm_id = cinfo->base_addr + ID_ADDRESS;
 
 		if (!ISZLOADED(*cinfo)) {
-			if (((ZE_V1 == readl(&cinfo->ctl_addr.p9060->
-							mail_box_0)) &&
-					Z_FPGA_CHECK(*cinfo)) &&
-					(ZFIRM_HLT == readl(
-						&firm_id->signature))) {
+			if (cinfo->hw_ver == ZE_V1 && Z_FPGA_CHECK(*cinfo) &&
+					readl(&firm_id->signature) ==
+					ZFIRM_HLT) {
 				printk(KERN_ERR "cyc:Cyclades-Z Error: you "
 					"need an external power supply for "
 					"this number of ports.\nFirmware "
@@ -4336,7 +4328,6 @@ static void cy_hangup(struct tty_struct *tty)
 static int __devinit cy_init_card(struct cyclades_card *cinfo)
 {
 	struct cyclades_port *info;
-	u32 uninitialized_var(mailbox);
 	unsigned int nports, port;
 	unsigned short chip_number;
 	int uninitialized_var(index);
@@ -4344,8 +4335,7 @@ static int __devinit cy_init_card(struct cyclades_card *cinfo)
 	spin_lock_init(&cinfo->card_lock);
 
 	if (IS_CYC_Z(*cinfo)) {	/* Cyclades-Z */
-		mailbox = readl(&cinfo->ctl_addr.p9060->mail_box_0);
-		nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
+		nports = (cinfo->hw_ver == ZE_V1) ? ZE_V1_NPORTS : 8;
 		cinfo->intr_enabled = 0;
 		cinfo->nports = 0;	/* Will be correctly set later, after
 					   Z FW is loaded */
@@ -4377,7 +4367,7 @@ static int __devinit cy_init_card(struct cyclades_card *cinfo)
 
 		if (IS_CYC_Z(*cinfo)) {
 			info->type = PORT_STARTECH;
-			if (mailbox == ZO_V1)
+			if (cinfo->hw_ver == ZO_V1)
 				info->xmit_fifo_size = CYZ_FIFO_SIZE;
 			else
 				info->xmit_fifo_size = 4 * CYZ_FIFO_SIZE;
@@ -4932,7 +4922,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 {
 	void __iomem *addr0 = NULL, *addr2 = NULL;
 	char *card_name = NULL;
-	u32 mailbox;
+	u32 uninitialized_var(mailbox);
 	unsigned int device_id, nchan = 0, card_no, i;
 	unsigned char plx_ver;
 	int retval, irq;
@@ -5014,7 +5004,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 
 		plx_init(pdev, irq, addr0);
 
-		mailbox = (u32)readl(&ctl_addr->mail_box_0);
+		mailbox = readl(&ctl_addr->mail_box_0);
 
 		addr2 = ioremap_nocache(pci_resource_start(pdev, 2),
 				mailbox == ZE_V1 ? CyPCI_Ze_win : CyPCI_Zwin);
@@ -5026,7 +5016,6 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		if (mailbox == ZE_V1) {
 			card_name = "Cyclades-Ze";
 
-			readl(&ctl_addr->mail_box_0);
 			nchan = ZE_V1_NPORTS;
 		} else {
 			card_name = "Cyclades-8Zo";
@@ -5089,6 +5078,8 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		}
 		cy_card[card_no].num_chips = nchan / 4;
 	} else {
+		cy_card[card_no].hw_ver = mailbox;
+		cy_card[card_no].num_chips = (unsigned int)-1;
 #ifdef CONFIG_CYZ_INTR
 		/* allocate IRQ only if board has an IRQ */
 		if (irq != 0 && irq != 255) {
@@ -5101,7 +5092,6 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 			}
 		}
 #endif				/* CONFIG_CYZ_INTR */
-		cy_card[card_no].num_chips = (unsigned int)-1;
 	}
 
 	/* set cy_card */
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index 9ae03d5..a14fe30 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -518,6 +518,7 @@ struct cyclades_card {
 	unsigned int nports;	/* Number of ports in the card */
 	int bus_index;		/* address shift - 0 for ISA, 1 for PCI */
 	int intr_enabled;		/* FW Interrupt flag - 0 disabled, 1 enabled */
+	u32 hw_ver;
 	spinlock_t card_lock;
 	struct cyclades_port *ports;
 };
-- 
1.6.2.3

