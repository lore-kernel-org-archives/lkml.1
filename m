Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZC3BlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZC3BlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZC3Bk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:40:59 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60543 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZC3Bk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:40:59 -0400
Message-ID: <49D02328.7060108@oss.ntt.co.jp>
Date: Mon, 30 Mar 2009 10:40:56 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] ext3: call blkdev_issue_flush on fsync()
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp>
In-Reply-To: <49D01F94.6000101@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

diff -urNp linux-2.6.29-orig/fs/ext3/fsync.c linux-2.6.29/fs/ext3/fsync.c
--- linux-2.6.29-orig/fs/ext3/fsync.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/fs/ext3/fsync.c	2009-03-28 20:45:40.000000000 +0900
@@ -45,6 +45,8 @@
  int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
  {
  	struct inode *inode = dentry->d_inode;
+	journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
+	unsigned long i_state = inode->i_state;
  	int ret = 0;

  	J_ASSERT(ext3_journal_current_handle() == NULL);
@@ -69,23 +71,30 @@ int ext3_sync_file(struct file * file, s
  	 */
  	if (ext3_should_journal_data(inode)) {
  		ret = ext3_force_commit(inode->i_sb);
-		goto out;
+		if (!(journal->j_flags & JFS_BARRIER))
+			block_flush_device(inode->i_sb);
+		return ret;
  	}

-	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		goto out;
+	if (datasync && !(i_state & I_DIRTY_DATASYNC)) {
+		if (i_state & I_DIRTY_PAGES)
+			block_flush_device(inode->i_sb);
+		return ret;
+	}

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
+		if (journal && !(journal->j_flags & JFS_BARRIER))
+			block_flush_device(inode->i_sb);
  	}
-out:
+
  	return ret;
  }
