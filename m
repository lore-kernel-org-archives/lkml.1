Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZBLKmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZBLKmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbZBLKks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:40:48 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:46172 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758968AbZBLKkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:40:46 -0500
Subject: ext4: call blkdev_issue_flush on fsync
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com,
       fernando@kic.ac.jp
In-Reply-To: <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
References: <20090114165952.GH6222@mit.edu>
	 <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090115234544.GA7579@duck.suse.cz>
	 <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090116163039.GE10617@duck.suse.cz>
	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 12 Feb 2009 19:40:45 +0900
Message-Id: <1234435245.15433.19.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To ensure that bits are truly on-disk after an fsync or fdatasync, we
should force a disk flush explicitly when there is dirty data/metadata
and the journal didn't emit a write barrier (either because metadata is
not being synched or barriers are disabled).

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.29-rc4-orig/fs/ext4/fsync.c linux-2.6.29-rc4/fs/ext4/fsync.c
--- linux-2.6.29-rc4-orig/fs/ext4/fsync.c	2008-12-25 08:26:37.000000000 +0900
+++ linux-2.6.29-rc4/fs/ext4/fsync.c	2009-02-12 19:22:28.000000000 +0900
@@ -48,6 +48,7 @@ int ext4_sync_file(struct file *file, st
 {
 	struct inode *inode = dentry->d_inode;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	unsigned long i_state = inode->i_state;
 	int ret = 0;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
@@ -76,25 +77,34 @@ int ext4_sync_file(struct file *file, st
 	 */
 	if (ext4_should_journal_data(inode)) {
 		ret = ext4_force_commit(inode->i_sb);
+		if (!(journal->j_flags & JBD2_BARRIER))
+			goto no_journal_barrier;
 		goto out;
 	}
 
-	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		goto out;
+	if (datasync && !(i_state & I_DIRTY_DATASYNC))
+		goto flush_blkdev;
 
 	/*
 	 * The VFS has written the file data.  If the inode is unaltered
 	 * then we need not start a commit.
 	 */
-	if (inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC)) {
+	if (i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC)) {
 		struct writeback_control wbc = {
 			.sync_mode = WB_SYNC_ALL,
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
 		ret = sync_inode(inode, &wbc);
-		if (journal && (journal->j_flags & JBD2_BARRIER))
-			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+		if (journal && !(journal->j_flags & JBD2_BARRIER))
+			goto no_journal_barrier;
+		goto out;
 	}
+
+flush_blkdev:
+	if (!(i_state & I_DIRTY_PAGES))
+		goto out;
+no_journal_barrier:
+	block_flush_device(inode->i_sb);
 out:
 	return ret;
 }


