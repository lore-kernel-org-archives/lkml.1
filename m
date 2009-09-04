Return-Path: <linux-kernel-owner+w=401wt.eu-S933047AbZIDHBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbZIDHBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbZIDHA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:00:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721AbZIDG6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:41 -0400
Message-Id: <20090904065538.536556189@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:10 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 29/33] Remove the global inode_hash_lock and replace it with per-hash-bucket locks. fs: inode per-bucket inode hash locks
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-inode_lock-scale-9.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todo: should use bit spinlock in hlist_head pointer to save space.
---
 fs/inode.c |  167 ++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 90 insertions(+), 77 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -76,7 +76,12 @@ static unsigned int i_hash_shift __read_
 
 LIST_HEAD(inode_in_use);
 LIST_HEAD(inode_unused);
-static struct hlist_head *inode_hashtable __read_mostly;
+
+struct inode_hash_bucket {
+	spinlock_t lock;
+	struct hlist_head head;
+};
+static struct inode_hash_bucket *inode_hashtable __read_mostly;
 
 /*
  * A simple spinlock to protect the list manipulations.
@@ -86,7 +91,6 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
-static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_mutex provides exclusion between the kswapd or try_to_free_pages
@@ -582,7 +586,7 @@ static void __wait_on_freeing_inode(stru
  * add any additional branch in the common code.
  */
 static struct inode *find_inode(struct super_block *sb,
-				struct hlist_head *head,
+				struct inode_hash_bucket *b,
 				int (*test)(struct inode *, void *),
 				void *data)
 {
@@ -590,12 +594,12 @@ static struct inode *find_inode(struct s
 	struct inode *inode = NULL;
 
 repeat:
-	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	spin_lock(&b->lock);
+	hlist_for_each_entry(inode, node, &b->head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock(&b->lock);
 			goto repeat;
 		}
 		if (!test(inode, data)) {
@@ -603,13 +607,13 @@ repeat:
 			continue;
 		}
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock(&b->lock);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
-	spin_unlock(&inode_hash_lock);
+	spin_unlock(&b->lock);
 	return node ? inode : NULL;
 }
 
@@ -618,30 +622,31 @@ repeat:
  * iget_locked for details.
  */
 static struct inode *find_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				struct inode_hash_bucket *b,
+				unsigned long ino)
 {
 	struct hlist_node *node;
 	struct inode *inode = NULL;
 
 repeat:
-	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	spin_lock(&b->lock);
+	hlist_for_each_entry(inode, node, &b->head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
 			continue;
 		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock(&b->lock);
 			goto repeat;
 		}
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock(&b->lock);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
-	spin_unlock(&inode_hash_lock);
+	spin_unlock(&b->lock);
 	return node ? inode : NULL;
 }
 
@@ -656,7 +661,7 @@ static unsigned long hash(struct super_b
 }
 
 static inline void
-__inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
+__inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
 	atomic_inc(&inodes_stat.nr_inodes);
