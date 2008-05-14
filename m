Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYENVFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYENVFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYENVF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:05:26 -0400
Received: from waste.org ([66.93.16.53]:52746 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbYENVFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:05:24 -0400
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <Pine.LNX.4.64.0805141333060.18231@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>
	 <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org>
	 <20080510221515.3540a6cc@bree.surriel.com>
	 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
	 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
	 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
	 <482B2617.5010605@firstfloor.org>
	 <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
	 <1210789112.4093.14.camel@calx>
	 <Pine.LNX.4.64.0805141220440.16223@schroedinger.engr.sgi.com>
	 <1210794563.4093.57.camel@calx>
	 <Pine.LNX.4.64.0805141333060.18231@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 16:02:58 -0500
Message-Id: <1210798978.4093.82.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-14 at 13:33 -0700, Christoph Lameter wrote:
> On Wed, 14 May 2008, Matt Mackall wrote:
> 
> > > allocator?
> > 
> > No, slow path here means we're already under memory pressure, so we
> > don't care if something takes longer if it saves memory.
> 
> So expire the queues under memory pressure only? Trigger queue cleanup 
> from reclaim?

This wouldn't be my first thought. The batch size could be potentially
huge and we'd have to worry about latency issues.

But here are some other thoughts:

First, we should obviously always expire all queues when we hit low
water marks as it'll be cheaper/faster than other forms of reclaim.

Second, if our queues were per-slab (this might be hard, I realize), we
can sweep the queue at alloc time.

We can also sweep before falling back to the page allocator. That should
guarantee that delayed frees don't negatively impact fragmentation.

And lastly, we can always have a periodic thread/timer/workqueue
operation.

So far this is a bunch of hand-waving but I think this ends up basically
being an anti-magazine. A magazine puts a per-cpu queue on the alloc
side which costs on both the alloc and free side, regardless of whether
the workload demands it. This puts a per-cpu queue on the free side that
we can bypass in the cache-friendly case. I think that's a step in the
right direction.

-- 
Mathematics is the supreme nostalgia of our time.

