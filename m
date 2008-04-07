Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbYDGWgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbYDGWgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYDGWf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:35:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:24966 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbYDGWf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:35:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,619,1199692800"; 
   d="scan'208";a="228609186"
Subject: Re: [RFC PATCH] sysfs: refill attribute buffer when reading from
	offset 0
From: Dan Williams <dan.j.williams@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, htejun@gmail.com,
       neilb@suse.de
In-Reply-To: <20080405232959.c6504be8.akpm@linux-foundation.org>
References: <20080405184122.2816.35845.stgit@dwillia2-linux.ch.intel.com>
	 <20080405232959.c6504be8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 15:35:01 -0700
Message-Id: <1207607701.24149.21.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-05 at 23:29 -0700, Andrew Morton wrote:
> On Sat, 05 Apr 2008 11:41:22 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > Requiring userspace to close and re-open sysfs attributes has been the
> > policy since before 2.6.12.  It allows userspace to get a consistent
> > snapshot of kernel state and consume it with incremental reads and seeks.
> >
> > Now, if the file position is zero the kernel assumes userspace wants to see
> > the new value.
> 
> This does sound a sensible change.
> 
> >  The application for this change is to allow a userspace
> > RAID metadata handler to check the state of an array without causing any
> > memory allocations.  Thus not causing writeback to a raid array that might
> > be blocked waiting for userspace to take action.
> 
> Although that sounds like a rather, umm, optimistic application.  I guess
> if everything's mlocked you might get lucky.

Well at the very least userspace can now bypass a get_zeroed_page()
attempt after being notified that some state has changed.

[..]
> Has this been tested with pread()?  That should work - doing an lseek+read
> is plain dopey.

pread works as expected, i.e. if offset is non-zero the kernel returns
old data and new data otherwise.
> 
> Can we now remove need_read_fill?  Not if we want to support
> open+lseek+read, I guess - this initial read might not be at offset
> zero.

Also, sysfs_write_file invalidates the buffer (sets need_read_fill), so
it is still needed.

Here is an updated patch with changes to
Documentation/filesystems/sysfs.txt

----snip---->
sysfs: refill attribute buffer when reading from offset 0

From: Dan Williams <dan.j.williams@intel.com>

Requiring userspace to close and re-open sysfs attributes has been the
policy since before 2.6.12.  It allows userspace to get a consistent
snapshot of kernel state and consume it with incremental reads and seeks.

Now, if the file position is zero the kernel assumes userspace wants to see
the new value.  The application for this change is to allow a userspace
RAID metadata handler to check the state of an array without causing any
memory allocations.  Thus not causing writeback to a raid array that might
be blocked waiting for userspace to take action.

Cc: NeilBrown <neilb@suse.de>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
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


