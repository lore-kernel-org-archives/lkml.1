Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZDTXl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZDTXl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZDTXlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:41:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbZDTXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:41:46 -0400
Date: Mon, 20 Apr 2009 16:37:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #13058] First hibernation attempt fails
Message-Id: <20090420163734.b8e24fc9.akpm@linux-foundation.org>
In-Reply-To: <20090420130412.bc337673.akpm@linux-foundation.org>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	<nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<20090417063007.GB4593@kernel.dk>
	<49E83DC4.8040207@tuffmail.co.uk>
	<20090417091321.GP4593@kernel.dk>
	<alpine.LFD.2.00.0904170813550.4042@localhost.localdomain>
	<20090407080632.GG1408@ucw.cz>
	<20090420122044.7ea6cc15.akpm@linux-foundation.org>
	<20090420195306.GA3299@elf.ucw.cz>
	<20090420130412.bc337673.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 13:04:12 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 20 Apr 2009 21:53:06 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > Remind me: why can't we just allocate N pages at suspend-time?
> > 
> > We need half of memory free. The reason we can't "just allocate" is
> > probably OOM killer; but my memories are quite weak :-(.
> 
> hm.  You'd think that with out splendid range of __GFP_foo falgs, there
> would be some combo which would suit this requirement but I can't
> immediately spot one.
> 
> We can always add another I guess.  Something like...
> 
> 
> diff -puN mm/page_alloc.c~a mm/page_alloc.c
> --- a/mm/page_alloc.c~a
> +++ a/mm/page_alloc.c
> @@ -1620,7 +1620,8 @@ nofail_alloc:
>  		}
>  
>  		/* The OOM killer will not help higher order allocs so fail */
> -		if (order > PAGE_ALLOC_COSTLY_ORDER) {
> +		if (order > PAGE_ALLOC_COSTLY_ORDER ||
> +				(gfp_mask & __GFP_NO_OOM_KILL)) {
>  			clear_zonelist_oom(zonelist, gfp_mask);
>  			goto nopage;
>  		}
> diff -puN include/linux/gfp.h~a include/linux/gfp.h
> --- a/include/linux/gfp.h~a
> +++ a/include/linux/gfp.h
> @@ -51,8 +51,9 @@ struct vm_area_struct;
>  #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
>  #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
>  #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
> +#define __GFP_NO_OOM_KILL ((__force gfp_t)0x200000u)  /* Don't invoke out_of_memory() */
>  
> -#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
> +#define __GFP_BITS_SHIFT 22	/* Number of__GFP_FOO bits */
>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
>  
>  /* This equals 0, but use constants in case they ever change */
> _
> 

Of course, this will protect the calling task from getting oom-killed. 
But it doesn't protect other tasks from getting oom-killed due to the
activity of _this_ task.

But I think that problem already exists, and that this proposal doesn't
worsen anything, yes?

Or is it the case that all other tasks are safely stuck in the freezer
at this time, so they won't be allocating any memory anyway?

