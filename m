Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbXJ2PBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbXJ2PBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXJ2PBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:01:45 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:57060 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbXJ2PBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:01:43 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <Pine.LNX.4.64.0710261436070.18899@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	 <20071025185506.8c373aa8.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	 <1193412644.5032.13.camel@localhost>
	 <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	 <20071026120037.7b95a136.pj@sgi.com>
	 <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	 <1193433239.5032.95.camel@localhost>
	 <Pine.LNX.4.64.0710261415580.18139@schroedinger.engr.sgi.com>
	 <1193433992.5032.102.camel@localhost>
	 <Pine.LNX.4.64.0710261436070.18899@schroedinger.engr.sgi.com>
Content-Type: multipart/mixed; boundary="=-GVUp1qvFilvHsz6Z8EAl"
Organization: HP/OSLO
Date: Mon, 29 Oct 2007 11:00:56 -0400
Message-Id: <1193670056.5035.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GVUp1qvFilvHsz6Z8EAl
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2007-10-26 at 14:37 -0700, Christoph Lameter wrote:
> On Fri, 26 Oct 2007, Lee Schermerhorn wrote:
> 
> > > > Now, if we could replace the 'cpuset_mems_allowed' nodemask with a
> > > > pointer to something stable, it might be a win.
> > > 
> > > The memory policies are already shared and have refcounters for that 
> > > purpose.
> > 
> > I must have missed that in the code I'm reading :)
> 
> What is the benefit of having pointers to nodemasks? We likely would need 
> to have refcounts in those nodemasks too? So we duplicate a lot of 
> the characteristics of memory policies?

Hi, Christoph:

remoting the nodemasks from the mempolicy and allocating them only when
needed is something that you and Mel and I discussed last month, in the
context of Mel's "one zonelist filtered by nodemask" patches.  I just
put together the dynamic nodemask patch [included below FYI, NOT for
serious consideration] to see what it looked like and whether it helped.
Conclusion:  it's ugly/complex [especially trying to keep the nodemasks
embedded for systems that don't require > a pointer's worth of bits] and
they probably don't help much if most uses of non-default mempolicy
requires a nodemask.

I only brought it up again because now you all are considering another
nodemask per policy.  In fact, I only considered it in the first place
because nodemasks on our [HP's] platform don't require more than a
pointer's worth of bits [today, at least--I don't know about future
plans].  However, since we share an arch--ia64-with SGI and distros
don't want to support special kernels for different vendors, if they can
avoid it, we have 1K-bit nodemasks.   Since this is ia64 we're talking
about, most folks don't care.  Now that you're going to do the same for
x86_64, it might become more visible.  Then again, maybe there are few
enough mempolicy structs that no-one will care anyway.

Note:  I don't [didn't] think I need to ref count the nodemasks
associated with the mempolicies because they are allocated when the
mempolicy is and destroyed when the policy is--not shared.  Just like
the custom zonelist for bind policy, and we have no ref count there.
I.e., they're protected by the mempol's ref.  However, now that you
bring it up, I'm wondering about the effects of policy remapping, and
whether we have the reference counting or indirect protection [mmap_sem,
whatever] correct there in current code.  I'll have to take a look.

Lee

--=-GVUp1qvFilvHsz6Z8EAl
Content-Disposition: attachment; filename=dynamically-allocate-mempolicy-nodemasks.patch
Content-Type: text/x-patch; name=dynamically-allocate-mempolicy-nodemasks.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

PATCH/RFC Memory Policy:  dynamically allocate policy nodemaps

Something that Christoph Lameter, Mel Gorman and I discussed.
Once Mel's "one zonelist" patches go in, we no longer have the
MPOL_BIND custom zonelist in the mempolicy struct.  However, we
still have 2 nodemask_t's that can get quite large:  one in the
union with the preferred_node, and one for the cpuset current
mems allowed.  Note that this 2nd nodemask_t does NOT depend on
whether or not cpusets are configured.

So, on an ia64 platform with NODES_SHIFT configured at 8 [256 nodes],
this results in a nodemask_t size of 32 bytes and a mempolicy size
of 72 bytes.  Real soon now, we'll be seeing x86_64 platforms with
hundreds of nodes.  Indirect/dynamically allocated policy nodemasks
can reduce this size, for policies that don't need them, to:
TODO

