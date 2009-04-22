Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZDVHCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZDVHCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZDVHCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:02:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41749 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZDVHCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:02:08 -0400
Date: Wed, 22 Apr 2009 10:02:06 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: "Luck, Tony" <tony.luck@intel.com>
cc: Christoph Lameter <cl@linux.com>, Nick Piggin <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "iwamatsu.nobuhiro@renesas.com" <iwamatsu.nobuhiro@renesas.com>
Subject: RE: linux-next ia64 build problems in slqb
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA39EC57AB7@orsmsx505.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0904220953040.20610@melkki.cs.Helsinki.FI>
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com> 
 <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com> 
 <alpine.DEB.1.10.0904211034550.19969@qirst.com> 
 <84144f020904211125v68b98df4ke1c04bc29df65fda@mail.gmail.com> 
 <57C9024A16AD2D4C97DC78E552063EA39EC57748@orsmsx505.amr.corp.intel.com>
 <84144f020904211207q736bfc44n4cd622536cd0a67@mail.gmail.com>
 <57C9024A16AD2D4C97DC78E552063EA39EC57AB7@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tue, 21 Apr 2009, Luck, Tony wrote:
> > One minor nit: the patch should define an empty static inline of
> > claim_remote_free_list() for the !SMP case. I can fix it at my end
> > before merging, though, if necessary.
> 
> Agreed.  It would be better to have an empty static inline than
> adding the noisy #ifdef SMP around every call to
> claim_remote_free_list() ... in fact some such #ifdef can be
> removed.
> 
> You could tag such a modified patch (attached) as:
> 
> Acked-by: Tony Luck <tony.luck@intel.com>

Thanks for the help! I went and merged the following patch and I hope I 
got all the patch attributions right. Paul, does this work for you as well?

			Pekka

>From d46f661ed791312ba008f862a601179c5c9f1e9c Mon Sep 17 00:00:00 2001
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Date: Wed, 22 Apr 2009 09:50:15 +0300
Subject: [PATCH] SLQB: Fix UP + NUMA build

This patch fixes the following build breakage which happens when CONFIG_NUMA is
enabled but CONFIG_SMP is disabled:

    CC      mm/slqb.o
  mm/slqb.c: In function '__slab_free':
  mm/slqb.c:1735: error: implicit declaration of function 'slab_free_to_remote'
  mm/slqb.c: In function 'kmem_cache_open':
  mm/slqb.c:2274: error: implicit declaration of function 'kmem_cache_dyn_array_free'
  mm/slqb.c:2275: warning: label 'error_cpu_array' defined but not used
  mm/slqb.c: In function 'kmem_cache_destroy':
  mm/slqb.c:2395: error: implicit declaration of function 'claim_remote_free_list'
  mm/slqb.c: In function 'kmem_cache_init':
  mm/slqb.c:2885: error: 'per_cpu__kmem_cpu_nodes' undeclared (first use in this function)
  mm/slqb.c:2885: error: (Each undeclared identifier is reported only once
  mm/slqb.c:2885: error: for each function it appears in.)
  mm/slqb.c:2886: error: 'kmem_cpu_cache' undeclared (first use in this function)
  make[1]: *** [mm/slqb.o] Error 1
  make: *** [mm] Error 2

As x86 Kconfig doesn't even allow this combination, one is tempted to think
it's an architecture Kconfig bug. But as it turns out, it's a perfecly 
valid configuration. Tony Luck explains:

  UP + NUMA is a special case of memory-only nodes.  There are some (crazy?)
  customers with problems that require very large amounts of memory, but not very
  much cpu horse power.  They buy large multi-node systems and populate all the
  nodes with as much memory as they can afford, but most nodes get zero cpus.

So lets fix that up.

[ tony.luck@intel.com: #ifdef cleanups ]
Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slqb.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
index 37949f5..0300a6d 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -1224,6 +1224,11 @@ static void claim_remote_free_list(struct kmem_cache *s,
 	slqb_stat_inc(l, CLAIM_REMOTE_LIST);
 	slqb_stat_add(l, CLAIM_REMOTE_LIST_OBJECTS, nr);
 }
+#else
+static inline void claim_remote_free_list(struct kmem_cache *s,
+					struct kmem_cache_list *l)
+{
+}
 #endif
 
 /*
@@ -1728,7 +1733,7 @@ static __always_inline void __slab_free(struct kmem_cache *s,
 			flush_free_list(s, l);
 
 	} else {
-#ifdef CONFIG_NUMA
+#ifdef CONFIG_SMP
 		/*
 		 * Freeing an object that was allocated on a remote node.
 		 */
@@ -1937,7 +1942,9 @@ static DEFINE_PER_CPU(struct kmem_cache_node, kmem_cpu_nodes); /* XXX per-nid */
 
 #ifdef CONFIG_NUMA
 static struct kmem_cache kmem_node_cache;
+#ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_node_cpus);
+#endif
 static DEFINE_PER_CPU(struct kmem_cache_node, kmem_node_nodes); /*XXX per-nid */
 #endif
 
@@ -2270,7 +2277,7 @@ static int kmem_cache_open(struct kmem_cache *s,
 error_nodes:
 	free_kmem_cache_nodes(s);
 error_node_array:
-#ifdef CONFIG_NUMA
+#if defined(CONFIG_NUMA) && defined(CONFIG_SMP)
 	kmem_cache_dyn_array_free(s->node_slab);
 error_cpu_array:
 #endif
@@ -2370,9 +2377,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
 		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
 		struct kmem_cache_list *l = &c->list;
 
-#ifdef CONFIG_SMP
 		claim_remote_free_list(s, l);
-#endif
 		flush_free_list_all(s, l);
 
 		WARN_ON(l->freelist.nr);
@@ -2595,9 +2600,7 @@ static void kmem_cache_trim_percpu(void *arg)
 	struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
 	struct kmem_cache_list *l = &c->list;
 
-#ifdef CONFIG_SMP
 	claim_remote_free_list(s, l);
-#endif
 	flush_free_list(s, l);
 #ifdef CONFIG_SMP
 	flush_remote_free_cache(s, c);
@@ -2881,11 +2884,11 @@ void __init kmem_cache_init(void)
 		n = &per_cpu(kmem_cache_nodes, i);
 		init_kmem_cache_node(&kmem_cache_cache, n);
 		kmem_cache_cache.node_slab[i] = n;
-
+#ifdef CONFIG_SMP
 		n = &per_cpu(kmem_cpu_nodes, i);
 		init_kmem_cache_node(&kmem_cpu_cache, n);
 		kmem_cpu_cache.node_slab[i] = n;
-
+#endif
 		n = &per_cpu(kmem_node_nodes, i);
 		init_kmem_cache_node(&kmem_node_cache, n);
 		kmem_node_cache.node_slab[i] = n;
-- 
1.5.6.3

