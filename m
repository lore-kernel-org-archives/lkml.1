Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbZEYMMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbZEYMMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZEYMM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:12:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:35175 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZEYMM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:12:27 -0400
Date: Mon, 25 May 2009 14:12:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090525121225.GF24071@wotan.suse.de>
References: <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu> <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu> <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI> <20090525112504.GB24071@wotan.suse.de> <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com> <20090525114127.GE24071@wotan.suse.de> <Pine.LNX.4.64.0905251503480.4279@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905251503480.4279@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 03:04:20PM +0300, Pekka Enberg wrote:
> > On Mon, May 25, 2009 at 02:37:59PM +0300, Pekka Enberg wrote:
> > > On Mon, May 25, 2009 at 2:25 PM, Nick Piggin <npiggin@suse.de> wrote:
> > > > The bootmem allocations of course are required because some hashes may
> > > > need to be larger than MAX_ORDER without using vmalloc.
> > > >
> > > > kmem_cache_init (and mem_init, partially) sets up the kernel memory
> > > > allocators...
> > > 
> > > Which comment are you talking about? The "setup kernel memory
> > > allocators" one? Yeah, I should probably move it couple of lines down.
>  
> On Mon, 25 May 2009, Nick Piggin wrote:
> > Yes, just that one.
> 
> And oh, we probably want to do this too while at it. Nick?
> 
> >From b211497261670ff6f9af6b8b0fab429e848ccc87 Mon Sep 17 00:00:00 2001
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> Date: Mon, 25 May 2009 15:01:35 +0300
> Subject: [PATCH] vmalloc: use kzalloc() instead of alloc_bootmem()
> 
> We can call vmalloc_init() after kmem_cache_init() and use kzalloc() instead of
> the bootmem allocator when initializing vmalloc data structures.
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  init/main.c  |    2 +-
>  mm/vmalloc.c |    3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index fb0e004..766194c 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -585,13 +585,13 @@ asmlinkage void __init start_kernel(void)
>  		   __stop___param - __start___param,
>  		   &unknown_bootoption);
>  	pidhash_init();
> -	vmalloc_init();
>  	vfs_caches_init_early();
>  	/*
>  	 * Set up kernel memory allocators
>  	 */
>  	mem_init();
>  	kmem_cache_init();
> +	vmalloc_init();

vmalloc won't work fully without slab and page allocators anyway, so this
is conceptually a bugfix I think. Ack.
