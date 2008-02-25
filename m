Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYBYPgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYBYPgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYBYPfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:35:47 -0500
Received: from smtp-out.google.com ([216.239.33.17]:59243 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbYBYPfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:35:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=S7xhbsq4WTGqmSKZGCEaYI3lLkhpqsUAzGbhcbpOM8lSfseW0SQgeXklm27AXQ7yq
	Hh+UT41gP++Ki/AWtnTIQ==
Date: Mon, 25 Feb 2008 07:35:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch 2/6] mempolicy: support optional mode flags
In-Reply-To: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the evolution of mempolicies, it is necessary to support mempolicy
mode flags that specify how the policy shall behave in certain
circumstances.  The most immediate need for mode flag support is to
suppress remapping the nodemask of a policy at the time of rebind.

Both the mempolicy mode and flags are passed by the user in the 'int
policy' formal of either the set_mempolicy() or mbind() syscall.  A new
constant, MPOL_MODE_FLAGS, represents the union of legal optional flags
that may be passed as part of this int.  Mempolicies that include illegal
flags as part of their policy are rejected as invalid.

An additional member to struct mempolicy is added to support the mode
flags:

	struct mempolicy {
		...
		unsigned short policy;
		unsigned short flags;
	}

The splitting of the 'int' actual passed by the user is done in
sys_set_mempolicy() and sys_mbind() for their respective syscalls.  This
is done by intersecting the actual with MPOL_MODE_FLAGS, rejecting the
syscall of there are additional flags, and storing it in the new 'flags'
member of struct mempolicy.  The intersection of the actual with
~MPOL_MODE_FLAGS is stored in the 'policy' member of the struct and all
current users of pol->policy remain unchanged.

The union of the policy mode and optional mode flags is passed back to
the user in get_mempolicy().

This combination of mode and flags within the same actual does not break 
userspace code that relies on get_mempolicy(&policy, ...) and either

	switch (policy) {
	case MPOL_BIND:
		...
	case MPOL_INTERLEAVE:
		...
	};

statements or

	if (policy == MPOL_INTERLEAVE) {
		...
	}

statements.  Such applications would need to use optional mode flags when
calling set_mempolicy() or mbind() for these previously implemented
statements to stop working.  If an application does start using optional
mode flags, it will need to mask the optional flags off the policy in
switch and conditional statements that only test mode.

An additional member is also added to struct shmem_sb_info to store the
optional mode flags.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/hugetlbfs/inode.c      |    2 +-
 include/linux/mempolicy.h |   20 +++++++++++++++--
 include/linux/shmem_fs.h  |    1 +
 mm/mempolicy.c            |   51 +++++++++++++++++++++++++++-----------------
 mm/shmem.c                |   24 ++++++++++++++-------
 5 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -504,7 +504,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb, uid_t uid,
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		INIT_LIST_HEAD(&inode->i_mapping->private_list);
 		info = HUGETLBFS_I(inode);
-		mpol_shared_policy_init(&info->policy, MPOL_DEFAULT, NULL);
+		mpol_shared_policy_init(&info->policy, MPOL_DEFAULT, 0, NULL);
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -8,6 +8,12 @@
  * Copyright 2003,2004 Andi Kleen SuSE Labs
  */
 
