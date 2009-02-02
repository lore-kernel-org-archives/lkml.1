Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZBBVIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZBBVIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZBBVH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:07:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:46041 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZBBVH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:07:57 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Schwab <schwab@suse.de>
In-Reply-To: <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <1233568479.18767.86.camel@pasglop>
	 <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain>
	 <1233606805.18767.97.camel@pasglop>
	 <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 08:07:37 +1100
Message-Id: <1233608857.18767.113.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I suspect that we could possibly make ACPI happy by actually leaving 
> interrupts "enabled" in the suspend-late (and early-resume) paths, but 
> with all hardware interrupts actually turned off. But that's really just a 
> "let's fool people by turning off interrupts a different way" thing - it 
> in no way really changes any fundamental issues.

Well, it might be the right approach ... for the simple reason that ACPI
doesn't -really- need external interrupts off ... it's a side effect of
the interpreter using mutexes etc... 

So maybe indeed we should look into doing something like that, in fact,
I quite like it:

 * suspend:

    - suspend devices with IRQs on
    - suspend PICs (ie, mask all interrupts). the main kernel clock 
      source should be kept running tho
    - do the device suspend "late" thing involving ACPI etc..

 * resume:

     the other way around.

Do we still need a real suspend "late" with hard IRQs off in that
scenario ?

Granted, because we are still effectively scheduling etc... we might
have the driver being hit by requests etc... so the suspend_late in the
above setup loses the property of being shielded against that...

> Whether you use "disable_irq() over all interrupts" or "local_irq_save -> 
> local_irq_restore" really doesn't change anything. You cannot do this in a 
> single phase, because that means that you randomly disable interrupts too 
> early (or enable them too late) when drivers still _require_ them.

Well, sort-of. IE. local_irq_save() vs. disable_irq() has a relevant
difference in our context ... the ability to use mutexes, msleep, etc...
which may allow ACPI to operate.

I don't care about ACPI on powerpc, so I'm happy hooking the gating with
irqs off ... but the existing hook isn't in the right place imho.

> Quite frankly, I don't think the second one is workable. It may be the 
> optimal one in theory, but it's never worked for us in practice.

True, it's going to be a pain. However, I still think you're going to
be bitten somewhere if you whack config space back before you called
the appropriate ACPI magic to resume the device, but I may be wrong,
maybe nobody will ever implement really aggressive power management
in their AML ? :-)

Cheers,
Ben.


