Return-Path: <linux-kernel-owner+w=401wt.eu-S934399AbZLKXeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934399AbZLKXeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934814AbZLKXeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:34:06 -0500
Received: from kroah.org ([198.145.64.141]:50479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933562AbZLKX3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:24 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/58] tty: tty_port: Add a kref object to the tty port
Date: Fri, 11 Dec 2009 15:28:25 -0800
Message-Id: <1260574122-10676-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Users of tty port need a way to refcount ports when hotplugging is
involved.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c |   18 ++++++++++++++++++
 include/linux/tty.h     |   12 ++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 84006de..be492dd 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -29,6 +29,7 @@ void tty_port_init(struct tty_port *port)
 	spin_lock_init(&port->lock);
 	port->close_delay = (50 * HZ) / 100;
 	port->closing_wait = (3000 * HZ) / 100;
+	kref_init(&port->kref);
 }
 EXPORT_SYMBOL(tty_port_init);
 
@@ -56,6 +57,23 @@ void tty_port_free_xmit_buf(struct tty_port *port)
 }
 EXPORT_SYMBOL(tty_port_free_xmit_buf);
 
+static void tty_port_destructor(struct kref *kref)
+{
+	struct tty_port *port = container_of(kref, struct tty_port, kref);
+	if (port->xmit_buf)
+		free_page((unsigned long)port->xmit_buf);
+	if (port->ops->destruct)
+		port->ops->destruct(port);
+	else
+		kfree(port);
+}
+
+void tty_port_put(struct tty_port *port)
+{
+	if (port)
+		kref_put(&port->kref, tty_port_destructor);
+}
+EXPORT_SYMBOL(tty_port_put);
 
 /**
  *	tty_port_tty_get	-	get a tty reference
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e9269ca..e6da667 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -199,6 +199,8 @@ struct tty_port_operations {
         /* FIXME: long term getting the tty argument *out* of this would be
            good for consoles */
 	int (*activate)(struct tty_port *port, struct tty_struct *tty);
+	/* Called on the final put of a port */
+	void (*destruct)(struct tty_port *port);
 };
 	
 struct tty_port {
@@ -219,6 +221,7 @@ struct tty_port {
 	int			drain_delay;	/* Set to zero if no pure time
 						   based drain is needed else
 						   set to size of fifo */
+	struct kref		kref;		/* Ref counter */
 };
 
 /*
@@ -461,6 +464,15 @@ extern int tty_write_lock(struct tty_struct *tty, int ndelay);
 extern void tty_port_init(struct tty_port *port);
 extern int tty_port_alloc_xmit_buf(struct tty_port *port);
 extern void tty_port_free_xmit_buf(struct tty_port *port);
+extern void tty_port_put(struct tty_port *port);
+
+extern inline struct tty_port *tty_port_get(struct tty_port *port)
+{
+	if (port)
+		kref_get(&port->kref);
+	return port;
+}
+
 extern struct tty_struct *tty_port_tty_get(struct tty_port *port);
 extern void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty);
 extern int tty_port_carrier_raised(struct tty_port *port);
-- 
1.6.5.5

