Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbXIUAtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbXIUAtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 20:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbXIUAtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 20:49:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38402 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbXIUAto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 20:49:44 -0400
Date: Fri, 21 Sep 2007 09:50:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       ricknu-0@student.ltu.se
Subject: Re: [RFC][PATCH] page->mapping clarification [1/3] base functions
Message-Id: <20070921095054.6386bae1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0709201120510.8801@schroedinger.engr.sgi.com>
References: <20070919164308.281f9960.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0709201120510.8801@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 11:26:47 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 19 Sep 2007, KAMEZAWA Hiroyuki wrote:
> 
> > Any comments are welcome.
> 
> I am still a bit confused as to what the benefit of this is.
> 
Honestly, I have 3 purposes, 2 for readability/clarificaton and 1 for my trial.

1. Clarify page cache <-> inode relationship before *new concept of page cache*,
   yours or someone else's is introduced.

2. There are some places using PAGE_MAPPING_ANON directly. I don't want to see
   following line in .c file. 
   ==
   anon_vma = (struct anon_vma *)(mapping - PAGE_MAPPING_ANON);
   ==

3. I want to *try* page->mapping overriding... store  memory resource controller's   
   information in page->mapping. By this, memory controller doesn't enlarge sizeof
   struct page. (works well in my small test.)
   Before doing that, I have to hide page->mapping from direct access.


> > +/*
> > + * On an anonymous page mapped into a user virtual memory area,
> > + * page->mapping points to its anon_vma, not to a struct address_space;
> > + * with the PAGE_MAPPING_ANON bit set to distinguish it.
> > + *
> > + * Please note that, confusingly, "page_mapping" refers to the inode
> > + * address_space which maps the page from disk; whereas "page_mapped"
> > + * refers to user virtual address space into which the page is mapped.
> > + */
> > +#define PAGE_MAPPING_ANON       1
> > +
> > +static inline bool PageAnon(struct page *page)
> 
> bool??? That is unusual?

This is my first experience of using bool in Linux kernel.. :)

I know bool is not very widely used in Linux now but I tried it because 
this function obviously returns yes or no, and C language supports bool as
_Bool now. If messy, I'll avoid using this in this time..


> 
> > +static inline struct address_space *page_mapping_cache(struct page *page)
> > +{
> > +	if (!page->mapping || PageAnon(page))
> > +		return NULL;
> > +	return page->mapping;
> > +}
> 
> That is confusing.
> 
> if (PageAnon(page))
> 	return NULL;
> return page->mapping;
ok,

> > +static inline struct address_space *page_mapping(struct page *page)
> > +{
> > +	struct address_space *mapping = page->mapping;
> > +
> > +	VM_BUG_ON(PageSlab(page));
> > +	if (unlikely(PageSwapCache(page)))
> > +		mapping = &swapper_space;
> > +#ifdef CONFIG_SLUB
> > +	else if (unlikely(PageSlab(page)))
> > +		mapping = NULL;
> > +#endif
> 
> The #ifdef does not exist in rc6-mm1. No need to reintroduce it.
> 
ok, thanks.

> > +static inline bool
> > +is_page_consistent(struct page *page, struct address_space *mapping)
> > +{
> > +	struct address_space *check = page_mapping_cache(page);
> > +	return (check == mapping);
> > +}
> 
> Why do we need a special function? Why is it safer?
> 
For clarify meaning of compareing page_mapping_cache() with mapping.
Does this reduce readability ?

Thank you for comments.

Regards,
-Kame





