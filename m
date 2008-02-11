Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYBKPcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYBKPcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYBKPcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:32:08 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbYBKPcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:32:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=AjAYYNTsKJ4Vja12H/vcq3oQviwvw4x/DETAC0hui95pwvJDg7ONDMmS0p+2Ewf0M
	dsykb2w4+bKPZw04cHqCw==
Date: Mon, 11 Feb 2008 07:30:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch 2/4] mempolicy: support optional mode flags
In-Reply-To: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
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

With the small number of possible mempolicy modes (currently four) and
the large size of the struct mempolicy member that stores this mode
(unsigned short), it is possible to store both the mode and optional mode
flags in the same member.

To do this, it is necessary to mask off the optional mode flag bits when
testing the mempolicy mode.  A new constant, MPOL_FLAG_SHIFT, indicates
the shift necessary to find the flag bits within struct mempolicy's
policy member.  With this, MPOL_MODE_MASK can be defined to mask off the
optional flags, yielding just the mode itself.

A helper function:

	unsigned char mpol_mode(unsigned short mode)

has been implemented to return only a policy's mode.  Notice that the
return type is unsigned char since MPOL_FLAG_SHIFT is currently defined
at eight.  mpol_flags(unsigned short mode) does the inverse.

While this requires frequent use of mpol_mode() within the internal
mempolicy code, it is easy to distinguish between actuals that contain
only modes and those that contain the entire policy member (modes and
flags).  If the formal uses enum mempolicy_mode, only the mode itself
may successfully be passed because of type checking.

Note that this does not break userspace code that relies on
get_mempolicy(&policy, ...) and either 'switch (policy)' statements or
'if (policy == MPOL_INTERLEAVE)' statements.  Such applications would
need to use optional mode flags when calling set_mempolicy() or mbind()
for these previously implemented statements to stop working.  If an
application does start using optional mode flags, it will need to use
mpol_mode() in switch and conditional statements that only test mode.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/hugetlbfs/inode.c      |    2 +-
 include/linux/mempolicy.h |   39 +++++++++++++++++++++--
 mm/mempolicy.c            |   77 ++++++++++++++++++++++++++------------------
 mm/shmem.c                |   15 ++++++--
 4 files changed, 93 insertions(+), 40 deletions(-)

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
@@ -17,7 +17,18 @@ enum mempolicy_mode {
 	MPOL_MAX,	/* always last member of mempolicy_mode */
 };
 
-/* Flags for get_mem_policy */
+/*
+ * The lower MPOL_FLAG_SHIFT bits of the policy mode represent the MPOL_*
+ * constants defined in enum mempolicy_mode.  The upper bits represent
+ * optional set_mempolicy() MPOL_F_* mode flags.
+ */
+#define MPOL_FLAG_SHIFT	(8)
+#define MPOL_MODE_MASK	((1 << MPOL_FLAG_SHIFT) - 1)
+
+/* Flags for set_mempolicy */
+#define MPOL_MODE_FLAGS	(0)	/* legal set_mempolicy() MPOL_* mode flags */
+
+/* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
 #define MPOL_F_MEMS_ALLOWED (1<<2) /* return allowed memories */
@@ -115,6 +126,16 @@ static inline int mpol_equal(struct mempolicy *a, struct mempolicy *b)
 
 #define mpol_set_vma_default(vma) ((vma)->vm_policy = NULL)
 
