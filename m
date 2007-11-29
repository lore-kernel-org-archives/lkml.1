Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbXK2JLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbXK2JLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761401AbXK2JKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:10:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:47053 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761315AbXK2JKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:10:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ep9pJaFxekQ9J4kKPrcUq4CXX4l6mRg7m6OTaWl+EEqOuBjwASRM2oW9iqUH/X4LzpXpRs7Dg5B/sUViXPG4Zi59JhNny+fU/qL50l3JIenzA5wu3YFFpmXZEoa0Wrnr5TLfB8kZYvkcaf3yNyfGD/lv+UHxYplpviemyr8aBxQ=
Message-ID: <19f34abd0711290110n501ddb43wf3ab69b526acef95@mail.gmail.com>
Date: Thu, 29 Nov 2007 10:10:33 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <84144f020711290002p290e91a4ubc40f1efbc877f75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <474C34CC.6060509@gmail.com>
	 <84144f020711290002p290e91a4ubc40f1efbc877f75@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Nov 29, 2007 9:02 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Vegard,
>
> On Nov 27, 2007 5:16 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > +config KMEMCHECK
> > +       bool "Trap use of uninitialized memory"
> > +       depends on X86_32 && !CC_OPTIMIZE_FOR_SIZE
> > +       help
> > +         This option enables tracing of dynamically allocated kernel memory
> > +         to see if memory is used before it has been given an initial value.
> > +         Be aware that this requires half of your memory for bookkeeping and
> > +         will insert extra code at *every* read and write to tracked memory
> > +         thus slow down the kernel code (but user code is unaffected).
>
> Is it really necessary to track every memory address? Tracking slab
> objects would require far less memory. You might also want to make
> kzalloc() and GFP_ZERO mark the memory area as initialized to avoid
> some page faults.

Yes, we are in fact only tracking the memory within SLUB allocations
(minus what SLUB itself needs for bookkeeping -- like the caches).
Maybe the Kconfig text was unclear?

As for the kzalloc() and GFP_ZERO, I believe these will write zeros to
the data in question before the memory is returned to the caller. In
that case, the area will be "automatically" set to initialized since
these writes are also intercepted by kmemcheck. If not, I will have to
investigate some more :-)

> On Nov 27, 2007 5:16 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > +       /* Actually allocate twice as much, since we need to track the
> > +        * status of each byte within the allocation. */
> > +       if (!(flags & __GFP_NOTRACK)) {
>
> If you change __GFP_NOTRACK to __GFP_TRACK, you can avoid the double
> negation here.

I deliberately chose this form. Here is my rationale: By default, when
kmemcheck is enabled, we want to track as much as possible. So every
"normal" allocation should be tracked. It seems easier to make an
exception for the pages that should *not* be tracked (like the SLUB
caches, DMA allocations), since this group of allocations is much
smaller than the group of allocations that should be tracked.

I could embed __GFP_TRACK into GFP_KERNEL, but then I would have to
mask this out at every non-tracked allocation, which leaves us with
the exact opposite problem, just in a different place.

Thank you for looking :)

>
>                                     Pekka
>

Vegard
