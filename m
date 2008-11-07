Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYKGUMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYKGUMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYKGUMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:12:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45761 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYKGUMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:12:43 -0500
Date: Fri, 7 Nov 2008 20:11:18 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Nicolas Pitre <nico@cam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107201118.GB28600@flint.arm.linux.org.uk>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nicolas Pitre <nico@cam.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
	benh@kernel.crashing.org, paulus@samba.org,
	David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
References: <20081107003816.9b0f947a.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> <20081107164758.GB22134@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107164758.GB22134@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:47:58AM -0500, Mathieu Desnoyers wrote:
> But any get_cycles() user of cnt32_to_63() should be shot down. The
> bright side is  : there is no way get_cycles() can be used with this
> new code. :)
> 
> e.g. of incorrect users for arm (unless they are UP only, but that seems
> like a weird design argument) :
> 
> mach-sa1100/include/mach/SA-1100.h:#define OSCR     __REG(0x90000010)
> /* OS timer Counter Reg. */
> mach-sa1100/generic.c:  unsigned long long v = cnt32_to_63(OSCR);
> mach-pxa/include/mach/pxa-regs.h:#define OSCR   __REG(0x40A00010)  /* OS
> Timer Counter Register */
> mach-pxa/time.c:  unsigned long long v = cnt32_to_63(OSCR);

It's strange for you to make that assertion when PXA was the exact
platform that Nicolas created this code for - and that's a platform
where preempt has been widely used.

The two you mention are both ARMv5 or older architectures, and the
first real SMP ARM architecture is ARMv6.  So architecturally they
are UP only.

So, tell me why you say "unless they are UP only, but that seems like
a weird design argument"?  If the platforms can only ever be UP only,
what's wrong with UP only code being used with them?  (Not that I'm
saying anything there about cnt32_to_63.)

I'd like to see you modify the silicon of a PXA or SA11x0 SoC to add
more than one processor to the chip - maybe you could use evostick to
glue two dies together and a microscope to aid bonding wires between
the two?  (Of course, you'd need to design something to ensure cache
coherence as well, and arbitrate the internal bus between the two
dies.) ;)

Personally, I think that's highly unlikely.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
