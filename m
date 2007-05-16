Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbXEPSo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbXEPSo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762482AbXEPSoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:44:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35938 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762353AbXEPSn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:43:59 -0400
Date: Wed, 16 May 2007 11:43:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <1179298771.7173.16.camel@twins>
Message-ID: <Pine.LNX.4.64.0705161139540.10265@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> 
 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com> 
 <20070514161224.GC11115@waste.org>  <Pine.LNX.4.64.0705140927470.10801@schroedinger.engr.sgi.com>
  <1179164453.2942.26.camel@lappy>  <Pine.LNX.4.64.0705141051170.11251@schroedinger.engr.sgi.com>
  <1179170912.2942.37.camel@lappy> <1179250036.7173.7.camel@twins> 
 <Pine.LNX.4.64.0705151457060.3155@schroedinger.engr.sgi.com>
 <1179298771.7173.16.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Peter Zijlstra wrote:

> On Tue, 2007-05-15 at 15:02 -0700, Christoph Lameter wrote:
> > On Tue, 15 May 2007, Peter Zijlstra wrote:
> > 
> > > How about something like this; it seems to sustain a little stress.
> > 
> > Argh again mods to kmem_cache.
> 
> Hmm, I had not understood you minded that very much; I did stay away
> from all the fast paths this time.

Well you added a new locking level and changed the locking hierachy!
 
> The thing is, I wanted to fold all the emergency allocs into a single
> slab, not a per cpu thing. And once you loose the per cpu thing, you
> need some extra serialization. Currently the top level lock is
> slab_lock(page), but that only works because we have interrupts disabled
> and work per cpu.

SLUB can only allocate from a per cpu slab. You will have to reserve one 
slab per cpu anyways unless we flush the cpu slab after each access. Same 
thing is true for SLAB. It wants objects in its per cpu queues.

> Why is it bad to extend kmem_cache a bit?

Because it is for all practical purposes a heavily accessed read only 
structure. Modifications only occur to per node and per cpu structures.
In a 4k systems any write will kick out the kmem_cache cacheline in 4k 
processors.
