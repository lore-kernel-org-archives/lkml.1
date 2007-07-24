Return-Path: <linux-kernel-owner+w=401wt.eu-S1763220AbXGXUGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763220AbXGXUGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932117AbXGXUE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:04:58 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:39295 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbXGXUEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:04:54 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Tue, 24 Jul 2007 13:53:57 -0600
User-Agent: KMail/1.9.6
Cc: Jeff Garzik <jeff@garzik.org>,
       =?iso-8859-1?q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <46A63BC3.3050208@garzik.org> <Pine.LNX.4.64N.0707241914060.17807@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0707241914060.17807@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241353.57458.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007 12:17:36 pm Maciej W. Rozycki wrote:
> On Tue, 24 Jul 2007, Jeff Garzik wrote:
> 
> > It seems clear from this report that we cannot, should not, trust BIOS for
> > something (a) so simple and (b) that has been working for over a decade.
> 
>  And (c) something BIOS writers have never ever in their most unlikely 
> imagination expected to be trusted for.

I don't think it's quite so clear-cut.  It is true that "poke at 0x3e8,
and if it responds, assume it's a 16550 with IRQ 4" is simple.  But it
doesn't always work.  Google for "irda setserial" and you'll find many
cases where the serial driver's blind probe erroneously claims an IRDA
device.  The SIR mode of IRDA devices is basically 16550-compatible,
so this wouldn't be a big problem, except that the blind probe often
assumes the wrong IRQ.  So users have to use setserial to fix up the
incorrect assumptions made by the blind probe.

We haven't debugged the problem on Sebastien's machine yet.  I suspect
we'll find that his serial port *is* described by ACPI, but that there's
some little difference in the way Linux discovers those devices compared
to how Windows does it.  If we figure out how to use ACPI more like
Windows does, I think we'll fix several little issues, including the one
on Sebastien's machine.

We have a whole laundry list of minor issues because we either don't
listen to the BIOS at all, or we use it differently than Windows does.
Here are a few off the top of my head:

  - IRDA drivers have platform-specific code to "preconfigure" (discover
    and reprogram) bridges on the way to the IR device
  - Hardware sensor drivers conflict with ACPI embedded controller
    drivers, so every once in a while, they return bogus readings
  - PCMCIA devices grab resources already in use by a PNP device,
    causing the PNP device to stop working
  - Linux enumerates CPUs with the MADT; I think Windows uses the ACPI
    namespace.  Sometimes there are multiple MADTs, and sometimes Linux
    uses the wrong one.

If we keep papering over these problems by ignoring what ACPI is trying
to tell us, we're going to be adding machine-specific hacks forever.
Of course, there are ACPI bugs.  But Windows does rely on ACPI, and
Microsoft doesn't want to add those per-platform hacks any more than
we do.  So we might as well try to take advantage of the ACPI testing
they do.

Bjorn

