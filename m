Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbYEWWHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbYEWWHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760009AbYEWWGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:06:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759332AbYEWWGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:06:34 -0400
Message-Id: <20080523195535.917456536@redhat.com>
References: <20080523195506.084894989@redhat.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 May 2008 15:55:22 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH -mm 16/16] SHM_LOCKED pages are nonreclaimable
Content-Disposition: inline; filename=rvr-14-lts-noreclaim-SHM_LOCKED-pages-are-nonreclaimable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

While working with Nick Piggin's mlock patches, I noticed that
shmem segments locked via shmctl(SHM_LOCKED) were not being handled.
SHM_LOCKed pages work like ramdisk pages--the writeback function
just redirties the page so that it can't be reclaimed.  Deal with
these using the same approach as for ram disk pages.

Use the AS_NORECLAIM flag to mark address_space of SHM_LOCKed
shared memory regions as non-reclaimable.  Then these pages
will be culled off the normal LRU lists during vmscan.

Add new wrapper function to clear the mapping's noreclaim state
when/if shared memory segment is munlocked.

Add 'scan_mapping_noreclaim_page()' to mm/vmscan.c to scan all
pages in the shmem segment's mapping [struct address_space] for
reclaimability now that they're no longer locked.  If so, move
them to the appropriate zone lru list.

Changes depend on [CONFIG_]NORECLAIM_LRU.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by:  Rik van Riel <riel@redhat.com>

---
V2 -> V3:
+ rebase to 23-mm1 atop RvR's split LRU series.
+ Use scan_mapping_noreclaim_page() on unlock.  See below.

V1 -> V2:
+  modify to use reworked 'scan_all_zones_noreclaim_pages()'
   See 'TODO' below - still pending.

 include/linux/mm.h      |    7 ++-
 include/linux/pagemap.h |   10 ++++-
 include/linux/swap.h    |    4 ++
 ipc/shm.c               |   11 ++++-
 mm/shmem.c              |   10 +++--
 mm/vmscan.c             |   92 ++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 124 insertions(+), 10 deletions(-)

Index: linux-2.6.26-rc2-mm1/mm/shmem.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/shmem.c	2008-05-23 15:14:03.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/shmem.c	2008-05-23 15:19:28.000000000 -0400
@@ -1458,23 +1458,27 @@ static struct mempolicy *shmem_get_polic
 }
 #endif
 
-int shmem_lock(struct file *file, int lock, struct user_struct *user)
+struct address_space *shmem_lock(struct file *file, int lock,
+				 struct user_struct *user)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	int retval = -ENOMEM;
+	struct address_space *retval = ERR_PTR(-ENOMEM);
 
 	spin_lock(&info->lock);
 	if (lock && !(info->flags & VM_LOCKED)) {
 		if (!user_shm_lock(inode->i_size, user))
 			goto out_nomem;
 		info->flags |= VM_LOCKED;
+		mapping_set_noreclaim(file->f_mapping);
+		retval = NULL;
 	}
 	if (!lock && (info->flags & VM_LOCKED) && user) {
 		user_shm_unlock(inode->i_size, user);
 		info->flags &= ~VM_LOCKED;
+		mapping_clear_noreclaim(file->f_mapping);
+		retval = file->f_mapping;
 	}
-	retval = 0;
 out_nomem:
 	spin_unlock(&info->lock);
 	return retval;
Index: linux-2.6.26-rc2-mm1/include/linux/pagemap.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/pagemap.h	2008-05-23 15:19:21.000000000 -0400
+++ linux-2.6.26-rc2-mm1/include/linux/pagemap.h	2008-05-23 15:19:28.000000000 -0400
@@ -38,14 +38,20 @@ static inline void mapping_set_noreclaim
 	set_bit(AS_NORECLAIM, &mapping->flags);
 }
 
+static inline void mapping_clear_noreclaim(struct address_space *mapping)
+{
+	clear_bit(AS_NORECLAIM, &mapping->flags);
+}
+
 static inline int mapping_non_reclaimable(struct address_space *mapping)
 {
-	if (mapping && (mapping->flags & AS_NORECLAIM))
-		return 1;
+	if (mapping)
+		return test_bit(AS_NORECLAIM, &mapping->flags);
 	return 0;
 }
 #else
 static inline void mapping_set_noreclaim(struct address_space *mapping) { }
