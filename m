Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbXGWWuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbXGWWuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXGWWuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:50:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39997 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751363AbXGWWuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:50:08 -0400
Date: Mon, 23 Jul 2007 15:50:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERP to GFP_LEVEL_MASK
In-Reply-To: <20070723151306.86e3e0ce.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707231544290.32603@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins> <20070723113712.c0ee29e5.akpm@linux-foundation.org>
 <1185216048.5535.1.camel@lappy> <20070723144323.1ac34b16@schroedinger.engr.sgi.com>
 <20070723151306.86e3e0ce.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 Jul 2007, Andrew Morton wrote:

> On Mon, 23 Jul 2007 14:43:23 -0700
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > __GFP_ZERO is implemented by the slab allocators (the page allocator
> > has no knowledge about the length of the object to be zeroed). The slab
> > allocators do not pass __GFP_ZERO to the page allocator.
> 
> OK, well that was weird.  So
> 
> 	kmalloc(42, GFP_KERNEL|__GFP_ZERO);
> 
> duplicates
> 
> 	kzalloc(42, GFP_KERNEL);

Correct.
 
> Why do it both ways?

There are now ~2.5k uses of kzalloc in the kernel.

kzalloc and friends implies that we need to duplicate all allocator 
functions. That was never done for NUMA allocators there was never a 
kzalloc_node f.e..

kzalloc also cannot be used in a parameterized way in a derived allocator 
where you would simply pass on the gfp flags.
 
__GFP_ZERO support allows all allocators to work in a consistent way. 
There is no need to special case slab zeroing allocation.

kzalloc could be removed.

