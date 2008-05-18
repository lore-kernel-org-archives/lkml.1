Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYERR1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYERR1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 13:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYERR0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 13:26:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbYERR0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 13:26:52 -0400
Date: Sun, 18 May 2008 10:24:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] posix timers: use SIGQUEUE_CANCELLED when the timer
 is destroyed
In-Reply-To: <20080518171543.GA25855@tv-sign.ru>
Message-ID: <alpine.LFD.1.10.0805181024050.3020@woody.linux-foundation.org>
References: <20080517151422.GA9502@tv-sign.ru> <20080517153140.GA9534@tv-sign.ru> <alpine.LFD.1.10.0805171006090.3020@woody.linux-foundation.org> <20080518171543.GA25855@tv-sign.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 May 2008, Oleg Nesterov wrote:
> 
> Initially, I did
> 
> 	q->flags |= SIGQUEUE_CANCELLED;
> 	spin_lock_irqsave(lock, flags);
> 	q->flags &= ~SIGQUEUE_PREALLOC;
> 
> to document the fact that SIGQUEUE_CANCELLED can be set lockless, but
> then "optimized" the code, couldn't help myself... Besides, the code
> above looks really confusing without the fat comment.

Oh, and the above is *wrong*.

Why?

Becayse if SIGQUEUE_PREALLOC setting needs the lock, then setting any 
*other* bit in that word will also need the lock!

That's because

	q->flags |= SIGQUEUE_CANCELLED;

writes those other bits too - admittedly with the value they were read 
just before, but if it races with something setting SIGQUEUE_PREALLOC that 
doesn't matter - the newly written version will simply be wrong.

So the rule is that if one bit of a word needs locking, then they *all* 
do.

(On alpha, this is true even for whole bytes or shortwords - because a 
byte/shortword write is actually "read word, update byte/short, write 
word" sequence on older CPU's. So you cannot do atomic byte updates, and 
need to use locks).

			Linus
