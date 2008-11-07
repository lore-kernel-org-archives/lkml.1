Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbYKGGIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbYKGGIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYKGGH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:07:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbYKGGHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:07:55 -0500
Date: Thu, 6 Nov 2008 22:05:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-Id: <20081106220530.5b0e3a96.akpm@linux-foundation.org>
In-Reply-To: <20081107053349.861709786@polymtl.ca>
References: <20081107052336.652868737@polymtl.ca>
	<20081107053349.861709786@polymtl.ca>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 00:23:44 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

>  #define cnt32_to_63(cnt_lo) \
>  ({ \
> -	static volatile u32 __m_cnt_hi; \
> +	static u32 __m_cnt_hi; \
>  	union cnt32_to_63 __x; \
>  	__x.hi = __m_cnt_hi; \
> +	smp_rmb(); 	/* read __m_cnt_hi before mmio cnt_lo */ \
>  	__x.lo = (cnt_lo); \
>  	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
>  		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \

Oh dear.  We have a macro which secretly maintains
per-instantiation-site global state?  And doesn't even implement locking
to protect that state?

I mean, the darned thing is called from sched_clock(), which can be
concurrently called on separate CPUs and which can be called from
interrupt context (with an arbitrary nesting level!) while it was running
in process context.

Who let that thing into Linux?


Look:

/*
 * Caller must provide locking to protect *caller_state
 */
u32 cnt32_to_63(u32 *caller_state, u32 cnt_lo);

But even that looks pretty crappy.
