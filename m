Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbXGSUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbXGSUOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXGSUOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:14:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878AbXGSUOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:14:09 -0400
Date: Thu, 19 Jul 2007 13:13:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: Powerpc - Include pagemap.h in asm/powerpc/tlb.h
Message-Id: <20070719131348.170443bb.akpm@linux-foundation.org>
In-Reply-To: <D9805F9D-04B0-4422-81F1-958B15482A93@kernel.crashing.org>
References: <20070714012033.GC31649@Krystal>
	<20070718223034.7388e59f.akpm@linux-foundation.org>
	<D9805F9D-04B0-4422-81F1-958B15482A93@kernel.crashing.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 14:55:23 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> 
> On Jul 19, 2007, at 12:30 AM, Andrew Morton wrote:
> 
> > On Fri, 13 Jul 2007 21:20:33 -0400 Mathieu Desnoyers  
> > <mathieu.desnoyers@polymtl.ca> wrote:
> >
> >> Powerpc - Include pagemap.h in asm/powerpc/tlb.h
> >>
> >> Fixes this powerpc build error in 2.6.22-rc6-mm1 for powerpc 64 :
> >>
> >> In file included from include2/asm/tlb.h:60,
> >>                  from /home/compudj/git/linux-2.6-lttng/arch/ 
> >> powerpc/mm/init_64.
> >> c:56:
> >> /home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h: In  
> >> function 'tlb_fl
> >> ush_mmu':
> >> /home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h:76:  
> >> error: implicit
> >> declaration of function 'release_pages'
> >> /home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h: In  
> >> function 'tlb_re
> >> move_page':
> >> /home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h:105:  
> >> error: implicit
> >>  declaration of function 'page_cache_release'
> >
> > You have some wordwrapping going on there.
> >
> >> make[2]: *** [arch/powerpc/mm/init_64.o] Error 1
> >>
> >> release_pages is declared in linux/pagemap.h, but cannot be  
> >> included in
> >> linux/swap.h because of a sparc related comment:
> >>
> >> /* only sparc can not include linux/pagemap.h in this file
> >>  * so leave page_cache_release and release_pages undeclared... */
> >> #define free_page_and_swap_cache(page) \
> >>         page_cache_release(page)
> >> #define free_pages_and_swap_cache(pages, nr) \
> >>         release_pages((pages), (nr), 0);
> >
> > It's always a worry when this happens.  What change made us need this
> > inclusion?  How come you're hitting it but I (and test.kernel.org,  
> > at least)
> > did not?  How come so few other architectures include pagemap.h from
> > asm/tlb.h?  Why do header files get into such a mess?
> >
> >
> >> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> >> CC: linuxppc-dev@ozlabs.org
> >> CC: Paul Mackerras <paulus@samba.org>
> >> ---
> >>  include/asm-powerpc/tlb.h |    2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> Index: linux-2.6-lttng/include/asm-powerpc/tlb.h
> >> ===================================================================
> >> --- linux-2.6-lttng.orig/include/asm-powerpc/tlb.h	2007-07-13  
> >> 11:30:54.000000000 -0400
> >> +++ linux-2.6-lttng/include/asm-powerpc/tlb.h	2007-07-13  
> >> 11:31:22.000000000 -0400
> >> @@ -23,6 +23,8 @@
> >>  #include <asm/mmu.h>
> >>  #endif
> >>
> >> +#include <linux/pagemap.h>
> >> +
> >>  struct mmu_gather;
> >>
> >
> > Oh well.  I queued it up for someone else to worry over ;)
> 
> Andrew,
> 
> Are you sending this to linus directly or should this go via paul and  
> me?
> 

I queued it up for Paul.  I can send it over to Linus today if we have a
reason for that.  It's just that I dont understand the patch: does it fix
-mm-only breakage?  Does it fix something which already got fixed, or what?

One might think "gee, it's trivial, just slam it in", but these nested
includes are often not-trivial and something else can explode as a result.

