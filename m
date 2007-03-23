Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbXCWHsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbXCWHsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 03:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXCWHsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 03:48:55 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41243 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934026AbXCWHsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 03:48:53 -0400
Date: Thu, 22 Mar 2007 23:48:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V4
Message-Id: <20070322234848.100abb3d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703222339560.19630@schroedinger.engr.sgi.com>
References: <20070323062843.19502.19827.sendpatchset@schroedinger.engr.sgi.com>
	<20070322223927.bb4caf43.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703222339560.19630@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 23:52:05 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 22 Mar 2007, Andrew Morton wrote:
> 
> > On Thu, 22 Mar 2007 23:28:41 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> > 
> > > 1. Proven code from the IA64 arch.
> > > 
> > > 	The method used here has been fine tuned for years and
> > > 	is NUMA aware. It is based on the knowledge that accesses
> > > 	to page table pages are sparse in nature. Taking a page
> > > 	off the freelists instead of allocating a zeroed pages
> > > 	allows a reduction of number of cachelines touched
> > > 	in addition to getting rid of the slab overhead. So
> > > 	performance improves.
> > 
> > By how much?
> 
> About 40% on fork+exit. See 
> 
> http://marc.info/?l=linux-ia64&m=110942798406005&w=2
> 

afacit that two-year-old, totally-different patch has nothing to do with my
repeatedly-asked question.  It appears to be consolidating three separate
quicklist allocators into one common implementation.

In an attempt to answer my own question (and hence to justify the retention
of this custom allocator) I did this:


diff -puN include/linux/quicklist.h~qlhack include/linux/quicklist.h
--- a/include/linux/quicklist.h~qlhack
+++ a/include/linux/quicklist.h
@@ -32,45 +32,17 @@ DECLARE_PER_CPU(struct quicklist, quickl
  */
 static inline void *quicklist_alloc(int nr, gfp_t flags, void (*ctor)(void *))
 {
-	struct quicklist *q;
-	void **p = NULL;
-
-	q =&get_cpu_var(quicklist)[nr];
-	p = q->page;
-	if (likely(p)) {
-		q->page = p[0];
-		p[0] = NULL;
-		q->nr_pages--;
-	}
-	put_cpu_var(quicklist);
-	if (likely(p))
-		return p;
-
-	p = (void *)__get_free_page(flags | __GFP_ZERO);
+	void *p = (void *)__get_free_page(flags | __GFP_ZERO);
 	if (ctor && p)
 		ctor(p);
 	return p;
 }
 
-static inline void quicklist_free(int nr, void (*dtor)(void *), void *pp)
+static inline void quicklist_free(int nr, void (*dtor)(void *), void *p)
 {
-	struct quicklist *q;
-	void **p = pp;
-	struct page *page = virt_to_page(p);
-	int nid = page_to_nid(page);
-
-	if (unlikely(nid != numa_node_id())) {
-		if (dtor)
-			dtor(p);
-		free_page((unsigned long)p);
-		return;
-	}
-
-	q = &get_cpu_var(quicklist)[nr];
-	p[0] = q->page;
-	q->page = p;
-	q->nr_pages++;
-	put_cpu_var(quicklist);
+	if (dtor)
+		dtor(p);
+	free_page((unsigned long)p);
 }
 
 void quicklist_trim(int nr, void (*dtor)(void *),
@@ -81,4 +53,3 @@ unsigned long quicklist_total_size(void)
 #endif
 
 #endif /* LINUX_QUICKLIST_H */
-
_

but it crashes early in the page allocator (i386) and I don't see why.  It
makes me wonder if we have a use-after-free which is hidden by the presence
of the quicklist buffering or something.

