Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZFMGCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZFMGCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZFMGCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:02:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54785 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZFMGCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:02:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ramfs: ignore tmpfs options when we emulate it
Date: Sat, 13 Jun 2009 02:02:00 -0400
Message-Id: <1244872920-13511-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
fail when tmpfs options are used.  This is because tmpfs creates a small
wrapper around ramfs which rejects unknown options, and ramfs itself only
supports a tiny subset of what tmpfs supports.  This makes it pretty hard
to use the same userspace systems across different configuration systems.
As such, ramfs should ignore the tmpfs options when tmpfs is merely a
wrapper around ramfs.

This used to work before commit c3b1b1cbf0 as previously, ramfs would
ignore all options.  But now, we get:
ramfs: bad mount option: size=10M
mount: mounting mdev on /dev failed: Invalid argument

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
another option might be to restore the previous behavior where ramfs simply
ignored all unknown mount options ...

 fs/ramfs/inode.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 3a6b193..57a797c 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -203,6 +203,16 @@ static int ramfs_parse_options(char *data, struct ramfs_mount_opts *opts)
 			opts->mode = option & S_IALLUGO;
 			break;
 		default:
+#ifndef CONFIG_SHMEM
+			/* If tmpfs is using us to emulate it, ignore its options */
+			if (!strncmp(p, "gid=", 4) ||
+			    !strncmp(p, "mpol=", 5) ||
+			    !strncmp(p, "nr_blocks=", 10) ||
+			    !strncmp(p, "nr_inodes=", 10) ||
+			    !strncmp(p, "size=", 5) ||
+			    !strncmp(p, "uid=", 4))
+				continue;
+#endif
 			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
 			return -EINVAL;
 		}
-- 
1.6.3.1

