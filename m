Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZIRP4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZIRP4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZIRP4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:56:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52863 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZIRP4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:56:13 -0400
Date: Fri, 18 Sep 2009 16:56:18 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090918155618.GA1225@csn.ul.ie>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie> <1253186019.4975.32.camel@penberg-laptop> <20090917111828.GB7205@csn.ul.ie> <20090917114116.GL18404@wotan.suse.de> <20090917181831.GA714@csn.ul.ie> <20090917182842.GS18404@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090917182842.GS18404@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 08:28:42PM +0200, Nick Piggin wrote:
> On Thu, Sep 17, 2009 at 07:18:32PM +0100, Mel Gorman wrote:
> > > Ahh... it's pretty lame of me. Sachin has been a willing tester :(
> > > I have spent quite a few hours looking at it but I never found
> > > many good leads. Much appreciated if you can make more progress on
> > > it.
> > 
> > Nothing much so far. I've reproduced the problem based on 2.6.31 and slqb-core
> > from Pekka's tree but not a whole pile else. I don't know SLQB at all so the
> > investigation is fuzzy. It appears to initialise SLQB ok but crashes later when
> > setting up SCSI. Not 100% sure what the triggering event is but it might be
> > userspace starting up and other CPUs get involved, possibly corrupting lists.
> > 
> > This machine has two CPUs (0, 1) and two nodes with actual memory (2,3).
> > After applying a patch to kmem_cache_create, I see in the console
> > 
> > MEL::Creating cache pgd_cache CPU 0 Node 0
> > MEL::Creating cache pmd_cache CPU 0 Node 0
> > MEL::Creating cache pid_namespace CPU 0 Node 0
> > MEL::Creating cache shmem_inode_cache CPU 0 Node 0
> > MEL::Creating cache scsi_data_buffer CPU 1 Node 0
> > 
> > It crashes at this point during creation before the struct kmem_cache has
> > been allocated from kmem_cache_cache. Note it's kmem_cache_cache we are
> > failing to allocate from, not scsi_data_buffer.
> 
> Yes, it's crashing in kmem_cache_create, when trying to allocate from
> kmem_cache_cache.
> 
> I didn't get much further. I had thought something must be NULL or
> not set up correctly in kmem_cache_cache, but I didn't work out what.
> 

Somehow it's getting scrambled but I couldn't see anything wrong with
the locking. Weirdly, the following patch allows the kernel to boot much
further. Is it possible the DEFINE_PER_CPU() trick for defining per-node data
is being busted by recent per-cpu changes? Sorry that this is pretty crude,
it's my first proper reading of SLQB so it's slow going.

Although booting gets further with the following patch, it quickly hits
an OOM-storm until the machine dies with the vast majority of pages being
allocated by the slab allocator. There must be some flaw in the node fallback
logic that means that pages are allocated for every slab allocation.

diff --git a/mm/slqb.c b/mm/slqb.c
index 4ca85e2..4d72be2 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -1944,16 +1944,16 @@ static void init_kmem_cache_node(struct kmem_cache *s,
 static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_cache_cpus);
 #endif
 #ifdef CONFIG_NUMA
-/* XXX: really need a DEFINE_PER_NODE for per-node data, but this is better than
- * a static array */
-static DEFINE_PER_CPU(struct kmem_cache_node, kmem_cache_nodes);
+/* XXX: really need a DEFINE_PER_NODE for per-node data because a static
+ *      array is wasteful */
+static struct kmem_cache_node kmem_cache_nodes[MAX_NUMNODES];
 #endif
 
 #ifdef CONFIG_SMP
 static struct kmem_cache kmem_cpu_cache;
 static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_cpu_cpus);
 #ifdef CONFIG_NUMA
-static DEFINE_PER_CPU(struct kmem_cache_node, kmem_cpu_nodes); /* XXX per-nid */
+static struct kmem_cache_node kmem_cpu_nodes[MAX_NUMNODES]; /* XXX per-nid */
 #endif
 #endif
 
@@ -1962,7 +1962,7 @@ static struct kmem_cache kmem_node_cache;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_node_cpus);
 #endif
-static DEFINE_PER_CPU(struct kmem_cache_node, kmem_node_nodes); /*XXX per-nid */
+static struct kmem_cache_node kmem_node_nodes[MAX_NUMNODES]; /*XXX per-nid */
 #endif
 
 #ifdef CONFIG_SMP
@@ -2918,15 +2918,15 @@ void __init kmem_cache_init(void)
 	for_each_node_state(i, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n;
 
-		n = &per_cpu(kmem_cache_nodes, i);
+		n = &kmem_cache_nodes[i];
 		init_kmem_cache_node(&kmem_cache_cache, n);
 		kmem_cache_cache.node_slab[i] = n;
 #ifdef CONFIG_SMP
-		n = &per_cpu(kmem_cpu_nodes, i);
+		n = &kmem_cpu_nodes[i];
 		init_kmem_cache_node(&kmem_cpu_cache, n);
 		kmem_cpu_cache.node_slab[i] = n;
 #endif
-		n = &per_cpu(kmem_node_nodes, i);
+		n = &kmem_node_nodes[i];
 		init_kmem_cache_node(&kmem_node_cache, n);
 		kmem_node_cache.node_slab[i] = n;
 	}
