Return-Path: <linux-kernel-owner+w=401wt.eu-S1751128AbZLNF0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128AbZLNF0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZLNF0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:26:12 -0500
Received: from www84.your-server.de ([213.133.104.84]:56852 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZLNF0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:26:11 -0500
Subject: [PATCH] kfifo: fix warn_unused_result
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Dec 2009 06:25:51 +0100
Message-ID: <1260768351.6620.57.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by Andrew Morton:

This patch fix the "ignoring return value of '...', declared with
attribute warn_unused_result" compiler warning in several users of the
new kfifo API.
 
It removes the __must_check attribute from kfifo_in() and
kfifo_in_locked() which must not necessary performed.

Fix the allocation bug in the nozomi driver file, by moving out the
kfifo_alloc from the interrupt handler into the probe function.

Fix the kfifo_out() and kfifo_out_locked() users to handle a unexpected
end of fifo. 

The patch-set is against current mm tree from 11-Dec-2009

Greetings,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/char/nozomi.c                       |   31 ++++++++++++++++++++++++----
 drivers/infiniband/hw/cxgb3/cxio_resource.c |    5 ++--
 drivers/media/video/meye.c                  |    5 ++--
 drivers/net/wireless/libertas/main.c        |    6 +++--
 drivers/scsi/libiscsi_tcp.c                 |    9 ++++++--
 drivers/scsi/libsrp.c                       |    7 ++++--
 include/linux/kfifo.h                       |    4 +--
 7 files changed, 51 insertions(+), 16 deletions(-)

diff -u -N -r mmotm.orig/include/linux/kfifo.h mmotm.new/include/linux/kfifo.h
--- mmotm.orig/include/linux/kfifo.h	2009-12-14 04:28:36.392623524 +0100
+++ mmotm.new/include/linux/kfifo.h	2009-12-14 06:15:53.889911612 +0100
@@ -110,7 +110,7 @@
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
 			gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
-extern __must_check unsigned int kfifo_in(struct kfifo *fifo,
+extern unsigned int kfifo_in(struct kfifo *fifo,
 				const unsigned char *from, unsigned int len);
 extern __must_check unsigned int kfifo_out(struct kfifo *fifo,
 				unsigned char *to, unsigned int len);
@@ -194,7 +194,7 @@
  * the FIFO depending on the free space, and returns the number of
  * bytes copied.
  */
-static inline __must_check unsigned int kfifo_in_locked(struct kfifo *fifo,
+static inline unsigned int kfifo_in_locked(struct kfifo *fifo,
 		const unsigned char *from, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
diff -u -N -r mmotm.orig/drivers/char/nozomi.c mmotm.new/drivers/char/nozomi.c
--- mmotm.orig/drivers/char/nozomi.c	2009-12-14 04:56:54.757061915 +0100
+++ mmotm.new/drivers/char/nozomi.c	2009-12-14 06:15:53.887965205 +0100
@@ -685,8 +685,6 @@
 		dump_table(dc);
 
 		for (i = PORT_MDM; i < MAX_PORT; i++) {
-			kfifo_alloc(&dc->port[i].fifo_ul,
-				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC);
 			memset(&dc->port[i].ctrl_dl, 0, sizeof(struct ctrl_dl));
 			memset(&dc->port[i].ctrl_ul, 0, sizeof(struct ctrl_ul));
 		}
@@ -1433,6 +1431,16 @@
 		goto err_free_sbuf;
 	}
 
+	for (i = PORT_MDM; i < MAX_PORT; i++) {
+		if (kfifo_alloc(&dc->port[i].fifo_ul,
+		      FIFO_BUFFER_SIZE_UL, GFP_ATOMIC)) {
+			dev_err(&pdev->dev,
+					"Could not allocate kfifo buffer\n");
+			ret = -ENOMEM;
+			goto err_free_kfifo;
+		}
+	}
+
 	spin_lock_init(&dc->spin_mutex);
 
 	nozomi_setup_private_data(dc);
@@ -1445,7 +1453,7 @@
 			NOZOMI_NAME, dc);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev, "can't request irq %d\n", pdev->irq);
-		goto err_free_sbuf;
+		goto err_free_kfifo;
 	}
 
 	DBG1("base_addr: %p", dc->base_addr);
