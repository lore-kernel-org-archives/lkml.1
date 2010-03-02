Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab0CBXr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:47:26 -0500
Received: from kroah.org ([198.145.64.141]:51638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab0CBXhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:06 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/36] nozomi: Add tty_port usage
Date: Tue,  2 Mar 2010 15:36:34 -0800
Message-Id: <1267573003-782-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The Nozomi tty handling is very broken on the open/close side (See
http://bugzilla.kernel.org/show_bug.cgi?id=13024 for one example). In
particular it marks the tty as closed on the first close() not on the last.

Most of the logic is pretty solid except for the open/close path so switch
to the tty_port helpers and let them do all the heavy lifting. This is also
fixes all the POSIX behaviour violations in the open/close paths.

Begin by adding the tty port usage

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/nozomi.c |  115 +++++++++++++++++++++++++++++--------------------
 1 files changed, 68 insertions(+), 47 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 2ad7d37..cd405bc 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -371,6 +371,8 @@ struct port {
 	struct mutex tty_sem;
 	wait_queue_head_t tty_wait;
 	struct async_icount tty_icount;
+
+	struct nozomi *dc;
 };
 
 /* Private data one for each card in the system */
@@ -414,6 +416,8 @@ MODULE_DEVICE_TABLE(pci, nozomi_pci_tbl);
 static struct nozomi *ndevs[NOZOMI_MAX_CARDS];
 static struct tty_driver *ntty_driver;
 
+static const struct tty_port_operations noz_tty_port_ops;
+
 /*
  * find card by tty_index
  */
@@ -1473,9 +1477,11 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 
 	for (i = 0; i < MAX_PORT; i++) {
 		struct device *tty_dev;
-
-		mutex_init(&dc->port[i].tty_sem);
-		tty_port_init(&dc->port[i].port);
+		struct port *port = &dc->port[i];
+		port->dc = dc;
+		mutex_init(&port->tty_sem);
+		tty_port_init(&port->port);
+		port->port.ops = &noz_tty_port_ops;
 		tty_dev = tty_register_device(ntty_driver, dc->index_start + i,
 							&pdev->dev);
 
@@ -1600,67 +1606,74 @@ static void set_dtr(const struct tty_struct *tty, int dtr)
  * ----------------------------------------------------------------------------
  */
 
-/* Called when the userspace process opens the tty, /dev/noz*.  */
-static int ntty_open(struct tty_struct *tty, struct file *file)
+static int ntty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct port *port = get_port_by_tty(tty);
 	struct nozomi *dc = get_dc_by_tty(tty);
-	unsigned long flags;
-
+	int ret;
 	if (!port || !dc || dc->state != NOZOMI_STATE_READY)
 		return -ENODEV;
-
-	if (mutex_lock_interruptible(&port->tty_sem))
-		return -ERESTARTSYS;
-
-	port->port.count++;
-	dc->open_ttys++;
-
-	/* Enable interrupt downlink for channel */
-	if (port->port.count == 1) {
-		tty->driver_data = port;
-		tty_port_tty_set(&port->port, tty);
-		DBG1("open: %d", port->token_dl);
-		spin_lock_irqsave(&dc->spin_mutex, flags);
-		dc->last_ier = dc->last_ier | port->token_dl;
-		writew(dc->last_ier, dc->reg_ier);
-		spin_unlock_irqrestore(&dc->spin_mutex, flags);
+	ret = tty_init_termios(tty);
+	if (ret == 0) {
+		tty_driver_kref_get(driver);
+		driver->ttys[tty->index] = tty;
 	}
-	mutex_unlock(&port->tty_sem);
-	return 0;
+	return ret;
 }
 
-/* Called when the userspace process close the tty, /dev/noz*. Also
-   called immediately if ntty_open fails in which case tty->driver_data
-   will be NULL an we exit by the first return */
+static void ntty_cleanup(struct tty_struct *tty)
+{
+	tty->driver_data = NULL;
+}
 
-static void ntty_close(struct tty_struct *tty, struct file *file)
+static int ntty_activate(struct tty_port *tport, struct tty_struct *tty)
 {
-	struct nozomi *dc = get_dc_by_tty(tty);
-	struct port *nport = tty->driver_data;
-	struct tty_port *port = &nport->port;
+	struct port *port = container_of(tport, struct port, port);
+	struct nozomi *dc = port->dc;
 	unsigned long flags;
 
-	if (!dc || !nport)
-		return;
+	DBG1("open: %d", port->token_dl);
+	spin_lock_irqsave(&dc->spin_mutex, flags);
+	dc->last_ier = dc->last_ier | port->token_dl;
+	writew(dc->last_ier, dc->reg_ier);
+	dc->open_ttys++;
+	spin_unlock_irqrestore(&dc->spin_mutex, flags);
+	printk("noz: activated %d: %p\n", tty->index, tport);
+	return 0;
+}
 
-	/* Users cannot interrupt a close */
-	mutex_lock(&nport->tty_sem);
+static int ntty_open(struct tty_struct *tty, struct file *filp)
+{
+	struct port *port = get_port_by_tty(tty);
+	return tty_port_open(&port->port, tty, filp);
+}
 
-	WARN_ON(!port->count);
+static void ntty_shutdown(struct tty_port *tport)
+{
+	struct port *port = container_of(tport, struct port, port);
+	struct nozomi *dc = port->dc;
+	unsigned long flags;
 
+	DBG1("close: %d", port->token_dl);
+	spin_lock_irqsave(&dc->spin_mutex, flags);
+	dc->last_ier &= ~(port->token_dl);
+	writew(dc->last_ier, dc->reg_ier);
 	dc->open_ttys--;
-	port->count--;
+	spin_unlock_irqrestore(&dc->spin_mutex, flags);
+	printk("noz: shutdown %p\n", tport);
+}
 
-	if (port->count == 0) {
-		DBG1("close: %d", nport->token_dl);
-		tty_port_tty_set(port, NULL);
-		spin_lock_irqsave(&dc->spin_mutex, flags);
-		dc->last_ier &= ~(nport->token_dl);
-		writew(dc->last_ier, dc->reg_ier);
-		spin_unlock_irqrestore(&dc->spin_mutex, flags);
-	}
-	mutex_unlock(&nport->tty_sem);
+static void ntty_close(struct tty_struct *tty, struct file *filp)
+{
+	struct port *port = tty->driver_data;
+	if (port)
+		tty_port_close(&port->port, tty, filp);
+}
+
+static void ntty_hangup(struct tty_struct *tty)
+{
+	struct port *port = tty->driver_data;
+	tty_port_hangup(&port->port);
 }
 
 /*
@@ -1906,10 +1919,16 @@ exit_in_buffer:
 	return rval;
 }
 
+static const struct tty_port_operations noz_tty_port_ops = {
+	.activate = ntty_activate,
+	.shutdown = ntty_shutdown,
+};
+
 static const struct tty_operations tty_ops = {
 	.ioctl = ntty_ioctl,
 	.open = ntty_open,
 	.close = ntty_close,
+	.hangup = ntty_hangup,
 	.write = ntty_write,
 	.write_room = ntty_write_room,
 	.unthrottle = ntty_unthrottle,
@@ -1917,6 +1936,8 @@ static const struct tty_operations tty_ops = {
 	.chars_in_buffer = ntty_chars_in_buffer,
 	.tiocmget = ntty_tiocmget,
 	.tiocmset = ntty_tiocmset,
+	.install = ntty_install,
+	.cleanup = ntty_cleanup,
 };
 
 /* Module initialization */
-- 
1.7.0.1

