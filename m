Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYCYUaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYCYUaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYCYUao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:30:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbYCYUan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:30:43 -0400
Date: Tue, 25 Mar 2008 21:29:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
Message-ID: <20080325202954.GA22007@elte.hu>
References: <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325201125.GD15330@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> > Modprobing either ohci1394 or firewire_ohci seems to lock up the 
> > system.
> 
> that's weird. If you do the modprobe from a VGA console and do a 
> 'dmesg -n 8', do you get any ioremap printk shortly before the hard 
> lockup?

basically, old ioremap did this:

[  162.485605] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[  162.485695] ioremap: 00000000(00000800) => f8978000

the theory (fact?) was that the zero physical address there (the 
'00000000') was some 4GB+ address truncated down to 32-bits.

OTOH, before this system worked for you before, i start to suspect that 
ioremap is a red herring here and that it's the code that gets to that 
physical address (which is ioremap-ed) is at fault here.

the hard hang might be your southbridge totally dumbfounded by the host 
OS attempting to do an MMIO access to an above-4GB address?

so the question is - what physical address did that ioremap do in 2.6.24 
(which presumly had a working ohci1394, right?), and why did it change 
to something else in -git?

	Ingo
