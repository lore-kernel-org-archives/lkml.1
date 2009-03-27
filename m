Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbZC0H5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbZC0H5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZC0H50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:57:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39713 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbZC0H50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:57:26 -0400
Date: Fri, 27 Mar 2009 08:57:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327075723.GT27476@kernel.dk>
References: <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25 2009, Linus Torvalds wrote:
> 
> 
> On Wed, 25 Mar 2009, Jeff Garzik wrote:
> > 
> > It is clearly possible to implement an fsync(2) that causes FLUSH CACHE to be
> > issued, without adding full barrier support to a filesystem.  It is likely
> > doable to avoid touching per-filesystem code at all, if we issue the flush
> > from a generic fsync(2) code path in the kernel.
> 
> We could easily do that. It would even work for most cases. The 
> problematic ones are where filesystems do their own disk management, but I 
> guess those people can do their own fsync() management too.
> 
> Somebody send me the patch, we can try it out.

Here's a simple patch that does that. Not even tested, it compiles. Note
that file systems that currently do blkdev_issue_flush() in their
->sync() should then get it removed.

> > Remember, fsync(2) means that the user _expects_ a performance hit.
> 
> Within reason, though.
> 
> OS X, for example, doesn't do the disk barrier. It requires you to do a 
> separate FULL_FSYNC (or something similar) ioctl to get that. Apparently 
> exactly because users don't expect quite _that_ big of a performance hit.
> 
> (Or maybe just because it was easier to do that way. Never attribute to 
> malice what can be sufficiently explained by stupidity).

It'd be better to have a knob to control whether fsync() should care
about the hardware side as well, instead of trying to teach applications
to use FULL_FSYNC.

diff --git a/fs/sync.c b/fs/sync.c
index ec95a69..7a44d4e 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/writeback.h>
+#include <linux/blkdev.h>
 #include <linux/syscalls.h>
 #include <linux/linkage.h>
 #include <linux/pagemap.h>
@@ -104,6 +105,7 @@ int vfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 {
 	const struct file_operations *fop;
 	struct address_space *mapping;
+	struct block_device *bdev;
 	int err, ret;
 
 	/*
@@ -138,6 +140,13 @@ int vfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 	err = filemap_fdatawait(mapping);
 	if (!ret)
 		ret = err;
+
+	bdev = mapping->host->i_sb->s_bdev;
+	if (bdev) {
+		err = blkdev_issue_flush(bdev, NULL);
+		if (!ret)
+			ret = err;
+	}
 out:
 	return ret;
 }

-- 
Jens Axboe

