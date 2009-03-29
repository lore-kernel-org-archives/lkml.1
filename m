Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZC2Rac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZC2Rac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 13:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZC2RaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 13:30:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:44981 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZC2RaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 13:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=S1/nwsUbijVy3JC/Fgt//rNYOGKZAlrHLXtLtRZGijn3UqUB4P91PCq3Zu0DavgsvU
         iDc+d7gI+sci12WyR/L7VmGA85KnUQsCVhN8EAJkjEgVSOJLdhU6NmcTs60s2WCm4stG
         YgMnforWnv3YFCZ9ADlL36Ja2duWv6pnNZkfA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: reiserfs-devel@vger.kernel.org
Subject: [PATCH] reiserfs: fix blkdev_issue_flush() failure handling
Date: Sun, 29 Mar 2009 19:29:40 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903291929.40523.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkdev_issue_flush() may fail (i.e. due to media error on FLUSH CACHE
command execution) so its users should check for the return value.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 fs/reiserfs/file.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: b/fs/reiserfs/file.c
===================================================================
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -140,14 +140,18 @@ static int reiserfs_sync_file(struct fil
 	struct inode *p_s_inode = p_s_dentry->d_inode;
 	int n_err;
 	int barrier_done;
+	int tmp_ret;
 
 	BUG_ON(!S_ISREG(p_s_inode->i_mode));
 	n_err = sync_mapping_buffers(p_s_inode->i_mapping);
 	reiserfs_write_lock(p_s_inode->i_sb);
 	barrier_done = reiserfs_commit_for_inode(p_s_inode);
 	reiserfs_write_unlock(p_s_inode->i_sb);
-	if (barrier_done != 1 && reiserfs_barrier_flush(p_s_inode->i_sb))
-		blkdev_issue_flush(p_s_inode->i_sb->s_bdev, NULL);
+	if (barrier_done != 1 && reiserfs_barrier_flush(p_s_inode->i_sb)) {
+		tmp_ret = blkdev_issue_flush(p_s_inode->i_sb->s_bdev, NULL);
+		if (n_err == 0 && tmp_ret < 0 && tmp_ret != -EOPNOTSUPP)
+			n_err = tmp_ret;
+	}
 	if (barrier_done < 0)
 		return barrier_done;
 	return (n_err < 0) ? -EIO : 0;
