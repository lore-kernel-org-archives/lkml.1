Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbXLKQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbXLKQ7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbXLKQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:59:13 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:50461 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbXLKQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:59:12 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.165
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19OnUUD8lMqz8tF5ZQ74Cph
Message-ID: <475EC1C0.2040000@reed.com>
Date: Tue, 11 Dec 2007 11:58:40 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Paul Rolland <rol@as2917.net>, David Newall <david@davidnewall.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<20071211143224.15900995@tux.DEF.witbe.net>	<475E9B9B.2050709@keyaccess.nl>	<475EACB8.7080608@keyaccess.nl> <20071211163706.2dc82275@tux.DEF.witbe.net> <475EB263.2050405@keyaccess.nl>
In-Reply-To: <475EB263.2050405@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the person who started this thread, I'm still puzzled by two things:

1) is there anyone out there who wrote one of these drivers (most listed 
below, from a list of those I needed to patch to eliminate refs to _b 
calls) or arch specific code (also listed below), who might know why the 
_p macros are actually needed (for any platform)?

Note that many of the devices are not on the ISA/LPC bus now, even if 
they were, and the vga has never needed a bus-level pause since the 
original IBM PC existed. (it did need a sync with retrace, but that's 
another story).

2) Why are opterons and so forth so slow on out's to x80 as the 
measurements show?   That seems to me like there is a hidden bus timeout 
going on.   I'm still trying to figure out what is happening on my 
machine which hangs when not in legacy mode (i.e. in ACPI mode) after a 
lot of out's to x80.  Perhaps the bus timeout handling is the issue.

I do remind all that 0x80 is a BIOS-specific standard, and is per BIOS - 
other ports have been used in the history of the IBM PC family by some 
vendors, and some machines have used it for DMA port mapping!!  And 
Windows XP does NOT use it at all.  Therefore it may not be supported by 
vendors, and may in fact be used for other purposes, since it can if the 
BIOS doesn't use it.

I have a simple patch that fixes my primary concern - just change the 
CMOS_READ and CMOS_WRITE, 64-bit versions of I/O and bootcode vga 
accesses (first group below) to use the straight inb and outb code.

I may submit it so that the many others who share my pain will be made 
happy - at least on modern _64 x86 machines those instructions don't 
need the _p feature.  The rest of the drivers and code are just lurking 
disasters, which I hope can be resolved somehow by the community 
figuring out what the timing delays were put there for...
-------------
arch/x86/boot/compressed/misc_64.c
arch/x86/kernel/i8259_64.c
arch/x86/pci/irq.c
include/asm/floppy.h
include/asm/io_64.h
include/asm/mc146818rtc_64.h
include/asm/vga.h
include/video/vga.h
drivers/video/console/vgacon.c
drivers/video/vesafb.c
drivers/video/vga16fb.c

drivers/acpi/processor_idle.c
drivers/bluetooth/bluecard_cs.c
drivers/char/pc8736x_gpio.c
drivers/char/rocket_int.h
drivers/hwmon/abituguru.c
drivers/hwmon/abituguru3.c
drivers/hwmon/it87.c
drivers/hwmon/lm78.c
drivers/hwmon/pc87360.c
drivers/hwmon/sis5595.c
drivers/hwmon/smsc47b397.c
drivers/hwmon/smsc47m1.c
drivers/hwmon/via686a.c
drivers/hwmon/vt8231.c
drivers/hwmon/w83627ehf.c
drivers/hwmon/w83627hf.c
drivers/hwmon/w83781d.c
drivers/i2c/busses/i2c-amd756.c
drivers/i2c/busses/i2c-i801.c
drivers/i2c/busses/i2c-nforce2.c
drivers/i2c/busses/i2c-viapro.c
drivers/input/misc/pcspkr.c
drivers/isdn/hisax/elsa_ser.c
drivers/isdn/hisax/s0box.c
drivers/misc/sony-laptop.c
drivers/net/8390.h
drivers/net/de600.c
drivers/net/de600.h
drivers/net/irda/nsc-ircc.c
drivers/net/irda/w83977af_ir.c
drivers/net/pcmcia/axnet_cs.c
drivers/net/pcmcia/pcnet_cs.c
drivers/net/wireless/wl3501_cs.c
drivers/scsi/megaraid.c
drivers/scsi/megaraid.h
drivers/scsi/ppa.h
drivers/serial/8250.c
drivers/video/console/vgacon.c
drivers/video/vesafb.c
drivers/video/vga16fb.c
drivers/watchdog/pcwd_pci.c
drivers/watchdog/w83627hf_wdt.c
drivers/watchdog/w83697hf_wdt.c
drivers/watchdog/w83877f_wdt.c
drivers/watchdog/w83977f_wdt.c
drivers/watchdog/wdt_pci.c

