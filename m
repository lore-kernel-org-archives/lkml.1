Return-Path: <linux-kernel-owner+w=401wt.eu-S1763544AbYDTKuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763544AbYDTKuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759807AbYDTKlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:41:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56356 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949AbYDTKlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:41:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/36] sysfs: refill attribute buffer when reading from offset 0
Date: Sun, 20 Apr 2008 03:46:00 -0700
Message-Id: <1208688366-9252-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

Requiring userspace to close and re-open sysfs attributes has been the
policy since before 2.6.12.  It allows userspace to get a consistent
snapshot of kernel state and consume it with incremental reads and seeks.

Now, if the file position is zero the kernel assumes userspace wants to see
the new value.  The application for this change is to allow a userspace
RAID metadata handler to check the state of an array without causing any
memory allocations.  Thus not causing writeback to a raid array that might
be blocked waiting for userspace to take action.

Cc: Neil Brown <neilb@suse.de>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/sysfs.txt |    9 +++++++--
 fs/sysfs/file.c                     |    5 ++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 4598ef7..7f27b8f 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -176,8 +176,10 @@ implementations:
   Recall that an attribute should only be exporting one value, or an
   array of similar values, so this shouldn't be that expensive. 
 
-  This allows userspace to do partial reads and seeks arbitrarily over
-  the entire file at will. 
+  This allows userspace to do partial reads and forward seeks
+  arbitrarily over the entire file at will. If userspace seeks back to
+  zero or does a pread(2) with an offset of '0' the show() method will
+  be called again, rearmed, to fill the buffer.
 
 - On write(2), sysfs expects the entire buffer to be passed during the
   first write. Sysfs then passes the entire buffer to the store()
@@ -192,6 +194,9 @@ implementations:
 
 Other notes:
 
+- Writing causes the show() method to be rearmed regardless of current
+  file position.
+
 - The buffer will always be PAGE_SIZE bytes in length. On i386, this
   is 4096. 
 
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index a859c32..ade9a7e 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -129,7 +129,7 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	ssize_t retval = 0;
 
 	mutex_lock(&buffer->mutex);
-	if (buffer->needs_read_fill) {
+	if (buffer->needs_read_fill || *ppos == 0) {
 		retval = fill_read_buffer(file->f_path.dentry,buffer);
 		if (retval)
 			goto out;
@@ -410,8 +410,7 @@ static int sysfs_release(struct inode *inode, struct file *filp)
  * return POLLERR|POLLPRI, and select will return the fd whether
  * it is waiting for read, write, or exceptions.
  * Once poll/select indicates that the value has changed, you
- * need to close and re-open the file, as simply seeking and reading
- * again will not get new data, or reset the state of 'poll'.
+ * need to close and re-open the file, or seek to 0 and read again.
  * Reminder: this only works for attributes which actively support
  * it, and it is not possible to test an attribute from userspace
  * to see if it supports poll (Neither 'poll' nor 'select' return
-- 
1.5.4.5

