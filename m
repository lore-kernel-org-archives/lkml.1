Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbZKRJay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbZKRJay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbZKRJ3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:29:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:42246 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbZKRJZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:05 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Subject: [PATCH 06/20] BKL: Remove BKL from BFS
Date: Wed, 18 Nov 2009 10:24:39 +0100
Message-Id: <1258536293-7762-7-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in put_super and fill_super that are both protected by
the superblocks s_umount rw_semaphore. Therefore it is safe to remove the BKL
entirely.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/bfs/inode.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 4bff506..8ed127a 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <asm/uaccess.h>
@@ -243,8 +242,6 @@ static void bfs_put_super(struct super_block *s)
 	if (!info)
 		return;
 
-	lock_kernel();
-
 	if (s->s_dirt)
 		bfs_write_super(s);
 
@@ -253,8 +250,6 @@ static void bfs_put_super(struct super_block *s)
 	kfree(info->si_imap);
 	kfree(info);
 	s->s_fs_info = NULL;
-
-	unlock_kernel();
 }
 
 static int bfs_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -356,13 +351,10 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	long ret = -EINVAL;
 	unsigned long i_sblock, i_eblock, i_eoff, s_size;
 
-	lock_kernel();
-
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		unlock_kernel();
+	if (!info)
 		return -ENOMEM;
-	}
+
 	s->s_fs_info = info;
 
 	sb_set_blocksize(s, BFS_BSIZE);
@@ -467,7 +459,6 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 			kfree(info->si_imap);
 			kfree(info);
 			s->s_fs_info = NULL;
-			unlock_kernel();
 			return -EIO;
 		}
 
@@ -486,17 +477,15 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	if (!(s->s_flags & MS_RDONLY)) {
 		mark_buffer_dirty(info->si_sbh);
 		s->s_dirt = 1;
-	} 
+	}
 	dump_imap("read_super", s);
 	mutex_init(&info->bfs_lock);
-	unlock_kernel();
 	return 0;
 
 out:
 	brelse(bh);
 	kfree(info);
 	s->s_fs_info = NULL;
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.4.2

