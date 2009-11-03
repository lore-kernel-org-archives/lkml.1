Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbZKCAfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbZKCAfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbZKCAfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:35:11 -0500
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:40436 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757373AbZKCAfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:35:10 -0500
Date: Mon, 2 Nov 2009 17:35:11 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com
Subject: [PATCH] TPM: Let the tpm char device be openable multiple times
Message-ID: <20091103003511.GL7768@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How to use the TPM is really a user space policy choice, if the
environment wants to use middleware then fine, but it is possible to
make correct TPM apps without using middleware.

So, remove the kernel restriction that only one process may open the TPM.
- TPM low level functions (in kernel users) are already locked proprely
  and can run in parallel with the user space interface anyhow.
- Move the user space data buffer and related goop into a
  struct tpm_file, create one struct tpm_file per open file.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm.c |   87 +++++++++++++++++++++--------------------------
 drivers/char/tpm/tpm.h |   24 ++++++++-----
 2 files changed, 53 insertions(+), 58 deletions(-)

Mainly for embedded where the middleware is perhaps not appropriate.

Tested with a winbond TPM and tpm_tis.

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 196bc48..0625404 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -31,7 +31,6 @@
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
-	TPM_BUFSIZE = 2048,
 	TPM_NUM_DEVICES = 256,
 };
 
