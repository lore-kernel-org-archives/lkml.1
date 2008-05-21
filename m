Return-Path: <linux-kernel-owner+w=401wt.eu-S1764727AbYEUCiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764727AbYEUCiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbYEUChz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:37:55 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61949 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752044AbYEUChy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:37:54 -0400
Date: Wed, 21 May 2008 03:37:27 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: gshan <gshan@alcatel-lucent.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: PIIX4 DMA Timeout
In-Reply-To: <48337608.7010000@alcatel-lucent.com>
Message-ID: <Pine.LNX.4.55.0805210309340.31790@cliff.in.clinika.pl>
References: <003b01c8ba7a$19f01500$01fca8c0@microsof60b8d6> 
 <Pine.LNX.4.55.0805201746130.31790@cliff.in.clinika.pl>
 <48337608.7010000@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, gshan wrote:

> Maciej, thank you very much for your reply. I don't think this was caused by
> interrupt routing. I added lots of "printk" before following output, and saw
> interrupts could be triggered correctly.

 As I wrote, that was a restriction that did not affect PIO operation.  
IIRC, you had to wire IDE interrupt lines to motherboard interrupt (MIRQ)  
lines of the south-bridge rather than regular IRQ14/15 lines and then
route them to IRQ14/15 inputs of the embedded slave 8259A core via some
internal interrupt routing register for DMA to work correctly.  PIO worked
just fine either way, because the interrupts were delivered to the CPU
after all, but some internal logic of the IDE adapter used them too in the
DMA mode and expected them on MIRQ lines.

 This is from memory -- I have the relevant datasheets somewhere, but you
could double-check it as well as cross-check with board documentation
yourself.  It may not apply to the PIIX4 specifically -- it may have only
been earlier south-bridges of the PIIX line, but I cannot remember for
sure.

> hdc: 195371568 sectors (100030 MB) w/7539KiB Cache, CHS=16383/255/63, UDMA(33)
> 
> LynxOS has been run successfully on this board, and we want port it to Linux recently.

 That does not mean anything here -- do you know for sure it uses DMA with
IDE?  I suppose Linux would run correctly if you configured the IDE driver
for PIO operation too.  Of course you do not want to make regular use of
IDE PIO modes unless you cannot spell performance; never mind additional
data protection in UDMA modes.

> I'm not sure which resource (I/O or Memory space) should be used for DMA operation because
> all memory resources haven't been set (the flag is 0x2xxxxxxx). So my question is DMA operation
> could succeed with I/O resource?

 The I/O BAR has been configured, though I have to admit the values set
may be problematic:

    ide0: BM-DMA at 0xd8000000-0xd8000007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xd8000008-0xd800000f, BIOS settings: hdc:pio, hdd:pio

Port I/O over PCI is generally not supported outside the low 64kB of
space, although it may work in some configurations.  Also here you need a
couple of ports in a range above 3GB as well as the usual ports in the
first 1kB implied by the PIIX4.  Given host bridges can usually only
allocate contiguous areas for I/O purposes you would need over 3GB of host
address space for port I/O.  That may be available in a 64-bit system, but
I would be suspicious.

 Linux's PCI subsystem can automatically assign address space to PCI port
and memory I/O resources reasonably if you ask it to do so.  You have to
tell it what host CPU address space is available for this purpose first
though.  You can get this information from configuration registers of the
host bridge.  Of course these registers have to be set in a sensible way
in the first place, which may not necessarily be the case.  This is the
area I would look into first.  Good luck!

  Maciej
