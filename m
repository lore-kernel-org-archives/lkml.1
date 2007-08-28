Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbXH1QJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbXH1QJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbXH1QJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:09:03 -0400
Received: from styx.suse.cz ([82.119.242.94]:37863 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752372AbXH1QJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:09:01 -0400
Date: Tue, 28 Aug 2007 18:28:02 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xb <xavier.bru@bull.net>
Subject: [PATCH] Fix infinite loop in quota
Message-ID: <20070828162802.GE5869@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8NvZYKFJsRX2Djef"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi!

  Attached patch fixes possible infinite loop in dqput() when quota code
fails to start a transaction on a filesystem. Andrew, please apply. Thanks.

								Honza

PS: Thanks goes to Xavier for spotting and analyzing the problem.

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--8NvZYKFJsRX2Djef
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="quota-2.6.23-rc4-1-quotaoff_hang.diff"

If we fail to start a transaction when releasing dquot, we have to call
dquot_release() anyway to mark dquot structure as inactive. Otherwise
we end in an infinite loop inside dqput().

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-rc4/fs/ext3/super.c linux-2.6.23-rc4-1-quotaoff_hang/fs/ext3/super.c
--- linux-2.6.23-rc4/fs/ext3/super.c	2007-08-28 14:08:51.000000000 +0200
+++ linux-2.6.23-rc4-1-quotaoff_hang/fs/ext3/super.c	2007-08-28 18:21:38.000000000 +0200
@@ -2578,8 +2578,11 @@ static int ext3_release_dquot(struct dqu
 
 	handle = ext3_journal_start(dquot_to_inode(dquot),
 					EXT3_QUOTA_DEL_BLOCKS(dquot->dq_sb));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		/* Release dquot anyway to avoid endless cycle in dqput() */
+		dquot_release(dquot);
 		return PTR_ERR(handle);
+	}
 	ret = dquot_release(dquot);
 	err = ext3_journal_stop(handle);
 	if (!ret)
@@ -2712,6 +2715,12 @@ static ssize_t ext3_quota_write(struct s
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
 
+	if (!handle) {
+		printk(KERN_WARNING "EXT3-fs: Quota write (off=%Lu, len=%Lu)"
+			" cancelled because transaction is not started.\n",
+			(unsigned long long)off, (unsigned long long)len);
+		return -EIO;
+	}
 	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-rc4/fs/ext4/super.c linux-2.6.23-rc4-1-quotaoff_hang/fs/ext4/super.c
--- linux-2.6.23-rc4/fs/ext4/super.c	2007-08-28 14:08:52.000000000 +0200
+++ linux-2.6.23-rc4-1-quotaoff_hang/fs/ext4/super.c	2007-08-28 17:31:54.000000000 +0200
@@ -2698,8 +2698,11 @@ static int ext4_release_dquot(struct dqu
 
 	handle = ext4_journal_start(dquot_to_inode(dquot),
 					EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		/* Release dquot anyway to avoid endless cycle in dqput() */
+		dquot_release(dquot);
 		return PTR_ERR(handle);
+	}
 	ret = dquot_release(dquot);
 	err = ext4_journal_stop(handle);
 	if (!ret)
@@ -2832,6 +2835,12 @@ static ssize_t ext4_quota_write(struct s
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
 
+	if (!handle) {
+		printk(KERN_WARNING "EXT4-fs: Quota write (off=%Lu, len=%Lu)"
+			" cancelled because transaction is not started.\n",
+			(unsigned long long)off, (unsigned long long)len);
+		return -EIO;
+	}
 	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-rc4/fs/reiserfs/super.c linux-2.6.23-rc4-1-quotaoff_hang/fs/reiserfs/super.c
--- linux-2.6.23-rc4/fs/reiserfs/super.c	2007-08-28 14:08:54.000000000 +0200
+++ linux-2.6.23-rc4-1-quotaoff_hang/fs/reiserfs/super.c	2007-08-28 17:41:07.000000000 +0200
@@ -1915,8 +1915,11 @@ static int reiserfs_release_dquot(struct
 	ret =
 	    journal_begin(&th, dquot->dq_sb,
 			  REISERFS_QUOTA_DEL_BLOCKS(dquot->dq_sb));
-	if (ret)
+	if (ret) {
+		/* Release dquot anyway to avoid endless cycle in dqput() */
+		dquot_release(dquot);
 		goto out;
+	}
 	ret = dquot_release(dquot);
 	err =
 	    journal_end(&th, dquot->dq_sb,
@@ -2067,6 +2070,12 @@ static ssize_t reiserfs_quota_write(stru
 	size_t towrite = len;
 	struct buffer_head tmp_bh, *bh;
 
+	if (!current->journal_info) {
+		printk(KERN_WARNING "reiserfs: Quota write (off=%Lu, len=%Lu)"
+			" cancelled because transaction is not started.\n",
+			(unsigned long long)off, (unsigned long long)len);
+		return -EIO;
+	}
 	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
@@ -2098,7 +2107,7 @@ static ssize_t reiserfs_quota_write(stru
 		data += tocopy;
 		blk++;
 	}
-      out:
+out:
 	if (len == towrite)
 		return err;
 	if (inode->i_size < off + len - towrite)

--8NvZYKFJsRX2Djef--
