Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbXGMDrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbXGMDrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763146AbXGMDrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:47:21 -0400
Received: from smtp110.sbc.mail.re2.yahoo.com ([68.142.229.95]:47352 "HELO
	smtp110.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759396AbXGMDrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:47:19 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 23:47:19 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IzqSXnqSwSsk0SRJyT8Ay4l3thQUDuQKDe/Y8W5+FJ5G2qYmIUCbn6v8t/aXRPS+me3rL5a+tSmjvTQsORmmLpYhGp89kMwg0v5J9mi0LDGoWkh25dbyPrxkLgHrsemMgQH3YD8c+Fl0nomRfvqIFzmfwM320Y/0TeMQO7+Grb4=  ;
X-YMail-OSG: rnzBT9EVM1lZUtZCVmikxtqFXMIZMLmrZsUtWscwz9jSrcD1tBDixkWEqmJAdEf5gwx.Y5019osxCO0yLC0N0gvaxCQ5tOLIL6nFKHDHDUnCwK34nJaFlfRF3Hn.Z.GHaSDQDo1oX3WO0O296Qq.f6rsUQ--
From: David Brownell <david-b@pacbell.net>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: PROBLEM: kernel hang in ohci init
Date: Thu, 12 Jul 2007 20:40:36 -0700
User-Agent: KMail/1.9.6
Cc: "Timo Lindemann" <tlindemann@arcor.de>, linux-kernel@vger.kernel.org
References: <4695EC25.6050003@arcor.de> <a781481a0707122015q48fd8a06m5d0e54b109708757@mail.gmail.com>
In-Reply-To: <a781481a0707122015q48fd8a06m5d0e54b109708757@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707122040.36800.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007, Satyam Sharma wrote:
> 
> > [2.] The version 2.6.22 of the linux kernel hangs when initializing the
> > integrated ohci controller of the nvidia MCP51 chipset (pci device ids
> > vendor:product == 10de:26d). I have traced through various printks that
> > pci_init calls pci_fixup_device, later on in quirk_usb_ohci_handoff
> > (file linux/drivers/usb/host/pci-quirks.c) kernel freezes in this
> > section:

Note that hangs in that file almost always mean "your BIOS is goofy".
Hunt for BIOS settings related to USB, and change them.  As a rule, if
you tell your BIOS to ignore USB devices (mostly keyboards and disks),
it will have even less of an excuse to break like that.


> > ...
> > if (control & OHCI_CTRL_IR) {
> >         int wait_time = 500;
> >         writel(OHCI_INTR_OC, base + OHCI_INTRENABLE);
> >         writel(OHCI_ORC, base + OHCI_CMDSTATUS); // this never returns
> > ...
> > after this, kernel apparently goes into busy waiting (fans gradually
> > turn louder) and hangs indefinitely. I have also made sure that writel
> > (in linux/include/asm/io.h) really is entered, but never returns.

Does the current kernel.org GIT tree do the same thing?  A bunch
of USB patches were recently merged, including ISTR one in that
area ...


> > I can only guess that it might
> > have to do with the patch
> > "commit 4302a595cd9c6363b495460497ecbda49fa16858
> > Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Date:   Fri Dec 15 06:53:55 2006 +1100
> > USB: Rework the OHCI quirk mecanism as suggested by David
> > "
> > but I don't really have a clue, so this might be groundless suspicion.

Should be unrelated.  That patch related to how vendor-specific
implementation differences get detected and handled ... basically
just switching to a table-driven approach that can even handle
board-specific wiring braindamage, rather than the original scheme
which was just a big if/then/else looking only at chip vendors.

- Dave
