Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZGBPQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZGBPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZGBPQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:16:14 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:51150 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZGBPQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:16:12 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Artem Bityutskiy <dedekind@infradead.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-mtd@lists.infradead.org
Subject: [PATCH] ubifs: allow more than one volume to be mounted
Date: Thu,  2 Jul 2009 17:15:47 +0200
Message-Id: <1246547747-13366-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UBIFS uses a bdi device per volume, but does not care to hand out unique
names to each of them. This causes an error when trying to mount more
than one volumes.

[  239.277407] kobject_add_internal failed for ubifs with -EEXIST, don't try to register things with the same name in the same directory.
[  239.289618] [<c002a45c>] (unwind_backtrace+0x0/0xdc) from [<c0160628>] (kobject_add_internal+0x188/0x1b8)
[  239.299445] [<c0160628>] (kobject_add_internal+0x188/0x1b8) from [<c01607d8>] (kobject_add+0x48/0x5c)
[  239.308896] [<c01607d8>] (kobject_add+0x48/0x5c) from [<c019d96c>] (device_add+0xac/0x510)
[  239.317392] [<c019d96c>] (device_add+0xac/0x510) from [<c019de58>] (device_create_vargs+0x70/0xa4)
[  239.326589] [<c019de58>] (device_create_vargs+0x70/0xa4) from [<c0073138>] (bdi_register+0x44/0x64)
[  239.335854] [<c0073138>] (bdi_register+0x44/0x64) from [<c01249f0>] (ubifs_get_sb+0x3c8/0x10cc)
[  239.344769] [<c01249f0>] (ubifs_get_sb+0x3c8/0x10cc) from [<c008b054>] (vfs_kern_mount+0x50/0xa8)
[  239.353867] [<c008b054>] (vfs_kern_mount+0x50/0xa8) from [<c008b0f0>] (do_kern_mount+0x34/0xd0)
[  239.362799] [<c008b0f0>] (do_kern_mount+0x34/0xd0) from [<c009f7b4>] (do_mount+0x644/0x6b4)
[  239.371377] [<c009f7b4>] (do_mount+0x644/0x6b4) from [<c009f8a8>] (sys_mount+0x84/0xcc)
[  239.379538] [<c009f8a8>] (sys_mount+0x84/0xcc) from [<c0025e80>] (ret_fast_syscall+0x0/0x2c)

Append the UBI volume and device ID to avoid that.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: linux-mtd@lists.infradead.org
---
 fs/ubifs/super.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 79fad43..fca5ebe 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1910,6 +1910,7 @@ static struct ubi_volume_desc *open_ubi(const char *name, int mode)
 static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct ubi_volume_desc *ubi = sb->s_fs_info;
+	struct ubi_volume_info ubi_info;
 	struct ubifs_info *c;
 	struct inode *root;
 	int err;
@@ -1975,7 +1976,9 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	err  = bdi_init(&c->bdi);
 	if (err)
 		goto out_close;
-	err = bdi_register(&c->bdi, NULL, "ubifs");
+	ubi_get_volume_info(ubi, &ubi_info);
+	err = bdi_register(&c->bdi, NULL, "ubifs_%d_%d",
+					ubi_info.ubi_num, ubi_info.vol_id);
 	if (err)
 		goto out_bdi;
 
-- 
1.6.3.1

