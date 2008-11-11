Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbYKKVxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbYKKVxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYKKVx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:53:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60627 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYKKVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:53:25 -0500
Date: Tue, 11 Nov 2008 21:51:12 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Nicolas Pitre <nico@cam.org>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, dhowells@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] convert cnt32_to_63 to inline
Message-ID: <20081111215112.GB12739@flint.arm.linux.org.uk>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Nicolas Pitre <nico@cam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, dhowells@redhat.com, mingo@elte.hu,
	a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
	ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
	davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
	rostedt@goodmis.org, linux-arch@vger.kernel.org
References: <alpine.LFD.2.00.0811092304300.13034@xanadu.home> <20081109204256.89ab7925.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101627510.13034@xanadu.home> <20081110135850.0d620f3c.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101811130.13034@xanadu.home> <20081110152221.64948d23.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101917450.13034@xanadu.home> <20081111182759.GA8052@Krystal> <20081111191355.GA13724@flint.arm.linux.org.uk> <20081111201130.GA10801@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111201130.GA10801@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 03:11:30PM -0500, Mathieu Desnoyers wrote:
> I think the added barrier() are causing these pipeline stalls. They
> don't allow the compiler to read variables such as oscr2ns_scale before
> the barrier because gcc cannot assume it won't be modified. However, to
> insure that OSCR read is done after __m_cnt_hi read, this barrier seems
> required to be safe against gcc optimizations.
> 
> Have you compared my patch to Nicolas'patch, which adds a smp_rmb() in
> the macro or to a vanilla tree ?

Nicolas' patch compared to unmodified - there's less side effects,
which come down to two pipeline stalls whereas we had none with
the unmodified code.

One pipeline stall for loading the address of __m_cnt_hi and reading
its value, followed by the same thing for oscr2ns_scale.

I think this is showing the problem of compiler barriers - they are
indescriminate.  They are total and complete barriers - not only do
they act on the data but also the compilers ability to emit code for
generating the addresses of the data to be loaded.

Clearly, the address of OSCR, __m_cnt_hi nor oscr2ns_scale is ever
going to change at run time - their addresses are all stored in the
literal pool, but by putting compiler barriers in, the compiler is
being prevented from reading from the literal pool at the most
appropriate point.

So, I've tried this:

 unsigned long long sched_clock(void)
 {
+       unsigned long *oscr2ns_ptr = &oscr2ns_scale;
        unsigned long long v = cnt32_to_63(OSCR);
-       return (v * oscr2ns_scale) >> OSCR2NS_SCALE_FACTOR;
+       return (v * *oscr2ns_ptr) >> OSCR2NS_SCALE_FACTOR;
 }

to try to explicitly code the loads.  This unfortunately results in
three pipeline stalls.  Also tried swapping the two lines starting
'unsigned long' without any improvement on not having those extra hacks
to work around the barrier.

So, let's summarise this:

1. the existing code works, is correct on ARM, and is efficient.
2. throwing barriers into the function makes it less efficient.
3. re-engineering the code appears to make things worse.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
