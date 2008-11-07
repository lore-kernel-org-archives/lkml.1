Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbYKGWlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbYKGWlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYKGWla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:41:30 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:57229 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156AbYKGWl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:41:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEANtRFElMQWxa/2dsb2JhbACBdskNg1Y
Date: Fri, 7 Nov 2008 17:36:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Nicolas Pitre <nico@cam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107223615.GA9197@Krystal>
References: <20081107003816.9b0f947a.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> <20081107164758.GB22134@Krystal> <20081107201118.GB28600@flint.arm.linux.org.uk> <20081107213610.GC2654@Krystal> <20081107221813.GA18378@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081107221813.GA18378@flint.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:32:10 up 156 days,  3:12,  7 users,  load average: 0.64, 1.62,
	1.18
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> On Fri, Nov 07, 2008 at 04:36:10PM -0500, Mathieu Desnoyers wrote:
> > * Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> > > On Fri, Nov 07, 2008 at 11:47:58AM -0500, Mathieu Desnoyers wrote:
> > > > But any get_cycles() user of cnt32_to_63() should be shot down. The
> > > > bright side is  : there is no way get_cycles() can be used with this
> > > > new code. :)
> > > > 
> > > > e.g. of incorrect users for arm (unless they are UP only, but that seems
> > > > like a weird design argument) :
> > > > 
> > > > mach-sa1100/include/mach/SA-1100.h:#define OSCR     __REG(0x90000010)
> > > > /* OS timer Counter Reg. */
> > > > mach-sa1100/generic.c:  unsigned long long v = cnt32_to_63(OSCR);
> > > > mach-pxa/include/mach/pxa-regs.h:#define OSCR   __REG(0x40A00010)  /* OS
> > > > Timer Counter Register */
> > > > mach-pxa/time.c:  unsigned long long v = cnt32_to_63(OSCR);
> > > 
> > > It's strange for you to make that assertion when PXA was the exact
> > > platform that Nicolas created this code for - and that's a platform
> > > where preempt has been widely used.
> > > 
> > > The two you mention are both ARMv5 or older architectures, and the
> > > first real SMP ARM architecture is ARMv6.  So architecturally they
> > > are UP only.
> > 
> > Ok. And hopefully they do not execute instructions speculatively ?
> 
> Again, that's ARMv6 and later.
> 
> > Because then a instruction sync would be required between the __m_hi_cnt
> > read and get_cycles.
> 
> What get_cycles?  This is the ARM implementation of get_cycles():
> 
> static inline cycles_t get_cycles (void)
> {
>         return 0;
> }
> 
> Maybe you're using a name for one thing which means something else to
> other people?  Please don't use confusing vocabulary.
> 

get_cycles() is expected to be a cpu register read which reads a cycle
counter. As far as I can tell,

#define OSCR     __REG(0x90000010)    /* OS timer Counter Reg. */

seems to fit this definition pretty closely. Or maybe not ?

I am personnally not trying to find someone to blame. Just trying to
figure out how to fix the existing code or, at the very least, to make
sure nobody will ask me to use a piece of code not suitable for
tracing clock source purposes.

Mathieu

> > If you design such stuff with portability in mind, you'd use per-cpu
> > variables, which ends up being a single variable in the single-cpu
> > special-case.
> 
> Explain how and why sched_clock(), which is a global time source, should
> use per-cpu variables.
> 
> > > So, tell me why you say "unless they are UP only, but that seems like
> > > a weird design argument"?  If the platforms can only ever be UP only,
> > > what's wrong with UP only code being used with them?  (Not that I'm
> > > saying anything there about cnt32_to_63.)
> > 
> > That's fine, as long as the code does not end up in include/linux and
> > stays in arch/arm/up-only-subarch/.
> 
> Well, that's where it was - private to ARM.  Then David Howells came
> along and unilaterally - and without reference to anyone as far as I
> can see - moved it to include/linux.
> 
> Neither Nicolas, nor me had any idea that it was going to move into
> include/linux - the first we knew of it was when pulling the change
> from Linus' tree.
> 
> Look, if people in the kernel community can't or won't communicate
> with others (either through malice, purpose or accident), you can
> expect this kind of crap to happen.
> 
> > When one try to create architecture agnostic code (which is what is
> > likely to be palatable to arch agnostic headers), designing with UP in
> > mind does not make much sense.
> 
> It wasn't architecture agnostic code.  It was ARM specific.  We have
> a "version control system" which stores "comments" for changes to the
> kernel tree.  Please use it to find out the true story.  I'll save
> you the trouble, here's the commits with full comments:
> 
> $ git log include/linux/cnt32_to_63.h
> commit b4f151ff899362fec952c45d166252c9912c041f
> Author: David Howells <dhowells@redhat.com>
> Date:   Wed Sep 24 17:48:26 2008 +0100
> 
>     MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
> 
>     Move asm-arm/cnt32_to_63.h to include/linux/ so that MN10300 can make
>     use of it too.
> 
>     Signed-off-by: David Howells <dhowells@redhat.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> $ git log -- arch/arm/include/asm/cnt32_to_63.h include/asm-arm/cnt32_to_63.h
> commit bc173c5789e1fc6065fd378edc815914b40ee86b
> Author: David Howells <dhowells@redhat.com>
> Date:   Fri Sep 26 16:22:58 2008 +0100
> 
>     ARM: Delete ARM's own cnt32_to_63.h
> 
>     Delete ARM's own cnt32_to_63.h as the copy in include/linux/ should now be
>     used instead.
> 
>     Signed-off-by: David Howells <dhowells@redhat.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit 4baa9922430662431231ac637adedddbb0cfb2d7
> Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
> Date:   Sat Aug 2 10:55:55 2008 +0100
> 
>     [ARM] move include/asm-arm to arch/arm/include/asm
> 
>     Move platform independent header files to arch/arm/include/asm, leaving
>     those in asm/arch* and asm/plat* alone.
> 
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> commit 838ccbc35eae5b44d47724e5f694dbec4a26d269
> Author: Nicolas Pitre <nico@cam.org>
> Date:   Mon Dec 4 20:19:31 2006 +0100
> 
>     [ARM] 3978/1: macro to provide a 63-bit value from a 32-bit hardware counter
> 
>     This is done in a completely lockless fashion. Bits 0 to 31 of the count
>     are provided by the hardware while bits 32 to 62 are stored in memory.
>     The top bit in memory is used to synchronize with the hardware count
>     half-period.  When the top bit of both counters (hardware and in memory)
>     differ then the memory is updated with a new value, incrementing it when
>     the hardware counter wraps around.  Because a word store in memory is
>     atomic then the incremented value will always be in synch with the top
>     bit indicating to any potential concurrent reader if the value in memory
>     is up to date or not wrt the needed increment.  And any race in updating
>     the value in memory is harmless as the same value would be stored more
>     than once.
> 
>     Signed-off-by: Nicolas Pitre <nico@cam.org>
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> So, stop slinging mud onto Nicolas and me over this.  The resulting
> mess is clearly not our creation.
> 
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
