Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYKGIMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYKGIMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYKGIM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:12:26 -0500
Received: from relais.videotron.ca ([24.201.245.36]:37083 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYKGIMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:12:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 07 Nov 2008 03:12:18 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
In-reply-to: <20081106220530.5b0e3a96.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0811070256450.13034@xanadu.home>
References: <20081107052336.652868737@polymtl.ca>
 <20081107053349.861709786@polymtl.ca>
 <20081106220530.5b0e3a96.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Andrew Morton wrote:

> On Fri, 07 Nov 2008 00:23:44 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> >  #define cnt32_to_63(cnt_lo) \
> >  ({ \
> > -	static volatile u32 __m_cnt_hi; \
> > +	static u32 __m_cnt_hi; \
> >  	union cnt32_to_63 __x; \
> >  	__x.hi = __m_cnt_hi; \
> > +	smp_rmb(); 	/* read __m_cnt_hi before mmio cnt_lo */ \
> >  	__x.lo = (cnt_lo); \
> >  	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
> >  		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
> 
> Oh dear.  We have a macro which secretly maintains
> per-instantiation-site global state?  And doesn't even implement locking
> to protect that state?

Please do me a favor and look for those very unfrequent posts I've sent 
to lkml lately.  I've explained it all at least 3 times so far, to Peter 
Zijlstra, to David Howells, to Mathieu Desnoyers, and now to you.

> I mean, the darned thing is called from sched_clock(), which can be
> concurrently called on separate CPUs and which can be called from
> interrupt context (with an arbitrary nesting level!) while it was running
> in process context.

Yes!  And this is so on *purpose*.  Please take some time to read the 
comment that goes along with it, and if you're still not convinced then 
look for those explanation emails I've already posted.

> /*
>  * Caller must provide locking to protect *caller_state
>  */

NO!  This is meant to be LOCK FREE!


Nicolas
