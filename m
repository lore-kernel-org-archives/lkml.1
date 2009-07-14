Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZGNOWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZGNOWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZGNOWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:22:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33555 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbZGNOWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:22:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH/RFC] NOMMU: drop page cache whenever any alloc fails due to low memory
Date: Tue, 14 Jul 2009 10:22:37 -0400
Message-Id: <1247581357-20068-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Since no-mmu systems tend to be memory constrained, we want to drop all
of the page cache whenever memory gets low.  The only other option is to
invoke the oom killer, and clearly that's not ideal.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: David Howells <dhowells@redhat.com>
---
 fs/drop_caches.c   |    2 +-
 include/linux/mm.h |    1 +
 mm/page_alloc.c    |    4 ++++
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index a2edb79..51f097d 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -33,7 +33,7 @@ static void drop_pagecache_sb(struct super_block *sb)
 	iput(toput_inode);
 }
 
-static void drop_pagecache(void)
+void drop_pagecache(void)
 {
 	struct super_block *sb;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ba3a7cb..46084c4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1293,6 +1293,7 @@ int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 			unsigned long lru_pages);
+void drop_pagecache(void);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index caa9268..246d381 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1772,6 +1772,10 @@ restart:
 		goto got_pg;
 
 rebalance:
+#ifndef CONFIG_MMU
+	drop_pagecache();
+#endif
+
 	/* Allocate without watermarks if the context allows */
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
 		page = __alloc_pages_high_priority(gfp_mask, order,
-- 
1.6.3.3

