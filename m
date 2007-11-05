Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbXKESp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbXKESp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbXKESpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:45:44 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58766 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756265AbXKESpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:45:42 -0500
Date: Mon, 5 Nov 2007 10:45:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: =?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?= <oliver.pntr@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711041103030.8179@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0711051036250.13139@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <6101e8c40711031027x3f946b28p324dadeab7c1b2c3@mail.gmail.com>
 <Pine.LNX.4.64.0711031741160.10953@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031847450.13845@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031935510.15611@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031247250.5828@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711031950300.17078@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031253580.6080@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711032007060.17942@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031326450.6227@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711041103030.8179@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007, Hugh Dickins wrote:

> That testing went fine, as you'd expect.  Your diffstat is certainly
> nicer than mine (corrected for SlabDebug) would be.  I expect you'll
> go ahead with yours.

Thanks for testing.

> But I remain slightly uneasy about it: I do think your original
> instinct, in putting in the code you're now removing, was good.

Well yes. I tend to think too much about performance.

> In a low memory situation, when several tasks pile up to allocate
> the same resource, we'd usually free back all but the first, rather
> than depleting free memory even more than necessary.  That you were
> doing before, now you take the simpler way out and don't bother.

Hmmm... But even without the patch: All tasks had to allocate their
own slabs via the page allocator first. Most of those were then thrown 
away immediately. Now we are flushing the current cpu slab. Which means 
that this is also going back to the page allocator if its empty. It is 
likely that the push back in the situation you mention will put a slab 
with only one object allocated onto the partial lists. This can have two 
beneficial effects:

1. We can avoid going back to the page allocator for awhile since we will
find the almost free slab if the current slab is exhausted.

2. If the object that was allocated in the flushed slab was a short lived 
use freed then the slab will go back to the page allocator very fast.

> I've no evidence that this is a significant issue: just mention
> it in case it gives you second thoughts e.g. was there a concrete
> scenario, other than instinct, which led you to put in that code
> originally?

The intend was to use objects that were cache hot as much as possible. Use 
of the newly allocated slab means we are likely accessing a cache cold 
page.

However, given that it took us pretty long to find that issue I would 
think that this is not that of an important code path. So the removal 
seems to be the right way to go.
