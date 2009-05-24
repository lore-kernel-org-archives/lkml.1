Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZEXSUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZEXSUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 14:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZEXSTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 14:19:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbZEXSTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 14:19:54 -0400
Date: Sun, 24 May 2009 11:18:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
Message-ID: <alpine.LFD.2.01.0905240947490.3435@localhost.localdomain>
References: <20090518142707.GA24142@elte.hu> <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain> <20090518164921.GA6903@elte.hu> <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain> <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu>
 <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain> <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain> <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 May 2009, Pekka J Enberg wrote:
>
> Ingo, here's a patch that boots UMA+SMP+SLUB x86-64 kernel on qemu all 
> the way to userspace. It probably breaks bunch of things for now but 
> something for you to play with if you want.

Just looking at the patch (not actually trying it out in any way or 
looking at some bigger context), this absolutely looks like the right 
direction to go in.

Our order in init/main.c is largely totally historical, and I think it 
makes tons of sense to move the memory allocation initialization up much 
earlier. 

In fact, it would be nice to perhaps try to move it even earlier. Now you 
moved it to before the scheduler init (good!), but I do wonder if it could 
be moved up to even before the setup_per_cpu_areas() etc crud. 

I realize that the allocator wants to use the per-CPU area, but if we have 
just the boot CPU area set up statically at that point, since it's only 
the boot CPU running, maybe we could do those per-cpu area allocations 
without the bootmem allocator too?

But even just getting bootmem out of the scheduler setup is a big 
improvement, I think. So this patch looks very promising as is.

Did you test whether the other allocators were ok with this too?

		Linus
