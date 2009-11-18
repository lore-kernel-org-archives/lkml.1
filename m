Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZKRO0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZKRO0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZKRO0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:26:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46395 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757197AbZKRO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:26:33 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/7] tty_port: Change the buffer allocator locking
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:10:09 +0000
Message-ID: <20091118141005.2798.43363.stgit@localhost.localdomain>
In-Reply-To: <20091118140935.2798.32517.stgit@localhost.localdomain>
References: <20091118140935.2798.32517.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to be able to do this without regard for the activate/own open
method being used which causes a problem using port->mutex. Add another
mutex for now. Once everything uses port_open to do buffer allocs we can
kill it back off

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_port.c |    9 +++++----
 include/linux/tty.h     |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 5c2deef..8825255 100644
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