+/*
+ * Both the MPOL_* mempolicy mode and the MPOL_F_* optional mode flags are
+ * passed by the user to either set_mempolicy() or mbind() in an 'int' actual.
+ * The MPOL_MODE_FLAGS macro determines the legal set of optional mode flags.
+ */
+
 /* Policies */
 enum {
 	MPOL_DEFAULT,
@@ -17,7 +23,14 @@ enum {
 	MPOL_MAX,	/* always last member of enum */
 };
 
-/* Flags for get_mem_policy */
+/* Flags for set_mempolicy */
+/*
+ * MPOL_MODE_FLAGS is the union of all possible optional mode flags passed to
+ * either set_mempolicy() or mbind().
+ */
+#define MPOL_MODE_FLAGS		(0)
+
+/* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
 #define MPOL_F_MEMS_ALLOWED (1<<2) /* return allowed memories */
@@ -64,6 +77,7 @@ struct mm_struct;
 struct mempolicy {
 	atomic_t refcnt;
 	unsigned short policy; 	/* See MPOL_* above */
+	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
 	union {
 		struct zonelist  *zonelist;	/* bind */
 		short 		 preferred_node; /* preferred */
@@ -135,7 +149,7 @@ struct shared_policy {
 };
 
 void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
-				nodemask_t *nodes);
+				unsigned short flags, nodemask_t *nodes);
 int mpol_set_shared_policy(struct shared_policy *info,
 				struct vm_area_struct *vma,
 				struct mempolicy *new);
@@ -201,7 +215,7 @@ static inline int mpol_set_shared_policy(struct shared_policy *info,
 }
 
 static inline void mpol_shared_policy_init(struct shared_policy *info,
-				unsigned short policy, nodemask_t *nodes)
+		unsigned short flags, unsigned short policy, nodemask_t *nodes)
 {
 }
 
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -35,6 +35,7 @@ struct shmem_sb_info {
 	gid_t gid;		    /* Mount gid for root directory */
 	mode_t mode;		    /* Mount mode for root directory */
 	unsigned short policy;	    /* Default NUMA memory alloc policy */
+	unsigned short flags;	    /* Optional mempolicy flags */
 	nodemask_t policy_nodes;    /* nodemask for preferred and bind */
 };
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -203,12 +203,13 @@ static struct zonelist *bind_zonelist(nodemask_t *nodes)
 }
 
 /* Create a new policy */
-static struct mempolicy *mpol_new(unsigned short mode, nodemask_t *nodes)
+static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
+				  nodemask_t *nodes)
 {
 	struct mempolicy *policy;
 
-	pr_debug("setting mode %d nodes[0] %lx\n",
-		 mode, nodes ? nodes_addr(*nodes)[0] : -1);
+	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
+		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
 	if (mode == MPOL_DEFAULT)
 		return NULL;
@@ -241,6 +242,7 @@ static struct mempolicy *mpol_new(unsigned short mode, nodemask_t *nodes)
 		BUG();
 	}
 	policy->policy = mode;
+	policy->flags = flags;
 	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
 	return policy;
 }
@@ -483,13 +485,14 @@ static void mpol_set_task_struct_flag(void)
 }
 
 /* Set the process memory policy */
-static long do_set_mempolicy(unsigned short mode, nodemask_t *nodes)
+static long do_set_mempolicy(unsigned short mode, unsigned short flags,
+			     nodemask_t *nodes)
 {
 	struct mempolicy *new;
 
 	if (mpol_check_policy(mode, nodes))
 		return -EINVAL;
-	new = mpol_new(mode, nodes);
+	new = mpol_new(mode, flags, nodes);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 	mpol_free(current->mempolicy);
@@ -595,7 +598,7 @@ static long do_get_mempolicy(int *policy, nodemask_t *nmask,
 			goto out;
 		}
 	} else
