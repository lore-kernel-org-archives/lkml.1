Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZGPMl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZGPMl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZGPMlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:41:55 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41836 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZGPMly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:41:54 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Adrian Hunter <adrian.hunter@nokia.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>, linux-mtd@lists.infradead.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Thu, 16 Jul 2009 18:11:36 +0530
Message-Id: <20090716124133.25463.33849.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

>On Thu, 2009-07-16 at 15:11 +0300, Artem Bityutskiy wrote:
>On Thu, 2009-07-16 at 13:57 +0200, Stefan Richter wrote:
> > Stefan Richter wrote:
> > > So, is uninitialized_var() a good fix here?  I'd say it's not a 
> > > particular good one.  Count the lines of code of dbg_check_old_index() 
> > > and the maximum indentation level of it.  Then remember the teachings of 
> > > CodingStyle. :-)  See?  dbg_check_old_index() clearly isn't a prime 
> > > example of best kernel coding practice.  /Perhaps/ a little bit of 
> > > refactoring would make it easier to read, and as a bonus side effect, 
> > > make it unnecessary to use the slightly dangerous and 
> > > uninitialized_var() macro here.
> > 
> > PS:
> > On the other hand, it is debug code.  Is it bound to stay in there 
> > forever?  If not, then it's surely not worth the developer time to 
> > beautify it.
> 
> Yes, it is debugging code. It is doing additional consistency/sanity
> checks of the internal data structures when you compile it in and enable
> it. And yes, I'd like it to stay there forever, because it is a very
> nice tool to catch bugs. In fact, I am really keen of this type of
> debugging when you have internal checking functions. They help a lot.
>

I see from "fs/ubifs/key.h" code that:
	"key_read(ubifs_idx_key(c, idx), &lower_key)"
will definitely initialize 'lower_key'.

Morever,

