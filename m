Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbXEaPeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbXEaPeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063AbXEaPd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:33:56 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:63978 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbXEaPdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:33:52 -0400
Message-Id: <20070531153436.973849599@de.ibm.com>
References: <20070531142024.011160634@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 31 May 2007 16:20:26 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/7] dasd_eer: use mutex instead of semaphore
Content-Disposition: inline; filename=002-dasd-mutex.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd_eer.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: quilt-2.6/drivers/s390/block/dasd_eer.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd_eer.c
+++ quilt-2.6/drivers/s390/block/dasd_eer.c
@@ -14,9 +14,9 @@
 #include <linux/moduleparam.h>
 #include <linux/device.h>
 #include <linux/poll.h>
+#include <linux/mutex.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/ebcdic.h>
 
@@ -514,7 +514,7 @@ void dasd_eer_disable(struct dasd_device
  * to transfer in a readbuffer, which is protected by the readbuffer_mutex.
  */
 static char readbuffer[PAGE_SIZE];
-static DECLARE_MUTEX(readbuffer_mutex);
+static DEFINE_MUTEX(readbuffer_mutex);
 
 static int dasd_eer_open(struct inode *inp, struct file *filp)
 {
@@ -579,7 +579,7 @@ static ssize_t dasd_eer_read(struct file
 	struct eerbuffer *eerb;
 
 	eerb = (struct eerbuffer *) filp->private_data;
-	if (down_interruptible(&readbuffer_mutex))
+	if (mutex_lock_interruptible(&readbuffer_mutex))
 		return -ERESTARTSYS;
 
 	spin_lock_irqsave(&bufferlock, flags);
@@ -588,7 +588,7 @@ static ssize_t dasd_eer_read(struct file
 		                  /* has been deleted             */
 		eerb->residual = 0;
 		spin_unlock_irqrestore(&bufferlock, flags);
-		up(&readbuffer_mutex);
+		mutex_unlock(&readbuffer_mutex);
 		return -EIO;
 	} else if (eerb->residual > 0) {
 		/* OK we still have a second half of a record to deliver */
@@ -602,7 +602,7 @@ static ssize_t dasd_eer_read(struct file
 			if (!tc) {
 				/* no data available */
 				spin_unlock_irqrestore(&bufferlock, flags);
-				up(&readbuffer_mutex);
+				mutex_unlock(&readbuffer_mutex);
 				if (filp->f_flags & O_NONBLOCK)
 					return -EAGAIN;
 				rc = wait_event_interruptible(
@@ -610,7 +610,7 @@ static ssize_t dasd_eer_read(struct file
 					eerb->head != eerb->tail);
 				if (rc)
 					return rc;
-				if (down_interruptible(&readbuffer_mutex))
+				if (mutex_lock_interruptible(&readbuffer_mutex))
 					return -ERESTARTSYS;
 				spin_lock_irqsave(&bufferlock, flags);
 			}
@@ -626,11 +626,11 @@ static ssize_t dasd_eer_read(struct file
 	spin_unlock_irqrestore(&bufferlock, flags);
 
 	if (copy_to_user(buf, readbuffer, effective_count)) {
-		up(&readbuffer_mutex);
+		mutex_unlock(&readbuffer_mutex);
 		return -EFAULT;
 	}
 
-	up(&readbuffer_mutex);
+	mutex_unlock(&readbuffer_mutex);
 	return effective_count;
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

