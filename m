Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYE1V4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYE1V4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYE1V4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:56:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:54456 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753389AbYE1V4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:56:15 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Silence warnings about non-uptodate buffers
Date: Wed, 28 May 2008 23:56:10 +0200
Message-Id: <12120117732496-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12120117733479-git-send-email-jack@suse.cz>
References: <12120117733479-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When underlying block device becomes unavailable (e.g. someone pulling an
USB stick from under us), kernel produces warning about non-uptodate buffer
(superblock) being marked dirty. Silence these warnings by making buffer
uptodate before marking it dirty.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fe3119a..19d2fb4 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -398,6 +398,7 @@ static void ext3_put_super (struct super_block * sb)
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
 		BUFFER_TRACE(sbi->s_sbh, "marking dirty");
+		set_buffer_uptodate(sbi->s_sbh);
 		mark_buffer_dirty(sbi->s_sbh);
 		ext3_commit_super(sb, es, 1);
 	}
@@ -2248,6 +2249,7 @@ static void ext3_commit_super (struct super_block * sb,
 	es->s_free_blocks_count = cpu_to_le32(ext3_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext3_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
+	set_buffer_uptodate(sbh);
 	mark_buffer_dirty(sbh);
 	if (sync)
 		sync_dirty_buffer(sbh);
-- 
1.5.2.4

