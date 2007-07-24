Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbXGXUOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbXGXUOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbXGXUO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:14:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58744 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837AbXGXUO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:14:26 -0400
Message-ID: <46A65D7D.6040409@garzik.org>
Date: Tue, 24 Jul 2007 16:13:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?ISO-8859-1?Q?S=E9bastie?= =?ISO-8859-1?Q?n_Dugu=E9?= 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <46A63BC3.3050208@garzik.org> <Pine.LNX.4.64N.0707241914060.17807@blysk.ds.pg.gda.pl> <200707241353.57458.bjorn.helgaas@hp.com>
In-Reply-To: <200707241353.57458.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Tuesday 24 July 2007 12:17:36 pm Maciej W. Rozycki wrote:
>> On Tue, 24 Jul 2007, Jeff Garzik wrote:
>>
>>> It seems clear from this report that we cannot, should not, trust BIOS for
>>> something (a) so simple and (b) that has been working for over a decade.
>>  And (c) something BIOS writers have never ever in their most unlikely 
>> imagination expected to be trusted for.
> 
> I don't think it's quite so clear-cut.  It is true that "poke at 0x3e8,
> and if it responds, assume it's a 16550 with IRQ 4" is simple.  But it
> doesn't always work.  Google for "irda setserial" and you'll find many
> cases where the serial driver's blind probe erroneously claims an IRDA
> device.  The SIR mode of IRDA devices is basically 16550-compatible,
> so this wouldn't be a big problem, except that the blind probe often
> assumes the wrong IRQ.  So users have to use setserial to fix up the
> incorrect assumptions made by the blind probe.
> 
> We haven't debugged the problem on Sebastien's machine yet.  I suspect
> we'll find that his serial port *is* described by ACPI, but that there's
> some little difference in the way Linux discovers those devices compared
> to how Windows does it.  If we figure out how to use ACPI more like
> Windows does, I think we'll fix several little issues, including the one
> on Sebastien's machine.

You have not fixed the double-probe problem either.  That should have 
been fixed before 7e92b4fc34 was even considered for upstream.


> We have a whole laundry list of minor issues because we either don't
> listen to the BIOS at all, or we use it differently than Windows does.

Getting [back] to this thread, I know that most versions of Windows poke 
the serial port directly.  It's pretty obvious when running Windows in 
an emulator.


> Here are a few off the top of my head:
> 
>   - IRDA drivers have platform-specific code to "preconfigure" (discover
>     and reprogram) bridges on the way to the IR device
>   - Hardware sensor drivers conflict with ACPI embedded controller
>     drivers, so every once in a while, they return bogus readings

Driver bug, completely unrelated to not "listen[ing] to the BIOS"


>   - PCMCIA devices grab resources already in use by a PNP device,
>     causing the PNP device to stop working

ditto


>   - Linux enumerates CPUs with the MADT; I think Windows uses the ACPI
>     namespace.  Sometimes there are multiple MADTs, and sometimes Linux
>     uses the wrong one.

Color me skeptical.  I think we would have bug reports if we were really 
getting this wrong a lot of the time.


> If we keep papering over these problems by ignoring what ACPI is trying
> to tell us, we're going to be adding machine-specific hacks forever.
> Of course, there are ACPI bugs.  But Windows does rely on ACPI, and
> Microsoft doesn't want to add those per-platform hacks any more than
> we do.  So we might as well try to take advantage of the ACPI testing
> they do.

You seem to be missing that ignoring BIOS is often a VERY GOOD thing, 
that has served us well many many times in the past.

	Jeff


