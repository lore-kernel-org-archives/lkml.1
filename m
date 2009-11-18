Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZKREVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZKREVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 23:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZKREVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 23:21:30 -0500
Received: from smtp-out.google.com ([216.239.45.13]:1201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbZKREVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 23:21:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=Yulq9v0ts/YWYWnwrHoUvbfByS+SE3HpvmEvDTqvtNcbVnEqwmveo+4MjusWshvOZ
	qQ6AkVIhAMaC4a3wnxoQQ==
Date: Tue, 17 Nov 2009 20:21:28 -0800
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
Message-ID: <20091118042128.GC23808@google.com>
References: <20091117074655.GA14023@google.com> <1258447807.7816.20.camel@laptop> <alpine.LFD.2.01.0911170708110.9384@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911170708110.9384@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 07:24:09AM -0800, Linus Torvalds wrote:
> The FUTEX_SET_WAIT concept seems well-defined, although it sounds more 
> like a FUTEX_CMPXCHG_WAIT to me than a "SET" operation. I'm not entirely 
> sure that we really want to do the CMPXCHG in the kernel rather than in 
> user space, since lock stealing generally isn't a problem, but I don't 
> think it's _wrong_ to add this concept.
> 
> In fact, CMPXCHG is generally seen to be the "fundamental" base for 
> implementing locking, so in that sense it makes perfect sense to have it 
> as a FUTEX model.

My first version called the operation that way, but it did *NOT* block if
val2 (now renamed setval) was already set in the futex. Turned out it helps
my use case if I do block in that situation, so I changed the operation
accordingly and renamed it into FUTEX_SET_WAIT (with a CAS model in mind,
though it's still also similar to cmpxchg in that it just returns if
the uval is not 'val' or 'setval').

> That said, I personally think the adaptive wait model is (a) more likely 
> to fix many performance issues and (b) a bit more high-level concept, so I 
> like Peter's patch too, but I don't see that the patches would really be 
> mutually exclusive.
> 
> Of course, it's possible that Michel's performance problem is fixed by the 
> adaptive approach too, in which case the FUTEX_SET_WAIT (or _CMPXCHG_WAIT) 
> patch is just fundamentally less interesting. But some people do need 
> fairness - even when it's bad for performance - so...
> 
> One thing that does strike me is that _if_ we want to do both interfaces, 
> then I would assume that we quite likely also want to have an adaptive 
> version of the FUTEX_SET|CMPXCHG_WAIT thing. Which perhaps implies that 
> the "ADAPTIVE" part should be a bitflag in the command value?

I like the adaptive approach as well, though I'm not sure yet if it'd work
for us. I can try it but it'll take a bit of time.


One difficulty with adaptive spinning is that we want to avoid deadlocks.
If two threads end up spinning in-kernel waiting for each other, we better
have preemption enabled... or detect and deal with the situation somehow.


Also one aspect I dislike is that this would impose a given format on the
futex for storing the TID. I would prefer if there were several bits available
in the futex for userspace to do whatever they want. 8 bits would likely
be enough, which leaves 24 for the TID - enough for us, but I have no idea
if that's good enough for upstream inclusion. It that's not possible,
one possible compromise could be:

- userspace passes a TID (which it extracted from the futex value; but kernel
  does not necessarily know how)
- kernel spins until that TID goes to sleep, or the futex value is not equal
  to val or setval anymore
- if val != setval and the futex value is val, set it to setval
- if the futex valus is setval, block, otherwise -EWOULDBLOCK.

If the lock got stolen from a different thread, userspace can decide to
retry with or without adaptive spinning.

That would be the most generic interface I can think of, though it's
starting to be a LOT of parameters - actually, too many to pass through
the _syscall6 interface.


I also like Darren's suggestion to do a FUTEX_SET_WAIT_REQUEUE_PI,
but it's hitting the same 'too many parameters' limitation as well :/

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
