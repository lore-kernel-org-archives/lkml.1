Return-Path: <linux-kernel-owner+w=401wt.eu-S937313AbXG2Vid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937313AbXG2Vid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935767AbXG2ViY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:38:24 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:33555
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S935705AbXG2ViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:38:23 -0400
Date: Sun, 29 Jul 2007 23:38:15 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/5] Use mutex instead of semaphore in the SCSI Tape driver
Message-ID: <20070729213815.GF3432@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070729212909.GC3432@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070729212909.GC3432@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The SCSI Tape driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a4f7b84..73c44cb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1485,7 +1485,7 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	struct st_buffer *STbp;
 	char *name = tape_name(STp);
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
 	retval = rw_checks(STp, filp, count);
@@ -1736,7 +1736,7 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	if (SRpnt != NULL)
 		st_release_request(SRpnt);
 	release_buffering(STp, 0);
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -1942,7 +1942,7 @@ st_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	struct st_buffer *STbp = STp->buffer;
 	DEB( char *name = tape_name(STp); )
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
 	retval = rw_checks(STp, filp, count);
@@ -2069,7 +2069,7 @@ st_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 		release_buffering(STp, 1);
 		STbp->buffer_bytes = 0;
 	}
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -3226,7 +3226,7 @@ static int st_ioctl(struct inode *inode, struct file *file,
 	char *name = tape_name(STp);
 	void __user *p = (void __user *)arg;
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
         DEB(
@@ -3537,7 +3537,7 @@ static int st_ioctl(struct inode *inode, struct file *file,
 			retval = (-EFAULT);
 		goto out;
 	}
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 	switch (cmd_in) {
 		case SCSI_IOCTL_GET_IDLUN:
 		case SCSI_IOCTL_GET_BUS_NUMBER:
@@ -3563,7 +3563,7 @@ static int st_ioctl(struct inode *inode, struct file *file,
 	return retval;
 
  out:
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 	return retval;
 }
 
@@ -4029,7 +4029,7 @@ static int st_probe(struct device *dev)
 
 	tpnt->density_changed = tpnt->compression_changed =
 	    tpnt->blksize_changed = 0;
-	init_MUTEX(&tpnt->lock);
+	mutex_init(&tpnt->lock);
 
 	st_nr_dev++;
 	write_unlock(&st_dev_arr_lock);
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 50f3deb..6c80757 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -3,6 +3,7 @@
 #define _ST_H
 
 #include <linux/completion.h>
+#include <linux/mutex.h>
 #include <linux/kref.h>
 #include <scsi/scsi_cmnd.h>
 
@@ -98,7 +99,7 @@ struct st_partstat {
 struct scsi_tape {
 	struct scsi_driver *driver;
 	struct scsi_device *device;
-	struct semaphore lock;	/* For serialization */
+	struct mutex lock;	/* For serialization */
 	struct completion wait;	/* For SCSI commands */
 	struct st_buffer *buffer;
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Ma patrie est où je suis, où personne ne me dérange, où personne
    ne me demande que je suis, d'où je viens et ce que je fais
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
