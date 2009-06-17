Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbZFQRce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbZFQRce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbZFQRc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:32:26 -0400
Received: from claw.goop.org ([74.207.240.146]:50328 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbZFQRcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:32:25 -0400
Message-ID: <4A392896.9090408@goop.org>
Date: Wed, 17 Jun 2009 10:32:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>	<4A36B3EC.7010004@goop.org> <m1fxe117n5.fsf@fess.ebiederm.org>	<4A37F4AE.5050902@goop.org> <m1vdmvxe3u.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdmvxe3u.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/09 05:02, Eric W. Biederman wrote:
> Trying to understand what is going on I just read through Xen 3.4 and the
> accompanying 2.6.18 kernel source.
>    

Thanks very much for spending time on this.  I really appreciate it.

> Xen has a horrible api with respect to io_apics.  They aren't even real
> io_apics when Xen is done ``abstracting'' them.
>
> Xen gives us the vector to write.  But we get to assign that
> vector arbitrarily to an ioapic and vector.
>
> We are required to use a hypercall when performing the write.
> Xen overrides the delivery_mode and destination, and occasionally
> the mask bit.
>    

Yes, it's a bit mad.  All those writes are really conveying is the 
vector, and Xen gave that to us in the first place.

> We still have to handle polarity and the trigger mode.  Despite
> the fact that Xen has acpi and mp tables parsers of it's own.
>
> I expect it would have been easier and simpler all around if there
> was just a map_gsi event channel hypercall.  But Xen has an abi
> and an existing set of calls so could aren't worth worrying about
> much.
>    

Actually I was discussing this with Keir yesterday.  We're definitely 
open to changing the dom0 API to make things simpler on the Linux side.  
(The dom0 ABI is more fluid than the domU one, and these changes would 
be backwards-compatible anyway.)

One of the options we discussed was changing the API to get rid of the 
exposed vector, and just replace it with an operation to directly bind a 
gsi to a pirq (internal Xen physical interrupt handle, if you will), so 
that Xen ends up doing all the I/O APIC programming internally, as well 
as the local APIC.

On the Linux side, I think it means we can just point 
pcibios_enable/disable_irq to our own xen_pci_irq_enable/disable 
functions to create the binding between a PCI device and an irq.

I haven't prototyped this yet, or even looked into it very closely, but 
it seems like a promising approach to avoid almost all interaction with 
the apic layer of the kernel.  xen_pci_irq_enable() would have to make 
its own calls acpi_pci_irq_lookup() to map pci_dev+pin -> gsi, so we 
would still need to make sure ACPI is up to that job.

> Xen's ioapic affinity management logic looks like it only works
> on sunny days if you don't stress it too hard.
Could you be a bit more specific?  Are you referring to problems that 
you've fixed in the kernel which are still present in Xen?

>    Of course the hard
> part Xen of driving the hardware Xen doesn't want to share.
>    

Yes; it has to handle everything relating to physical CPUs, as the 
kernel only has virtual CPUs.

> It looks like the only thing Xen gains by pushing out the work of
> setting the polarity and setting edge/level triggering is our database
> of motherboards which get those things wrong.
>    

Avoiding duplication of effort is a non-trivial benefit.

> So I expect the thing to do is factor out acpi_parse_ioapic,
> mp_register_ioapic so we can share information on borked BIOS's
> between the Xen dom0 port and otherwise push Xen pseudo apic handling
> off into it's strange little corner.

Yes, that's what I'll look into.

     J

