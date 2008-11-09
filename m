Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbYKINem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbYKINem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 08:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYKINec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 08:34:32 -0500
Received: from relais.videotron.ca ([24.201.245.36]:27052 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbYKINea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:34:30 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 09 Nov 2008 08:34:23 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] clarify usage expectations for cnt32_to_63()
In-reply-to: <20081109064855.GA23782@Krystal>
Message-id: <alpine.LFD.2.00.0811090827160.13034@xanadu.home>
References: <20081107201118.GB28600@flint.arm.linux.org.uk>
 <20081107213610.GC2654@Krystal> <9405.1226101315@redhat.com>
 <20081108001555.GE18378@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.0811080939180.13034@xanadu.home>
 <alpine.LFD.2.00.0811081746060.13034@xanadu.home>
 <20081109022549.GA18508@Krystal>
 <alpine.LFD.2.00.0811082143320.13034@xanadu.home>
 <alpine.LFD.2.00.0811082356090.13034@xanadu.home>
 <alpine.LFD.2.00.0811090015570.13034@xanadu.home>
 <20081109064855.GA23782@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008, Mathieu Desnoyers wrote:

> * Nicolas Pitre (nico@cam.org) wrote:
> > Currently, all existing users of cnt32_to_63() are fine since the CPU
> > architectures where it is used don't do read access reordering, and user
> > mode preemption is disabled already.  It is nevertheless a good idea to
> > better elaborate usage requirements wrt preemption, and use an explicit
> > memory barrier on SMP to avoid different CPUs accessing the counter
> > value in the wrong order.  On UP a simple compiler barrier is 
> > sufficient.
> > 
> > Signed-off-by: Nicolas Pitre <nico@marvell.com>
> > ---
> > 
> ...
> > @@ -68,9 +77,10 @@ union cnt32_to_63 {
> >   */
> >  #define cnt32_to_63(cnt_lo) \
> >  ({ \
> > -	static volatile u32 __m_cnt_hi; \
> > +	static u32 __m_cnt_hi; \
> 
> It's important to get the smp_rmb() here, which this patch provides, so
> consider this patch to be acked-by me. The added documentation is needed
> too.

Thanks.

> But I also think that declaring the static u32 __m_cnt_hi here is
> counter-intuitive for developers who wish to use it.

I'm rather not convinced of that.  And this is a much bigger change 
affecting all callers so I'd defer such change even if I was convinced 
of it.

> I'd recommend letting the declaration be done outside of cnt32_to_63 so
> the same variable can be passed as parameter to more than one execution
> site.

Do you really have such instances where multiple call sites are needed?  
That sounds even more confusing to me than the current model.  Better 
encapsulate the usage of this macro within some function which has a 
stronger meaning, such as sched_clock(), and call _that_ from multiple 
sites instead.


Nicolas
