Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbXCZS05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbXCZS05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbXCZS05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:26:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43869 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbXCZS04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:26:56 -0400
Date: Mon, 26 Mar 2007 10:26:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V4
Message-Id: <20070326102651.6d59207b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703260938520.3297@schroedinger.engr.sgi.com>
References: <20070323062843.19502.19827.sendpatchset@schroedinger.engr.sgi.com>
	<20070322223927.bb4caf43.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703222339560.19630@schroedinger.engr.sgi.com>
	<20070322234848.100abb3d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703230804120.21857@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0703231026490.23132@schroedinger.engr.sgi.com>
	<20070323222133.f17090cf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703260938520.3297@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 09:52:17 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 23 Mar 2007, Andrew Morton wrote:
> 
> > On Fri, 23 Mar 2007 10:54:12 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> > 
> > > Here are the results of aim9 tests on x86_64. There are some minor performance 
> > > improvements and some fluctuations.
> > 
> > There are a lot of numbers there - what do they tell us?
> 
> That there are performance improvements because of quicklists.

Christoph, you can continue to be obtuse, and I can continue to ignore
these patches until

a) it has been demonstrated that this patch is superior to simply removing
   the quicklists and

b) we understand why the below simple modification crashes i386.


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


