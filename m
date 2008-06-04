Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbYFDLeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbYFDLeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYFDLeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:34:03 -0400
Received: from ns.suse.de ([195.135.220.2]:60923 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYFDLeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:34:01 -0400
Message-ID: <48467DA7.9030309@suse.de>
Date: Wed, 04 Jun 2008 13:33:59 +0200
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
References: <12124107071847-git-send-email-od@suse.de>	<m1tzgauduu.fsf@frodo.ebiederm.org> <4846651F.4070802@suse.de> <m1ve0pqy06.fsf@frodo.ebiederm.org>
In-Reply-To: <m1ve0pqy06.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman schrieb:
> Stefan Assmann <sassmann@suse.de> writes:
> 
>> On the chips (ICHx, ...) we saw, the interrupt lines on the PIC also go
>> to the first IO-APIC. So the boot interrupts go to both the PIC and the
>> first IO-APIC.
>>
>> When running in APIC mode all PIC IRQs are disabled, except for the
>> timer maybe. Boot interrupts still arrive on the first IO-APIC and end
>> up as being counted as spurious interrupts.
> 
> So the boot interrupt comes in on one of the legacy irq vectors on
> the first ioapic, but it is a native ioapic irq.
> 
> What is the reason why you don't simply disable the ioapic vector of
> the boot interrupt?  Do some devices not use anything else?

That's exactly the reason why disabling them is a bad idea, you end up
having devices fixed to IO-APIC pins that boot interrupts are routed to.

>> The lines where the boot interrupts show up are usually hard wired to
>> the first IO-APIC. It might be possible to move devices that share these
>> lines to other interrupts but in many cases, especially on older ICHs,
>> this is not possible.
> 
> Not what I was suggesting.
> 
> As I read the above.  It says:
> When you can not disable the boot interrupt you don't attempt to use
> the non-boot interrupts and use the boot interrupt for everything.
> 
> If that is what your patches implement I disagree with that approach
> for the mainstream kernel.

You're right, that behavior is more appropriate for RT, where we see
these boot interrupts because of the way interrupts are handled there.
We're rewriting the patches to use a parameter like pci=ioapicreroute to
trigger this only if the parameter is specified (for the mainstream
kernel).

>> The wiring of the boot interrupts follows a fixed pattern on most
>> bridges and generates a PCI IRQ. This ends up on the ICH or equivalent,
>> where it either is hard-wired to IRQ 16 to 24, or can be routed to
>> some IRQ through a programmable mapping. An example for the mappings
>> on intel chips is in another mail in this thread.
> 
> I will have to look.  I am familiar with the concept but I have
> not looked at any of these in detail for a while.
> 
>>> For the mainstream kernel I expect we can even teach the drivers
>>> not to call disable_irq.  As a function of last resort to deal
>>> with screaming irqs, disable_irq seems reasonable.  Using disable_irq
>>> on a regular basis appears to be asking for a trouble (as you have
>>> found).
>> We see these boot interrupts mainly in the RT kernels, which handle
>> interrupts in threads. To do this, they mask the IRQ until it has been
>> handled. The masking sets up the conditions on the chip so that boot
>> interrupts are generated.
> 
> Yes.  My point being that because we don't do that in the mainstream
> kernels we have more robust alternatives in the mainstream kernel.
> 
>> Some chips (6700PXH, ...) are not PCIe 2.x (IIR the version correctly)
>> compatible, and they do not support switching off INTx generation.
>> We tried this anyway for the 6700PXH and it did not work.
> 
> So much for that idea then.
> 
> Eric

  Stefan
-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail : sassmann@suse.de | GF: Markus Rex, HRB 16746 (AG Nuernberg)
