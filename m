Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYBKPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYBKPbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYBKPbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:31:03 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45314 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYBKPbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:31:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	user-agent:mime-version:content-type;
	b=yjzhovj9Mr33x8FT0UfQKh8tiDoOFTVufwFO6TcAXSkvppGERYGSkRfKOIJ5NAnS/
	zW41SJdDvI8bj7/NGk7PQ==
Date: Mon, 11 Feb 2008 07:30:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch 1/4] mempolicy: convert MPOL constants to enum
Message-ID: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mempolicy mode constants, MPOL_DEFAULT, MPOL_PREFERRED, MPOL_BIND,
and MPOL_INTERLEAVE, are better declared as part of an enum for type
checking.

The policy member of struct mempolicy is also converted from type short
to type unsigned short.  A negative policy does not have any legitimate
meaning, so it is possible to change its type in preparation for adding
optional mode flags later.

The equivalent member of struct shmem_sb_info is also changed from int
to unsigned short.

For compatibility, the policy formal to get_mempolicy() remains as a
pointer to an int:

	int get_mempolicy(int *policy, unsigned long *nmask,
			  unsigned long maxnode, unsigned long addr,
			  unsigned long flags);

although the only possible values is the range of type unsigned short.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Applies on top of V3 of Lee Schermerhorn's mempolicy patch posted to
 LKML on February 8.

 include/linux/mempolicy.h |   21 +++++++++++----------
 include/linux/shmem_fs.h  |    2 +-
 mm/mempolicy.c            |   29 +++++++++++++++++------------
 mm/shmem.c                |   11 ++++++-----
 4 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -9,12 +9,13 @@
  */
 
 /* Policies */
-#define MPOL_DEFAULT	0
-#define MPOL_PREFERRED	1
-#define MPOL_BIND	2
-#define MPOL_INTERLEAVE	3
-
-#define MPOL_MAX MPOL_INTERLEAVE
+enum mempolicy_mode {
+	MPOL_DEFAULT,
+	MPOL_PREFERRED,
+	MPOL_BIND,
+	MPOL_INTERLEAVE,
+	MPOL_MAX,	/* always last member of mempolicy_mode */
+};
 
 /* Flags for get_mem_policy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
@@ -62,7 +63,7 @@ struct mm_struct;
  */
 struct mempolicy {
 	atomic_t refcnt;
-	short policy; 	/* See MPOL_* above */
+	unsigned short policy; 	/* See MPOL_* above */
 	union {
 		struct zonelist  *zonelist;	/* bind */
 		short 		 preferred_node; /* preferred */
@@ -133,8 +134,8 @@ struct shared_policy {
 	spinlock_t lock;
 };
 
-void mpol_shared_policy_init(struct shared_policy *info, int policy,
-				nodemask_t *nodes);
+void mpol_shared_policy_init(struct shared_policy *info,
+		enum mempolicy_mode policy, nodemask_t *nodes);
 int mpol_set_shared_policy(struct shared_policy *info,
 				struct vm_area_struct *vma,
 				struct mempolicy *new);
@@ -200,7 +201,7 @@ static inline int mpol_set_shared_policy(struct shared_policy *info,
 }
 
 static inline void mpol_shared_policy_init(struct shared_policy *info,
-					int policy, nodemask_t *nodes)
+			enum mempolicy_type policy, nodemask_t *nodes)
 {
 }
 
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -34,7 +34,7 @@ struct shmem_sb_info {
 	uid_t uid;		    /* Mount uid for root directory */
 	gid_t gid;		    /* Mount gid for root directory */
 	mode_t mode;		    /* Mount mode for root directory */
-	int policy;		    /* Default NUMA memory alloc policy */
+	unsigned short policy;	    /* Default NUMA memory alloc policy */
 	nodemask_t policy_nodes;    /* nodemask for preferred and bind */
 };
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -114,7 +114,7 @@ static void mpol_rebind_policy(struct mempolicy *pol,
                                const nodemask_t *newmask);
 
 /* Do sanity checking on a policy */
-static int mpol_check_policy(int mode, nodemask_t *nodes)
+static int mpol_check_policy(enum mempolicy_mode mode, nodemask_t *nodes)
 {
 	int was_empty, is_empty;
 
@@ -159,6 +159,8 @@ static int mpol_check_policy(int mode, nodemask_t *nodes)
 		if (!was_empty && is_empty)
 			return -EINVAL;
 		break;
+	default:
+		BUG();
 	}
 	return 0;
 }
@@ -201,7 +203,7 @@ static struct zonelist *bind_zonelist(nodemask_t *nodes)
 }
 
 /* Create a new policy */
-static struct mempolicy *mpol_new(int mode, nodemask_t *nodes)
+static struct mempolicy *mpol_new(enum mempolicy_mode mode, nodemask_t *nodes)
 {
 	struct mempolicy *policy;
 
@@ -235,6 +237,8 @@ static struct mempolicy *mpol_new(int mode, nodemask_t *nodes)
 			return error_code;
 		}
 		break;
