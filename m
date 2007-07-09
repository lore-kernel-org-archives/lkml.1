Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbXGIR0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbXGIR0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXGIR0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:26:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38339 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754983AbXGIR0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:26:10 -0400
Date: Mon, 9 Jul 2007 10:26:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <20070709095116.c2ea700f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org>
 <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
 <20070709095116.c2ea700f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Andrew Morton wrote:

> On Mon, 9 Jul 2007 09:06:46 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> 
> > But yes the power of 
> > two caches are a necessary design feature of SLAB/SLUB that allows O(1) 
> > operations of kmalloc slabs which in turns causes memory wastage because 
> > of rounding of the alloc to the next power of two.
> 
> I've frequently wondered why we don't just create more caches for kmalloc:
> make it denser than each-power-of-2-plus-a-few-others-in-between.
> 
> I assume the tradeoff here is better packing versus having a ridiculous
> number of caches.  Is there any other cost?
> Because even having 1024 caches wouldn't consume a terrible amount of
> memory and I bet it would result in aggregate savings.

I have tried any number of approaches without too much success. Even one 
slab cache for every 8 bytes. This creates additional admin overhead 
through more control structure (that is pretty minimal but nevertheless 
exists)

The main issue is that kmallocs of different size must use different 
pages. If one allocates one 64 byte item and one 256 byte item and both 64 
byte and 256 byte are empty then SLAB/SLUB will have to allocate 2 pages. 
SLUB can fit them into one. This is basically only relevant early after 
boot. The advantage goes away as the system starts to work and as more 
objects are allocated in the slabs but the power-of-two slab will always
have to extend its size in page size chunks which leads to some overhead 
that SLOB can avoid by placing entities of multiple size in one slab. 
The tradeoff in SLOB is that is cannot be an O(1) allocator because it 
has to manage these variable sized objects by traversing the lists.

I think the advantage that SLOB generates here is pretty minimal and is 
easily offset by the problems of maintaining SLOB.
 
> Of course, a scheme which creates kmalloc caches on-demand would be better,
> but that would kill our compile-time cache selection, I suspect.

SLUB creates kmalloc caches on-demand for DMA caches already. But then we 
are not allowing compile time cache selection for DMA caches.

