Return-Path: <linux-kernel-owner+w=401wt.eu-S933263AbYBCEvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbYBCEvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 23:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbYBCEu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 23:50:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46606 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341AbYBCEuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 23:50:55 -0500
Date: Sun, 3 Feb 2008 05:50:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Chris Rankin <rankincj@yahoo.com>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.24 refuses to boot - ATA problem?
Message-ID: <20080203045040.GA12160@elte.hu>
References: <745427.71265.qm@web52907.mail.re2.yahoo.com> <47A51AD7.3070102@garzik.org> <200802022243.13710.gene.heskett@gmail.com> <20080203044428.GA10139@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203044428.GA10139@elte.hu>
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

> > [   27.097095] ENABLING IO-APIC IRQs
> > [   27.097287] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> > [   27.107291] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> > [   27.107343] ...trying to set up timer (IRQ0) through the 8259A ...  failed.
> > [   27.107346] ...trying to set up timer as Virtual Wire IRQ... failed.
> > [   27.117353] ...trying to set up timer as ExtINT IRQ... works.
> > 
> > The last 4 lines above are not logged without that argument.  So my 
> > theory ATM is that this forced the kernel to initialize something in 
> > the boards registers that it does not initialize without that 
> > command, and that its going fubar as shown in the msg quoted above 
> > is a totally random thing, perhaps dependent on the phase of one of 
> > jupiters moons as to what state it powers up in.  And I got lucky, 
> > so far in that my single powerdown reset didn't trigger it again...  
> > And you _know_ what that knocking sound is by now. :)
> 
> that's weird. Could you try the hack below and _remove_ the 
> acpi_use_timer_override flag? The change should artificially cause the 
> above 4 lines to appear again, in all cases.
> 
> This would test the following aspects of your theory: is this unknown 
> side-effect of the the acpi_use_timer_override flag related to the 
> timer setup sequence in io_apic_32.c? If not, then the difference most 
> likely lies in the different ACPI setup sequence.

i tried that patch on a box here, and it produces similar 4 lines:

[    0.172141] ENABLING IO-APIC IRQs
[    0.175498] init IO_APIC IRQs
[    0.176059]  IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
[    0.187942] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.233859] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.236014] ...trying to set up timer (IRQ0) through the 8259A ...  failed.
[    0.236014] ...trying to set up timer as Virtual Wire IRQ... failed.
[    0.236014] ...trying to set up timer as ExtINT IRQ... works.
[    0.277879] Using local APIC timer interrupts.

but ... in all likelyhood it's some ACPI side-effects of the 
acpi_use_timer_override flag, not really this IO-APIC/timer-setup detail 
that matters.

	Ingo
