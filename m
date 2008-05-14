Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbYENSDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbYENSDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761442AbYENSDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:03:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51945 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761088AbYENSDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:03:20 -0400
Date: Wed, 14 May 2008 11:03:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <482B2617.5010605@firstfloor.org>
Message-ID: <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>  <20080510030919.604216074@sgi.com>
 <4825709A.2020407@firstfloor.org>  <20080510221515.3540a6cc@bree.surriel.com>
  <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Andi Kleen wrote:

> iirc profiling analysis showed that the problem was the page lock
> serialization (in particular the slab_lock() in __slab_free). That
> was on 2.6.24.2

Do you have an URL?

> I think the problem is that this atomic operation thrashes cache lines
> around. Really counting cycles on instructions is not that interesting,
> but minimizing the cache thrashing is. And for that it looks like slub
> is worse.

It can thrash cachelines if objects from the same slab page are freed 
simultaneously on multiple processors. That occurred in the hackbench 
regression that we addressed with the dynamic configuration of slab sizes.

However, typically long lived objects freed from multiple processors 
belong to different slab caches.

> > So I think that the free need to  stay as is. The disadvantages in terms 
> > of the complexity of handling the objects and expiring them and the issue 
> > of having to take per node locks in SLAB makes it hard to justify adding a 
> > queue for free in SLUB. Maybe someone has an inspiration on how to do this 
> > effective that is better than my attempts which always ultimately ended 
> > implementing code that thad the same issues that we have in SLAB.
> 
> What is the big problem of having a batched free queue? If the expiry
> is done at a good bounded time (e.g. on interrupt exit or similar)
> locally on the CPU it shouldn't be a big issue, should it?

Interrupt exit in general would have to inspect the per cpu structures of 
all slab caches on the system?
