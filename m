Return-Path: <linux-kernel-owner+w=401wt.eu-S935684AbXHHOnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935684AbXHHOnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935568AbXHHOmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:42:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44976 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935561AbXHHOmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:42:43 -0400
Date: Wed, 8 Aug 2007 20:12:39 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Chip Coldwell <coldwell@redhat.com>
Cc: Martin Wilck <martin.wilck@fujitsu-siemens.com>,
       Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
Message-ID: <20070808144239.GA1499@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <46B73955.2080007@fujitsu-siemens.com> <20070807142928.GA18839@in.ibm.com> <46B8AECA.7050908@fujitsu-siemens.com> <20070808103603.GC13808@in.ibm.com> <Pine.LNX.4.64.0708081003000.29193@bogart.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708081003000.29193@bogart.boston.redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 10:06:13AM -0400, Chip Coldwell wrote:
> On Wed, 8 Aug 2007, Vivek Goyal wrote:
> 
> > On Tue, Aug 07, 2007 at 07:41:30PM +0200, Martin Wilck wrote:
> > > 
> > > Can you explain how, on the front side bus, the IO-APIC knows whether
> > > a CPU has accepted the INT message? There is no response
> > > to the INT message on the bus, except for the EOI which comes much later.
> > > I'm not saying that you're wrong, I just really don't understand this
> > > point.
> > > 
> > 
> > I don't know what is exactly hardware protocol. I am just going by 
> > intel documentation. 
> 
> I think it's important to distinguish between the LAPIC receiving an
> interrupt and the CPU receiving an interrupt.  The former could happen
> without the latter if the CPU has set the TPR above the priority of
> the interrupt received by the LAPIC.  In that case, the interrupt is
> kept pending in the LAPIC and recorded in the IRR if I understand the
> Intel documentation correctly.
> 
> So I think the scenario which leaves IRR set when the kdump kernel
> starts is possible.

Hi Chip,

That's true. I agree that once kdump kernel starts we very well can be
in a situation where ISR/IRR bits of LAPIC are set and IRR bit of IOAPIC
is set. These are pending interrupt which will be delivered in the
second kernel and that kernel will reject these pending interrupts as spurious
interrupt and send an EOI. This will clear the LAPIC state. 

But the issue here seems to be that LAPIC state got clear but IRR bit
at IOAPIC bit is not cleared because IOAPIC vector information was deleted
in first kernel and now upon receiving EOI, it does not know this EOI belongs
to which vector.

Given the fact that "irqpoll" makes things work, I think we should not 
complicate the logic and leave it like that. Anyway, our goal is to capture
the dump and not make sure in second kernel interrupt from all the devices
are coming.

Otherwise we shall have to resort to techniques like first masking all
the interrupts at IOAPIC level, then issuing EOI on all the cpus in the
first kernel itself. It makes the logic little twisted. 

Thanks
Vivek
