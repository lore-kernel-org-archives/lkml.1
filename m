Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZGBQ00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZGBQ00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZGBQ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:26:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbZGBQ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:26:16 -0400
Date: Thu, 2 Jul 2009 09:25:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Kevin Cernekee <cernekee@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix virt_to_phys() warnings
Message-Id: <20090702092536.b0f6a3da.akpm@linux-foundation.org>
In-Reply-To: <20090702104027.GB14804@linux-mips.org>
References: <910ba280decc9ee53d9971ba04f73fab@localhost>
	<20090701224627.0b2704df.akpm@linux-foundation.org>
	<20090702104027.GB14804@linux-mips.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 11:40:27 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:

> On Wed, Jul 01, 2009 at 10:46:27PM -0700, Andrew Morton wrote:
> 
> > > mm/page_alloc.c: In function 'alloc_pages_exact':
> > > mm/page_alloc.c:1986: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast
> > > 
> > > drivers/usb/mon/mon_bin.c: In function 'mon_alloc_buff':
> > > drivers/usb/mon/mon_bin.c:1264: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast
> > > 
> > > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> > > ---
> > > diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
> > > index f8d9045..0f7a30b 100644
> > > --- a/drivers/usb/mon/mon_bin.c
> > > +++ b/drivers/usb/mon/mon_bin.c
> > > @@ -1261,7 +1261,7 @@ static int mon_alloc_buff(struct mon_pgmap *map, int npages)
> > >  			return -ENOMEM;
> > >  		}
> > >  		map[n].ptr = (unsigned char *) vaddr;
> > > -		map[n].pg = virt_to_page(vaddr);
> > > +		map[n].pg = virt_to_page((void *) vaddr);
> > >  	}
> > >  	return 0;
> > >  }
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 5d714f8..f6180db 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1983,7 +1983,7 @@ void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
> > >  		unsigned long alloc_end = addr + (PAGE_SIZE << order);
> > >  		unsigned long used = addr + PAGE_ALIGN(size);
> > >  
> > > -		split_page(virt_to_page(addr), order);
> > > +		split_page(virt_to_page((void *)addr), order);
> > >  		while (used < alloc_end) {
> > >  			free_page(used);
> > >  			used += PAGE_SIZE;
> > 
> > The virt_to_foo() functions were written back in the Linux dark ages and
> > they're horrid.  A byzantine mixture of macros and typecasts which make
> > it really hard to work out what type their argument actually should be.
> 
> No disagreement there.
> 
> > virt_to_page() takes an argument of type `unsigned long'.  (except for
> > the include/asm-generic/page.h version which takes any damn type at
> > all).
> 
> You meant it takes a pointer argument, for example:
> 
> mm/page_alloc.c:
> 	__free_pages(virt_to_page((void *)addr), order);
> mm/slob.c:
> static inline struct slob_page *slob_page(const void *addr)
> {
>         return (struct slob_page *)virt_to_page(addr);
> }
> 

lol.  I think you're right.  What a crock.

looky, they're popping up everywhere:

: static void perf_mmap_free_page(unsigned long addr)
: {
: 	struct page *page = virt_to_page(addr);
: 

And mm/nommu.c:

: int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
: 		     unsigned long start, int nr_pages, int flags,
:		     struct page **pages, struct vm_area_struct **vmas)
: {
: 	...
:                       pages[i] = virt_to_page(start);


: static void free_page_series(unsigned long from, unsigned long to)
: {
: 	for (; from < to; from += PAGE_SIZE) {
: 		struct page *page = virt_to_page(from);

Heaven knows how many more there are.  I guess we should drag x86's
virt_to_page()/virt_to_phys() into the 1980's by doing some
compile-time arg checking?

>
> ...
> 
> Anyway, since virt_to_page and virt_to_phys (imho :-) take the same
> argument times I'm in favor of Kevin's patch.

yup, I'll queue it.
