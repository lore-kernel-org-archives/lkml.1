Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbZE2JHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbZE2JHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbZE2JH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:07:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33291 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842AbZE2JHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:07:24 -0400
Subject: Re: [PATCH] slab: remove bootmem calling
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, mpm@selenic.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <4A1F37DD.5030800@kernel.org>
References: <1243517365.11533.65.camel@penberg-laptop>
	 <4A1F3724.8050103@kernel.org>  <4A1F37DD.5030800@kernel.org>
Date: Fri, 29 May 2009 12:07:24 +0300
Message-Id: <1243588044.15371.10.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 18:18 -0700, Yinghai Lu wrote:
> Yinghai Lu wrote:
> > mem_init/kmem_cache_init is moved up
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > ---
> >  mm/page_cgroup.c |   12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6/mm/page_cgroup.c
> > ===================================================================
> > --- linux-2.6.orig/mm/page_cgroup.c
> > +++ linux-2.6/mm/page_cgroup.c
> > @@ -47,6 +47,8 @@ static int __init alloc_node_page_cgroup
> >  	struct page_cgroup *base, *pc;
> >  	unsigned long table_size;
> >  	unsigned long start_pfn, nr_pages, index;
> > +	struct page *page;
> > +	unsigned int order;
> >  
> >  	start_pfn = NODE_DATA(nid)->node_start_pfn;
> >  	nr_pages = NODE_DATA(nid)->node_spanned_pages;
> > @@ -55,11 +57,13 @@ static int __init alloc_node_page_cgroup
> >  		return 0;
> >  
> >  	table_size = sizeof(struct page_cgroup) * nr_pages;
> > -
> > -	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
> > -			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
> > -	if (!base)
> > +	order = get_order(table_size);
> > +	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);
> > +	if (!page)
> > +		page = alloc_pages_node(-1, GFP_NOWAIT | __GFP_ZERO, order);
> > +	if (!page)
> >  		return -ENOMEM;
> > +	base = page_address(page);
> 
> any good way to replace __alloc_bootmem_node that could take alignment?

Not that I am aware of. Where do you need that? This one looks ok to me
as page allocator obviously returns PAGE_SIZE aligned chunks.

			Pekka

