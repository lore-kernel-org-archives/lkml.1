Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXFFJH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXFFJH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXFFJHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:07:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbXFFJHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:07:14 -0400
Date: Wed, 6 Jun 2007 02:06:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       Ollie Wild <aaw@google.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 4/4] mm: variable length argument support
Message-Id: <20070606020651.19a89dca.akpm@linux-foundation.org>
In-Reply-To: <1181120061.7348.177.camel@twins>
References: <20070605150523.786600000@chello.nl>
	<20070605151203.790585000@chello.nl>
	<20070606013658.20bcbe2f.akpm@linux-foundation.org>
	<1181120061.7348.177.camel@twins>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 10:54:21 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > It is a bit peculiar in that we have one task with two mm's, one of which is
> > > inactive.
> > > 
> > > ...
> > >
> > > +				flush_cache_page(bprm->vma, kpos,
> > > +						 page_to_pfn(kmapped_page));
> 
> Bah, and my frv cross build bums out on an unrelated change,..
> I'll see if I can get a noMMU arch building, in the mean time, would you
> try this:
> 
> ---
> 
> Since no-MMU doesn't do the fancy inactive mm access there is no need to
> flush cache.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> 
> Index: linux-2.6-2/fs/exec.c
> ===================================================================
> --- linux-2.6-2.orig/fs/exec.c	2007-06-05 16:48:52.000000000 +0200
> +++ linux-2.6-2/fs/exec.c	2007-06-06 10:49:19.000000000 +0200
> @@ -428,8 +428,10 @@ static int copy_strings(int argc, char _
>  				kmapped_page = page;
>  				kaddr = kmap(kmapped_page);
>  				kpos = pos & PAGE_MASK;
> +#ifdef CONFIG_MMU
>  				flush_cache_page(bprm->vma, kpos,
>  						 page_to_pfn(kmapped_page));
> +#endif
>  			}
>  			if (copy_from_user(kaddr+offset, str, bytes_to_copy)) {
>  				ret = -EFAULT;
> 

I think the same problem will happen on NOMMU && STACK_GROWS_UP.  There are
several new references to bprm->vma in there, not all inside CONFIG_MMU.

