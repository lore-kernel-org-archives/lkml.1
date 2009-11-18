Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZKRFk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZKRFk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 00:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZKRFk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 00:40:57 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33237 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZKRFk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 00:40:57 -0500
Message-ID: <4B0388E7.5080704@us.ibm.com>
Date: Tue, 17 Nov 2009 21:40:55 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
References: <20091117074655.GA14023@google.com> <1258447807.7816.20.camel@laptop> <alpine.LFD.2.01.0911170708110.9384@localhost.localdomain> <20091118042128.GC23808@google.com>
In-Reply-To: <20091118042128.GC23808@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:

> One difficulty with adaptive spinning is that we want to avoid deadlocks.
> If two threads end up spinning in-kernel waiting for each other, we better
> have preemption enabled... or detect and deal with the situation somehow.

This is really only a problem for SCHED_FIFO tasks right? (SCHED_OTHER 
should get scheduled() out when CFS deems they've exhausted their fair 
share). Real-Time tasks typically should be using PI anyway as adaptive 
locking is non-deterministic and doesn't provide for PI. So I'm not sure 
how critical this problem is in practice.

> Also one aspect I dislike is that this would impose a given format on the
> futex for storing the TID.

We do have a precedent for this with robust as well as PI futexes.

  I would prefer if there were several bits available
> in the futex for userspace to do whatever they want. 8 bits would likely
> be enough, which leaves 24 for the TID - enough for us, but I have no idea
> if that's good enough for upstream inclusion. It that's not possible,
> one possible compromise could be:

And we already use two of those bits for OWNER_DIED and FUTEX_WAITERS. 
Perhaps you just have to choose between your own value scheme and 
adaptive spinning (sounds horribly limiting as I'm typing this...).

> 
> - userspace passes a TID (which it extracted from the futex value; but kernel
>   does not necessarily know how)
> - kernel spins until that TID goes to sleep, or the futex value is not equal
>   to val or setval anymore
> - if val != setval and the futex value is val, set it to setval
> - if the futex valus is setval, block, otherwise -EWOULDBLOCK.
> 
> If the lock got stolen from a different thread, userspace can decide to
> retry with or without adaptive spinning.

I'll think on this a bit more...

> 
> That would be the most generic interface I can think of, though it's
> starting to be a LOT of parameters - actually, too many to pass through
> the _syscall6 interface.
> 
> 
> I also like Darren's suggestion to do a FUTEX_SET_WAIT_REQUEUE_PI,
> but it's hitting the same 'too many parameters' limitation as well :/

We don't use val2 for FUTEX_WAIT_REQUEUE_PI, so we should be able to use 
that for setval.


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
