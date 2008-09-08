Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbYIHHej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbYIHHej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 03:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYIHHea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 03:34:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54454 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYIHHe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 03:34:29 -0400
Message-ID: <48C4D54E.60909@cn.fujitsu.com>
Date: Mon, 08 Sep 2008 15:33:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4: miss an unlock in ext4_check_descriptors()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 # mkfs.ext3 -m 0 /dev/sda6
 # tune2fs -E test_fs -O extents,uninit_bg
 (no e2fsck after tune2fs)
 # mount -t ext4dev /dev/sda6

oops immediately:

EXT4-fs: ext4_check_descriptors: Checksum for group 0 failed (20091!=0)
EXT4-fs: group descriptors corrupted!

=========================
[ BUG: held lock freed! ]
-------------------------
mount/9422 is freeing memory c6ca0000-c6ca7fff, with a lock still held there!
 (&bgl->locks[i].lock#2){--..}, at: [<f8996589>] ext4_fill_super+0xde8/0x1dcf [ext4dev]
2 locks held by mount/9422:
 #0:  (&type->s_umount_key#19){----}, at: [<c0488258>] sget+0x1dd/0x31c
 #1:  (&bgl->locks[i].lock#2){--..}, at: [<f8996589>] ext4_fill_super+0xde8/0x1dcf [ext4dev]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/ext4/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 566344b..24e7df6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1623,8 +1623,10 @@ static int ext4_check_descriptors(struct super_block *sb)
 			       "Checksum for group %lu failed (%u!=%u)\n",
 			       i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
 			       gdp)), le16_to_cpu(gdp->bg_checksum));
-			if (!(sb->s_flags & MS_RDONLY))
+			if (!(sb->s_flags & MS_RDONLY)) {
+				spin_unlock(sb_bgl_lock(sbi, i));
 				return 0;
+			}
 		}
 		spin_unlock(sb_bgl_lock(sbi, i));
 		if (!flexbg_flag)
-- 1.5.4.rc3 
