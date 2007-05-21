Return-Path: <linux-kernel-owner+w=401wt.eu-S1762320AbXEUSp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbXEUSp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbXEUSpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:45:15 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34478 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbXEUSpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:45:14 -0400
Date: Mon, 21 May 2007 19:44:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705211930370.31659@blonde.wat.veritas.com>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AHNyaWhhcml2aWpheWFyYWdoYXZhbkB5YWhvby5jb20uYXUAb3h5bW9yb25Ad2FzdGUub3JnAGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBqZW5zLmF4Ym9lQG9yYWNsZS5jb20AYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Christoph Lameter wrote:
> On Mon, 21 May 2007, Hugh Dickins wrote:
> 
> > Yes, sounded the same to me too: I couldn't reproduce it or see anything
> > wrong in the code back then.  But Srihari's info about CONFIG_DEBUG_SLUB
> > off has helped a lot: I was then able to reproduce it on my x86_64, and
> > after a lot of staring at the code, the problem became obvious...
> 
> Right. The #ifdef CONFIG_SLUB_DEBUG is at the wrong location. The best fix
> is to moving the #ifdef otherwise the size is still wrong for the 
> ctor case.

? My patch did handle the ctor case.

> 
> SLUB Debug: Fix object size calculation
> 
> The object size calculation is wrong if !CONFIG_SLUB_DEBUG because
> the #ifdef CONFIG_SLUB_DEBUG is now switching off the size adjustments
> for DESTROY_BY_RCU and ctor.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

Yes, I think that should do it too.  The reason behind my repeating
the block was to handle the case where SLAB_POISON is passed to
kmem_cache_create, but CONFIG_SLUB_DEBUG is off.  But apparently
that case would hit the BUG_ON(flags & ~CREATE_MASK), therefore
your patch is simpler and better.  Quite a maze.

Hugh

> 
> ---
>  mm/slub.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: slub/mm/slub.c
> ===================================================================
> --- slub.orig/mm/slub.c	2007-05-21 11:21:36.000000000 -0700
> +++ slub/mm/slub.c	2007-05-21 11:21:49.000000000 -0700
> @@ -1943,7 +1943,6 @@ static int calculate_sizes(struct kmem_c
>  	 */
>  	s->inuse = size;
>  
> -#ifdef CONFIG_SLUB_DEBUG
>  	if (((flags & (SLAB_DESTROY_BY_RCU | SLAB_POISON)) ||
>  		s->ctor)) {
>  		/*
> @@ -1958,6 +1957,7 @@ static int calculate_sizes(struct kmem_c
>  		size += sizeof(void *);
>  	}
>  
> +#ifdef CONFIG_SLUB_DEBUG
>  	if (flags & SLAB_STORE_USER)
>  		/*
>  		 * Need to store information about allocs and frees after
