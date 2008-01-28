Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYA1GKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYA1GKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 01:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYA1GJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 01:09:51 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43182 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYA1GJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 01:09:50 -0500
Date: Mon, 28 Jan 2008 06:09:26 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@sister.site
To: Miklos Szeredi <miklos@szeredi.hu>
cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 24/26] mount options: fix tmpfs
In-Reply-To: <20080124193454.408283578@szeredi.hu>
Message-ID: <Pine.LNX.4.64.0801280534370.15609@sister.site>
References: <20080124193341.166753833@szeredi.hu> <20080124193454.408283578@szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008, Miklos Szeredi wrote:
>

Thanks Miklos, that's a welcome enhancement, nicely done.  I've only
noticed one thing wrong (MPOL_PREFERRED shown as "default"); but thought
shmem_config didn't add much value - I'd rather avoid those syntactic
changes to unchanged code; and several tmpfs defaults being relative
(e.g. to totalram_pages, or to mounter's fsuid), I ended up preferring
to do real tests in shmem_show_options.

Thus, for example, if memory is hotplugged in or out later, what started
out as an unspecified size option will then get shown as explicit size.
(I did think for a while that I wanted to show explicit size in all
cases; but it looked pretty silly on udev.)  I think that's the correct
behaviour, that otherwise would be misleading; but I may be looking at
this the wrong way round, what's your view?

If you agree with the version below, please take it into your collection
and insert your Signed-off-by.  I should admit, I've not yet tested how
the NUMA policies look: you'll hear from me again tomorrow morning if
those turn out to wrong.

Hugh

From: Miklos Szeredi <mszeredi@suse.cz>

Add .show_options super operation to tmpfs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/linux/shmem_fs.h |    5 
 mm/shmem.c               |  189 ++++++++++++++++++++++++-------------
 2 files changed, 129 insertions(+), 65 deletions(-)

--- 2.6.24-rc8-mm1/include/linux/shmem_fs.h	2006-11-29 21:57:37.000000000 +0000
+++ linux/include/linux/shmem_fs.h	2008-01-27 22:42:52.000000000 +0000
@@ -30,9 +30,12 @@ struct shmem_sb_info {
 	unsigned long free_blocks;  /* How many are left for allocation */
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
+	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
+	uid_t uid;		    /* Mount uid for root directory */
+	gid_t gid;		    /* Mount gid for root directory */
+	mode_t mode;		    /* Mount mode for root directory */
 	int policy;		    /* Default NUMA memory alloc policy */
 	nodemask_t policy_nodes;    /* nodemask for preferred and bind */
-	spinlock_t    stat_lock;
 };
 
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
--- 2.6.24-rc8-mm1/mm/shmem.c	2008-01-17 16:51:21.000000000 +0000
+++ linux/mm/shmem.c	2008-01-27 23:41:31.000000000 +0000
@@ -49,6 +49,7 @@
 #include <linux/ctype.h>
 #include <linux/migrate.h>
 #include <linux/highmem.h>
+#include <linux/seq_file.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
@@ -1068,7 +1069,8 @@ redirty:
 }
 
 #ifdef CONFIG_NUMA
-static inline int shmem_parse_mpol(char *value, int *policy, nodemask_t *policy_nodes)
+#ifdef CONFIG_TMPFS
+static int shmem_parse_mpol(char *value, int *policy, nodemask_t *policy_nodes)
 {
 	char *nodelist = strchr(value, ':');
 	int err = 1;
@@ -1117,6 +1119,42 @@ out:
 	return err;
 }
 
