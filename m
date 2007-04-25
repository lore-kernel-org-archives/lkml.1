Return-Path: <linux-kernel-owner+w=401wt.eu-S1161218AbXDYOjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161218AbXDYOjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161750AbXDYOjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:39:13 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:35520
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161218AbXDYOjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:39:12 -0400
Date: Wed, 25 Apr 2007 16:42:08 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore for misc char devices
Message-ID: <20070425144208.GO6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the misc character device driver uses a semaphore as mutex. use the
mutex API instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 7e975f6..afd7cf5 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -53,7 +53,7 @@
  * Head entry for the doubly linked miscdevice list
  */
 static LIST_HEAD(misc_list);
-static DECLARE_MUTEX(misc_sem);
+static DEFINE_MUTEX(misc_mtx);
 
 /*
  * Assigned numbers, used for dynamic minors
@@ -69,7 +69,7 @@ static void *misc_seq_start(struct seq_file *seq, loff_t *pos)
 	struct miscdevice *p;
 	loff_t off = 0;
 
-	down(&misc_sem);
+	mutex_lock(&misc_mtx);
 	list_for_each_entry(p, &misc_list, list) {
 		if (*pos == off++) 
 			return p;
@@ -89,7 +89,7 @@ static void *misc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 
 static void misc_seq_stop(struct seq_file *seq, void *v)
 {
-	up(&misc_sem);
+	mutex_unlock(&misc_mtx);
 }
 
 static int misc_seq_show(struct seq_file *seq, void *v)
@@ -129,7 +129,7 @@ static int misc_open(struct inode * inode, struct file * file)
 	int err = -ENODEV;
 	const struct file_operations *old_fops, *new_fops = NULL;
 	
-	down(&misc_sem);
+	mutex_lock(&misc_mtx);
 	
 	list_for_each_entry(c, &misc_list, list) {
 		if (c->minor == minor) {
@@ -139,9 +139,9 @@ static int misc_open(struct inode * inode, struct file * file)
 	}
 		
 	if (!new_fops) {
-		up(&misc_sem);
+		mutex_unlock(&misc_mtx);
 		request_module("char-major-%d-%d", MISC_MAJOR, minor);
-		down(&misc_sem);
+		mutex_lock(&misc_mtx);
 
 		list_for_each_entry(c, &misc_list, list) {
 			if (c->minor == minor) {
@@ -165,7 +165,7 @@ static int misc_open(struct inode * inode, struct file * file)
 	}
 	fops_put(old_fops);
 fail:
-	up(&misc_sem);
+	mutex_unlock(&misc_mtx);
 	return err;
 }
 
@@ -201,10 +201,10 @@ int misc_register(struct miscdevice * misc)
 
 	INIT_LIST_HEAD(&misc->list);
 
-	down(&misc_sem);
+	mutex_lock(&misc_mtx);
 	list_for_each_entry(c, &misc_list, list) {
 		if (c->minor == misc->minor) {
-			up(&misc_sem);
+			mutex_unlock(&misc_mtx);
 			return -EBUSY;
 		}
 	}
@@ -215,7 +215,7 @@ int misc_register(struct miscdevice * misc)
 			if ( (misc_minors[i>>3] & (1 << (i&7))) == 0)
 				break;
 		if (i<0) {
-			up(&misc_sem);
+			mutex_unlock(&misc_mtx);
 			return -EBUSY;
 		}
 		misc->minor = i;
@@ -238,7 +238,7 @@ int misc_register(struct miscdevice * misc)
 	 */
 	list_add(&misc->list, &misc_list);
  out:
-	up(&misc_sem);
+	mutex_unlock(&misc_mtx);
 	return err;
 }
 
@@ -259,13 +259,13 @@ int misc_deregister(struct miscdevice * misc)
 	if (list_empty(&misc->list))
 		return -EINVAL;
 
-	down(&misc_sem);
+	mutex_lock(&misc_mtx);
 	list_del(&misc->list);
 	device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	if (i < DYNAMIC_MINORS && i>0) {
 		misc_minors[i>>3] &= ~(1 << (misc->minor & 7));
 	}
-	up(&misc_sem);
+	mutex_unlock(&misc_mtx);
 	return 0;
 }
 

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

  Control over the use of one's ideas really constitutes control over other
  people's lives; and it is usually used to make their lives more difficult.
                          (Richard Stallman)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
