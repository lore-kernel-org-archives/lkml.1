Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYCaSrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYCaSrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYCaSrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:47:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38525 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754115AbYCaSro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:47:44 -0400
Date: Mon, 31 Mar 2008 11:45:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <alpine.LFD.1.00.0803291422160.14670@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803311123180.6510@schroedinger.engr.sgi.com>
References: <200803272353.51901.rjw@sisk.pl>
 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
 <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0803281128480.17805@schroedinger.engr.sgi.com>
 <alpine.LFD.1.00.0803281214580.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0803291330190.26394@schroedinger.engr.sgi.com>
 <alpine.LFD.1.00.0803291422160.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2008, Linus Torvalds wrote:

> 
> You don't have a f*cking clue about this cocde that you're supposed to be 
> maintaining, do you?
> 
> See "slab_alloc()". See the code:
> 
> 	if (unlikely((gfpflags & __GFP_ZERO) && object))
> 		memset(object, 0, c->objsize);
> 
> and see how it does it regardless of anything else.

Yes I am very aware of that.

> In short, if *any* code-path calls down to any allocator from that routine 
> with GFP_ZERO set, it's a bug. No ifs, buts or maybes about it. It 
> shouldn't do that, because the actual memset() is done by slab_alloc(), 
> and should not be done ANYWHERE ELSE.
> 
> It has *nothing* to do with "object is too big" or anything else.

It has to do how large objects are allocated through kmalloc_large().
kmalloc_large() is elsewhere called with unfiltered gfpflags and relies 
on zeroing being handled by the page allocator. It can take unfiltered gfp 
flags.

The filtering of __GFP_ZERO that you added avoids the double zeroing for 
the fallback path (which is only called if all the partial lists are empty 
and after the page allocator went through reclaim and did not get the 
large sized memory we wanted). So okay the patch could be a performance 
enhancement. But then it adds the filtering to the hot path instead of the 
code path that containts the kmalloc_large that is executed once in a blue 
moon. The hot path should only filter when we actually decide that we need 
to allocate a new slab from the page allocator.

It seemed to me that the reason for inserting the filtering of __GFP_ZERO 
there was the belief that the page allocator cannot take __GFP_ZERO 
through kmalloc_large() if we are in an interrupt.

The use of kmalloc_large() in __slab_alloc() is a bit strange at this 
point. The cleanup work in 2.6.26 will make this all nice again.
