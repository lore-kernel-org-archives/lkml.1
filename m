Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYKLDxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYKLDxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 22:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYKLDxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 22:53:32 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:59991 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbYKLDxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 22:53:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFAJPfGUlMQWxa/2dsb2JhbACBdstlg1c
Date: Tue, 11 Nov 2008 22:48:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nicolas Pitre <nico@cam.org>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, dhowells@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] convert cnt32_to_63 to inline
Message-ID: <20081112034826.GA29000@Krystal>
References: <20081109204256.89ab7925.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101627510.13034@xanadu.home> <20081110135850.0d620f3c.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101811130.13034@xanadu.home> <20081110152221.64948d23.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101917450.13034@xanadu.home> <20081111182759.GA8052@Krystal> <20081111191355.GA13724@flint.arm.linux.org.uk> <20081111201130.GA10801@Krystal> <20081111215112.GB12739@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081111215112.GB12739@flint.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:19:19 up 160 days,  7:59,  7 users,  load average: 1.01, 0.83,
	0.73
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> On Tue, Nov 11, 2008 at 03:11:30PM -0500, Mathieu Desnoyers wrote:
> > I think the added barrier() are causing these pipeline stalls. They
> > don't allow the compiler to read variables such as oscr2ns_scale before
> > the barrier because gcc cannot assume it won't be modified. However, to
> > insure that OSCR read is done after __m_cnt_hi read, this barrier seems
> > required to be safe against gcc optimizations.
> > 
> > Have you compared my patch to Nicolas'patch, which adds a smp_rmb() in
> > the macro or to a vanilla tree ?
> 
> Nicolas' patch compared to unmodified - there's less side effects,
> which come down to two pipeline stalls whereas we had none with
> the unmodified code.
> 
> One pipeline stall for loading the address of __m_cnt_hi and reading
> its value, followed by the same thing for oscr2ns_scale.
> 
> I think this is showing the problem of compiler barriers - they are
> indescriminate.  They are total and complete barriers - not only do
> they act on the data but also the compilers ability to emit code for
> generating the addresses of the data to be loaded.
> 
> Clearly, the address of OSCR, __m_cnt_hi nor oscr2ns_scale is ever
> going to change at run time - their addresses are all stored in the
> literal pool, but by putting compiler barriers in, the compiler is
> being prevented from reading from the literal pool at the most
> appropriate point.
> 
> So, I've tried this:
> 
>  unsigned long long sched_clock(void)
>  {
> +       unsigned long *oscr2ns_ptr = &oscr2ns_scale;
>         unsigned long long v = cnt32_to_63(OSCR);
> -       return (v * oscr2ns_scale) >> OSCR2NS_SCALE_FACTOR;
> +       return (v * *oscr2ns_ptr) >> OSCR2NS_SCALE_FACTOR;
>  }
> 
> to try to explicitly code the loads.  This unfortunately results in
> three pipeline stalls.  Also tried swapping the two lines starting
> 'unsigned long' without any improvement on not having those extra hacks
> to work around the barrier.
> 
> So, let's summarise this:
> 
> 1. the existing code works, is correct on ARM, and is efficient.
> 2. throwing barriers into the function makes it less efficient.
> 3. re-engineering the code appears to make things worse.
> 

Hrm, if we want to obtain similar results gcc has currently, casting to
(volatile u32) or doing a *(volatile u32 *) to force gcc to do specific
memory accesses in order could probably be used. Those are generally
discouraged because they are not suitable for SMP systems, but we are
talking here about UP-specific optimizations that will end up in UP-only
code, so why not ?

http://gcc.gnu.org/onlinedocs/gcc-4.0.4/gcc/Volatiles.html

"The minimum either standard specifies is that at a sequence point all
previous accesses to volatile objects have stabilized and no subsequent
accesses have occurred. Thus an implementation is free to reorder and
combine volatile accesses which occur between sequence points, but
cannot do so for accesses across a sequence point."

Therefore, regarding program order, the access is insured to be
performed between each semicolumn.

So that would be an argument for leaving the variable read in
architecture-specific code, because it heavily depends on the
architecture context (whether it's UP-only or must support SMP, whether
it has unordered memory reads...).

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