+static void shmem_show_mpol(struct seq_file *seq, int policy,
+			    const nodemask_t policy_nodes)
+{
+	char *policy_string;
+
+	switch (policy) {
+	case MPOL_PREFERRED:
+		policy_string = "prefer";
+		break;
+	case MPOL_BIND:
+		policy_string = "bind";
+		break;
+	case MPOL_INTERLEAVE:
+		policy_string = "interleave";
+		break;
+	default:
+		/* MPOL_DEFAULT */
+		return;
+	}
+
+	seq_printf(seq, ",mpol=%s", policy_string);
+
+	if (policy != MPOL_INTERLEAVE ||
+	    !nodes_equal(policy_nodes, node_states[N_HIGH_MEMORY])) {
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
+#endif /* CONFIG_TMPFS */
+
 static struct page *shmem_swapin(swp_entry_t entry, gfp_t gfp,
 			struct shmem_inode_info *info, unsigned long idx)
 {
@@ -1148,13 +1186,20 @@ static struct page *shmem_alloc_page(gfp
 	mpol_free(pvma.vm_policy);
 	return page;
 }
-#else
+#else /* !CONFIG_NUMA */
+#ifdef CONFIG_TMPFS
 static inline int shmem_parse_mpol(char *value, int *policy,
 						nodemask_t *policy_nodes)
 {
 	return 1;
 }
 
+static inline void shmem_show_mpol(struct seq_file *seq, int policy,
+			    const nodemask_t policy_nodes)
+{
+}
+#endif /* CONFIG_TMPFS */
+
 static inline struct page *shmem_swapin(swp_entry_t entry, gfp_t gfp,
 			struct shmem_inode_info *info, unsigned long idx)
 {
@@ -1166,7 +1211,7 @@ static inline struct page *shmem_alloc_p
 {
 	return alloc_page(gfp);
 }
-#endif
+#endif /* CONFIG_NUMA */
 
 /*
  * shmem_getpage - either get the page from swap or allocate a new one
@@ -2077,9 +2122,8 @@ static const struct export_operations sh
 	.fh_to_dentry	= shmem_fh_to_dentry,
 };
 
-static int shmem_parse_options(char *options, int *mode, uid_t *uid,
-	gid_t *gid, unsigned long *blocks, unsigned long *inodes,
-	int *policy, nodemask_t *policy_nodes)
+static int shmem_parse_options(char *options, struct shmem_sb_info *sbinfo,
+			       bool remount)
 {
 	char *this_char, *value, *rest;
 
@@ -2122,35 +2166,37 @@ static int shmem_parse_options(char *opt
 			}
 			if (*rest)
 				goto bad_val;
-			*blocks = DIV_ROUND_UP(size, PAGE_CACHE_SIZE);
+			sbinfo->max_blocks =
+				DIV_ROUND_UP(size, PAGE_CACHE_SIZE);
 		} else if (!strcmp(this_char,"nr_blocks")) {
-			*blocks = memparse(value,&rest);
+			sbinfo->max_blocks = memparse(value, &rest);
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"nr_inodes")) {
-			*inodes = memparse(value,&rest);
+			sbinfo->max_inodes = memparse(value, &rest);
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"mode")) {
-			if (!mode)
+			if (remount)
 				continue;
-			*mode = simple_strtoul(value,&rest,8);
+			sbinfo->mode = simple_strtoul(value, &rest, 8) & 07777;
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"uid")) {
-			if (!uid)
+			if (remount)
 				continue;
-			*uid = simple_strtoul(value,&rest,0);
+			sbinfo->uid = simple_strtoul(value, &rest, 0);
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"gid")) {
-			if (!gid)
+			if (remount)
 				continue;
-			*gid = simple_strtoul(value,&rest,0);
+			sbinfo->gid = simple_strtoul(value, &rest, 0);
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
-			if (shmem_parse_mpol(value,policy,policy_nodes))
+			if (shmem_parse_mpol(value, &sbinfo->policy,
+					     &sbinfo->policy_nodes))
 				goto bad_val;
 		} else {
 			printk(KERN_ERR "tmpfs: Bad mount option %s\n",
@@ -2170,24 +2216,20 @@ bad_val:
 static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
-	unsigned long max_blocks = sbinfo->max_blocks;
-	unsigned long max_inodes = sbinfo->max_inodes;
-	int policy = sbinfo->policy;
-	nodemask_t policy_nodes = sbinfo->policy_nodes;
+	struct shmem_sb_info config = *sbinfo;
 	unsigned long blocks;
 	unsigned long inodes;
 	int error = -EINVAL;
 
-	if (shmem_parse_options(data, NULL, NULL, NULL, &max_blocks,
-				&max_inodes, &policy, &policy_nodes))
+	if (shmem_parse_options(data, &config, true))
 		return error;
 
 	spin_lock(&sbinfo->stat_lock);
 	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
-	if (max_blocks < blocks)
+	if (config.max_blocks < blocks)
 		goto out;
-	if (max_inodes < inodes)
+	if (config.max_inodes < inodes)
 		goto out;
 	/*
 	 * Those tests also disallow limited->unlimited while any are in
@@ -2195,23 +2237,43 @@ static int shmem_remount_fs(struct super
 	 * but we must separately disallow unlimited->limited, because
 	 * in that case we have no record of how much is already in use.
 	 */
-	if (max_blocks && !sbinfo->max_blocks)
+	if (config.max_blocks && !sbinfo->max_blocks)
 		goto out;
-	if (max_inodes && !sbinfo->max_inodes)
+	if (config.max_inodes && !sbinfo->max_inodes)
 		goto out;
 
 	error = 0;
-	sbinfo->max_blocks  = max_blocks;
-	sbinfo->free_blocks = max_blocks - blocks;
-	sbinfo->max_inodes  = max_inodes;
-	sbinfo->free_inodes = max_inodes - inodes;
-	sbinfo->policy = policy;
-	sbinfo->policy_nodes = policy_nodes;
+	sbinfo->max_blocks  = config.max_blocks;
+	sbinfo->free_blocks = config.max_blocks - blocks;
+	sbinfo->max_inodes  = config.max_inodes;
+	sbinfo->free_inodes = config.max_inodes - inodes;
+	sbinfo->policy      = config.policy;
+	sbinfo->policy_nodes = config.policy_nodes;
 out:
 	spin_unlock(&sbinfo->stat_lock);
 	return error;
 }
-#endif
+
+static int shmem_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(vfs->mnt_sb);
+
+	if (sbinfo->max_blocks != totalram_pages / 2)
+		seq_printf(seq, ",size=%luk",
+			sbinfo->max_blocks << (PAGE_CACHE_SHIFT - 10));
+	if (sbinfo->max_inodes !=
+	    min(totalram_pages - totalhigh_pages, totalram_pages / 2))
+		seq_printf(seq, ",nr_inodes=%lu", sbinfo->max_inodes);
+	if (sbinfo->mode != (S_IRWXUGO | S_ISVTX))
+		seq_printf(seq, ",mode=%03o", sbinfo->mode);
+	if (sbinfo->uid != 0)
+		seq_printf(seq, ",uid=%u", sbinfo->uid);
+	if (sbinfo->gid != 0)
+		seq_printf(seq, ",gid=%u", sbinfo->gid);
+	shmem_show_mpol(seq, sbinfo->policy, sbinfo->policy_nodes);
+	return 0;
+}
+#endif /* CONFIG_TMPFS */
 
 static void shmem_put_super(struct super_block *sb)
 {
@@ -2224,15 +2286,23 @@ static int shmem_fill_super(struct super
 {
 	struct inode *inode;
 	struct dentry *root;
-	int mode   = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current->fsuid;
-	gid_t gid = current->fsgid;
-	int err = -ENOMEM;
 	struct shmem_sb_info *sbinfo;
-	unsigned long blocks = 0;
-	unsigned long inodes = 0;
-	int policy = MPOL_DEFAULT;
-	nodemask_t policy_nodes = node_states[N_HIGH_MEMORY];
+	int err = -ENOMEM;
+
+	/* Round up to L1_CACHE_BYTES to resist false sharing */
+	sbinfo = kmalloc(max((int)sizeof(struct shmem_sb_info),
+				L1_CACHE_BYTES), GFP_KERNEL);
+	if (!sbinfo)
+		return -ENOMEM;
+
+	sbinfo->max_blocks = 0;
+	sbinfo->max_inodes = 0;
+	sbinfo->mode = S_IRWXUGO | S_ISVTX;
+	sbinfo->uid = current->fsuid;
+	sbinfo->gid = current->fsgid;
+	sbinfo->policy = MPOL_DEFAULT;
+	sbinfo->policy_nodes = node_states[N_HIGH_MEMORY];
+	sb->s_fs_info = sbinfo;
 
 #ifdef CONFIG_TMPFS
 	/*
@@ -2241,34 +2311,24 @@ static int shmem_fill_super(struct super
 	 * but the internal instance is left unlimited.
 	 */
 	if (!(sb->s_flags & MS_NOUSER)) {
-		blocks = totalram_pages / 2;
-		inodes = totalram_pages - totalhigh_pages;
-		if (inodes > blocks)
-			inodes = blocks;
-		if (shmem_parse_options(data, &mode, &uid, &gid, &blocks,
-					&inodes, &policy, &policy_nodes))
-			return -EINVAL;
+		sbinfo->max_blocks = totalram_pages / 2;
+		sbinfo->max_inodes = totalram_pages - totalhigh_pages;
+		if (sbinfo->max_inodes > sbinfo->max_blocks)
+			sbinfo->max_inodes = sbinfo->max_blocks;
+		if (shmem_parse_options(data, sbinfo, false)) {
+			err = -EINVAL;
+			goto failed;
+		}
 	}
 	sb->s_export_op = &shmem_export_ops;
 #else
 	sb->s_flags |= MS_NOUSER;
 #endif
 
-	/* Round up to L1_CACHE_BYTES to resist false sharing */
-	sbinfo = kmalloc(max((int)sizeof(struct shmem_sb_info),
-				L1_CACHE_BYTES), GFP_KERNEL);
-	if (!sbinfo)
-		return -ENOMEM;
-
 	spin_lock_init(&sbinfo->stat_lock);
-	sbinfo->max_blocks = blocks;
-	sbinfo->free_blocks = blocks;
-	sbinfo->max_inodes = inodes;
-	sbinfo->free_inodes = inodes;
-	sbinfo->policy = policy;
-	sbinfo->policy_nodes = policy_nodes;
+	sbinfo->free_blocks = sbinfo->max_blocks;
+	sbinfo->free_inodes = sbinfo->max_inodes;
 
-	sb->s_fs_info = sbinfo;
 	sb->s_maxbytes = SHMEM_MAX_BYTES;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
@@ -2280,11 +2340,11 @@ static int shmem_fill_super(struct super
 	sb->s_flags |= MS_POSIXACL;
 #endif
 
-	inode = shmem_get_inode(sb, S_IFDIR | mode, 0);
+	inode = shmem_get_inode(sb, S_IFDIR | sbinfo->mode, 0);
 	if (!inode)
 		goto failed;
-	inode->i_uid = uid;
-	inode->i_gid = gid;
+	inode->i_uid = sbinfo->uid;
+	inode->i_gid = sbinfo->gid;
 	root = d_alloc_root(inode);
 	if (!root)
 		goto failed_iput;
@@ -2420,6 +2480,7 @@ static const struct super_operations shm
 #ifdef CONFIG_TMPFS
 	.statfs		= shmem_statfs,
 	.remount_fs	= shmem_remount_fs,
+	.show_options	= shmem_show_options,
 #endif
 	.delete_inode	= shmem_delete_inode,
 	.drop_inode	= generic_delete_inode,