+	default:
+		BUG();
 	}
 	policy->policy = mode;
 	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
@@ -479,7 +483,7 @@ static void mpol_set_task_struct_flag(void)
 }
 
 /* Set the process memory policy */
-static long do_set_mempolicy(int mode, nodemask_t *nodes)
+static long do_set_mempolicy(enum mempolicy_mode mode, nodemask_t *nodes)
 {
 	struct mempolicy *new;
 
@@ -781,7 +785,7 @@ static struct page *new_vma_page(struct page *page, unsigned long private, int *
 #endif
 
 static long do_mbind(unsigned long start, unsigned long len,
-		     unsigned long mode, nodemask_t *nmask,
+		     enum mempolicy_mode mode, nodemask_t *nmask,
 		     unsigned long flags)
 {
 	struct vm_area_struct *vma;
@@ -791,9 +795,8 @@ static long do_mbind(unsigned long start, unsigned long len,
 	int err;
 	LIST_HEAD(pagelist);
 
-	if ((flags & ~(unsigned long)(MPOL_MF_STRICT |
+	if (flags & ~(unsigned long)(MPOL_MF_STRICT |
 				      MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
-	    || mode > MPOL_MAX)
 		return -EINVAL;
 	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
 		return -EPERM;
@@ -826,7 +829,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (!new)
 		flags |= MPOL_MF_DISCONTIG_OK;
 
-	pr_debug("mbind %lx-%lx mode:%ld nodes:%lx\n",start,start+len,
+	pr_debug("mbind %lx-%lx mode:%d nodes:%lx\n",start,start+len,
 		 mode, nmask ? nodes_addr(*nmask)[0] : -1);
 
 	down_write(&mm->mmap_sem);
@@ -927,6 +930,8 @@ asmlinkage long sys_mbind(unsigned long start, unsigned long len,
 	nodemask_t nodes;
 	int err;
 
+	if (mode >= MPOL_MAX)
+		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
@@ -940,7 +945,7 @@ asmlinkage long sys_set_mempolicy(int mode, unsigned long __user *nmask,
 	int err;
 	nodemask_t nodes;
 
-	if (mode < 0 || mode > MPOL_MAX)
+	if (mode < 0 || mode >= MPOL_MAX)
 		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
@@ -1206,7 +1211,7 @@ static unsigned interleave_nodes(struct mempolicy *policy)
  */
 unsigned slab_node(struct mempolicy *policy)
 {
-	int pol = policy ? policy->policy : MPOL_DEFAULT;
+	enum mempolicy_mode pol = policy ? policy->policy : MPOL_DEFAULT;
 
 	switch (pol) {
 	case MPOL_INTERLEAVE:
@@ -1634,8 +1639,8 @@ restart:
 	return 0;
 }
 
-void mpol_shared_policy_init(struct shared_policy *info, int policy,
-				nodemask_t *policy_nodes)
+void mpol_shared_policy_init(struct shared_policy *info,
+		enum mempolicy_mode policy, nodemask_t *policy_nodes)
 {
 	info->root = RB_ROOT;
 	spin_lock_init(&info->lock);
@@ -1853,7 +1858,7 @@ static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 	char *p = buffer;
 	int l;
 	nodemask_t nodes;
-	int mode = pol ? pol->policy : MPOL_DEFAULT;
+	enum mempolicy_mode mode = pol ? pol->policy : MPOL_DEFAULT;
 
 	switch (mode) {
 	case MPOL_DEFAULT:
diff --git a/mm/shmem.c b/mm/shmem.c
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1082,7 +1082,8 @@ redirty:
 
 #ifdef CONFIG_NUMA
 #ifdef CONFIG_TMPFS
-static int shmem_parse_mpol(char *value, int *policy, nodemask_t *policy_nodes)
+static int shmem_parse_mpol(char *value, unsigned short *policy,
+			    nodemask_t *policy_nodes)
 {
 	char *nodelist = strchr(value, ':');
 	int err = 1;
@@ -1131,7 +1132,7 @@ out:
 	return err;
 }
 
-static void shmem_show_mpol(struct seq_file *seq, int policy,
+static void shmem_show_mpol(struct seq_file *seq, enum mempolicy_mode policy,
 			    const nodemask_t policy_nodes)
 {
 	char *policy_string;
@@ -1200,14 +1201,14 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
-static inline int shmem_parse_mpol(char *value, int *policy,
+static inline int shmem_parse_mpol(char *value, unsigned short *policy,
 						nodemask_t *policy_nodes)
 {
 	return 1;
 }
 
-static inline void shmem_show_mpol(struct seq_file *seq, int policy,
-			    const nodemask_t policy_nodes)
+static inline void shmem_show_mpol(struct seq_file *seq,
+		enum mempolicy_mode policy, const nodemask_t policy_nodes)
 {
 }
 #endif /* CONFIG_TMPFS */