[Some distros ship with NODES_SHIFT=10 => 128 byte nodemasks.]

However, on platforms and configurations where BITS_PER_LONG >=
(1 << NODES_SHIFT),  indirect policy nodemasks are unnecessary 
overhead, as the maximum number of nodes will fit in a pointers
worth of data.

So, this patch implements indirect, dynamically allocated nodemasks
for memory policies  when:  BITS_PER_LONG < (1 << NODES_SHIFT).

etc...

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 include/linux/mempolicy.h |   20 +++++-
 mm/mempolicy.c            |  134 ++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 135 insertions(+), 19 deletions(-)

Index: Linux/include/linux/mempolicy.h
===================================================================
--- Linux.orig/include/linux/mempolicy.h	2007-10-02 14:11:20.000000000 -0400
+++ Linux/include/linux/mempolicy.h	2007-10-02 16:07:43.000000000 -0400
@@ -47,6 +47,12 @@ struct mm_struct;
 
 #ifdef CONFIG_NUMA
 
+#if BITS_PER_LONG < (1 << NODES_SHIFT)
+#define INDIRECT_POLICY_NODEMASK 1
+#else
+#define INDIRECT_POLICY_NODEMASK 0
+#endif
+
 /*
  * Describe a memory policy.
  *
@@ -71,11 +77,19 @@ struct mempolicy {
 	atomic_t refcnt;
 	short policy; 	/* See MPOL_* above */
 	union {
-		short 		 preferred_node; /* preferred */
-		nodemask_t	 nodes;		/* interleave/bind */
+		short 		preferred_node;	/* preferred */
+#if INDIRECT_POLICY_NODEMASK
+		nodemask_t	*nodes;		/* interleave/bind */
+#else
+		nodemask_t	nodes;		/* interleave/bind */
+#endif
 		/* undefined for default */
 	} v;
-	nodemask_t cpuset_mems_allowed;	/* mempolicy relative to these nodes */
+#if INDIRECT_POLICY_NODEMASK
+	nodemask_t *cpuset_mems_allowed; /* mempolicy relative to these nodes */
+#else
+	nodemask_t cpuset_mems_allowed; /* mempolicy relative to these nodes */
+#endif
 };
 
 /*
Index: Linux/mm/mempolicy.c
===================================================================
--- Linux.orig/mm/mempolicy.c	2007-10-02 14:12:35.000000000 -0400
+++ Linux/mm/mempolicy.c	2007-10-02 17:18:24.000000000 -0400
@@ -100,6 +100,7 @@
 
 static struct kmem_cache *policy_cache;
 static struct kmem_cache *sn_cache;
+static struct kmem_cache *nodemask_cache;
 
 /* Highest zone. An specific allocation for a zone below that is not
    policied. */
@@ -158,10 +159,68 @@ static int is_valid_nodemask(nodemask_t 
 	return 0;
 }
 
