Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbZANEIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbZANEIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 23:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZANEIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 23:08:38 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60743 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZANEIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 23:08:37 -0500
X-Greylist: delayed 1876 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 23:08:36 EST
Subject: Re: ext2 + -osync: not as easy as it seems
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com
In-Reply-To: <20090113143011.GB10064@duck.suse.cz>
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz>
	 <20090113134503.41318144@lxorguk.ukuu.org.uk>
	 <20090113140347.GD17664@mit.edu>  <20090113143011.GB10064@duck.suse.cz>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 14 Jan 2009 12:37:19 +0900
Message-Id: <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCing Eric Sandeen)

On Tue, 2009-01-13 at 15:30 +0100, Jan Kara wrote:
> On Tue 13-01-09 09:03:47, Theodore Tso wrote:
> > Adding a barrier shouldn't be that hard; just a matter adding a call
> > to blkdev_issue_flush() to ext2_sync_file() before it returns.
>   Yes. Something like the patch below?
> 
>   But it's not the whole story. Strictly speaking we should also call
> blkdev_issue_flush() whenever we write things because of O_SYNC or
> O_DIRSYNC flags. My patch does also that (it's based on the previous ext2
> patch I've sent a while before).

Commit d755fb384250d6bd7fd18a0930e71965acc8e72e added a call to
blkdev_issue_flush to ext4_sync_file, and looking at its ext3
counterpart it seems it might be needed there too.

I may be missing something, but is it possible to ensure the inode hits
the platter without the patch below?

--

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Subject: ext3: call blkdev_issue_flush on fsync

To ensure that bits are truly on-disk after an fsync, we should call
blkdev_issue_flush if barriers are supported.

This is a straight port of a similar patch written by Eric Sandeen for
ext4 (commit d755fb384250d6bd7fd18a0930e71965acc8e72e).

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.29-rc1-orig/fs/ext3/fsync.c linux-2.6.29-rc1/fs/ext3/fsync.c
--- linux-2.6.29-rc1-orig/fs/ext3/fsync.c	2008-12-25 08:26:37.000000000 +0900
+++ linux-2.6.29-rc1/fs/ext3/fsync.c	2009-01-14 11:45:47.000000000 +0900
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/writeback.h>
 #include <linux/jbd.h>
+#include <linux/blkdev.h>
 #include <linux/ext3_fs.h>
 #include <linux/ext3_jbd.h>
 
@@ -45,6 +46,7 @@
 int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
+	journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
 	int ret = 0;
 
 	J_ASSERT(ext3_journal_current_handle() == NULL);
@@ -85,6 +87,9 @@ int ext3_sync_file(struct file * file, s
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
 		ret = sync_inode(inode, &wbc);
+
+		if (journal && (journal->j_flags & JFS_BARRIER))
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	}
 out:
 	return ret;


