Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbYHZVAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbYHZVAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYHZVAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:00:07 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53135 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYHZVAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:00:05 -0400
Date: Tue, 26 Aug 2008 23:59:16 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080826205916.GB11734@cs181140183.pp.htv.fi>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org> <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 11:47:01AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 26 Aug 2008, Adrian Bunk wrote:
> > 
> > I added "-fno-inline-functions-called-once -fno-early-inlining" to 
> > KBUILD_CFLAGS, and (with gcc 4.3) that increased the size of my kernel 
> > image by 2%.
> 
> Btw, did you check with just "-fno-inline-functions-called-once"?
> 
> The -fearly-inlining decisions _should_ be mostly right. If gcc sees early 
> that a function is so small (even without any constant propagation etc) 
> that it can be inlined, it's probably right. 
> 
> The inline-functions-called-once thing is what causes even big functions 
> to be inlined, and that's where you find the big downsides too (eg the 
> stack usage).

-fno-inline-functions-called-once alone costs me nearly 1% in code size.

And I'd expect it to become more with "-fwhole-program --combine".


If you think we have too many stacksize problems I'd suggest to consider 
removing the choice of 4k stacks on i386, sh and m68knommu instead of 
using -fno-inline-functions-called-once:

Now that 32bit x86 is no longer used for extreme highend configurations 
the only serious usecase for 4k stacks are AFAIK space savings on 
embedded archs.

4k stacks have caused us much pain [1], and the cases where gcc inlined 
too much were the easy ones.

I'm not saying that I'd like removing the choice of 4k stacks, but if we 
want to reduce the number of stack related problems that's IMHO the 
better alternative.


> 			Linus

cu
Adrian

[1] AFAIR some callpaths in the kernel are still too big

BTW: In case anyone wonders about why I suggest removing 4k stacks:
     My position is that 4k stacks should either be enabled 
     unconditionally or no longer offered at all.
     And if we remove 4k stacks from 32bit x86 it's no longer 
     realistically maintainable for other architectures.

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

