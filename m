Return-Path: <linux-kernel-owner+w=401wt.eu-S1761513AbXGWW4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbXGWW4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXGWW41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:56:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380AbXGWW41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:56:27 -0400
Date: Mon, 23 Jul 2007 15:56:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERP to GFP_LEVEL_MASK
Message-Id: <20070723155603.f1b1a735.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707231539520.3607@woody.linux-foundation.org>
References: <1185185020.8197.11.camel@twins>
	<20070723113712.c0ee29e5.akpm@linux-foundation.org>
	<1185216048.5535.1.camel@lappy>
	<20070723144323.1ac34b16@schroedinger.engr.sgi.com>
	<20070723151306.86e3e0ce.akpm@linux-foundation.org>
	<alpine.LFD.0.999.0707231539520.3607@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 15:41:36 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 23 Jul 2007, Andrew Morton wrote:
> > 
> > OK, well that was weird.  So
> > 
> > 	kmalloc(42, GFP_KERNEL|__GFP_ZERO);
> > 
> > duplicates
> > 
> > 	kzalloc(42, GFP_KERNEL);
> > 
> > Why do it both ways?
> 
> Both ways? The latter *is* the former. That's how kzalloc() is implemented 
> these days.

<looks>

So this:

	/*
	 * Be lazy and only check for valid flags here,  keeping it out of the
	 * critical path in kmem_cache_alloc().
	 */
	BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));

would no longer need the __GFP_ZERO.  Ditto in slob's new_slab().


> Andrew - all these patches came through you. You didn't realize?

Well.  I didn't memorise the past few months' 250-odd slab/slob/slub
patches..

My point is, I don't think we want some code doing
kmalloc(42, GFP_KERNEL|__GFP_ZERO) and some other code doing
kzalloc(42, GFP_KERNEL).  But this patch does nothing to increase the
chances of that happening, so I'm happy.