509 {
510         int lnum, offs, len, err = 0, uninitialized_var(last_level), child_cnt;
511         int first = 1, iip;

'last_level' & 'last_sqnum' definitely gets initialized below:

572                         /* Set last values as though root had a parent */
573                         last_level = le16_to_cpu(idx->level) + 1;
574                         last_sqnum = le64_to_cpu(idx->ch.sqnum) + 1;
575                         key_read(c, ubifs_idx_key(c, idx), &lower_key);

Though it is understandable that GCC (my version 4.4.1) might
not see 'lower_key' assignment directly(hidden through a function call),
it should have predicted 'last_level' & 'last_sqnum'. May be because they
are inside the "if (first) {..." statement.

I understand that there might be no necessity to fix this using
unitialized_var() macro, as, it seems that proper initialization
will take place. However, on debugging, i found something more
interesting. The

key_read() and key_write() functions defined inside "fs/ubifs/key.h"

426 /**
427  * key_read - transform a key to in-memory format.
428  * @c: UBIFS file-system description object
429  * @from: the key to transform
430  * @to: the key to store the result
431  */
432 static inline void key_read(const struct ubifs_info *c, const void *from,
433                             union ubifs_key *to)
434 {
435         const union ubifs_key *f = from;
436 
437         to->u32[0] = le32_to_cpu(f->j32[0]);
438         to->u32[1] = le32_to_cpu(f->j32[1]);
439 }
440 
441 /**
442  * key_write - transform a key from in-memory format.
443  * @c: UBIFS file-system description object
444  * @from: the key to transform
445  * @to: the key to store the result
446  */
447 static inline void key_write(const struct ubifs_info *c,
448                              const union ubifs_key *from, void *to)
449 {
450         union ubifs_key *t = to;
451 
452         t->j32[0] = cpu_to_le32(from->u32[0]);
453         t->j32[1] = cpu_to_le32(from->u32[1]);
454         memset(to + 8, 0, UBIFS_MAX_KEY_LEN - 8);
455 }

does not use:
	"const struct ubifs_info *c"
inside the inline function. I do not see any practical usage of
"const struct ubifs_info *c" in the functions key_read() and key_write().
Is there something which i am missing to understand ?

When i applied the following patch, still the "fs/ubifs/" code compiled fine.
If the below fix is correct, i can try fixing some other functions i saw
having similar defects.
---

diff -uprN b/fs/ubifs/commit.c a/fs/ubifs/commit.c
--- a/fs/ubifs/commit.c	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/commit.c	2009-07-16 17:42:57.000000000 +0530
@@ -507,7 +507,7 @@ out:
  */
 int dbg_check_old_index(struct ubifs_info *c, struct ubifs_zbranch *zroot)
 {
-	int lnum, offs, len, err = 0, uninitialized_var(last_level), child_cnt;
+	int lnum, offs, len, err = 0, last_level, child_cnt;
 	int first = 1, iip;
 	struct ubifs_debug_info *d = c->dbg;
 	union ubifs_key lower_key, upper_key, l_key, u_key;
@@ -572,7 +572,7 @@ int dbg_check_old_index(struct ubifs_inf
 			/* Set last values as though root had a parent */
 			last_level = le16_to_cpu(idx->level) + 1;
 			last_sqnum = le64_to_cpu(idx->ch.sqnum) + 1;
-			key_read(c, ubifs_idx_key(c, idx), &lower_key);
+			key_read(ubifs_idx_key(c, idx), &lower_key);
 			highest_ino_key(c, &upper_key, INUM_WATERMARK);
 		}
 		key_copy(c, &upper_key, &i->upper_key);
@@ -589,9 +589,9 @@ int dbg_check_old_index(struct ubifs_inf
 			goto out_dump;
 		}
 		/* Check key range */
-		key_read(c, ubifs_idx_key(c, idx), &l_key);
+		key_read(ubifs_idx_key(c, idx), &l_key);
 		br = ubifs_idx_branch(c, idx, child_cnt - 1);
-		key_read(c, &br->key, &u_key);
+		key_read(&br->key, &u_key);
 		if (keys_cmp(c, &lower_key, &l_key) > 0) {
 			err = 5;
 			goto out_dump;
@@ -640,10 +640,10 @@ int dbg_check_old_index(struct ubifs_inf
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
 			key_copy(c, &i->upper_key, &upper_key);
 	}
diff -uprN b/fs/ubifs/debug.c a/fs/ubifs/debug.c
--- a/fs/ubifs/debug.c	2009-07-16 16:18:46.000000000 +0530
+++ b/fs/ubifs/debug.c	2009-07-16 17:32:29.000000000 +0530
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
@@ -998,7 +998,7 @@ int dbg_check_dir_size(struct ubifs_info
 			nlink += 1;
 		kfree(pdent);
 		pdent = dent;
-		key_read(c, &dent->key, &key);
+		key_read(&dent->key, &key);
 	}
 	kfree(pdent);
 
@@ -1066,7 +1066,7 @@ static int dbg_check_key_order(struct ub
 
 	/* Make sure node keys are the same as in zbranch */
 	err = 1;
-	key_read(c, &dent1->key, &key);
+	key_read(&dent1->key, &key);
 	if (keys_cmp(c, &zbr1->key, &key)) {
 		dbg_err("1st entry at %d:%d has key %s", zbr1->lnum,
 			zbr1->offs, DBGKEY(&key));
@@ -1076,7 +1076,7 @@ static int dbg_check_key_order(struct ub
 		goto out_free;
 	}
 
-	key_read(c, &dent2->key, &key);
+	key_read(&dent2->key, &key);
 	if (keys_cmp(c, &zbr2->key, &key)) {
 		dbg_err("2nd entry at %d:%d has key %s", zbr1->lnum,
 			zbr1->offs, DBGKEY(&key));
diff -uprN b/fs/ubifs/dir.c a/fs/ubifs/dir.c
--- a/fs/ubifs/dir.c	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/dir.c	2009-07-16 17:32:52.000000000 +0530
@@ -439,7 +439,7 @@ static int ubifs_readdir(struct file *fi
 			return 0;
 
 		/* Switch to the next entry */
-		key_read(c, &dent->key, &key);
+		key_read(&dent->key, &key);
 		nm.name = dent->name;
 		dent = ubifs_tnc_next_ent(c, &key, &nm);
 		if (IS_ERR(dent)) {
diff -uprN b/fs/ubifs/gc.c a/fs/ubifs/gc.c
--- a/fs/ubifs/gc.c	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/gc.c	2009-07-16 17:33:13.000000000 +0530
@@ -546,7 +546,7 @@ int ubifs_garbage_collect_leb(struct ubi
 			int level = le16_to_cpu(idx->level);
 
 			ubifs_assert(snod->type == UBIFS_IDX_NODE);
-			key_read(c, ubifs_idx_key(c, idx), &snod->key);
+			key_read(ubifs_idx_key(c, idx), &snod->key);
 			err = ubifs_dirty_idx_node(c, &snod->key, level, lnum,
 						   snod->offs);
 			if (err)
diff -uprN b/fs/ubifs/journal.c a/fs/ubifs/journal.c
--- a/fs/ubifs/journal.c	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/journal.c	2009-07-16 17:30:51.000000000 +0530
@@ -583,7 +583,7 @@ int ubifs_jnl_update(struct ubifs_info *
 		xent_key_init(c, &dent_key, dir->i_ino, nm);
 	}
 
-	key_write(c, &dent_key, dent->key);
+	key_write(&dent_key, dent->key);
 	dent->inum = deletion ? 0 : cpu_to_le64(inode->i_ino);
 	dent->type = get_dent_type(inode->i_mode);
 	dent->nlen = cpu_to_le16(nm->len);
@@ -699,7 +699,7 @@ int ubifs_jnl_write_data(struct ubifs_in
 		return -ENOMEM;
 
 	data->ch.node_type = UBIFS_DATA_NODE;
-	key_write(c, key, &data->key);
+	key_write(key, &data->key);
 	data->size = cpu_to_le32(len);
 	zero_data_node_unused(data);
 
@@ -1296,7 +1296,7 @@ int ubifs_jnl_delete_xattr(struct ubifs_
 
 	xent->ch.node_type = UBIFS_XENT_NODE;
 	xent_key_init(c, &xent_key, host->i_ino, nm);
-	key_write(c, &xent_key, xent->key);
+	key_write(&xent_key, xent->key);
 	xent->inum = 0;
 	xent->type = get_dent_type(inode->i_mode);
 	xent->nlen = cpu_to_le16(nm->len);
diff -uprN b/fs/ubifs/key.h a/fs/ubifs/key.h
--- a/fs/ubifs/key.h	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/key.h	2009-07-16 17:37:20.000000000 +0530
@@ -429,8 +429,7 @@ static inline unsigned int key_block_fla
  * @from: the key to transform
  * @to: the key to store the result
  */
-static inline void key_read(const struct ubifs_info *c, const void *from,
-			    union ubifs_key *to)
+static inline void key_read(const void *from, union ubifs_key *to)
 {
 	const union ubifs_key *f = from;
 
@@ -444,8 +443,7 @@ static inline void key_read(const struct
  * @from: the key to transform
  * @to: the key to store the result
  */
-static inline void key_write(const struct ubifs_info *c,
-			     const union ubifs_key *from, void *to)
+static inline void key_write(const union ubifs_key *from, void *to)
 {
 	union ubifs_key *t = to;
 
@@ -461,7 +459,7 @@ static inline void key_write(const struc
  * @to: the key to store the result
  */
 static inline void key_write_idx(const struct ubifs_info *c,
-				 const union ubifs_key *from, void *to)
+                                 const union ubifs_key *from, void *to)
 {
 	union ubifs_key *t = to;
 
diff -uprN b/fs/ubifs/lprops.c a/fs/ubifs/lprops.c
--- a/fs/ubifs/lprops.c	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/lprops.c	2009-07-16 17:33:30.000000000 +0530
@@ -1142,7 +1142,7 @@ static int scan_check_cb(struct ubifs_in
 		if (snod->type == UBIFS_IDX_NODE) {
 			struct ubifs_idx_node *idx = snod->node;
 
-			key_read(c, ubifs_idx_key(c, idx), &snod->key);
+			key_read(ubifs_idx_key(c, idx), &snod->key);
 			level = le16_to_cpu(idx->level);
 		}
 
diff -uprN b/fs/ubifs/scan.c a/fs/ubifs/scan.c
--- a/fs/ubifs/scan.c	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/scan.c	2009-07-16 17:33:42.000000000 +0530
@@ -218,7 +218,7 @@ int ubifs_add_snod(const struct ubifs_in
 		 * The key is in the same place in all keyed
 		 * nodes.
 		 */
-		key_read(c, &ino->key, &snod->key);
+		key_read(&ino->key, &snod->key);
 		break;
 	}
 	list_add_tail(&snod->list, &sleb->nodes);
diff -uprN b/fs/ubifs/tnc.c a/fs/ubifs/tnc.c
--- a/fs/ubifs/tnc.c	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/tnc.c	2009-07-16 17:34:06.000000000 +0530
@@ -510,7 +510,7 @@ static int fallible_read_node(struct ubi
 		struct ubifs_dent_node *dent = node;
 
 		/* All nodes have key in the same place */
-		key_read(c, &dent->key, &node_key);
+		key_read(&dent->key, &node_key);
 		if (keys_cmp(c, key, &node_key) != 0)
 			ret = 0;
 	}
@@ -1713,7 +1713,7 @@ static int validate_data_node(struct ubi
 	}
 
 	/* Make sure the key of the read node is correct */
-	key_read(c, buf + UBIFS_KEY_OFFSET, &key1);
+	key_read(buf + UBIFS_KEY_OFFSET, &key1);
 	if (!keys_eq(c, &zbr->key, &key1)) {
 		ubifs_err("bad key in node at LEB %d:%d",
 			  zbr->lnum, zbr->offs);
@@ -2726,7 +2726,7 @@ int ubifs_tnc_remove_ino(struct ubifs_in
 
 		kfree(pxent);
 		pxent = xent;
-		key_read(c, &xent->key, &key1);
+		key_read(&xent->key, &key1);
 	}
 
 	kfree(pxent);
diff -uprN b/fs/ubifs/tnc_commit.c a/fs/ubifs/tnc_commit.c
--- a/fs/ubifs/tnc_commit.c	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/tnc_commit.c	2009-07-16 17:34:18.000000000 +0530
@@ -256,7 +256,7 @@ static int layout_leb_in_gaps(struct ubi
 
 		ubifs_assert(snod->type == UBIFS_IDX_NODE);
 		idx = snod->node;
-		key_read(c, ubifs_idx_key(c, idx), &snod->key);
+		key_read(ubifs_idx_key(c, idx), &snod->key);
 		level = le16_to_cpu(idx->level);
 		/* Determine if the index node is in use (not obsolete) */
 		in_use = is_idx_node_in_use(c, &snod->key, level, lnum,
diff -uprN b/fs/ubifs/tnc_misc.c a/fs/ubifs/tnc_misc.c
--- a/fs/ubifs/tnc_misc.c	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/tnc_misc.c	2009-07-16 17:34:38.000000000 +0530
@@ -305,7 +305,7 @@ static int read_znode(struct ubifs_info 
 		const struct ubifs_branch *br = ubifs_idx_branch(c, idx, i);
 		struct ubifs_zbranch *zbr = &znode->zbranch[i];
 
-		key_read(c, &br->key, &zbr->key);
+		key_read(&br->key, &zbr->key);
 		zbr->lnum = le32_to_cpu(br->lnum);
 		zbr->offs = le32_to_cpu(br->offs);
 		zbr->len  = le32_to_cpu(br->len);
@@ -480,7 +480,7 @@ int ubifs_tnc_read_node(struct ubifs_inf
 	}
 
 	/* Make sure the key of the read node is correct */
-	key_read(c, node + UBIFS_KEY_OFFSET, &key1);
+	key_read(node + UBIFS_KEY_OFFSET, &key1);
 	if (!keys_eq(c, key, &key1)) {
 		ubifs_err("bad key in node at LEB %d:%d",
 			  zbr->lnum, zbr->offs);
diff -uprN b/fs/ubifs/xattr.c a/fs/ubifs/xattr.c
--- a/fs/ubifs/xattr.c	2009-07-16 16:18:47.000000000 +0530
+++ b/fs/ubifs/xattr.c	2009-07-16 17:34:51.000000000 +0530
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

