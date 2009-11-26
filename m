Return-Path: <linux-kernel-owner+w=401wt.eu-S965072AbZKZAos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072AbZKZAos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 19:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965078AbZKZAor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 19:44:47 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:51031 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068AbZKZAop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 19:44:45 -0500
From: Ian Molton <ian.molton@collabora.co.uk>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, mpm@selenic.com,
       Ian Molton <ian.molton@collabora.co.uk>
Subject: [PATCH 1/2] hw_random: core updates to allow more efficient drivers
Date: Thu, 26 Nov 2009 00:44:09 +0000
Message-Id: <1259196250-24182-2-git-send-email-ian.molton@collabora.co.uk>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1259196250-24182-1-git-send-email-ian.molton@collabora.co.uk>
References: <1259177252.2858.17.camel@calx>
 <1259196250-24182-1-git-send-email-ian.molton@collabora.co.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch implements a new method by which hw_random hardware drivers
can pass data to the core more efficiently, using a shared buffer.

The old methods have been retained as a compatability layer until all the
drivers have been updated.

Signed-off-by: Ian Molton <ian.molton@collabora.co.uk>
---
 drivers/char/hw_random/core.c |  120 ++++++++++++++++++++++++++---------------
 include/linux/hw_random.h     |    7 ++-
 2 files changed, 81 insertions(+), 46 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 1573aeb..e179afd 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -47,12 +47,14 @@
 #define RNG_MODULE_NAME		"hw_random"
 #define PFX			RNG_MODULE_NAME ": "
 #define RNG_MISCDEV_MINOR	183 /* official */
+#define RNG_BUFFSIZE		64
 
 
 static struct hwrng *current_rng;
 static LIST_HEAD(rng_list);
 static DEFINE_MUTEX(rng_mutex);
-
+static u8 *rng_buffer;
+static int data_avail;
 
 static inline int hwrng_init(struct hwrng *rng)
 {
@@ -67,19 +69,6 @@ static inline void hwrng_cleanup(struct hwrng *rng)
 		rng->cleanup(rng);
 }
 
