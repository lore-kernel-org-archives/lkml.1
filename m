Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbZEUUCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbZEUUCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756580AbZEUUBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:01:20 -0400
Received: from thunk.org ([69.25.196.29]:39204 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbZEUUBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:01:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       krh@redhat.com, stefanr@s5r6.in-berlin.de
Subject: [PATCH 2/5] fs: Remove i_cindex from struct inode
Date: Thu, 21 May 2009 16:01:00 -0400
Message-Id: <1242936063-31689-3-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.1.1.g75fc.dirty
In-Reply-To: <1242936063-31689-2-git-send-email-tytso@mit.edu>
References: <1242936063-31689-1-git-send-email-tytso@mit.edu>
 <1242936063-31689-2-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user of the i_cindex element in the inode structure is used
is by the firewire drivers.  As part of an attempt to slim down the
inode structure to save memory --- since a typical Linux system will
have hundreds of thousands if not millions of inodes cached, a
reduction in the size inode has high leverage.

The firewire driver does not need i_cindex in any fast path, so it's
simple enough to calculate when it is needed, instead of wasting space
in the inode structure.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: krh@redhat.com
Cc: stefanr@s5r6.in-berlin.de
Cc: linux-fsdevel@vger.kernel.org
---
 drivers/ieee1394/dv1394.c        |    5 +++--
 drivers/ieee1394/ieee1394_core.h |    5 ++++-
 fs/char_dev.c                    |   14 +++++++++++++-
 include/linux/cdev.h             |    2 ++
 include/linux/fs.h               |    1 -
 5 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index 823a629..2cd00b5 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -1789,12 +1789,13 @@ static int dv1394_open(struct inode *inode, struct file *file)
 	} else {
 		/* look up the card by ID */
 		unsigned long flags;
+		int idx = ieee1394_file_to_instance(file);
 
 		spin_lock_irqsave(&dv1394_cards_lock, flags);
 		if (!list_empty(&dv1394_cards)) {
 			struct video_card *p;
 			list_for_each_entry(p, &dv1394_cards, list) {
-				if ((p->id) == ieee1394_file_to_instance(file)) {
+				if ((p->id) == idx) {
 					video = p;
 					break;
 				}
@@ -1803,7 +1804,7 @@ static int dv1394_open(struct inode *inode, struct file *file)
 		spin_unlock_irqrestore(&dv1394_cards_lock, flags);
 
 		if (!video) {
-			debug_printk("dv1394: OHCI card %d not found", ieee1394_file_to_instance(file));
+			debug_printk("dv1394: OHCI card %d not found", idx);
 			return -ENODEV;
 		}
 
diff --git a/drivers/ieee1394/ieee1394_core.h b/drivers/ieee1394/ieee1394_core.h
index 21d50f7..fda0f5e 100644
--- a/drivers/ieee1394/ieee1394_core.h
+++ b/drivers/ieee1394/ieee1394_core.h
@@ -155,7 +155,10 @@ void hpsb_packet_received(struct hpsb_host *host, quadlet_t *data, size_t size,
  */
 static inline unsigned char ieee1394_file_to_instance(struct file *file)
 {
-	return file->f_path.dentry->d_inode->i_cindex;
+	int idx = cdev_index(file->f_path.dentry->d_inode);
+	if (idx < 0)
+		idx = 0;
+	return idx;
 }
 
 extern int hpsb_disable_irm;
diff --git a/fs/char_dev.c b/fs/char_dev.c
index 38f7122..b7c9d51 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -375,7 +375,6 @@ static int chrdev_open(struct inode *inode, struct file *filp)
 		p = inode->i_cdev;
 		if (!p) {
 			inode->i_cdev = p = new;
-			inode->i_cindex = idx;
 			list_add(&inode->i_devices, &p->list);
 			new = NULL;
 		} else if (!cdev_get(p))
@@ -405,6 +404,18 @@ static int chrdev_open(struct inode *inode, struct file *filp)
 	return ret;
 }
 
+int cdev_index(struct inode *inode)
+{
+	int idx;
+	struct kobject *kobj;
+
+	kobj = kobj_lookup(cdev_map, inode->i_rdev, &idx);
+	if (!kobj)
+		return -1;
+	kobject_put(kobj);
+	return idx;
+}
+
 void cd_forget(struct inode *inode)
 {
 	spin_lock(&cdev_lock);
@@ -557,6 +568,7 @@ EXPORT_SYMBOL(cdev_init);
 EXPORT_SYMBOL(cdev_alloc);
 EXPORT_SYMBOL(cdev_del);
 EXPORT_SYMBOL(cdev_add);
+EXPORT_SYMBOL(cdev_index);
 EXPORT_SYMBOL(register_chrdev);
 EXPORT_SYMBOL(unregister_chrdev);
 EXPORT_SYMBOL(directly_mappable_cdev_bdi);
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index fb45919..f389e31 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -28,6 +28,8 @@ int cdev_add(struct cdev *, dev_t, unsigned);
 
 void cdev_del(struct cdev *);
 
+int cdev_index(struct inode *inode);
+
 void cd_forget(struct inode *);
 
 extern struct backing_dev_info directly_mappable_cdev_bdi;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9b20f13..e3b8334 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -751,7 +751,6 @@ struct inode {
 		struct block_device	*i_bdev;
 		struct cdev		*i_cdev;
 	};
-	int			i_cindex;
 
 	__u32			i_generation;
 
-- 
1.6.3.1.1.g75fc.dirty

