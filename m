Return-Path: <linux-kernel-owner+w=401wt.eu-S1762636AbXGWWpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbXGWWpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXGWWpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:45:01 -0400
Received: from ozlabs.org ([203.10.76.45]:57593 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbXGWWpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:45:00 -0400
Subject: Re: [PATCH 3/3] readahead: scale max readahead size depending on
	memory size
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
In-Reply-To: <20070723100438.GA13963@lazybastard.org>
References: <20070721210005.000228000@chello.nl>
	 <20070721210052.497469000@chello.nl> <20070722082434.GR11657@kernel.dk>
	 <1185093405.20032.205.camel@twins> <20070722085041.GS11657@kernel.dk>
	 <1185095852.20032.229.camel@twins> <20070722164403.GU11657@kernel.dk>
	 <20070723100438.GA13963@lazybastard.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 24 Jul 2007 08:44:21 +1000
Message-Id: <1185230661.1803.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 12:04 +0200, Jörn Engel wrote:
> I believe this whole thing is fundamentally flawed.  The perfect
> readahead size depends on the device in question.  If we set a single
> system-wide value depending on memory size, it may easily be too small
> and too large at the same time.  Think hard disk and SSD.

Well, I think the filesystem should get the first shot at altering the
readahead heuristic (we should add a hook so it can then ask the
underlying device).

Something like:
===
Hook for filesystems to tweak readahead logic

It was suggested at Fengguang's OLS talk that filesystems can make a
useful contribution to the readahead logic: avoiding seeks and lock
boundaries (on cluster filesystems) and other such filesystem-specific
things.

The alter_readahead hook should return the number of pages to read.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

---
 Documentation/filesystems/vfs.txt |   10 ++++++----
 include/linux/fs.h                |    1 +
 mm/readahead.c                    |   12 ++++++++++++
 3 files changed, 19 insertions(+), 4 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/include/linux/fs.h
+++ linux-2.6.22-rc6-mm1/include/linux/fs.h
@@ -1204,7 +1204,8 @@ struct file_operations {
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*revoke)(struct file *, struct address_space *);
+	unsigned long (*alter_readahead)(struct file *, pgoff_t, unsigned long, pgoff_t, unsigned long);
 };
 
 struct inode_operations {
--- linux-2.6.22-rc6-mm1.orig/mm/readahead.c
+++ linux-2.6.22-rc6-mm1/mm/readahead.c
@@ -394,7 +394,19 @@ ondemand_readahead(struct address_space 
 	}
 
 readit:
+	/*
+	 * Give filesystem a chance to tweak readahead size (eg. to
+	 * contiguous block boundary).  It should probably not change
+	 * by more than 50% otherwise it's really ignoring our
+	 * readahead advice.
+	 */
+	if (filp->f_op->alter_readahead) {
+		ra->size = filp->f_op->alter_readahead(filp, offset, req_size,
+						       ra->start, ra->size);
+		if (ra->async_size > ra->size)
+			ra->async_size = ra->size;
+	}
 	return ra_submit(ra, mapping, filp);
 }
 
--- linux-2.6.22-rc6-mm1.orig/Documentation/filesystems/vfs.txt
+++ linux-2.6.22-rc6-mm1/Documentation/filesystems/vfs.txt
@@ -777,11 +777,10 @@ struct file_operations {
 	int (*check_flags)(int);
 	int (*dir_notify)(struct file *filp, unsigned long arg);
 	int (*flock) (struct file *, int, struct file_lock *);
-	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned 
-int);
-	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned  
-int);
+	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned int);
+	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*revoke)(struct file *);
+	unsigned long (*alter_readahead)(struct file *, pgoff_t, unsigned long, pgoff_t, unsigned long);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -859,6 +858,9 @@ otherwise noted.
 	  to an open file. This method must ensure that all currently blocked
 	  writes are flushed and reads will fail.
 
+  alter_readahead: called when the readahead logic is about to submit a
+                   readahead request for I/O
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides. When opening a device node
 (character or block special) most filesystems will call special


