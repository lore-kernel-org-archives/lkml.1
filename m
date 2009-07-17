Return-Path: <linux-kernel-owner+w=401wt.eu-S934118AbZGQGV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbZGQGV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 02:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933998AbZGQGV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 02:21:28 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40069 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934114AbZGQGVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 02:21:25 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Adrian Hunter <adrian.hunter@nokia.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>, linux-mtd@lists.infradead.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Fri, 17 Jul 2009 11:51:04 +0530
Message-Id: <20090717062101.11440.49299.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH] Clean up some extra unused arguments in fs/ubifs/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"const struct ubifs_info *c" exists as an extra argument for major
function definitions under the "fs/ubifs/*" code. The reason why
this extra argument exists is based on assumtion that there
will be several key schemes. It is possible to add more than one,
but we use only one. When there is practically no usage of them
presently, they can be removed, and if needed can be added later.

The following patch does that by removing:
1) "const struct ubifs_info *c" where it is not used/necessary,
2) remove xent_key_init_hash() function, as it is also not used,
3) remove data_key_init_flash() function, as it is also not used anywhere,

Recent discussion on this can be found at:
http://lkml.org/lkml/2009/7/16/164,
http://lkml.org/lkml/2009/7/16/166,

Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
---

diff -uprN a/fs/ubifs/commit.c b/fs/ubifs/commit.c
--- a/fs/ubifs/commit.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/commit.c	2009-07-17 11:35:04.000000000 +0530
@@ -572,10 +572,10 @@ int dbg_check_old_index(struct ubifs_inf
 			/* Set last values as though root had a parent */
 			last_level = le16_to_cpu(idx->level) + 1;
 			last_sqnum = le64_to_cpu(idx->ch.sqnum) + 1;
-			key_read(c, ubifs_idx_key(c, idx), &lower_key);
-			highest_ino_key(c, &upper_key, INUM_WATERMARK);
+			key_read(ubifs_idx_key(idx), &lower_key);
+			highest_ino_key(&upper_key, INUM_WATERMARK);
 		}
