Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYHAHGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYHAHGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYHAHGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:06:45 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:54103 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYHAHGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:06:44 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2008 03:06:44 EDT
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>
Subject: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Date: Thu, 31 Jul 2008 23:58:38 -0700
Message-Id: <1217573919-7496-2-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1217573919-7496-1-git-send-email-eric@anholt.net>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Packard <keithp@keithp.com>

GEM needs to create shmem files and get pages related to a shmem file, and
using this pair of functions is the easiest way to do that.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 include/linux/mm.h |   11 +++++++++++
 mm/shmem.c         |   17 ++++-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 866a3db..6e54210 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -715,6 +715,17 @@ static inline int shmem_lock(struct file *file, int lock,
 #endif
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);
 
+/* Flag allocation requirements to shmem_getpage and shmem_swp_alloc */
+enum sgp_type {
+	SGP_READ,	/* don't exceed i_size, don't allocate page */
+	SGP_CACHE,	/* don't exceed i_size, may allocate page */
+	SGP_DIRTY,	/* like SGP_CACHE, but set new page dirty */
+	SGP_WRITE,	/* may exceed i_size, may allocate page */
+};
+
+int shmem_getpage(struct inode *inode, unsigned long idx,
+		  struct page **pagep, enum sgp_type sgp, int *type);
+
 int shmem_zero_setup(struct vm_area_struct *);
 
 #ifndef CONFIG_MMU
diff --git a/mm/shmem.c b/mm/shmem.c
index c1e5a3b..7166ff3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -77,14 +77,6 @@
 /* Pretend that each entry is of this size in directory's i_size */
 #define BOGO_DIRENT_SIZE 20
 
-/* Flag allocation requirements to shmem_getpage and shmem_swp_alloc */
-enum sgp_type {
-	SGP_READ,	/* don't exceed i_size, don't allocate page */
-	SGP_CACHE,	/* don't exceed i_size, may allocate page */
-	SGP_DIRTY,	/* like SGP_CACHE, but set new page dirty */
-	SGP_WRITE,	/* may exceed i_size, may allocate page */
-};
-
 #ifdef CONFIG_TMPFS
 static unsigned long shmem_default_max_blocks(void)
 {
@@ -97,9 +89,6 @@ static unsigned long shmem_default_max_inodes(void)
 }
 #endif
 
-static int shmem_getpage(struct inode *inode, unsigned long idx,
-			 struct page **pagep, enum sgp_type sgp, int *type);
-
 static inline struct page *shmem_dir_alloc(gfp_t gfp_mask)
 {
 	/*
@@ -1177,8 +1166,8 @@ static inline struct mempolicy *shmem_get_sbmpol(struct shmem_sb_info *sbinfo)
  * vm. If we swap it in we mark it dirty since we also free the swap
  * entry since a page cannot live in both the swap and page cache
  */
-static int shmem_getpage(struct inode *inode, unsigned long idx,
-			struct page **pagep, enum sgp_type sgp, int *type)
+int shmem_getpage(struct inode *inode, unsigned long idx,
+		  struct page **pagep, enum sgp_type sgp, int *type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -1431,6 +1420,7 @@ failed:
 	}
 	return error;
 }
+EXPORT_SYMBOL(shmem_getpage);
 
 static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
@@ -2582,6 +2572,7 @@ put_memory:
 	shmem_unacct_size(flags, size);
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL(shmem_file_setup);
 
 /**
  * shmem_zero_setup - setup a shared anonymous mapping
-- 
1.5.6.3

