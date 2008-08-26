Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbYHZSbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbYHZSbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbYHZSbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:31:40 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43267 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171AbYHZSbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:31:39 -0400
Date: Tue, 26 Aug 2008 21:30:51 +0300
From: Adrian Bunk <bunk@kernel.org>
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
Message-ID: <20080826183051.GB10925@cs181140183.pp.htv.fi>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 10:35:05AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 26 Aug 2008, Rusty Russell wrote:
> > 
> > Your workaround is very random, and that scares me.  I think a huge number of 
> > CPUs needs a real solution (an actual cpumask allocator, then do something 
> > clever if we come across an actual fastpath).
> 
> The thing is, the inlining thing is a separate issue.
> 
> Yes, the cpumasks were what made stack pressure so critical to begin with, 
> but no, a 400-byte stack frame in a deep callchain isn't acceptable 
> _regardless_ of any cpumask_t issues.
> 
> Gcc inlining is a total and utter pile of shit. And _that_ is the problem. 
> I seriously think we shouldn't allow gcc to inline anything at all unless 
> we tell it to. That's how it used to work, and quite frankly, that's how 
> it _should_ work.
> 
> The downsides of inlining are big enough from both a debugging and a real 
> code generation angle (eg stack usage like this), that the upsides 
> (_somesimes_ smaller kernel, possibly slightly faster code) simply aren't 
> relevant.
>...
> It would be interesting to see what "-fno-default-inline" does to the 
> kernel. It really would get rid of a _lot_ of gcc version issues too. 
> Inlining behavior of gcc has long been a problem for us.

I added "-fno-inline-functions-called-once -fno-early-inlining" to 
KBUILD_CFLAGS, and (with gcc 4.3) that increased the size of my kernel 
image by 2%.

And when David's "-fwhole-program --combine" will become ready the cost
of disallowing gcc to inline functions will most likely increase.

A debugging option (for better traces) to disallow gcc some inlining 
might make sense (and might even make sense for distributions to 
enable in their kernels), but when you go to use cases that require
really small kernels the cost is too high.

But if you don't trust gcc's inlining you should revert
commit 3f9b5cc018566ad9562df0648395649aebdbc5e0 that increases gcc's 
freedom regarding what to inline in 2.6.27 - what gcc 4.2 does in the 
case of the regression tracked as Bugzilla #11276 is really not funny 
(two callers -> function not inlined; gcc seems to emit the function 
although both callers later get removed (or at least should be removed) 
by dead code elimination).

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

