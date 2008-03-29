Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYC2Vah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYC2Vah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 17:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYC2Va2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 17:30:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbYC2Va2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 17:30:28 -0400
Date: Sat, 29 Mar 2008 14:29:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <Pine.LNX.4.64.0803291330190.26394@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.1.00.0803291422160.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com> <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0803281128480.17805@schroedinger.engr.sgi.com> <alpine.LFD.1.00.0803281214580.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0803291330190.26394@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 29 Mar 2008, Christoph Lameter wrote:
>
> > If SLUB *ever* calls the page allocator with __GFP_ZERO set, it's a 
> > bug, and that has nothing to do with GFP_ATOMIC or anything else. Because 
> > SLUB uses its own logic for clearing the result.
> 
> Yes it uses its own logic if the object is managed by SLUB but not if the 
> object is too big and/or the allocation forwarded to the page allocator 
> or for other internal allocations of buffers etc.

Wrong.

It uses it's own logic for __GFP_ZERO *regardless* of size.

> > Why cannot you just admit it?
> 
> Admitting something that is not true is rather difficult.

You don't have a f*cking clue about this cocde that you're supposed to be 
maintaining, do you?

See "slab_alloc()". See the code:

	if (unlikely((gfpflags & __GFP_ZERO) && object))
		memset(object, 0, c->objsize);

and see how it does it regardless of anything else.

In short, if *any* code-path calls down to any allocator from that routine 
with GFP_ZERO set, it's a bug. No ifs, buts or maybes about it. It 
shouldn't do that, because the actual memset() is done by slab_alloc(), 
and should not be done ANYWHERE ELSE.

It has *nothing* to do with "object is too big" or anything else.

> So what you want is to forbid any use of
> 
> 	alloc_pages(__GFP_ZERO|...)

No. I want you to admit the bugs in code you maintain. I want you to admit 
that slab_alloc() does the memset(), and should NEVER EVER use __GFP_ZERO
for the page allocations.

I have told you about a million times now that THIS HAS NOTHING TO DO WITH 
interrupts or HIGHMEM or *anything* else. This is purely a SLUB issue.

But don't worry. I already fixed it by reverting your broken commit. I 
just wish you could follow code that you are supposed to be maintaining.

			Linus