-		key_copy(c, &upper_key, &i->upper_key);
+		key_copy(&upper_key, &i->upper_key);
 		if (le16_to_cpu(idx->level) != last_level - 1) {
 			err = 3;
 			goto out_dump;
@@ -589,19 +589,19 @@ int dbg_check_old_index(struct ubifs_inf
 			goto out_dump;
 		}
 		/* Check key range */
-		key_read(c, ubifs_idx_key(c, idx), &l_key);
+		key_read(ubifs_idx_key(idx), &l_key);
 		br = ubifs_idx_branch(c, idx, child_cnt - 1);
-		key_read(c, &br->key, &u_key);
-		if (keys_cmp(c, &lower_key, &l_key) > 0) {
+		key_read(&br->key, &u_key);
+		if (keys_cmp(&lower_key, &l_key) > 0) {
 			err = 5;
 			goto out_dump;
 		}
-		if (keys_cmp(c, &upper_key, &u_key) < 0) {
+		if (keys_cmp(&upper_key, &u_key) < 0) {
 			err = 6;
 			goto out_dump;
 		}
-		if (keys_cmp(c, &upper_key, &u_key) == 0)
-			if (!is_hash_key(c, &u_key)) {
+		if (keys_cmp(&upper_key, &u_key) == 0)
+			if (!is_hash_key(&u_key)) {
 				err = 7;
 				goto out_dump;
 			}
@@ -640,12 +640,12 @@ int dbg_check_old_index(struct ubifs_inf
 		lnum = le32_to_cpu(br->lnum);
 		offs = le32_to_cpu(br->offs);
 		len = le32_to_cpu(br->len);
-		key_read(c, &br->key, &lower_key);
+		key_read(&br->key, &lower_key);
 		if (iip + 1 < le16_to_cpu(idx->child_cnt)) {
 			br = ubifs_idx_branch(c, idx, iip + 1);
-			key_read(c, &br->key, &upper_key);
+			key_read(&br->key, &upper_key);
 		} else
-			key_copy(c, &i->upper_key, &upper_key);
+			key_copy(&i->upper_key, &upper_key);
 	}
 out:
 	err = dbg_old_index_check_init(c, zroot);
diff -uprN a/fs/ubifs/debug.c b/fs/ubifs/debug.c
--- a/fs/ubifs/debug.c	2009-07-17 08:11:49.000000000 +0530
+++ b/fs/ubifs/debug.c	2009-07-17 11:30:46.000000000 +0530
@@ -98,28 +98,28 @@ static void sprintf_key(const struct ubi
 			char *buffer)
 {
 	char *p = buffer;
-	int type = key_type(c, key);
+	int type = key_type(key);
 
 	if (c->key_fmt == UBIFS_SIMPLE_KEY_FMT) {
 		switch (type) {
 		case UBIFS_INO_KEY:
-			sprintf(p, "(%lu, %s)", (unsigned long)key_inum(c, key),
+			sprintf(p, "(%lu, %s)", (unsigned long)key_inum(key),
 			       get_key_type(type));
 			break;
 		case UBIFS_DENT_KEY:
 		case UBIFS_XENT_KEY:
 			sprintf(p, "(%lu, %s, %#08x)",
-				(unsigned long)key_inum(c, key),
-				get_key_type(type), key_hash(c, key));
+				(unsigned long)key_inum(key),
+				get_key_type(type), key_hash(key));
 			break;
 		case UBIFS_DATA_KEY:
 			sprintf(p, "(%lu, %s, %u)",
-				(unsigned long)key_inum(c, key),
-				get_key_type(type), key_block(c, key));
+				(unsigned long)key_inum(key),
+				get_key_type(type), key_block(key));
 			break;
 		case UBIFS_TRUN_KEY:
 			sprintf(p, "(%lu, %s)",
-				(unsigned long)key_inum(c, key),
+				(unsigned long)key_inum(key),
 				get_key_type(type));
 			break;
 		default:
@@ -423,7 +423,7 @@ void dbg_dump_node(const struct ubifs_in
 	{
 		const struct ubifs_ino_node *ino = node;
 
-		key_read(c, &ino->key, &key);
+		key_read(&ino->key, &key);
 		printk(KERN_DEBUG "\tkey            %s\n", DBGKEY(&key));
 		printk(KERN_DEBUG "\tcreat_sqnum    %llu\n",
 		       (unsigned long long)le64_to_cpu(ino->creat_sqnum));
@@ -466,7 +466,7 @@ void dbg_dump_node(const struct ubifs_in
 		const struct ubifs_dent_node *dent = node;
 		int nlen = le16_to_cpu(dent->nlen);
 
-		key_read(c, &dent->key, &key);
+		key_read(&dent->key, &key);
 		printk(KERN_DEBUG "\tkey            %s\n", DBGKEY(&key));
 		printk(KERN_DEBUG "\tinum           %llu\n",
 		       (unsigned long long)le64_to_cpu(dent->inum));
@@ -490,7 +490,7 @@ void dbg_dump_node(const struct ubifs_in
 		const struct ubifs_data_node *dn = node;
 		int dlen = le32_to_cpu(ch->len) - UBIFS_DATA_NODE_SZ;
 
-		key_read(c, &dn->key, &key);
+		key_read(&dn->key, &key);
 		printk(KERN_DEBUG "\tkey            %s\n", DBGKEY(&key));
 		printk(KERN_DEBUG "\tsize           %u\n",
 		       le32_to_cpu(dn->size));
@@ -529,7 +529,7 @@ void dbg_dump_node(const struct ubifs_in
 			const struct ubifs_branch *br;
 
 			br = ubifs_idx_branch(c, idx, i);
-			key_read(c, &br->key, &key);
+			key_read(&br->key, &key);
 			printk(KERN_DEBUG "\t%d: LEB %d:%d len %d key %s\n",
 			       i, le32_to_cpu(br->lnum), le32_to_cpu(br->offs),
 			       le32_to_cpu(br->len), DBGKEY(&key));
@@ -979,7 +979,7 @@ int dbg_check_dir_size(struct ubifs_info
 	if (!S_ISDIR(dir->i_mode))
 		return 0;
 
-	lowest_dent_key(c, &key, dir->i_ino);
+	lowest_dent_key(&key, dir->i_ino);
 	while (1) {
 		int err;
 
@@ -998,7 +998,7 @@ int dbg_check_dir_size(struct ubifs_info
 			nlink += 1;
 		kfree(pdent);
 		pdent = dent;
-		key_read(c, &dent->key, &key);
+		key_read(&dent->key, &key);
 	}
 	kfree(pdent);
 
@@ -1040,7 +1040,7 @@ static int dbg_check_key_order(struct ub
 	struct ubifs_dent_node *dent1, *dent2;
 	union ubifs_key key;
 
-	ubifs_assert(!keys_cmp(c, &zbr1->key, &zbr2->key));
+	ubifs_assert(!keys_cmp(&zbr1->key, &zbr2->key));
 	dent1 = kmalloc(UBIFS_MAX_DENT_NODE_SZ, GFP_NOFS);
 	if (!dent1)
 		return -ENOMEM;
@@ -1053,21 +1053,21 @@ static int dbg_check_key_order(struct ub
 	err = ubifs_tnc_read_node(c, zbr1, dent1);
 	if (err)
 		goto out_free;
-	err = ubifs_validate_entry(c, dent1);
+	err = ubifs_validate_entry(dent1);
 	if (err)
 		goto out_free;
 
 	err = ubifs_tnc_read_node(c, zbr2, dent2);
 	if (err)
 		goto out_free;
-	err = ubifs_validate_entry(c, dent2);
+	err = ubifs_validate_entry(dent2);
 	if (err)
 		goto out_free;
 
 	/* Make sure node keys are the same as in zbranch */
 	err = 1;
-	key_read(c, &dent1->key, &key);
-	if (keys_cmp(c, &zbr1->key, &key)) {
+	key_read(&dent1->key, &key);
+	if (keys_cmp(&zbr1->key, &key)) {
 		dbg_err("1st entry at %d:%d has key %s", zbr1->lnum,
 			zbr1->offs, DBGKEY(&key));
 		dbg_err("but it should have key %s according to tnc",
@@ -1076,8 +1076,8 @@ static int dbg_check_key_order(struct ub
 		goto out_free;
 	}
 
-	key_read(c, &dent2->key, &key);
-	if (keys_cmp(c, &zbr2->key, &key)) {
+	key_read(&dent2->key, &key);
+	if (keys_cmp(&zbr2->key, &key)) {
 		dbg_err("2nd entry at %d:%d has key %s", zbr1->lnum,
 			zbr1->offs, DBGKEY(&key));
 		dbg_err("but it should have key %s according to tnc",
@@ -1176,7 +1176,7 @@ static int dbg_check_znode(struct ubifs_
 		}
 
 		/* Make sure the 'parent' pointer in our znode is correct */
-		err = ubifs_search_zbranch(c, zp, &zbr->key, &n);
+		err = ubifs_search_zbranch(zp, &zbr->key, &n);
 		if (!err) {
 			/* This zbranch does not exist in the parent */
 			err = 7;
@@ -1190,7 +1190,7 @@ static int dbg_check_znode(struct ubifs_
 
 		if (znode->iip != n) {
 			/* This may happen only in case of collisions */
-			if (keys_cmp(c, &zp->zbranch[n].key,
+			if (keys_cmp(&zp->zbranch[n].key,
 				     &zp->zbranch[znode->iip].key)) {
 				err = 9;
 				goto out;
@@ -1203,7 +1203,7 @@ static int dbg_check_znode(struct ubifs_
 		 * equal to the key in the pointing zbranch.
 		 */
 		min = &zbr->key;
-		cmp = keys_cmp(c, min, &znode->zbranch[0].key);
+		cmp = keys_cmp(min, &znode->zbranch[0].key);
 		if (cmp == 1) {
 			err = 10;
 			goto out;
@@ -1217,7 +1217,7 @@ static int dbg_check_znode(struct ubifs_
 			 * equivalent than the key in the zbranch which goes
 			 * after our pointing zbranch.
 			 */
-			cmp = keys_cmp(c, max,
+			cmp = keys_cmp(max,
 				&znode->zbranch[znode->child_cnt - 1].key);
 			if (cmp == -1) {
 				err = 11;
@@ -1237,7 +1237,7 @@ static int dbg_check_znode(struct ubifs_
 	 * one.
 	 */
 	for (n = 1; n < znode->child_cnt; n++) {
-		cmp = keys_cmp(c, &znode->zbranch[n - 1].key,
+		cmp = keys_cmp(&znode->zbranch[n - 1].key,
 			       &znode->zbranch[n].key);
 		if (cmp > 0) {
 			err = 13;
@@ -1245,7 +1245,7 @@ static int dbg_check_znode(struct ubifs_
 		}
 		if (cmp == 0) {
 			/* This can only be keys with colliding hash */
-			if (!is_hash_key(c, &znode->zbranch[n].key)) {
+			if (!is_hash_key(&znode->zbranch[n].key)) {
 				err = 14;
 				goto out;
 			}
@@ -1368,7 +1368,7 @@ int dbg_check_tnc(struct ubifs_info *c, 
 		 */
 		last = prev->child_cnt - 1;
 		if (prev->level == 0 && znode->level == 0 && !c->replaying &&
-		    !keys_cmp(c, &prev->zbranch[last].key,
+		    !keys_cmp(&prev->zbranch[last].key,
 			      &znode->zbranch[0].key)) {
 			err = dbg_check_key_order(c, &prev->zbranch[last],
 						  &znode->zbranch[0]);
@@ -1656,7 +1656,7 @@ static struct fsck_inode *add_inode(stru
 {
 	struct rb_node **p, *parent = NULL;
 	struct fsck_inode *fscki;
-	ino_t inum = key_inum_flash(c, &ino->key);
+	ino_t inum = key_inum_flash(&ino->key);
 
 	p = &fsckd->inodes.rb_node;
 	while (*p) {
@@ -1748,7 +1748,7 @@ static struct fsck_inode *read_add_inode
 	if (fscki)
 		return fscki;
 
-	ino_key_init(c, &key, inum);
+	ino_key_init(&key, inum);
 	err = ubifs_lookup_level0(c, &key, &znode, &n);
 	if (!err) {
 		ubifs_err("inode %lu not found in index", (unsigned long)inum);
@@ -1811,7 +1811,7 @@ static int check_leaf(struct ubifs_info 
 	ino_t inum;
 	void *node;
 	struct ubifs_ch *ch;
-	int err, type = key_type(c, &zbr->key);
+	int err, type = key_type(&zbr->key);
 	struct fsck_inode *fscki;
 
 	if (zbr->len < UBIFS_CH_SZ) {
@@ -1866,7 +1866,7 @@ static int check_leaf(struct ubifs_info 
 		 * Search the inode node this data node belongs to and insert
 		 * it to the RB-tree of inodes.
 		 */
-		inum = key_inum_flash(c, &dn->key);
+		inum = key_inum_flash(&dn->key);
 		fscki = read_add_inode(c, priv, inum);
 		if (IS_ERR(fscki)) {
 			err = PTR_ERR(fscki);
@@ -1877,7 +1877,7 @@ static int check_leaf(struct ubifs_info 
 		}
 
 		/* Make sure the data node is within inode size */
-		blk_offs = key_block_flash(c, &dn->key);
+		blk_offs = key_block_flash(&dn->key);
 		blk_offs <<= UBIFS_BLOCK_SHIFT;
 		blk_offs += le32_to_cpu(dn->size);
 		if (blk_offs > fscki->size) {
@@ -1892,7 +1892,7 @@ static int check_leaf(struct ubifs_info 
 		struct ubifs_dent_node *dent = node;
 		struct fsck_inode *fscki1;
 
-		err = ubifs_validate_entry(c, dent);
+		err = ubifs_validate_entry(dent);
 		if (err)
 			goto out_dump;
 
@@ -1913,7 +1913,7 @@ static int check_leaf(struct ubifs_info 
 		/* Count how many direntries or xentries refers this inode */
 		fscki->references += 1;
 
-		inum = key_inum_flash(c, &dent->key);
+		inum = key_inum_flash(&dent->key);
 		fscki1 = read_add_inode(c, priv, inum);
 		if (IS_ERR(fscki1)) {
 			err = PTR_ERR(fscki);
@@ -2073,7 +2073,7 @@ static int check_inodes(struct ubifs_inf
 
 out_dump:
 	/* Read the bad inode and dump it */
-	ino_key_init(c, &key, fscki->inum);
+	ino_key_init(&key, fscki->inum);
 	err = ubifs_lookup_level0(c, &key, &znode, &n);
 	if (!err) {
 		ubifs_err("inode %lu not found in index",
diff -uprN a/fs/ubifs/dir.c b/fs/ubifs/dir.c
--- a/fs/ubifs/dir.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/dir.c	2009-07-17 09:59:39.000000000 +0530
@@ -394,7 +394,7 @@ static int ubifs_readdir(struct file *fi
 			return 0;
 
 		/* Find the first entry in TNC and save it */
-		lowest_dent_key(c, &key, dir->i_ino);
+		lowest_dent_key(&key, dir->i_ino);
 		nm.name = NULL;
 		dent = ubifs_tnc_next_ent(c, &key, &nm);
 		if (IS_ERR(dent)) {
@@ -402,7 +402,7 @@ static int ubifs_readdir(struct file *fi
 			goto out;
 		}
 
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = key_hash_flash(&dent->key);
 		file->private_data = dent;
 	}
 
@@ -413,21 +413,21 @@ static int ubifs_readdir(struct file *fi
 		 * Find the entry corresponding to @file->f_pos or the
 		 * closest one.
 		 */
-		dent_key_init_hash(c, &key, dir->i_ino, file->f_pos);
+		dent_key_init_hash(&key, dir->i_ino, file->f_pos);
 		nm.name = NULL;
 		dent = ubifs_tnc_next_ent(c, &key, &nm);
 		if (IS_ERR(dent)) {
 			err = PTR_ERR(dent);
 			goto out;
 		}
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = key_hash_flash(&dent->key);
 		file->private_data = dent;
 	}
 
 	while (1) {
 		dbg_gen("feed '%s', ino %llu, new f_pos %#x",
 			dent->name, (unsigned long long)le64_to_cpu(dent->inum),
-			key_hash_flash(c, &dent->key));
+			key_hash_flash(&dent->key));
 		ubifs_assert(le64_to_cpu(dent->ch.sqnum) >
 			     ubifs_inode(dir)->creat_sqnum);
 
@@ -439,7 +439,7 @@ static int ubifs_readdir(struct file *fi
 			return 0;
 
 		/* Switch to the next entry */
-		key_read(c, &dent->key, &key);
+		key_read(&dent->key, &key);
 		nm.name = dent->name;
 		dent = ubifs_tnc_next_ent(c, &key, &nm);
 		if (IS_ERR(dent)) {
@@ -448,7 +448,7 @@ static int ubifs_readdir(struct file *fi
 		}
 
 		kfree(file->private_data);
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = key_hash_flash(&dent->key);
 		file->private_data = dent;
 		cond_resched();
 	}
@@ -659,7 +659,7 @@ static int check_dir_empty(struct ubifs_
 	union ubifs_key key;
 	int err;
 
-	lowest_dent_key(c, &key, dir->i_ino);
+	lowest_dent_key(&key, dir->i_ino);
 	dent = ubifs_tnc_next_ent(c, &key, &nm);
 	if (IS_ERR(dent)) {
 		err = PTR_ERR(dent);
diff -uprN a/fs/ubifs/file.c b/fs/ubifs/file.c
--- a/fs/ubifs/file.c	2009-07-17 08:11:49.000000000 +0530
+++ b/fs/ubifs/file.c	2009-07-17 09:54:11.000000000 +0530
@@ -63,7 +63,7 @@ static int read_block(struct inode *inod
 	union ubifs_key key;
 	unsigned int dlen;
 
-	data_key_init(c, &key, inode->i_ino, block);
+	data_key_init(&key, inode->i_ino, block);
 	err = ubifs_tnc_lookup(c, &key, dn);
 	if (err) {
 		if (err == -ENOENT)
@@ -631,7 +631,7 @@ static int populate_page(struct ubifs_in
 		if (nn >= bu->cnt) {
 			hole = 1;
 			memset(addr, 0, UBIFS_BLOCK_SIZE);
-		} else if (key_block(c, &bu->zbranch[nn].key) == page_block) {
+		} else if (key_block(&bu->zbranch[nn].key) == page_block) {
 			struct ubifs_data_node *dn;
 
 			dn = bu->buf + (bu->zbranch[nn].offs - offs);
@@ -655,7 +655,7 @@ static int populate_page(struct ubifs_in
 
 			nn += 1;
 			read = (i << UBIFS_BLOCK_SHIFT) + len;
-		} else if (key_block(c, &bu->zbranch[nn].key) < page_block) {
+		} else if (key_block(&bu->zbranch[nn].key) < page_block) {
 			nn += 1;
 			continue;
 		} else {
@@ -866,7 +866,7 @@ static int ubifs_bulk_read(struct page *
 	}
 
 	bu->buf_len = c->max_bu_buf_len;
-	data_key_init(c, &bu->key, inode->i_ino,
+	data_key_init(&bu->key, inode->i_ino,
 		      page->index << UBIFS_BLOCKS_PER_PAGE_SHIFT);
 	err = ubifs_do_bulk_read(c, bu, page);
 
@@ -912,7 +912,7 @@ static int do_writepage(struct page *pag
 	i = 0;
 	while (len) {
 		blen = min_t(int, len, UBIFS_BLOCK_SIZE);
-		data_key_init(c, &key, inode->i_ino, block);
+		data_key_init(&key, inode->i_ino, block);
 		err = ubifs_jnl_write_data(c, inode, &key, addr, blen);
 		if (err)
 			break;
diff -uprN a/fs/ubifs/gc.c b/fs/ubifs/gc.c
--- a/fs/ubifs/gc.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/gc.c	2009-07-17 11:25:37.000000000 +0530
@@ -214,21 +214,20 @@ static void list_sort(void *priv, struct
 int data_nodes_cmp(void *priv, struct list_head *a, struct list_head *b)
 {
 	ino_t inuma, inumb;
-	struct ubifs_info *c = priv;
 	struct ubifs_scan_node *sa, *sb;
 
 	cond_resched();
 	sa = list_entry(a, struct ubifs_scan_node, list);
 	sb = list_entry(b, struct ubifs_scan_node, list);
-	ubifs_assert(key_type(c, &sa->key) == UBIFS_DATA_KEY);
-	ubifs_assert(key_type(c, &sb->key) == UBIFS_DATA_KEY);
+	ubifs_assert(key_type(&sa->key) == UBIFS_DATA_KEY);
+	ubifs_assert(key_type(&sb->key) == UBIFS_DATA_KEY);
 
-	inuma = key_inum(c, &sa->key);
-	inumb = key_inum(c, &sb->key);
+	inuma = key_inum(&sa->key);
+	inumb = key_inum(&sb->key);
 
 	if (inuma == inumb) {
-		unsigned int blka = key_block(c, &sa->key);
-		unsigned int blkb = key_block(c, &sb->key);
+		unsigned int blka = key_block(&sa->key);
+		unsigned int blkb = key_block(&sb->key);
 
 		if (blka <= blkb)
 			return -1;
@@ -252,14 +251,13 @@ int nondata_nodes_cmp(void *priv, struct
 {
 	int typea, typeb;
 	ino_t inuma, inumb;
-	struct ubifs_info *c = priv;
 	struct ubifs_scan_node *sa, *sb;
 
 	cond_resched();
 	sa = list_entry(a, struct ubifs_scan_node, list);
 	sb = list_entry(b, struct ubifs_scan_node, list);
-	typea = key_type(c, &sa->key);
-	typeb = key_type(c, &sb->key);
+	typea = key_type(&sa->key);
+	typeb = key_type(&sb->key);
 	ubifs_assert(typea != UBIFS_DATA_KEY && typeb != UBIFS_DATA_KEY);
 
 	/* Inodes go before directory entries */
@@ -272,12 +270,12 @@ int nondata_nodes_cmp(void *priv, struct
 		return 1;
 
 	ubifs_assert(typea == UBIFS_DENT_KEY && typeb == UBIFS_DENT_KEY);
-	inuma = key_inum(c, &sa->key);
-	inumb = key_inum(c, &sb->key);
+	inuma = key_inum(&sa->key);
+	inumb = key_inum(&sb->key);
 
 	if (inuma == inumb) {
-		uint32_t hasha = key_hash(c, &sa->key);
-		uint32_t hashb = key_hash(c, &sb->key);
+		uint32_t hasha = key_hash(&sa->key);
+		uint32_t hashb = key_hash(&sb->key);
 
 		if (hasha <= hashb)
 			return -1;
@@ -344,7 +342,7 @@ static int sort_nodes(struct ubifs_info 
 		if (snod->len < *min)
 			*min = snod->len;
 
-		if (key_type(c, &snod->key) != UBIFS_DATA_KEY)
+		if (key_type(&snod->key) != UBIFS_DATA_KEY)
 			list_move_tail(&snod->list, nondata);
 	}
 
@@ -447,7 +445,7 @@ static int move_nodes(struct ubifs_info 
 				 * nodes and direntry nodes are roughly of the
 				 * same size.
 				 */
-				if (key_type(c, &snod->key) == UBIFS_DENT_KEY ||
+				if (key_type(&snod->key) == UBIFS_DENT_KEY ||
 				    snod->len == UBIFS_INO_NODE_SZ)
 					break;
 				continue;
@@ -546,7 +544,7 @@ int ubifs_garbage_collect_leb(struct ubi
 			int level = le16_to_cpu(idx->level);
 
 			ubifs_assert(snod->type == UBIFS_IDX_NODE);
-			key_read(c, ubifs_idx_key(c, idx), &snod->key);
+			key_read(ubifs_idx_key(idx), &snod->key);
 			err = ubifs_dirty_idx_node(c, &snod->key, level, lnum,
 						   snod->offs);
 			if (err)
diff -uprN a/fs/ubifs/journal.c b/fs/ubifs/journal.c
--- a/fs/ubifs/journal.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/journal.c	2009-07-17 10:13:24.000000000 +0530
@@ -454,7 +454,7 @@ static void pack_inode(struct ubifs_info
 	struct ubifs_inode *ui = ubifs_inode(inode);
 
 	ino->ch.node_type = UBIFS_INO_NODE;
-	ino_key_init_flash(c, &ino->key, inode->i_ino);
+	ino_key_init_flash(&ino->key, inode->i_ino);
 	ino->creat_sqnum = cpu_to_le64(ui->creat_sqnum);
 	ino->atime_sec  = cpu_to_le64(inode->i_atime.tv_sec);
 	ino->atime_nsec = cpu_to_le32(inode->i_atime.tv_nsec);
@@ -583,7 +583,7 @@ int ubifs_jnl_update(struct ubifs_info *
 		xent_key_init(c, &dent_key, dir->i_ino, nm);
 	}
 
-	key_write(c, &dent_key, dent->key);
+	key_write(&dent_key, dent->key);
 	dent->inum = deletion ? 0 : cpu_to_le64(inode->i_ino);
 	dent->type = get_dent_type(inode->i_mode);
 	dent->nlen = cpu_to_le16(nm->len);
@@ -634,13 +634,13 @@ int ubifs_jnl_update(struct ubifs_info *
 	 * Instead, the inode has been added to orphan lists and the orphan
 	 * subsystem will take further care about it.
 	 */
-	ino_key_init(c, &ino_key, inode->i_ino);
+	ino_key_init(&ino_key, inode->i_ino);
 	ino_offs = dent_offs + aligned_dlen;
 	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, ilen);
 	if (err)
 		goto out_ro;
 
-	ino_key_init(c, &ino_key, dir->i_ino);
+	ino_key_init(&ino_key, dir->i_ino);
 	ino_offs += aligned_ilen;
 	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, UBIFS_INO_NODE_SZ);
 	if (err)
@@ -690,7 +690,7 @@ int ubifs_jnl_write_data(struct ubifs_in
 	struct ubifs_inode *ui = ubifs_inode(inode);
 
 	dbg_jnl("ino %lu, blk %u, len %d, key %s",
-		(unsigned long)key_inum(c, key), key_block(c, key), len,
+		(unsigned long)key_inum(key), key_block(key), len,
 		DBGKEY(key));
 	ubifs_assert(len <= UBIFS_BLOCK_SIZE);
 
@@ -699,7 +699,7 @@ int ubifs_jnl_write_data(struct ubifs_in
 		return -ENOMEM;
 
 	data->ch.node_type = UBIFS_DATA_NODE;
-	key_write(c, key, &data->key);
+	key_write(key, &data->key);
 	data->size = cpu_to_le32(len);
 	zero_data_node_unused(data);
 
@@ -724,7 +724,7 @@ int ubifs_jnl_write_data(struct ubifs_in
 	err = write_node(c, DATAHD, data, dlen, &lnum, &offs);
 	if (err)
 		goto out_release;
-	ubifs_wbuf_add_ino_nolock(&c->jheads[DATAHD].wbuf, key_inum(c, key));
+	ubifs_wbuf_add_ino_nolock(&c->jheads[DATAHD].wbuf, key_inum(key));
 	release_head(c, DATAHD);
 
 	err = ubifs_tnc_add(c, key, lnum, offs, dlen);
@@ -798,7 +798,7 @@ int ubifs_jnl_write_inode(struct ubifs_i
 	} else {
 		union ubifs_key key;
 
-		ino_key_init(c, &key, inode->i_ino);
+		ino_key_init(&key, inode->i_ino);
 		err = ubifs_tnc_add(c, &key, lnum, offs, len);
 	}
 	if (err)
@@ -1021,21 +1021,21 @@ int ubifs_jnl_rename(struct ubifs_info *
 
 	offs += aligned_dlen1 + aligned_dlen2;
 	if (new_inode) {
-		ino_key_init(c, &key, new_inode->i_ino);
+		ino_key_init(&key, new_inode->i_ino);
 		err = ubifs_tnc_add(c, &key, lnum, offs, ilen);
 		if (err)
 			goto out_ro;
 		offs += ALIGN(ilen, 8);
 	}
 
-	ino_key_init(c, &key, old_dir->i_ino);
+	ino_key_init(&key, old_dir->i_ino);
 	err = ubifs_tnc_add(c, &key, lnum, offs, plen);
 	if (err)
 		goto out_ro;
 
 	if (old_dir != new_dir) {
 		offs += ALIGN(plen, 8);
-		ino_key_init(c, &key, new_dir->i_ino);
+		ino_key_init(&key, new_dir->i_ino);
 		err = ubifs_tnc_add(c, &key, lnum, offs, plen);
 		if (err)
 			goto out_ro;
@@ -1152,7 +1152,7 @@ int ubifs_jnl_truncate(struct ubifs_info
 		/* Get last data block so it can be truncated */
 		dn = (void *)trun + UBIFS_TRUN_NODE_SZ;
 		blk = new_size >> UBIFS_BLOCK_SHIFT;
-		data_key_init(c, &key, inum, blk);
+		data_key_init(&key, inum, blk);
 		dbg_jnl("last block key %s", DBGKEY(&key));
 		err = ubifs_tnc_lookup(c, &key, dn);
 		if (err == -ENOENT)
@@ -1205,7 +1205,7 @@ int ubifs_jnl_truncate(struct ubifs_info
 			goto out_ro;
 	}
 
-	ino_key_init(c, &key, inum);
+	ino_key_init(&key, inum);
 	err = ubifs_tnc_add(c, &key, lnum, offs, UBIFS_INO_NODE_SZ);
 	if (err)
 		goto out_ro;
@@ -1216,11 +1216,11 @@ int ubifs_jnl_truncate(struct ubifs_info
 
 	bit = new_size & (UBIFS_BLOCK_SIZE - 1);
 	blk = (new_size >> UBIFS_BLOCK_SHIFT) + (bit ? 1 : 0);
-	data_key_init(c, &key, inum, blk);
+	data_key_init(&key, inum, blk);
 
 	bit = old_size & (UBIFS_BLOCK_SIZE - 1);
 	blk = (old_size >> UBIFS_BLOCK_SHIFT) - (bit ? 0 : 1);
-	data_key_init(c, &to_key, inum, blk);
+	data_key_init(&to_key, inum, blk);
 
 	err = ubifs_tnc_remove_range(c, &key, &to_key);
 	if (err)
@@ -1296,7 +1296,7 @@ int ubifs_jnl_delete_xattr(struct ubifs_
 
 	xent->ch.node_type = UBIFS_XENT_NODE;
 	xent_key_init(c, &xent_key, host->i_ino, nm);
-	key_write(c, &xent_key, xent->key);
+	key_write(&xent_key, xent->key);
 	xent->inum = 0;
 	xent->type = get_dent_type(inode->i_mode);
 	xent->nlen = cpu_to_le16(nm->len);
@@ -1330,8 +1330,8 @@ int ubifs_jnl_delete_xattr(struct ubifs_
 	 * Remove all nodes belonging to the extended attribute inode from TNC.
 	 * Well, there actually must be only one node - the inode itself.
 	 */
-	lowest_ino_key(c, &key1, inode->i_ino);
-	highest_ino_key(c, &key2, inode->i_ino);
+	lowest_ino_key(&key1, inode->i_ino);
+	highest_ino_key(&key2, inode->i_ino);
 	err = ubifs_tnc_remove_range(c, &key1, &key2);
 	if (err)
 		goto out_ro;
@@ -1340,7 +1340,7 @@ int ubifs_jnl_delete_xattr(struct ubifs_
 		goto out_ro;
 
 	/* And update TNC with the new host inode position */
-	ino_key_init(c, &key1, host->i_ino);
+	ino_key_init(&key1, host->i_ino);
 	err = ubifs_tnc_add(c, &key1, lnum, xent_offs + len - hlen, hlen);
 	if (err)
 		goto out_ro;
@@ -1413,12 +1413,12 @@ int ubifs_jnl_change_xattr(struct ubifs_
 	if (err)
 		goto out_ro;
 
-	ino_key_init(c, &key, host->i_ino);
+	ino_key_init(&key, host->i_ino);
 	err = ubifs_tnc_add(c, &key, lnum, offs, len1);
 	if (err)
 		goto out_ro;
 
-	ino_key_init(c, &key, inode->i_ino);
+	ino_key_init(&key, inode->i_ino);
 	err = ubifs_tnc_add(c, &key, lnum, offs + aligned_len1, len2);
 	if (err)
 		goto out_ro;
diff -uprN a/fs/ubifs/key.h b/fs/ubifs/key.h
--- a/fs/ubifs/key.h	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/key.h	2009-07-17 10:28:02.000000000 +0530
@@ -93,8 +93,7 @@ static inline uint32_t key_test_hash(con
  * @key: key to initialize
  * @inum: inode number
  */
-static inline void ino_key_init(const struct ubifs_info *c,
-				union ubifs_key *key, ino_t inum)
+static inline void ino_key_init(union ubifs_key *key, ino_t inum)
 {
 	key->u32[0] = inum;
 	key->u32[1] = UBIFS_INO_KEY << UBIFS_S_KEY_BLOCK_BITS;
@@ -106,8 +105,7 @@ static inline void ino_key_init(const st
  * @k: key to initialize
  * @inum: inode number
  */
-static inline void ino_key_init_flash(const struct ubifs_info *c, void *k,
-				      ino_t inum)
+static inline void ino_key_init_flash(void *k, ino_t inum)
 {
 	union ubifs_key *key = k;
 
@@ -122,8 +120,7 @@ static inline void ino_key_init_flash(co
  * @key: key to initialize
  * @inum: inode number
  */
-static inline void lowest_ino_key(const struct ubifs_info *c,
-				union ubifs_key *key, ino_t inum)
+static inline void lowest_ino_key(union ubifs_key *key, ino_t inum)
 {
 	key->u32[0] = inum;
 	key->u32[1] = 0;
@@ -135,8 +132,7 @@ static inline void lowest_ino_key(const 
  * @key: key to initialize
  * @inum: inode number
  */
-static inline void highest_ino_key(const struct ubifs_info *c,
-				union ubifs_key *key, ino_t inum)
+static inline void highest_ino_key(union ubifs_key *key, ino_t inum)
 {
 	key->u32[0] = inum;
 	key->u32[1] = 0xffffffff;
@@ -153,7 +149,7 @@ static inline void dent_key_init(const s
 				 union ubifs_key *key, ino_t inum,
 				 const struct qstr *nm)
 {
-	uint32_t hash = c->key_hash(nm->name, nm->len);
+	uint32_t hash = c->key_hash(nm->len);
 
 	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
 	key->u32[0] = inum;
@@ -168,8 +164,7 @@ static inline void dent_key_init(const s
  * @inum: parent inode number
  * @hash: direntry name hash
  */
-static inline void dent_key_init_hash(const struct ubifs_info *c,
-				      union ubifs_key *key, ino_t inum,
+static inline void dent_key_init_hash(union ubifs_key *key, ino_t inum,
 				      uint32_t hash)
 {
 	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
@@ -188,7 +183,7 @@ static inline void dent_key_init_flash(c
 				       ino_t inum, const struct qstr *nm)
 {
 	union ubifs_key *key = k;
-	uint32_t hash = c->key_hash(nm->name, nm->len);
+	uint32_t hash = c->key_hash(nm->len);
 
 	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
 	key->j32[0] = cpu_to_le32(inum);
@@ -203,8 +198,7 @@ static inline void dent_key_init_flash(c
  * @key: where to store the lowest key
  * @inum: parent inode number
  */
-static inline void lowest_dent_key(const struct ubifs_info *c,
-				   union ubifs_key *key, ino_t inum)
+static inline void lowest_dent_key(union ubifs_key *key, ino_t inum)
 {
 	key->u32[0] = inum;
 	key->u32[1] = UBIFS_DENT_KEY << UBIFS_S_KEY_HASH_BITS;
@@ -221,7 +215,7 @@ static inline void xent_key_init(const s
 				 union ubifs_key *key, ino_t inum,
 				 const struct qstr *nm)
 {
-	uint32_t hash = c->key_hash(nm->name, nm->len);
+	uint32_t hash = c->key_hash(nm->len);
 
 	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
 	key->u32[0] = inum;
@@ -229,23 +223,6 @@ static inline void xent_key_init(const s
 }
 
 /**
- * xent_key_init_hash - initialize extended attribute entry key without
- *                      re-calculating hash function.
- * @c: UBIFS file-system description object
- * @key: key to initialize
- * @inum: host inode number
- * @hash: extended attribute entry name hash
- */
-static inline void xent_key_init_hash(const struct ubifs_info *c,
-				      union ubifs_key *key, ino_t inum,
-				      uint32_t hash)
-{
-	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
-	key->u32[0] = inum;
-	key->u32[1] = hash | (UBIFS_XENT_KEY << UBIFS_S_KEY_HASH_BITS);
-}
-
-/**
  * xent_key_init_flash - initialize on-flash extended attribute entry key.
  * @c: UBIFS file-system description object
  * @k: key to initialize
@@ -256,7 +233,7 @@ static inline void xent_key_init_flash(c
 				       ino_t inum, const struct qstr *nm)
 {
 	union ubifs_key *key = k;
-	uint32_t hash = c->key_hash(nm->name, nm->len);
+	uint32_t hash = c->key_hash(nm->len);
 
 	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
 	key->j32[0] = cpu_to_le32(inum);
@@ -271,8 +248,7 @@ static inline void xent_key_init_flash(c
  * @key: where to store the lowest key
  * @inum: host inode number
  */
-static inline void lowest_xent_key(const struct ubifs_info *c,
-				   union ubifs_key *key, ino_t inum)
+static inline void lowest_xent_key(union ubifs_key *key, ino_t inum)
 {
 	key->u32[0] = inum;
 	key->u32[1] = UBIFS_XENT_KEY << UBIFS_S_KEY_HASH_BITS;
@@ -285,8 +261,7 @@ static inline void lowest_xent_key(const
  * @inum: inode number
  * @block: block number
  */
-static inline void data_key_init(const struct ubifs_info *c,
-				 union ubifs_key *key, ino_t inum,
+static inline void data_key_init(union ubifs_key *key, ino_t inum,
 				 unsigned int block)
 {
 	ubifs_assert(!(block & ~UBIFS_S_KEY_BLOCK_MASK));
@@ -295,25 +270,6 @@ static inline void data_key_init(const s
 }
 
 /**
- * data_key_init_flash - initialize on-flash data key.
- * @c: UBIFS file-system description object
- * @k: key to initialize
- * @inum: inode number
- * @block: block number
- */
-static inline void data_key_init_flash(const struct ubifs_info *c, void *k,
-				       ino_t inum, unsigned int block)
-{
-	union ubifs_key *key = k;
-
-	ubifs_assert(!(block & ~UBIFS_S_KEY_BLOCK_MASK));
-	key->j32[0] = cpu_to_le32(inum);
-	key->j32[1] = cpu_to_le32(block |
-				  (UBIFS_DATA_KEY << UBIFS_S_KEY_BLOCK_BITS));
-	memset(k + 8, 0, UBIFS_MAX_KEY_LEN - 8);
-}
-
-/**
  * trun_key_init - initialize truncation node key.
  * @c: UBIFS file-system description object
  * @key: key to initialize
@@ -322,8 +278,7 @@ static inline void data_key_init_flash(c
  * Note, UBIFS does not have truncation keys on the media and this function is
  * only used for purposes of replay.
  */
-static inline void trun_key_init(const struct ubifs_info *c,
-				 union ubifs_key *key, ino_t inum)
+static inline void trun_key_init(union ubifs_key *key, ino_t inum)
 {
 	key->u32[0] = inum;
 	key->u32[1] = UBIFS_TRUN_KEY << UBIFS_S_KEY_BLOCK_BITS;
@@ -334,8 +289,7 @@ static inline void trun_key_init(const s
  * @c: UBIFS file-system description object
  * @key: key to get type of
  */
-static inline int key_type(const struct ubifs_info *c,
-			   const union ubifs_key *key)
+static inline int key_type(const union ubifs_key *key)
 {
 	return key->u32[1] >> UBIFS_S_KEY_BLOCK_BITS;
 }
@@ -345,7 +299,7 @@ static inline int key_type(const struct 
  * @c: UBIFS file-system description object
  * @k: key to get type of
  */
-static inline int key_type_flash(const struct ubifs_info *c, const void *k)
+static inline int key_type_flash(const void *k)
 {
 	const union ubifs_key *key = k;
 
@@ -357,7 +311,7 @@ static inline int key_type_flash(const s
  * @c: UBIFS file-system description object
  * @k: key to fetch inode number from
  */
-static inline ino_t key_inum(const struct ubifs_info *c, const void *k)
+static inline ino_t key_inum(const void *k)
 {
 	const union ubifs_key *key = k;
 
@@ -369,7 +323,7 @@ static inline ino_t key_inum(const struc
  * @c: UBIFS file-system description object
  * @k: key to fetch inode number from
  */
-static inline ino_t key_inum_flash(const struct ubifs_info *c, const void *k)
+static inline ino_t key_inum_flash(const void *k)
 {
 	const union ubifs_key *key = k;
 
@@ -381,8 +335,7 @@ static inline ino_t key_inum_flash(const
  * @c: UBIFS file-system description object
  * @key: the key to get hash from
  */
-static inline uint32_t key_hash(const struct ubifs_info *c,
-				const union ubifs_key *key)
+static inline uint32_t key_hash(const union ubifs_key *key)
 {
 	return key->u32[1] & UBIFS_S_KEY_HASH_MASK;
 }
@@ -392,7 +345,7 @@ static inline uint32_t key_hash(const st
  * @c: UBIFS file-system description object
  * @k: the key to get hash from
  */
-static inline uint32_t key_hash_flash(const struct ubifs_info *c, const void *k)
+static inline uint32_t key_hash_flash(const void *k)
 {
 	const union ubifs_key *key = k;
 
@@ -404,8 +357,7 @@ static inline uint32_t key_hash_flash(co
  * @c: UBIFS file-system description object
  * @key: the key to get the block number from
  */
-static inline unsigned int key_block(const struct ubifs_info *c,
-				     const union ubifs_key *key)
+static inline unsigned int key_block(const union ubifs_key *key)
 {
 	return key->u32[1] & UBIFS_S_KEY_BLOCK_MASK;
 }
@@ -415,8 +367,7 @@ static inline unsigned int key_block(con
  * @c: UBIFS file-system description object
  * @k: the key to get the block number from
  */
-static inline unsigned int key_block_flash(const struct ubifs_info *c,
-					   const void *k)
+static inline unsigned int key_block_flash(const void *k)
 {
 	const union ubifs_key *key = k;
 
@@ -429,8 +380,7 @@ static inline unsigned int key_block_fla
  * @from: the key to transform
  * @to: the key to store the result
  */
-static inline void key_read(const struct ubifs_info *c, const void *from,
-			    union ubifs_key *to)
+static inline void key_read(const void *from, union ubifs_key *to)
 {
 	const union ubifs_key *f = from;
 
@@ -444,8 +394,7 @@ static inline void key_read(const struct
  * @from: the key to transform
  * @to: the key to store the result
  */
-static inline void key_write(const struct ubifs_info *c,
-			     const union ubifs_key *from, void *to)
+static inline void key_write(const union ubifs_key *from, void *to)
 {
 	union ubifs_key *t = to;
 
@@ -460,8 +409,7 @@ static inline void key_write(const struc
  * @from: the key to transform
  * @to: the key to store the result
  */
-static inline void key_write_idx(const struct ubifs_info *c,
-				 const union ubifs_key *from, void *to)
+static inline void key_write_idx(const union ubifs_key *from, void *to)
 {
 	union ubifs_key *t = to;
 
@@ -475,8 +423,8 @@ static inline void key_write_idx(const s
  * @from: the key to copy from
  * @to: the key to copy to
  */
-static inline void key_copy(const struct ubifs_info *c,
-			    const union ubifs_key *from, union ubifs_key *to)
+static inline void key_copy(const union ubifs_key *from,
+			    union ubifs_key *to)
 {
 	to->u64[0] = from->u64[0];
 }
@@ -490,8 +438,7 @@ static inline void key_copy(const struct
  * This function compares 2 keys and returns %-1 if @key1 is less than
  * @key2, %0 if the keys are equivalent and %1 if @key1 is greater than @key2.
  */
-static inline int keys_cmp(const struct ubifs_info *c,
-			   const union ubifs_key *key1,
+static inline int keys_cmp(const union ubifs_key *key1,
 			   const union ubifs_key *key2)
 {
 	if (key1->u32[0] < key2->u32[0])
@@ -515,8 +462,7 @@ static inline int keys_cmp(const struct 
  * This function compares 2 keys and returns %1 if @key1 is equal to @key2 and
  * %0 if not.
  */
-static inline int keys_eq(const struct ubifs_info *c,
-			  const union ubifs_key *key1,
+static inline int keys_eq(const union ubifs_key *key1,
 			  const union ubifs_key *key2)
 {
 	if (key1->u32[0] != key2->u32[0])
@@ -533,10 +479,9 @@ static inline int keys_eq(const struct u
  *
  * This function returns %1 if @key is a hashed key or %0 otherwise.
  */
-static inline int is_hash_key(const struct ubifs_info *c,
-			      const union ubifs_key *key)
+static inline int is_hash_key(const union ubifs_key *key)
 {
-	int type = key_type(c, key);
+	int type = key_type(key);
 
 	return type == UBIFS_DENT_KEY || type == UBIFS_XENT_KEY;
 }
diff -uprN a/fs/ubifs/lprops.c b/fs/ubifs/lprops.c
--- a/fs/ubifs/lprops.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/lprops.c	2009-07-17 11:25:47.000000000 +0530
@@ -59,7 +59,7 @@ static int get_heap_comp_val(struct ubif
  * is either the amount of free space or the amount of dirty space, depending
  * on the category.
  */
-static void move_up_lpt_heap(struct ubifs_info *c, struct ubifs_lpt_heap *heap,
+static void move_up_lpt_heap(struct ubifs_lpt_heap *heap,
 			     struct ubifs_lprops *lprops, int cat)
 {
 	int val1, val2, hpos;
@@ -96,7 +96,7 @@ static void move_up_lpt_heap(struct ubif
  * greater.  In the case of LPT's category heaps, the value is either the amount
  * of free space or the amount of dirty space, depending on the category.
  */
-static void adjust_lpt_heap(struct ubifs_info *c, struct ubifs_lpt_heap *heap,
+static void adjust_lpt_heap(struct ubifs_lpt_heap *heap,
 			    struct ubifs_lprops *lprops, int hpos, int cat)
 {
 	int val1, val2, val3, cpos;
@@ -202,7 +202,7 @@ static int add_to_lpt_heap(struct ubifs_
 			list_add(&lp->list, &c->uncat_list);
 			lprops->hpos = cpos;
 			heap->arr[cpos] = lprops;
-			move_up_lpt_heap(c, heap, lprops, cat);
+			move_up_lpt_heap(heap, lprops, cat);
 			dbg_check_heap(c, heap, cat, lprops->hpos);
 			return 1; /* Added to heap */
 		}
@@ -211,7 +211,7 @@ static int add_to_lpt_heap(struct ubifs_
 	} else {
 		lprops->hpos = heap->cnt++;
 		heap->arr[lprops->hpos] = lprops;
-		move_up_lpt_heap(c, heap, lprops, cat);
+		move_up_lpt_heap(heap, lprops, cat);
 		dbg_check_heap(c, heap, cat, lprops->hpos);
 		return 1; /* Added to heap */
 	}
@@ -236,7 +236,7 @@ static void remove_from_lpt_heap(struct 
 	if (hpos < heap->cnt) {
 		heap->arr[hpos] = heap->arr[heap->cnt];
 		heap->arr[hpos]->hpos = hpos;
-		adjust_lpt_heap(c, heap, heap->arr[hpos], hpos, cat);
+		adjust_lpt_heap(heap, heap->arr[hpos], hpos, cat);
 	}
 	dbg_check_heap(c, heap, cat, -1);
 }
@@ -453,7 +453,7 @@ static void change_category(struct ubifs
 		if (new_cat < 1 || new_cat > LPROPS_HEAP_CNT)
 			return; /* Not on a heap */
 		heap = &c->lpt_heap[new_cat - 1];
-		adjust_lpt_heap(c, heap, lprops, lprops->hpos, new_cat);
+		adjust_lpt_heap(heap, lprops, lprops->hpos, new_cat);
 	} else {
 		ubifs_remove_from_cat(c, lprops, old_cat);
 		ubifs_add_to_cat(c, lprops, new_cat);
@@ -1142,7 +1142,7 @@ static int scan_check_cb(struct ubifs_in
 		if (snod->type == UBIFS_IDX_NODE) {
 			struct ubifs_idx_node *idx = snod->node;
 
-			key_read(c, ubifs_idx_key(c, idx), &snod->key);
+			key_read(ubifs_idx_key(idx), &snod->key);
 			level = le16_to_cpu(idx->level);
 		}
 
diff -uprN a/fs/ubifs/misc.h b/fs/ubifs/misc.h
--- a/fs/ubifs/misc.h	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/misc.h	2009-07-17 10:59:45.000000000 +0530
@@ -277,8 +277,7 @@ struct ubifs_branch *ubifs_idx_branch(co
  * @c: the UBIFS file-system description object
  * @idx: index node
  */
-static inline void *ubifs_idx_key(const struct ubifs_info *c,
-				  const struct ubifs_idx_node *idx)
+static inline void *ubifs_idx_key(const struct ubifs_idx_node *idx)
 {
 	return (void *)((struct ubifs_branch *)idx->branches)->key;
 }
diff -uprN a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
--- a/fs/ubifs/orphan.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/orphan.c	2009-07-17 11:01:12.000000000 +0530
@@ -839,12 +839,12 @@ static int dbg_orphan_check(struct ubifs
 	ino_t inum;
 	int err;
 
-	inum = key_inum(c, &zbr->key);
+	inum = key_inum(&zbr->key);
 	if (inum != ci->last_ino) {
 		/* Lowest node type is the inode node, so it comes first */
-		if (key_type(c, &zbr->key) != UBIFS_INO_KEY)
+		if (key_type(&zbr->key) != UBIFS_INO_KEY)
 			ubifs_err("found orphan node ino %lu, type %d",
-				  (unsigned long)inum, key_type(c, &zbr->key));
+				  (unsigned long)inum, key_type(&zbr->key));
 		ci->last_ino = inum;
 		ci->tot_inos += 1;
 		err = ubifs_tnc_read_node(c, zbr, ci->node);
diff -uprN a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
--- a/fs/ubifs/recovery.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/recovery.c	2009-07-17 11:28:51.000000000 +0530
@@ -597,7 +597,7 @@ struct ubifs_scan_leb *ubifs_recover_leb
 			struct ubifs_ch *ch = buf;
 			int node_len;
 
-			err = ubifs_add_snod(c, sleb, buf, offs);
+			err = ubifs_add_snod(sleb, buf, offs);
 			if (err)
 				goto error;
 			node_len = ALIGN(le32_to_cpu(ch->len), 8);
@@ -1311,11 +1311,11 @@ void ubifs_destroy_size_tree(struct ubif
 int ubifs_recover_size_accum(struct ubifs_info *c, union ubifs_key *key,
 			     int deletion, loff_t new_size)
 {
-	ino_t inum = key_inum(c, key);
+	ino_t inum = key_inum(key);
 	struct size_entry *e;
 	int err;
 
-	switch (key_type(c, key)) {
+	switch (key_type(key)) {
 	case UBIFS_INO_KEY:
 		if (deletion)
 			remove_ino(c, inum);
@@ -1366,7 +1366,7 @@ static int fix_size_in_place(struct ubif
 	uint32_t crc;
 
 	/* Locate the inode node LEB number and offset */
-	ino_key_init(c, &key, e->inum);
+	ino_key_init(&key, e->inum);
 	err = ubifs_tnc_locate(c, &key, ino, &lnum, &offs);
 	if (err)
 		goto out;
@@ -1428,7 +1428,7 @@ int ubifs_recover_size(struct ubifs_info
 		if (!e->exists) {
 			union ubifs_key key;
 
-			ino_key_init(c, &key, e->inum);
+			ino_key_init(&key, e->inum);
 			err = ubifs_tnc_lookup(c, &key, c->sbuf);
 			if (err && err != -ENOENT)
 				return err;
diff -uprN a/fs/ubifs/replay.c b/fs/ubifs/replay.c
--- a/fs/ubifs/replay.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/replay.c	2009-07-17 11:27:16.000000000 +0530
@@ -183,10 +183,10 @@ static int trun_remove_range(struct ubif
 	if ((r->old_size & (UBIFS_BLOCK_SIZE - 1)) == 0)
 		max_blk -= 1;
 
-	ino = key_inum(c, &r->key);
+	ino = key_inum(&r->key);
 
-	data_key_init(c, &min_key, ino, min_blk);
-	data_key_init(c, &max_key, ino, max_blk);
+	data_key_init(&min_key, ino, min_blk);
+	data_key_init(&max_key, ino, max_blk);
 
 	return ubifs_tnc_remove_range(c, &min_key, &max_key);
 }
@@ -210,7 +210,7 @@ static int apply_replay_entry(struct ubi
 
 	if (r->flags & REPLAY_REF)
 		err = set_bud_lprops(c, r);
-	else if (is_hash_key(c, &r->key)) {
+	else if (is_hash_key(&r->key)) {
 		if (deletion)
 			err = ubifs_tnc_remove_nm(c, &r->key, &r->nm);
 		else
@@ -218,10 +218,10 @@ static int apply_replay_entry(struct ubi
 					       r->len, &r->nm);
 	} else {
 		if (deletion)
-			switch (key_type(c, &r->key)) {
+			switch (key_type(&r->key)) {
 			case UBIFS_INO_KEY:
 			{
-				ino_t inum = key_inum(c, &r->key);
+				ino_t inum = key_inum(&r->key);
 
 				err = ubifs_tnc_remove_ino(c, inum);
 				break;
@@ -274,7 +274,7 @@ static void destroy_replay_tree(struct u
 			else
 				this->rb_right = NULL;
 		}
-		if (is_hash_key(c, &r->key))
+		if (is_hash_key(&r->key))
 			kfree(r->nm.name);
 		kfree(r);
 	}
@@ -336,8 +336,8 @@ static int insert_node(struct ubifs_info
 	struct rb_node **p = &c->replay_tree.rb_node, *parent = NULL;
 	struct replay_entry *r;
 
-	if (key_inum(c, key) >= c->highest_inum)
-		c->highest_inum = key_inum(c, key);
+	if (key_inum(key) >= c->highest_inum)
+		c->highest_inum = key_inum(key);
 
 	dbg_mnt("add LEB %d:%d, key %s", lnum, offs, DBGKEY(key));
 	while (*p) {
@@ -367,7 +367,7 @@ static int insert_node(struct ubifs_info
 	r->flags = (deletion ? REPLAY_DELETION : 0);
 	r->old_size = old_size;
 	r->new_size = new_size;
-	key_copy(c, key, &r->key);
+	key_copy(key, &r->key);
 
 	rb_link_node(&r->rb, parent, p);
 	rb_insert_color(&r->rb, &c->replay_tree);
@@ -402,8 +402,8 @@ static int insert_dent(struct ubifs_info
 	struct replay_entry *r;
 	char *nbuf;
 
-	if (key_inum(c, key) >= c->highest_inum)
-		c->highest_inum = key_inum(c, key);
+	if (key_inum(key) >= c->highest_inum)
+		c->highest_inum = key_inum(key);
 
 	dbg_mnt("add LEB %d:%d, key %s", lnum, offs, DBGKEY(key));
 	while (*p) {
@@ -441,7 +441,7 @@ static int insert_dent(struct ubifs_info
 	nbuf[nlen] = '\0';
 	r->nm.name = nbuf;
 	r->flags = (deletion ? REPLAY_DELETION : 0);
-	key_copy(c, key, &r->key);
+	key_copy(key, &r->key);
 
 	ubifs_assert(!*p);
 	rb_link_node(&r->rb, parent, p);
@@ -457,10 +457,9 @@ static int insert_dent(struct ubifs_info
  * This function validates directory or extended attribute entry node @dent.
  * Returns zero if the node is all right and a %-EINVAL if not.
  */
-int ubifs_validate_entry(struct ubifs_info *c,
-			 const struct ubifs_dent_node *dent)
+int ubifs_validate_entry(const struct ubifs_dent_node *dent)
 {
-	int key_type = key_type_flash(c, dent->key);
+	int key_type = key_type_flash(dent->key);
 	int nlen = le16_to_cpu(dent->nlen);
 
 	if (le32_to_cpu(dent->ch.len) != nlen + UBIFS_DENT_NODE_SZ + 1 ||
@@ -562,7 +561,7 @@ static int replay_bud(struct ubifs_info 
 		{
 			struct ubifs_data_node *dn = snod->node;
 			loff_t new_size = le32_to_cpu(dn->size) +
-					  key_block(c, &snod->key) *
+					  key_block(&snod->key) *
 					  UBIFS_BLOCK_SIZE;
 
 			err = insert_node(c, lnum, snod->offs, snod->len,
@@ -575,7 +574,7 @@ static int replay_bud(struct ubifs_info 
 		{
 			struct ubifs_dent_node *dent = snod->node;
 
-			err = ubifs_validate_entry(c, dent);
+			err = ubifs_validate_entry(dent);
 			if (err)
 				goto out_dump;
 
@@ -604,7 +603,7 @@ static int replay_bud(struct ubifs_info 
 			 * Create a fake truncation key just to use the same
 			 * functions which expect nodes to have keys.
 			 */
-			trun_key_init(c, &key, le32_to_cpu(trun->inum));
+			trun_key_init(&key, le32_to_cpu(trun->inum));
 			err = insert_node(c, lnum, snod->offs, snod->len,
 					  &key, snod->sqnum, 1, &used,
 					  old_size, new_size);
diff -uprN a/fs/ubifs/sb.c b/fs/ubifs/sb.c
--- a/fs/ubifs/sb.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/sb.c	2009-07-17 11:06:32.000000000 +0530
@@ -276,9 +276,9 @@ static int create_default_filesystem(str
 
 	idx->ch.node_type = UBIFS_IDX_NODE;
 	idx->child_cnt = cpu_to_le16(1);
-	ino_key_init(c, &key, UBIFS_ROOT_INO);
+	ino_key_init(&key, UBIFS_ROOT_INO);
 	br = ubifs_idx_branch(c, idx, 0);
-	key_write_idx(c, &key, &br->key);
+	key_write_idx(&key, &br->key);
 	br->lnum = cpu_to_le32(main_first + DEFAULT_DATA_LEB);
 	br->len  = cpu_to_le32(UBIFS_INO_NODE_SZ);
 	err = ubifs_write_node(c, idx, tmp, main_first + DEFAULT_IDX_LEB, 0,
@@ -296,7 +296,7 @@ static int create_default_filesystem(str
 	if (!ino)
 		return -ENOMEM;
 
-	ino_key_init_flash(c, &ino->key, UBIFS_ROOT_INO);
+	ino_key_init_flash(&ino->key, UBIFS_ROOT_INO);
 	ino->ch.node_type = UBIFS_INO_NODE;
 	ino->creat_sqnum = cpu_to_le64(++c->max_sqnum);
 	ino->nlink = cpu_to_le32(2);
diff -uprN a/fs/ubifs/scan.c b/fs/ubifs/scan.c
--- a/fs/ubifs/scan.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/scan.c	2009-07-17 11:32:19.000000000 +0530
@@ -191,8 +191,7 @@ void ubifs_end_scan(const struct ubifs_i
  *
  * This function returns %0 on success and a negative error code on failure.
  */
-int ubifs_add_snod(const struct ubifs_info *c, struct ubifs_scan_leb *sleb,
-		   void *buf, int offs)
+int ubifs_add_snod(struct ubifs_scan_leb *sleb, void *buf, int offs)
 {
 	struct ubifs_ch *ch = buf;
 	struct ubifs_ino_node *ino = buf;
@@ -218,7 +217,7 @@ int ubifs_add_snod(const struct ubifs_in
 		 * The key is in the same place in all keyed
 		 * nodes.
 		 */
-		key_read(c, &ino->key, &snod->key);
+		key_read(&ino->key, &snod->key);
 		break;
 	}
 	list_add_tail(&snod->list, &sleb->nodes);
@@ -309,7 +308,7 @@ struct ubifs_scan_leb *ubifs_scan(const 
 			goto error;
 		}
 
-		err = ubifs_add_snod(c, sleb, buf, offs);
+		err = ubifs_add_snod(sleb, buf, offs);
 		if (err)
 			goto error;
 
diff -uprN a/fs/ubifs/super.c b/fs/ubifs/super.c
--- a/fs/ubifs/super.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/super.c	2009-07-17 11:10:38.000000000 +0530
@@ -123,7 +123,7 @@ struct inode *ubifs_iget(struct super_bl
 		goto out;
 	}
 
-	ino_key_init(c, &key, inode->i_ino);
+	ino_key_init(&key, inode->i_ino);
 
 	err = ubifs_tnc_lookup(c, &key, ino);
 	if (err)
diff -uprN a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
--- a/fs/ubifs/tnc.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/tnc.c	2009-07-17 11:31:14.000000000 +0530
@@ -334,9 +334,9 @@ static int lnc_add(struct ubifs_info *c,
 
 	ubifs_assert(!zbr->leaf);
 	ubifs_assert(zbr->len != 0);
-	ubifs_assert(is_hash_key(c, &zbr->key));
+	ubifs_assert(is_hash_key(&zbr->key));
 
-	err = ubifs_validate_entry(c, dent);
+	err = ubifs_validate_entry(dent);
 	if (err) {
 		dbg_dump_stack();
 		dbg_dump_node(c, dent);
@@ -370,7 +370,7 @@ static int lnc_add_directly(struct ubifs
 	ubifs_assert(!zbr->leaf);
 	ubifs_assert(zbr->len != 0);
 
-	err = ubifs_validate_entry(c, node);
+	err = ubifs_validate_entry(node);
 	if (err) {
 		dbg_dump_stack();
 		dbg_dump_node(c, node);
@@ -410,7 +410,7 @@ static int tnc_read_node_nm(struct ubifs
 {
 	int err;
 
-	ubifs_assert(is_hash_key(c, &zbr->key));
+	ubifs_assert(is_hash_key(&zbr->key));
 
 	if (zbr->leaf) {
 		/* Read from the leaf node cache */
@@ -503,15 +503,15 @@ static int fallible_read_node(struct ubi
 
 	dbg_tnc("LEB %d:%d, key %s", zbr->lnum, zbr->offs, DBGKEY(key));
 
-	ret = try_read_node(c, node, key_type(c, key), zbr->len, zbr->lnum,
+	ret = try_read_node(c, node, key_type(key), zbr->len, zbr->lnum,
 			    zbr->offs);
 	if (ret == 1) {
 		union ubifs_key node_key;
 		struct ubifs_dent_node *dent = node;
 
 		/* All nodes have key in the same place */
-		key_read(c, &dent->key, &node_key);
-		if (keys_cmp(c, key, &node_key) != 0)
+		key_read(&dent->key, &node_key);
+		if (keys_cmp(key, &node_key) != 0)
 			ret = 0;
 	}
 	if (ret == 0 && c->replaying)
@@ -723,7 +723,7 @@ static int resolve_collision(struct ubif
 			}
 			if (err < 0)
 				return err;
-			if (keys_cmp(c, &(*zn)->zbranch[*n].key, key)) {
+			if (keys_cmp(&(*zn)->zbranch[*n].key, key)) {
 				/*
 				 * We have found the branch after which we would
 				 * like to insert, but inserting in this znode
@@ -787,7 +787,7 @@ static int resolve_collision(struct ubif
 				return 0;
 			if (err < 0)
 				return err;
-			if (keys_cmp(c, &znode->zbranch[nn].key, key))
+			if (keys_cmp(&znode->zbranch[nn].key, key))
 				return 0;
 			err = matches_name(c, &znode->zbranch[nn], nm);
 			if (err < 0)
@@ -924,7 +924,7 @@ static int fallible_resolve_collision(st
 			}
 			if (err < 0)
 				return err;
-			if (keys_cmp(c, &(*zn)->zbranch[*n].key, key)) {
+			if (keys_cmp(&(*zn)->zbranch[*n].key, key)) {
 				/* See comments in 'resolve_collision()' */
 				if (*n == (*zn)->child_cnt - 1) {
 					err = tnc_next(c, zn, n);
@@ -969,7 +969,7 @@ static int fallible_resolve_collision(st
 				break;
 			if (err < 0)
 				return err;
-			if (keys_cmp(c, &znode->zbranch[nn].key, key))
+			if (keys_cmp(&znode->zbranch[nn].key, key))
 				break;
 			err = fallible_matches_name(c, &znode->zbranch[nn], nm);
 			if (err < 0)
@@ -1052,7 +1052,7 @@ static int resolve_collision_directly(st
 			break;
 		if (err < 0)
 			return err;
-		if (keys_cmp(c, &znode->zbranch[nn].key, key))
+		if (keys_cmp(&znode->zbranch[nn].key, key))
 			break;
 		if (matches_position(&znode->zbranch[nn], lnum, offs)) {
 			*zn = znode;
@@ -1070,7 +1070,7 @@ static int resolve_collision_directly(st
 			return 0;
 		if (err < 0)
 			return err;
-		if (keys_cmp(c, &znode->zbranch[nn].key, key))
+		if (keys_cmp(&znode->zbranch[nn].key, key))
 			return 0;
 		*zn = znode;
 		*n = nn;
@@ -1189,7 +1189,7 @@ int ubifs_lookup_level0(struct ubifs_inf
 	while (1) {
 		struct ubifs_zbranch *zbr;
 
-		exact = ubifs_search_zbranch(c, znode, key, n);
+		exact = ubifs_search_zbranch(znode, key, n);
 
 		if (znode->level == 0)
 			break;
@@ -1211,7 +1211,7 @@ int ubifs_lookup_level0(struct ubifs_inf
 	}
 
 	*zn = znode;
-	if (exact || !is_hash_key(c, key) || *n != -1) {
+	if (exact || !is_hash_key(key) || *n != -1) {
 		dbg_tnc("found %d, lvl %d, n %d", exact, znode->level, *n);
 		return exact;
 	}
@@ -1267,7 +1267,7 @@ int ubifs_lookup_level0(struct ubifs_inf
 	}
 	if (unlikely(err < 0))
 		return err;
-	if (keys_cmp(c, key, &znode->zbranch[*n].key)) {
+	if (keys_cmp(key, &znode->zbranch[*n].key)) {
 		dbg_tnc("found 0, lvl %d, n -1", znode->level);
 		*n = -1;
 		return 0;
@@ -1328,7 +1328,7 @@ static int lookup_level0_dirty(struct ub
 	while (1) {
 		struct ubifs_zbranch *zbr;
 
-		exact = ubifs_search_zbranch(c, znode, key, n);
+		exact = ubifs_search_zbranch(znode, key, n);
 
 		if (znode->level == 0)
 			break;
@@ -1355,7 +1355,7 @@ static int lookup_level0_dirty(struct ub
 	}
 
 	*zn = znode;
-	if (exact || !is_hash_key(c, key) || *n != -1) {
+	if (exact || !is_hash_key(key) || *n != -1) {
 		dbg_tnc("found %d, lvl %d, n %d", exact, znode->level, *n);
 		return exact;
 	}
@@ -1372,7 +1372,7 @@ static int lookup_level0_dirty(struct ub
 	}
 	if (unlikely(err < 0))
 		return err;
-	if (keys_cmp(c, key, &znode->zbranch[*n].key)) {
+	if (keys_cmp(key, &znode->zbranch[*n].key)) {
 		*n = -1;
 		dbg_tnc("found 0, lvl %d, n -1", znode->level);
 		return 0;
@@ -1460,7 +1460,7 @@ again:
 		*lnum = zt->lnum;
 		*offs = zt->offs;
 	}
-	if (is_hash_key(c, key)) {
+	if (is_hash_key(key)) {
 		/*
 		 * In this case the leaf node cache gets used, so we pass the
 		 * address of the zbranch and keep the mutex locked
@@ -1516,7 +1516,7 @@ int ubifs_tnc_get_bu_keys(struct ubifs_i
 {
 	int n, err = 0, lnum = -1, uninitialized_var(offs);
 	int uninitialized_var(len);
-	unsigned int block = key_block(c, &bu->key);
+	unsigned int block = key_block(&bu->key);
 	struct ubifs_znode *znode;
 
 	bu->cnt = 0;
@@ -1554,8 +1554,8 @@ int ubifs_tnc_get_bu_keys(struct ubifs_i
 		zbr = &znode->zbranch[n];
 		key = &zbr->key;
 		/* See if there is another data key for this file */
-		if (key_inum(c, key) != key_inum(c, &bu->key) ||
-		    key_type(c, key) != UBIFS_DATA_KEY) {
+		if (key_inum(key) != key_inum(&bu->key) ||
+		    key_type(key) != UBIFS_DATA_KEY) {
 			err = -ENOENT;
 			goto out;
 		}
@@ -1582,7 +1582,7 @@ int ubifs_tnc_get_bu_keys(struct ubifs_i
 				goto out;
 		}
 		/* Allow for holes */
-		next_block = key_block(c, key);
+		next_block = key_block(key);
 		bu->blk_cnt += (next_block - block - 1);
 		if (bu->blk_cnt >= UBIFS_MAX_BULK_READ)
 			goto out;
@@ -1624,10 +1624,10 @@ out:
 		return 0;
 	}
 	/* Exclude data nodes that do not make up a whole page cache page */
-	block = key_block(c, &bu->key) + bu->blk_cnt;
+	block = key_block(&bu->key) + bu->blk_cnt;
 	block &= ~(UBIFS_BLOCKS_PER_PAGE - 1);
 	while (bu->cnt) {
-		if (key_block(c, &bu->zbranch[bu->cnt - 1].key) < block)
+		if (key_block(&bu->zbranch[bu->cnt - 1].key) < block)
 			break;
 		bu->cnt -= 1;
 	}
@@ -1713,8 +1713,8 @@ static int validate_data_node(struct ubi
 	}
 
 	/* Make sure the key of the read node is correct */
-	key_read(c, buf + UBIFS_KEY_OFFSET, &key1);
-	if (!keys_eq(c, &zbr->key, &key1)) {
+	key_read(buf + UBIFS_KEY_OFFSET, &key1);
+	if (!keys_eq(&zbr->key, &key1)) {
 		ubifs_err("bad key in node at LEB %d:%d",
 			  zbr->lnum, zbr->offs);
 		dbg_tnc("looked for key %s found node's key %s",
@@ -1882,8 +1882,7 @@ int ubifs_tnc_lookup_nm(struct ubifs_inf
  * zbranch changes, keys of parent znodes have to be corrected. This helper
  * function is called in such situations and corrects the keys if needed.
  */
-static void correct_parent_keys(const struct ubifs_info *c,
-				struct ubifs_znode *znode)
+static void correct_parent_keys(struct ubifs_znode *znode)
 {
 	union ubifs_key *key, *key1;
 
@@ -1893,8 +1892,8 @@ static void correct_parent_keys(const st
 	key = &znode->zbranch[0].key;
 	key1 = &znode->parent->zbranch[0].key;
 
-	while (keys_cmp(c, key, key1) < 0) {
-		key_copy(c, key, key1);
+	while (keys_cmp(key, key1) < 0) {
+		key_copy(key, key1);
 		znode = znode->parent;
 		znode->alt = 1;
 		if (!znode->parent || znode->iip)
@@ -1987,7 +1986,7 @@ again:
 
 		/* Ensure parent's key is correct */
 		if (n == 0 && zp && znode->iip == 0)
-			correct_parent_keys(c, znode);
+			correct_parent_keys(znode);
 
 		return 0;
 	}
@@ -2012,12 +2011,12 @@ again:
 	zn->level = znode->level;
 
 	/* Decide where to split */
-	if (znode->level == 0 && key_type(c, key) == UBIFS_DATA_KEY) {
+	if (znode->level == 0 && key_type(key) == UBIFS_DATA_KEY) {
 		/* Try not to split consecutive data keys */
 		if (n == c->fanout) {
 			key1 = &znode->zbranch[n - 1].key;
-			if (key_inum(c, key1) == key_inum(c, key) &&
-			    key_type(c, key1) == UBIFS_DATA_KEY)
+			if (key_inum(key1) == key_inum(key) &&
+			    key_type(key1) == UBIFS_DATA_KEY)
 				appending = 1;
 		} else
 			goto check_split;
@@ -2027,11 +2026,11 @@ again:
 check_split:
 		if (n >= (c->fanout + 1) / 2) {
 			key1 = &znode->zbranch[0].key;
-			if (key_inum(c, key1) == key_inum(c, key) &&
-			    key_type(c, key1) == UBIFS_DATA_KEY) {
+			if (key_inum(key1) == key_inum(key) &&
+			    key_type(key1) == UBIFS_DATA_KEY) {
 				key1 = &znode->zbranch[n].key;
-				if (key_inum(c, key1) != key_inum(c, key) ||
-				    key_type(c, key1) != UBIFS_DATA_KEY) {
+				if (key_inum(key1) != key_inum(key) ||
+				    key_type(key1) != UBIFS_DATA_KEY) {
 					keep = n;
 					move = c->fanout - keep;
 					zi = znode;
@@ -2097,7 +2096,7 @@ do_split:
 	/* Insert new znode (produced by spitting) into the parent */
 	if (zp) {
 		if (n == 0 && zi == znode && znode->iip == 0)
-			correct_parent_keys(c, znode);
+			correct_parent_keys(znode);
 
 		/* Locate insertion point */
 		n = znode->iip + 1;
@@ -2175,7 +2174,7 @@ int ubifs_tnc_add(struct ubifs_info *c, 
 		zbr.lnum = lnum;
 		zbr.offs = offs;
 		zbr.len = len;
-		key_copy(c, key, &zbr.key);
+		key_copy(key, &zbr.key);
 		err = tnc_insert(c, znode, &zbr, n + 1);
 	} else if (found == 1) {
 		struct ubifs_zbranch *zbr = &znode->zbranch[n];
@@ -2236,7 +2235,7 @@ int ubifs_tnc_replace(struct ubifs_info 
 			zbr->offs = offs;
 			zbr->len = len;
 			found = 1;
-		} else if (is_hash_key(c, key)) {
+		} else if (is_hash_key(key)) {
 			found = resolve_collision_directly(c, key, &znode, &n,
 							   old_lnum, old_offs);
 			dbg_tnc("rc returned %d, znode %p, n %d, LEB %d:%d",
@@ -2346,7 +2345,7 @@ int ubifs_tnc_add_nm(struct ubifs_info *
 		zbr.lnum = lnum;
 		zbr.offs = offs;
 		zbr.len = len;
-		key_copy(c, key, &zbr.key);
+		key_copy(key, &zbr.key);
 		err = tnc_insert(c, znode, &zbr, n + 1);
 		if (err)
 			goto out_unlock;
@@ -2580,9 +2579,9 @@ out_unlock:
 static int key_in_range(struct ubifs_info *c, union ubifs_key *key,
 			union ubifs_key *from_key, union ubifs_key *to_key)
 {
-	if (keys_cmp(c, key, from_key) < 0)
+	if (keys_cmp(key, from_key) < 0)
 		return 0;
-	if (keys_cmp(c, key, to_key) > 0)
+	if (keys_cmp(key, to_key) > 0)
 		return 0;
 	return 1;
 }
@@ -2691,7 +2690,7 @@ int ubifs_tnc_remove_ino(struct ubifs_in
 	 * Walk all extended attribute entries and remove them together with
 	 * corresponding extended attribute inodes.
 	 */
-	lowest_xent_key(c, &key1, inum);
+	lowest_xent_key(&key1, inum);
 	while (1) {
 		ino_t xattr_inum;
 		int err;
@@ -2716,8 +2715,8 @@ int ubifs_tnc_remove_ino(struct ubifs_in
 			return err;
 		}
 
-		lowest_ino_key(c, &key1, xattr_inum);
-		highest_ino_key(c, &key2, xattr_inum);
+		lowest_ino_key(&key1, xattr_inum);
+		highest_ino_key(&key2, xattr_inum);
 		err = ubifs_tnc_remove_range(c, &key1, &key2);
 		if (err) {
 			kfree(xent);
@@ -2726,12 +2725,12 @@ int ubifs_tnc_remove_ino(struct ubifs_in
 
 		kfree(pxent);
 		pxent = xent;
-		key_read(c, &xent->key, &key1);
+		key_read(&xent->key, &key1);
 	}
 
 	kfree(pxent);
-	lowest_ino_key(c, &key1, inum);
-	highest_ino_key(c, &key2, inum);
+	lowest_ino_key(&key1, inum);
+	highest_ino_key(&key2, inum);
 
 	return ubifs_tnc_remove_range(c, &key1, &key2);
 }
@@ -2763,14 +2762,14 @@ struct ubifs_dent_node *ubifs_tnc_next_e
 					   union ubifs_key *key,
 					   const struct qstr *nm)
 {
-	int n, err, type = key_type(c, key);
+	int n, err, type = key_type(key);
 	struct ubifs_znode *znode;
 	struct ubifs_dent_node *dent;
 	struct ubifs_zbranch *zbr;
 	union ubifs_key *dkey;
 
 	dbg_tnc("%s %s", nm->name ? (char *)nm->name : "(lowest)", DBGKEY(key));
-	ubifs_assert(is_hash_key(c, key));
+	ubifs_assert(is_hash_key(key));
 
 	mutex_lock(&c->tnc_mutex);
 	err = ubifs_lookup_level0(c, key, &znode, &n);
@@ -2821,8 +2820,8 @@ struct ubifs_dent_node *ubifs_tnc_next_e
 	 * this.
 	 */
 	dkey = &zbr->key;
-	if (key_inum(c, dkey) != key_inum(c, key) ||
-	    key_type(c, dkey) != type) {
+	if (key_inum(dkey) != key_inum(key) ||
+	    key_type(dkey) != type) {
 		err = -ENOENT;
 		goto out_free;
 	}
@@ -3008,7 +3007,7 @@ static struct ubifs_znode *lookup_znode(
 	if (level >= znode->level)
 		return NULL;
 	while (1) {
-		ubifs_search_zbranch(c, znode, key, &n);
+		ubifs_search_zbranch(znode, key, &n);
 		if (n < 0) {
 			/*
 			 * We reached a znode where the leftmost key is greater
@@ -3023,7 +3022,7 @@ static struct ubifs_znode *lookup_znode(
 				return NULL;
 			if (IS_ERR(znode))
 				return znode;
-			ubifs_search_zbranch(c, znode, key, &n);
+			ubifs_search_zbranch(znode, key, &n);
 			ubifs_assert(n >= 0);
 		}
 		if (znode->level == level + 1)
@@ -3036,7 +3035,7 @@ static struct ubifs_znode *lookup_znode(
 	if (znode->zbranch[n].lnum == lnum && znode->zbranch[n].offs == offs)
 		return get_znode(c, znode, n);
 	/* If the key is unique, there is nowhere else to look */
-	if (!is_hash_key(c, key))
+	if (!is_hash_key(key))
 		return NULL;
 	/*
 	 * The key is not unique and so may be also in the znodes to either
@@ -3062,7 +3061,7 @@ static struct ubifs_znode *lookup_znode(
 		    znode->zbranch[n].offs == offs)
 			return get_znode(c, znode, n);
 		/* Stop if the key is less than the one we are looking for */
-		if (keys_cmp(c, &znode->zbranch[n].key, key) < 0)
+		if (keys_cmp(&znode->zbranch[n].key, key) < 0)
 			break;
 	}
 	/* Back to the middle */
@@ -3084,7 +3083,7 @@ static struct ubifs_znode *lookup_znode(
 		    znode->zbranch[n].offs == offs)
 			return get_znode(c, znode, n);
 		/* Stop if the key is greater than the one we are looking for */
-		if (keys_cmp(c, &znode->zbranch[n].key, key) > 0)
+		if (keys_cmp(&znode->zbranch[n].key, key) > 0)
 			break;
 	}
 	return NULL;
@@ -3140,7 +3139,7 @@ static int is_leaf_node_in_tnc(struct ub
 	struct ubifs_zbranch *zbr;
 	struct ubifs_znode *znode, *zn;
 	int n, found, err, nn;
-	const int unique = !is_hash_key(c, key);
+	const int unique = !is_hash_key(key);
 
 	found = ubifs_lookup_level0(c, key, &znode, &n);
 	if (found < 0)
@@ -3165,7 +3164,7 @@ static int is_leaf_node_in_tnc(struct ub
 			break;
 		if (err)
 			return err;
-		if (keys_cmp(c, key, &znode->zbranch[n].key))
+		if (keys_cmp(key, &znode->zbranch[n].key))
 			break;
 		zbr = &znode->zbranch[n];
 		if (lnum == zbr->lnum && offs == zbr->offs)
@@ -3181,7 +3180,7 @@ static int is_leaf_node_in_tnc(struct ub
 				return 0;
 			return err;
 		}
-		if (keys_cmp(c, key, &znode->zbranch[n].key))
+		if (keys_cmp(key, &znode->zbranch[n].key))
 			break;
 		zbr = &znode->zbranch[n];
 		if (lnum == zbr->lnum && offs == zbr->offs)
diff -uprN a/fs/ubifs/tnc_commit.c b/fs/ubifs/tnc_commit.c
--- a/fs/ubifs/tnc_commit.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/tnc_commit.c	2009-07-17 11:26:10.000000000 +0530
@@ -47,7 +47,7 @@ static int make_idx_node(struct ubifs_in
 		struct ubifs_branch *br = ubifs_idx_branch(c, idx, i);
 		struct ubifs_zbranch *zbr = &znode->zbranch[i];
 
-		key_write_idx(c, &zbr->key, &br->key);
+		key_write_idx(&zbr->key, &br->key);
 		br->lnum = cpu_to_le32(zbr->lnum);
 		br->offs = cpu_to_le32(zbr->offs);
 		br->len = cpu_to_le32(zbr->len);
@@ -256,7 +256,7 @@ static int layout_leb_in_gaps(struct ubi
 
 		ubifs_assert(snod->type == UBIFS_IDX_NODE);
 		idx = snod->node;
-		key_read(c, ubifs_idx_key(c, idx), &snod->key);
+		key_read(ubifs_idx_key(idx), &snod->key);
 		level = le16_to_cpu(idx->level);
 		/* Determine if the index node is in use (not obsolete) */
 		in_use = is_idx_node_in_use(c, &snod->key, level, lnum,
@@ -874,7 +874,7 @@ static int write_index(struct ubifs_info
 			struct ubifs_branch *br = ubifs_idx_branch(c, idx, i);
 			struct ubifs_zbranch *zbr = &znode->zbranch[i];
 
-			key_write_idx(c, &zbr->key, &br->key);
+			key_write_idx(&zbr->key, &br->key);
 			br->lnum = cpu_to_le32(zbr->lnum);
 			br->offs = cpu_to_le32(zbr->offs);
 			br->len = cpu_to_le32(zbr->len);
diff -uprN a/fs/ubifs/tnc_misc.c b/fs/ubifs/tnc_misc.c
--- a/fs/ubifs/tnc_misc.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/tnc_misc.c	2009-07-17 11:18:32.000000000 +0530
@@ -132,8 +132,7 @@ struct ubifs_znode *ubifs_tnc_levelorder
  *     closest branch is returned in @n; the slot if all keys in this znode are
  *     greater than @key, then %-1 is returned in @n.
  */
-int ubifs_search_zbranch(const struct ubifs_info *c,
-			 const struct ubifs_znode *znode,
+int ubifs_search_zbranch(const struct ubifs_znode *znode,
 			 const union ubifs_key *key, int *n)
 {
 	int beg = 0, end = znode->child_cnt, uninitialized_var(mid);
@@ -144,7 +143,7 @@ int ubifs_search_zbranch(const struct ub
 
 	while (end > beg) {
 		mid = (beg + end) >> 1;
-		cmp = keys_cmp(c, key, &zbr[mid].key);
+		cmp = keys_cmp(key, &zbr[mid].key);
 		if (cmp > 0)
 			beg = mid + 1;
 		else if (cmp < 0)
@@ -160,11 +159,11 @@ int ubifs_search_zbranch(const struct ub
 	/* The insert point is after *n */
 	ubifs_assert(*n >= -1 && *n < znode->child_cnt);
 	if (*n == -1)
-		ubifs_assert(keys_cmp(c, key, &zbr[0].key) < 0);
+		ubifs_assert(keys_cmp(key, &zbr[0].key) < 0);
 	else
-		ubifs_assert(keys_cmp(c, key, &zbr[*n].key) > 0);
+		ubifs_assert(keys_cmp(key, &zbr[*n].key) > 0);
 	if (*n + 1 < znode->child_cnt)
-		ubifs_assert(keys_cmp(c, key, &zbr[*n + 1].key) < 0);
+		ubifs_assert(keys_cmp(key, &zbr[*n + 1].key) < 0);
 
 	return 0;
 }
@@ -305,7 +304,7 @@ static int read_znode(struct ubifs_info 
 		const struct ubifs_branch *br = ubifs_idx_branch(c, idx, i);
 		struct ubifs_zbranch *zbr = &znode->zbranch[i];
 
-		key_read(c, &br->key, &zbr->key);
+		key_read(&br->key, &zbr->key);
 		zbr->lnum = le32_to_cpu(br->lnum);
 		zbr->offs = le32_to_cpu(br->offs);
 		zbr->len  = le32_to_cpu(br->len);
@@ -321,7 +320,7 @@ static int read_znode(struct ubifs_info 
 			goto out_dump;
 		}
 
-		switch (key_type(c, &zbr->key)) {
+		switch (key_type(&zbr->key)) {
 		case UBIFS_INO_KEY:
 		case UBIFS_DATA_KEY:
 		case UBIFS_DENT_KEY:
@@ -337,7 +336,7 @@ static int read_znode(struct ubifs_info 
 		if (znode->level)
 			continue;
 
-		type = key_type(c, &zbr->key);
+		type = key_type(&zbr->key);
 		if (c->ranges[type].max_len == 0) {
 			if (zbr->len != c->ranges[type].len) {
 				dbg_err("bad target node (type %d) length (%d)",
@@ -368,12 +367,12 @@ static int read_znode(struct ubifs_info 
 		key1 = &znode->zbranch[i].key;
 		key2 = &znode->zbranch[i + 1].key;
 
-		cmp = keys_cmp(c, key1, key2);
+		cmp = keys_cmp(key1, key2);
 		if (cmp > 0) {
 			dbg_err("bad key order (keys %d and %d)", i, i + 1);
 			err = 6;
 			goto out_dump;
-		} else if (cmp == 0 && !is_hash_key(c, key1)) {
+		} else if (cmp == 0 && !is_hash_key(key1)) {
 			/* These can only be keys with colliding hash */
 			dbg_err("keys %d and %d are not hashed but equivalent",
 				i, i + 1);
@@ -459,7 +458,7 @@ int ubifs_tnc_read_node(struct ubifs_inf
 			void *node)
 {
 	union ubifs_key key1, *key = &zbr->key;
-	int err, type = key_type(c, key);
+	int err, type = key_type(key);
 	struct ubifs_wbuf *wbuf;
 
 	/*
@@ -480,8 +479,8 @@ int ubifs_tnc_read_node(struct ubifs_inf
 	}
 
 	/* Make sure the key of the read node is correct */
-	key_read(c, node + UBIFS_KEY_OFFSET, &key1);
-	if (!keys_eq(c, key, &key1)) {
+	key_read(node + UBIFS_KEY_OFFSET, &key1);
+	if (!keys_eq(key, &key1)) {
 		ubifs_err("bad key in node at LEB %d:%d",
 			  zbr->lnum, zbr->offs);
 		dbg_tnc("looked for key %s found node's key %s",
diff -uprN a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
--- a/fs/ubifs/ubifs.h	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/ubifs.h	2009-07-17 11:30:31.000000000 +0530
@@ -1256,7 +1256,7 @@ struct ubifs_info {
 	long long main_bytes;
 
 	uint8_t key_hash_type;
-	uint32_t (*key_hash)(const char *str, int len);
+	uint32_t (*key_hash)(int len);
 	int key_fmt;
 	int key_len;
 	int fanout;
@@ -1459,8 +1459,7 @@ struct ubifs_scan_leb *ubifs_start_scan(
 					int offs, void *sbuf);
 void ubifs_end_scan(const struct ubifs_info *c, struct ubifs_scan_leb *sleb,
 		    int lnum, int offs);
-int ubifs_add_snod(const struct ubifs_info *c, struct ubifs_scan_leb *sleb,
-		   void *buf, int offs);
+int ubifs_add_snod(struct ubifs_scan_leb *sleb, void *buf, int offs);
 void ubifs_scanned_corruption(const struct ubifs_info *c, int lnum, int offs,
 			      void *buf);
 
@@ -1559,8 +1558,7 @@ int ubifs_tnc_bulk_read(struct ubifs_inf
 /* tnc_misc.c */
 struct ubifs_znode *ubifs_tnc_levelorder_next(struct ubifs_znode *zr,
 					      struct ubifs_znode *znode);
-int ubifs_search_zbranch(const struct ubifs_info *c,
-			 const struct ubifs_znode *znode,
+int ubifs_search_zbranch(const struct ubifs_znode *znode,
 			 const union ubifs_key *key, int *n);
 struct ubifs_znode *ubifs_tnc_postorder_first(struct ubifs_znode *znode);
 struct ubifs_znode *ubifs_tnc_postorder_next(struct ubifs_znode *znode);
@@ -1597,8 +1595,7 @@ struct ubifs_sb_node *ubifs_read_sb_node
 int ubifs_write_sb_node(struct ubifs_info *c, struct ubifs_sb_node *sup);
 
 /* replay.c */
-int ubifs_validate_entry(struct ubifs_info *c,
-			 const struct ubifs_dent_node *dent);
+int ubifs_validate_entry(const struct ubifs_dent_node *dent);
 int ubifs_replay_journal(struct ubifs_info *c);
 
 /* gc.c */
diff -uprN a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
--- a/fs/ubifs/xattr.c	2009-07-17 08:11:50.000000000 +0530
+++ b/fs/ubifs/xattr.c	2009-07-17 11:19:48.000000000 +0530
@@ -441,7 +441,7 @@ ssize_t ubifs_listxattr(struct dentry *d
 	if (len > size)
 		return -ERANGE;
 
-	lowest_xent_key(c, &key, host->i_ino);
+	lowest_xent_key(&key, host->i_ino);
 	while (1) {
 		int type;
 
@@ -468,7 +468,7 @@ ssize_t ubifs_listxattr(struct dentry *d
 
 		kfree(pxent);
 		pxent = xent;
-		key_read(c, &xent->key, &key);
+		key_read(&xent->key, &key);
 	}
 
 	kfree(pxent);

---
Regards--
Subrata

