Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYKGLVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYKGLVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYKGLVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:21:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48523 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbYKGLVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:21:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081107003816.9b0f947a.akpm@linux-foundation.org>
References: <20081107003816.9b0f947a.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Nicolas Pitre <nico@cam.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Fri, 07 Nov 2008 11:20:19 +0000
Message-ID: <25363.1226056819@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> We have a macro which must only have a single usage in any particular
> kernel build (and nothing to detect a violation of that).

That's not true.  It's a macro containing a _static_ local variable, therefore
the macro may be used multiple times, and each time it's used the compiler
will allocate a new piece of storage.

> It apparently tries to avoid races via ordering tricks, as long
> as it is called with sufficient frequency.  But nothing guarantees
> that it _is_ called sufficiently frequently?

The comment attached to it clearly states this restriction.  Therefore the
caller must guarantee it.  That is something Mathieu's code and my code must
deal with, not Nicolas's.

> There is absolutely no reason why the first two of these quite bad things
> needed to be done.  In fact there is no reason why it needed to be
> implemented as a macro at all.

There's a very good reason to implement it as either a macro or an inline
function: it's faster.  Moving the whole thing out of line would impose an
additional function call overhead - with a 64-bit return value on 32-bit
platforms.  For my case - sched_clock() - I'm willing to burn a bit of extra
space to get the extra speed.

> As I said in the text which you deleted and ignored, this would be
> better if it was implemented as a C function which requires that the
> caller explicitly pass in a reference to the state storage.

I'd be quite happy if it was:

	static inline u64 cnt32_to_63(u32 cnt_lo, u32 *__m_cnt_hi)
	{
		union cnt32_to_63 __x;
		__x.hi = *__m_cnt_hi;
		__x.lo = cnt_lo;
		if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
			*__m_cnt_hi =
				__x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31);
		return __x.val;
	}

I imagine this would compile pretty much the same as the macro.  I think it
would make it more obvious about the independence of the storage.

Alternatively, perhaps Nicolas just needs to mention this in the comment more
clearly.

David
