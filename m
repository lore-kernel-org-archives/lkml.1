Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbXKETKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbXKETKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXKETKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:10:40 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55136 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbXKETKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:10:39 -0500
Date: Mon, 5 Nov 2007 19:09:41 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: =?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?= <oliver.pntr@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711051036250.13139@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711051901330.28390@blonde.wat.veritas.com>
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
 <Pine.LNX.4.64.0711051036250.13139@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Christoph Lameter wrote:
> On Sun, 4 Nov 2007, Hugh Dickins wrote:
> 
> > In a low memory situation, when several tasks pile up to allocate
> > the same resource, we'd usually free back all but the first, rather
> > than depleting free memory even more than necessary.  That you were
> > doing before, now you take the simpler way out and don't bother.
> 
> Hmmm... But even without the patch: All tasks had to allocate their
> own slabs via the page allocator first. Most of those were then thrown 
> away immediately. Now we are flushing the current cpu slab. Which means 
> that this is also going back to the page allocator if its empty.

Perfectly possible, but not the likely case.

> It is 
> likely that the push back in the situation you mention will put a slab 
> with only one object allocated onto the partial lists. This can have two 
> beneficial effects:
> 
> 1. We can avoid going back to the page allocator for awhile since we will
> find the almost free slab if the current slab is exhausted.

Well, yes, but we don't usually make that argument for allocating
more than we need - especially not when memory is low ;)

> 
> 2. If the object that was allocated in the flushed slab was a short lived 
> use freed then the slab will go back to the page allocator very fast.
> 
> > I've no evidence that this is a significant issue: just mention
> > it in case it gives you second thoughts e.g. was there a concrete
> > scenario, other than instinct, which led you to put in that code
> > originally?
> 
> The intend was to use objects that were cache hot as much as possible. Use 
> of the newly allocated slab means we are likely accessing a cache cold 
> page.

Ah yes.  And that's certainly no argument for retaining the code,
I'm sure it's not a case we need to optimize for.

> 
> However, given that it took us pretty long to find that issue I would 
> think that this is not that of an important code path. So the removal 
> seems to be the right way to go.

Okay, I wanted to make the point, but I've no wish to hold up your fix
(and removing code, particularly code that has given trouble, is always
welcome).  Please go ahead - thanks.

Hugh
