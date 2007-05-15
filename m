Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbXEOWCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbXEOWCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 18:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbXEOWCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:02:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34172 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754460AbXEOWCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:02:44 -0400
Date: Tue, 15 May 2007 15:02:40 -0700 (PDT)
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
In-Reply-To: <1179250036.7173.7.camel@twins>
Message-ID: <Pine.LNX.4.64.0705151457060.3155@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> 
 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com> 
 <20070514161224.GC11115@waste.org>  <Pine.LNX.4.64.0705140927470.10801@schroedinger.engr.sgi.com>
  <1179164453.2942.26.camel@lappy>  <Pine.LNX.4.64.0705141051170.11251@schroedinger.engr.sgi.com>
  <1179170912.2942.37.camel@lappy> <1179250036.7173.7.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007, Peter Zijlstra wrote:

> How about something like this; it seems to sustain a little stress.

Argh again mods to kmem_cache.

Could we do this with a new slab page flag? F.e. SlabEmergPool.


in alloc_slab() do

if (is_emergency_pool_page(page)) {
	SetSlabDebug(page);
	SetSlabEmerg(page);
}

So now you can intercept allocs to the SlabEmerg slab in __slab_alloc 

debug:

if (SlabEmergPool(page)) {
	if (mem_no_longer_critical()) {
		/* Avoid future trapping */
		ClearSlabDebug(page);
		ClearSlabEmergPool(page);
	} else
	if (process_not_allowed_this_memory()) {
		do_something_bad_to_the_caller();
	} else {
		/* Allocation permitted */
	}
}

....

