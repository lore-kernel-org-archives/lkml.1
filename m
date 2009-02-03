Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZBCUFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZBCUFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZBCUFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:05:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59405 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZBCUF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:05:29 -0500
Date: Tue, 3 Feb 2009 21:04:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Barnes <jesse.barnes@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
	standard config registers of all devices early)
Message-ID: <20090203200459.GA1293@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain> <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain> <20090203191334.GA2797@elte.hu> <alpine.LFD.2.00.0902031120080.3247@localhost.localdomain> <20090203195304.GA31049@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203195304.GA31049@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  - the screaming-irq observation i had - do you consider that valid?:
> 
>    >> [ In theory this also solves screaming level-triggered irqs that 
>    >>   advertise themselves as edge-triggered [due to firmware/BIOS bug - 
>    >>   these do happen] and then keep spamming the system. ]
> 
>    I wanted to have a pretty much interchangeable flow method between edge 
>    and level triggered - so that the BIOS cannot screw us by enumerating an 
>    irq as edge-triggered while it's level-triggered.
> 
>    Especially for legacy x86 irqs in the low <16 range the trigger mode can 
>    be influenced by chipset settings and might not always be what we think 
>    it is.

For apic and MSI based methods that's not a big issue: the trigger mode is 
explicitly set by us, so if there's a mismatch it's a kernel bug.

And even for legacy ISA i8259a.c it should be fine after all, as we 
initialize it via:

        set_irq_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,

Which is a screaming-safe sequence. (and the x86 i8259 PIC does not lose 
edges.)

That still leaves other architectures ... but i think the argument is a lot 
weaker than i thought it to be.

Could you send a Signed-off-by so that i can queue it up and test it a bit? 
If it does not blow up on x86 in practice then we should be fine, and it 
avoids the MSI ->mask() stupidity as well.

	Ingo
