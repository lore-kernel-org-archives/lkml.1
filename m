Return-Path: <linux-kernel-owner+w=401wt.eu-S1423023AbXDXTJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423023AbXDXTJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423026AbXDXTJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:09:22 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:40991
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423023AbXDXTJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:09:21 -0400
Date: Tue, 24 Apr 2007 21:12:20 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: kjhall@us.ibm.com, tpm@selhorst.net, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore in TPM driver
Message-ID: <20070424191220.GG6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	kjhall@us.ibm.com, tpm@selhorst.net,
	tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the TPM driver uses two semaphores as mutexes. use the mutex API
instead of the (binary) semaphores

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com> 

--

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index e5a254a..0805d39 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -328,10 +328,10 @@ static void timeout_work(struct work_struct *work)
 {
 	struct tpm_chip *chip = container_of(work, struct tpm_chip, work);
 
-	down(&chip->buffer_mutex);
+	mutex_lock(&chip->buffer_mutex);
 	atomic_set(&chip->data_pending, 0);
 	memset(chip->data_buffer, 0, TPM_BUFSIZE);
-	up(&chip->buffer_mutex);
+	mutex_unlock(&chip->buffer_mutex);
 }
 
 /*
@@ -380,7 +380,7 @@ static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		return -E2BIG;
 	}
 
-	down(&chip->tpm_mutex);
+	mutex_lock(&chip->tpm_mutex);
 
 	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {
 		dev_err(chip->dev,
@@ -419,7 +419,7 @@ out_recv:
 		dev_err(chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
-	up(&chip->tpm_mutex);
+	mutex_unlock(&chip->tpm_mutex);
 	return rc;
 }
 
@@ -966,14 +966,14 @@ ssize_t tpm_write(struct file *file, const char __user *buf,
 	while (atomic_read(&chip->data_pending) != 0)
 		msleep(TPM_TIMEOUT);
 
-	down(&chip->buffer_mutex);
+	mutex_lock(&chip->buffer_mutex);
 
 	if (in_size > TPM_BUFSIZE)
 		in_size = TPM_BUFSIZE;
 
 	if (copy_from_user
 	    (chip->data_buffer, (void __user *) buf, in_size)) {
-		up(&chip->buffer_mutex);
+		mutex_unlock(&chip->buffer_mutex);
 		return -EFAULT;
 	}
 
@@ -981,7 +981,7 @@ ssize_t tpm_write(struct file *file, const char __user *buf,
 	out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
 
 	atomic_set(&chip->data_pending, out_size);
-	up(&chip->buffer_mutex);
+	mutex_unlock(&chip->buffer_mutex);
 
 	/* Set a timeout by which the reader must come claim the result */
 	mod_timer(&chip->user_read_timer, jiffies + (60 * HZ));
@@ -1004,10 +1004,10 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 		if (size < ret_size)
 			ret_size = size;
 
-		down(&chip->buffer_mutex);
+		mutex_lock(&chip->buffer_mutex);
 		if (copy_to_user(buf, chip->data_buffer, ret_size))
 			ret_size = -EFAULT;
-		up(&chip->buffer_mutex);
+		mutex_unlock(&chip->buffer_mutex);
 	}
 
 	return ret_size;
@@ -1100,8 +1100,8 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
 	if (chip == NULL)
 		return NULL;
 
-	init_MUTEX(&chip->buffer_mutex);
-	init_MUTEX(&chip->tpm_mutex);
+	mutex_init(&chip->buffer_mutex);
+	mutex_init(&chip->tpm_mutex);
 	INIT_LIST_HEAD(&chip->list);
 
 	INIT_WORK(&chip->work, timeout_work);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index bb9a43c..bf58aac 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -95,11 +95,11 @@ struct tpm_chip {
 	/* Data passed to and from the tpm via the read/write calls */
 	u8 *data_buffer;
 	atomic_t data_pending;
-	struct semaphore buffer_mutex;
+	struct mutex buffer_mutex;
 
 	struct timer_list user_read_timer;	/* user needs to claim result */
 	struct work_struct work;
-	struct semaphore tpm_mutex;	/* tpm is processing */
+	struct mutex tpm_mutex;	/* tpm is processing */
 
 	struct tpm_vendor_specific vendor;
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

          Dreams and reality are opposites. Action synthesizes them
                             (Assata Shakur)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
