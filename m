Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZK3Whg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZK3Whg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZK3Whf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:37:35 -0500
Received: from www.tglx.de ([62.245.132.106]:38080 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZK3Whf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:37:35 -0500
Date: Mon, 30 Nov 2009 23:37:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de>  <alpine.LFD.2.00.0911280927180.2561@localhost>  <20091130100041.GA29610@infradead.org>  <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>  <20091130174638.GA9782@elte.hu> 
 <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain> <1259616429.26472.499.camel@laptop> <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain> <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Linus Torvalds wrote:
> On Mon, 30 Nov 2009, Thomas Gleixner wrote:
> > 
> > Yeah, forgot to mention sched.c, but that's solvable
> 
> It should be fairly easy to add a few 'spin_lock(&tasklist_lock)' around 
> stuff that really depended on exclusion from writers. That should 
> _hopefully_ be the rare case.
> 
> The biggest problem is that there will almost inevitably be things that 
> get missed, and any races exposed by lacking locking will be _very_ hard 
> to debug and trigger. So what I'd be worried about is not getting to a 
> "practically working" state, but any really subtle cases that nobody 
> really hits in practice.

I'm aware of that. The number of places where we read_lock
tasklist_lock is 79 in 36 files right now. That's not a horrible task
to go through them one by one and do a case by case conversion with a
proper changelog. That would only leave the write_lock sites. 

We can then either do the rw_lock to spin_lock conversion or keep the
rw_lock which has no readers anymore and behaves like a spinlock for a
transition time so reverts of one of the read_lock -> rcu patches
could be done to debug stuff.

Thanks,

	tglx
