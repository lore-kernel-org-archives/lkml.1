Return-Path: <linux-kernel-owner+w=401wt.eu-S935271AbZAPOAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935271AbZAPOAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935095AbZAPN7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:59:47 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59541 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566AbZAPN7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:59:46 -0500
Subject: ext4: call blkdev_issue_flush on fsync
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com,
       fernando@kic.ac.jp
In-Reply-To: <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>
References: <20090113140347.GD17664@mit.edu>
	 <20090113143011.GB10064@duck.suse.cz>
	 <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090114103532.GA18834@duck.suse.cz> <20090114132146.GC6222@mit.edu>
	 <20090114140532.GC19950@duck.suse.cz> <20090114141204.GD6222@mit.edu>
	 <20090114143756.GF19950@duck.suse.cz> <20090114165952.GH6222@mit.edu>
	 <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090115234544.GA7579@duck.suse.cz>
	 <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Fri, 16 Jan 2009 22:59:44 +0900
Message-Id: <1232114384.13775.68.camel@sebastian.kern.oss.ntt.co.jp>
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

--- linux-2.6.29-rc1-orig/fs/ext4/fsync.c	2008-12-25 08:26:37.000000000 +0900
+++ linux-2.6.29-rc1/fs/ext4/fsync.c	2009-01-16 22:18:51.000000000 +0900
@@ -48,6 +48,7 @@ int ext4_sync_file(struct file *file, st
 {
 	struct inode *inode = dentry->d_inode;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	unsigned long i_state = inode->i_state;
 	int ret = 0;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
@@ -76,25 +77,33 @@ int ext4_sync_file(struct file *file, st
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
 	}
+
+flush_blkdev:
+	if (!(i_state & I_DIRTY_PAGES))
+		goto out;
+no_journal_barrier:
+	blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 out:
 	return ret;
 }


