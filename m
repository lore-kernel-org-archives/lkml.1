Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbZJ1HtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbZJ1HtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbZJ1HtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:49:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48014 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915AbZJ1HtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:49:02 -0400
Date: Wed, 28 Oct 2009 08:48:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
Message-ID: <20091028074832.GC19402@elte.hu>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> From: Chris Wright <chrisw@sous-sol.org>
> 
> Add a new function for freeing bootmem after the bootmem allocator has
> been released and the unreserved pages given to the page allocator.
> This allows us to reserve bootmem and then release it if we later
> discover it was not needed.
> 
> Reviewed-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  include/linux/bootmem.h |    1 +
>  mm/bootmem.c            |   43 ++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 39 insertions(+), 5 deletions(-)

Hm, we are now further complicating the bootmem model.

I think we could remove the bootmem allocator middle man altogether. 

This can be done by initializing the page allocator sooner and by 
extending (already existing) 'reserve memory early on' mechanisms in 
architecture code. (the reserve_early*() APIs in x86 for example)

Right now we have 5 memory allocation models on x86, initialized 
gradually:

 - allocator                        (buddy)                 [generic]
 - early allocator                  (bootmem)               [generic]
 - very early allocator             (reserve_early*())      [x86]
 - very very early allocator        (early brk model)       [x86]
 - very very very early allocator   (build time .data/.bss) [generic]

Seems excessive.

The reserve_early() method is list/range based and can handle vast 
amounts of not very fragmented memory - perfect for basically all the 
real bootmem purposes (which is to bootstrap the buddy).

reserve_early() allocated memory could be freed into the buddy later on 
as well. The main reason why bootmem is 'destroyed' during free-to-buddy 
is because it has excessive internal bitmaps we want to free. With a 
list/range based reserve_early() mechanism there's no such problem - 
they can linger indefinitely and there's near zero allocation management 
overhead.

reserve_early() might need some small amount of extra work before it can 
be used as a generic early allocator - like adding a node field to it 
(so that the buddy can then pick those ranges up in a NUMA aware 
fashion) - but nothing very complex.

Thoughts?

	Ingo
