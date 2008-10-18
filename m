Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbYJRUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbYJRUiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYJRUiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:38:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53554 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbYJRUiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:38:08 -0400
Date: Sat, 18 Oct 2008 22:37:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Keith Packard <keithp@keithp.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm patches for 2.6.27-rc1
Message-ID: <20081018203741.GA23396@elte.hu>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie> <200810181237.49784.nickpiggin@yahoo.com.au> <1224357062.4384.72.camel@koto.keithp.com> <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [ The *non-atomic* kmap() functions are fairly high-overhead, in that they 
>   want to keep track of cached mappings and remember page addresses etc. 
>   So those are the ones we don't want to support for non-HIGHMEM setups. 
> 
>   But the atomic kmaps are pretty simple, and really only need some 
>   trivial FIXMAP support. We could easily extend it for x86-64, methinks, 
>   and do it for x86-32 even when we don't do HIGHMEM.
> 
>   Ingo? ]

agreed, and there's certainly no resistance from the x86 architecture 
side to extend our mapping APIs in such directions.

But i think the direction of the new GEM code is subtly wrong here, 
because it tries to manage memory even on 64-bit systems. IMO it should 
just map the _whole_ graphics aperture (non-cached) and be done with it. 
There's no faster method at managing pages than the CPU doing a TLB fill 
from pagetables.

The only real API need i see is on 32-bit: with a 1GB or 2GB graphics 
aperture we just cannot map that permanently, so kmap_atomic() is a 
necessity. We can certainly extend that to non-highmem as well.

But this should be an ad-hoc transitionary thing for 32-bit, and on 
64-bit we really should not be using any form of kmap.

Especially with large vertex buffers or textures, mapping a lot of pages 
via kmap is not going to be trivial overhead - even if INVLPG is faster 
than a full TLB flush, it's still on the order of 100-200 cycles - and 
with a lot of pages that mounts up quickly. And if i understood your 
workload correctly you want to do tens of thousand of map/unmap/remap 
events per frame generated - depending on the type of the 3D app/engine.

Or am i missing something subtle? Why do you want the overhead of kmap 
on 64-bit?

	Ingo
