Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbYB0TTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbYB0TTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbYB0TTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:19:08 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:17185 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYB0TTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:19:06 -0500
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, akpm@linux-foundation.org
Subject: [PATCH 2/2] IB/uverbs: Use anonymous inodes instead of private filesystem
X-Message-Flag: Warning: May contain useful information
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 27 Feb 2008 11:18:57 -0800
In-Reply-To: <adak5kqyzv1.fsf@cisco.com> (Roland Dreier's message of "Wed, 27 Feb 2008 11:16:02 -0800")
Message-ID: <adafxveyzq6.fsf_-_@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Feb 2008 19:18:59.0737 (UTC) FILETIME=[9AEC4890:01C87975]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that anonymous inodes allow us to control when fd_install() is
called, we can convert ib_uverbs to use them instead of its own
private infinibandeventfs virtual filesystem.  This removes a healthy
chunk of code and also deletes the last in-tree user of
get_empty_filp(), which makes Christoph Hellwig happy.

Tested with an app that uses the ib_uverbs event file interfaces.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/infiniband/core/uverbs_main.c |   76 ++++-----------------------------
 1 files changed, 9 insertions(+), 67 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 7c2ac39..7629566 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -40,11 +40,10 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/file.h>
-#include <linux/mount.h>
 #include <linux/cdev.h>
+#include <linux/anon_inodes.h>
 
 #include <asm/uaccess.h>
 
@@ -54,8 +53,6 @@ MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace verbs access");
 MODULE_LICENSE("Dual BSD/GPL");
 
-#define INFINIBANDEVENTFS_MAGIC	0x49426576	/* "IBev" */
-
 enum {
 	IB_UVERBS_MAJOR       = 231,
 	IB_UVERBS_BASE_MINOR  = 192,
@@ -112,8 +109,6 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_DESTROY_SRQ]   	= ib_uverbs_destroy_srq,
 };
 
-static struct vfsmount *uverbs_event_mnt;
-
 static void ib_uverbs_add_one(struct ib_device *device);
 static void ib_uverbs_remove_one(struct ib_device *device);
 
@@ -495,6 +490,7 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					int is_async, int *fd)
 {
 	struct ib_uverbs_event_file *ev_file;
+	struct inode *inode;
 	struct file *filp;
 	int ret;
 
@@ -510,37 +506,19 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 	ev_file->async_queue = NULL;
 	ev_file->is_async    = is_async;
 
-	*fd = get_unused_fd();
-	if (*fd < 0) {
-		ret = *fd;
-		goto err;
-	}
-
-	filp = get_empty_filp();
-	if (!filp) {
-		ret = -ENFILE;
-		goto err_fd;
-	}
-
-	ev_file->file      = filp;
-
 	/*
 	 * fops_get() can't fail here, because we're coming from a
 	 * system call on a uverbs file, which will already have a
 	 * module reference.
 	 */
-	filp->f_op 	   = fops_get(&uverbs_event_fops);
-	filp->f_path.mnt 	   = mntget(uverbs_event_mnt);
-	filp->f_path.dentry 	   = dget(uverbs_event_mnt->mnt_root);
-	filp->f_mapping    = filp->f_path.dentry->d_inode->i_mapping;
-	filp->f_flags      = O_RDONLY;
-	filp->f_mode       = FMODE_READ;
-	filp->private_data = ev_file;
+	ret = anon_inode_allocfd(fd, &inode, &filp, "[uverbs-event]",
+				 fops_get(&uverbs_event_fops), ev_file);
+	if (ret)
+		goto err;
 
-	return filp;
+	ev_file->file = filp;
 
-err_fd:
-	put_unused_fd(*fd);
+	return filp;
 
 err:
 	kfree(ev_file);
@@ -817,21 +795,6 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 	kfree(uverbs_dev);
 }
 
-static int uverbs_event_get_sb(struct file_system_type *fs_type, int flags,
-			       const char *dev_name, void *data,
-			       struct vfsmount *mnt)
-{
-	return get_sb_pseudo(fs_type, "infinibandevent:", NULL,
-			     INFINIBANDEVENTFS_MAGIC, mnt);
-}
-
-static struct file_system_type uverbs_event_fs = {
-	/* No owner field so module can be unloaded */
-	.name    = "infinibandeventfs",
-	.get_sb  = uverbs_event_get_sb,
-	.kill_sb = kill_litter_super
-};
-
 static int __init ib_uverbs_init(void)
 {
 	int ret;
@@ -858,33 +821,14 @@ static int __init ib_uverbs_init(void)
 		goto out_class;
 	}
 
-	ret = register_filesystem(&uverbs_event_fs);
-	if (ret) {
-		printk(KERN_ERR "user_verbs: couldn't register infinibandeventfs\n");
-		goto out_class;
-	}
-
-	uverbs_event_mnt = kern_mount(&uverbs_event_fs);
-	if (IS_ERR(uverbs_event_mnt)) {
-		ret = PTR_ERR(uverbs_event_mnt);
-		printk(KERN_ERR "user_verbs: couldn't mount infinibandeventfs\n");
-		goto out_fs;
-	}
-
 	ret = ib_register_client(&uverbs_client);
 	if (ret) {
 		printk(KERN_ERR "user_verbs: couldn't register client\n");
-		goto out_mnt;
+		goto out_class;
 	}
 
 	return 0;
 
-out_mnt:
-	mntput(uverbs_event_mnt);
-
-out_fs:
-	unregister_filesystem(&uverbs_event_fs);
-
 out_class:
 	class_destroy(uverbs_class);
 
@@ -898,8 +842,6 @@ out:
 static void __exit ib_uverbs_cleanup(void)
 {
 	ib_unregister_client(&uverbs_client);
-	mntput(uverbs_event_mnt);
-	unregister_filesystem(&uverbs_event_fs);
 	class_destroy(uverbs_class);
 	unregister_chrdev_region(IB_UVERBS_BASE_DEV, IB_UVERBS_MAX_DEVICES);
 	idr_destroy(&ib_uverbs_pd_idr);
-- 
1.5.4.2

