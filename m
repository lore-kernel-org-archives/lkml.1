Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZFIHGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZFIHGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZFIHGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:06:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58111 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbZFIHGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:06:41 -0400
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de
In-Reply-To: <20090608141212.GE15070@csn.ul.ie>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
	 <20090608110303.GD15377@csn.ul.ie>
	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
	 <20090608141212.GE15070@csn.ul.ie>
Date: Tue, 09 Jun 2009 10:06:41 +0300
Message-Id: <1244531201.5024.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Mon, 2009-06-08 at 15:12 +0100, Mel Gorman wrote:
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 65ffda5..b5acf18 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1565,6 +1565,8 @@ new_slab:
> >  		c->page = new;
> >  		goto load_freelist;
> >  	}
> > +	printk(KERN_WARNING "SLUB: unable to satisfy allocation for cache %s (size=%d, node=%d, gfp=%x)\n",
> > +		s->name, s->size, node, gfpflags);
> 
> size could be almost anything here for a casual reader. You are
> outputting the size of the object plus its metadata so the name should
> reflect that. I think it would be better to output objsize= and the
> object size without the metadata overhead. What do you think?
> 
> In addition, include how many objects there are per-slab and include what
> the order is being passed to the page allocator when allocating new slabs.
> Would that be enough to determine if fallback-to-smaller orders occured?

So how about something like this then?

			Pekka

diff --git a/mm/slub.c b/mm/slub.c
index 65ffda5..a03dbe8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1484,6 +1484,58 @@ static inline int node_match(struct kmem_cache_cpu *c, int node)
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
+		unsigned long nr_partials;
+		unsigned long nr_slabs;
+		unsigned long nr_objs;
+		unsigned long nr_free;
+
+		if (!n)
+			continue;
+
+		nr_partials = n->nr_partial;
+		nr_slabs = atomic_long_read(&n->nr_slabs);
+		nr_objs = atomic_long_read(&n->total_objects);
+		nr_free = count_partial(n, count_free);
+
+		printk(KERN_WARNING
+			"  node %d: partials: %ld, slabs: %ld, objs: %ld, free: %ld\n",
+			node, nr_partials, nr_slabs, nr_objs, nr_free);
+	}
+}
+
 /*
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
@@ -1565,6 +1617,7 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
+	slab_out_of_memory(s, gfpflags, node);
 	return NULL;
 debug:
 	if (!alloc_debug_processing(s, c->page, object, addr))
@@ -3318,20 +3371,6 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
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
@@ -3342,11 +3381,6 @@ static int count_total(struct page *page)
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


