Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXCOTva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXCOTva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933588AbXCOTva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:51:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54369 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933473AbXCOTv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:51:29 -0400
Date: Thu, 15 Mar 2007 15:51:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: reinstate exclusion between method calls and attribute
 unregistration
In-Reply-To: <Pine.LNX.4.64.0703150944250.3816@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0703151550380.2482-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as869) reinstates the mutual exclusion between sysfs
attribute method calls and attribute unregistration.  The
previously-reported deadlocks have been fixed, and this exclusion is
by far the simplest way to avoid races during driver unbinding.

The check for orphaned read-buffers has been moved down slightly, so
that the remainder of a partially-read buffer will still be available
to userspace even after the attribute has been unregistered.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: 2.6.21-rc3-git9/fs/sysfs/inode.c
===================================================================
--- 2.6.21-rc3-git9.orig/fs/sysfs/inode.c
+++ 2.6.21-rc3-git9/fs/sysfs/inode.c
@@ -222,13 +222,17 @@ const unsigned char * sysfs_get_name(str
 
 static inline void orphan_all_buffers(struct inode *node)
 {
-	struct sysfs_buffer_collection *set = node->i_private;
+	struct sysfs_buffer_collection *set;
 	struct sysfs_buffer *buf;
 
 	mutex_lock_nested(&node->i_mutex, I_MUTEX_CHILD);
-	if (node->i_private) {
-		list_for_each_entry(buf, &set->associates, associates)
+	set = node->i_private;
+	if (set) {
+		list_for_each_entry(buf, &set->associates, associates) {
+			down(&buf->sem);
 			buf->orphaned = 1;
+			up(&buf->sem);
+		}
 	}
 	mutex_unlock(&node->i_mutex);
 }
Index: 2.6.21-rc3-git9/fs/sysfs/file.c
===================================================================
--- 2.6.21-rc3-git9.orig/fs/sysfs/file.c
+++ 2.6.21-rc3-git9/fs/sysfs/file.c
@@ -168,12 +168,12 @@ sysfs_read_file(struct file *file, char 
 	ssize_t retval = 0;
 
 	down(&buffer->sem);
-	if (buffer->orphaned) {
-		retval = -ENODEV;
-		goto out;
-	}
 	if (buffer->needs_read_fill) {
-		if ((retval = fill_read_buffer(file->f_path.dentry,buffer)))
+		if (buffer->orphaned)
+			retval = -ENODEV;
+		else
+			retval = fill_read_buffer(file->f_path.dentry,buffer);
+		if (retval)
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",

