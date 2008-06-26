Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYFZLYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYFZLYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbYFZLYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:24:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:54246 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755131AbYFZLYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:24:01 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: [PATCH] reiserfs: Add missing unlock to an error path in reiserfs_quota_write()
Date: Thu, 26 Jun 2008 13:24:00 +0200
Message-Id: <1214479440759-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: n
References: n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When write in reiserfs_quota_write() fails, we have to properly release
i_mutex. One error path has been missing the unlock...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index ed424d7..1d40f2b 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2165,8 +2165,10 @@ static ssize_t reiserfs_quota_write(struct super_block *sb, int type,
 		blk++;
 	}
 out:
-	if (len == towrite)
+	if (len == towrite) {
+		mutex_unlock(&inode->i_mutex);
 		return err;
+	}
 	if (inode->i_size < off + len - towrite)
 		i_size_write(inode, off + len - towrite);
 	inode->i_version++;
-- 
1.5.2.4

