Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbYLSFzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbYLSFzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYLSFzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:55:35 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:33787 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYLSFze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:55:34 -0500
From: Yuri Tikhonov <yur@emcraft.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mm/shmem.c: fix division by zero
Date: Fri, 19 Dec 2008 08:44:57 +0300
User-Agent: KMail/1.9.4
Cc: linuxppc-dev@ozlabs.org, hugh@veritas.com, akpm@linux-foundation.org,
       paulus@samba.org, wd@denx.de, dzu@denx.de, yanok@emcraft.com,
       miltonm@bga.com, viro@zeniv.linux.org.uk,
       Geert.Uytterhoeven@sonycom.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812190844.57996.yur@emcraft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch fixes division by zero, which we have in
shmem_truncate_range() and shmem_unuse_inode(), if use big
PAGE_SIZE values (e.g. 256KB on ppc44x).

With 256KB PAGE_SIZE the ENTRIES_PER_PAGEPAGE constant becomes
too large (0x1.0000.0000), so this patch just changes the types
from 'ulong' to 'ullong' where it's necessary.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
---
 mm/shmem.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0ed0752..99d7c91 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -57,7 +57,7 @@
 #include <asm/pgtable.h>
 
 #define ENTRIES_PER_PAGE (PAGE_CACHE_SIZE/sizeof(unsigned long))
-#define ENTRIES_PER_PAGEPAGE (ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
+#define ENTRIES_PER_PAGEPAGE ((unsigned long long)ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
 #define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
 
 #define SHMEM_MAX_INDEX  (SHMEM_NR_DIRECT + (ENTRIES_PER_PAGEPAGE/2) * (ENTRIES_PER_PAGE+1))
@@ -95,7 +95,7 @@ static unsigned long shmem_default_max_inodes(void)
 }
 #endif
 
-static int shmem_getpage(struct inode *inode, unsigned long idx,
+static int shmem_getpage(struct inode *inode, unsigned long long idx,
 			 struct page **pagep, enum sgp_type sgp, int *type);
 
 static inline struct page *shmem_dir_alloc(gfp_t gfp_mask)
@@ -533,7 +533,7 @@ static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
 	int punch_hole;
 	spinlock_t *needs_lock;
 	spinlock_t *punch_lock;
-	unsigned long upper_limit;
+	unsigned long long upper_limit;
 
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 	idx = (start + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
@@ -1175,7 +1175,7 @@ static inline struct mempolicy *shmem_get_sbmpol(struct shmem_sb_info *sbinfo)
  * vm. If we swap it in we mark it dirty since we also free the swap
  * entry since a page cannot live in both the swap and page cache
  */
-static int shmem_getpage(struct inode *inode, unsigned long idx,
+static int shmem_getpage(struct inode *inode, unsigned long long idx,
 			struct page **pagep, enum sgp_type sgp, int *type)
 {
 	struct address_space *mapping = inode->i_mapping;
-- 
1.6.0.4
