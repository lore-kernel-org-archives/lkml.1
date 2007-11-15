Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbXKOEGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbXKOEGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 23:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbXKOEGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 23:06:14 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:33892 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbXKOEGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 23:06:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAO9UO0dMROHU/2dsb2JhbACBXI5w
Date: Wed, 14 Nov 2007 23:06:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization
Message-ID: <20071115040610.GA23443@Krystal>
References: <20071113185800.436425570@polymtl.ca> <20071113190040.740103668@polymtl.ca> <200711151408.46030.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200711151408.46030.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:34:40 up 11 days,  8:40,  5 users,  load average: 0.05, 0.18,
	0.29
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Wednesday 14 November 2007 05:58:05 Mathieu Desnoyers wrote:
> > x86 optimization of the immediate values which uses a movl with code
> > patching to set/unset the value used to populate the register used as
> > variable source.
> 
> For the record, I think the patching code gross overkill.
> 
> A stop_machine (or lightweight variant using IPI) would be sufficient and 
> vastly simpler.  Trying to patch NMI handlers while they're running is 
> already crazy.
> 

I wouldn't mind if it was limited to the code within do_nmi(), but then
we would have to accept potential GPF if

A - the NMI or MCE code calls any external kernel code (printk,
  notify_die, spin_lock/unlock, die_nmi, lapic_wd_event (perfctr code,
  calls printk too for debugging)...

B - we try to patch this code at the wrong moment

I could live with that, but I would prefer to have a solid, non flaky
solution. My goal is to help the kernel quality _improve_ rather than
deteriorate. Therefore, if one decides to use the immediate values to
leave dormant spinlock instrumentation in the kernel, I wouldn't want it
to have undesirable side-effects (GPF) when the instrumentation is
being enabled, as rare as it could be.

> I'd keep this version up your sleeve for they day when it's needed.
> 

If we choose to go this way, stop_machine would have to do a sync_core()
on every CPU before it reactivates interrupts for this to respect
Intel's errata. It's not just a matter of not executing the code while
it is modified; the issue here is that we must insure that we don't have
an incoherent trace cache.  So, as is, stop_machine would not respect
the errata.

Mathieu

> Rusty.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
