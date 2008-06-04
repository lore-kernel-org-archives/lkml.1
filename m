Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYFDCls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYFDCls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYFDClk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:41:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56114 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbYFDClj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:41:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Olaf Dabrunz <od@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>, linux-kernel@vger.kernel.org
References: <12124107071847-git-send-email-od@suse.de>
Date: Tue, 03 Jun 2008 19:35:05 -0700
In-Reply-To: <12124107071847-git-send-email-od@suse.de> (Olaf Dabrunz's
	message of "Mon, 2 Jun 2008 14:45:00 +0200")
Message-ID: <m1tzgauduu.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Olaf Dabrunz <od@suse.de>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0740]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Dabrunz <od@suse.de> writes:

> These patches are against linux-2.6-tip, auto-x86-next.
>
> When IRQ lines on secondary or higher IO-APICs are masked (as done by
> RT and others), many chipsets redirect IRQs on this line to the PIC, and
> thereby regularly to the first IO-APIC in the system. This causes
> spurious interrupts and can lead to disabled IRQ lines.

Sounds like good problem tracking.

> Disabling this "boot interrupt" (as it is mostly used to supply all
> IRQs to the legacy PIC during boot) is chipset-specific, and not
> possible for all chips. This patchset disables the boot interrupt on
> chipsets where this is possible and where we know how to do it.

I know to work around a similar issue we disable the interrupt inputs
on the PIC.  Is that not enough?  In particular what is enabled and
what is disabled when these interrupts are coming in.

> When disabling the boot interrupt is not possible, the patches tell the
> IRQ code to always use the redirected interrupt line (on the first
> IO-APIC) instead of the "original" line on the secondary (tertiary ...)
> IO-APIC. The original line remains masked, and IRQs always appear on
> the boot interrupt line on the first IO-APIC instead.

In general we should not be disabling interrupts, especially in the
mainline kernel.  Artificially increasing interrupt sharing just so
you can be certain of disabling the interrupt line seems to be the
wrong approach.

Much better would be to get everything off of the shared boot
interrupt line, so you can disable that, if that is possible.

For the mainstream kernel I expect we can even teach the drivers
not to call disable_irq.  As a function of last resort to deal
with screaming irqs, disable_irq seems reasonable.  Using disable_irq
on a regular basis appears to be asking for a trouble (as you have
found).

As for the question about MSI.  Good MSI implementations have a mask
bit so we should be able to disable those reliably.  For other MSI
implementations we disable both the mask bit and the pci_intx
capability.  So there should be no way for the irq to leave the
device.  But it hardware is strange sometimes.

That said have you tried clearing the PCI_COMMAND_INTX_DISABLE bit
of the PCI_COMMAND register to mask the boot interrupts?  I expect
that would work on quite a lot of modern hardware.

Eric
