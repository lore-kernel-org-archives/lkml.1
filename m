Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbYGPTnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbYGPTnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYGPTnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:43:11 -0400
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:41971 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752012AbYGPTnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:43:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=oFXRnVpr+r8qewi0mqrL9rM3jgigdTob3ZMlyxv7SCwvO24dGgPI+epPCfqdaSKm1qZ26qvt21KxXN7yA4nofJ3aXgurjP+XvJLPn7UNykkV023TD6k+qYuBREweEZdQ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Vrabel <david.vrabel@csr.com>
Subject: Re: PCI: MSI interrupts masked using prohibited method
Date: Wed, 16 Jul 2008 12:43:03 -0700
User-Agent: KMail/1.9.9
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Wilcox <matthew@wil.cx>
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com> <200806271007.26248.jbarnes@virtuousgeek.org>
In-Reply-To: <200806271007.26248.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161243.03360.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 27, 2008 10:07 am Jesse Barnes wrote:
> On Friday, June 27, 2008 5:17 am David Vrabel wrote:
> > Jesse Barnes wrote:
> > > On Tuesday, June 24, 2008 3:46 am David Vrabel wrote:
> > >> PCI MSI interrupts are masked and unmasked using a method (by writing
> > >> the MSI Enable capability bit) that is prohibited by the PCI
> > >> specification.
> > >
> > > Yeah, it's probably quite a bit slower too (I assume you're talking
> > > about io_apic_64's msi_mask_irq).  Seems like masking this at the
> > > ioapic level would make more sense anyway...
> > >
> > >> This behaviour can cause missed interrupts with some devices if the
> > >> interrupt is asserted by the hardware while MSI is disabled.
> > >>
> > >> I believe the interrupt should be masked/unmasked on the interrupt
> > >> controller (the APIC on x86, for example).   I'm going to test this
> > >> now and see if it works.
> >
> > After further research it seems that MSI interrupts aren't routed via
> > the IO-APIC, so this cannot be done.
> >
> > I think the only solution is to not perform any sort of masking and rely
> > on the device driver being able to handle this.
>
> On x86, they're targetted at the LAPIC block (see section 8 of the IA SDM);
> maybe we could modify the message address or data such that it won't
> generate an interrupt instead?  I think this latest approach is correct in
> the sense that both the system and drivers have to take care that
>   1) we don't miss interrupts, and
>   2) we don't generate spurious unhandled interrupts (as might happen if we
> disable MSI and the device generates a legacy IRQ on a different vector).
>
> But it looks like the real problem is in the system interrupt code that
> handles MSIs.  We should only be disabling MSIs using the capability bit at
> device enable or disable time, not during the normal course of interrupt
> handling, since if we do we may miss device interrupts or have them routed
> to the wrong (legacy) vector.
>
> Cc'ing Ingo & Thomas since they know the core interrupt code pretty well.

Ingo or Matthew, any ideas about this?  The fundamental issue is that if we go 
poke at a device's MSI cap bits during interrupt handling, the device may 
start using regular IRQs instead, potentially on a different vector.  It 
would be good if we could come up with a better way of masking MSIs during 
handling...

Thanks,
Jesse
