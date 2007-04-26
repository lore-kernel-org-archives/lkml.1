Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbXDZHUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbXDZHUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933304AbXDZHUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:20:55 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:48521 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294AbXDZHUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:20:54 -0400
Subject: Re: [RFC PATCH 0/10] apic_wait_icr_idle issues and possible
	solutions
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: vgoyal@in.ibm.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, ak@suse.de, horms@verge.net.au,
       mbligh@google.com
In-Reply-To: <20070426064806.GA2626@in.ibm.com>
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
	 <20070426064806.GA2626@in.ibm.com>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Thu, 26 Apr 2007 16:20:51 +0900
Message-Id: <1177572051.1600.20.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 12:18 +0530, Vivek Goyal wrote:
> On Wed, Apr 25, 2007 at 08:03:04PM +0900, Fernando Luis Vázquez Cao wrote:
> > 
> > static __inline__ void apic_wait_icr_idle(void)
> > {
> >   while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
> >     cpu_relax();
> > }
> > 
> > The busy loop in this function would not be problematic if the
> > corresponding status bit in the ICR were always updated, but that does
> > not seem to be the case under certain crash scenarios. As an example,
> > when the other CPUs are locked-up inside the NMI handler the CPU that
> > sends the IPI will end up looping forever in the ICR check, effectively
> > hard-locking the whole system.
> > 
> > Quoting from Intel's "MultiProcessor Specification" (Version 1.4), B-3:
> > 
> > "A local APIC unit indicates successful dispatch of an IPI by
> > resetting the Delivery Status bit in the Interrupt Command
> > Register (ICR). The operating system polls the delivery status
> > bit after sending an INIT or STARTUP IPI until the command has
> > been dispatched.
> > 
> > A period of 20 microseconds should be sufficient for IPI dispatch
> > to complete under normal operating conditions. If the IPI is not
> > successfully dispatched, the operating system can abort the
> > command. Alternatively, the operating system can retry the IPI by
> > writing the lower 32-bit double word of the ICR. This “time-out”
> > mechanism can be implemented through an external interrupt, if
> > interrupts are enabled on the processor, or through execution of
> > an instruction or time-stamp counter spin loop."
> > 
> > Intel's documentation suggests the implementation of a time-out
> > mechanism, which, by the way, is already being open-coded in some parts
> > of the kernel that tinker with ICR.
> > 
> > --- Possible solutions
> > 
> > * Solution A: Implement the time-out mechanism in apic_wait_icr_idle.
> > 
> > The problem with this approach is that introduces a performance penalty
> > that may not be acceptable for some callers of apic_wait_icr_idle.
> > Besides, during normal operation delivery errors should not occur. This
> > brings us to solution B.
> > 
> 
> Hi Fernando,
Hi Vivek,

Thank you for your feedback!

> How much is the performance penalty? Is it really significant. My point
> is that, to me changing apic_wait_icr_dle() itself seems to be the simple
> approach instead of introducing another function.
That was what my gut feel said at first, too. But...

> Original implementation is:
> 
> static __inline__ void apic_wait_icr_idle(void)
> {
> 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
> 	cpu_relax();
> }
> 
> And new one will look something like.
> 
>         do {
>                 send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
>                 if (!send_status)
>                         break;
>                 udelay(100);
>         } while (timeout++ < 1000);
> 
> There will be at max 100 microsecond delay before you realize that IPI has
> been dispatched. To optimize it further we can change it to 10 microsecond
> delay
... I noticed that the maximum theoretical delay you mention has to be
multiplied by the number of CPUs on big systems, because on those
machines send_IPI_mask is implemented as a series of unicasts to each
CPU. It is for this reason that I thought this approach may be
considered unacceptable (I have to admit that I have not performed any
micro-benchmarks, though).

>         do {
>                 send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
>                 if (!send_status)
>                         break;
>                 udelay(10);
>         } while (timeout++ < 10000);
>  
> or may be
> 
>         do {
>                 send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
>                 if (!send_status)
>                         break;
>                 udelay(1);
>         } while (timeout++ < 100000);
> 
> I don't know if 1 micro second delay is supported. I do see it being
> used in kernel/hpet.c
Please notice that such high-precision timers are not available in all
machines.

> Is it too much of performance overhead? Somebody who knows more about it
> needs to tell. To me changing apic_wait_icr_idle() seems simple instead
> of introducing a new function and then making a special case for NMI.
As I mentioned above the performance overhead depends on several
factors. I hope it makes sense.

 - Fernando

