Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYAAQYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYAAQYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYAAQYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:24:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57439 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYAAQYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:24:05 -0500
Date: Tue, 1 Jan 2008 17:23:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>, Willy Tarreau <w@1wt.eu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch] slub: provide /proc/slabinfo
Message-ID: <20080101162328.GC20426@elte.hu>
References: <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org> <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org> <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com> <20071224233701.GB9784@kernel.org> <20071225033418.GA29199@one.firstfloor.org> <20080101124741.GH11776@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101124741.GH11776@mit.edu>
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


* Theodore Tso <tytso@MIT.EDU> wrote:

> [...] doesn't a patch to provide /proc/slabinfo for SLUB already 
> exist?

yes, the complete (and tested) patch is below. It has been through a few 
thousand random-bootup tests on x86 32-bit and 64-bit so it's v2.6.24 
material i think.

	Ingo

----------------->
Subject: slub: provide /proc/slabinfo
From: Pekka J Enberg <penberg@cs.helsinki.fi>

This adds a read-only /proc/slabinfo file on SLUB, that makes slabtop work.

[ mingo@elte.hu: build fix. ]

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/slub_def.h |    2 
 mm/slub.c                |  105 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 94 insertions(+), 13 deletions(-)

Index: linux/include/linux/slub_def.h
===================================================================
--- linux.orig/include/linux/slub_def.h
+++ linux/include/linux/slub_def.h
@@ -200,4 +200,6 @@ static __always_inline void *kmalloc_nod
 }
 #endif
 
+extern const struct seq_operations slabinfo_op;
+
 #endif /* _LINUX_SLUB_DEF_H */
Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -3076,6 +3076,19 @@ void *__kmalloc_node_track_caller(size_t
 	return slab_alloc(s, gfpflags, node, caller);
 }
 
+static unsigned long count_partial(struct kmem_cache_node *n)
+{
+	unsigned long flags;
+	unsigned long x = 0;
+	struct page *page;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+	list_for_each_entry(page, &n->partial, lru)
+		x += page->inuse;
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return x;
+}
+
 #if defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)
 static int validate_slab(struct kmem_cache *s, struct page *page,
 						unsigned long *map)
@@ -3458,19 +3471,6 @@ static int list_locations(struct kmem_ca
 	return n;
 }
 
-static unsigned long count_partial(struct kmem_cache_node *n)
-{
-	unsigned long flags;
-	unsigned long x = 0;
-	struct page *page;
-
-	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry(page, &n->partial, lru)
-		x += page->inuse;
-	spin_unlock_irqrestore(&n->list_lock, flags);
-	return x;
-}
-
 enum slab_stat_type {
 	SL_FULL,
 	SL_PARTIAL,
@@ -4123,3 +4123,82 @@ static int __init slab_sysfs_init(void)
 
 __initcall(slab_sysfs_init);
 #endif
+
+/*
+ * The /proc/slabinfo ABI
+ */
+#ifdef CONFIG_PROC_FS
+
+static void print_slabinfo_header(struct seq_file *m)
+{
+	seq_puts(m, "slabinfo - version: 2.1\n");
+	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> "
+		 "<objperslab> <pagesperslab>");
+	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
+	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
+	seq_putc(m, '\n');
+}
+
+static void *s_start(struct seq_file *m, loff_t *pos)
+{
+	loff_t n = *pos;
+
+	down_read(&slub_lock);
+	if (!n)
+		print_slabinfo_header(m);
+
+	return seq_list_start(&slab_caches, *pos);
+}
+
+static void *s_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	return seq_list_next(p, &slab_caches, pos);
+}
+
+static void s_stop(struct seq_file *m, void *p)
+{
+	up_read(&slub_lock);
+}
+
+static int s_show(struct seq_file *m, void *p)
+{
+	unsigned long nr_partials = 0;
+	unsigned long nr_slabs = 0;
+	unsigned long nr_inuse = 0;
+	unsigned long nr_objs;
+	struct kmem_cache *s;
+	int node;
+
+	s = list_entry(p, struct kmem_cache, list);
+
+	for_each_online_node(node) {
+		struct kmem_cache_node *n = get_node(s, node);
+
+		if (!n)
+			continue;
+
+		nr_partials += n->nr_partial;
+		nr_slabs += atomic_long_read(&n->nr_slabs);
+		nr_inuse += count_partial(n);
+	}
+
+	nr_objs = nr_slabs * s->objects;
+	nr_inuse += (nr_slabs - nr_partials) * s->objects;
+
+	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d", s->name, nr_inuse,
+		   nr_objs, s->size, s->objects, (1 << s->order));
+	seq_printf(m, " : tunables %4u %4u %4u", 0, 0, 0);
+	seq_printf(m, " : slabdata %6lu %6lu %6lu", nr_slabs, nr_slabs,
+		   0UL);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+const struct seq_operations slabinfo_op = {
+	.start = s_start,
+	.next = s_next,
+	.stop = s_stop,
+	.show = s_show,
+};
+
+#endif /* CONFIG_PROC_FS */
