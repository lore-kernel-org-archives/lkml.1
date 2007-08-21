Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbXHUVIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbXHUVIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbXHUVIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:08:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52067 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753703AbXHUVIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:08:37 -0400
Date: Tue, 21 Aug 2007 14:08:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070821173849.GA8360@Krystal>
Message-ID: <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca>
 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
 <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
 <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
 <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:

> - Fixed an erroneous test in slab_free() (logic was flipped from the 
>   original code when testing for slow path. It explains the wrong 
>   numbers you have with big free).

If you look at the numbers that I posted earlier then you will see that 
even the measurements without free were not up to par.

> It applies on top of the 
> "SLUB Use cmpxchg() everywhere" patch.

Which one is that?

>              |     slab.git HEAD slub (min-max)    |  cmpxchg_local slub
> kmalloc(8)   |         190 - 201                   |         83
> kfree(8)     |         351 - 351                   |        363
> kmalloc(64)  |         224 - 245                   |        115
> kfree(64)    |         389 - 394                   |        397
> kmalloc(16384)|        713 - 741                   |        724
> kfree(16384) |         843 - 856                   |        843
> 
> Therefore, there seems to be a repeatable gain on the kmalloc fast path
> (more than twice faster). No significant performance hit for the kfree
> case, but no gain neither, same for large kmalloc, as expected.

There is a consistent loss on slab_free it seems. The 16k numbers are 
irrelevant since we do not use slab_alloc/slab_free due to the direct pass 
through patch but call the page allocator directly. That also explains 
that there is no loss there.

The kmalloc numbers look encouraging. I will check to see if I can 
reproduce it once I sort out the patches.
