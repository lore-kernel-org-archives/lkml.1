Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbXHGTpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbXHGTpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbXHGTo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:44:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbXHGTo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:44:57 -0400
Date: Tue, 7 Aug 2007 15:44:37 -0400 (EDT)
From: Chip Coldwell <coldwell@redhat.com>
To: Vivek Goyal <vgoyal@in.ibm.com>
cc: Martin Wilck <martin.wilck@fujitsu-siemens.com>,
       Haren Myneni <hbabu@us.ibm.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
In-Reply-To: <20070807142928.GA18839@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0708071540090.20769@bogart.boston.redhat.com>
References: <46B73955.2080007@fujitsu-siemens.com> <20070807142928.GA18839@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007, Vivek Goyal wrote:

> On Mon, Aug 06, 2007 at 05:08:05PM +0200, Martin Wilck wrote:
> 
> > 1. If, under SMP, the IO-APIC logical destination field is
> >    set by the IRQ balancing code to one of the "other"
> >    CPUs (i.e. not the crashing_cpu), and an IRQ arrives
> >    on the respective pin after that CPU has shut down
> >    its local APIC (but before the IO-APIC pin is masked)
> >    the IRQ message can't be delivered.
> 
> Point 1 and Point 2 seems to be same.
> 
> > 
> > 2. The crashing CPU itself disables its local APIC
> >    before the IO-APIC, leaving a short time window
> >    where the IOAPIC can receive IRQs, but not
> >    deliver them.
> > 
> 
> I doubut that it would be the issue. Looking at intel IOAPIC (82093AA)
> documentation, it says that IRR bit of IOAPIC will be set only if
> destination CPU has accepted the interrupt.

I think you mean "destination Local APIC has accepted the interrupt"
above.  The Intel documentation cited above contains this text on page
12:

    For level triggered interrupts, this bit is set to 1 when local
    APIC(s) accept the level interrupt sent by the IOAPIC. The Remote
    IRR bit is set to 0 when an EOI message with a matching interrupt
    vector is received from a local APIC.

The following text is from the IA-64 documentation ...

    Any interrupt that is received by the processor is kept pending
    and recorded in the Interrupt Request Register (IRR). If the
    processor is not servicing an interrupt, then the contents of the
    TPR determines whether the processor will accept a pending
    interrupt depending on the priority of the interrupt compared to
    the current TPR. If the interrupt has a higher priority, then the
    processor is interrupted, otherwise the interrupt is kept pending.

So, I think if the CPU has interrupts disabled, but the Local APIC
does not, the IRR could get set.  I guess we need to be sure to turn
off the Local APIC first before disabling interrupts in the CPU.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426

