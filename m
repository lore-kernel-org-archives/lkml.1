Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbXLVNP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbXLVNP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXLVNPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:15:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46770 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbXLVNPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:15:16 -0500
Date: Sat, 22 Dec 2007 14:14:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, clameter@sgi.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] slub: /proc/slabinfo ABI compatibility
Message-ID: <20071222131456.GA32558@elte.hu>
References: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This adds a read-only /proc/slabinfo file that is ABI compatible with 
> SLAB for SLUB.

cool :-) I tried your patch and slabtop works just fine:

 ------------------>
 Active / Total Objects (% used)    : 31939 / 32363 (98.7%)
 Active / Total Slabs (% used)      : 2082 / 2082 (100.0%)
 Active / Total Caches (% used)     : 87 / 165 (52.7%)
 Active / Total Size (% used)       : 9225.02K / 9325.23K (98.9%)
 Minimum / Average / Maximum Object : 0.08K / 0.29K / 4.12K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
  7618   7610  99%    0.15K    293       26      1172K sysfs_dir_cache
  3045   3045 100%    0.27K    203       15       812K dentry
  2856   2852  99%    0.14K    102       28       408K selinux_inode_security
  2760   2721  98%    0.17K    120       23       480K buffer_head
  2737   2736  99%    0.23K    161       17       644K vm_area_struct
 <------------------

 Tested-by: Ingo Molnar <mingo@elte.hu>

Also please apply the cleanup patch below, it fixes 34 checkpatch errors 
and warnings in mm/slub.c.

	Ingo

------------------------>
Subject: SLUB: fix checkpatch warnings
From: Ingo Molnar <mingo@elte.hu>

fix checkpatch --file mm/slub.c errors and warnings.

 $ q-code-quality-compare
                                      errors   lines of code   errors/KLOC
 mm/slub.c      [before]                  22            4204           5.2
 mm/slub.c      [after]                    0            4210             0

no code changed:

    text    data     bss     dec     hex filename
   22195    8634     136   30965    78f5 slub.o.before
   22195    8634     136   30965    78f5 slub.o.after

   md5:
     93cdfbec2d6450622163c590e1064358  slub.o.before.asm
     93cdfbec2d6450622163c590e1064358  slub.o.after.asm

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/slub.c |   92 +++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 49 insertions(+), 43 deletions(-)

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -354,22 +354,22 @@ static void print_section(char *text, u8
 			printk(KERN_ERR "%8s 0x%p: ", text, addr + i);
 			newline = 0;
 		}
-		printk(" %02x", addr[i]);
+		printk(KERN_CONT " %02x", addr[i]);
 		offset = i % 16;
 		ascii[offset] = isgraph(addr[i]) ? addr[i] : '.';
 		if (offset == 15) {
-			printk(" %s\n",ascii);
+			printk(KERN_CONT " %s\n", ascii);
 			newline = 1;
 		}
 	}
 	if (!newline) {
 		i %= 16;
 		while (i < 16) {
-			printk("   ");
+			printk(KERN_CONT "   ");
 			ascii[i] = ' ';
 			i++;
 		}
-		printk(" %s\n", ascii);
+		printk(KERN_CONT " %s\n", ascii);
 	}
 }
 
