Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbYKGRRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbYKGRRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 12:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbYKGRRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 12:17:07 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:39123 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbYKGRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 12:17:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAMoEFElMQWxa/2dsb2JhbACBdrxuCIsJglMIew
Date: Fri, 7 Nov 2008 12:17:03 -0500
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
Message-ID: <20081107171703.GE22134@Krystal>
References: <20081107164758.GB22134@Krystal> <20081107003816.9b0f947a.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> <8481.1226077497@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <8481.1226077497@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:11:58 up 155 days, 21:52,  7 users,  load average: 0.13, 0.58,
	0.67
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Howells (dhowells@redhat.com) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > First off, using this macro with get_cycles() is simply buggy, because the
> > macro expects _perfect_ order of timestamps, no skew whatsoever, or
> > otherwise time could jump.
> 
> Erm...  Why can't I pass it get_cycles()?  Are you saying that sched_clock()
> in MN10300 is wrong for it's use of get_cycles() with cnt32_to_63()?
> 

Yes. Do you think the synchronization of the cycles counters is
_perfect_ across CPUs so that there is no possible way whatsoever that
two cycle counter values appear to go backward between CPUs ? (also
taking in account delays in __m_cnt_hi write-back...)

As I showed in my previous example, if you are unlucky enough to hit the
spot where the cycle counters go backward at the time warp edge, time
will jump of 2^32, so about 4.29s at 1GHz.

> > 	__x.lo = readl(cnt_lo); /* mmio read */
> 
> readl() might insert an extra barrier instruction.  Not only that, io_addr
> must be unsigned long.

If we expect the only correct use-case to be with readl(), I don't see
the problem with added synchronization.

> 

Ah, right, then the parameters should be updated accordingly.

static inline u64 cnt32_to_63(unsigned long io_addr, u32 *__m_cnt_hi)
{
        union cnt32_to_63 __x;
        __x.hi = *__m_cnt_hi;   /* memory read for high bits internal state */
        rmb();                  /*
                                 * read high bits before low bits insures time
                                 * does not go backward. Sync across
                                 * CPUs and for interrupts.
                                 */
        __x.lo = readl(io_addr); /* mmio read */
        if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
                *__m_cnt_hi =
                        __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31);
        return __x.val;
}

Mathieu

> David

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
