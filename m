Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYLTLfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYLTLfC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 06:35:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYLTLex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 06:34:53 -0500
Received: from cmpxchg.org ([85.214.51.133]:48878 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbYLTLex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 06:34:53 -0500
Date: Sat, 20 Dec 2008 12:34:20 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] bitmap: fix bitmap_find_free_region()
Message-ID: <20081220113419.GB2581@cmpxchg.org>
References: <Pine.LNX.4.64.0812191202130.4536@axis700.grange> <20081219130211.GA1560@cmpxchg.org> <Pine.LNX.4.64.0812191413520.4536@axis700.grange> <20081219144726.GA1991@cmpxchg.org> <Pine.LNX.4.64.0812191553550.4536@axis700.grange> <20081219224532.GA2581@cmpxchg.org> <Pine.LNX.4.64.0812200005430.9649@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812200005430.9649@axis700.grange>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 12:19:46AM +0100, Guennadi Liakhovetski wrote:
> Well, I don't quite understand. Doesn't bitmap_find_free_region() _have_ 
> to return an error if the request cannot be satisfied? Isn't it what it 
> does if after scanning the bitmap no suitable free region is found?

There is a difference here.  In the case it already checks, the
request was sane but couldn't be satisfied due to prior requests.
This is an expected situation on the bitmap allocator level.

The check you want to add is for fixing up the caller.

This API is especially clear on that separation because the caller
even has to pass in the size of the bitmap, so itself should ensure
that the combination of bitmap size and request size is sane.

> What's the difference? Why don't we want to fix _that_ function? It
> also has other users - currently I see 3 of them in the kernel:
> 
> mm/vmalloc.c

This has its own sanity checks.  It's a bug for the user of vb_alloc()
to pass a size that is larger than VMAP_MAX_ALLOC pages and the bitmap
has a minimum of VMAP_MAX_ALLOC * 2 bits.

> arch/powerpc/sysdev/msi_bitmap.c (5 occurrences)

The users allocating irqs from there seem all sane and doing only low
orders.  Not yet quite through, though.

> arch/sh/kernel/cpu/sh4/sq.c

Not yet looked into it.

> Yes, I understand that the caller _can_ verify whether the requested 
> region at all fits into the bitmap, but from the PoV of offering a 
> consistent API this seems strange.

Not really.  The user that is supposed to use the bitmap also sets it
up.  If the requests are bogus wrt the original parameters it's the
users fault, not that of the API.

> Thanks
> Guennadi

	Hannes