@@ -529,7 +529,7 @@ static void init_object(struct kmem_cach
 
 	if (s->flags & __OBJECT_POISON) {
 		memset(p, POISON_FREE, s->objsize - 1);
-		p[s->objsize -1] = POISON_END;
+		p[s->objsize - 1] = POISON_END;
 	}
 
 	if (s->flags & SLAB_RED_ZONE)
@@ -558,7 +558,7 @@ static void restore_bytes(struct kmem_ca
 
 static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
 			u8 *object, char *what,
-			u8* start, unsigned int value, unsigned int bytes)
+			u8 *start, unsigned int value, unsigned int bytes)
 {
 	u8 *fault;
 	u8 *end;
@@ -682,9 +682,10 @@ static int check_object(struct kmem_cach
 			endobject, red, s->inuse - s->objsize))
 			return 0;
 	} else {
-		if ((s->flags & SLAB_POISON) && s->objsize < s->inuse)
-			check_bytes_and_report(s, page, p, "Alignment padding", endobject,
-				POISON_INUSE, s->inuse - s->objsize);
+		if ((s->flags & SLAB_POISON) && s->objsize < s->inuse) {
+			check_bytes_and_report(s, page, p, "Alignment padding",
+				endobject, POISON_INUSE, s->inuse - s->objsize);
+		}
 	}
 
 	if (s->flags & SLAB_POISON) {
@@ -692,7 +693,7 @@ static int check_object(struct kmem_cach
 			(!check_bytes_and_report(s, page, p, "Poison", p,
 					POISON_FREE, s->objsize - 1) ||
 			 !check_bytes_and_report(s, page, p, "Poison",
-			 	p + s->objsize -1, POISON_END, 1)))
+				p + s->objsize - 1, POISON_END, 1)))
 			return 0;
 		/*
 		 * check_pad_bytes cleans up on its own.
@@ -781,7 +782,8 @@ static int on_freelist(struct kmem_cache
 	return search == NULL;
 }
 
-static void trace(struct kmem_cache *s, struct page *page, void *object, int alloc)
+static void
+trace(struct kmem_cache *s, struct page *page, void *object, int alloc)
 {
 	if (s->flags & SLAB_TRACE) {
 		printk(KERN_INFO "TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
@@ -891,17 +893,15 @@ static int free_debug_processing(struct 
 		return 0;
 
 	if (unlikely(s != page->slab)) {
-		if (!PageSlab(page))
+		if (!PageSlab(page)) {
 			slab_err(s, page, "Attempt to free object(0x%p) "
 				"outside of slab", object);
-		else
-		if (!page->slab) {
+		} else if (!page->slab) {
 			printk(KERN_ERR
 				"SLUB <none>: no slab for object 0x%p.\n",
 						object);
 			dump_stack();
-		}
-		else
+		} else
 			object_err(s, page, object,
 					"page slab pointer corrupt.");
 		goto fail;
@@ -947,7 +947,7 @@ static int __init setup_slub_debug(char 
 	/*
 	 * Determine which debug features should be switched on
 	 */
-	for ( ;*str && *str != ','; str++) {
+	for ( ; *str && *str != ','; str++) {
 		switch (tolower(*str)) {
 		case 'f':
 			slub_debug |= SLAB_DEBUG_FREE;
@@ -966,7 +966,7 @@ static int __init setup_slub_debug(char 
 			break;
 		default:
 			printk(KERN_ERR "slub_debug option '%c' "
-				"unknown. skipped\n",*str);
+				"unknown. skipped\n", *str);
 		}
 	}
 
@@ -1005,7 +1005,7 @@ static unsigned long kmem_cache_flags(un
 		 */
 		if (slub_debug && (!slub_debug_slabs ||
 		    strncmp(slub_debug_slabs, name,
-		    	strlen(slub_debug_slabs)) == 0))
+			strlen(slub_debug_slabs)) == 0))
 				flags |= slub_debug;
 	}
 
@@ -1039,7 +1039,7 @@ static inline unsigned long kmem_cache_f
  */
 static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
-	struct page * page;
+	struct page *page;
 	int pages = 1 << s->order;
 
 	if (s->order)
@@ -1134,8 +1134,7 @@ static void __free_slab(struct kmem_cach
 
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-		- pages);
+		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE, -pages);
 
 	__free_pages(page, s->order);
 }
