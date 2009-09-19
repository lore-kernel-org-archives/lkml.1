Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZISVkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZISVkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZISVkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:40:33 -0400
Received: from kroah.org ([198.145.64.141]:40439 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbZISVk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:40:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/79] tty: Add a full port_close function
Date: Sat, 19 Sep 2009 14:36:34 -0700
Message-Id: <1253396244-7885-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Now we are extracting out methods for shutdown and the like we can add a
proper tty_port_close method that knows all the innards of the tty closing
process and hides the lot from the caller.

At some point in the future this will be paired with a similar open()
helper and the drivers can stick to hardware management.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c |   29 +++++++++++++++++++++++++++--
 include/linux/tty.h     |    8 +++++++-
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 9769b11..549bd0f 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -96,6 +96,14 @@ void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_port_tty_set);
 
+static void tty_port_shutdown(struct tty_port *port)
+{
+	if (port->ops->shutdown &&
+		test_and_clear_bit(ASYNC_INITIALIZED, &port->flags))
+			port->ops->shutdown(port);
+
+}
+
 /**
  *	tty_port_hangup		-	hangup helper
  *	@port: tty port
@@ -116,6 +124,7 @@ void tty_port_hangup(struct tty_port *port)
 	port->tty = NULL;
 	spin_unlock_irqrestore(&port->lock, flags);
 	wake_up_interruptible(&port->open_wait);
+	tty_port_shutdown(port);
 }
 EXPORT_SYMBOL(tty_port_hangup);
 
@@ -296,15 +305,17 @@ int tty_port_close_start(struct tty_port *port, struct tty_struct *tty, struct f
 
 	if (port->count) {
 		spin_unlock_irqrestore(&port->lock, flags);
+		if (port->ops->drop)
+			port->ops->drop(port);
 		return 0;
 	}
-	port->flags |= ASYNC_CLOSING;
+	set_bit(ASYNC_CLOSING, &port->flags);
 	tty->closing = 1;
 	spin_unlock_irqrestore(&port->lock, flags);
 	/* Don't block on a stalled port, just pull the chain */
 	if (tty->flow_stopped)
 		tty_driver_flush_buffer(tty);
-	if (port->flags & ASYNC_INITIALIZED &&
+	if (test_bit(ASYNCB_INITIALIZED, &port->flags) &&
 			port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
 		tty_wait_until_sent(tty, port->closing_wait);
 	if (port->drain_delay) {
@@ -318,6 +329,9 @@ int tty_port_close_start(struct tty_port *port, struct tty_struct *tty, struct f
 			timeout = 2 * HZ;
 		schedule_timeout_interruptible(timeout);
 	}
+	/* Don't call port->drop for the last reference. Callers will want
+	   to drop the last active reference in ->shutdown() or the tty
+	   shutdown path */
 	return 1;
 }
 EXPORT_SYMBOL(tty_port_close_start);
@@ -348,3 +362,14 @@ void tty_port_close_end(struct tty_port *port, struct tty_struct *tty)
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 EXPORT_SYMBOL(tty_port_close_end);
+
+void tty_port_close(struct tty_port *port, struct tty_struct *tty,
+							struct file *filp)
+{
+	if (tty_port_close_start(port, tty, filp) == 0)
+		return;
+	tty_port_shutdown(port);
+	tty_port_close_end(port, tty);
+	tty_port_tty_set(port, NULL);
+}
+EXPORT_SYMBOL(tty_port_close);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index a916a31..ecb3d1b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -187,7 +187,12 @@ struct tty_port;
 struct tty_port_operations {
 	/* Return 1 if the carrier is raised */
 	int (*carrier_raised)(struct tty_port *port);
+	/* Control the DTR line */
 	void (*dtr_rts)(struct tty_port *port, int raise);
+	/* Called when the last close completes or a hangup finishes
+	   IFF the port was initialized. Do not use to free resources */
+	void (*shutdown)(struct tty_port *port);
+	void (*drop)(struct tty_port *port);
 };
 	
 struct tty_port {
@@ -459,7 +464,8 @@ extern int tty_port_block_til_ready(struct tty_port *port,
 extern int tty_port_close_start(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
 extern void tty_port_close_end(struct tty_port *port, struct tty_struct *tty);
-
+extern void tty_port_close(struct tty_port *port,
+				struct tty_struct *tty, struct file *filp);
 extern int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc);
 extern int tty_unregister_ldisc(int disc);
 extern int tty_set_ldisc(struct tty_struct *tty, int ldisc);
-- 
1.6.4.2

