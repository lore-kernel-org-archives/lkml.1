Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbYFZLTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbYFZLTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYFZLTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:19:06 -0400
Received: from styx.suse.cz ([82.119.242.94]:54112 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753652AbYFZLTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:19:05 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Add missing unlock to error path in ext3_quota_write()
Date: Thu, 26 Jun 2008 13:19:02 +0200
Message-Id: <12144791432214-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: n
References: n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When write in ext3_quota_write() fails, we have to properly release
i_mutex. One error path has been missing the unlock...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fe3119a..2845425 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2875,8 +2875,10 @@ static ssize_t ext3_quota_write(struct super_block *sb, int type,
 		blk++;
 	}
 out:
-	if (len == towrite)
+	if (len == towrite) {
+		mutex_unlock(&inode->i_mutex);
 		return err;
+	}
 	if (inode->i_size < off+len-towrite) {
 		i_size_write(inode, off+len-towrite);
 		EXT3_I(inode)->i_disksize = inode->i_size;
-- 
1.5.2.4

