Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYJHTz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYJHTz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYJHTzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:55:19 -0400
Received: from waste.org ([66.93.16.53]:58083 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYJHTzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:55:18 -0400
Subject: Re: [BUG] SLOB's krealloc() seems bust
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <alpine.LFD.2.00.0810071116050.3208@nehalem.linux-foundation.org>
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
	 <48EB6D2C.30806@linux-foundation.org>  <1223391655.13453.344.camel@calx>
	 <1223395846.26330.55.camel@lappy.programming.kicks-ass.net>
	 <1223397455.13453.385.camel@calx>
	 <alpine.LFD.2.00.0810071053540.3208@nehalem.linux-foundation.org>
	 <1223403082.26330.78.camel@lappy.programming.kicks-ass.net>
	 <alpine.LFD.2.00.0810071116050.3208@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 14:51:57 -0500
Message-Id: <1223495517.17706.31.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 11:18 -0700, Linus Torvalds wrote:
> 
> On Tue, 7 Oct 2008, Peter Zijlstra wrote:
> 
> > On Tue, 2008-10-07 at 10:57 -0700, Linus Torvalds wrote:
> > 
> > > Peter - can you check with that
> > > 
> > > >  	if (slob_page(sp))
> > > > -		return ((slob_t *)block - 1)->units + SLOB_UNIT;
> > > > +		return (((slob_t *)block - 1)->units - 1) * SLOB_UNIT;
> > > 
> > > thing using
> > > 
> > > -		return ((slob_t *)block - 1)->units + SLOB_UNIT;
> > > +		return ((slob_t *)block - 1)->units * SLOB_UNIT;
> > > 
> > > instead? 
> > 
> > went splat on the second run...
> 
> Well, that makes it simple. I'll take Matt's patch as being "tested", and 
> somebody can hopefully explain where the extra unit comes from later.

Ok, I think we've gotten to the bottom of this. Here's an incremental
patch that doesn't work by dumb luck. Please apply.


SLOB: fix bogus ksize calculation fix

This fixes the previous fix, which was completely wrong on closer
inspection. This version has been manually tested with a user-space
test harness and generates sane values. A nearly identical patch has
been boot-tested.

The problem arose from changing how kmalloc/kfree handled alignment
padding without updating ksize to match. This brings it in sync.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 3dd2424d4c32 -r 73d55a1b6c10 mm/slob.c
--- a/mm/slob.c	Tue Oct 07 23:00:11 2008 +0000
+++ b/mm/slob.c	Wed Oct 08 14:48:45 2008 -0500
@@ -514,9 +514,11 @@
 		return 0;
 
 	sp = (struct slob_page *)virt_to_page(block);
-	if (slob_page(sp))
-		return (((slob_t *)block - 1)->units - 1) * SLOB_UNIT;
-	else
+	if (slob_page(sp)) {
+		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+		unsigned int *m = (unsigned int *)(block - align);
+		return SLOB_UNITS(*m) * SLOB_UNIT;
+	} else
 		return sp->page.private;
 }

-- 
Mathematics is the supreme nostalgia of our time.

