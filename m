Return-Path: <linux-kernel-owner+w=401wt.eu-S1030781AbXCTAVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030781AbXCTAVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030784AbXCTAVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:21:48 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36150 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030781AbXCTAVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:21:46 -0400
Date: Mon, 19 Mar 2007 17:21:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
Message-Id: <20070319172142.542c8284.akpm@linux-foundation.org>
In-Reply-To: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 15:37:16 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> ...
>
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.21-rc3-mm2/include/linux/quicklist.h	2007-03-16 02:19:15.000000000 -0700
> @@ -0,0 +1,95 @@
> +#ifndef LINUX_QUICKLIST_H
> +#define LINUX_QUICKLIST_H
> +/*
> + * Fast allocations and disposal of pages. Pages must be in the condition
> + * as needed after allocation when they are freed. Per cpu lists of pages
> + * are kept that only contain node local pages.
> + *
> + * (C) 2007, SGI. Christoph Lameter <clameter@sgi.com>
> + */
> +#include <linux/kernel.h>
> +#include <linux/gfp.h>
> +#include <linux/percpu.h>
> +
> +#ifdef CONFIG_QUICKLIST
> +
> +#ifndef CONFIG_NR_QUICK
> +#define CONFIG_NR_QUICK 1
> +#endif

No, please don't define config items like this.  Do it in Kconfig.

> +static inline void *quicklist_alloc(int nr, gfp_t flags, void (*ctor)(void *))
> +{
> +	struct quicklist *q;
> +	void **p = NULL;
> +
> +	q =&get_cpu_var(quicklist)[nr];
> +	p = q->page;
> +	if (likely(p)) {
> +		q->page = p[0];
> +		p[0] = NULL;
> +		q->nr_pages--;
> +	}
> +	put_cpu_var(quicklist);
> +	if (likely(p))
> +		return p;
> +
> +	p = (void *)__get_free_page(flags | __GFP_ZERO);
> +	if (ctor && p)
> +		ctor(p);
> +	return p;
> +}
> +
> +static inline void quicklist_free(int nr, void (*dtor)(void *), void *pp)
> +{
> +	struct quicklist *q;
> +	void **p = pp;
> +	struct page *page = virt_to_page(p);
> +	int nid = page_to_nid(page);
> +
> +	if (unlikely(nid != numa_node_id())) {
> +		if (dtor)
> +			dtor(p);
> +		free_page((unsigned long)p);
> +		return;
> +	}
> +
> +	q = &get_cpu_var(quicklist)[nr];
> +	p[0] = q->page;
> +	q->page = p;
> +	q->nr_pages++;
> +	put_cpu_var(quicklist);
> +}

These guys seem to have multiple callsites for ia64 at least and probably
would benefit from being uninlined.

> +void quicklist_check(int nr, void (*dtor)(void *));
> +unsigned long quicklist_total_size(void);
> +
> +#else
> +void quicklist_check(int nr, void (*dtor)(void *))
> +{
> +}
> +
> +unsigned long quicklist_total_size(void)
> +{
> +	return 0;
> +}
> +#endif

That obviouslty won't link and wasn't tested.  Making these static inline
will help.

> +/*
> + * Quicklist support.
> + *
> + * Quicklists are light weight lists of pages that have a defined state
> + * on alloc and free. Pages must be in the quicklist specific defined state
> + * (zero by default) when the page is freed. It seems that the initial idea
> + * for such lists first came from Dave Miller and then various other people
> + * improved on it.
> + *
> + * Copyright (C) 2007 SGI,
> + * 	Christoph Lameter <clameter@sgi.com>
> + * 		Generalized, added support for multiple lists and
> + * 		constructors / destructors.
> + */
> +#include <linux/kernel.h>
> +
> +#include <linux/mm.h>
> +#include <linux/mmzone.h>
> +#include <linux/module.h>
> +#include <linux/quicklist.h>
> +
> +DEFINE_PER_CPU(struct quicklist, quicklist)[CONFIG_NR_QUICK];

If we uninline those big inlines, this can perhaps be made static.

> +#define MIN_PAGES		25
> +#define MAX_FREES_PER_PASS	16
> +#define FRACTION_OF_NODE_MEM	16

Are these constants optimal for all architectures?

> +static unsigned long max_pages(void)
> +{
> +	unsigned long node_free_pages, max;
> +
> +	node_free_pages = node_page_state(numa_node_id(),
> +			NR_FREE_PAGES);
> +	max = node_free_pages / FRACTION_OF_NODE_MEM;
> +	return max(max, (unsigned long)MIN_PAGES);
> +}
> +
> +static long min_pages_to_free(struct quicklist *q)
> +{
> +	long pages_to_free;
> +
> +	pages_to_free = q->nr_pages - max_pages();
> +
> +	return min(pages_to_free, (long)MAX_FREES_PER_PASS);
> +}

min_t and max_t are the standard way of avoiding that warning.  Or stick a
UL on the constants (which is probably better).

> +void quicklist_check(int nr, void (*dtor)(void *))
> +{
> +	long pages_to_free;
> +	struct quicklist *q;
> +
> +	q = &get_cpu_var(quicklist)[nr];
> +	if (q->nr_pages > MIN_PAGES) {
> +		pages_to_free = min_pages_to_free(q);
> +
> +		while (pages_to_free > 0) {
> +			void *p = quicklist_alloc(nr, 0, NULL);
> +
> +			if (dtor)
> +				dtor(p);
> +			free_page((unsigned long)p);
> +			pages_to_free--;
> +		}
> +	}
> +	put_cpu_var(quicklist);
> +}

The use of a literal 0 as a gfp_t is a bit ugly.  I assume that we don't
care because we should never actually call into the page allocator for this
caller.  But it's not terribly clear because there is no commentary
describing what this function is supposed to do.

The name foo_check() is unfortunate: it implies that the function checks
something (ie: has no side-effects).  But this function _does_ change
things and perhaps should be called quicklist_trim() or something like
that.

This function lacks any commentary, but I was able to work it out.  I
think.  Some nice comments would be, umm, nice.

> +unsigned long quicklist_total_size(void)
> +{
> +	unsigned long count = 0;
> +	int cpu;
> +	struct quicklist *ql, *q;
> +
> +	for_each_online_cpu(cpu) {
> +		ql = per_cpu(quicklist, cpu);
> +		for (q = ql; q < ql + CONFIG_NR_QUICK; q++)
> +			count += q->nr_pages;
> +	}
> +	return count;
> +}
> +
