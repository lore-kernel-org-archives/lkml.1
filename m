Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbYFTUQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbYFTUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbYFTUQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:16:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51953 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758871AbYFTUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:16:07 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/70] tty: Introduce a tty_port common structure
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 20:58:43 +0100
Message-ID: <20080620195838.1479.34725.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
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

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |   34 ++++++++++++++++++++++++++++++++++
 include/linux/tty.h   |   30 +++++++++++++++++++++++++++++-
 2 files changed, 63 insertions(+), 1 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index ab1dd0a..1856096 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2088,6 +2088,40 @@ ssize_t redirected_tty_write(struct file *file, const char __user *buf,
 	return tty_write(file, buf, count, ppos);
 }
 
+void tty_port_init(struct tty_port *port)
+{
+	memset(port, 0, sizeof(*port));
+	init_waitqueue_head(&port->open_wait);
+	init_waitqueue_head(&port->close_wait);
+	mutex_init(&port->mutex);
+}
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
+EXPORT_SYMBOL(tty_port_free_xmit_buf);
+
+
 static char ptychar[] = "pqrstuvwxyzabcde";
 
 /**
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 013711e..d7c695b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -166,6 +166,29 @@ struct tty_bufhead {
 
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
+struct tty_port {
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
@@ -214,7 +237,7 @@ struct tty_struct {
 	struct list_head tty_files;
 
 #define N_TTY_BUF_SIZE 4096
-	
+
 	/*
 	 * The following is data for the N_TTY line discipline.  For
 	 * historical reasons, this is included in the tty structure.
@@ -242,6 +265,7 @@ struct tty_struct {
 	spinlock_t read_lock;
 	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
+	struct tty_port *port;
 };
 
 /* tty magic number */
@@ -350,6 +374,10 @@ extern void tty_write_unlock(struct tty_struct *tty);
 extern int tty_write_lock(struct tty_struct *tty, int ndelay);
 #define tty_is_writelocked(tty)  (mutex_is_locked(&tty->atomic_write_lock))
 
+extern void tty_port_init(struct tty_port *port);
+extern int tty_port_alloc_xmit_buf(struct tty_port *port);
+extern void tty_port_free_xmit_buf(struct tty_port *port);
+
 
 
 /* n_tty.c */

