Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbZFII3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbZFII3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZFII2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:28:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56715 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbZFII2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:28:43 -0400
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de
In-Reply-To: <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
	 <20090608110303.GD15377@csn.ul.ie>
	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
	 <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>
	 <1244534315.5024.34.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com>
Date: Tue, 09 Jun 2009 11:28:44 +0300
Message-Id: <1244536124.5024.41.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 2009-06-09 at 01:14 -0700, David Rientjes wrote:
> I wasn't sure whether you were proposing the patch as an addition to slub 
> or just to help with this issue.  I agree it would help in a hopefully 
> ratelimited manner for general slab allocation failures and would have 
> avoided some of the confusion for this issue from lack of diagnostics.

I am proposing it as a generic addition to SLUB.

On Tue, 2009-06-09 at 01:14 -0700, David Rientjes wrote:
> > It doesn't hurt either, does it? Yes, we expect the partial lists to be
> > exhausted but it's better to print that out just in case we have a bug
> > some day somewhere and that condition is not true. This is very
> > infrequent slow patch code here anyway.
> 
> It will lead to false postiives since you can get a free to a full slab 
> which moves it back to an allowed node's partial list before count_free() 
> is printed.

Fair enough, lets drop it then!

			Pekka

diff --git a/mm/slub.c b/mm/slub.c
index 65ffda5..2bbacfc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1484,6 +1484,56 @@ static inline int node_match(struct kmem_cache_cpu *c, int node)
 	return 1;
 }
 
+static int count_free(struct page *page)
+{
+	return page->objects - page->inuse;
+}
+
+static unsigned long count_partial(struct kmem_cache_node *n,
+					int (*get_count)(struct page *))
+{
+	unsigned long flags;
+	unsigned long x = 0;
+	struct page *page;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+	list_for_each_entry(page, &n->partial, lru)
+		x += get_count(page);
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return x;
+}
+
+static noinline void
+slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
+{
+	int node;
+
+	printk(KERN_WARNING
+		"SLUB: Unable to allocate memory on node %d (gfp=%x)\n",
+		nid, gfpflags);
+	printk(KERN_WARNING "  cache: %s, object size: %d, buffer size: %d, "
+		"default order: %d, min order: %d\n", s->name, s->objsize,
+		s->size, oo_order(s->oo), oo_order(s->min));
+
+	for_each_online_node(node) {
+		struct kmem_cache_node *n = get_node(s, node);
+		unsigned long nr_slabs;
+		unsigned long nr_objs;
+		unsigned long nr_free;
+
+		if (!n)
+			continue;
+
+		nr_slabs = atomic_long_read(&n->nr_slabs);
+		nr_objs = atomic_long_read(&n->total_objects);
+		nr_free = count_partial(n, count_free);
+
+		printk(KERN_WARNING
+			"  node %d: slabs: %ld, objs: %ld, free: %ld\n",
+			node, nr_slabs, nr_objs, nr_free);
+	}
+}
+
 /*
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
@@ -1565,6 +1615,7 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
+	slab_out_of_memory(s, gfpflags, node);
 	return NULL;
 debug:
 	if (!alloc_debug_processing(s, c->page, object, addr))
@@ -3318,20 +3369,6 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 }
 
 #ifdef CONFIG_SLUB_DEBUG
-static unsigned long count_partial(struct kmem_cache_node *n,
-					int (*get_count)(struct page *))
-{
-	unsigned long flags;
-	unsigned long x = 0;
-	struct page *page;
-
-	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry(page, &n->partial, lru)
-		x += get_count(page);
-	spin_unlock_irqrestore(&n->list_lock, flags);
-	return x;
-}
-
 static int count_inuse(struct page *page)
 {
 	return page->inuse;
@@ -3342,11 +3379,6 @@ static int count_total(struct page *page)
 	return page->objects;
 }
 
-static int count_free(struct page *page)
-{
-	return page->objects - page->inuse;
-}
-
 static int validate_slab(struct kmem_cache *s, struct page *page,
 						unsigned long *map)
 {


