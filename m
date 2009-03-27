Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZC0Uu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZC0Uu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZC0Uuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:50:50 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49517 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbZC0Uut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:50:49 -0400
Date: Fri, 27 Mar 2009 16:50:46 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] issue storage dev flush from generic file_fsync helper
Message-ID: <20090327205046.GA2036@havoc.gtf.org>
References: <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326032445.GA16999@havoc.gtf.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Simple and legacy blkdev-based filesystems such HFS, HFS+, ADFS, AFFS,
FAT, bfs, UFS, NTFS, and qnx4 all use file_fsync as their fsync(2)
VFS helper implementation.

Add a storage dev cache flush, to actually provide the guarantees that
are promised with fsync(2).

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

Out of 18 other places that call sync_blockdev(), only 3-4 are in
filesystems that arguably do not need or want a blkdev flush.  This
patch below clearly only addresses 1 out of ~15 callsites that really do
want metadata, data, and everything in between flushed to disk at the
sync_blockdev() callsite.

It should be noted that other calls are NOT used in fsync(2), but
rather than with guaranteed written data prior to major events such
as unmount, journal close, MD consistency check, etc.


diff --git a/fs/sync.c b/fs/sync.c
index a16d53e..24bb2f4 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/blkdev.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/writeback.h>
@@ -72,6 +73,13 @@ int file_fsync(struct file *filp, struct dentry *dentry, int datasync)
 	err = sync_blockdev(sb->s_bdev);
 	if (!ret)
 		ret = err;
+
+	err = blkdev_issue_flush(sb->s_bdev, NULL);
+	if (err == -EOPNOTSUPP)
+		err = 0;
+	if (!ret)
+		ret = err;
+
 	return ret;
 }
 
