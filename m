Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbYESPC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbYESPC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYESPCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:02:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39688 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044AbYESPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:02:32 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/20] tty: Introduce a tty_port common structure
To: linux-kernel@vger.kernel.org, akpm@osdl.org, greg@kroah.com
Date: Mon, 19 May 2008 15:50:13 +0100
Message-ID: <20080519145013.19326.38344.stgit@core>
In-Reply-To: <20080519144557.19326.74313.stgit@core>
References: <20080519144557.19326.74313.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Every tty driver has its own concept of a port structure and because they all
differ we cannot extract commonality. Begin fixing this by creating a structure
drivers can elect to use so that over time we can push fields into this and
create commonality and then introduce common methods.
---

 drivers/char/tty_io.c |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/tty.h   |   29 +++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 0 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 49c1a22..fb17b18 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2004,6 +2004,43 @@ ssize_t redirected_tty_write(struct file *file, const char __user *buf,
 	return tty_write(file, buf, count, ppos);
 }
 
+void tty_port_init(struct tty_port *port)
+{
+	memset(port, 0, sizeof(*port));
+	init_waitqueue_head(&port->open_wait);
+	init_waitqueue_head(&port->close_wait);
+	mutex_init(&port->mutex);
+}
+
+EXPORT_SYMBOL(tty_port_init);
+
+int tty_port_alloc_xmit_buf(struct tty_port *port)
+{
+	/* We may sleep in get_zeroed_page() */
+	mutex_lock(&port->mutex);
+	if (port->xmit_buf == NULL)
+		port->xmit_buf = (unsigned char *)get_zeroed_page(GFP_KERNEL);
+	mutex_unlock(&port->mutex);
+	if (port->xmit_buf == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+EXPORT_SYMBOL(tty_port_alloc_xmit_buf);
+
+void tty_port_free_xmit_buf(struct tty_port *port)
+{
+	mutex_lock(&port->mutex);
+	if (port->xmit_buf != NULL) {
+		free_page((unsigned long)port->xmit_buf);
+		port->xmit_buf = NULL;
+	}
+	mutex_unlock(&port->mutex);
+}
+
+EXPORT_SYMBOL(tty_port_free_xmit_buf);
+
+
 static char ptychar[] = "pqrstuvwxyzabcde";
 
 /**
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 7f7121f..a5dc3e9 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -166,6 +166,30 @@ struct tty_bufhead {
 
 struct device;
 struct signal_struct;
+
+/*
+ * Port level information. Each device keeps its own port level information
+ * so provide a common structure for those ports wanting to use common support
+ * routines.
+ *
+ * The tty port has a different lifetime to the tty so must be kept apart.
+ * In addition be careful as tty -> port mappings are valid for the life
+ * of the tty object but in many cases port -> tty mappings are valid only
+ * until a hangup so don't use the wrong path.
+ */
+ 
+struct tty_port
+{
+	struct tty_struct	*tty;		/* Back pointer */
+	int			blocked_open;	/* Waiting to open */
+	int			count;		/* Usage count */
+	wait_queue_head_t	open_wait;	/* Open waiters */
+	wait_queue_head_t	close_wait;	/* Close waiters */
+	unsigned long		flags;		/* TTY flags ASY_*/
+	struct mutex		mutex;		/* Locking */
+	unsigned char		*xmit_buf;	/* Optional buffer */
+};
+
 /*
  * Where all of the state associated with a tty is kept while the tty
  * is open.  Since the termios state should be kept even if the tty
@@ -241,6 +265,7 @@ struct tty_struct {
 	spinlock_t read_lock;
 	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
+	struct tty_port *port;
 };
 
 /* tty magic number */
@@ -351,6 +376,10 @@ extern void tty_write_unlock(struct tty_struct *tty);
 extern int tty_write_lock(struct tty_struct *tty, int ndelay);
 #define tty_is_writelocked(tty)  (mutex_is_locked(&tty->atomic_write_lock))
 
+extern void tty_port_init(struct tty_port *port);
+extern int tty_port_alloc_xmit_buf(struct tty_port *port);
+extern void tty_port_free_xmit_buf(struct tty_port *port);
+
 
 
 /* n_tty.c */

