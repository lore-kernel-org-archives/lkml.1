Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYAXTl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYAXTl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbYAXTfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:32 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46591 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbYAXTe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:59 -0500
Message-Id: <20080124193454.408283578@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:34:05 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 24/26] mount options: fix tmpfs
Content-Disposition: inline; filename=tmpfs_opts.patch
Cc: Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add .show_options super operation to tmpfs.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/mm/shmem.c
===================================================================
--- linux.orig/mm/shmem.c	2008-01-21 21:20:04.000000000 +0100
+++ linux/mm/shmem.c	2008-01-21 21:30:04.000000000 +0100
@@ -49,6 +49,7 @@
 #include <linux/ctype.h>
 #include <linux/migrate.h>
 #include <linux/highmem.h>
+#include <linux/seq_file.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
@@ -198,7 +199,7 @@ static DEFINE_MUTEX(shmem_swaplist_mutex
 static void shmem_free_blocks(struct inode *inode, long pages)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-	if (sbinfo->max_blocks) {
+	if (sbinfo->config.max_blocks) {
 		spin_lock(&sbinfo->stat_lock);
 		sbinfo->free_blocks += pages;
 		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
@@ -209,7 +210,7 @@ static void shmem_free_blocks(struct ino
 static int shmem_reserve_inode(struct super_block *sb)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
-	if (sbinfo->max_inodes) {
+	if (sbinfo->config.max_inodes) {
 		spin_lock(&sbinfo->stat_lock);
 		if (!sbinfo->free_inodes) {
 			spin_unlock(&sbinfo->stat_lock);
@@ -224,7 +225,7 @@ static int shmem_reserve_inode(struct su
 static void shmem_free_inode(struct super_block *sb)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
-	if (sbinfo->max_inodes) {
+	if (sbinfo->config.max_inodes) {
 		spin_lock(&sbinfo->stat_lock);
 		sbinfo->free_inodes++;
 		spin_unlock(&sbinfo->stat_lock);
@@ -388,7 +389,7 @@ static swp_entry_t *shmem_swp_alloc(stru
 		 * page (and perhaps indirect index pages) yet to allocate:
 		 * a waste to allocate index if we cannot allocate data.
 		 */
-		if (sbinfo->max_blocks) {
+		if (sbinfo->config.max_blocks) {
 			spin_lock(&sbinfo->stat_lock);
 			if (sbinfo->free_blocks <= 1) {
 				spin_unlock(&sbinfo->stat_lock);
@@ -1338,7 +1339,7 @@ repeat:
 	} else {
 		shmem_swp_unmap(entry);
 		sbinfo = SHMEM_SB(inode->i_sb);
-		if (sbinfo->max_blocks) {
+		if (sbinfo->config.max_blocks) {
 			spin_lock(&sbinfo->stat_lock);
 			if (sbinfo->free_blocks == 0 ||
 			    shmem_acct_block(info->flags)) {
@@ -1519,8 +1520,9 @@ shmem_get_inode(struct super_block *sb, 
 		case S_IFREG:
 			inode->i_op = &shmem_inode_operations;
 			inode->i_fop = &shmem_file_operations;
-			mpol_shared_policy_init(&info->policy, sbinfo->policy,
-							&sbinfo->policy_nodes);
+			mpol_shared_policy_init(&info->policy,
+						sbinfo->config.policy,
+						&sbinfo->config.policy_nodes);
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);
@@ -1720,12 +1722,12 @@ static int shmem_statfs(struct dentry *d
 	buf->f_bsize = PAGE_CACHE_SIZE;
 	buf->f_namelen = NAME_MAX;
 	spin_lock(&sbinfo->stat_lock);
-	if (sbinfo->max_blocks) {
-		buf->f_blocks = sbinfo->max_blocks;
+	if (sbinfo->config.max_blocks) {
+		buf->f_blocks = sbinfo->config.max_blocks;
 		buf->f_bavail = buf->f_bfree = sbinfo->free_blocks;
 	}
-	if (sbinfo->max_inodes) {
-		buf->f_files = sbinfo->max_inodes;
+	if (sbinfo->config.max_inodes) {
+		buf->f_files = sbinfo->config.max_inodes;
 		buf->f_ffree = sbinfo->free_inodes;
 	}
 	/* else leave those fields 0 like simple_statfs */
@@ -2077,9 +2079,8 @@ static const struct export_operations sh
 	.fh_to_dentry	= shmem_fh_to_dentry,
 };
 
-static int shmem_parse_options(char *options, int *mode, uid_t *uid,
-	gid_t *gid, unsigned long *blocks, unsigned long *inodes,
-	int *policy, nodemask_t *policy_nodes)
+static int shmem_parse_options(char *options, struct shmem_config *config,
+			       bool remount)
 {
 	char *this_char, *value, *rest;
 
@@ -2122,35 +2123,43 @@ static int shmem_parse_options(char *opt
 			}
 			if (*rest)
 				goto bad_val;
-			*blocks = DIV_ROUND_UP(size, PAGE_CACHE_SIZE);
+			config->max_blocks =
+				DIV_ROUND_UP(size, PAGE_CACHE_SIZE);
+			config->max_blocks_changed = 1;
 		} else if (!strcmp(this_char,"nr_blocks")) {
-			*blocks = memparse(value,&rest);
+			config->max_blocks = memparse(value, &rest);
+			config->max_blocks_changed = 1;
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"nr_inodes")) {
-			*inodes = memparse(value,&rest);
+			config->max_inodes = memparse(value, &rest);
+			config->max_inodes_changed = 1;
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"mode")) {
-			if (!mode)
+			if (remount)
 				continue;
-			*mode = simple_strtoul(value,&rest,8);
+			config->mode = simple_strtoul(value, &rest, 8) & 07777;
+			config->mode_changed = 1;
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"uid")) {
-			if (!uid)
+			if (remount)
 				continue;
-			*uid = simple_strtoul(value,&rest,0);
+			config->uid = simple_strtoul(value, &rest, 0);
+			config->uid_changed = 1;
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"gid")) {
-			if (!gid)
+			if (remount)
 				continue;
-			*gid = simple_strtoul(value,&rest,0);
+			config->gid = simple_strtoul(value, &rest, 0);
+			config->gid_changed = 1;
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
-			if (shmem_parse_mpol(value,policy,policy_nodes))
+			if (shmem_parse_mpol(value, &config->policy,
+					     &config->policy_nodes))
 				goto bad_val;
 		} else {
 			printk(KERN_ERR "tmpfs: Bad mount option %s\n",
@@ -2170,24 +2179,20 @@ bad_val:
 static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
-	unsigned long max_blocks = sbinfo->max_blocks;
-	unsigned long max_inodes = sbinfo->max_inodes;
-	int policy = sbinfo->policy;
-	nodemask_t policy_nodes = sbinfo->policy_nodes;
+	struct shmem_config config = sbinfo->config;
 	unsigned long blocks;
 	unsigned long inodes;
 	int error = -EINVAL;
 
-	if (shmem_parse_options(data, NULL, NULL, NULL, &max_blocks,
-				&max_inodes, &policy, &policy_nodes))
+	if (shmem_parse_options(data, &config, true))
 		return error;
 
 	spin_lock(&sbinfo->stat_lock);
-	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
-	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
-	if (max_blocks < blocks)
+	blocks = sbinfo->config.max_blocks - sbinfo->free_blocks;
+	inodes = sbinfo->config.max_inodes - sbinfo->free_inodes;
+	if (config.max_blocks < blocks)
 		goto out;
-	if (max_inodes < inodes)
+	if (config.max_inodes < inodes)
 		goto out;
 	/*
 	 * Those tests also disallow limited->unlimited while any are in
@@ -2195,24 +2200,85 @@ static int shmem_remount_fs(struct super
 	 * but we must separately disallow unlimited->limited, because
 	 * in that case we have no record of how much is already in use.
 	 */
-	if (max_blocks && !sbinfo->max_blocks)
+	if (config.max_blocks && !sbinfo->config.max_blocks)
 		goto out;
-	if (max_inodes && !sbinfo->max_inodes)
+	if (config.max_inodes && !sbinfo->config.max_inodes)
 		goto out;
 
 	error = 0;
-	sbinfo->max_blocks  = max_blocks;
-	sbinfo->free_blocks = max_blocks - blocks;
-	sbinfo->max_inodes  = max_inodes;
-	sbinfo->free_inodes = max_inodes - inodes;
-	sbinfo->policy = policy;
-	sbinfo->policy_nodes = policy_nodes;
+	sbinfo->config = config;
+	sbinfo->free_blocks = config.max_blocks - blocks;
+	sbinfo->free_inodes = config.max_inodes - inodes;
 out:
 	spin_unlock(&sbinfo->stat_lock);
 	return error;
 }
+
+#ifdef CONFIG_NUMA
+static void shmem_show_mpol(struct seq_file *seq, int policy,
+			    const nodemask_t policy_nodes)
+{
+	seq_puts(seq, ",mpol=");
+	switch (policy) {
+	case MPOL_PREFERRED:
+		seq_puts(seq, "default");
+		break;
+	case MPOL_BIND:
+		seq_puts(seq, "bind");
+		break;
+	case MPOL_INTERLEAVE:
+		seq_puts(seq, "interleave");
+		break;
+	default:
+		seq_puts(seq, "default");
+	}
+
+	if (policy == MPOL_PREFERRED || policy == MPOL_BIND ||
+	    (policy == MPOL_INTERLEAVE &&
+	     !nodes_equal(policy_nodes, node_online_map))) {
+		char buffer[64];
+		int len;
+
+		len = nodelist_scnprintf(buffer, sizeof(buffer), policy_nodes);
+		if (len < sizeof(buffer))
+			seq_printf(seq, ":%s", buffer);
+		else
+			seq_printf(seq, ":?");
+	}
+}
+#else
+static void shmem_show_mpol(struct seq_file *seq, int policy,
+			    const nodemask_t policy_nodes)
+{
+}
 #endif
 
+static int shmem_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct super_block *sb = vfs->mnt_sb;
+	struct shmem_config *config = &SHMEM_SB(sb)->config;
+
+	if (config->max_blocks_changed) {
+		unsigned long sizek;
+
+		sizek = config->max_blocks << (PAGE_CACHE_SHIFT - 10);
+		seq_printf(seq, ",size=%luk", sizek);
+	}
+	if (config->max_inodes_changed)
+		seq_printf(seq, ",nr_inodes=%lu", config->max_inodes);
+	if (config->mode_changed)
+		seq_printf(seq, ",mode=%03o", config->mode);
+	if (config->uid_changed)
+		seq_printf(seq, ",uid=%u", config->uid);
+	if (config->gid_changed)
+		seq_printf(seq, ",gid=%u", config->gid);
+	if (config->policy != MPOL_DEFAULT)
+		shmem_show_mpol(seq, config->policy, config->policy_nodes);
+
+	return 0;
+}
+#endif /* CONFIG_TMPFS */
+
 static void shmem_put_super(struct super_block *sb)
 {
 	kfree(sb->s_fs_info);
@@ -2224,15 +2290,17 @@ static int shmem_fill_super(struct super
 {
 	struct inode *inode;
 	struct dentry *root;
-	int mode   = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current->fsuid;
-	gid_t gid = current->fsgid;
 	int err = -ENOMEM;
 	struct shmem_sb_info *sbinfo;
-	unsigned long blocks = 0;
-	unsigned long inodes = 0;
-	int policy = MPOL_DEFAULT;
-	nodemask_t policy_nodes = node_states[N_HIGH_MEMORY];
+	struct shmem_config config = {
+		.mode = S_IRWXUGO | S_ISVTX,
+		.uid = current->fsuid,
+		.gid = current->fsgid,
+		.max_blocks = 0,
+		.max_inodes = 0,
+		.policy = MPOL_DEFAULT,
+		.policy_nodes = node_states[N_HIGH_MEMORY],
+	};
 
 #ifdef CONFIG_TMPFS
 	/*
@@ -2241,12 +2309,11 @@ static int shmem_fill_super(struct super
 	 * but the internal instance is left unlimited.
 	 */
 	if (!(sb->s_flags & MS_NOUSER)) {
-		blocks = totalram_pages / 2;
-		inodes = totalram_pages - totalhigh_pages;
-		if (inodes > blocks)
-			inodes = blocks;
-		if (shmem_parse_options(data, &mode, &uid, &gid, &blocks,
-					&inodes, &policy, &policy_nodes))
+		config.max_blocks = totalram_pages / 2;
+		config.max_inodes = totalram_pages - totalhigh_pages;
+		if (config.max_inodes > config.max_blocks)
+			config.max_inodes = config.max_blocks;
+		if (shmem_parse_options(data, &config, false))
 			return -EINVAL;
 	}
 	sb->s_export_op = &shmem_export_ops;
@@ -2261,12 +2328,9 @@ static int shmem_fill_super(struct super
 		return -ENOMEM;
 
 	spin_lock_init(&sbinfo->stat_lock);
-	sbinfo->max_blocks = blocks;
-	sbinfo->free_blocks = blocks;
-	sbinfo->max_inodes = inodes;
-	sbinfo->free_inodes = inodes;
-	sbinfo->policy = policy;
-	sbinfo->policy_nodes = policy_nodes;
+	sbinfo->config = config;
+	sbinfo->free_blocks = config.max_blocks;
+	sbinfo->free_inodes = config.max_inodes;
 
 	sb->s_fs_info = sbinfo;
 	sb->s_maxbytes = SHMEM_MAX_BYTES;
@@ -2280,11 +2344,11 @@ static int shmem_fill_super(struct super
 	sb->s_flags |= MS_POSIXACL;
 #endif
 
-	inode = shmem_get_inode(sb, S_IFDIR | mode, 0);
+	inode = shmem_get_inode(sb, S_IFDIR | config.mode, 0);
 	if (!inode)
 		goto failed;
-	inode->i_uid = uid;
-	inode->i_gid = gid;
+	inode->i_uid = config.uid;
+	inode->i_gid = config.gid;
 	root = d_alloc_root(inode);
 	if (!root)
 		goto failed_iput;
@@ -2420,6 +2484,7 @@ static const struct super_operations shm
 #ifdef CONFIG_TMPFS
 	.statfs		= shmem_statfs,
 	.remount_fs	= shmem_remount_fs,
+	.show_options	= shmem_show_options,
 #endif
 	.delete_inode	= shmem_delete_inode,
 	.drop_inode	= generic_delete_inode,
Index: linux/include/linux/shmem_fs.h
===================================================================
--- linux.orig/include/linux/shmem_fs.h	2008-01-21 21:20:04.000000000 +0100
+++ linux/include/linux/shmem_fs.h	2008-01-21 21:21:08.000000000 +0100
@@ -25,14 +25,27 @@ struct shmem_inode_info {
 #endif
 };
 
-struct shmem_sb_info {
+struct shmem_config {
+	mode_t mode;
+	uid_t uid;
+	gid_t gid;
 	unsigned long max_blocks;   /* How many blocks are allowed */
-	unsigned long free_blocks;  /* How many are left for allocation */
 	unsigned long max_inodes;   /* How many inodes are allowed */
-	unsigned long free_inodes;  /* How many are left for allocation */
 	int policy;		    /* Default NUMA memory alloc policy */
 	nodemask_t policy_nodes;    /* nodemask for preferred and bind */
+
+	unsigned mode_changed : 1;
+	unsigned uid_changed : 1;
+	unsigned gid_changed : 1;
+	unsigned max_blocks_changed : 1;
+	unsigned max_inodes_changed : 1;
+};
+
+struct shmem_sb_info {
+	unsigned long free_blocks;  /* How many are left for allocation */
+	unsigned long free_inodes;  /* How many are left for allocation */
 	spinlock_t    stat_lock;
+	struct shmem_config config;
 };
 
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)

--
