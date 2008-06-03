Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYFCPyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYFCPyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 11:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYFCPyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 11:54:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYFCPyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 11:54:13 -0400
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
From: Jon Masters <jcm@redhat.com>
To: Olaf Dabrunz <od@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Stefan Assmann <sassmann@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <12124107071847-git-send-email-od@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 11:52:01 -0400
Message-Id: <1212508321.22357.13.camel@londonpacket.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-06-02 at 14:45 +0200, Olaf Dabrunz wrote:

> These patches are against linux-2.6-tip, auto-x86-next.
> 
> When IRQ lines on secondary or higher IO-APICs are masked (as done by
> RT and others), many chipsets redirect IRQs on this line to the PIC, and
> thereby regularly to the first IO-APIC in the system. This causes
> spurious interrupts and can lead to disabled IRQ lines.
> 
> Disabling this "boot interrupt" (as it is mostly used to supply all
> IRQs to the legacy PIC during boot) is chipset-specific, and not
> possible for all chips. This patchset disables the boot interrupt on
> chipsets where this is possible and where we know how to do it.
> 
> When disabling the boot interrupt is not possible, the patches tell the
> IRQ code to always use the redirected interrupt line (on the first
> IO-APIC) instead of the "original" line on the secondary (tertiary ...)
> IO-APIC. The original line remains masked, and IRQs always appear on
> the boot interrupt line on the first IO-APIC instead.
> 
> Two new boot parameters control the quirks and are explained in the
> patches: nobootirqquirk,
> bootirqquirk=0x<vendor>,0x<device>,<quirk_variant>. "noapic" also sets
> nobootirqquirk.
> 
> All patches are co-authored by Stefan Assmann and Olaf Dabrunz. But
> according to Documentation/SubmittingPatches, the patch submission format
> allows only for one author.

I like the patch series, insomuch as the intention is good, and it does
away with the special PCI IRQ quirk patches some of us are carrying in
our vendor trees to temporarily workaround this problem[0]. Also, I'm
extremely impressed with the research that went into this, since I
repeatedly tried to get ahold of information about disabling this
unfortunate "feature" of various bridges, without much success.

However, I really am not happy with the implementation as it stands. The
duplicated table of quirks that doesn't really fit in with the existing
PCI quirks infrastructure, the weird naming of the kernel options, and
various other things that Thomas has already mentioned in his reply.
Therefore, I think this needs a bit more reworking before going in.

Thanks!

Jon.

[0] The real fix come when we move IRQ handling in RT to per-device
threads, as is the longer term intention. Then you can quiesse the
device immediately and not the mask/unmask cycle that fails here.