+static inline unsigned char mpol_mode(unsigned short mode)
+{
+	return mode & MPOL_MODE_MASK;
+}
+
+static inline unsigned short mpol_flags(unsigned short mode)
+{
+	return mode & ~MPOL_MODE_MASK;
+}
+
 /*
  * Tree of shared policies for a shared memory region.
  * Maintain the policies in a pseudo mm that contains vmas. The vmas
@@ -135,7 +156,8 @@ struct shared_policy {
 };
 
 void mpol_shared_policy_init(struct shared_policy *info,
-		enum mempolicy_mode policy, nodemask_t *nodes);
+		enum mempolicy_mode policy, unsigned short flags,
+		nodemask_t *nodes);
 int mpol_set_shared_policy(struct shared_policy *info,
 				struct vm_area_struct *vma,
 				struct mempolicy *new);
@@ -176,6 +198,16 @@ static inline int mpol_equal(struct mempolicy *a, struct mempolicy *b)
 }
 #define vma_mpol_equal(a,b) 1
 
+static inline unsigned char mpol_mode(unsigned short mode)
+{
+	return 0;
+}
+
+static inline unsigned short mpol_flags(unsigned short mode)
+{
+	return 0;
+}
+
 #define mpol_set_vma_default(vma) do {} while(0)
 
 static inline void mpol_free(struct mempolicy *p)
@@ -201,7 +233,8 @@ static inline int mpol_set_shared_policy(struct shared_policy *info,
 }
 
 static inline void mpol_shared_policy_init(struct shared_policy *info,
-			enum mempolicy_type policy, nodemask_t *nodes)
+			enum mempolicy_type policy, unsigned short flags,
+			nodemask_t *nodes)
 {
 }
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -203,18 +203,20 @@ static struct zonelist *bind_zonelist(nodemask_t *nodes)
 }
 
 /* Create a new policy */
-static struct mempolicy *mpol_new(enum mempolicy_mode mode, nodemask_t *nodes)
+static struct mempolicy *mpol_new(enum mempolicy_mode mode,
+				  unsigned short flags, nodemask_t *nodes)
 {
 	struct mempolicy *policy;
 
-	pr_debug("setting mode %d nodes[0] %lx\n",
-		 mode, nodes ? nodes_addr(*nodes)[0] : -1);
+	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
+		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
 	if (mode == MPOL_DEFAULT)
 		return NULL;
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
+	flags &= MPOL_MODE_FLAGS;
 	atomic_set(&policy->refcnt, 1);
 	switch (mode) {
 	case MPOL_INTERLEAVE:
@@ -240,7 +242,7 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode, nodemask_t *nodes)
 	default:
 		BUG();
 	}
-	policy->policy = mode;
+	policy->policy = mode | flags;
 	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
 	return policy;
 }
@@ -483,19 +485,20 @@ static void mpol_set_task_struct_flag(void)
 }
 
 /* Set the process memory policy */
-static long do_set_mempolicy(enum mempolicy_mode mode, nodemask_t *nodes)
+static long do_set_mempolicy(enum mempolicy_mode mode, unsigned short flags,
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
 	current->mempolicy = new;
 	mpol_set_task_struct_flag();
-	if (new && new->policy == MPOL_INTERLEAVE)
+	if (new && mpol_mode(new->policy) == MPOL_INTERLEAVE)
 		current->il_next = first_node(new->v.nodes);
 	return 0;
 }
@@ -506,7 +509,7 @@ static void get_zonemask(struct mempolicy *p, nodemask_t *nodes)
 	int i;
 
 	nodes_clear(*nodes);