-static inline int hwrng_data_present(struct hwrng *rng, int wait)
-{
-	if (!rng->data_present)
-		return 1;
-	return rng->data_present(rng, wait);
-}
-
-static inline int hwrng_data_read(struct hwrng *rng, u32 *data)
-{
-	return rng->data_read(rng, data);
-}
-
-
 static int rng_dev_open(struct inode *inode, struct file *filp)
 {
 	/* enforce read-only access to this chrdev */
@@ -91,54 +80,86 @@ static int rng_dev_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static inline int rng_get_data(struct hwrng *rng, u8 *rng_buffer, size_t size,
+			int wait) {
+	int present;
+
+	if (rng->read)
+		return rng->read(rng, (void *)rng_buffer, size, wait);
+
+	if (rng->data_present)
+		present = rng->data_present(rng, wait);
+	else
+		present = 1;
+
+	if (present)
+		return rng->data_read(rng, (u32 *)rng_buffer);
+
+	return 0;
+}
+
 static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			    size_t size, loff_t *offp)
 {
-	u32 data;
 	ssize_t ret = 0;
 	int err = 0;
-	int bytes_read;
+	int bytes_read, len;
 
 	while (size) {
-		err = -ERESTARTSYS;
-		if (mutex_lock_interruptible(&rng_mutex))
+		if (mutex_lock_interruptible(&rng_mutex)) {
+			err = -ERESTARTSYS;
 			goto out;
+		}
+
 		if (!current_rng) {
-			mutex_unlock(&rng_mutex);
 			err = -ENODEV;
-			goto out;
+			goto out_unlock;
 		}
 
-		bytes_read = 0;
-		if (hwrng_data_present(current_rng,
-				       !(filp->f_flags & O_NONBLOCK)))
-			bytes_read = hwrng_data_read(current_rng, &data);
-		mutex_unlock(&rng_mutex);
-
-		err = -EAGAIN;
-		if (!bytes_read && (filp->f_flags & O_NONBLOCK))
-			goto out;
-		if (bytes_read < 0) {
-			err = bytes_read;
-			goto out;
+		if (!data_avail) {
+			bytes_read = rng_get_data(current_rng, rng_buffer,
+				RNG_BUFFSIZE, !(filp->f_flags & O_NONBLOCK));
+			if (bytes_read < 0) {
+				err = bytes_read;
+				goto out_unlock;
+			}
+			data_avail = bytes_read;
 		}
 
-		err = -EFAULT;
-		while (bytes_read && size) {
-			if (put_user((u8)data, buf++))
-				goto out;
-			size--;
-			ret++;
-			bytes_read--;
-			data >>= 8;
+		if (!data_avail) {
+			if (filp->f_flags & O_NONBLOCK) {
+				err = -EAGAIN;
+				goto out_unlock;
+			}
+		} else {
+			len = data_avail;
+			if (len > size)
+				len = size;
+
+			data_avail -= len;
+
+			if (copy_to_user(buf + ret, rng_buffer + data_avail,
+								len)) {
+				err = -EFAULT;
+				goto out_unlock;
+			}
+
+			size -= len;
+			ret += len;
 		}
 
+		mutex_unlock(&rng_mutex);
+
 		if (need_resched())
 			schedule_timeout_interruptible(1);
-		err = -ERESTARTSYS;
-		if (signal_pending(current))
+
+		if (signal_pending(current)) {
+			err = -ERESTARTSYS;
 			goto out;
+		}
 	}
+out_unlock:
+	mutex_unlock(&rng_mutex);
 out:
 	return ret ? : err;
 }
@@ -280,11 +301,19 @@ int hwrng_register(struct hwrng *rng)
 	struct hwrng *old_rng, *tmp;
 
 	if (rng->name == NULL ||
-	    rng->data_read == NULL)
+	    (rng->data_read == NULL && rng->read == NULL))
 		goto out;
 
 	mutex_lock(&rng_mutex);
 
+	if (!rng_buffer) {
+		rng_buffer = kmalloc(RNG_BUFFSIZE, GFP_KERNEL);
+		if (!rng_buffer) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
+	}
+
 	/* Must not register two RNGs with the same name. */
 	err = -EEXIST;
 	list_for_each_entry(tmp, &rng_list, list) {
@@ -338,8 +367,11 @@ void hwrng_unregister(struct hwrng *rng)
 				current_rng = NULL;
 		}
 	}
-	if (list_empty(&rng_list))
+	if (list_empty(&rng_list)) {
 		unregister_miscdev();
+		kfree(rng_buffer);
+		rng_buffer = NULL;
+	}
 
 	mutex_unlock(&rng_mutex);
 }
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 7244456..9bede76 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -22,10 +22,12 @@
  * @cleanup:		Cleanup callback (can be NULL).
  * @data_present:	Callback to determine if data is available
  *			on the RNG. If NULL, it is assumed that
- *			there is always data available.
+ *			there is always data available.  *OBSOLETE*
  * @data_read:		Read data from the RNG device.
  *			Returns the number of lower random bytes in "data".
- *			Must not be NULL.
+ *			Must not be NULL.    *OSOLETE*
+ * @read:		New API. drivers can fill up to max bytes of data
+ *			into the buffer. The buffer is aligned for any type.
  * @priv:		Private data, for use by the RNG driver.
  */
 struct hwrng {
@@ -34,6 +36,7 @@ struct hwrng {
 	void (*cleanup)(struct hwrng *rng);
 	int (*data_present)(struct hwrng *rng, int wait);
 	int (*data_read)(struct hwrng *rng, u32 *data);
+	int (*read)(struct hwrng *rng, void *data, size_t max, bool wait);
 	unsigned long priv;
 
 	/* internal. */
-- 
1.6.5