@@ -665,10 +670,10 @@ __inode_add_to_lists(struct super_block
 	spin_lock(&wb_inode_list_lock);
 	list_add(&inode->i_list, &inode_in_use);
 	spin_unlock(&wb_inode_list_lock);
-	if (head) {
-		spin_lock(&inode_hash_lock);
-		hlist_add_head(&inode->i_hash, head);
-		spin_unlock(&inode_hash_lock);
+	if (b) {
+		spin_lock(&b->lock);
+		hlist_add_head(&inode->i_hash, &b->head);
+		spin_unlock(&b->lock);
 	}
 }
 
@@ -686,11 +691,11 @@ __inode_add_to_lists(struct super_block
  */
 void inode_add_to_lists(struct super_block *sb, struct inode *inode)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, inode->i_ino);
 
 	spin_lock(&sb_inode_list_lock);
 	spin_lock(&inode->i_lock);
-	__inode_add_to_lists(sb, head, inode);
+	__inode_add_to_lists(sb, b, inode);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
@@ -770,7 +775,7 @@ EXPORT_SYMBOL(unlock_new_inode);
  *	-- rmk@arm.uk.linux.org
  */
 static struct inode *get_new_inode(struct super_block *sb,
-				struct hlist_head *head,
+				struct inode_hash_bucket *b,
 				int (*test)(struct inode *, void *),
 				int (*set)(struct inode *, void *),
 				void *data)
@@ -782,7 +787,7 @@ static struct inode *get_new_inode(struc
 		struct inode *old;
 
 		/* We released the lock, so.. */
-		old = find_inode(sb, head, test, data);
+		old = find_inode(sb, b, test, data);
 		if (!old) {
 			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
@@ -790,7 +795,7 @@ static struct inode *get_new_inode(struc
 				goto set_failed;
 
 			inode->i_state = I_LOCK|I_NEW;
-			__inode_add_to_lists(sb, head, inode);
+			__inode_add_to_lists(sb, b, inode);
 			spin_unlock(&inode->i_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -824,7 +829,7 @@ set_failed:
  * comment at iget_locked for details.
  */
 static struct inode *get_new_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				struct inode_hash_bucket *b, unsigned long ino)
 {
 	struct inode *inode;
 
@@ -833,13 +838,13 @@ static struct inode *get_new_inode_fast(
 		struct inode *old;
 
 		/* We released the lock, so.. */
-		old = find_inode_fast(sb, head, ino);
+		old = find_inode_fast(sb, b, ino);
 		if (!old) {
 			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
 			inode->i_ino = ino;
 			inode->i_state = I_LOCK|I_NEW;
-			__inode_add_to_lists(sb, head, inode);
+			__inode_add_to_lists(sb, b, inode);
 			spin_unlock(&inode->i_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -862,19 +867,20 @@ static struct inode *get_new_inode_fast(
 	return inode;
 }
 
-static int test_inode_iunique(struct super_block * sb, struct hlist_head *head, unsigned long ino)
+static int test_inode_iunique(struct super_block *sb,
+				struct inode_hash_bucket *b, unsigned long ino)
 {
 	struct hlist_node *node;
-	struct inode * inode = NULL;
+	struct inode *inode = NULL;
 
-	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	spin_lock(&b->lock);
+	hlist_for_each_entry(inode, node, &b->head, i_hash) {
 		if (inode->i_ino == ino && inode->i_sb == sb) {
-			spin_unlock(&inode_hash_lock);
+			spin_unlock(&b->lock);
 			return 0;
 		}
 	}
-	spin_unlock(&inode_hash_lock);
+	spin_unlock(&b->lock);
 	return 1;
 }
 
@@ -901,7 +907,7 @@ ino_t iunique(struct super_block *sb, in
 	 */
 	static DEFINE_SPINLOCK(unique_lock);
 	static unsigned int counter;
-	struct hlist_head *head;
+	struct inode_hash_bucket *b;
 	ino_t res;
 
 	spin_lock(&unique_lock);
@@ -909,8 +915,8 @@ ino_t iunique(struct super_block *sb, in
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
-		head = inode_hashtable + hash(sb, res);
-	} while (!test_inode_iunique(sb, head, res));
+		b = inode_hashtable + hash(sb, res);
+	} while (!test_inode_iunique(sb, b, res));
 	spin_unlock(&unique_lock);
 
 	return res;
@@ -957,12 +963,13 @@ EXPORT_SYMBOL(igrab);
  * Note, @test is called with the inode_lock held, so can't sleep.
  */
 static struct inode *ifind(struct super_block *sb,
-		struct hlist_head *head, int (*test)(struct inode *, void *),
+		struct inode_hash_bucket *b,
+		int (*test)(struct inode *, void *),
 		void *data, const int wait)
 {
 	struct inode *inode;
 
-	inode = find_inode(sb, head, test, data);
+	inode = find_inode(sb, b, test, data);
 	if (inode) {
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
@@ -989,11 +996,12 @@ static struct inode *ifind(struct super_
  * Otherwise NULL is returned.
  */
 static struct inode *ifind_fast(struct super_block *sb,
-		struct hlist_head *head, unsigned long ino)
+		struct inode_hash_bucket *b,
+		unsigned long ino)
 {
 	struct inode *inode;
 
-	inode = find_inode_fast(sb, head, ino);
+	inode = find_inode_fast(sb, b, ino);
 	if (inode) {
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
@@ -1027,9 +1035,9 @@ static struct inode *ifind_fast(struct s
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
-	return ifind(sb, head, test, data, 0);
+	return ifind(sb, b, test, data, 0);
 }
 EXPORT_SYMBOL(ilookup5_nowait);
 
@@ -1055,9 +1063,9 @@ EXPORT_SYMBOL(ilookup5_nowait);
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
-	return ifind(sb, head, test, data, 1);
+	return ifind(sb, b, test, data, 1);
 }
 EXPORT_SYMBOL(ilookup5);
 
@@ -1077,9 +1085,9 @@ EXPORT_SYMBOL(ilookup5);
  */
 struct inode *ilookup(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 
-	return ifind_fast(sb, head, ino);
+	return ifind_fast(sb, b, ino);
 }
 EXPORT_SYMBOL(ilookup);
 
@@ -1107,17 +1115,17 @@ struct inode *iget5_locked(struct super_
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 	struct inode *inode;
 
-	inode = ifind(sb, head, test, data, 1);
+	inode = ifind(sb, b, test, data, 1);
 	if (inode)
 		return inode;
 	/*
 	 * get_new_inode() will do the right thing, re-trying the search
 	 * in case it had to block at any point.
 	 */
-	return get_new_inode(sb, head, test, set, data);
+	return get_new_inode(sb, b, test, set, data);
 }
 EXPORT_SYMBOL(iget5_locked);
 
@@ -1138,17 +1146,17 @@ EXPORT_SYMBOL(iget5_locked);
  */
 struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 
-	inode = ifind_fast(sb, head, ino);
+	inode = ifind_fast(sb, b, ino);
 	if (inode)
 		return inode;
 	/*
 	 * get_new_inode_fast() will do the right thing, re-trying the search
 	 * in case it had to block at any point.
 	 */
-	return get_new_inode_fast(sb, head, ino);
+	return get_new_inode_fast(sb, b, ino);
 }
 EXPORT_SYMBOL(iget_locked);
 
@@ -1156,7 +1164,7 @@ int insert_inode_locked(struct inode *in
 {
 	struct super_block *sb = inode->i_sb;
 	ino_t ino = inode->i_ino;
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 
 	inode->i_state |= I_LOCK|I_NEW;
 	while (1) {
@@ -1164,8 +1172,8 @@ int insert_inode_locked(struct inode *in
 		struct inode *old = NULL;
 
 repeat:
-		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		spin_lock(&b->lock);
+		hlist_for_each_entry(old, node, &b->head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
 			if (old->i_sb != sb)
@@ -1173,18 +1181,18 @@ repeat:
 			if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
 				continue;
 			if (!spin_trylock(&old->i_lock)) {
-				spin_unlock(&inode_hash_lock);
+				spin_unlock(&b->lock);
 				goto repeat;
 			}
 			break;
 		}
 		if (likely(!node)) {
 			/* XXX: initialize inode->i_lock to locked? */
-			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode_hash_lock);
+			hlist_add_head(&inode->i_hash, &b->head);
+			spin_unlock(&b->lock);
 			return 0;
 		}
-		spin_unlock(&inode_hash_lock);
+		spin_unlock(&b->lock);
 		__iget(old);
 		spin_unlock(&old->i_lock);
 		wait_on_inode(old);
@@ -1201,7 +1209,7 @@ int insert_inode_locked4(struct inode *i
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct super_block *sb = inode->i_sb;
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
 
 	inode->i_state |= I_LOCK|I_NEW;
 
@@ -1210,8 +1218,8 @@ int insert_inode_locked4(struct inode *i
 		struct inode *old = NULL;
 
 repeat:
-		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		spin_lock(&b->lock);
+		hlist_for_each_entry(old, node, &b->head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
 			if (!test(old, data))
@@ -1219,18 +1227,18 @@ repeat:
 			if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
 				continue;
 			if (!spin_trylock(&old->i_lock)) {
-				spin_unlock(&inode_hash_lock);
+				spin_unlock(&b->lock);
 				goto repeat;
 			}
 			break;
 		}
 		if (likely(!node)) {
 			/* XXX: initialize inode->i_lock to locked? */
-			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode_hash_lock);
+			hlist_add_head(&inode->i_hash, &b->head);
+			spin_unlock(&b->lock);
 			return 0;
 		}
-		spin_unlock(&inode_hash_lock);
+		spin_unlock(&b->lock);
 		__iget(old);
 		spin_unlock(&old->i_lock);
 		wait_on_inode(old);
@@ -1253,12 +1261,12 @@ EXPORT_SYMBOL(insert_inode_locked4);
  */
 void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
-	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
+	struct inode_hash_bucket *b = inode_hashtable + hash(inode->i_sb, hashval);
 
 	spin_lock(&inode->i_lock);
-	spin_lock(&inode_hash_lock);
-	hlist_add_head(&inode->i_hash, head);
-	spin_unlock(&inode_hash_lock);
+	spin_lock(&b->lock);
+	hlist_add_head(&inode->i_hash, &b->head);
+	spin_unlock(&b->lock);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -1272,9 +1280,10 @@ EXPORT_SYMBOL(__insert_inode_hash);
  */
 void __remove_inode_hash(struct inode *inode)
 {
-	spin_lock(&inode_hash_lock);
+	struct inode_hash_bucket *b = inode_hashtable + hash(inode->i_sb, inode->i_ino);
+	spin_lock(&b->lock);
 	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_hash_lock);
+	spin_unlock(&b->lock);
 }
 
 /**
@@ -1663,7 +1672,7 @@ void __init inode_init_early(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct inode_hash_bucket),
 					ihash_entries,
 					14,
 					HASH_EARLY,
@@ -1671,8 +1680,10 @@ void __init inode_init_early(void)
 					&i_hash_mask,
 					0);
 
-	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+	for (loop = 0; loop < (1 << i_hash_shift); loop++) {
+		spin_lock_init(&inode_hashtable[loop].lock);
+		INIT_HLIST_HEAD(&inode_hashtable[loop].head);
+	}
 }
 
 void __init inode_init(void)
@@ -1702,8 +1713,10 @@ void __init inode_init(void)
 					&i_hash_mask,
 					0);
 
-	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
+	for (loop = 0; loop < (1 << i_hash_shift); loop++) {
+		spin_lock_init(&inode_hashtable[loop].lock);
+		INIT_HLIST_HEAD(&inode_hashtable[loop].head);
+	}
 }
 
 void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)


