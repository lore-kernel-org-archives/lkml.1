Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZFIPI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZFIPI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZFIPIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:08:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751579AbZFIPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:08:20 -0400
Date: Tue, 9 Jun 2009 08:07:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <20090609121055.GA9158@wotan.suse.de>
Message-ID: <alpine.LFD.2.01.0906090802400.6847@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
 <20090609093918.GC16940@wotan.suse.de> <20090609111719.GA4463@elte.hu> <20090609121055.GA9158@wotan.suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Jun 2009, Nick Piggin wrote:

> On Tue, Jun 09, 2009 at 01:17:19PM +0200, Ingo Molnar wrote:
> > 
> >  - The buddy allocator allocates top down, with highmem pages first.
> >    So a lot of critical apps (the first ones started) will have 
> >    highmem footprint, and that shows up every time they use it for 
> >    file IO or other ops. kmap() overhead and more.
> 
> Yeah this really sucks about it. OTOH, we have basically the same
> thing today with NUMA allocations and task placement.

It's not the buddy allocator. Each zone has it's own buddy list.

It's that we do the zones in order, and always start with the HIGHMEM 
zone. 

Which is quite reasonablefor most loads (if the page is only used as a 
user mapping, we won't kmap it all that often), but it's bad for things 
where we will actually want to touch it over and over again. Notably 
filesystem caches that aren't just for user mappings.

> > Highmem simply enables a sucky piece of hardware so the code itself 
> > has an intrinsic level of suckage, so to speak. There's not much to 
> > be done about it but it's not a _big_ problem either: this type of 
> > hw is moving fast out of the distro attention span.
> 
> Yes but Linus really hated the code. I wonder whether it is
> generic code or x86 specific. OTOH with x86 you'd probably
> still have to support different page table formats, at least,
> so you couldn't rip it all out.

The arch-specific code really isn't that nasty. We have some silly 
workarouds for doing 8-byte-at-a-time operations on x86-32 with cmpxchg8b 
etc, but those are just odd small details.

If highmem was just a matter of arch details, I wouldn't mind it at all.

It's the generic code pollution I find annoying. It really does pollute a 
lot of crap. Not just fs/ and mm/, but even drivers. 

		Linus
