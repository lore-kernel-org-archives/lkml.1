Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZKRJZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZKRJZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbZKRJZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:25:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:42292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817AbZKRJZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:14 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 13/20] BKL: Remove BKL from HFS+
Date: Wed, 18 Nov 2009 10:24:46 +0100
Message-Id: <1258536293-7762-14-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in put_super and fill_super that are both protected by
the superblocks s_umount rw_semaphore. Therefore it is safe to remove the
BKL entirely.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/hfsplus/super.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 824f57a..8a77d43 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -12,7 +12,6 @@
 #include <linux/pagemap.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/vfs.h>
 #include <linux/nls.h>
 
@@ -210,8 +209,6 @@ static void hfsplus_put_super(struct super_block *sb)
 	if (!sb->s_fs_info)
 		return;
 
-	lock_kernel();
-
 	if (sb->s_dirt)
 		hfsplus_write_super(sb);
 	if (!(sb->s_flags & MS_RDONLY) && HFSPLUS_SB(sb).s_vhdr) {
@@ -232,8 +229,6 @@ static void hfsplus_put_super(struct super_block *sb)
 	unload_nls(HFSPLUS_SB(sb).nls);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
-
-	unlock_kernel();
 }
 
 static int hfsplus_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -312,13 +307,9 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	struct nls_table *nls = NULL;
 	int err = -EINVAL;
 
-	lock_kernel();
-
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
 
 	sb->s_fs_info = sbi;
 	INIT_HLIST_HEAD(&sbi->rsrc_inodes);
@@ -463,13 +454,11 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 out:
 	unload_nls(sbi->nls);
 	sbi->nls = nls;
-	unlock_kernel();
 	return 0;
 
 cleanup:
 	hfsplus_put_super(sb);
 	unload_nls(nls);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2

