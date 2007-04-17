Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbXDQKOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbXDQKOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 06:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbXDQKOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 06:14:23 -0400
Received: from smtp-4.hut.fi ([130.233.228.94]:41648 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbXDQKOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 06:14:22 -0400
Date: Tue, 17 Apr 2007 13:13:54 +0300 (EEST)
From: Mikko Tiihonen <mikko.tiihonen@iki.fi>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hpet: Enable hidden HPET on NVidia motherboards
In-Reply-To: <20070416214042.GB25508@one.firstfloor.org>
Message-ID: <Pine.OSF.4.64.0704171058040.487506@kosh.hut.fi>
References: <1176708094.22969.7.camel@dual.local> <p734png6s1t.fsf@bingen.suse.de>
 <Pine.OSF.4.64.0704162337320.487506@kosh.hut.fi> <20070416214042.GB25508@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at putosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 16 Apr 2007, Andi Kleen wrote:

> On Tue, Apr 17, 2007 at 12:28:31AM +0300, Mikko Tiihonen wrote:
>> I actually was more worried that someone might complain that the pci
>> scanning is copy & paste code from end of the same file. I did try to use
>> the generic pci functions first but because they insist on enabling
>> interrupts they cannot be used this early. And this code needs to be run
>> before the timer initialization.
>
> Yes that's the issue. You're adding another PCI scanner copy'n'pasted
> from the caller of the function you're adding it to. See the problem?

I'll remove the duplicated scanning code in next patch version by creating a 
more general scanning code.

>> If you want I can submit a separate patch to move the ... not nice pci
>> scanning code to pci directory under some early_pci_scan(u32 *pci_ids,
>> hook) function. The same code was already cut&pasted in
>
> That is what early-quirks is anyways. But the way to scan for multple
> things is not to add anther recursive scan, but to just extend or
> change the main loop.

I don't think the quirk can avoid a recursive scan easily. It is supposed to 
be only run if the first scan finds nvidia chipset, does not detect acpi hpet 
and, as a last resort, tries to scan for the hpet manually to avoid enabling 
the original quirk. In more pictoresque way:

scan-for-chipsets
  -> nvidia chipset found
    -> does acpi hpet exist
      -> did manual_hpet_quirk fail (new)
        -> enable acpi_skip_timer_override quirk

It could be done in one scanning loop provided that it is quaranteed that the 
nvidia chipset is always before the the hpet quirk chip in pci hierarchy. Then 
the nvidia quirk needs to be split to two parts, of which the last part is run 
after all other quirks and to check if hpet quirk was ever activated.

scan-for-pci-ids
  -> nvidia chipset id found
    -> does acpi hpet exist
       -> possibly_enable_acpi_skip_timer_override = 1
  -> nvidia pci-id matching hpet chip found
     -> if possibly_enable_acpi_skip_timer_override
        -> did manual_hpet_quirk work
           -> possibly_enable_acpi_skip_timer_override = 0
if possibly_enable_acpi_skip_timer_override
  -> enable acpi_skip_timer_override quirk

But I really do think that overall the first solution is better, even if it 
does a recursive scan. Assuming of course that stupid code duplication is 
removed.

-Mikko
