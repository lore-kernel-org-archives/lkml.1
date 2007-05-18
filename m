Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbXERRuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbXERRuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761851AbXERRty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:49:54 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:57548 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761589AbXERRtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:49:53 -0400
Message-id: <4782246392357423555@wsc.cz>
In-reply-to: <2258930840122446564@wsc.cz>
Subject: [PATCH 2/2] Char: cyclades, fix sparse warning
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Fri, 18 May 2007 19:49:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, fix sparse warning

+ one possible deadlock (omitted unlock)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit a9dbc0b98956d548b1aee3f55b3799a12946ace4
tree 1e62235a9bf1edb7c206932c9a10d1e9e77cb0a0
parent 7a9aa4781fc5aa6493bb3a7ac59b3c9e5f20fa76
author Jiri Slaby <jirislaby@gmail.com> Fri, 18 May 2007 19:42:55 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 18 May 2007 19:42:55 +0200

 drivers/char/cyclades.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 829be9d..01d1da0 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1100,6 +1100,7 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 
 				if (data & info->ignore_status_mask) {
 					info->icount.rx++;
+					spin_unlock(&cinfo->card_lock);
 					return;
 				}
 				if (tty_buffer_request_room(tty, 1)) {
@@ -1889,11 +1890,11 @@ static void cyz_poll(unsigned long arg)
 	struct cyclades_card *cinfo;
 	struct cyclades_port *info;
 	struct tty_struct *tty;
-	static struct FIRM_ID *firm_id;
-	static struct ZFW_CTRL *zfw_ctrl;
-	static struct BOARD_CTRL *board_ctrl;
-	static struct CH_CTRL *ch_ctrl;
-	static struct BUF_CTRL *buf_ctrl;
+	struct FIRM_ID __iomem *firm_id;
+	struct ZFW_CTRL __iomem *zfw_ctrl;
+	struct BOARD_CTRL __iomem *board_ctrl;
+	struct CH_CTRL __iomem *ch_ctrl;
+	struct BUF_CTRL __iomem *buf_ctrl;
 	unsigned long expires = jiffies + HZ;
 	int card, port;
 
@@ -2037,7 +2038,6 @@ static int startup(struct cyclades_port *info)
 		struct ZFW_CTRL __iomem *zfw_ctrl;
 		struct BOARD_CTRL __iomem *board_ctrl;
 		struct CH_CTRL __iomem *ch_ctrl;
-		int retval;
 
 		base_addr = card->base_addr;
 
@@ -2409,7 +2409,6 @@ block_til_ready(struct tty_struct *tty, struct file *filp,
 		struct ZFW_CTRL __iomem *zfw_ctrl;
 		struct BOARD_CTRL __iomem *board_ctrl;
 		struct CH_CTRL __iomem *ch_ctrl;
-		int retval;
 
 		base_addr = cinfo->base_addr;
 		firm_id = base_addr + ID_ADDRESS;
@@ -4905,7 +4904,7 @@ static int __devinit cyz_load_fw(struct pci_dev *pdev, void __iomem *base_addr,
 	struct FIRM_ID __iomem *fid = base_addr + ID_ADDRESS;
 	struct CUSTOM_REG __iomem *cust = base_addr;
 	struct ZFW_CTRL __iomem *pt_zfwctrl;
-	u8 *tmp;
+	void __iomem *tmp;
 	u32 mailbox, status;
 	unsigned int i;
 	int retval;
@@ -4967,13 +4966,13 @@ static int __devinit cyz_load_fw(struct pci_dev *pdev, void __iomem *base_addr,
 	udelay(100);
 
 	/* clear memory */
-	for (tmp = base_addr; (void *)tmp < base_addr + RAM_SIZE; tmp++)
+	for (tmp = base_addr; tmp < base_addr + RAM_SIZE; tmp++)
 		cy_writeb(tmp, 255);
 	if (mailbox != 0) {
 		/* set window to last 512K of RAM */
 		cy_writel(&ctl_addr->loc_addr_base, WIN_RAM + RAM_SIZE);
 		//sleep(1);
-		for (tmp = base_addr; (void *)tmp < base_addr + RAM_SIZE; tmp++)
+		for (tmp = base_addr; tmp < base_addr + RAM_SIZE; tmp++)
 			cy_writeb(tmp, 255);
 		/* set window to beginning of RAM */
 		cy_writel(&ctl_addr->loc_addr_base, WIN_RAM);
