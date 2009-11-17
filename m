Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZKQPZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZKQPZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZKQPZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:25:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbZKQPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:25:13 -0500
Date: Tue, 17 Nov 2009 07:24:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Michel Lespinasse <walken@google.com>, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
In-Reply-To: <1258447807.7816.20.camel@laptop>
Message-ID: <alpine.LFD.2.01.0911170708110.9384@localhost.localdomain>
References: <20091117074655.GA14023@google.com> <1258447807.7816.20.camel@laptop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Nov 2009, Peter Zijlstra wrote:
>
> (long quote for Linus' benefit, added an old patch to the tail)

Both look conceptually sane to me.

The FUTEX_SET_WAIT concept seems well-defined, although it sounds more 
like a FUTEX_CMPXCHG_WAIT to me than a "SET" operation. I'm not entirely 
sure that we really want to do the CMPXCHG in the kernel rather than in 
user space, since lock stealing generally isn't a problem, but I don't 
think it's _wrong_ to add this concept.

In fact, CMPXCHG is generally seen to be the "fundamental" base for 
implementing locking, so in that sense it makes perfect sense to have it 
as a FUTEX model.

That said, I personally think the adaptive wait model is (a) more likely 
to fix many performance issues and (b) a bit more high-level concept, so I 
like Peter's patch too, but I don't see that the patches would really be 
mutually exclusive.

Of course, it's possible that Michel's performance problem is fixed by the 
adaptive approach too, in which case the FUTEX_SET_WAIT (or _CMPXCHG_WAIT) 
patch is just fundamentally less interesting. But some people do need 
fairness - even when it's bad for performance - so...

One thing that does strike me is that _if_ we want to do both interfaces, 
then I would assume that we quite likely also want to have an adaptive 
version of the FUTEX_SET|CMPXCHG_WAIT thing. Which perhaps implies that 
the "ADAPTIVE" part should be a bitflag in the command value?

		Linus
