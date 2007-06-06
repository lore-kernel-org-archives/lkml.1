Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXFFJMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXFFJMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbXFFJMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:12:15 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:27496 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755175AbXFFJMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:12:14 -0400
Subject: Re: [PATCH 4/4] mm: variable length argument support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       Ollie Wild <aaw@google.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <20070606020651.19a89dca.akpm@linux-foundation.org>
References: <20070605150523.786600000@chello.nl>
	 <20070605151203.790585000@chello.nl>
	 <20070606013658.20bcbe2f.akpm@linux-foundation.org>
	 <1181120061.7348.177.camel@twins>
	 <20070606020651.19a89dca.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 11:12:09 +0200
Message-Id: <1181121129.7348.181.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 02:06 -0700, Andrew Morton wrote:
> On Wed, 06 Jun 2007 10:54:21 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > > > It is a bit peculiar in that we have one task with two mm's, one of which is
> > > > inactive.
> > > > 
> > > > ...
> > > >
> > > > +				flush_cache_page(bprm->vma, kpos,
> > > > +						 page_to_pfn(kmapped_page));
> > 
> > Bah, and my frv cross build bums out on an unrelated change,..
> > I'll see if I can get a noMMU arch building, in the mean time, would you
> > try this:
> > 
> > ---
> > 
> > Since no-MMU doesn't do the fancy inactive mm access there is no need to
> > flush cache.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> > 
> > Index: linux-2.6-2/fs/exec.c
> > ===================================================================
> > --- linux-2.6-2.orig/fs/exec.c	2007-06-05 16:48:52.000000000 +0200
> > +++ linux-2.6-2/fs/exec.c	2007-06-06 10:49:19.000000000 +0200
> > @@ -428,8 +428,10 @@ static int copy_strings(int argc, char _
> >  				kmapped_page = page;
> >  				kaddr = kmap(kmapped_page);
> >  				kpos = pos & PAGE_MASK;
> > +#ifdef CONFIG_MMU
> >  				flush_cache_page(bprm->vma, kpos,
> >  						 page_to_pfn(kmapped_page));
> > +#endif
> >  			}
> >  			if (copy_from_user(kaddr+offset, str, bytes_to_copy)) {
> >  				ret = -EFAULT;
> > 
> 
> I think the same problem will happen on NOMMU && STACK_GROWS_UP.  There are
> several new references to bprm->vma in there, not all inside CONFIG_MMU.

Right, which archs have that combo? I'll go gather cross compilers.

Perhaps I'd better create a flush_arg_page() function and stick that in
the mmu/nommu section somewhere earlier on in that file. Patch in a few.

A related question; does anybody know of a no-MMU arch that uses
fs/compat.c ? If there is such a beast, that would need some work.

