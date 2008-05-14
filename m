Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbYENRtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbYENRtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYENRtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:49:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59216 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYENRtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:49:18 -0400
Message-ID: <482B2617.5010605@firstfloor.org>
Date: Wed, 14 May 2008 19:49:11 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
References: <20080510030831.796641881@sgi.com>  <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org>  <20080510221515.3540a6cc@bree.surriel.com>  <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:

> Fundamentally there is no way to avoid complex queueing on free() unless 
> one directly frees the object. This is serialized in SLUB by taking a page 
> lock. 

iirc profiling analysis showed that the problem was the page lock
serialization (in particular the slab_lock() in __slab_free). That
was on 2.6.24.2

> Howver, the "slow" case in SLUB is still much less complex 
> than comparable processing in SLAB. It is quite fast.

Well in the benchmark it is slower.


> SLAB freeing can avoid taking a lock if
> 
> 1. We can establish that the object is node local (trivial if !NUMA 
> otherwise we need to get the node information from the page struct and 
> compare to the current node).

Ignoring NUMA is no option unfortunately. And with integrated memory
controller many of the remote CPU frees are off node.

> The main issue for SLAB vs. SLUB on free is likely the !NUMA case in which 
> SLAB can avoid the overhead of the node check (which does not exist in 
> SLUB) and in which case we can always immediately batch the object (if 
> there is space). The additional overhead in SLUB is mainly one 
> atomic instruction over the SLAB fastpath.

I think the problem is that this atomic operation thrashes cache lines
around. Really counting cycles on instructions is not that interesting,
but minimizing the cache thrashing is. And for that it looks like slub
is worse.

> So I think that the free need to  stay as is. The disadvantages in terms 
> of the complexity of handling the objects and expiring them and the issue 
> of having to take per node locks in SLAB makes it hard to justify adding a 
> queue for free in SLUB. Maybe someone has an inspiration on how to do this 
> effective that is better than my attempts which always ultimately ended 
> implementing code that thad the same issues that we have in SLAB.

What is the big problem of having a batched free queue? If the expiry
is done at a good bounded time (e.g. on interrupt exit or similar)
locally on the CPU it shouldn't be a big issue, should it?

-Andi
