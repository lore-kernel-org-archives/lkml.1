Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbZFIQVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbZFIQVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZFIQVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:21:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbZFIQVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:21:24 -0400
Date: Tue, 9 Jun 2009 18:21:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Message-ID: <20090609162125.GC9211@wotan.suse.de>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de> <alpine.LFD.2.01.0906090749380.6847@localhost.localdomain> <20090609153847.GB9211@wotan.suse.de> <alpine.LFD.2.01.0906090849080.6847@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906090849080.6847@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 09:00:08AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 9 Jun 2009, Nick Piggin wrote:
> > 
> > If it's such a problem, it could be made a lot faster without too
> > much problem. You could just introduce a FIFO of ptes behind it 
> > and flush them all in one go. 4K worth of ptes per CPU might
> > hopefully bring your overhead down to < 1%.
> 
> We already have that. The regular kmap() does that. It's just not usable 
> in atomic context.

Well this would be more like the kmap cache idea rather than the
kmap_atomic FIFO (which would remain per-cpu and look much like
the existing kmap_atomic).


> We'd need to fix the locking: right now kmap_high() uses non-irq-safe 
> locks, and it does that whole cross-cpu flushing thing (which is why 
> those locks _have_ to be non-irq-safe.
> 
> The way to fix that, though, would be to never do any cross-cpu calls, and 
> instead just have a cpumask saying "you need to flush before you do 
> anything with kmap".  So you'd just set that cpumask inside the lock, and 
> if/when some other CPU does a kmap, they'd flush their local TLB at _that_ 
> point instead of having to have an IPI call.

The idea seems nice but isn't the problem that kmap gives back a
basically 1st class kernel virtual memory? (ie. it can then be used
by any other CPU at any point without it having to use kmap?).

