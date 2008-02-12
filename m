Return-Path: <linux-kernel-owner+w=401wt.eu-S1764238AbYBLXN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764238AbYBLXN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759969AbYBLXLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:11:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:8053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762688AbYBLXLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:11:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=GdqXxyvFL3E4jUhY4Syrx+lwQOxBWTdAq3V4HxhQvVJtnPLx5Ao6NEfKz8zzyhvsI7xQsdE0HrUuIo37TZT+Ve00EWeI9fqjoX79qk14fsU4yCBErP1tJ0Qkrk3+PW1YKys4l8pVcQ3RzNgST4UNvJCXncDeMnOj1KeVs+AtUFw=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, reiserfs-dev@namesys.com,
       reiserfs-devel@vger.kernel.org
Subject: [PATCH] reiserfs: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:20 +0100
Message-Id: <1202857582-15450-16-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: reiserfs-dev@namesys.com
Cc: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/objectid.c |    5 ++---
 fs/reiserfs/stree.c    |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/objectid.c b/fs/reiserfs/objectid.c
index 65feba4..f0c1543 100644
--- a/fs/reiserfs/objectid.c
+++ b/fs/reiserfs/objectid.c
@@ -114,7 +114,7 @@ void reiserfs_release_objectid(struct reiserfs_transaction_handle *th,
 		if (objectid_to_release == le32_to_cpu(map[i])) {
 			/* This incrementation unallocates the objectid. */
 			//map[i]++;
-			map[i] = cpu_to_le32(le32_to_cpu(map[i]) + 1);
+			le32_add_cpu(&map[i], 1);
 
 			/* Did we unallocate the last member of an odd sequence, and can shrink oids? */
 			if (map[i] == map[i + 1]) {
@@ -138,8 +138,7 @@ void reiserfs_release_objectid(struct reiserfs_transaction_handle *th,
 			/* size of objectid map is not changed */
 			if (objectid_to_release + 1 == le32_to_cpu(map[i + 1])) {
 				//objectid_map[i+1]--;
-				map[i + 1] =
-				    cpu_to_le32(le32_to_cpu(map[i + 1]) - 1);
+				le32_add_cpu(&map[i + 1], -1);
 				return;
 			}
 
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index d2db241..abbc64d 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1419,8 +1419,7 @@ int reiserfs_delete_object(struct reiserfs_transaction_handle *th,
 
 		inode_generation =
 		    &REISERFS_SB(th->t_super)->s_rs->s_inode_generation;
-		*inode_generation =
-		    cpu_to_le32(le32_to_cpu(*inode_generation) + 1);
+		le32_add_cpu(inode_generation, 1);
 	}
 /* USE_INODE_GENERATION_COUNTER */
 #endif
-- 
1.5.3.7

