Return-Path: <linux-kernel-owner+w=401wt.eu-S1750867AbZD3EME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750867AbZD3EME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 00:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbZD3ELw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 00:11:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:52770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZD3ELv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 00:11:51 -0400
Date: Thu, 30 Apr 2009 06:11:46 +0200
From: Nick Piggin <npiggin@suse.de>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linuxppc-dev@ozlabs.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
Message-ID: <20090430041146.GB23746@wotan.suse.de>
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F6E421.401@in.ibm.com> <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com> <20090429113604.GE3398@wotan.suse.de> <49F87FAB.9050408@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F87FAB.9050408@in.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 09:56:19PM +0530, Sachin Sant wrote:
> Nick Piggin wrote:
> >Does this help?
> >---
> With the patch the machine boots past the failure point, but panics
> immediately with the following trace...

OK good, that solves one problem.

 
> Unable to handle kernel paging request for data at address 0x00000010
> Faulting instruction address: 0xc0000000007d03ec
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=1024 DEBUG_PAGEALLOC NUMA pSeries
> Modules linked in:
> NIP: c0000000007d03ec LR: c0000000007b0bbc CTR: 0000000000136f8c
> REGS: c000000000a23bd0 TRAP: 0300   Not tainted  (2.6.30-rc3-next-20090429)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28000084  XER: 00000010
> DAR: 0000000000000010, DSISR: 0000000040000000
> TASK = c000000000955fc0[0] 'swapper' THREAD: c000000000a20000 CPU: 0
> GPR00: 0000000000000001 c000000000a23e50 c000000000a17650 000000000000001f
> GPR04: 0000000000000000 ffffffffffffffff 000000000077a4b9 800000000c9b2cc0
> GPR08: 0000000000000000 0000000000000010 0000000000000000 c00000000095b0f8
> GPR12: 0000000028000082 c000000000af2400 c0000000007f3200 c000000000705c32
> GPR16: 00000000014f3138 0000000000000000 c0000000007f3138 0000000002f1fc90
> GPR20: c0000000007f3150 c000000000725d11 00000000007bb8e4 0000000002f1fc90
> GPR24: 0000000002f1fc90 c0000000007f31f0 0000000000d00000 c000000000b73b10
> GPR28: c0000000007f0440 c00000000095db00 c00000000098d5f0 0000000003c90000
> NIP [c0000000007d03ec] .pidmap_init+0x28/0x88

Well kmalloc is failing. It should not be though, even if the
current node is offline, it should be able to fall back to other
nodes. Stephen's trace indicates the same thing.

Could you try the following patch please, and capture the output
it generates?

Thanks,
Nick
---
 mm/slqb.c |   40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/slqb.c
===================================================================
--- linux-2.6.orig/mm/slqb.c
+++ linux-2.6/mm/slqb.c
@@ -1456,7 +1456,7 @@ static void *__remote_slab_alloc_node(st
 }
 
 static noinline void *__remote_slab_alloc(struct kmem_cache *s,
-				gfp_t gfpflags, int node)
+				gfp_t gfpflags, int node, int trace)
 {
 	void *object;
 	struct zonelist *zonelist;
@@ -1465,19 +1465,32 @@ static noinline void *__remote_slab_allo
 	enum zone_type high_zoneidx = gfp_zone(gfpflags);
 
 	object = __remote_slab_alloc_node(s, gfpflags, node);
+	if (trace && !object)
+		printk("__remote_slab_alloc_node(node:%d) failed\n", node);
 	if (likely(object || (gfpflags & __GFP_THISNODE)))
 		return object;
 
-	zonelist = node_zonelist(slab_node(current->mempolicy), gfpflags);
+	node = slab_node(current->mempolicy);
+	if (trace)
+		printk("slab_node(current->mempolicy) = %d\n", node);
+
+	zonelist = node_zonelist(node, gfpflags);
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
-		if (!cpuset_zone_allowed_hardwall(zone, gfpflags))
+		if (!cpuset_zone_allowed_hardwall(zone, gfpflags)) {
+			if (trace)
+				printk("cpuset not allowed node:%d\n", zone_to_nid(zone));
 			continue;
+		}
 
 		node = zone_to_nid(zone);
 		object = __remote_slab_alloc_node(s, gfpflags, node);
 		if (likely(object))
 			return object;
+		if (trace)
+			printk("__remote_slab_alloc_node(node:%d) failed\n", node);
 	}
+	if (trace)
+		printk("__remote_slab_alloc failed\n");
 	return NULL;
 }
 #endif
@@ -1488,7 +1501,7 @@ static noinline void *__remote_slab_allo
  * Must be called with interrupts disabled.
  */
 static __always_inline void *__slab_alloc(struct kmem_cache *s,
-				gfp_t gfpflags, int node)
+				gfp_t gfpflags, int node, int trace)
 {
 	void *object;
 	struct kmem_cache_cpu *c;
@@ -1497,7 +1510,7 @@ static __always_inline void *__slab_allo
 #ifdef CONFIG_NUMA
 	if (unlikely(node != -1) && unlikely(node != numa_node_id())) {
 try_remote:
-		return __remote_slab_alloc(s, gfpflags, node);
+		return __remote_slab_alloc(s, gfpflags, node, trace);
 	}
 #endif
 
@@ -1509,6 +1522,8 @@ try_remote:
 		object = cache_list_get_page(s, l);
 		if (unlikely(!object)) {
 			object = __slab_alloc_page(s, gfpflags, node);
+			if (trace && !object)
+				printk("__slab_alloc_page(node:%d) failed\n", node);
 #ifdef CONFIG_NUMA
 			if (unlikely(!object)) {
 				node = numa_node_id();
@@ -1532,10 +1547,11 @@ static __always_inline void *slab_alloc(
 {
 	void *object;
 	unsigned long flags;
+	int trace = 0;
 
 again:
 	local_irq_save(flags);
-	object = __slab_alloc(s, gfpflags, node);
+	object = __slab_alloc(s, gfpflags, node, trace);
 	local_irq_restore(flags);
 
 	if (unlikely(slab_debug(s)) && likely(object)) {
@@ -1546,6 +1562,18 @@ again:
 	if (unlikely(gfpflags & __GFP_ZERO) && likely(object))
 		memset(object, 0, s->objsize);
 
+	if (!object && !trace) {
+		trace = 1;
+		dump_stack();
+		printk("slab_alloc allocation failed\n");
+		printk("slab:%s flags:%x node:%d\n", s->name, gfpflags, node);
+		goto again;
+	}
+	if (trace) {
+		if (object)
+			printk("slab_alloc allocation worked when being traced, bugger\n");
+	}
+
 	return object;
 }
 


