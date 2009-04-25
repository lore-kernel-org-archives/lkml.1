Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbZDYBcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbZDYBcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZDYB3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:29:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:44576 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbZDYB2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:50 -0400
Message-Id: <20090425012210.161936428@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:28 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 08/27] fs: dcache scale lru
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=fs-dcache-scale-d_lru.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, dcache_lru_lock, to protect the dcache hash table from
concurrent modification. d_lru is also protected by d_lock.

Move lru scanning out from underneath dcache_lock.

---
 fs/dcache.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 85 insertions(+), 20 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -36,17 +36,26 @@
 
 /*
  * Usage:
- * dcache_hash_lock protects dcache hash table
+ * dcache_hash_lock protects:
+ *   - the dcache hash table
+ * dcache_lru_lock protects:
+ *   - the dcache lru lists and counters
+ * d_lock protects:
+ *   - d_flags
+ *   - d_name
+ *   - d_lru
  *
  * Ordering:
  * dcache_lock
  *   dentry->d_lock
+ *     dcache_lru_lock
  *     dcache_hash_lock
  */
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_hash_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
@@ -133,37 +142,56 @@ static void dentry_iput(struct dentry *
 }
 
 /*
- * dentry_lru_(add|add_tail|del|del_init) must be called with dcache_lock held.
+ * dentry_lru_(add|add_tail|del|del_init) must be called with d_lock held
+ * to protect list_empty(d_lru) condition.
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
+	spin_lock(&dcache_lru_lock);
 	list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 	dentry->d_sb->s_nr_dentry_unused++;
 	dentry_stat.nr_unused++;
+	spin_unlock(&dcache_lru_lock);
 }
 
 static void dentry_lru_add_tail(struct dentry *dentry)
 {
+	spin_lock(&dcache_lru_lock);
 	list_add_tail(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 	dentry->d_sb->s_nr_dentry_unused++;
 	dentry_stat.nr_unused++;
+	spin_unlock(&dcache_lru_lock);
+}
+
+static void __dentry_lru_del(struct dentry *dentry)
+{
+	list_del(&dentry->d_lru);
+	dentry->d_sb->s_nr_dentry_unused--;
+	dentry_stat.nr_unused--;
+}
+
+static void __dentry_lru_del_init(struct dentry *dentry)
+{
+	list_del_init(&dentry->d_lru);
+	dentry->d_sb->s_nr_dentry_unused--;
+	dentry_stat.nr_unused--;
 }
 
 static void dentry_lru_del(struct dentry *dentry)
 {
 	if (!list_empty(&dentry->d_lru)) {
-		list_del(&dentry->d_lru);
-		dentry->d_sb->s_nr_dentry_unused--;
-		dentry_stat.nr_unused--;
+		spin_lock(&dcache_lru_lock);
+		__dentry_lru_del(dentry);
+		spin_unlock(&dcache_lru_lock);
 	}
 }
 
 static void dentry_lru_del_init(struct dentry *dentry)
 {
 	if (likely(!list_empty(&dentry->d_lru))) {
-		list_del_init(&dentry->d_lru);
-		dentry->d_sb->s_nr_dentry_unused--;
-		dentry_stat.nr_unused--;
+		spin_lock(&dcache_lru_lock);
+		__dentry_lru_del_init(dentry);
+		spin_unlock(&dcache_lru_lock);
 	}
 }
 
@@ -174,6 +202,8 @@ static void dentry_lru_del_init(struct d
  * The dentry must already be unhashed and removed from the LRU.
  *
  * If this is the root of the dentry tree, return NULL.
+ *
+ * dcache_lock and d_lock must be held by caller, are dropped by d_kill.
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
@@ -326,11 +356,19 @@ int d_invalidate(struct dentry * dentry)
 }
 
 /* This should be called _only_ with dcache_lock held */
+static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
+{
+	atomic_inc(&dentry->d_count);
+	dentry_lru_del_init(dentry);
+	return dentry;
+}
 
 static inline struct dentry * __dget_locked(struct dentry *dentry)
 {
 	atomic_inc(&dentry->d_count);
+	spin_lock(&dentry->d_lock);
 	dentry_lru_del_init(dentry);
+	spin_lock(&dentry->d_lock);
 	return dentry;
 }
 
