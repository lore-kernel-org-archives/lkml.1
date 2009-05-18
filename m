Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZERWIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZERWIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 18:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZERWIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 18:08:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbZERWH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 18:07:59 -0400
Date: Mon, 18 May 2009 15:06:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <20090518202031.GA26549@elte.hu>
Message-ID: <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
References: <20090518142707.GA24142@elte.hu> <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain> <20090518164921.GA6903@elte.hu> <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain> <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu>
 <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain> <20090518202031.GA26549@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 May 2009, Ingo Molnar wrote:
> 
> ok. I've queued it up for .31, with your Acked-by. (which i assume 
> your reply implies?)

Yes.

> > I hate that stupid bootmem allocator. I suspect we seriously 
> > over-use it, and that we _should_ be able to do the SL*B init 
> > earlier.
> 
> Hm, tempting thought - not sure how to pull it off though.

As far as I can recall, one of the things that historically made us want 
to use the bootmem allocator even relatively late was that the real SLAB 
allocator had to wait until all the node information etc was initialized. 

That's pretty damn late. And I wonder if SLUB (and SLOB) might not need a 
lot less initialization, and work much earlier. Something like that might 
be the final nail in the coffin for SLAB, and convince me to just say 
'we don't support it any more".

That said, for the case of things like 'static_sched_group' and 
'static_sched_domain', the problem might well be not just about the 
allocation itself, but simply about the use of those variables. Maybe they 
themselves are needed before we've done all the CPU setup?

> One of the biggest user of bootmem is the mem_map[] hierarchies and 
> the page allocator bitmaps. Not sure we can get rid of bootmem there 
> - those areas are really large, physical memory is often fragmented 
> and we need a good NUMA sense for them as well.

I think that's the _valid_ kind of use of a bootmem allocator.

But for something like the scheduler data structures? Not so much.

		Linus
