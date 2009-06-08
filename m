Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZFHT3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZFHT3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZFHTXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:42 -0400
Received: from thunk.org ([69.25.196.29]:39587 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZFHTXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 49/49] ext4: fix dx_map_entry to support 256k directory blocks
Date: Mon,  8 Jun 2009 15:23:07 -0400
Message-Id: <1244488987-32564-50-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-49-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
 <1244488987-32564-29-git-send-email-tytso@mit.edu>
 <1244488987-32564-30-git-send-email-tytso@mit.edu>
 <1244488987-32564-31-git-send-email-tytso@mit.edu>
 <1244488987-32564-32-git-send-email-tytso@mit.edu>
 <1244488987-32564-33-git-send-email-tytso@mit.edu>
 <1244488987-32564-34-git-send-email-tytso@mit.edu>
 <1244488987-32564-35-git-send-email-tytso@mit.edu>
 <1244488987-32564-36-git-send-email-tytso@mit.edu>
 <1244488987-32564-37-git-send-email-tytso@mit.edu>
 <1244488987-32564-38-git-send-email-tytso@mit.edu>
 <1244488987-32564-39-git-send-email-tytso@mit.edu>
 <1244488987-32564-40-git-send-email-tytso@mit.edu>
 <1244488987-32564-41-git-send-email-tytso@mit.edu>
 <1244488987-32564-42-git-send-email-tytso@mit.edu>
 <1244488987-32564-43-git-send-email-tytso@mit.edu>
 <1244488987-32564-44-git-send-email-tytso@mit.edu>
 <1244488987-32564-45-git-send-email-tytso@mit.edu>
 <1244488987-32564-46-git-send-email-tytso@mit.edu>
 <1244488987-32564-47-git-send-email-tytso@mit.edu>
 <1244488987-32564-48-git-send-email-tytso@mit.edu>
 <1244488987-32564-49-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

The dx_map_entry structure doesn't support over 64KB block size by
current usage of its member("offs"). Because "offs" treats an offset
of copies of the ext4_dir_entry_2 structure as is. This member size is
16 bits. But real offset for over 64KB(256KB) block size needs 18
bits. However, real offset keeps 4 byte boundary, so lower 2 bits is
not used.

Therefore, we do the following to fix this limitation:
For "store":
	we divide the real offset by 4 and then store this result to "offs"
	member.
For "use":
	we multiply "offs" member by 4 and then use this result
	as real offset.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index f2bc160..07eb664 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -749,7 +749,7 @@ static int dx_make_map(struct ext4_dir_entry_2 *de, unsigned blocksize,
 			ext4fs_dirhash(de->name, de->name_len, &h);
 			map_tail--;
 			map_tail->hash = h.hash;
-			map_tail->offs = (u16) ((char *) de - base);
+			map_tail->offs = ((char *) de - base)>>2;
 			map_tail->size = le16_to_cpu(de->rec_len);
 			count++;
 			cond_resched();
@@ -1147,7 +1147,8 @@ dx_move_dirents(char *from, char *to, struct dx_map_entry *map, int count,
 	unsigned rec_len = 0;
 
 	while (count--) {
-		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) (from + map->offs);
+		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) 
+						(from + (map->offs<<2));
 		rec_len = EXT4_DIR_REC_LEN(de->name_len);
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
-- 
1.6.3.2.1.gb9f7d.dirty

