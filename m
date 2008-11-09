Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbYKIQXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbYKIQXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbYKIQWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:22:54 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62029 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755168AbYKIQWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:22:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAHOZFklMQWxa/2dsb2JhbACBdsY/g1g
Date: Sun, 9 Nov 2008 11:22:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nicolas Pitre <nico@cam.org>
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
Message-ID: <20081109162250.GB10181@Krystal>
References: <9405.1226101315@redhat.com> <20081108001555.GE18378@flint.arm.linux.org.uk> <alpine.LFD.2.00.0811080939180.13034@xanadu.home> <alpine.LFD.2.00.0811081746060.13034@xanadu.home> <20081109022549.GA18508@Krystal> <alpine.LFD.2.00.0811082143320.13034@xanadu.home> <alpine.LFD.2.00.0811082356090.13034@xanadu.home> <alpine.LFD.2.00.0811090015570.13034@xanadu.home> <20081109064855.GA23782@Krystal> <alpine.LFD.2.00.0811090827160.13034@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811090827160.13034@xanadu.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:18:21 up 157 days, 20:58,  6 users,  load average: 1.14, 0.75,
	0.57
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre (nico@cam.org) wrote:
> On Sun, 9 Nov 2008, Mathieu Desnoyers wrote:
> 
> > * Nicolas Pitre (nico@cam.org) wrote:
> > > Currently, all existing users of cnt32_to_63() are fine since the CPU
> > > architectures where it is used don't do read access reordering, and user
> > > mode preemption is disabled already.  It is nevertheless a good idea to
> > > better elaborate usage requirements wrt preemption, and use an explicit
> > > memory barrier on SMP to avoid different CPUs accessing the counter
> > > value in the wrong order.  On UP a simple compiler barrier is 
> > > sufficient.
> > > 
> > > Signed-off-by: Nicolas Pitre <nico@marvell.com>
> > > ---
> > > 
> > ...
> > > @@ -68,9 +77,10 @@ union cnt32_to_63 {
> > >   */
> > >  #define cnt32_to_63(cnt_lo) \
> > >  ({ \
> > > -	static volatile u32 __m_cnt_hi; \
> > > +	static u32 __m_cnt_hi; \
> > 
> > It's important to get the smp_rmb() here, which this patch provides, so
> > consider this patch to be acked-by me. The added documentation is needed
> > too.
> 
> Thanks.
> 
> > But I also think that declaring the static u32 __m_cnt_hi here is
> > counter-intuitive for developers who wish to use it.
> 
> I'm rather not convinced of that.  And this is a much bigger change 
> affecting all callers so I'd defer such change even if I was convinced 
> of it.
> 
> > I'd recommend letting the declaration be done outside of cnt32_to_63 so
> > the same variable can be passed as parameter to more than one execution
> > site.
> 
> Do you really have such instances where multiple call sites are needed?  
> That sounds even more confusing to me than the current model.  Better 
> encapsulate the usage of this macro within some function which has a 
> stronger meaning, such as sched_clock(), and call _that_ from multiple 
> sites instead.
> 
> 
> Nicolas

I see a few reasons for it :

- If we want to inline the whole read function so we don't pay the extra
  runtime cost of a function call, this would become required.
- If we want to create a per cpu timer which updates the value
  periodically without calling the function. We may want to add some
  WARN_ON or some sanity tests in this periodic update that would not be
  part of the standard read code. If we don't have access to this
  variable outside of the macro, this becomes impossible.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
