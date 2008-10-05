Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYJEQN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYJEQN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYJEQIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:08:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54880 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756582AbYJEQH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:07:59 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 24/76] tty: Split tty_port into its own file
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:07:59 +0100
Message-ID: <20081005160756.1997.23666.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not much in it yet but this will grow a lot

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/Makefile   |    2 +-
 drivers/char/tty_io.c   |   36 -------------------------------
 drivers/char/tty_port.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 37 deletions(-)
 create mode 100644 drivers/char/tty_port.c

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 77ea41b..1a4247d 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -7,7 +7,7 @@
 #
 FONTMAPFILE = cp437.uni
 
-obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o
+obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o tty_port.o
 
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 3a72693..7323168 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1139,42 +1139,6 @@ ssize_t redirected_tty_write(struct file *file, const char __user *buf,
 	return tty_write(file, buf, count, ppos);
 }
 
-void tty_port_init(struct tty_port *port)
-{
-	memset(port, 0, sizeof(*port));
-	init_waitqueue_head(&port->open_wait);
-	init_waitqueue_head(&port->close_wait);
-	mutex_init(&port->mutex);
-	port->close_delay = (50 * HZ) / 100;
-	port->closing_wait = (3000 * HZ) / 100;
-}
-EXPORT_SYMBOL(tty_port_init);
-
-int tty_port_alloc_xmit_buf(struct tty_port *port)
-{
-	/* We may sleep in get_zeroed_page() */
-	mutex_lock(&port->mutex);
-	if (port->xmit_buf == NULL)
-		port->xmit_buf = (unsigned char *)get_zeroed_page(GFP_KERNEL);
-	mutex_unlock(&port->mutex);
-	if (port->xmit_buf == NULL)
-		return -ENOMEM;
-	return 0;
-}
-EXPORT_SYMBOL(tty_port_alloc_xmit_buf);
-
-void tty_port_free_xmit_buf(struct tty_port *port)
-{
-	mutex_lock(&port->mutex);
-	if (port->xmit_buf != NULL) {
-		free_page((unsigned long)port->xmit_buf);
-		port->xmit_buf = NULL;
-	}
-	mutex_unlock(&port->mutex);
-}
-EXPORT_SYMBOL(tty_port_free_xmit_buf);
-
-
 static char ptychar[] = "pqrstuvwxyzabcde";
 
 /**
diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
new file mode 100644
index 0000000..6fadb19
--- /dev/null
+++ b/drivers/char/tty_port.c
@@ -0,0 +1,55 @@
+/*
+ * Tty port functions
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/timer.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/wait.h>
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+
+void tty_port_init(struct tty_port *port)
+{
+	memset(port, 0, sizeof(*port));
+	init_waitqueue_head(&port->open_wait);
+	init_waitqueue_head(&port->close_wait);
+	mutex_init(&port->mutex);
+	port->close_delay = (50 * HZ) / 100;
+	port->closing_wait = (3000 * HZ) / 100;
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

