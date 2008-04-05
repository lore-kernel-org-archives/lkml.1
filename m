Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYDESmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYDESmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 14:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYDESmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 14:42:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:56633 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbYDESmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 14:42:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,609,1199692800"; 
   d="scan'208";a="546255030"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH] sysfs: refill attribute buffer when reading from offset 0
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com, neilb@suse.de
Date: Sat, 05 Apr 2008 11:41:22 -0700
Message-ID: <20080405184122.2816.35845.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requiring userspace to close and re-open sysfs attributes has been the
policy since before 2.6.12.  It allows userspace to get a consistent
snapshot of kernel state and consume it with incremental reads and seeks.

Now, if the file position is zero the kernel assumes userspace wants to see
the new value.  The application for this change is to allow a userspace
RAID metadata handler to check the state of an array without causing any
memory allocations.  Thus not causing writeback to a raid array that might
be blocked waiting for userspace to take action.

Cc: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 fs/sysfs/file.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index baa663e..0a26ba8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -128,7 +128,7 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	ssize_t retval = 0;
 
 	mutex_lock(&buffer->mutex);
-	if (buffer->needs_read_fill) {
+	if (buffer->needs_read_fill || *ppos == 0) {
 		retval = fill_read_buffer(file->f_path.dentry,buffer);
 		if (retval)
 			goto out;
@@ -409,8 +409,7 @@ static int sysfs_release(struct inode *inode, struct file *filp)
  * return POLLERR|POLLPRI, and select will return the fd whether
  * it is waiting for read, write, or exceptions.
  * Once poll/select indicates that the value has changed, you
- * need to close and re-open the file, as simply seeking and reading
- * again will not get new data, or reset the state of 'poll'.
+ * need to close and re-open the file, or seek to 0 and read again.
  * Reminder: this only works for attributes which actively support
  * it, and it is not possible to test an attribute from userspace
  * to see if it supports poll (Neither 'poll' nor 'select' return

