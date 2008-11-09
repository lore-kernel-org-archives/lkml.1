Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbYKIGtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbYKIGtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 01:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYKIGs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 01:48:59 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:41211 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbYKIGs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 01:48:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAEMVFklMQWxa/2dsb2JhbACBdsYyg1g
Date: Sun, 9 Nov 2008 01:48:55 -0500
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
Message-ID: <20081109064855.GA23782@Krystal>
References: <20081107201118.GB28600@flint.arm.linux.org.uk> <20081107213610.GC2654@Krystal> <9405.1226101315@redhat.com> <20081108001555.GE18378@flint.arm.linux.org.uk> <alpine.LFD.2.00.0811080939180.13034@xanadu.home> <alpine.LFD.2.00.0811081746060.13034@xanadu.home> <20081109022549.GA18508@Krystal> <alpine.LFD.2.00.0811082143320.13034@xanadu.home> <alpine.LFD.2.00.0811082356090.13034@xanadu.home> <alpine.LFD.2.00.0811090015570.13034@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811090015570.13034@xanadu.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:43:04 up 157 days, 11:23,  6 users,  load average: 0.58, 0.74,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre (nico@cam.org) wrote:
> Currently, all existing users of cnt32_to_63() are fine since the CPU
> architectures where it is used don't do read access reordering, and user
> mode preemption is disabled already.  It is nevertheless a good idea to
> better elaborate usage requirements wrt preemption, and use an explicit
> memory barrier on SMP to avoid different CPUs accessing the counter
> value in the wrong order.  On UP a simple compiler barrier is 
> sufficient.
> 
> Signed-off-by: Nicolas Pitre <nico@marvell.com>
> ---
> 
...
> @@ -68,9 +77,10 @@ union cnt32_to_63 {
>   */
>  #define cnt32_to_63(cnt_lo) \
>  ({ \
> -	static volatile u32 __m_cnt_hi; \
> +	static u32 __m_cnt_hi; \

It's important to get the smp_rmb() here, which this patch provides, so
consider this patch to be acked-by me. The added documentation is needed
too.

But I also think that declaring the static u32 __m_cnt_hi here is
counter-intuitive for developers who wish to use it.

I'd recommend letting the declaration be done outside of cnt32_to_63 so
the same variable can be passed as parameter to more than one execution
site.

Mathieu


>  	union cnt32_to_63 __x; \
>  	__x.hi = __m_cnt_hi; \
> + 	smp_rmb(); \
>  	__x.lo = (cnt_lo); \
>  	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
>  		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
