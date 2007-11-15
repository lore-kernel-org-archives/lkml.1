Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbXKOEp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbXKOEp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 23:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbXKOEpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 23:45:21 -0500
Received: from ozlabs.org ([203.10.76.45]:43274 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbXKOEpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 23:45:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization
Date: Thu, 15 Nov 2007 15:45:18 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071113185800.436425570@polymtl.ca> <200711151408.46030.rusty@rustcorp.com.au> <20071115040610.GA23443@Krystal>
In-Reply-To: <20071115040610.GA23443@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711151545.19359.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 15:06:10 Mathieu Desnoyers wrote:
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > A stop_machine (or lightweight variant using IPI) would be sufficient and
> > vastly simpler.  Trying to patch NMI handlers while they're running is
> > already crazy.
>
> I wouldn't mind if it was limited to the code within do_nmi(), but then
> we would have to accept potential GPF if
>
> A - the NMI or MCE code calls any external kernel code (printk,
>   notify_die, spin_lock/unlock, die_nmi, lapic_wd_event (perfctr code,
>   calls printk too for debugging)...

Sure, but as I pointed out previously, such calls are already best effort.  
You can do very little safely from do_nmi(), and calling printk isn't one of 
them, nor is grabbing a spinlock (well, actually you could as long as it's 
*only* used by NMI handlers.  See any of those?).

> Therefore, if one decides to use the immediate values to
> leave dormant spinlock instrumentation in the kernel, I wouldn't want it
> to have undesirable side-effects (GPF) when the instrumentation is
> being enabled, as rare as it could be.

It's overengineered, since it's less likely than deadlock already.

> > I'd keep this version up your sleeve for they day when it's needed.
>
> If we choose to go this way, stop_machine would have to do a sync_core()
> on every CPU before it reactivates interrupts for this to respect
> Intel's errata.

Yes, I don't think stop_machine is actually what you want anyway, since you 
are happy to run in interrupt context.  An IPI-based scheme is probably 
better, and also has the side effect of iret doing the sync you need, IIUC.

Hope that clarifies,
Rusty.