-	switch (p->policy) {
+	switch (mpol_mode(p->policy)) {
 	case MPOL_BIND:
 		for (i = 0; p->v.zonelist->zones[i]; i++)
 			node_set(zone_to_nid(p->v.zonelist->zones[i]),
@@ -588,7 +591,7 @@ static long do_get_mempolicy(int *policy, nodemask_t *nmask,
 				goto out;
 			*policy = err;
 		} else if (pol == current->mempolicy &&
-				pol->policy == MPOL_INTERLEAVE) {
+				mpol_mode(pol->policy) == MPOL_INTERLEAVE) {
 			*policy = current->il_next;
 		} else {
 			err = -EINVAL;
@@ -785,8 +788,8 @@ static struct page *new_vma_page(struct page *page, unsigned long private, int *
 #endif
 
 static long do_mbind(unsigned long start, unsigned long len,
-		     enum mempolicy_mode mode, nodemask_t *nmask,
-		     unsigned long flags)
+		     enum mempolicy_mode mode, unsigned short mode_flags,
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
 
+	mode_flags = mpol_flags(mode);
+	mode = mpol_mode(mode);
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
 
+	flags = mpol_flags(mode);
+	mode = mpol_mode(mode);
 	if (mode < 0 || mode >= MPOL_MAX)
 		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
-	return do_set_mempolicy(mode, &nodes);
+	return do_set_mempolicy(mode, flags, &nodes);
 }
 
 asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
@@ -1152,7 +1162,7 @@ static struct mempolicy * get_vma_policy(struct task_struct *task,
 			pol = vma->vm_ops->get_policy(vma, addr);
 			shared_pol = 1;	/* if pol non-NULL, add ref below */
 		} else if (vma->vm_policy &&
-				vma->vm_policy->policy != MPOL_DEFAULT)
+			   mpol_mode(vma->vm_policy->policy) != MPOL_DEFAULT)
 			pol = vma->vm_policy;
 	}
 	if (!pol)
@@ -1167,7 +1177,7 @@ static struct zonelist *zonelist_policy(gfp_t gfp, struct mempolicy *policy)
 {
 	int nd;
 
-	switch (policy->policy) {
+	switch (mpol_mode(policy->policy)) {
 	case MPOL_PREFERRED:
 		nd = policy->v.preferred_node;
 		if (nd < 0)
@@ -1211,7 +1221,8 @@ static unsigned interleave_nodes(struct mempolicy *policy)
  */
 unsigned slab_node(struct mempolicy *policy)
 {
-	enum mempolicy_mode pol = policy ? policy->policy : MPOL_DEFAULT;
+	enum mempolicy_mode pol = policy ? mpol_mode(policy->policy) :
+					   MPOL_DEFAULT;
 
 	switch (pol) {
 	case MPOL_INTERLEAVE:
@@ -1297,7 +1308,7 @@ struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
 	struct zonelist *zl;
 
 	*mpol = NULL;		/* probably no unref needed */
-	if (pol->policy == MPOL_INTERLEAVE) {
+	if (mpol_mode(pol->policy) == MPOL_INTERLEAVE) {
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
@@ -1307,7 +1318,7 @@ struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
 
 	zl = zonelist_policy(GFP_HIGHUSER, pol);
 	if (unlikely(pol != &default_policy && pol != current->mempolicy)) {
-		if (pol->policy != MPOL_BIND)
+		if (mpol_mode(pol->policy) != MPOL_BIND)
 			__mpol_free(pol);	/* finished with pol */
 		else
 			*mpol = pol;	/* unref needed after allocation */
@@ -1361,7 +1372,7 @@ alloc_page_vma(gfp_t gfp, struct vm_area_struct *vma, unsigned long addr)
 
 	cpuset_update_task_memory_state();
 
-	if (unlikely(pol->policy == MPOL_INTERLEAVE)) {
+	if (unlikely(mpol_mode(pol->policy) == MPOL_INTERLEAVE)) {
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
@@ -1409,7 +1420,7 @@ struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 		cpuset_update_task_memory_state();
 	if (!pol || in_interrupt() || (gfp & __GFP_THISNODE))
 		pol = &default_policy;
-	if (pol->policy == MPOL_INTERLEAVE)
+	if (mpol_mode(pol->policy) == MPOL_INTERLEAVE)
 		return alloc_page_interleave(gfp, order, interleave_nodes(pol));
 	return __alloc_pages(gfp, order, zonelist_policy(gfp, pol));
 }
@@ -1436,7 +1447,7 @@ struct mempolicy *__mpol_copy(struct mempolicy *old)
 	}
 	*new = *old;
 	atomic_set(&new->refcnt, 1);
-	if (new->policy == MPOL_BIND) {
+	if (mpol_mode(new->policy) == MPOL_BIND) {
 		int sz = ksize(old->v.zonelist);
 		new->v.zonelist = kmemdup(old->v.zonelist, sz, GFP_KERNEL);
 		if (!new->v.zonelist) {
@@ -1454,7 +1465,7 @@ int __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 		return 0;
 	if (a->policy != b->policy)
 		return 0;
-	switch (a->policy) {
+	switch (mpol_mode(a->policy)) {
 	case MPOL_DEFAULT:
 		return 1;
 	case MPOL_INTERLEAVE:
@@ -1479,7 +1490,7 @@ void __mpol_free(struct mempolicy *p)
 {
 	if (!atomic_dec_and_test(&p->refcnt))
 		return;
-	if (p->policy == MPOL_BIND)
+	if (mpol_mode(p->policy) == MPOL_BIND)
 		kfree(p->v.zonelist);
 	p->policy = MPOL_DEFAULT;
 	kmem_cache_free(policy_cache, p);
@@ -1640,7 +1651,8 @@ restart:
 }
 
 void mpol_shared_policy_init(struct shared_policy *info,
-		enum mempolicy_mode policy, nodemask_t *policy_nodes)
+		enum mempolicy_mode policy, unsigned short flags,
+		nodemask_t *policy_nodes)
 {
 	info->root = RB_ROOT;
 	spin_lock_init(&info->lock);
@@ -1649,7 +1661,7 @@ void mpol_shared_policy_init(struct shared_policy *info,
 		struct mempolicy *newpol;
 
 		/* Falls back to MPOL_DEFAULT on any error */
-		newpol = mpol_new(policy, policy_nodes);
+		newpol = mpol_new(policy, flags, policy_nodes);
 		if (!IS_ERR(newpol)) {
 			/* Create pseudo-vma that contains just the policy */
 			struct vm_area_struct pvma;
@@ -1745,14 +1757,14 @@ void __init numa_policy_init(void)
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
@@ -1768,7 +1780,7 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 	if (nodes_equal(*mpolmask, *newmask))
 		return;
 
-	switch (pol->policy) {
+	switch (mpol_mode(pol->policy)) {
 	case MPOL_DEFAULT:
 		break;
 	case MPOL_INTERLEAVE:
@@ -1858,7 +1870,8 @@ static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 	char *p = buffer;
 	int l;
 	nodemask_t nodes;
-	enum mempolicy_mode mode = pol ? pol->policy : MPOL_DEFAULT;
+	enum mempolicy_mode mode = pol ? mpol_mode(pol->policy) :
+					 MPOL_DEFAULT;
 
 	switch (mode) {
 	case MPOL_DEFAULT:
diff --git a/mm/shmem.c b/mm/shmem.c
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1086,6 +1086,7 @@ static int shmem_parse_mpol(char *value, unsigned short *policy,
 			    nodemask_t *policy_nodes)
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
@@ -1154,7 +1159,7 @@ static void shmem_show_mpol(struct seq_file *seq, enum mempolicy_mode policy,
 
 	seq_printf(seq, ",mpol=%s", policy_string);
 
-	if (policy != MPOL_INTERLEAVE ||
+	if (mpol_mode(policy) != MPOL_INTERLEAVE ||
 	    !nodes_equal(policy_nodes, node_states[N_HIGH_MEMORY])) {
 		char buffer[64];
 		int len;
@@ -1577,8 +1582,10 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 		case S_IFREG:
 			inode->i_op = &shmem_inode_operations;
 			inode->i_fop = &shmem_file_operations;
-			mpol_shared_policy_init(&info->policy, sbinfo->policy,
-							&sbinfo->policy_nodes);
+			mpol_shared_policy_init(&info->policy,
+						mpol_mode(sbinfo->policy),
+						mpol_flags(sbinfo->policy),
+						&sbinfo->policy_nodes);
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);
@@ -1592,7 +1599,7 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 			 * Must not load anything in the rbtree,
 			 * mpol_free_shared_policy will not be called.
 			 */
-			mpol_shared_policy_init(&info->policy, MPOL_DEFAULT,
+			mpol_shared_policy_init(&info->policy, MPOL_DEFAULT, 0,
 						NULL);
 			break;
 		}
