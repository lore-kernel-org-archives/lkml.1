Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZEZHdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZEZHdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZEZHdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:33:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:58797 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbZEZHdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:33:45 -0400
Date: Tue, 26 May 2009 09:33:44 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090526073344.GD21496@wotan.suse.de>
References: <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu> <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu> <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI> <20090525112504.GB24071@wotan.suse.de> <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com> <20090525114127.GE24071@wotan.suse.de> <Pine.LNX.4.64.0905251443390.4115@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0905250930530.3435@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905250930530.3435@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 09:39:36AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 25 May 2009, Pekka J Enberg wrote:
> > diff --git a/init/main.c b/init/main.c
> > index 33ce929..fb0e004 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -576,6 +576,22 @@ asmlinkage void __init start_kernel(void)
> >  	setup_nr_cpu_ids();
> >  	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
> >  
> > +	build_all_zonelists();
> > +	page_alloc_init();
> > +
> > +	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
> > +	parse_early_param();
> > +	parse_args("Booting kernel", static_command_line, __start___param,
> > +		   __stop___param - __start___param,
> > +		   &unknown_bootoption);
> > +	pidhash_init();
> > +	vmalloc_init();
> > +	vfs_caches_init_early();
> > +	/*
> > +	 * Set up kernel memory allocators
> > +	 */
> > +	mem_init();
> > +	kmem_cache_init();
> 
> So what strikes me is a question:
> 
>  - why do we want to do pidhash_init and vfs_caches_init_early() so early?
> 
> Yes, pidhash_init() now uses alloc_bootmem. It's an allocation that is not 
> trivially small, but it's not humongous either (max 4096 hash list heads, 
> one pointer each).

It would be nice to use the regular page allocator for pidhash_init; For
my case, I have this patch floating around for a long time which can make
this (among other things) dynamically resizable without using locking, and
avoiding the special case for the bootmem allocated hash would be good. 


> And vfs_caches_init_early() is actually doing some rather strange things, 
> like doing a "alloc_large_system_hash()" but not unconditionally: it does 
> it in the "late" initialization too, if not done early. inode_init_early 
> does soemthing very similar (ie a _conditional_ early init).
> 
> So none of this seems to really get a huge advantage from the early init. 
> There seems to be some subtle NUMA issues, but do we really want that? I 
> get the feeling that nobody ever wanted to do it early, and then the NUMA 
> people said "I don't wnt to do this early, but I don't want to touch the 
> non-NUMA case, so I'll do it early for non-numa, and late for numa".
 
vfs_caches_init_early wants to allocate with bootmem so it can get
>= MAX_ORDER cache size in the kernel direct mapping. In the NUMA
case, it is more important to spread the memory usage and utilisation
over nodes I guess so they use vmalloc for that. Bootmem and vmalloc
are not available at the same time, so it has to be 2 cases.


> I'm also not entirely sure we really need to do vmalloc_init() that early, 
> but I dunno. It also uses alloc_bootmem().

Probably not. vmalloc doesn't really work without the page allocator and
slab allocator already up, so it can probably be moved after them.

