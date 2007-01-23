Return-Path: <linux-kernel-owner+w=401wt.eu-S965429AbXAWTgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965429AbXAWTgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965408AbXAWTg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:36:29 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:33095 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965430AbXAWTez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:34:55 -0500
Message-Id: <200701231927.l0NJReOw005343@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 2/7] UML - locking fixes in the ubd driver
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 23 Jan 2007 14:27:40 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some small locking and formatting fixes in the ubd driver.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/drivers/ubd_kern.c |   35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

Index: linux-2.6.18-mm/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/drivers/ubd_kern.c	2007-01-17 12:46:28.000000000 +1100
+++ linux-2.6.18-mm/arch/um/drivers/ubd_kern.c	2007-01-17 12:46:31.000000000 +1100
@@ -131,7 +131,6 @@ static const struct block_device_operati
 
 /* Protected by ubd_lock */
 static int fake_major = MAJOR_NR;
-
 static struct gendisk *ubd_gendisk[MAX_DEV];
 static struct gendisk *fake_gendisk[MAX_DEV];
 
@@ -142,10 +141,6 @@ static struct gendisk *fake_gendisk[MAX_
 #define OPEN_FLAGS ((struct openflags) { .r = 1, .w = 1, .s = 0, .c = 0, \
 					 .cl = 1 })
 #endif
-
-/* Not protected - changed only in ubd_setup_common and then only to
- * to enable O_SYNC.
- */
 static struct openflags global_openflags = OPEN_FLAGS;
 
 struct cow {
@@ -197,6 +192,7 @@ struct ubd {
 	.lock =			SPIN_LOCK_UNLOCKED,	\
 }
 
+/* Protected by ubd_lock */
 struct ubd ubd_devs[MAX_DEV] = { [ 0 ... MAX_DEV - 1 ] = DEFAULT_UBD };
 
 /* Only changed by fake_ide_setup which is a setup */
@@ -287,7 +283,7 @@ static int ubd_setup_common(char *str, i
 	struct ubd *ubd_dev;
 	struct openflags flags = global_openflags;
 	char *backing_file;
-	int n, err, i;
+	int n, err = 0, i;
 
 	if(index_out) *index_out = -1;
 	n = *str;
@@ -298,15 +294,16 @@ static int ubd_setup_common(char *str, i
 		str++;
 		if(!strcmp(str, "sync")){
 			global_openflags = of_sync(global_openflags);
-			return 0;
+			goto out1;
 		}
+
+		err = -EINVAL;
 		major = simple_strtoul(str, &end, 0);
 		if((*end != '\0') || (end == str)){
 			*error_out = "Didn't parse major number";
-			return -EINVAL;
+			goto out1;
 		}
 
-		err = -EINVAL;
 		mutex_lock(&ubd_lock);
 		if(fake_major != MAJOR_NR){
 			*error_out = "Can't assign a fake major twice";
@@ -472,12 +469,6 @@ static void do_ubd_request(request_queue
 /* Only changed by ubd_init, which is an initcall. */
 int thread_fd = -1;
 
-/* Changed by ubd_handler, which is serialized because interrupts only
- * happen on CPU 0.
- * XXX: currently unused.
- */
-static int intr_count = 0;
-
 /* call ubd_finish if you need to serialize */
 static void __ubd_finish(struct request *req, int error)
 {
@@ -517,7 +508,6 @@ static void ubd_handler(void)
 	int n;
 
 	do_ubd = 0;
-	intr_count++;
 	n = os_read_file(thread_fd, &req, sizeof(req));
 	if(n != sizeof(req)){
 		printk(KERN_ERR "Pid %d - spurious interrupt in ubd_handler, "
@@ -636,8 +626,7 @@ static int ubd_open_dev(struct ubd *ubd_
 }
 
 static int ubd_disk_register(int major, u64 size, int unit,
-			struct gendisk **disk_out)
-			
+			     struct gendisk **disk_out)
 {
 	struct gendisk *disk;
 
@@ -839,7 +828,7 @@ out:
 }
 
 /* All these are called by mconsole in process context and without
- * ubd-specific locks.
+ * ubd-specific locks.  The structure itself is const except for .list.
  */
 static struct mc_device ubd_mc = {
 	.list		= LIST_HEAD_INIT(ubd_mc.list),
@@ -862,13 +851,17 @@ static int __init ubd0_init(void)
 {
 	struct ubd *ubd_dev = &ubd_devs[0];
 
+	mutex_lock(&ubd_lock);
 	if(ubd_dev->file == NULL)
 		ubd_dev->file = "root_fs";
+	mutex_unlock(&ubd_lock);
+
 	return(0);
 }
 
 __initcall(ubd0_init);
 
+/* Used in ubd_init, which is an initcall */
 static struct platform_driver ubd_driver = {
 	.driver = {
 		.name  = DRIVER_NAME,
@@ -891,12 +884,14 @@ static int __init ubd_init(void)
 			return -1;
 	}
 	platform_driver_register(&ubd_driver);
+ 	mutex_lock(&ubd_lock);
 	for (i = 0; i < MAX_DEV; i++){
 		err = ubd_add(i, &error);
 		if(err)
 			printk(KERN_ERR "Failed to initialize ubd device %d :"
 			       "%s\n", i, error);
 	}
+ 	mutex_unlock(&ubd_lock);
 	return 0;
 }
 
@@ -1128,7 +1123,7 @@ static int ubd_ioctl(struct inode * inod
 				 sizeof(ubd_id)))
 			return(-EFAULT);
 		return(0);
-		
+
 	case CDROMVOLREAD:
 		if(copy_from_user(&volume, (char __user *) arg, sizeof(volume)))
 			return(-EFAULT);

