Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331Ab0A0RjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0A0RjC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:39:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127Ab0A0RjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:39:01 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:41922 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0A0RjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:39:00 -0500
Date: Wed, 27 Jan 2010 12:38:50 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Leigh Porter <leigh@leighporter.org>, linux-geode@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: MFGPT in 2.6.33-rc5
Message-ID: <20100127123850.129020d3@mycelium.queued.net>
In-Reply-To: <4B605410.3030409@LiPPERTEmbedded.de>
References: <4B5DC7EF.5060609@leighporter.org>
	<4B5EE78F.8030705@LiPPERTEmbedded.de>
	<4B5F01E3.2090006@leighporter.org>
	<4B603383.1090807@LiPPERTEmbedded.de>
	<4B604324.6030806@leighporter.org>
	<4B605410.3030409@LiPPERTEmbedded.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 15:56:16 +0100
Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:

> A bit of background: The _real_ base address for the MFGPT hardware
> is set with the MSR, but this is very Geode-proprietary. So the BIOS
> contains VSA (Virtual System Architecture) code to implement a
> _virtual_ PCI device. This means the BIOS simulates a standard PCI
> device solely in software as a front-end for the MFGPT hardware to
> make it look like a 'normal' device which can be accessed with normal
> PCI drivers.
> 
> Well, this PCI device's configuration should of course always mirror
> the real state of the hardware, i.e. if someone changes the MSR, the
> PCI header should reflect that change, and vice versa.
> 
> > [    0.090015] pci 0000:00:14.0: address space collision: [io
> > 0x6200-0x63ff] already in use
> ....
> > [    0.202033] pci 0000:00:14.0: BAR 2: set to [io  0x1000-0x11ff]
> > (PCI address [0x1000-0x11ff]
> ....
> > root@doulos:/home/leigh# ./mfgpt
> > 6200
> 
> Now it looks like originally both MSR and PCI say the adress is 6200.
> But Linux detects a conflict on boot and moves it to 1000 by changing
> the PCI config. At this point the BIOS should copy the new address to
> the backing MSR i.e. to the real hardware. But this it fails to do.
> And later the cs5535-mfgpt uses the address from PCI (=1000) to look
> for the MFGPTs, but they're not there - they're are still at 6200.

At least on another net5501 board, BAR0 appears to have an 8k size.
This is pretty clearly wrong, and is why there are space conflicts w/
the other BARs (consuming 0x6000 through 0x7fff, while BAR1 and BAR2
are in the 0x6100/0x6200 range).

 	Region 0: I/O ports at 6000 [size=8K]
 



> >>> Copyright (C) 2000-2007 Soekris Engineering."
> > Yup, I am about to call them. ...
> 
> Hope they fix it. But this will not be the only BIOS with this bug,
> that's why we have to revert the cs5535-mfgpt driver to read the MSR
> directly again.
> 


Indeed, thanks for the report.  This is the second email I've gotten in
the past week about net5501 bios being broken w/ the new mfgpt
stuff.  :(

CC'ing lkml to ensure others see it.  I'll write and test a patch
sometime this week.

