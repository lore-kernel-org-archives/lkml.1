Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYBHIKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYBHIKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761679AbYBHIJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:09:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38111 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426AbYBHIJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:09:56 -0500
Date: Fri, 8 Feb 2008 09:09:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH 1/2] kmemcheck v3
Message-ID: <20080208080939.GA11863@elte.hu>
References: <47AB79D4.2070605@gmail.com> <Pine.LNX.4.64.0802071341500.2544@schroedinger.engr.sgi.com> <19f34abd0802071412m569e4993kffb4a3af163fa16c@mail.gmail.com> <Pine.LNX.4.64.0802071443440.3289@schroedinger.engr.sgi.com> <19f34abd0802071518j1ffc3dafp46fcbd8d36d36f17@mail.gmail.com> <Pine.LNX.4.64.0802071530040.3845@schroedinger.engr.sgi.com> <84144f020802072240o20ae7420x2e404e731a629c24@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802072240o20ae7420x2e404e731a629c24@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Feb 8, 2008 1:32 AM, Christoph Lameter <clameter@sgi.com> wrote:
> > But the slab layer allocates pages < PAGE_SIZE. You need to take a 
> > fault right? So each object would need its own page?
> 
> No. We allocate a shadow page for each data page which we then use as 
> a per-byte "bitmap." For every tracked _page_ we take the page fault 
> always.

it should also be made clear that not only does kmemcheck consume half 
of the RAM to do byte granular tracking of the other half of RAM, it's 
also slow, very slow, because almost every kernel-space instruction will 
generate a pagefault and then it will be single-stepped and it takes a 
debug fault as well.

That's of course totally crazy, but that's also OK and it's what makes 
the feature so interesting and powerful.

For example, when CONFIG_DEBUG_PAGEALLOC=y was introduced 5 years ago, 
it was almost unusable on modern hardware, due to the slowdown it gave. 
People said "twiddling ptes and flushing the TLB for every allocation, 
that's crazy!".

Today it can be enabled without noticing anything on a desktop, and it 
catches lots of nasty bugs.

The many debugging helpers Linux has are our eyes and ears - they catch 
stuff our real eyes did not catch. We need to sharpen these tools 
constantly, and do all the things that current hardware allows us to do 
sanely.

The same speedup will happen with kmemcheck as well in the long run. It 
is a big slowdown currently due to the massive amount of pagefaults it 
generates, even on top of the line hardware, but it's already fast 
enough to boot up and to catch bugs. [and we can optimize it by quite a 
degree - i've alreadyextended the profiler to trace kmemcheck pagefault 
sources.] It will never be usable in production, but the boundary of 
where to enable it and why will move constantly.

So i'm convinced that the time has come for kmemcheck. It already caught 
4 live kernel bugs and it's been tested on 2 boxes only. Please help us 
make the SLUB bits squeaky clean :-)

	Ingo