@@ -407,7 +445,7 @@ restart:
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!atomic_read(&dentry->d_count)) {
-			__dget_locked(dentry);
+			__dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
@@ -439,17 +477,18 @@ static void prune_one_dentry(struct dent
 	 * Prune ancestors.  Locking is simpler than in dput(),
 	 * because dcache_lock needs to be taken anyway.
 	 */
-	spin_lock(&dcache_lock);
 	while (dentry) {
-		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock))
+		spin_lock(&dcache_lock);
+		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock)) {
+			spin_unlock(&dcache_lock);
 			return;
+		}
 
 		if (dentry->d_op && dentry->d_op->d_delete)
 			dentry->d_op->d_delete(dentry);
 		dentry_lru_del_init(dentry);
 		__d_drop(dentry);
 		dentry = d_kill(dentry);
-		spin_lock(&dcache_lock);
 	}
 }
 
@@ -470,10 +509,11 @@ static void __shrink_dcache_sb(struct su
 
 	BUG_ON(!sb);
 	BUG_ON((flags & DCACHE_REFERENCED) && count == NULL);
-	spin_lock(&dcache_lock);
 	if (count != NULL)
 		/* called from prune_dcache() and shrink_dcache_parent() */
 		cnt = *count;
+relock:
+	spin_lock(&dcache_lru_lock);
 restart:
 	if (count == NULL)
 		list_splice_init(&sb->s_dentry_lru, &tmp);
@@ -483,7 +523,10 @@ restart:
 					struct dentry, d_lru);
 			BUG_ON(dentry->d_sb != sb);
 
-			spin_lock(&dentry->d_lock);
+			if (!spin_trylock(&dentry->d_lock)) {
+				spin_unlock(&dcache_lru_lock);
+				goto relock;
+			}
 			/*
 			 * If we are honouring the DCACHE_REFERENCED flag and
 			 * the dentry has this flag set, don't free it. Clear
@@ -501,13 +544,22 @@ restart:
 				if (!cnt)
 					break;
 			}
-			cond_resched_lock(&dcache_lock);
+			cond_resched_lock(&dcache_lru_lock);
 		}
 	}
+	spin_unlock(&dcache_lru_lock);
+
+	spin_lock(&dcache_lock);
+again:
+	spin_lock(&dcache_lru_lock); /* lru_lock also protects tmp list */
 	while (!list_empty(&tmp)) {
 		dentry = list_entry(tmp.prev, struct dentry, d_lru);
-		dentry_lru_del_init(dentry);
-		spin_lock(&dentry->d_lock);
+
+		if (!spin_trylock(&dentry->d_lock)) {
+			spin_unlock(&dcache_lru_lock);
+			goto again;
+		}
+		__dentry_lru_del_init(dentry);
 		/*
 		 * We found an inuse dentry which was not removed from
 		 * the LRU because of laziness during lookup.  Do not free
@@ -517,17 +569,22 @@ restart:
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
+
+		spin_unlock(&dcache_lru_lock);
 		prune_one_dentry(dentry);
-		/* dentry->d_lock was dropped in prune_one_dentry() */
-		cond_resched_lock(&dcache_lock);
+		/* dcache_lock and dentry->d_lock dropped */
+		spin_lock(&dcache_lock);
+		spin_lock(&dcache_lru_lock);
 	}
+	spin_unlock(&dcache_lock);
+
 	if (count == NULL && !list_empty(&sb->s_dentry_lru))
 		goto restart;
 	if (count != NULL)
 		*count = cnt;
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
-	spin_unlock(&dcache_lock);
+	spin_unlock(&dcache_lru_lock);
 }
 
 /**
@@ -635,7 +692,9 @@ static void shrink_dcache_for_umount_sub
 
 	/* detach this root from the system */
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	dentry_lru_del_init(dentry);
+	spin_unlock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dcache_lock);
 
@@ -649,7 +708,9 @@ static void shrink_dcache_for_umount_sub
 			spin_lock(&dcache_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
+				spin_lock(&loop->d_lock);
 				dentry_lru_del_init(loop);
+				spin_unlock(&loop->d_lock);
 				__d_drop(loop);
 				cond_resched_lock(&dcache_lock);
 			}
@@ -832,13 +893,17 @@ resume:
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
+		spin_lock(&dentry->d_lock);
 		dentry_lru_del_init(dentry);
+		spin_unlock(&dentry->d_lock);
 		/* 
 		 * move only zero ref count dentries to the end 
 		 * of the unused list for prune_dcache
 		 */
 		if (!atomic_read(&dentry->d_count)) {
+			spin_lock(&dentry->d_lock);
 			dentry_lru_add_tail(dentry);
+			spin_unlock(&dentry->d_lock);
 			found++;
 		}
 


