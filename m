Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZK3Wtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZK3Wtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZK3Wtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:49:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbZK3Wtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:49:32 -0500
Date: Mon, 30 Nov 2009 14:49:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de>  <alpine.LFD.2.00.0911280927180.2561@localhost>  <20091130100041.GA29610@infradead.org>  <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>  <20091130174638.GA9782@elte.hu> 
 <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain> <1259616429.26472.499.camel@laptop> <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain> <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
 <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Nov 2009, Thomas Gleixner wrote:
> 
> I'm aware of that. The number of places where we read_lock
> tasklist_lock is 79 in 36 files right now. That's not a horrible task
> to go through them one by one and do a case by case conversion with a
> proper changelog. That would only leave the write_lock sites. 

The write_lock sites should be fine, since just changing them to a 
spinlock should be 100% semantically equivalent - except for the lack of 
interrupt disable. And the lack of interrupt disable will result in a nice 
big deadlock if some interrupt really does take the spinlock, which is 
much easier to debug than a subtle race that would get the wrong read 
value.

> We can then either do the rw_lock to spin_lock conversion or keep the
> rw_lock which has no readers anymore and behaves like a spinlock for a
> transition time so reverts of one of the read_lock -> rcu patches
> could be done to debug stuff.

So as per the above, I wouldn't worry about the write lockers. Might as 
well change it to a spinlock, since that's what it will act as. It's not 
as if there is any chance that the spinlock code is subtly buggy.

So the only reason to keep it as a rwlock would be if you decide to do the 
read-locked cases one by one, and don't end up with all of them converted. 
Which is a reasonable strategy too, of course. We don't _have_ to convert 
them all - if the main problem is some starvation issue, it's sufficient 
to convert just the main read-lock cases so that writers never get 
starved.

But converting it all would be nice, because that whole

	write_lock_irq(&tasklist_lock);

to

	spin_lock(&tasklist_lock);

conversion would likely be a measurable performance win. Both because 
spinlocks are fundamentally faster (no atomic on unlock), and because you 
get rid of the irq disable/enable. But in order to get there, you'd have 
to convert _all_ the read-lockers, so you'd miss the opportunity to only 
convert the easy cases.

			Linus
