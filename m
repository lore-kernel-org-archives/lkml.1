Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYIISCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYIISCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYIISCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:02:37 -0400
Received: from verein.lst.de ([213.95.11.210]:47808 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbYIISCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:02:36 -0400
Date: Tue, 9 Sep 2008 20:02:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] update Documentation/filesystems/Locking for 2.6.27 changes
Message-ID: <20080909180201.GA22200@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the 2.6.27 circle ->fasync lost the BKL, and the last remaining
->open variant that takes the BKL is also gone.  ->get_sb and ->kill_sb
didn't have BKL forever, so updated the entries while we're at that.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/Documentation/filesystems/Locking
===================================================================
--- linux-2.6.orig/Documentation/filesystems/Locking	2008-09-09 19:57:03.000000000 +0200
+++ linux-2.6/Documentation/filesystems/Locking	2008-09-09 19:59:46.000000000 +0200
@@ -144,8 +144,8 @@ prototypes:
 	void (*kill_sb) (struct super_block *);
 locking rules:
 		may block	BKL
-get_sb		yes		yes
-kill_sb		yes		yes
+get_sb		yes		no
+kill_sb		yes		no
 
 ->get_sb() returns error or 0 with locked superblock attached to the vfsmount
 (exclusive on ->s_umount).
@@ -409,12 +409,12 @@ ioctl:			yes	(see below)
 unlocked_ioctl:		no	(see below)
 compat_ioctl:		no
 mmap:			no
-open:			maybe	(see below)
+open:			no
 flush:			no
 release:		no
 fsync:			no	(see below)
 aio_fsync:		no
-fasync:			yes	(see below)
+fasync:			no
 lock:			yes
 readv:			no
 writev:			no
@@ -431,13 +431,6 @@ For many filesystems, it is probably saf
 semaphore.  Note some filesystems (i.e. remote ones) provide no
 protection for i_size so you will need to use the BKL.
 
-->open() locking is in-transit: big lock partially moved into the methods.
-The only exception is ->open() in the instances of file_operations that never
-end up in ->i_fop/->proc_fops, i.e. ones that belong to character devices
-(chrdev_open() takes lock before replacing ->f_op and calling the secondary
-method. As soon as we fix the handling of module reference counters all
-instances of ->open() will be called without the BKL.
-
 Note: ext2_release() was *the* source of contention on fs-intensive
 loads and dropping BKL on ->release() helps to get rid of that (we still
 grab BKL for cases when we close a file that had been opened r/w, but that