@@ -1227,7 +1226,8 @@ static void remove_partial(struct kmem_c
  *
  * Must hold list_lock.
  */
-static inline int lock_and_freeze_slab(struct kmem_cache_node *n, struct page *page)
+static inline int
+lock_and_freeze_slab(struct kmem_cache_node *n, struct page *page)
 {
 	if (slab_trylock(page)) {
 		list_del(&page->lru);
@@ -1295,8 +1295,8 @@ static struct page *get_any_partial(stru
 	if (!s->defrag_ratio || get_cycles() % 1024 > s->defrag_ratio)
 		return NULL;
 
-	zonelist = &NODE_DATA(slab_node(current->mempolicy))
-					->node_zonelists[gfp_zone(flags)];
+	zonelist = &NODE_DATA(
+		slab_node(current->mempolicy))->node_zonelists[gfp_zone(flags)];
 	for (z = zonelist->zones; *z; z++) {
 		struct kmem_cache_node *n;
 
@@ -1539,8 +1539,8 @@ debug:
  *
  * Otherwise we can simply pick the next object from the lockless free list.
  */
-static void __always_inline *slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr)
+static __always_inline void *
+slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node, void *addr)
 {
 	void **object;
 	unsigned long flags;
@@ -1647,8 +1647,8 @@ debug:
  * If fastpath is not possible then fall back to __slab_free where we deal
  * with all sorts of special processing.
  */
-static void __always_inline slab_free(struct kmem_cache *s,
-			struct page *page, void *x, void *addr)
+static __always_inline void
+slab_free(struct kmem_cache *s, struct page *page, void *x, void *addr)
 {
 	void **object = (void *)x;
 	unsigned long flags;
@@ -2228,7 +2228,7 @@ error:
  */
 int kmem_ptr_validate(struct kmem_cache *s, const void *object)
 {
-	struct page * page;
+	struct page *page;
 
 	page = get_object_page(object);
 
@@ -2341,7 +2341,7 @@ static struct kmem_cache *kmalloc_caches
 
 static int __init setup_slub_min_order(char *str)
 {
-	get_option (&str, &slub_min_order);
+	get_option(&str, &slub_min_order);
 
 	return 1;
 }
@@ -2350,7 +2350,7 @@ __setup("slub_min_order=", setup_slub_mi
 
 static int __init setup_slub_max_order(char *str)
 {
-	get_option (&str, &slub_max_order);
+	get_option(&str, &slub_max_order);
 
 	return 1;
 }
@@ -2359,7 +2359,7 @@ __setup("slub_max_order=", setup_slub_ma
 
 static int __init setup_slub_min_objects(char *str)
 {
-	get_option (&str, &slub_min_objects);
+	get_option(&str, &slub_min_objects);
 
 	return 1;
 }
@@ -2437,7 +2437,8 @@ static noinline struct kmem_cache *dma_k
 		goto unlock_out;
 
 	realsize = kmalloc_caches[index].objsize;
-	text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d", (unsigned int)realsize),
+	text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d",
+			 (unsigned int)realsize);
 	s = kmalloc(kmem_size, flags & ~SLUB_DMA);
 
 	if (!s || !text || !kmem_cache_open(s, flags, text,
@@ -2874,7 +2875,8 @@ void __init kmem_cache_init(void)
 #endif
 
 
-	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
+	printk(KERN_INFO
+		"SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
 		" CPUs=%d, Nodes=%d\n",
 		caches, cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
@@ -2931,7 +2933,7 @@ static struct kmem_cache *find_mergeable
 		 * Check if alignment is compatible.
 		 * Courtesy of Adrian Drzewiecki
 		 */
-		if ((s->size & ~(align -1)) != s->size)
+		if ((s->size & ~(align - 1)) != s->size)
 			continue;
 
 		if (s->size - size >= sizeof(void *))
@@ -3040,8 +3042,9 @@ static int __cpuinit slab_cpuup_callback
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata slab_notifier =
-	{ &slab_cpuup_callback, NULL, 0 };
+static struct notifier_block __cpuinitdata slab_notifier = {
+	.notifier_call = slab_cpuup_callback
+};
 
 #endif
 
@@ -3198,8 +3201,9 @@ static void resiliency_test(void)
 	p = kzalloc(32, GFP_KERNEL);
 	p[32 + sizeof(void *)] = 0x34;
 	printk(KERN_ERR "\n2. kmalloc-32: Clobber next pointer/next slab"
-		 	" 0x34 -> -0x%p\n", p);
-	printk(KERN_ERR "If allocated object is overwritten then not detectable\n\n");
+			" 0x34 -> -0x%p\n", p);
+	printk(KERN_ERR
+		"If allocated object is overwritten then not detectable\n\n");
 
 	validate_slab_cache(kmalloc_caches + 5);
 	p = kzalloc(64, GFP_KERNEL);
@@ -3207,7 +3211,8 @@ static void resiliency_test(void)
 	*p = 0x56;
 	printk(KERN_ERR "\n3. kmalloc-64: corrupting random byte 0x56->0x%p\n",
 									p);
-	printk(KERN_ERR "If allocated object is overwritten then not detectable\n\n");
+	printk(KERN_ERR
+		"If allocated object is overwritten then not detectable\n\n");
 	validate_slab_cache(kmalloc_caches + 6);
 
 	printk(KERN_ERR "\nB. Corruption after free\n");
@@ -3220,7 +3225,8 @@ static void resiliency_test(void)
 	p = kzalloc(256, GFP_KERNEL);
 	kfree(p);
 	p[50] = 0x9a;
-	printk(KERN_ERR "\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n", p);
+	printk(KERN_ERR "\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n",
+			p);
 	validate_slab_cache(kmalloc_caches + 8);
 
 	p = kzalloc(512, GFP_KERNEL);
@@ -3865,7 +3871,7 @@ static ssize_t defrag_ratio_store(struct
 SLAB_ATTR(defrag_ratio);
 #endif
 
-static struct attribute * slab_attrs[] = {
+static struct attribute *slab_attrs[] = {
 	&slab_size_attr.attr,
 	&object_size_attr.attr,
 	&objs_per_slab_attr.attr,
