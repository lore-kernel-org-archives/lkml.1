Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbYCKAzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbYCKAzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYCKAzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:55:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:40535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYCKAzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:55:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Frank Seidel <fseidel@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/4] nozomi: fix initialization and early flow control access
Date: Mon, 10 Mar 2008 17:55:12 -0700
Message-Id: <1205196914-17965-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080311004219.GA17890@suse.de>
References: <20080311004219.GA17890@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <fseidel@suse.de>

Due to some flaws in the initialization and flow control
code kernel oopses could be triggered e.g. when accessing
the card too early after insertion.
See e.g. kernel.org bug #10077.
The main part of the fix is a trivial state management
making sure the card is realy ready to use before allowing
any access.

Signed-off-by: Frank Seidel <fseidel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/nozomi.c |   61 ++++++++++++++++++++++++++++++++++--------------
 1 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index dfaab23..6d0dc5f 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -190,6 +190,14 @@ enum card_type {
 	F32_8 = 8192,	/* 3072 bytes downl. + 1024 bytes uplink * 2 -> 8192 */
 };
 
+/* Initialization states a card can be in */
+enum card_state {
+	NOZOMI_STATE_UKNOWN	= 0,
+	NOZOMI_STATE_ENABLED	= 1,	/* pci device enabled */
+	NOZOMI_STATE_ALLOCATED	= 2,	/* config setup done */
+	NOZOMI_STATE_READY	= 3,	/* flowcontrols received */
+};
+
 /* Two different toggle channels exist */
 enum channel_type {
 	CH_A = 0,
@@ -385,6 +393,7 @@ struct nozomi {
 	spinlock_t spin_mutex;	/* secures access to registers and tty */
 
 	unsigned int index_start;
+	enum card_state state;
 	u32 open_ttys;
 };
 
@@ -686,6 +695,7 @@ static int nozomi_read_config_table(struct nozomi *dc)
 		dc->last_ier = dc->last_ier | CTRL_DL;
 		writew(dc->last_ier, dc->reg_ier);
 
+		dc->state = NOZOMI_STATE_ALLOCATED;
 		dev_info(&dc->pdev->dev, "Initialization OK!\n");
 		return 1;
 	}
@@ -944,6 +954,14 @@ static int receive_flow_control(struct nozomi *dc)
 	case CTRL_APP2:
 		port = PORT_APP2;
 		enable_ier = APP2_DL;
+		if (dc->state == NOZOMI_STATE_ALLOCATED) {
+			/*
+			 * After card initialization the flow control
+			 * received for APP2 is always the last
+			 */
+			dc->state = NOZOMI_STATE_READY;
+			dev_info(&dc->pdev->dev, "Device READY!\n");
+		}
 		break;
 	default:
 		dev_err(&dc->pdev->dev,
@@ -1366,22 +1384,12 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 
 	dc->pdev = pdev;
 
-	/* Find out what card type it is */
-	nozomi_get_card_type(dc);
-
 	ret = pci_enable_device(dc->pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to enable PCI Device\n");
 		goto err_free;
 	}
 
-	start = pci_resource_start(dc->pdev, 0);
-	if (start == 0) {
-		dev_err(&pdev->dev, "No I/O address for card detected\n");
-		ret = -ENODEV;
-		goto err_disable_device;
-	}
-
 	ret = pci_request_regions(dc->pdev, NOZOMI_NAME);
 	if (ret) {
 		dev_err(&pdev->dev, "I/O address 0x%04x already in use\n",
@@ -1389,6 +1397,16 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 		goto err_disable_device;
 	}
 
+	start = pci_resource_start(dc->pdev, 0);
+	if (start == 0) {
+		dev_err(&pdev->dev, "No I/O address for card detected\n");
+		ret = -ENODEV;
+		goto err_rel_regs;
+	}
+
+	/* Find out what card type it is */
+	nozomi_get_card_type(dc);
+
 	dc->base_addr = ioremap(start, dc->card_type);
 	if (!dc->base_addr) {
 		dev_err(&pdev->dev, "Unable to map card MMIO\n");
@@ -1425,6 +1443,14 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 	dc->index_start = ndev_idx * MAX_PORT;
 	ndevs[ndev_idx] = dc;
 
+	pci_set_drvdata(pdev, dc);
+
+	/* Enable RESET interrupt */
+	dc->last_ier = RESET;
+	iowrite16(dc->last_ier, dc->reg_ier);
+
+	dc->state = NOZOMI_STATE_ENABLED;
+
 	for (i = 0; i < MAX_PORT; i++) {
 		mutex_init(&dc->port[i].tty_sem);
 		dc->port[i].tty_open_count = 0;
@@ -1433,12 +1459,6 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 							&pdev->dev);
 	}
 
-	/* Enable  RESET interrupt. */
-	dc->last_ier = RESET;
-	writew(dc->last_ier, dc->reg_ier);
-
-	pci_set_drvdata(pdev, dc);
-
 	return 0;
 
 err_free_sbuf:
@@ -1553,7 +1573,7 @@ static int ntty_open(struct tty_struct *tty, struct file *file)
 	struct nozomi *dc = get_dc_by_tty(tty);
 	unsigned long flags;
 
-	if (!port || !dc)
+	if (!port || !dc || dc->state != NOZOMI_STATE_READY)
 		return -ENODEV;
 
 	if (mutex_lock_interruptible(&port->tty_sem))
@@ -1716,6 +1736,10 @@ static int ntty_tiocmget(struct tty_struct *tty, struct file *file)
 static int ntty_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned int set, unsigned int clear)
 {
+	struct nozomi *dc = get_dc_by_tty(tty);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dc->spin_mutex, flags);
 	if (set & TIOCM_RTS)
 		set_rts(tty, 1);
 	else if (clear & TIOCM_RTS)
@@ -1725,6 +1749,7 @@ static int ntty_tiocmset(struct tty_struct *tty, struct file *file,
 		set_dtr(tty, 1);
 	else if (clear & TIOCM_DTR)
 		set_dtr(tty, 0);
+	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 
 	return 0;
 }
@@ -1762,7 +1787,7 @@ static int ntty_ioctl_tiocgicount(struct port *port, void __user *argp)
 	icount.brk = cnow.brk;
 	icount.buf_overrun = cnow.buf_overrun;
 
-	return copy_to_user(argp, &icount, sizeof(icount));
+	return copy_to_user(argp, &icount, sizeof(icount)) ? -EFAULT : 0;
 }
 
 static int ntty_ioctl(struct tty_struct *tty, struct file *file,
-- 
1.5.4.3

