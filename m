Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbZKRJbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbZKRJbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZKRJ3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:29:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776AbZKRJZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:09 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Andreas Dilger <adilger@sun.com>
Subject: [PATCH 09/20] BKL: Remove BKL from ext3_put_super() and ext3_remount()
Date: Wed, 18 Nov 2009 10:24:42 +0100
Message-Id: <1258536293-7762-10-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL lock is protecting the remounting against a potential call to
ext3_put_super(). This could not happen, since this is protected by the
s_umount rw semaphore of struct super_block.

Therefore I think the BKL is protecting nothing here.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 373fc54..d02fbc6 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -398,8 +398,6 @@ static void ext3_put_super (struct super_block * sb)
 	struct ext3_super_block *es = sbi->s_es;
 	int i, err;
 
-	lock_kernel();
-
 	ext3_xattr_put_super(sb);
 	err = journal_destroy(sbi->s_journal);
 	sbi->s_journal = NULL;
@@ -448,8 +446,6 @@ static void ext3_put_super (struct super_block * sb)
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
-
-	unlock_kernel();
 }
 
 static struct kmem_cache *ext3_inode_cachep;
@@ -2497,8 +2493,6 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 	int i;
 #endif
 
-	lock_kernel();
-
 	/* Store the original options */
 	lock_super(sb);
 	old_sb_flags = sb->s_flags;
@@ -2609,7 +2603,6 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			kfree(old_opts.s_qf_names[i]);
 #endif
 	unlock_super(sb);
-	unlock_kernel();
 	return 0;
 restore_opts:
 	sb->s_flags = old_sb_flags;
@@ -2627,7 +2620,6 @@ restore_opts:
 	}
 #endif
 	unlock_super(sb);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2

