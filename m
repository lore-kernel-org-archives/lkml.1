Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYF0RIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYF0RIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYF0RIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:08:16 -0400
Received: from outbound-mail-113.bluehost.com ([69.89.24.3]:40030 "HELO
	outbound-mail-113.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751128AbYF0RIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:08:15 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Vrabel <david.vrabel@csr.com>
Subject: Re: PCI: MSI interrupts masked using prohibited method
Date: Fri, 27 Jun 2008 10:07:25 -0700
User-Agent: KMail/1.9.9
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <4860D09D.4060801@csr.com> <200806251420.51751.jbarnes@virtuousgeek.org> <4864DA54.6000205@csr.com>
In-Reply-To: <4864DA54.6000205@csr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806271007.26248.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 27, 2008 5:17 am David Vrabel wrote:
> Jesse Barnes wrote:
> > On Tuesday, June 24, 2008 3:46 am David Vrabel wrote:
> >> PCI MSI interrupts are masked and unmasked using a method (by writing
> >> the MSI Enable capability bit) that is prohibited by the PCI
> >> specification.
> >
> > Yeah, it's probably quite a bit slower too (I assume you're talking about
> > io_apic_64's msi_mask_irq).  Seems like masking this at the ioapic level
> > would make more sense anyway...
> >
> >> This behaviour can cause missed interrupts with some devices if the
> >> interrupt is asserted by the hardware while MSI is disabled.
> >>
> >> I believe the interrupt should be masked/unmasked on the interrupt
> >> controller (the APIC on x86, for example).   I'm going to test this now
> >> and see if it works.
>
> After further research it seems that MSI interrupts aren't routed via
> the IO-APIC, so this cannot be done.
>
> I think the only solution is to not perform any sort of masking and rely
> on the device driver being able to handle this.

On x86, they're targetted at the LAPIC block (see section 8 of the IA SDM); 
maybe we could modify the message address or data such that it won't generate 
an interrupt instead?  I think this latest approach is correct in the sense 
that both the system and drivers have to take care that
  1) we don't miss interrupts, and 
  2) we don't generate spurious unhandled interrupts (as might happen if we 
disable MSI and the device generates a legacy IRQ on a different vector).

But it looks like the real problem is in the system interrupt code that 
handles MSIs.  We should only be disabling MSIs using the capability bit at 
device enable or disable time, not during the normal course of interrupt 
handling, since if we do we may miss device interrupts or have them routed to 
the wrong (legacy) vector.

Cc'ing Ingo & Thomas since they know the core interrupt code pretty well.

Jesse
