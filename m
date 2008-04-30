Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbYD3FJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbYD3FJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 01:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYD3FJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 01:09:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:55758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbYD3FJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 01:09:05 -0400
Date: Wed, 30 Apr 2008 07:09:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Tony Battersby <tonyb@cybernetics.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] more ZERO_PAGE handling ( was 2.6.24 regression: deadlock on coredump of big process)
Message-ID: <20080430050903.GC27652@wotan.suse.de>
References: <4815E932.1040903@cybernetics.com> <20080429100048.3e78b1ba.kamezawa.hiroyu@jp.fujitsu.com> <48172C72.1000501@cybernetics.com> <20080430132516.28f1ee0c.kamezawa.hiroyu@jp.fujitsu.com> <4817FDA5.1040702@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4817FDA5.1040702@kolumbus.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 08:03:33AM +0300, Mika Penttilä wrote:
> KAMEZAWA Hiroyuki wrote:
> >On Tue, 29 Apr 2008 10:10:58 -0400
> >Tony Battersby <tonyb@cybernetics.com> wrote:
> >  
> >>If I leave more memory free by changing the argument to
> >>malloc_all_but_x_mb(), then I have to increase the number of threads
> >>required to trigger the deadlock.  Changing the thread stack size via
> >>setrlimit(RLIMIT_STACK) also changes the number of threads that are
> >>required to trigger the deadlock.  For example, with
> >>malloc_all_but_x_mb(16) and the default stack size of 8 MB, <= 5 threads
> >>will coredump successfully, and >= 6 threads will deadlock.  With
> >>malloc_all_but_x_mb(16) and a reduced stack size of 4096 bytes, <= 8
> >>threads will coredump successfully, and >= 9 threads will deadlock.
> >>
> >>Also note that the "free" command reports 10 MB free memory while the
> >>program is running before the segfault is triggered.
> >>
> >>    
> >Hmm, my idea is below.
> >
> >Nick's remove ZERO_PAGE patch includes following change
> >
> >==
> >@@ -2252,39 +2158,24 @@ static int do_anonymous_page(struct mm_struct *mm, 
> >struct vm_area_struct *vma,
> >        spinlock_t *ptl;
> > {
> ><snip>
> >-               page_add_new_anon_rmap(page, vma, address);
> >-       } else {
> >-               /* Map the ZERO_PAGE - vm_page_prot is readonly */
> >-               page = ZERO_PAGE(address);
> >-               page_cache_get(page);
> >-               entry = mk_pte(page, vma->vm_page_prot);
> >+       if (unlikely(anon_vma_prepare(vma)))
> >+               goto oom;
> >+       page = alloc_zeroed_user_highpage_movable(vma, address);
> >==
> >
> >above change is for avoiding to use ZERO_PAGE at read-page-fault to 
> >anonymous
> >vma. This is reasonable I think. But at coredump, tons of 
> >read-but-never-written pages can be allocated.
> >==
> >coredump
> >  -> get_user_pages()
> >       -> follow_page() returns NULL
> >            -> handle mm fault
> >                 -> do_anonymous page.
> >==
> >follow_page() returns ZERO_PAGE only when page table is not avaiable.
> >
> >So, making follow_page() return ZERO_PAGE can be a fix of extra memory
> >consumpstion at core dump. (Maybe someone can think of other fix.)
> >
> >how about this patch ? Could you try ?
> >
> >(I'm sorry but I'll not be active for a week because my servers are 
> >powered off.)
> >
> >-Kame
> >
> >  
> 
> 
> But sure we still have to handle the fault for instance swapped pages, 
> for other uses of get_user_pages();

Yeah, it does need to test for pte_none.

