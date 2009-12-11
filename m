Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbZLKXhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbZLKXhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934956AbZLKXgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:25 -0500
Received: from kroah.org ([198.145.64.141]:50499 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934261AbZLKX3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/58] sdio_uart: Move the open lock
Date: Fri, 11 Dec 2009 15:28:13 -0800
Message-Id: <1260574122-10676-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

When we move to the tty_port logic the port mutex will protect open v close
v hangup. Move to this first in the existing open code so we have a bisection
point.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/card/sdio_uart.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 86ad543..31f7023 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -78,7 +78,6 @@ struct sdio_uart_port {
 	struct tty_struct	*tty;
 	unsigned int		index;
 	unsigned int		opened;
-	struct mutex		open_lock;
 	struct sdio_func	*func;
 	struct mutex		func_lock;
 	struct task_struct	*in_sdio_uart_irq;
@@ -103,7 +102,6 @@ static int sdio_uart_add_port(struct sdio_uart_port *port)
 	int index, ret = -EBUSY;
 
 	kref_init(&port->kref);
-	mutex_init(&port->open_lock);
 	mutex_init(&port->func_lock);
 	spin_lock_init(&port->write_lock);
 
@@ -166,7 +164,7 @@ static void sdio_uart_port_remove(struct sdio_uart_port *port)
 	 * give up on that port ASAP.
 	 * Beware: the lock ordering is critical.
 	 */
-	mutex_lock(&port->open_lock);
+	mutex_lock(&port->port.mutex);
 	mutex_lock(&port->func_lock);
 	func = port->func;
 	sdio_claim_host(func);
@@ -179,7 +177,7 @@ static void sdio_uart_port_remove(struct sdio_uart_port *port)
 			tty_hangup(tty);
 		tty_kref_put(tty);
 	}
-	mutex_unlock(&port->open_lock);
+	mutex_unlock(&port->port.mutex);
 	sdio_release_irq(func);
 	sdio_disable_func(func);
 	sdio_release_host(func);
@@ -699,14 +697,14 @@ static int sdio_uart_open(struct tty_struct *tty, struct file *filp)
 	if (!port)
 		return -ENODEV;
 
-	mutex_lock(&port->open_lock);
+	mutex_lock(&port->port.mutex);
 
 	/*
 	 * Make sure not to mess up with a dead port
 	 * which has not been closed yet.
 	 */
 	if (tty->driver_data && tty->driver_data != port) {
-		mutex_unlock(&port->open_lock);
+		mutex_unlock(&port->port.mutex);
 		sdio_uart_port_put(port);
 		return -EBUSY;
 	}
@@ -718,13 +716,13 @@ static int sdio_uart_open(struct tty_struct *tty, struct file *filp)
 		if (ret) {
 			tty->driver_data = NULL;
 			tty_port_tty_set(&port->port, NULL);
-			mutex_unlock(&port->open_lock);
+			mutex_unlock(&port->port.mutex);
 			sdio_uart_port_put(port);
 			return ret;
 		}
 	}
 	port->opened++;
-	mutex_unlock(&port->open_lock);
+	mutex_unlock(&port->port.mutex);
 	return 0;
 }
 
@@ -735,7 +733,7 @@ static void sdio_uart_close(struct tty_struct *tty, struct file * filp)
 	if (!port)
 		return;
 
-	mutex_lock(&port->open_lock);
+	mutex_lock(&port->port.mutex);
 	BUG_ON(!port->opened);
 
 	/*
@@ -744,7 +742,7 @@ static void sdio_uart_close(struct tty_struct *tty, struct file * filp)
 	 * is larger than port->count.
 	 */
 	if (tty->count > port->opened) {
-		mutex_unlock(&port->open_lock);
+		mutex_unlock(&port->port.mutex);
 		return;
 	}
 
@@ -756,7 +754,7 @@ static void sdio_uart_close(struct tty_struct *tty, struct file * filp)
 		tty->driver_data = NULL;
 		tty->closing = 0;
 	}
-	mutex_unlock(&port->open_lock);
+	mutex_unlock(&port->port.mutex);
 	sdio_uart_port_put(port);
 }
 
-- 
1.6.5.5

