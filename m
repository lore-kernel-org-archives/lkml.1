Return-Path: <linux-kernel-owner+w=401wt.eu-S934946AbZLKXfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946AbZLKXfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934809AbZLKXfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:35:19 -0500
Received: from kroah.org ([198.145.64.141]:50447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933798AbZLKX3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/58] tty: tty_port: Change the buffer allocator locking
Date: Fri, 11 Dec 2009 15:28:19 -0800
Message-Id: <1260574122-10676-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We want to be able to do this without regard for the activate/own open
method being used which causes a problem using port->mutex. Add another
mutex for now. Once everything uses port_open to do buffer allocs we can
kill it back off

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c |    9 +++++----
 include/linux/tty.h     |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index dd471d6..3ef644a 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -25,6 +25,7 @@ void tty_port_init(struct tty_port *port)
 	init_waitqueue_head(&port->close_wait);
 	init_waitqueue_head(&port->delta_msr_wait);
 	mutex_init(&port->mutex);
+	mutex_init(&port->buf_mutex);
 	spin_lock_init(&port->lock);
 	port->close_delay = (50 * HZ) / 100;
 	port->closing_wait = (3000 * HZ) / 100;
@@ -34,10 +35,10 @@ EXPORT_SYMBOL(tty_port_init);
 int tty_port_alloc_xmit_buf(struct tty_port *port)
 {
 	/* We may sleep in get_zeroed_page() */
-	mutex_lock(&port->mutex);
+	mutex_lock(&port->buf_mutex);
 	if (port->xmit_buf == NULL)
 		port->xmit_buf = (unsigned char *)get_zeroed_page(GFP_KERNEL);
-	mutex_unlock(&port->mutex);
+	mutex_unlock(&port->buf_mutex);
 	if (port->xmit_buf == NULL)
 		return -ENOMEM;
 	return 0;
@@ -46,12 +47,12 @@ EXPORT_SYMBOL(tty_port_alloc_xmit_buf);
 
 void tty_port_free_xmit_buf(struct tty_port *port)
 {
-	mutex_lock(&port->mutex);
+	mutex_lock(&port->buf_mutex);
 	if (port->xmit_buf != NULL) {
 		free_page((unsigned long)port->xmit_buf);
 		port->xmit_buf = NULL;
 	}
-	mutex_unlock(&port->mutex);
+	mutex_unlock(&port->buf_mutex);
 }
 EXPORT_SYMBOL(tty_port_free_xmit_buf);
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 6352ac2..e9269ca 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -212,6 +212,7 @@ struct tty_port {
 	wait_queue_head_t	delta_msr_wait;	/* Modem status change */
 	unsigned long		flags;		/* TTY flags ASY_*/
 	struct mutex		mutex;		/* Locking */
+	struct mutex		buf_mutex;	/* Buffer alloc lock */
 	unsigned char		*xmit_buf;	/* Optional buffer */
 	unsigned int		close_delay;	/* Close port delay */
 	unsigned int		closing_wait;	/* Delay for output */
-- 
1.6.5.5

