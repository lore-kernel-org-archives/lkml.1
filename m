Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbYFDJtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbYFDJtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYFDJtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:49:23 -0400
Received: from mail.suse.de ([195.135.220.2]:49627 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYFDJtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:49:22 -0400
Message-ID: <4846651F.4070802@suse.de>
Date: Wed, 04 Jun 2008 11:49:19 +0200
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
References: <12124107071847-git-send-email-od@suse.de> <m1tzgauduu.fsf@frodo.ebiederm.org>
In-Reply-To: <m1tzgauduu.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman schrieb:
> Olaf Dabrunz <od@suse.de> writes:
> 
>> These patches are against linux-2.6-tip, auto-x86-next.
>>
>> When IRQ lines on secondary or higher IO-APICs are masked (as done by
>> RT and others), many chipsets redirect IRQs on this line to the PIC, and
>> thereby regularly to the first IO-APIC in the system. This causes
>> spurious interrupts and can lead to disabled IRQ lines.
> 
> Sounds like good problem tracking.
> 
>> Disabling this "boot interrupt" (as it is mostly used to supply all
>> IRQs to the legacy PIC during boot) is chipset-specific, and not
>> possible for all chips. This patchset disables the boot interrupt on
>> chipsets where this is possible and where we know how to do it.
> 
> I know to work around a similar issue we disable the interrupt inputs
> on the PIC.  Is that not enough?  In particular what is enabled and
> what is disabled when these interrupts are coming in.

On the chips (ICHx, ...) we saw, the interrupt lines on the PIC also go
to the first IO-APIC. So the boot interrupts go to both the PIC and the
first IO-APIC.

When running in APIC mode all PIC IRQs are disabled, except for the
timer maybe. Boot interrupts still arrive on the first IO-APIC and end
up as being counted as spurious interrupts.

>> When disabling the boot interrupt is not possible, the patches tell the
>> IRQ code to always use the redirected interrupt line (on the first
>> IO-APIC) instead of the "original" line on the secondary (tertiary ...)
>> IO-APIC. The original line remains masked, and IRQs always appear on
>> the boot interrupt line on the first IO-APIC instead.
> 
> In general we should not be disabling interrupts, especially in the
> mainline kernel.  Artificially increasing interrupt sharing just so
> you can be certain of disabling the interrupt line seems to be the
> wrong approach.
> 
> Much better would be to get everything off of the shared boot
> interrupt line, so you can disable that, if that is possible.
> 

The lines where the boot interrupts show up are usually hard wired to
the first IO-APIC. It might be possible to move devices that share these
lines to other interrupts but in many cases, especially on older ICHs,
this is not possible.

The wiring of the boot interrupts follows a fixed pattern on most
bridges and generates a PCI IRQ. This ends up on the ICH or equivalent,
where it either is hard-wired to IRQ 16 to 24, or can be routed to
some IRQ through a programmable mapping. An example for the mappings
on intel chips is in another mail in this thread.

> For the mainstream kernel I expect we can even teach the drivers
> not to call disable_irq.  As a function of last resort to deal
> with screaming irqs, disable_irq seems reasonable.  Using disable_irq
> on a regular basis appears to be asking for a trouble (as you have
> found).

We see these boot interrupts mainly in the RT kernels, which handle
interrupts in threads. To do this, they mask the IRQ until it has been
handled. The masking sets up the conditions on the chip so that boot
interrupts are generated.

When drivers call disable_irq, this is another possible cause for boot
interrupts. We agree that this should probably be fixed.

> As for the question about MSI.  Good MSI implementations have a mask
> bit so we should be able to disable those reliably.  For other MSI
> implementations we disable both the mask bit and the pci_intx
> capability.  So there should be no way for the irq to leave the
> device.  But it hardware is strange sometimes.
>
> That said have you tried clearing the PCI_COMMAND_INTX_DISABLE bit
> of the PCI_COMMAND register to mask the boot interrupts?  I expect
> that would work on quite a lot of modern hardware.

Some chips (6700PXH, ...) are not PCIe 2.x (IIR the version correctly)
compatible, and they do not support switching off INTx generation.
We tried this anyway for the 6700PXH and it did not work.

Stefan and Olaf

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail : sassmann@suse.de | GF: Markus Rex, HRB 16746 (AG Nuernberg)
