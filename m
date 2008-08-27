Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbYH0Cx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbYH0Cx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 22:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYH0Cxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 22:53:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbYH0Cxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 22:53:45 -0400
Date: Tue, 26 Aug 2008 19:52:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Parag Warudkar <parag.lkml@gmail.com>
cc: Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <f7848160808261936m18c69dc0r26f41850efae4b91@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808261942100.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>  <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>  <20080826183051.GB10925@cs181140183.pp.htv.fi>  <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>  <20080826205916.GB11734@cs181140183.pp.htv.fi>
  <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>  <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>  <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>  <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
  <alpine.LFD.1.10.0808261837530.3363@nehalem.linux-foundation.org> <f7848160808261936m18c69dc0r26f41850efae4b91@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Parag Warudkar wrote:
> 
> What about deep call chains? The problem with the uptake of 4K stacks
> seems to be that is not reliably provable that it will work under all
> circumstances.

Umm. Neither is 8k stacks. Nobody "proved" anything.

But yes, some subsystems have insanely deep call chains. And yes, things 
like the VFS recursion (for symlinks) makes that deeper yet for 
filesystems, although only on the lookup path. And that is exactly the 
kind of thing that can exacerbate the problem of the compiler artificially 
making for a bigger stack footprint of a function (*).

For things like the VFS layer, right now we allow a nesting level of 8, I 
think. If I remember correctly, it was 5 historically. Part of raising 
that depth, though, was that we actually moved the recursive part into 
fs/namei.c, and the nesting stack-depth was something pretty damn small 
when the filesystem used "follow_link" properly and let the VFS do it for 
it (ie the callchain to actually look up the link could be deep, but it 
would not recurse back, and instead just return a pointer, so that the 
actual _recursive_ part was just __do_follow_link() and is just a few 
words on the stack).

So yes, we do have some deep callchains, but they tend to be pretty well 
managed for _good_ code. The problems tend to be the areas with lots of 
indirection layers, and yeah, XFS, MD and ACPI all have those kinds of 
things.

In an embdedded world, many of those should be a non-issue, though. 

			Linus

(*) ie the function that _is_ on the deep chain doesn't actually need much 
of a stack footprint at all itself, but it may call a helper function that 
is _not_ in the deep chain, and if it gets inlined it may give its 
excessive stack footprint to the deep chain - and this is _exactly_ the 
problem that happened with inlining "load_module()".
