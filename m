Return-Path: <linux-kernel-owner+w=401wt.eu-S965443AbXA3IDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965443AbXA3IDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965444AbXA3IDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:03:09 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43957 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965443AbXA3IDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:03:06 -0500
Message-ID: <45BEFBB2.8090402@garzik.org>
Date: Tue, 30 Jan 2007 03:02:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
References: <1170109401.29240.49.camel@localhost.localdomain> <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org> <20070129144055.151cfe52@freekitty> <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org> <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <20070129161626.33277eb1@freekitty> <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org> <20070130065457.GA23390@elte.hu> <45BEF61F.7000400@garzik.org> <20070130075325.GA591@elte.hu>
In-Reply-To: <20070130075325.GA591@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> btw., it would be great if you could help us here: could you perhaps, 
> from a past example, outline a specific case of such an ATA/USB IRQ 
> storm and how it occured (precisely) - and what the fix was? I'd like to 
> analyze a specific case to make sure the genirq layer recovers from such 
> cases more gracefully. In general, i think the IRQ subsystem needs to 
> become more failure-resilient and needs to become more auto-learning 
> (and these two dont stand in the way of good performance). This problem 
> of shared IRQs will be with us for at least another 10 years, if not 
> more. (for example ISA is /still/ not dead everywhere and it was already 
> legacy technology 15 years ago when Linux was started.)


Easy to name an example, as they are pretty generic.  When sharing irqs 
-- usually ATA is configured to PCI native (IO-APIC-fasteoi) -- any 
interrupt storm causes the other devices sharing that irq to crap 
themselves (kernel turns off irq, suggests irqpoll, etc.)

ATA is unfortunately easier to cause interrupt storms than most because 
the standard PCI IDE definition has __no__ possible way to indicate 
certain interrupt conditions are pending.  You have to /know/ that you 
are expecting an interrupt, which causes problems if the hardware 
decides to send the interrupt early or late, rather than when its 
expected.  Most modern hardware has a read/write/clear interrupt status 
  register that gives you an immediate summary of the pending interrupt 
conditions, and an easy way to ack the pending events.  ATA does not 
have any such capability.

That said, stuff like AHCI or sata_sil or sata_sil24 do have modern 
designs with the expected interrupt status register(s), so they do not 
suffer from the problems suffered by the more legacy-like hardware 
(ata_piix, sata_via, pata_*)

	Jeff


