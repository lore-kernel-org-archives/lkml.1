Return-Path: <linux-kernel-owner+w=401wt.eu-S1764895AbZFQJ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764895AbZFQJ4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763802AbZFQJ4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:56:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbZFQJ42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:56:28 -0400
Date: Wed, 17 Jun 2009 11:56:28 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Message-ID: <20090617095628.GB14915@wotan.suse.de>
References: <20090609093918.GC16940@wotan.suse.de> <alpine.LFD.2.01.0906090749380.6847@localhost.localdomain> <20090609153847.GB9211@wotan.suse.de> <alpine.LFD.2.01.0906090849080.6847@localhost.localdomain> <20090609162125.GC9211@wotan.suse.de> <alpine.LFD.2.01.0906090924580.6847@localhost.localdomain> <20090609164519.GE9211@wotan.suse.de> <alpine.LFD.2.01.0906091005150.6847@localhost.localdomain> <20090610055309.GA27767@wotan.suse.de> <20090617094015.GC1403@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617094015.GC1403@ucw.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 11:40:16AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > > The "problem" is that you could in theory run out of kmap frames, since if 
> > > > > everybody does a kmap() in an interruptible context and you have lots and 
> > > > > lots of threads doing different pages, you'd run out. But that has nothing 
> > > > > to do with kmap_atomic(), which is basically limited to just the number of 
> > > > > CPU's and a (very small) level of nesting.
> > > > 
> > > > This could be avoided with an anti-deadlock pool. If a task
> > > > attempts a nested kmap and already holds a kmap, then give it
> > > > exclusive access to this pool until it releases its last
> > > > nested kmap.
> > > 
> > > We just sleep, waiting for somebody to release their. Again, that 
> > > obviously won't work in atomic context, but it's easy enough to just have 
> > > a "we need to have a few entries free" for the atomic case, and make it 
> > > busy-loop if it runs out (which is not going to happen in practice 
> > > anyway).
> > 
> > The really theoretical one (which Andrew likes complaining about) is
> > when *everybody* is holding a kmap and asking for another one ;)
> > But I think it isn't too hard to make a pool for that. And yes we'd
> 
> Does one pool help?

So long as only one process is allowed access to the pool at
one time, yes I think it solves it. It would probably never
even hit in practice, so synchronization overhead would not
matter.


> Now you can have '*everyone* is holding the kmaps and is asking for
> another one'.
> 
> You could add as many pools as maximum nesting level... Is there
> maximum nesting level?

Yes there are only a set number of kmap_atomic nesting levels,
so if you converted them all to kmap then it would be that + 1.
