Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYKQPrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYKQPrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYKQPrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:47:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYKQPrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:47:36 -0500
Date: Mon, 17 Nov 2008 10:47:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/7] ftrace, ppc: convert to new dynamic ftrace arch
 API
In-Reply-To: <18720.60351.611649.125429@drongo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0811171045070.2919@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org> <20081116212515.331278109@goodmis.org> <18720.60351.611649.125429@drongo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Paul Mackerras wrote:

> Steven Rostedt writes:
> 
> > +static int test_24bit_addr(unsigned long ip, unsigned long addr)
> > +{
> > +	unsigned long diff;
> > +
> > +	/* can we get to addr from ip in 24 bits? */
> > +	diff = ip > addr ? ip - addr : addr - ip;
> > +
> > +	return !(diff & ((unsigned long)-1 << 24));
> 
> Since a branch instruction can reach +/- 32MB, the 24 needs to be 25.
> It's 25 not 26 since you have effectively accounted for one bit by
> taking the absolute value of the offset.  Also, this will say that an
> offset of -0x2000000 is out of range whereas it is just in range.
> That probably doesn't matter unless you're relying on this to give
> exactly the same answer in all cases as tests done elsewhere (e.g. in
> module_64.c).

I'll update this to be correct.

> 
> Note that the address difference being too large isn't the only reason
> for a procedure call to go via a trampoline on ppc64.  A trampoline is
> also needed when the called function uses a different TOC from the
> caller.  The most obvious example of this is when the caller is in a
> module and the callee is in the main kernel or another module.
> 
> Currently all functions in the main kernel use the same TOC, but the
> linker is capable of dividing up a large executable into groups of
> functions and assigning a different TOC to each group, in order to
> avoid any of the TOCs getting too large (a TOC is limited to 64kB).
> If the linker does that, it automatically inserts trampolines to
> handle the TOC change.

OK, I'll deal with that at a another time. If this does happen in core 
kernel code, it will produce a nice warning and nicely shutdown ftrace, 
without causing any harm. Then I can deal with the bug report.

-- Steve


