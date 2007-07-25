Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXGYQHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXGYQHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761661AbXGYQH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:07:26 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:39801 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760614AbXGYQHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:07:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Wed, 25 Jul 2007 10:06:42 -0600
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?iso-8859-1?q?S=C3=A9bastien_Dugu=C3=A9?= 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <p73ir88sax1.fsf@bingen.suse.de> <20070725164808.41404dc7@the-village.bc.nu>
In-Reply-To: <20070725164808.41404dc7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251006.42948.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 09:48:08 am Alan Cox wrote:
> That isn't the problem with the IR stuff. In many cases the user wants
> the port to be showing up as a serial port for SIR usage. We need a clean
> automatic SIR/FIR switching for them. It has nothing to do with whether
> the ACPI data is trustworthy or not.

If we were starting fresh, I think the best way would be for the IR
driver to claim the whole PNP device, which typically has two I/O port
ranges, like this:

  00:03 SMCf010 SMC Fast Infrared Port
    state = active
        io 0x3e8-0x3ef
        io 0x100-0x10f
        irq 3
        dma 3

There could be an ioctl or equivalent to request SIR mode, and the
IR driver could use serial8250_register_port() when entering SIR
mode and serial8250_unregister_port() when leaving.

The IR driver would be the clear owner of the entire device.  Of course,
this still only works if we get rid of the 8250 blind probe for 0x3e8
or figure out some API for the IR driver to tell the 8250 driver to get
its mitts off.

Bjorn
