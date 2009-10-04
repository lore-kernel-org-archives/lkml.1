Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZJDDNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZJDDNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 23:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZJDDNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 23:13:17 -0400
Received: from thunk.org ([69.25.196.29]:45526 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbZJDDNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 23:13:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext3: Don't update superblock write time when filesystem is read-only
Date: Sat,  3 Oct 2009 23:12:38 -0400
Message-Id: <1254625958-3588-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.4.4.2.g31f8e.dirty
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids updating the superblock write time when we are mounting
the root file system read/only but we need to replay the journal; at
that point, for people who are east of GMT and who make their clock
tick in localtime for Windows bug-for-bug compatibility, and this will
cause e2fsck to complain and force a full file system check.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext3/super.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 72743d3..7a520a8 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2321,7 +2321,18 @@ static int ext3_commit_super(struct super_block *sb,
 
 	if (!sbh)
 		return error;
-	es->s_wtime = cpu_to_le32(get_seconds());
+	/*
+	 * If the file system is mounted read-only, don't update the
+	 * superblock write time.  This avoids updating the superblock
+	 * write time when we are mounting the root file system
+	 * read/only but we need to replay the journal; at that point,
+	 * for people who are east of GMT and who make their clock
+	 * tick in localtime for Windows bug-for-bug compatibility,
+	 * the clock is set in the future, and this will cause e2fsck
+	 * to complain and force a full file system check.
+	 */
+	if (!(sb->s_flags & MS_RDONLY))
+		es->s_wtime = cpu_to_le32(get_seconds());
 	es->s_free_blocks_count = cpu_to_le32(ext3_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext3_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
-- 
1.6.4.4.2.g31f8e.dirty

