Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbXIUNxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbXIUNxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXIUNwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:52:53 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:49290 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbXIUNww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:52:52 -0400
Date: Fri, 21 Sep 2007 14:52:44 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Peter Fordham <peter.fordham@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: fpu IO port reservation (arch/i386)
In-Reply-To: <a71b7b480709210622l23481221pd09302a827b55eb@mail.gmail.com>
Message-ID: <Pine.LNX.4.64N.0709211440380.2724@blysk.ds.pg.gda.pl>
References: <a71b7b480709210622l23481221pd09302a827b55eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> Does anybody know why we reserve this range of IO ports for 'fpu'?
> AFAIK from all the IO maps I can find on the internet for various x86
> chipsets only 0x00f0 is actaully ever used.

 There are two ports used: 0xf0 is the busy latch reset and 0xf1 is the 
coprocessor reset.  They are legacy ports resulting from the interesting 
way the FPU has been wired by IBM in their PC design.  None of them is 
used by Linux for i486 and newer systems, which can support the FPU in its 
native configuration.

> ./arch/i386/kernel/setup.c
> 282 }, {
> 283         .name   = "fpu",
> 284         .start  = 0x00f0,
> 285         .end    = 0x00ff,
> 286         .flags  = IORESOURCE_BUSY | IORESOURCE_IO
> 287 } };

 The reason is most likely the definition of the address decoder for the 
chip-select for this range in the IBM PC -- like with all motherboard port 
I/O peripherals the smallest size of the chunk the decoder resolved to was 
16 bytes, with unused locations aliasing to defined ones.

> The reason I ask is that I've written a watchdog driver for a Nexcom
> MAX6600 server blade type device which has the watchdog control
> register at 0xF2. Currently request_region fails due to the fpu
> reservation.

 Reservations for some of the legacy ranges have been shrunk in the past; 
perhaps this one could too.  I hope you have a way to make sure not to 
interact badly with the FPU possibly being decoded there on other systems 
-- the original registers are write-only.

  Maciej