+#if INDIRECT_POLICY_NODEMASK
+/*
+ * mempolicy operations for indirect policy nodemasks
+ * operate on pointers to nodemask_t pointers in mempolicy struct
+ */
+static int set_policy_nodemask(nodemask_t **pol_nodes, nodemask_t *nodes)
+{
+	**pol_nodes = *nodes;
+	return 0;
+}
+
+static int new_policy_nodemask(nodemask_t **pol_nodes, nodemask_t *nodes)
+{
+	*pol_nodes = kmem_cache_alloc(nodemask_cache, GFP_KERNEL);
+	if (!*pol_nodes)
+		return -ENOMEM;
+	return set_policy_nodemask(pol_nodes, nodes);
+}
+
+static nodemask_t *policy_nodemask_ref(nodemask_t **pol_nodes)
+{
+	return *pol_nodes;
+}
+
+static void free_policy_nodemask(nodemask_t **pol_nodes)
+{
+	kmem_cache_free(nodemask_cache, *pol_nodes);
+}
+
+#else
+
+/*
+ * mempolicy operations for embedded policy nodemasks
+ * operate on pointers to nodemasks embedded in mempolicy structs
+ */
+static int set_policy_nodemask(nodemask_t *pol_nodes, nodemask_t *nodes)
+{
+	*policy->v.nodes = *nodes;
+	return 0;
+}
+
+static int new_policy_nodemask(nodemask_t *pol_nodes, nodemask_t *nodes)
+{
+	return set_policy_nodemask(pol_nodes, nodes);
+}
+
+static nodemask_t *policy_nodemask_ref(nodemask_t *pol_nodes)
+{
+	return pol_nodes;
+}
+
+static void free_policy_nodemask(nodemask_t *pol_nodes)
+{
+}
+#endif
+
 /* Create a new policy */
 static struct mempolicy *mpol_new(int mode, nodemask_t *nodes)
 {
 	struct mempolicy *policy;
+	nodemask_t mems_allowed;
+	int ret;
 
 	pr_debug("setting mode %d nodes[0] %lx\n",
 		 mode, nodes ? nodes_addr(*nodes)[0] : -1);
@@ -175,14 +234,18 @@ static struct mempolicy *mpol_new(int mo
 	atomic_set(&policy->refcnt, 1);
 	switch (mode) {
 	case MPOL_INTERLEAVE:
-		policy->v.nodes = *nodes;
+		ret = new_policy_nodemask(&policy->v.nodes, nodes);
+		if (ret)
+			return ERR_PTR(ret);
 		if (nodes_weight(*nodes) == 0) {
 			mode |= MPOL_CONTEXT;
 			break;
 		}
-		nodes_and(policy->v.nodes, policy->v.nodes,
+		nodes_and(*policy_nodemask_ref(&policy->v.nodes),
+				*policy_nodemask_ref(&policy->v.nodes),
 					node_states[N_HIGH_MEMORY]);
-		if (nodes_weight(policy->v.nodes) == 0) {
+		if (nodes_weight(*policy_nodemask_ref(&policy->v.nodes)) == 0) {
+			free_policy_nodemask(&policy->v.nodes);
 			kmem_cache_free(policy_cache, policy);
 			return ERR_PTR(-EINVAL);
 		}
@@ -197,11 +260,21 @@ static struct mempolicy *mpol_new(int mo
 			kmem_cache_free(policy_cache, policy);
 			return ERR_PTR(-EINVAL);
 		}
-		policy->v.nodes = *nodes;
+		ret = new_policy_nodemask(&policy->v.nodes, nodes);
+		if (ret)
+			return ERR_PTR(ret);
 		break;
 	}
 	policy->policy = mode;
-	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
+
+//TODO:  I ought to be able to figure out how to reference the
+//       mems_allowed [current task's or node_possible_map] w/o
+//       allocating a new copy.  Need more helper function?
+	mems_allowed = cpuset_mems_allowed(current);
+	ret = new_policy_nodemask(&policy->cpuset_mems_allowed,
+					 		&mems_allowed);
+	if (ret)
+		return ERR_PTR(ret);
 	return policy;
 }
 
@@ -464,7 +537,7 @@ static nodemask_t *get_interleave_nodes(
 	if (unlikely(p->policy & MPOL_CONTEXT))
 		return &cpuset_current_mems_allowed;
 
-	return &p->v.nodes;
+	return policy_nodemask_ref(&p->v.nodes);
 }
 
 /* Set the process memory policy */
@@ -1135,8 +1208,8 @@ static inline nodemask_t *nodemask_polic
 	/* Lower zones don't get a nodemask applied for MPOL_BIND */
 	if (unlikely(policy->policy == MPOL_BIND &&
 			gfp_zone(gfp) >= policy_zone &&
-			cpuset_nodemask_valid_mems_allowed(&policy->v.nodes)))
-		return &policy->v.nodes;
+			cpuset_nodemask_valid_mems_allowed(policy_nodemask_ref(&policy->v.nodes))))
+		return policy_nodemask_ref(&policy->v.nodes);
 
 	return NULL;
 }
@@ -1200,8 +1273,9 @@ unsigned slab_node(struct mempolicy *pol
 		struct zoneref *z;
 		enum zone_type highest_zoneidx = gfp_zone(GFP_KERNEL);
 		zonelist = &NODE_DATA(numa_node_id())->node_zonelist;
-		z = first_zones_zonelist(zonelist, &policy->v.nodes,
-							highest_zoneidx);
+		z = first_zones_zonelist(zonelist,
+					policy_nodemask_ref(&policy->v.nodes),
+					highest_zoneidx);
 		return zonelist_node_idx(z);
 	}
 
