Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab0BDQjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:39:12 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59466 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351Ab0BDQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:39:09 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19OaB4O9ekLqFgVjL0sXpCS
Date: Thu, 4 Feb 2010 08:39:30 -0800
From: Tony Lindgren <tony@atomide.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Larry Bassel <lbassel@quicinc.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC PATCH] ARM: Change the mandatory barriers implementation
Message-ID: <20100204163929.GR22747@atomide.com>
References: <4B6A131B.1070005@codeaurora.org>
 <1265289330.28746.58.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265289330.28746.58.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas <catalin.marinas@arm.com> [100204 05:13]:
> On Thu, 2010-02-04 at 00:21 +0000, Abhijeet Dharmapurikar wrote:
> > > The mandatory barriers (mb, rmb, wmb) are used even on uniprocessor
> > > systems for things like ordering Normal Non-cacheable memory accesses
> > > with DMA transfer (via Device memory writes). The current implementation
> > > uses dmb() for mb() and friends but this is not sufficient. The DMB only
> > > ensures the ordering of accesses with regards to a single observer
> > > accessing the same memory. If a DMA transfer is started by a write to
> > > Device memory, the data to be transfered may not reach the main memory
> > > (even if mapped as Normal Non-cacheable) before the device receives the
> > > notification to begin the transfer. The only barrier that would help in
> > > this situation is DSB which would completely drain the write buffers.
> > 
> > On ARMv7, DMB guarantees that all accesses prior to DMB are observed by
> > an observer if that observer sees any accesses _after_ the DMB. In this
> > case, since DMA engine observes a write to itself( It is being written
> > to and hence must observe the write) it should also see the writes to
> > the buffers. A dmb() after the writes to buffer and before write to DMA
> > engine should suffice.
> 
> I asked our processor architect for a clarification on the wording of
> the DMB definition but the "all accesses" part most likely refer to
> accesses to the same peripheral or memory block (but not together).
> Intuitively, you can have a hardware configuration as below:
> 
>      CPU   Device
>       |     | |
>       +-----+ |      (1)
>       |       |
>     Buffer    |
>       |       |
>       +---+---+      (2)
>           |
>          RAM
> 
> The peripheral register write and memory write go on different paths. A
> DMB may ensure the ordering at level (1) but there could be delays
> before a write reaches the RAM and the peripheral would get the DMA
> start notification before that. Only DSB would ensure the draining of
> the buffer.

Additionally if there's an external bus at (1), the ARM ordering may
does not guarantee that bus is done.

For example, on omap L3/L4 buses we need to do a readback from the same
device on the bus to ensure the write got to the device. Otherwise things
like spurious interrupts can happen as the device has not yet acked the
interrupt while ARM thinks the handler is done.
 
> > Moreover an mb() could be in places where accesses to ARM's Device type
> > memory need ordering and are 1kb apart. Such usages of mb() would result
> > in a dsb() and could cause performance problems.
> 
> Note that accesses to Device memory are ordered relative to each-other
> without any barrier. If you have weakly ordered I/O (not the ARM case),
> there's mmiowb() for this.
> 
> If you need ordering between accesses to Normal memory and Device
> memory, a DSB is needed, hence the definition of mb() to be a DSB (some
> processors like Cortex-A8 implement DMB so that it drains the write
> buffer but this is not always the case on other implementations).
> 
> Of course, there are situations when you only need ordering of Normal
> memory accesses without any peripheral access and a DMB would be fine in
> this situation. But so far Linux uses mb() for both situations, hence
> I'm taking the less optimal approach for Normal-Normal ordering.

Yeah. The device access is ordered relative to each-other, but since
the device writes may directly affect ARM (for example IRQ status),
a readback from the device is the only way to guarantee ordering for
an external bus.

In most cases only the ordering of instructions matters and there
the barriers work just fine. Just FYI, in case others are experiencing
similar issues.
 
> > Since you mention the write buffers this probably applies only to ARMv6.
> > Correct me here, I think that dmb on ARMv6 should suffice too.
> 
> I can't guarantee. It depends on the processor implementation
> (ARM11MPCore may have a different behaviour). Linux on ARM should pretty
> much be architecturally generic.

Also, my experience is that what I describe above was rare on v6 omaps
(or some different problem), but was happening often on v7 omaps.

Regards,

Tony