@@ -1464,13 +1472,28 @@
 	dc->state = NOZOMI_STATE_ENABLED;
 
 	for (i = 0; i < MAX_PORT; i++) {
+		struct device *tty_dev;
+
 		mutex_init(&dc->port[i].tty_sem);
 		tty_port_init(&dc->port[i].port);
-		tty_register_device(ntty_driver, dc->index_start + i,
+		tty_dev = tty_register_device(ntty_driver, dc->index_start + i,
 							&pdev->dev);
+
+		if (IS_ERR(tty_dev)) {
+			ret = PTR_ERR(tty_dev);
+			dev_err(&pdev->dev, "Could not allocate tty?\n");
+			goto err_free_tty;
+		}
 	}
+
 	return 0;
 
+err_free_tty:
+	for (i = dc->index_start; i < dc->index_start + MAX_PORT; ++i)
+		tty_unregister_device(ntty_driver, i);
+err_free_kfifo:
+	for (i = 0; i < MAX_PORT; i++)
+		kfifo_free(&dc->port[i].fifo_ul);
 err_free_sbuf:
 	kfree(dc->send_buf);
 	iounmap(dc->base_addr);
diff -u -N -r mmotm.orig/drivers/infiniband/hw/cxgb3/cxio_resource.c mmotm.new/drivers/infiniband/hw/cxgb3/cxio_resource.c
--- mmotm.orig/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-12-14 05:48:19.409593867 +0100
+++ mmotm.new/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-12-14 06:15:53.887047560 +0100
@@ -86,8 +86,9 @@
 			kfifo_in(fifo, (unsigned char *) &i, sizeof(u32));
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_out_locked(fifo, (unsigned char *) &entry,
-				sizeof(u32), fifo_lock);
+		if (kfifo_out_locked(fifo, (unsigned char *) &entry,
+				sizeof(u32), fifo_lock) != sizeof(u32))
+					break;
 	return 0;
 }
 
diff -u -N -r mmotm.orig/drivers/media/video/meye.c mmotm.new/drivers/media/video/meye.c
--- mmotm.orig/drivers/media/video/meye.c	2009-12-14 05:50:04.409843744 +0100
+++ mmotm.new/drivers/media/video/meye.c	2009-12-14 06:15:53.885580195 +0100
@@ -968,8 +968,9 @@
 		/* fall through */
 	case MEYE_BUF_DONE:
 		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
-		kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
-				sizeof(int), &meye.doneq_lock);
+		if (kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
+				sizeof(int), &meye.doneq_lock) != sizeof(int))
+					break;
 	}
 	*i = meye.grab_buffer[*i].size;
 	mutex_unlock(&meye.lock);
diff -u -N -r mmotm.orig/drivers/net/wireless/libertas/main.c mmotm.new/drivers/net/wireless/libertas/main.c
--- mmotm.orig/drivers/net/wireless/libertas/main.c	2009-12-14 05:50:59.173511999 +0100
+++ mmotm.new/drivers/net/wireless/libertas/main.c	2009-12-14 06:15:53.889002627 +0100
@@ -514,8 +514,10 @@
 		while (kfifo_len(&priv->event_fifo)) {
 			u32 event;
 
-			kfifo_out(&priv->event_fifo, (unsigned char *) &event,
-				sizeof(event));
+			if (kfifo_out(&priv->event_fifo,
+				(unsigned char *) &event, sizeof(event)) !=
+				sizeof(event))
+					break;
 			spin_unlock_irq(&priv->driver_lock);
 			lbs_process_event(priv, event);
 			spin_lock_irq(&priv->driver_lock);
diff -u -N -r mmotm.orig/drivers/scsi/libiscsi_tcp.c mmotm.new/drivers/scsi/libiscsi_tcp.c
--- mmotm.orig/drivers/scsi/libiscsi_tcp.c	2009-12-14 05:51:36.459482982 +0100
+++ mmotm.new/drivers/scsi/libiscsi_tcp.c	2009-12-14 06:15:53.883593559 +0100
@@ -990,8 +990,13 @@
 		}
 
 		if (r2t == NULL) {
-			kfifo_out(&tcp_task->r2tqueue,
-				    (void *)&tcp_task->r2t, sizeof(void *));
+			if (kfifo_out(&tcp_task->r2tqueue,
+			    (void *)&tcp_task->r2t, sizeof(void *)) !=
+			    sizeof(void *)) {
+				WARN_ONCE(1, "unexpected fifo state");
+				r2t = NULL;
+			}
+					
 			r2t = tcp_task->r2t;
 		}
 		spin_unlock_bh(&session->lock);
diff -u -N -r mmotm.orig/drivers/scsi/libsrp.c mmotm.new/drivers/scsi/libsrp.c
--- mmotm.orig/drivers/scsi/libsrp.c	2009-12-14 05:51:53.838843981 +0100
+++ mmotm.new/drivers/scsi/libsrp.c	2009-12-14 06:15:53.885580195 +0100
@@ -163,8 +163,11 @@
 {
 	struct iu_entry *iue = NULL;
 
-	kfifo_out_locked(&target->iu_queue.queue, (void *) &iue,
-			sizeof(void *), &target->iu_queue.lock);
+	if (kfifo_out_locked(&target->iu_queue.queue, (void *) &iue,
+		sizeof(void *), &target->iu_queue.lock) != sizeof(void *)) {
+			WARN_ONCE(1, "unexpected fifo state");
+			return NULL;
+	}
 	if (!iue)
 		return iue;
 	iue->target = target;