@@ -1421,7 +1495,25 @@ struct mempolicy *__mpol_copy(struct mem
 		nodemask_t mems = cpuset_mems_allowed(current);
 		mpol_rebind_policy(old, &mems);
 	}
-	*new = *old;
+
+	/*
+	 * need to copy members explicitly to handle indirect vs
+	 * embedded nodemasks
+	 */
+	new->policy = old->policy;
+	switch (policy_mode(old)) {
+	case MPOL_PREFERRED:
+		new->v.preferred_node = old->v.preferred_node;
+		break;
+
+	case MPOL_BIND:
+		/*FALL THROUGH*/
+	case MPOL_INTERLEAVE:
+		new_policy_nodemask(&new->v.nodes,
+					policy_nodemask_ref(&old->v.nodes));
+	}
+	new_policy_nodemask(&new->cpuset_mems_allowed,
+				policy_nodemask_ref(&old->cpuset_mems_allowed));
 	atomic_set(&new->refcnt, 1);
 	return new;
 }
@@ -1441,7 +1533,9 @@ int __mpol_equal(struct mempolicy *a, st
 		 * works for MPOL_BIND as it shouldn't have MPOL_CONTEXT set
 		 */
 		return a->policy & MPOL_CONTEXT ||
-				nodes_equal(a->v.nodes, b->v.nodes);
+				nodes_equal(
+					*policy_nodemask_ref(&a->v.nodes),
+					*policy_nodemask_ref(&b->v.nodes));
 	case MPOL_PREFERRED:
 		return a->v.preferred_node == b->v.preferred_node;
 	default:
@@ -1455,6 +1549,8 @@ void __mpol_free(struct mempolicy *p)
 {
 	if (!atomic_dec_and_test(&p->refcnt))
 		return;
+	free_policy_nodemask(&p->v.nodes);
+	free_policy_nodemask(&p->cpuset_mems_allowed);
 	kmem_cache_free(policy_cache, p);
 }
 
@@ -1646,7 +1742,8 @@ int mpol_set_shared_policy(struct shared
 	pr_debug("set_shared_policy %lx sz %lu %d %lx\n",
 		 vma->vm_pgoff,
 		 sz, npol? npol->policy : -1,
-		 npol ? nodes_addr(npol->v.nodes)[0] : -1);
+		 npol ? nodes_addr(*policy_nodemask_ref(&npol->v.nodes))[0] :
+			-1);
 
 	if (npol) {
 		new = sp_alloc(vma->vm_pgoff, vma->vm_pgoff + sz, npol);
@@ -1694,6 +1791,10 @@ void __init numa_policy_init(void)
 				     sizeof(struct sp_node),
 				     0, SLAB_PANIC, NULL);
 
+	if (INDIRECT_POLICY_NODEMASK)
+		nodemask_cache = kmem_cache_create("nodemask",
+					     sizeof(nodemask_t),
+					     0, SLAB_PANIC, NULL);
 	/*
 	 * Set interleaving policy for system init. Interleaving is only
 	 * enabled across suitably sized nodes (default is >= 16MB), or
@@ -1738,7 +1839,7 @@ static void mpol_rebind_policy(struct me
 
 	if (!pol)
 		return;
-	mpolmask = &pol->cpuset_mems_allowed;
+	mpolmask = policy_nodemask_ref(&pol->cpuset_mems_allowed);
 	if (nodes_equal(*mpolmask, *newmask))
 		return;
 
@@ -1746,8 +1847,9 @@ static void mpol_rebind_policy(struct me
 	case MPOL_BIND:
 		/* Fall through */
 	case MPOL_INTERLEAVE:
-		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
-		pol->v.nodes = tmp;
+		nodes_remap(tmp, *policy_nodemask_ref(&pol->v.nodes),
+				 *mpolmask, *newmask);
+		set_policy_nodemask(&pol->v.nodes, &tmp);
 		*mpolmask = *newmask;
 		current->il_next = node_remap(current->il_next,
 						*mpolmask, *newmask);

--=-GVUp1qvFilvHsz6Z8EAl--

