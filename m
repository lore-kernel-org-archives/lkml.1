Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbXDEE3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbXDEE3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 00:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161139AbXDEE3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 00:29:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40710 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752402AbXDEE3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 00:29:08 -0400
Date: Wed, 4 Apr 2007 21:29:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4 (SLUB)
In-Reply-To: <1175741046.13125.0.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704042127230.14168@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com> 
 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com> 
 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com> 
 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com> 
 <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com> 
 <1175709755.6185.34.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0704041120250.793@schroedinger.engr.sgi.com> 
 <1175727185.5019.8.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704041556530.11769@schroedinger.engr.sgi.com> 
 <1175730157.5019.19.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704041730470.22161@schroedinger.engr.sgi.com>
 <1175741046.13125.0.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a patch that adds validation (only for cpuslabs and partial 
slabs but thats where the action is). Apply this patch
and then do

echo 1 >/sys/slab/<cache-to-check>/validate

I suggest to boot with full debugging and then run this on the ACPI slabs.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc5-mm4/mm/slub.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-04 20:26:03.000000000 -0700
+++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-04 21:26:15.000000000 -0700
@@ -2280,6 +2280,67 @@ void *__kmalloc_node_track_caller(size_t
 
 #ifdef CONFIG_SYSFS
 
+static int validate_slab(struct kmem_cache *s, struct page *page)
+{
+	void *p;
+	void *addr = page_address(page);
+	unsigned long map[BITS_TO_LONGS(s->objects)];
+
+	if (!check_slab(s, page) ||
+			!on_freelist(s, page, NULL))
+		return 0;
+
+	/* Now we know that a valid freelist exists */
+	bitmap_zero(map, s->objects);
+
+	for(p = page->freelist; p; p = get_freepointer(s, p)) {
+		set_bit((p - addr) / s->size, map);
+		if (!check_object(s, page, p, 0))
+			return 0;
+	}
+
+	for(p = addr; p < addr + s->objects * s->size; p += s->size)
+		if (!test_bit((p - addr) / s->size, map))
+			if (!check_object(s, page, p, 1))
+				return 0;
+	return 1;
+}
+
+static int validate_slab_node(struct kmem_cache *s, struct kmem_cache_node *n)
+{
+	int count = 0;
+	struct page *page;
+	unsigned long flags;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+	list_for_each_entry(page, &n->partial, lru) {
+		if (slab_trylock(page)) {
+			validate_slab(s, page);
+			slab_unlock(page);
+		} else
+			printk(KERN_INFO "Skipped busy slab %p\n", page);
+		count++;
+	}
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return count;
+}
+
+static void validate_slab_cache(struct kmem_cache *s)
+{
+	int node;
+	int count = 0;
+
+	printk(KERN_INFO "--- Validating slabcache '%s'\n", s->name);
+	flush_all(s);
+	for_each_online_node(node) {
+		struct kmem_cache_node *n = get_node(s, node);
+
+		count += validate_slab_node(s, n);
+	}
+	printk(KERN_INFO "--- Checked %d slabs in '%s'\n",
+		count, s->name);
+}
+
 static unsigned long count_partial(struct kmem_cache_node *n)
 {
 	unsigned long flags;
@@ -2402,7 +2463,6 @@ struct slab_attribute {
 	static struct slab_attribute _name##_attr =  \
 	__ATTR(_name, 0644, _name##_show, _name##_store)
 
-
 static ssize_t slab_size_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", s->size);
@@ -2609,6 +2669,22 @@ static ssize_t store_user_store(struct k
 }
 SLAB_ATTR(store_user);
 
+static ssize_t validate_show(struct kmem_cache *s, char *buf)
+{
+	return 0;
+}
+
+static ssize_t validate_store(struct kmem_cache *s,
+			const char *buf, size_t length)
+{
+	if (buf[0] == '1')
+		validate_slab_cache(s);
+	else
+		return -EINVAL;
+	return length;
+}
+SLAB_ATTR(validate);
+
 #ifdef CONFIG_NUMA
 static ssize_t defrag_ratio_show(struct kmem_cache *s, char *buf)
 {
@@ -2648,6 +2724,7 @@ static struct attribute * slab_attrs[] =
 	&red_zone_attr.attr,
 	&poison_attr.attr,
 	&store_user_attr.attr,
+	&validate_attr.attr,
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif
