Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbZKRJb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbZKRJb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbZKRJY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:24:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbZKRJYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:24:54 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 02/20] AFFS: Free sbi memory in error path
Date: Wed, 18 Nov 2009 10:24:35 +0100
Message-Id: <1258536293-7762-3-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I spotted the missing kfree() while removing the BKL.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/affs/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 104fdcb..058c2c7 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -316,7 +316,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 				&blocksize,&sbi->s_prefix,
 				sbi->s_volume, &mount_flags)) {
 		printk(KERN_ERR "AFFS: Error parsing options\n");
-		return -EINVAL;
+		goto out_error_free_sbi;
 	}
 	/* N.B. after this point s_prefix must be released */
 
@@ -498,6 +498,7 @@ out_error_noinode:
 	kfree(sbi->s_bitmap);
 	affs_brelse(root_bh);
 	kfree(sbi->s_prefix);
+out_error_free_sbi:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	return ret;
-- 
1.6.4.2