-		*policy = pol->policy;
+		*policy = pol->policy | pol->flags;
 
 	if (vma) {
 		up_read(&current->mm->mmap_sem);
@@ -785,8 +788,8 @@ static struct page *new_vma_page(struct page *page, unsigned long private, int *
 #endif
 
 static long do_mbind(unsigned long start, unsigned long len,
-		     unsigned short mode, nodemask_t *nmask,
-		     unsigned long flags)
+		     unsigned short mode, unsigned short mode_flags,
+		     nodemask_t *nmask, unsigned long flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
@@ -818,7 +821,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (mpol_check_policy(mode, nmask))
 		return -EINVAL;
 
-	new = mpol_new(mode, nmask);
+	new = mpol_new(mode, mode_flags, nmask);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
@@ -829,8 +832,9 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (!new)
 		flags |= MPOL_MF_DISCONTIG_OK;
 
-	pr_debug("mbind %lx-%lx mode:%d nodes:%lx\n",start,start+len,
-		 mode, nmask ? nodes_addr(*nmask)[0] : -1);
+	pr_debug("mbind %lx-%lx mode:%d flags:%d nodes:%lx\n",
+		 start, start + len, mode, mode_flags,
+		 nmask ? nodes_addr(*nmask)[0] : -1);
 
 	down_write(&mm->mmap_sem);
 	vma = check_range(mm, start, end, nmask,
@@ -929,13 +933,16 @@ asmlinkage long sys_mbind(unsigned long start, unsigned long len,
 {
 	nodemask_t nodes;
 	int err;
+	unsigned short mode_flags;
 
+	mode_flags = mode & MPOL_MODE_FLAGS;
+	mode &= ~MPOL_MODE_FLAGS;
 	if (mode >= MPOL_MAX)
 		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
-	return do_mbind(start, len, mode, &nodes, flags);
+	return do_mbind(start, len, mode, mode_flags, &nodes, flags);
 }
 
 /* Set the process memory policy */
@@ -944,13 +951,16 @@ asmlinkage long sys_set_mempolicy(int mode, unsigned long __user *nmask,
 {
 	int err;
 	nodemask_t nodes;
+	unsigned short flags;
 
-	if (mode < 0 || mode >= MPOL_MAX)
+	flags = mode & MPOL_MODE_FLAGS;
+	mode &= ~MPOL_MODE_FLAGS;
+	if ((unsigned int)mode >= MPOL_MAX)
 		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
-	return do_set_mempolicy(mode, &nodes);
+	return do_set_mempolicy(mode, flags, &nodes);
 }
 
 asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
@@ -1640,7 +1650,7 @@ restart:
 }
 
 void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
-				nodemask_t *policy_nodes)
+			unsigned short flags, nodemask_t *policy_nodes)
 {
 	info->root = RB_ROOT;
 	spin_lock_init(&info->lock);
@@ -1649,7 +1659,7 @@ void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
 		struct mempolicy *newpol;
 
 		/* Falls back to MPOL_DEFAULT on any error */
-		newpol = mpol_new(policy, policy_nodes);
+		newpol = mpol_new(policy, flags, policy_nodes);
 		if (!IS_ERR(newpol)) {
 			/* Create pseudo-vma that contains just the policy */
 			struct vm_area_struct pvma;
@@ -1670,9 +1680,10 @@ int mpol_set_shared_policy(struct shared_policy *info,
 	struct sp_node *new = NULL;
 	unsigned long sz = vma_pages(vma);
 
-	pr_debug("set_shared_policy %lx sz %lu %d %lx\n",
+	pr_debug("set_shared_policy %lx sz %lu %d %d %lx\n",
 		 vma->vm_pgoff,
-		 sz, npol? npol->policy : -1,
+		 sz, npol ? npol->policy : -1,
+		 npol ? npol->flags : -1,
 		 npol ? nodes_addr(npol->v.nodes)[0] : -1);
 
 	if (npol) {
@@ -1745,14 +1756,14 @@ void __init numa_policy_init(void)
 	if (unlikely(nodes_empty(interleave_nodes)))
 		node_set(prefer, interleave_nodes);
 
-	if (do_set_mempolicy(MPOL_INTERLEAVE, &interleave_nodes))
+	if (do_set_mempolicy(MPOL_INTERLEAVE, 0, &interleave_nodes))
 		printk("numa_policy_init: interleaving failed\n");
 }
 
 /* Reset policy of current process to default */
 void numa_default_policy(void)
 {
-	do_set_mempolicy(MPOL_DEFAULT, NULL);
+	do_set_mempolicy(MPOL_DEFAULT, 0, NULL);
 }
 
 /* Migrate a policy to a different set of nodes */
diff --git a/mm/shmem.c b/mm/shmem.c
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1083,9 +1083,10 @@ redirty:
 #ifdef CONFIG_NUMA
 #ifdef CONFIG_TMPFS
 static int shmem_parse_mpol(char *value, unsigned short *policy,
-			    nodemask_t *policy_nodes)
+			unsigned short *mode_flags, nodemask_t *policy_nodes)
 {
 	char *nodelist = strchr(value, ':');
+	char *flags = strchr(value, '=');
 	int err = 1;
 
 	if (nodelist) {
@@ -1096,6 +1097,8 @@ static int shmem_parse_mpol(char *value, unsigned short *policy,
 		if (!nodes_subset(*policy_nodes, node_states[N_HIGH_MEMORY]))
 			goto out;
 	}
+	if (flags)
+		*flags++ = '\0';
 	if (!strcmp(value, "default")) {
 		*policy = MPOL_DEFAULT;
 		/* Don't allow a nodelist */
@@ -1125,6 +1128,8 @@ static int shmem_parse_mpol(char *value, unsigned short *policy,
 			*policy_nodes = node_states[N_HIGH_MEMORY];
 		err = 0;
 	}
+	if (flags) {
+	}
 out:
 	/* Restore string for error message */
 	if (nodelist)
@@ -1133,7 +1138,7 @@ out:
 }
 
 static void shmem_show_mpol(struct seq_file *seq, unsigned short policy,
-			    const nodemask_t policy_nodes)
+			unsigned short flags, const nodemask_t policy_nodes)
 {
 	char *policy_string;
 
@@ -1202,13 +1207,13 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
 static inline int shmem_parse_mpol(char *value, unsigned short *policy,
-						nodemask_t *policy_nodes)
+				unsigned short *flags, nodemask_t *policy_nodes)
 {
 	return 1;
 }
 
 static inline void shmem_show_mpol(struct seq_file *seq, unsigned short policy,
-			    const nodemask_t policy_nodes)
+			unsigned short flags, const nodemask_t policy_nodes)
 {
 }
 #endif /* CONFIG_TMPFS */
@@ -1578,7 +1583,7 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 			inode->i_op = &shmem_inode_operations;
 			inode->i_fop = &shmem_file_operations;
 			mpol_shared_policy_init(&info->policy, sbinfo->policy,
-							&sbinfo->policy_nodes);
+					sbinfo->flags, &sbinfo->policy_nodes);
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);
@@ -1592,7 +1597,7 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 			 * Must not load anything in the rbtree,
 			 * mpol_free_shared_policy will not be called.
 			 */
-			mpol_shared_policy_init(&info->policy, MPOL_DEFAULT,
+			mpol_shared_policy_init(&info->policy, MPOL_DEFAULT, 0,
 						NULL);
 			break;
 		}
@@ -2209,7 +2214,7 @@ static int shmem_parse_options(char *options, struct shmem_sb_info *sbinfo,
 				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
 			if (shmem_parse_mpol(value, &sbinfo->policy,
-					     &sbinfo->policy_nodes))
+				&sbinfo->flags, &sbinfo->policy_nodes))
 				goto bad_val;
 		} else {
 			printk(KERN_ERR "tmpfs: Bad mount option %s\n",
@@ -2261,6 +2266,7 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
 	sbinfo->policy      = config.policy;
+	sbinfo->flags       = config.flags;
 	sbinfo->policy_nodes = config.policy_nodes;
 out:
 	spin_unlock(&sbinfo->stat_lock);
@@ -2282,7 +2288,8 @@ static int shmem_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_printf(seq, ",uid=%u", sbinfo->uid);
 	if (sbinfo->gid != 0)
 		seq_printf(seq, ",gid=%u", sbinfo->gid);
-	shmem_show_mpol(seq, sbinfo->policy, sbinfo->policy_nodes);
+	shmem_show_mpol(seq, sbinfo->policy, sbinfo->flags,
+			sbinfo->policy_nodes);
 	return 0;
 }
 #endif /* CONFIG_TMPFS */
@@ -2313,6 +2320,7 @@ static int shmem_fill_super(struct super_block *sb,
 	sbinfo->uid = current->fsuid;
 	sbinfo->gid = current->fsgid;
 	sbinfo->policy = MPOL_DEFAULT;
+	sbinfo->flags = 0;
 	sbinfo->policy_nodes = node_states[N_HIGH_MEMORY];
 	sb->s_fs_info = sbinfo;
 
