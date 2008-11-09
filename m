Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYKIC0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYKIC0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 21:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYKICZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 21:25:54 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:53582 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562AbYKICZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 21:25:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAPvVFUlMQWxa/2dsb2JhbACBdsYdg1g
Date: Sat, 8 Nov 2008 21:25:49 -0500
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
Subject: Re: [PATCH] clarify usage expectations for cnt32_to_63()
Message-ID: <20081109022549.GA18508@Krystal>
References: <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> <20081107164758.GB22134@Krystal> <20081107201118.GB28600@flint.arm.linux.org.uk> <20081107213610.GC2654@Krystal> <9405.1226101315@redhat.com> <20081108001555.GE18378@flint.arm.linux.org.uk> <alpine.LFD.2.00.0811080939180.13034@xanadu.home> <alpine.LFD.2.00.0811081746060.13034@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811081746060.13034@xanadu.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:20:28 up 157 days,  7:00,  6 users,  load average: 1.02, 0.58,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre (nico@cam.org) wrote:
> Currently, all existing users of cnt32_to_63() are fine since the CPU
> architectures where it is used don't do read access reordering, and user 
> mode preemption is disabled already.  It is nevertheless a good idea to
> better elaborate usage requirements wrt preemption, and use an explicit
> memory barrier for proper results on CPUs that may perform instruction
> reordering.
> 
> Signed-off-by: Nicolas Pitre <nico@marvell.com>
> ---
> 
> On Sat, 8 Nov 2008, Nicolas Pitre wrote:
> 
> > I think this is OK if not everyone can use this.  The main purpose for 
> > this code was to provide much increased accuracy for shed_clock() on 
> > processors with only a 32-bit hardware counter.
> > 
> > Given that sched_clock() is already used in contexts where preemption is 
> > disabled, I don't mind the addition of a precision to the associated 
> > comment mentioning that it must be called at least once per 
> > half period of the base counter ***and*** not be preempted 
> > away for longer than the half period of the counter minus the longest 
> > period between two calls.  The comment already mention a kernel timer 
> > which can be used to control the longest period between two calls.  
> > Implicit disabling of preemption is _NOT_ the goal of this code.
> > 
> > I also don't mind having a real barrier for this code to be useful on 
> > other platforms.  On the platform this was written for, any kind of 
> > barrier is defined as a compiler barrier which is perfectly fine and 
> > achieve the same effect as the current usage of volatile.
> 
> So here it is.
> 
> I used a rmb() so this is also safe for mixed usages in and out of 
> interrupt context.  On the architecture I care about this is turned into
> a simple compiler barrier and therefore doesn't make a difference, while 
> smp_rmb() is a noop which isn't right.
> 

Hum ? smp_rmb() is turned into a compiler barrier on !SMP architectures.
Turning it into a NOP would be broken. Actually, ARM defines it as a
barrier().

I *think* that smp_rmb() would be enough, supposing the access to memory
is done in program order wrt local interrupts in UP. This is basically
Steven's question, which has not received any clear answer yet. I'd like
to know what others think about it.

Mathieu

> I won't make a per_cpu_cnt32_to_63() version myself as I have no need 
> for that.  But if someone wants to use this witha per CPU counter which 
> is not coherent between CPUs then be my guest.  The usage requirements 
> would be the same but on each used CPU instead of globally.
> 
> diff --git a/include/linux/cnt32_to_63.h b/include/linux/cnt32_to_63.h
> index 8c0f950..584289d 100644
> --- a/include/linux/cnt32_to_63.h
> +++ b/include/linux/cnt32_to_63.h
> @@ -53,11 +53,19 @@ union cnt32_to_63 {
>   * needed increment.  And any race in updating the value in memory is harmless
>   * as the same value would simply be stored more than once.
>   *
> - * The only restriction for the algorithm to work properly is that this
> - * code must be executed at least once per each half period of the 32-bit
> - * counter to properly update the state bit in memory. This is usually not a
> - * problem in practice, but if it is then a kernel timer could be scheduled
> - * to manage for this code to be executed often enough.
> + * The restrictions for the algorithm to work properly are:
> + *
> + * 1) this code must be called at least once per each half period of the
> + *    32-bit counter;
> + *
> + * 2) this code must not be preempted for a duration longer than the
> + *    32-bit counter half period minus the longest period between two
> + *    calls to this code.
> + *
> + * Those requirements ensure proper update to the state bit in memory.
> + * This is usually not a problem in practice, but if it is then a kernel
> + * timer should be scheduled to manage for this code to be executed often
> + * enough.
>   *
>   * Note that the top bit (bit 63) in the returned value should be considered
>   * as garbage.  It is not cleared here because callers are likely to use a
> @@ -68,9 +76,10 @@ union cnt32_to_63 {
>   */
>  #define cnt32_to_63(cnt_lo) \
>  ({ \
> -	static volatile u32 __m_cnt_hi; \
> +	static u32 __m_cnt_hi; \
>  	union cnt32_to_63 __x; \
>  	__x.hi = __m_cnt_hi; \
> + 	rmb(); \
>  	__x.lo = (cnt_lo); \
>  	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
>  		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