@@ -321,19 +320,19 @@ static const u8 tpm_ordinal_duration[TPM_MAX_ORDINAL] = {
 
 static void user_reader_timeout(unsigned long ptr)
 {
-	struct tpm_chip *chip = (struct tpm_chip *) ptr;
+	struct tpm_file *fl = (struct tpm_file *) ptr;
 
-	schedule_work(&chip->work);
+	schedule_work(&fl->work);
 }
 
 static void timeout_work(void *ptr)
 {
-	struct tpm_chip *chip = ptr;
+	struct tpm_file *fl = ptr;
 
-	mutex_lock(&chip->buffer_mutex);
-	atomic_set(&chip->data_pending, 0);
-	memset(chip->data_buffer, 0, TPM_BUFSIZE);
-	mutex_unlock(&chip->buffer_mutex);
+	mutex_lock(&fl->buffer_mutex);
+	atomic_set(&fl->data_pending, 0);
+	memset(fl->data_bufferx, 0, sizeof(fl->data_bufferx));
+	mutex_unlock(&fl->buffer_mutex);
 }
 
 /*
@@ -962,6 +961,7 @@ int tpm_open(struct inode *inode, struct file *file)
 {
 	int minor = iminor(inode);
 	struct tpm_chip *chip = NULL, *pos;
+	struct tpm_file *fl;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
@@ -976,22 +976,19 @@ int tpm_open(struct inode *inode, struct file *file)
 	if (!chip)
 		return -ENODEV;
 
-	if (test_and_set_bit(0, &chip->is_open)) {
-		dev_dbg(chip->dev, "Another process owns this TPM\n");
-		put_device(chip->dev);
-		return -EBUSY;
-	}
-
-	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
-	if (chip->data_buffer == NULL) {
-		clear_bit(0, &chip->is_open);
+	fl = kzalloc(sizeof(*fl), GFP_KERNEL);
+	if (fl == NULL) {
 		put_device(chip->dev);
 		return -ENOMEM;
 	}
 
-	atomic_set(&chip->data_pending, 0);
+	fl->chip = chip;
+	mutex_init(&fl->buffer_mutex);
+	setup_timer(&fl->user_read_timer, user_reader_timeout,
+			(unsigned long)fl);
+	INIT_WORK(&fl->work, timeout_work, fl);
 
-	file->private_data = chip;
+	file->private_data = fl;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_open);
@@ -1001,14 +998,14 @@ EXPORT_SYMBOL_GPL(tpm_open);
  */
 int tpm_release(struct inode *inode, struct file *file)
 {
-	struct tpm_chip *chip = file->private_data;
+	struct tpm_file *fl = file->private_data;
+	struct tpm_chip *chip = fl->chip;
 
-	del_singleshot_timer_sync(&chip->user_read_timer);
+	del_singleshot_timer_sync(&fl->user_read_timer);
 	flush_scheduled_work();
+	mutex_destroy(&fl->buffer_mutex);
+	kfree(file->private_data);
 	file->private_data = NULL;
-	atomic_set(&chip->data_pending, 0);
-	kfree(chip->data_buffer);
-	clear_bit(0, &chip->is_open);
 	put_device(chip->dev);
 	return 0;
 }
@@ -1017,33 +1014,33 @@ EXPORT_SYMBOL_GPL(tpm_release);
 ssize_t tpm_write(struct file *file, const char __user *buf,
 		  size_t size, loff_t *off)
 {
-	struct tpm_chip *chip = file->private_data;
+	struct tpm_file *fl = file->private_data;
 	size_t in_size = size, out_size;
 
 	/* cannot perform a write until the read has cleared
 	   either via tpm_read or a user_read_timer timeout */
-	while (atomic_read(&chip->data_pending) != 0)
+	while (atomic_read(&fl->data_pending) != 0)
 		msleep(TPM_TIMEOUT);
 
-	mutex_lock(&chip->buffer_mutex);
+	mutex_lock(&fl->buffer_mutex);
 
-	if (in_size > TPM_BUFSIZE)
-		in_size = TPM_BUFSIZE;
+	in_size = min(sizeof(fl->data_bufferx), in_size);
 
 	if (copy_from_user
-	    (chip->data_buffer, (void __user *) buf, in_size)) {
-		mutex_unlock(&chip->buffer_mutex);
+	    (fl->data_bufferx, (void __user *) buf, in_size)) {
+		mutex_unlock(&fl->buffer_mutex);
 		return -EFAULT;
 	}
 
 	/* atomic tpm command send and result receive */
-	out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
+	out_size = tpm_transmit(fl->chip, fl->data_bufferx,
+				sizeof(fl->data_bufferx));
 
-	atomic_set(&chip->data_pending, out_size);
-	mutex_unlock(&chip->buffer_mutex);
+	atomic_set(&fl->data_pending, out_size);
+	mutex_unlock(&fl->buffer_mutex);
 
 	/* Set a timeout by which the reader must come claim the result */
-	mod_timer(&chip->user_read_timer, jiffies + (60 * HZ));
+	mod_timer(&fl->user_read_timer, jiffies + (60 * HZ));
 
 	return in_size;
 }
@@ -1052,21 +1049,21 @@ EXPORT_SYMBOL_GPL(tpm_write);
 ssize_t tpm_read(struct file *file, char __user *buf,
 		 size_t size, loff_t *off)
 {
-	struct tpm_chip *chip = file->private_data;
+	struct tpm_file *fl = file->private_data;
 	ssize_t ret_size;
 
-	del_singleshot_timer_sync(&chip->user_read_timer);
+	del_singleshot_timer_sync(&fl->user_read_timer);
 	flush_scheduled_work();
-	ret_size = atomic_read(&chip->data_pending);
-	atomic_set(&chip->data_pending, 0);
+	ret_size = atomic_read(&fl->data_pending);
+	atomic_set(&fl->data_pending, 0);
 	if (ret_size > 0) {	/* relay data */
 		if (size < ret_size)
 			ret_size = size;
 
-		mutex_lock(&chip->buffer_mutex);
-		if (copy_to_user(buf, chip->data_buffer, ret_size))
+		mutex_lock(&fl->buffer_mutex);
+		if (copy_to_user(buf, fl->data_bufferx, ret_size))
 			ret_size = -EFAULT;
-		mutex_unlock(&chip->buffer_mutex);
+		mutex_unlock(&fl->buffer_mutex);
 	}
 
 	return ret_size;
@@ -1182,15 +1179,9 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	if (chip == NULL || devname == NULL)
 		goto out_free;
 
-	mutex_init(&chip->buffer_mutex);
 	mutex_init(&chip->tpm_mutex);
 	INIT_LIST_HEAD(&chip->list);
 
-	INIT_WORK(&chip->work, timeout_work, chip);
-
-	setup_timer(&chip->user_read_timer, user_reader_timeout,
-			(unsigned long)chip);
-
 	memcpy(&chip->vendor, entry, sizeof(struct tpm_vendor_specific));
 
 	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8e00b4d..0fa262d 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -91,16 +91,6 @@ struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 
 	int dev_num;		/* /dev/tpm# */
-	unsigned long is_open;	/* only one allowed */
-	int time_expired;
-
-	/* Data passed to and from the tpm via the read/write calls */
-	u8 *data_buffer;
-	atomic_t data_pending;
-	struct mutex buffer_mutex;
-
-	struct timer_list user_read_timer;	/* user needs to claim result */
-	struct work_struct work;
 	struct mutex tpm_mutex;	/* tpm is processing */
 
 	struct tpm_vendor_specific vendor;
@@ -113,6 +103,20 @@ struct tpm_chip {
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
 
+/* Private data structure for struct file */
+struct tpm_file {
+	struct tpm_chip *chip;
+
+	/* Data passed to and from the tpm via the read/write calls */
+	atomic_t data_pending;
+	struct mutex buffer_mutex;
+
+	struct timer_list user_read_timer;	/* user needs to claim result */
+	struct work_struct work;
+
+	u8 data_bufferx[2048];
+};
+
 static inline int tpm_read_index(int base, int index)
 {
 	outb(index, base);
-- 
1.5.4.2

