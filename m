Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZFIRKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZFIRKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZFIRKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:10:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbZFIRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:10:07 -0400
Date: Tue, 9 Jun 2009 10:08:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <20090609164519.GE9211@wotan.suse.de>
Message-ID: <alpine.LFD.2.01.0906091005150.6847@localhost.localdomain>
References: <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de>
 <alpine.LFD.2.01.0906090749380.6847@localhost.localdomain> <20090609153847.GB9211@wotan.suse.de> <alpine.LFD.2.01.0906090849080.6847@localhost.localdomain> <20090609162125.GC9211@wotan.suse.de> <alpine.LFD.2.01.0906090924580.6847@localhost.localdomain>
 <20090609164519.GE9211@wotan.suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Jun 2009, Nick Piggin wrote:

> On Tue, Jun 09, 2009 at 09:26:47AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 9 Jun 2009, Nick Piggin wrote:
> > > 
> > > The idea seems nice but isn't the problem that kmap gives back a
> > > basically 1st class kernel virtual memory? (ie. it can then be used
> > > by any other CPU at any point without it having to use kmap?).
> > 
> > No, everybody has to use kmap()/kunmap().
> 
> So it is strictly a bug to expose a pointer returned by kmap to
> another CPU?

No, not at all. The pointers are all global. They have to be, since the 
original kmap() user may well be scheduled away.

> > The "problem" is that you could in theory run out of kmap frames, since if 
> > everybody does a kmap() in an interruptible context and you have lots and 
> > lots of threads doing different pages, you'd run out. But that has nothing 
> > to do with kmap_atomic(), which is basically limited to just the number of 
> > CPU's and a (very small) level of nesting.
> 
> This could be avoided with an anti-deadlock pool. If a task
> attempts a nested kmap and already holds a kmap, then give it
> exclusive access to this pool until it releases its last
> nested kmap.

We just sleep, waiting for somebody to release their. Again, that 
obviously won't work in atomic context, but it's easy enough to just have 
a "we need to have a few entries free" for the atomic case, and make it 
busy-loop if it runs out (which is not going to happen in practice 
anyway).

			Linus
