Return-Path: <linux-kernel-owner+w=401wt.eu-S1764162AbXKIXoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764162AbXKIXoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXKIXoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:44:12 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57201 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbXKIXoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:44:11 -0500
Message-id: <457510094309335479.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 2/13] Char: nozomi, expand some functions
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:44:11 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, expand some functions

nozomi_setup_interrupt and tty_do_close are used only in one place and has
no pros of being in separate functions. move tty_do_close contents into
ntty_close (it contained only tty_do_close call before) and
nozomi_setup_interrupt (only request_irq) into nozomi_card_init.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 29335b619cc5ee27417d50982f029d440570f67c
tree 9cef37ef05e53453cd4d245a34c038ca12433253
parent 79aeb51662902086507927cb7fcd682ae319630a
author Jiri Slaby <jirislaby@gmail.com> Sun, 28 Oct 2007 11:06:05 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:54:16 +0100

 drivers/char/nozomi.c |   75 +++++++++++++++++++------------------------------
 1 files changed, 29 insertions(+), 46 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 458e70b..2e2cbc5 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1478,20 +1478,6 @@ none:
 	return IRQ_NONE;
 }
 
-/* Request a shared IRQ from system */
-static int nozomi_setup_interrupt(struct nozomi_devices *ndev)
-{
-	int rval;
-
-	rval = request_irq(ndev->my_dev->pdev->irq, &interrupt_handler,
-				IRQF_SHARED, NOZOMI_NAME, ndev);
-	if (unlikely(rval))
-		dev_err(&ndev->my_dev->pdev->dev, "Cannot open because IRQ %d "
-			"is already in use.\n", ndev->my_dev->pdev->irq);
-
-	return rval;
-}
-
 static void nozomi_get_card_type(struct nozomi *dc)
 {
 	int i;
@@ -1635,9 +1621,10 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 	dc->last_ier = 0;
 	writew(dc->last_ier, dc->reg_ier);
 
-	/* Setup interrupt handler */
-	if (nozomi_setup_interrupt(newdev)) {
-		ret = -EIO;
+	ret = request_irq(pdev->irq, &interrupt_handler, IRQF_SHARED,
+			NOZOMI_NAME, newdev);
+	if (unlikely(ret)) {
+		dev_err(&pdev->dev, "can't request irq\n");
 		goto err_disable_regions;
 	}
 
@@ -1694,34 +1681,6 @@ err_disable_device:
 	return ret;
 }
 
-static void tty_do_close(struct nozomi *dc, struct port *port)
-{
-	unsigned long flags;
-
-	if (!dc || !port)
-		return;
-
-	if (down_interruptible(&port->tty_sem))
-		return;
-
-	if (!port->tty_open_count)
-		goto exit;
-
-	dc->open_ttys--;
-	port->tty_open_count--;
-
-	if (port->tty_open_count == 0) {
-		DBG1("close: %d", port->token_dl);
-		spin_lock_irqsave(&dc->spin_mutex, flags);
-		dc->last_ier &= ~(port->token_dl);
-		writew(dc->last_ier, dc->reg_ier);
-		spin_unlock_irqrestore(&dc->spin_mutex, flags);
-	}
-
-exit:
-	up(&port->tty_sem);
-}
-
 static void __devexit tty_exit(struct nozomi_devices *ndev)
 {
 	struct nozomi *dc = ndev->my_dev;
@@ -1874,7 +1833,31 @@ static int ntty_open(struct tty_struct *tty, struct file *file)
 static void ntty_close(struct tty_struct *tty, struct file *file)
 {
 	struct nozomi *dc = get_dc_by_tty(tty);
-	tty_do_close(dc, (struct port *)tty->driver_data);
+	struct port *port = tty->driver_data;
+	unsigned long flags;
+
+	if (!dc || !port)
+		return;
+
+	if (down_interruptible(&port->tty_sem))
+		return;
+
+	if (!port->tty_open_count)
+		goto exit;
+
+	dc->open_ttys--;
+	port->tty_open_count--;
+
+	if (port->tty_open_count == 0) {
+		DBG1("close: %d", port->token_dl);
+		spin_lock_irqsave(&dc->spin_mutex, flags);
+		dc->last_ier &= ~(port->token_dl);
+		writew(dc->last_ier, dc->reg_ier);
+		spin_unlock_irqrestore(&dc->spin_mutex, flags);
+	}
+
+exit:
+	up(&port->tty_sem);
 }
 
 /*
