Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZETPPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZETPPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZETPPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:15:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50474 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbZETPPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:15:40 -0400
Date: Wed, 20 May 2009 10:15:28 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: ashwin.ganti@gmail.com
Cc: gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH staging] p9auth: prevent some oopses and memory leaks
Message-ID: <20090520151528.GA28322@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before all testcases, do:
	mknod /dev/caphash c 253 0
	mknod /dev/capuse c 253 1

This patch does the following:

1. caphash write of > CAP_NODE_SIZE bytes overruns node_ptr->data
	(test: cat /etc/mime.types > /dev/caphash)
2. make sure we don't dereference a NULL cap_devices[0].head
	(test: cat serge@root@abab > /dev/capuse)
3. don't let strlen dereference a NULL target_user etc
	(test: echo ab > /dev/capuse)
4. Don't leak a bunch of memory in cap_write().  Note that
   technically node_ptr is not needed for the capuse write case.
   As a result I have a much more extensive patch splitting up
   cap_write(), but I thought a smaller patch that is easier to test
   and verify would be a better start.  To test:
	cnt=0
	while [ 1 ]; do
		echo /etc/mime.types > /dev/capuse
		if [ $((cnt%25)) -eq 0 ]; then
			head -2 /proc/meminfo
		fi
		cnt=$((cnt+1))
		sleep 0.3
	done
   Without this patch, it MemFree steadily drops.  With the patch,
   it does not.

I have *not* tested this driver (with or without these patches)
with factotum or anything - only using the tests described above.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 drivers/staging/p9auth/p9auth.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index 3cac89b..9111dcb 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -180,8 +180,12 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 	if (down_interruptible(&dev->sem))
 		return -ERESTARTSYS;
 
+	user_buf_running = NULL;
+	hash_str = NULL;
 	node_ptr = kmalloc(sizeof(struct cap_node), GFP_KERNEL);
 	user_buf = kzalloc(count, GFP_KERNEL);
+	if (!node_ptr || !user_buf)
+		goto out;
 
 	if (copy_from_user(user_buf, buf, count)) {
 		retval = -EFAULT;
@@ -193,11 +197,21 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 	 * hashed capability supplied by the user to the list of hashes
 	 */
 	if (0 == iminor(filp->f_dentry->d_inode)) {
+		if (count > CAP_NODE_SIZE) {
+			retval = -EINVAL;
+			goto out;
+		}
 		printk(KERN_INFO "Capability being written to /dev/caphash : \n");
 		hexdump(user_buf, count);
 		memcpy(node_ptr->data, user_buf, count);
 		list_add(&(node_ptr->list), &(dev->head->list));
+		node_ptr = NULL;
 	} else {
+		if (!cap_devices[0].head ||
+				list_empty(&(cap_devices[0].head->list))) {
+			retval = -EINVAL;
+			goto out;
+		}
 		/*
 		 * break the supplied string into tokens with @ as the
 		 * delimiter If the string is "user1@user2@randomstring" we
@@ -208,6 +222,10 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 		source_user = strsep(&user_buf_running, "@");
 		target_user = strsep(&user_buf_running, "@");
 		rand_str = strsep(&user_buf_running, "@");
+		if (!source_user || !target_user || !rand_str) {
+			retval = -EINVAL;
+			goto out;
+		}
 
 		/* hash the string user1@user2 with rand_str as the key */
 		len = strlen(source_user) + strlen(target_user) + 1;
@@ -224,7 +242,7 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 			retval = -EFAULT;
 			goto out;
 		}
-		memcpy(node_ptr->data, result, CAP_NODE_SIZE);
+		memcpy(node_ptr->data, result, CAP_NODE_SIZE);  /* why? */
 		/* Change the process's uid if the hash is present in the
 		 * list of hashes
 		 */
@@ -299,6 +317,10 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 		dev->size = *f_pos;
 
 out:
+	kfree(node_ptr);
+	kfree(user_buf);
+	kfree(user_buf_running);
+	kfree(hash_str);
 	up(&dev->sem);
 	return retval;
 }
-- 
1.5.4.3

