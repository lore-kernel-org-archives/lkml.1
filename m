Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbXKSO2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbXKSO2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbXKSO2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:28:08 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:58444 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbXKSO2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:28:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAHssQUdMROHU/2dsb2JhbACBWA
Date: Mon, 19 Nov 2007 09:28:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (simplified)
Message-ID: <20071119142803.GA19301@Krystal>
References: <20071113185800.436425570@polymtl.ca> <200711152206.07519.rusty@rustcorp.com.au> <20071116140334.GA14930@Krystal> <200711191011.18634.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200711191011.18634.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:12:04 up 15 days, 18:17,  3 users,  load average: 0.74, 0.78,
	1.01
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Saturday 17 November 2007 01:03:35 Mathieu Desnoyers wrote:
> > x86 optimization of the immediate values which uses a movl with code
> > patching to set/unset the value used to populate the register used as
> > variable source.
> 
> Since immediate values are by definition an optimization, I think it makes
> sense to insist they be 1, 2, 4 or 8 bytes.  A BUILD_BUG_ON() in the right
> place should ensure this (probably in generic code rather than x86).
> 
sure,


> > ===================================================================
> > --- linux-2.6-lttng.orig/arch/x86/kernel/traps_32.c
> 
> I don't think you need any modification to this file now.
> 
yep,

> > + * Create the instruction in a discarded section to calculate its size. This is
> > + * how we can align the beginning of the instruction on an address that will 
> > + * permit atomic modificatino of the immediate value without knowing the size of 
> > + * the opcode used by the compiler. The operand size is known in advance.
> > + */ 
> 
> This alignment is also now unnecessary.
> 

right,

> > +++ linux-2.6-lttng/arch/x86/kernel/immediate.c	2007-11-16
> > 08:56:22.000000000 -0500 @@ -0,0 +1,143 @@
> > +/*
> > + * Immediate Value - x86 architecture specific code.
> 
> This is now almost entirely generic code, but I suppose we can let the next
> architecture hoist it out.
> 

I'll move it to kernel/immediate.c. We can therefore remove the powerpc
immediate.c as well.

> > +/**
> > + * arch_immediate_update_early - update one immediate value at boot time
> > + * @immediate: pointer of type const struct __immediate to update
> > + *
> > + * Update one immediate value at boot time.
> > + */
> > +void arch_immediate_update_early(const struct __immediate *immediate)
> 
> I think it would be easier to just fast-path the num_online_cpus == 1 case,
> even if you want to keep this "update_early" interface.
> 

Nope, that could lead to problems. I call core_immediate_update()
_very_ early, before boot_cpu_init() is called. Therefore,
cpu_online_map is not set yet. I am not sure the benefit of using
num_online_cpus outweights the added fragility wrt other boot process
initializations.

> But I like your IPI algorithm: very tight.
> 

Thanks. Many thanks for the review, I'll repost the patchset for
comments.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
