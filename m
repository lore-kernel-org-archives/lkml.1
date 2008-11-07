Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYKGQsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYKGQsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYKGQsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:48:05 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:37949 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963AbYKGQsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:48:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAIz8E0lMQWxa/2dsb2JhbACBdsgSg1Y
Date: Fri, 7 Nov 2008 11:47:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nicolas Pitre <nico@cam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107164758.GB22134@Krystal>
References: <20081107003816.9b0f947a.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <25363.1226056819@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:22:03 up 155 days, 21:02,  6 users,  load average: 0.34, 0.68,
	0.79
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Howells (dhowells@redhat.com) wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > We have a macro which must only have a single usage in any particular
> > kernel build (and nothing to detect a violation of that).
> 
> That's not true.  It's a macro containing a _static_ local variable, therefore
> the macro may be used multiple times, and each time it's used the compiler
> will allocate a new piece of storage.
> 
> > It apparently tries to avoid races via ordering tricks, as long
> > as it is called with sufficient frequency.  But nothing guarantees
> > that it _is_ called sufficiently frequently?
> 
> The comment attached to it clearly states this restriction.  Therefore the
> caller must guarantee it.  That is something Mathieu's code and my code must
> deal with, not Nicolas's.
> 
> > There is absolutely no reason why the first two of these quite bad things
> > needed to be done.  In fact there is no reason why it needed to be
> > implemented as a macro at all.
> 
> There's a very good reason to implement it as either a macro or an inline
> function: it's faster.  Moving the whole thing out of line would impose an
> additional function call overhead - with a 64-bit return value on 32-bit
> platforms.  For my case - sched_clock() - I'm willing to burn a bit of extra
> space to get the extra speed.
> 
> > As I said in the text which you deleted and ignored, this would be
> > better if it was implemented as a C function which requires that the
> > caller explicitly pass in a reference to the state storage.
> 
> I'd be quite happy if it was:
> 
> 	static inline u64 cnt32_to_63(u32 cnt_lo, u32 *__m_cnt_hi)
> 	{
> 		union cnt32_to_63 __x;
> 		__x.hi = *__m_cnt_hi;
> 		__x.lo = cnt_lo;
> 		if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
> 			*__m_cnt_hi =
> 				__x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31);
> 		return __x.val;
> 	}
> 

Almost there. At least, with this kind of implementation, we would not
have to resort to various tricks to make sure a single code path is
called at a certain frequency. We would simply have to make sure the
__m_cnt_hi value is updated at a certain frequency. Thinking about
"data" rather than "code" makes much more sense.

The only missing thing here is the correct ordering. The problem is, as
I presented in more depth in my previous discussion with Nicolas, that
the __m_cnt_hi value has to be read before cnt_lo. First off, using this
macro with get_cycles() is simply buggy, because the macro expects
_perfect_ order of timestamps, no skew whatsoever, or otherwise time
could jump. This macro is therefore good only for mmio reads. One should
use per-cpu variables to keep the state of get_cycles() reads (as I did
in my other patch).

The following approach should work :

static inline u64 cnt32_to_63(u32 io_addr, u32 *__m_cnt_hi)
{
	union cnt32_to_63 __x;
	__x.hi = *__m_cnt_hi;   /* memory read for high bits internal state */
  smp_rmb();              /*
                           * read high bits before low bits insures time
                           * does not go backward.
                           */
	__x.lo = readl(cnt_lo); /* mmio read */
	if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
		*__m_cnt_hi =
			__x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31);
	return __x.val;
}

But any get_cycles() user of cnt32_to_63() should be shot down. The
bright side is  : there is no way get_cycles() can be used with this
new code. :)

e.g. of incorrect users for arm (unless they are UP only, but that seems
like a weird design argument) :

mach-sa1100/include/mach/SA-1100.h:#define OSCR     __REG(0x90000010)
/* OS timer Counter Reg. */
mach-sa1100/generic.c:  unsigned long long v = cnt32_to_63(OSCR);
mach-pxa/include/mach/pxa-regs.h:#define OSCR   __REG(0x40A00010)  /* OS
Timer Counter Register */
mach-pxa/time.c:  unsigned long long v = cnt32_to_63(OSCR);

Correct user :
mach-versatile/core.c:  unsigned long long v =
  cnt32_to_63(readl(VERSATILE_REFCOUNTER));

The new call would look like :

/* Hi 32-bits of versatile refcounter state, kept for cnt32_to_64. */
static u32 versatile_refcounter_hi;

unsigned long long v = cnt32_to_64(VERSATILE_REFCOUNTER, refcounter_hi);

Mathieu


> I imagine this would compile pretty much the same as the macro.  I think it
> would make it more obvious about the independence of the storage.
> 
> Alternatively, perhaps Nicolas just needs to mention this in the comment more
> clearly.
> 
> David

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
