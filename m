Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbYFDKuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbYFDKuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYFDKuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:50:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52109 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbYFDKuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:50:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stefan Assmann <sassmann@suse.de>
Cc: Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org
References: <12124107071847-git-send-email-od@suse.de>
	<m1tzgauduu.fsf@frodo.ebiederm.org> <4846651F.4070802@suse.de>
Date: Wed, 04 Jun 2008 03:45:45 -0700
In-Reply-To: <4846651F.4070802@suse.de> (Stefan Assmann's message of "Wed, 04
	Jun 2008 11:49:19 +0200")
Message-ID: <m1ve0pqy06.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stefan Assmann <sassmann@suse.de>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3084]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Assmann <sassmann@suse.de> writes:

> On the chips (ICHx, ...) we saw, the interrupt lines on the PIC also go
> to the first IO-APIC. So the boot interrupts go to both the PIC and the
> first IO-APIC.
>
> When running in APIC mode all PIC IRQs are disabled, except for the
> timer maybe. Boot interrupts still arrive on the first IO-APIC and end
> up as being counted as spurious interrupts.

So the boot interrupt comes in on one of the legacy irq vectors on
the first ioapic, but it is a native ioapic irq.

What is the reason why you don't simply disable the ioapic vector of
the boot interrupt?  Do some devices not use anything else?

> The lines where the boot interrupts show up are usually hard wired to
> the first IO-APIC. It might be possible to move devices that share these
> lines to other interrupts but in many cases, especially on older ICHs,
> this is not possible.

Not what I was suggesting.

As I read the above.  It says:
When you can not disable the boot interrupt you don't attempt to use
the non-boot interrupts and use the boot interrupt for everything.

If that is what your patches implement I disagree with that approach
for the mainstream kernel.

> The wiring of the boot interrupts follows a fixed pattern on most
> bridges and generates a PCI IRQ. This ends up on the ICH or equivalent,
> where it either is hard-wired to IRQ 16 to 24, or can be routed to
> some IRQ through a programmable mapping. An example for the mappings
> on intel chips is in another mail in this thread.

I will have to look.  I am familiar with the concept but I have
not looked at any of these in detail for a while.

>> For the mainstream kernel I expect we can even teach the drivers
>> not to call disable_irq.  As a function of last resort to deal
>> with screaming irqs, disable_irq seems reasonable.  Using disable_irq
>> on a regular basis appears to be asking for a trouble (as you have
>> found).
>
> We see these boot interrupts mainly in the RT kernels, which handle
> interrupts in threads. To do this, they mask the IRQ until it has been
> handled. The masking sets up the conditions on the chip so that boot
> interrupts are generated.

Yes.  My point being that because we don't do that in the mainstream
kernels we have more robust alternatives in the mainstream kernel.

> Some chips (6700PXH, ...) are not PCIe 2.x (IIR the version correctly)
> compatible, and they do not support switching off INTx generation.
> We tried this anyway for the 6700PXH and it did not work.

So much for that idea then.

Eric
