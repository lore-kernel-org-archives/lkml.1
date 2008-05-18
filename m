Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYERRrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYERRrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 13:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYERRqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 13:46:51 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42952 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYERRqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 13:46:51 -0400
Date: Sun, 18 May 2008 21:46:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] posix timers: use SIGQUEUE_CANCELLED when the timer is destroyed
Message-ID: <20080518174646.GA25915@tv-sign.ru>
References: <20080517151422.GA9502@tv-sign.ru> <20080517153140.GA9534@tv-sign.ru> <alpine.LFD.1.10.0805171006090.3020@woody.linux-foundation.org> <20080518171543.GA25855@tv-sign.ru> <alpine.LFD.1.10.0805181024050.3020@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805181024050.3020@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, Linus Torvalds wrote:
> 
> On Sun, 18 May 2008, Oleg Nesterov wrote:
> > 
> > Initially, I did
> > 
> > 	q->flags |= SIGQUEUE_CANCELLED;
> > 	spin_lock_irqsave(lock, flags);
> > 	q->flags &= ~SIGQUEUE_PREALLOC;
> > 
> > to document the fact that SIGQUEUE_CANCELLED can be set lockless, but
> > then "optimized" the code, couldn't help myself... Besides, the code
> > above looks really confusing without the fat comment.
> 
> Oh, and the above is *wrong*.
> 
> Why?
> 
> Becayse if SIGQUEUE_PREALLOC setting needs the lock, then setting any 
> *other* bit in that word will also need the lock!
> 
> That's because
> 
> 	q->flags |= SIGQUEUE_CANCELLED;
> 
> writes those other bits too - admittedly with the value they were read 
> just before, but if it races with something setting SIGQUEUE_PREALLOC that 
> doesn't matter - the newly written version will simply be wrong.
> 
> So the rule is that if one bit of a word needs locking, then they *all* 
> do.

Ah. I wasn't clear.

Clearing of SIGQUEUE_PREALLOC needs ->siglock, yes. But not because anybody
else can write to q->flags. Nobody can, we (the timer) "own" this sigqueue.

Once we clear SIGQUEUE_PREALLOC, "q" can be freed by the receiver (it doesn't
writes to q->flags, it only reads ->flags). After that we can't trust the
list_empty() check, we just can't dereference this "struct sigqueue *".

Taking ->siglock before "&= ~SIGQUEUE_PREALLOC" ensures that "q" can't be
be freed if it is queued, nothing more.

Oleg.

