Return-Path: <linux-kernel-owner+w=401wt.eu-S1030259AbXDIV2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbXDIV2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965959AbXDIV1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:27:30 -0400
Received: from smtp.osdl.org ([65.172.181.24]:32895 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965880AbXDIV1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:27:15 -0400
Date: Mon, 9 Apr 2007 14:27:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [QUICKLIST 1/4] Quicklists for page table pages V5
Message-Id: <20070409142705.55fa0f34.akpm@linux-foundation.org>
In-Reply-To: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Apr 2007 11:25:09 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> Quicklists for page table pages V5
> 
> ...
>
> +/*
> + * The two key functions quicklist_alloc and quicklist_free are inline so
> + * that they may be custom compiled for the platform.
> + * Specifying a NULL ctor can remove constructor support. Specifying
> + * a constant quicklist allows the determination of the exact address
> + * in the per cpu area.
> + *
> + * The fast patch in quicklist_alloc touched only a per cpu cacheline and
> + * the first cacheline of the page itself. There is minmal overhead involved.
> + */
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
> +static inline void __quicklist_free(int nr, void (*dtor)(void *), void *p,
> +	struct page *page)
> +{
> +	struct quicklist *q;
> +	int nid = page_to_nid(page);
> +
> +	if (unlikely(nid != numa_node_id())) {
> +		if (dtor)
> +			dtor(p);
> +		free_page((unsigned long)p);

free_page() has to run virt_to_page(), but we already have the page*.

> +		return;
> +	}
> +
> +	q = &get_cpu_var(quicklist)[nr];
> +	*(void **)p = q->page;
> +	q->page = p;
> +	q->nr_pages++;
> +	put_cpu_var(quicklist);
> +}
> +
> +static inline void quicklist_free(int nr, void (*dtor)(void *), void *pp)
> +{
> +	__quicklist_free(nr, dtor, pp, virt_to_page(pp));
> +}
> +
> +static inline void quicklist_free_page(int nr, void (*dtor)(void *),
> +							struct page *page)
> +{
> +	__quicklist_free(nr, dtor, page_address(page), page);
> +}

All this (still) seems way too big to be inlined.  I'm showing a 20-odd
byte reduction in x86_64's memory.o text when it is uninlined.  Pretty
modest I guess.

