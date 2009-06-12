Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbZFLLYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbZFLLYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZFLLYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:24:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:57224 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbZFLLYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:24:21 -0400
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
 suspending
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <1244805230.7172.130.camel@pasglop>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090612091002.GA32052@elte.hu>
	 <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
	 <20090612100756.GA25185@elte.hu>
	 <84144f020906120311x7c7dd628s82e3ca9a840f9890@mail.gmail.com>
	 <20090612101511.GC13607@wotan.suse.de>  <1244805230.7172.130.camel@pasglop>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 21:24:02 +1000
Message-Id: <1244805842.7172.133.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 21:13 +1000, Benjamin Herrenschmidt wrote:
> > I agree with Ingo though that exposing it as a gfp modifier is
> > not so good. I just like the implementation to mask off GFP_WAIT
> > better, and also prefer not to test system state, but have someone
> > just call into slab to tell it not to unconditionally enable
> > interrupts.
> 
> But interrupts is just one example. GFP_NOIO is another one vs. suspend
> and resume.
> 
> What we have here is the allocator needs to be clamped down based on the
> system state. I think it will not work to try to butcher every caller,
> especially since they don't always know themselves in what state they
> are called.

Let me put it another way....

If you have to teach every call site whether to use one flag or the
other, there is -no- difference with teaching them to call one routine
(alloc_bootmem) vs another (kmalloc).

The way I see thing is that the -whole- point of the exercise is to
remove the need for the callers to have to know in what environment they
are calling kmalloc().

Yes, we do still want that for atomic calls, just because it's a good
way to get people to think twice before allocating things in atomic
context, but that logic pretty much ends there.

If we're going to require any boot time caller of kmalloc() to pass a
different set of flags than any non-boot time caller, then the whole
idea of moving the initialization earlier so a single allocator can be
used is moot.

Cheers,
Ben.

