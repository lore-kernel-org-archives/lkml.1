Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXLKRjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXLKRjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbXLKRj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:39:28 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55387 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752434AbXLKRj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:39:27 -0500
Date: Tue, 11 Dec 2007 17:32:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071211173231.2b87a81f@the-village.bc.nu>
In-Reply-To: <475EC1C0.2040000@reed.com>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071209125458.GB4381@ucw.cz>
	<20071209165908.GA15910@one.firstfloor.org>
	<20071209212513.GC24284@elf.ucw.cz>
	<475CBDD7.5050602@keyaccess.nl>
	<m3bq8y23de.fsf@maximus.localdomain>
	<475DE37F.20706@davidnewall.com>
	<475DE6F4.80702@zytor.com>
	<475DEB23.1000304@davidnewall.com>
	<20071211084059.3d03e11d@tux.DEF.witbe.net>
	<475E5D4B.8020101@keyaccess.nl>
	<475E7DC2.4060509@davidnewall.com>
	<475E8D91.20201@keyaccess.nl>
	<20071211143224.15900995@tux.DEF.witbe.net>
	<475E9B9B.2050709@keyaccess.nl>
	<475EACB8.7080608@keyaccess.nl>
	<20071211163706.2dc82275@tux.DEF.witbe.net>
	<475EB263.2050405@keyaccess.nl>
	<475EC1C0.2040000@reed.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> below, from a list of those I needed to patch to eliminate refs to _b 
> calls) or arch specific code (also listed below), who might know why the 
> _p macros are actually needed (for any platform)?

Because the controllers were historically slower than the CPU and thus
clocked at half bus speed. Various chipsets simply shrank the logic
without fixing this.

> Note that many of the devices are not on the ISA/LPC bus now, even if 
> they were, and the vga has never needed a bus-level pause since the 
> original IBM PC existed. (it did need a sync with retrace, but that's 
> another story).

Sync with retrace is MDA memory updates.

The vga driver is somewhat misnamed. In console mode we handle everything
back to MDA/HGA and some HGA adapters do need delays.

> 2) Why are opterons and so forth so slow on out's to x80 as the 
> measurements show?   That seems to me like there is a hidden bus timeout 

Because the LPC bus cycles are run at ISA speed. 

> I do remind all that 0x80 is a BIOS-specific standard, and is per BIOS - 
> other ports have been used in the history of the IBM PC family by some 
> vendors, and some machines have used it for DMA port mapping!!  And 

All do -thats why it is suitable.

> Windows XP does NOT use it at all.  Therefore it may not be supported by 

Older Windows does. Don't know about XP although DOS apps in XP will but
they may virtualise the port.

> I have a simple patch that fixes my primary concern - just change the 
> CMOS_READ and CMOS_WRITE, 64-bit versions of I/O and bootcode vga 
> accesses (first group below) to use the straight inb and outb code.

Which requires care. Have you verified all the main chipset vendors ?

> I may submit it so that the many others who share my pain will be made 

All .. none of them ?

I can do some of these off the top of my head

> drivers/net/8390.h

Needed for some 8390 devices on ISA bus

> drivers/net/de600.c
> drivers/net/de600.h

Uses the parallel port which isnt guaranteed to be full ISA speed.

> drivers/scsi/ppa.h

Parallel port

> drivers/serial/8250.c

Some PC's need delays for certain ops.

> drivers/watchdog/wdt_pci.c

That one is a mistake I believe, I'll dig out the docs.