+static inline void mapping_clear_noreclaim(struct address_space *mapping) { }
 static inline int mapping_non_reclaimable(struct address_space *mapping)
 {
 	return 0;
Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/vmscan.c	2008-05-23 15:19:21.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/vmscan.c	2008-05-23 15:19:28.000000000 -0400
@@ -2317,4 +2317,96 @@ int page_reclaimable(struct page *page, 
 
 	return 1;
 }
+
+/**
+ * check_move_noreclaim_page - check page for reclaimability and move to appropriate zone lru list
+ * @page: page to check reclaimability and move to appropriate lru list
+ * @zone: zone page is in
+ *
+ * Checks a page for reclaimability and moves the page to the appropriate
+ * zone lru list.
+ *
+ * Restrictions: zone->lru_lock must be held, page must be on LRU and must
+ * have PageNoreclaim set.
+ */
+static void check_move_noreclaim_page(struct page *page, struct zone *zone)
+{
+
+	ClearPageNoreclaim(page); /* for page_reclaimable() */
+	if (page_reclaimable(page, NULL)) {
+		enum lru_list l = LRU_INACTIVE_ANON + page_file_cache(page);
+		__dec_zone_state(zone, NR_NORECLAIM);
+		list_move(&page->lru, &zone->list[l]);
+		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
+	} else {
+		/*
+		 * rotate noreclaim list
+		 */
+		SetPageNoreclaim(page);
+		list_move(&page->lru, &zone->list[LRU_NORECLAIM]);
+	}
+}
+
+/**
+ * scan_mapping_noreclaim_pages - scan an address space for reclaimable pages
+ * @mapping: struct address_space to scan for reclaimable pages
+ *
+ * Scan all pages in mapping.  Check non-reclaimable pages for
+ * reclaimability and move them to the appropriate zone lru list.
+ */
+void scan_mapping_noreclaim_pages(struct address_space *mapping)
+{
+	pgoff_t next = 0;
+	pgoff_t end   = i_size_read(mapping->host);
+	struct zone *zone;
+	struct pagevec pvec;
+
+	if (mapping->nrpages == 0)
+		return;
+
+	pagevec_init(&pvec, 0);
+	while (next < end &&
+		pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
+		int i;
+
+		zone = NULL;
+
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+			pgoff_t page_index = page->index;
+			struct zone *pagezone = page_zone(page);
+
+			if (page_index > next)
+				next = page_index;
+			next++;
+
+			if (TestSetPageLocked(page)) {
+				/*
+				 * OK, let's do it the hard way...
+				 */
+				if (zone)
+					spin_unlock_irq(&zone->lru_lock);
+				zone = NULL;
+				lock_page(page);
+			}
+
+			if (pagezone != zone) {
+				if (zone)
+					spin_unlock_irq(&zone->lru_lock);
+				zone = pagezone;
+				spin_lock_irq(&zone->lru_lock);
+			}
+
+			if (PageLRU(page) && PageNoreclaim(page))
+				check_move_noreclaim_page(page, zone);
+
+			unlock_page(page);
+
+		}
+		if (zone)
+			spin_unlock_irq(&zone->lru_lock);
+		pagevec_release(&pvec);
+	}
+
+}
 #endif
Index: linux-2.6.26-rc2-mm1/include/linux/swap.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/swap.h	2008-05-23 15:14:03.000000000 -0400
+++ linux-2.6.26-rc2-mm1/include/linux/swap.h	2008-05-23 15:19:28.000000000 -0400
@@ -232,12 +232,16 @@ static inline int zone_reclaim(struct zo
 
 #ifdef CONFIG_NORECLAIM_LRU
 extern int page_reclaimable(struct page *page, struct vm_area_struct *vma);
+extern void scan_mapping_noreclaim_pages(struct address_space *);
 #else
 static inline int page_reclaimable(struct page *page,
 						struct vm_area_struct *vma)
 {
 	return 1;
 }
+static inline void scan_mapping_noreclaim_pages(struct address_space *mapping)
+{
+}
 #endif
 
 extern int kswapd_run(int nid);
Index: linux-2.6.26-rc2-mm1/include/linux/mm.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/mm.h	2008-05-23 15:14:03.000000000 -0400
+++ linux-2.6.26-rc2-mm1/include/linux/mm.h	2008-05-23 15:19:28.000000000 -0400
@@ -694,10 +694,11 @@ static inline int page_mapped(struct pag
 extern void show_free_areas(void);
 
 #ifdef CONFIG_SHMEM
-int shmem_lock(struct file *file, int lock, struct user_struct *user);
+extern struct address_space *shmem_lock(struct file *file, int lock,
+					struct user_struct *user);
 #else
-static inline int shmem_lock(struct file *file, int lock,
-			     struct user_struct *user)
+static inline struct address_space *shmem_lock(struct file *file, int lock,
+					struct user_struct *user)
 {
 	return 0;
 }
Index: linux-2.6.26-rc2-mm1/ipc/shm.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/ipc/shm.c	2008-05-23 15:14:03.000000000 -0400
+++ linux-2.6.26-rc2-mm1/ipc/shm.c	2008-05-23 15:19:28.000000000 -0400
@@ -736,6 +736,8 @@ asmlinkage long sys_shmctl(int shmid, in
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
+		struct address_space *mapping = NULL;
+
 		shp = shm_lock_check(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
@@ -763,18 +765,23 @@ asmlinkage long sys_shmctl(int shmid, in
 		if(cmd==SHM_LOCK) {
 			struct user_struct * user = current->user;
 			if (!is_file_hugepages(shp->shm_file)) {
-				err = shmem_lock(shp->shm_file, 1, user);
+				mapping = shmem_lock(shp->shm_file, 1, user);
+				if (IS_ERR(mapping))
+					err = PTR_ERR(mapping);
+				mapping = NULL;
 				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
 					shp->shm_perm.mode |= SHM_LOCKED;
 					shp->mlock_user = user;
 				}
 			}
 		} else if (!is_file_hugepages(shp->shm_file)) {
-			shmem_lock(shp->shm_file, 0, shp->mlock_user);
+			mapping = shmem_lock(shp->shm_file, 0, shp->mlock_user);
 			shp->shm_perm.mode &= ~SHM_LOCKED;
 			shp->mlock_user = NULL;
 		}
 		shm_unlock(shp);
+		if (mapping)
+			scan_mapping_noreclaim_pages(mapping);
 		goto out;
 	}
 	case IPC_RMID:

-- 
All Rights Reversed

