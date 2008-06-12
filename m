Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYFLPtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYFLPtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYFLPsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:48:41 -0400
Received: from www.tglx.de ([62.245.132.106]:40316 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbYFLPsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:48:38 -0400
Date: Thu, 12 Jun 2008 17:48:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 0/6] AMD C1E aware idle support
In-Reply-To: <20080612142455.GC7763@alberich.amd.com>
Message-ID: <alpine.LFD.1.10.0806121737090.3193@apollo.tec.linutronix.de>
References: <20080610171639.551369443@linutronix.de> <20080612142455.GC7763@alberich.amd.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Andreas Herrmann wrote:
> On Thu, Jun 12, 2008 at 10:28:32AM -0000, Thomas Gleixner wrote:
> > ...
> > The following patch series implements a C1E aware idle function which
> > also covers the late C1E enablement (case #3):
> > ...
>
> Great work!

Thanks.

> >From a first glance and test it looks really good.
> Just about 10 wakeups from idle on a C1E enabled box here.
> 
> Will do some deeper review and more tests later.
> 
> > The patches work fine on systems which are not affected by the dreaded
> > ATI chipset timer wreckage. On those which have the problem, the box
> > needs help from the keyboard to continue working.
> 
> I am currently not aware of that timer wreckage problem.
> Are you referring to one of the HPET related bugzillas at Kernel Bug
> Tracker?

There might be related ones. Need to look.

> If not, do you have a pointer to more information regarding this?
> (Say, problem description and lspci -vxxx output for such a system.)

Usually those systems have the:

..MP-BIOS bug: 8254 timer not connected to IO-APIC

and the fixup machinery in current mainline is slightly insufficient.

The result on such a system is that with current mainline plus the C1E
idle changes (just do not apply the apic patch from the tarball),
those systems keep missing timer interrupts. I have not yet decoded
the root cause, but the patch which is finally fixing that is:

http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=7e3530cd98a0c6ab38f5898e855a5beffab26561

lspci output below.

Thanks,

	tglx
---

00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge
	Subsystem: Fujitsu Siemens Computers Unknown device 111d
	Flags: bus master, 66MHz, medium devsel, latency 64
	Memory at <ignored> (64-bit, non-prefetchable)
00: 02 10 10 79 06 00 20 22 00 00 00 06 00 40 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 e0
20: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 1d 11
30: 00 00 00 00 c4 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 42 20 05 00
50: 34 17 1d 11 00 00 00 00 00 00 00 00 00 00 00 00
60: 80 00 00 00 87 04 00 00 00 02 20 00 d8 d0 01 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 40 44 00 00 95 00 00 03 20 11 10 00 02 27 00 10
90: 00 00 00 38 40 c4 40 e3 00 c0 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 07 01 00 00 49 01 10 07
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 08 00 80 01 60 20 11 11 d0 00 00 00
d0: 25 05 65 00 02 00 00 00 00 00 00 00 00 00 00 00
e0: 10 00 00 00 01 30 03 80 7f 00 00 00 00 00 00 00
f0: 00 00 00 00 00 80 80 00 00 00 00 00 00 00 00 00

00:01.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal gfx) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: f8200000-f83fffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f7ffffff
	Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [b0] Subsystem: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal gfx)
	Kernel modules: shpchp
00: 02 10 12 79 07 00 30 02 00 00 04 06 00 40 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 40 91 91 20 02
20: 20 f8 30 f8 01 f0 f1 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 0c 00
40: 00 00 00 00 08 b0 03 a8 00 00 00 00 02 10 12 79
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 0d 00 00 00 02 10 12 79 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:06.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 2) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=07, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: f8400000-f84fffff
	Prefetchable memory behind bridge: 00000000f8000000-00000000f80fffff
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [b0] Subsystem: Fujitsu Siemens Computers Unknown device 111d
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp
00: 02 10 16 79 07 04 10 00 00 00 04 06 08 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 07 00 a1 a1 00 00
20: 40 f8 40 f8 01 f8 01 f8 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 04 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 03 c8 00 00 00 00 10 80 41 01 20 80 00 00
60: 1f 08 00 00 11 0c 10 03 42 00 11 30 e0 0c 30 00
70: c0 03 48 00 00 00 01 00 00 00 00 00 00 00 00 00
80: 05 b0 01 00 0c 30 e0 fe 49 41 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 0d b8 00 00 34 17 1d 11 08 00 03 a8 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 ff ff ff ff 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:07.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 3) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=08, subordinate=0d, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: f8500000-f85fffff
	Prefetchable memory behind bridge: 00000000f8100000-00000000f81fffff
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [b0] Subsystem: Fujitsu Siemens Computers Unknown device 111d
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp
00: 02 10 17 79 07 04 10 00 00 00 04 06 08 00 01 00
10: 00 00 00 00 00 00 00 00 00 08 0d 00 b1 b1 00 00
20: 50 f8 50 f8 11 f8 11 f8 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 04 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 03 c8 00 00 00 00 10 80 41 01 20 80 00 00
60: 1f 08 00 00 11 0c 10 04 42 00 11 30 80 0c 30 00
70: c0 03 48 00 00 00 01 00 00 00 00 00 00 00 00 00
80: 05 b0 01 00 0c 30 e0 fe 51 41 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 0d b8 00 00 34 17 1d 11 08 00 03 a8 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 ff ff ff ff 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA (prog-if 01 [AHCI 1.0])
	Subsystem: Fujitsu Siemens Computers Unknown device 10d1
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 22
	I/O ports at 8440 [size=8]
	I/O ports at 8434 [size=4]
	I/O ports at 8438 [size=8]
	I/O ports at 8430 [size=4]
	I/O ports at 8400 [size=16]
	Memory at f890a000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [60] Power Management version 2
	Kernel driver in use: ahci
	Kernel modules: ahci
00: 02 10 80 43 07 00 30 02 00 01 06 01 00 40 00 00
10: 41 84 00 00 35 84 00 00 39 84 00 00 31 84 00 00
20: 01 84 00 00 00 a0 90 f8 00 00 00 00 34 17 d1 10
30: 00 00 00 00 60 00 00 00 00 00 00 00 0b 01 00 00
40: 10 00 83 02 01 00 10 00 01 00 00 00 00 00 00 00
50: 05 00 84 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 00 22 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 12 00 10 00 0f 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 06 00 00 2c d6 01 b4 00 d6 01 b4 00
90: d6 01 b4 00 d6 01 b4 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 b8 00 00 00 00 00 00 00 b8 00 00
b0: 00 00 00 00 00 b8 00 00 00 00 00 00 00 b8 00 00
c0: 00 20 00 00 80 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0) (prog-if 10 [OHCI])
	Subsystem: Fujitsu Siemens Computers Unknown device 10d1
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
	Memory at f8904000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd
00: 02 10 87 43 17 00 a0 02 00 10 03 0c 08 40 80 00
10: 00 40 90 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 d1 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 00
40: 80 1f 00 00 0a 84 b7 18 07 35 00 00 00 00 00 00
50: 00 9c 00 00 00 00 00 00 ff ff ff ff ff 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 ff 00 00 80 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1) (prog-if 10 [OHCI])
	Subsystem: Fujitsu Siemens Computers Unknown device 10d1
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
	Memory at f8905000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd
00: 02 10 88 43 17 00 a0 02 00 10 03 0c 08 40 00 00
10: 00 50 90 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 d1 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2) (prog-if 10 [OHCI])
	Subsystem: Fujitsu Siemens Computers Unknown device 10d1
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 18
	Memory at f8906000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd
00: 02 10 89 43 17 00 a0 02 00 10 03 0c 08 40 00 00
10: 00 60 90 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 d1 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3) (prog-if 10 [OHCI])
	Subsystem: Fujitsu Siemens Computers Unknown device 10d1
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
	Memory at f8907000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd
00: 02 10 8a 43 17 00 a0 02 00 10 03 0c 08 40 00 00
10: 00 70 90 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 d1 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4) (prog-if 10 [OHCI])
	Subsystem: Fujitsu Siemens Computers Unknown device 10d1
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 18
	Memory at f8908000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd
00: 02 10 8b 43 17 00 a0 02 00 10 03 0c 08 40 00 00
10: 00 80 90 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 d1 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI) (prog-if 20 [EHCI])
	Subsystem: ATI Technologies Inc SB600 USB Controller (EHCI)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
	Memory at f890a400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd
00: 02 10 86 43 17 00 b0 02 00 20 03 0c 10 40 00 00
10: 00 a4 90 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 86 43
30: 00 00 00 00 c0 00 00 00 00 00 00 00 0b 04 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 40 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 01 00 00 08 80 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 e4 02 7e 00 00 40 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 0a 00 e0 20 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
	Subsystem: Fujitsu Siemens Computers Unknown device 10d1
	Flags: 66MHz, medium devsel
	I/O ports at 8410 [size=16]
	Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: piix4_smbus
	Kernel modules: i2c-piix4
00: 02 10 85 43 03 00 30 02 14 00 05 0c 00 00 80 00
10: 11 84 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 d1 10
30: 00 00 00 00 b0 00 00 00 00 00 00 00 00 00 00 00
40: d4 bb 00 04 00 00 00 00 0f ff 00 00 00 00 00 00
50: f0 0d 00 00 00 00 f0 08 51 80 03 f3 00 00 00 00
60: 01 00 24 00 bf fd 9e 8f 3f 90 00 00 20 00 00 00
70: 00 01 00 00 08 00 c0 fe ff 6f 00 00 00 00 5a 0f
80: 4a 0a 84 7c 00 00 00 00 00 00 00 00 8c 00 00 80
90: 11 84 00 00 ff de f7 00 00 00 00 00 00 00 00 00
a0: 00 00 ff ff ff ff e0 08 14 28 1c 00 16 79 20 18
b0: 08 00 02 a8 00 00 00 00 00 00 00 00 f0 0f 08 1a
c0: 7d db b6 ed 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: d8 0c 00 00 7f 08 00 00 00 00 00 00 02 00 30 01

00:14.1 IDE interface: ATI Technologies Inc SB600 IDE (prog-if 8a [Master SecP PriP])
	Subsystem: Fujitsu Siemens Computers Unknown device 10d1
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 8420 [size=16]
	Kernel driver in use: pata_atiixp
	Kernel modules: ata_generic, pata_acpi, pata_atiixp
00: 02 10 8c 43 15 00 20 02 00 8a 01 01 00 40 00 00
10: f1 01 00 00 f5 03 00 00 01 00 00 00 01 00 00 00
20: 21 84 00 00 00 00 00 00 00 00 00 00 34 17 d1 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 01 00 00
40: 5d 5d 00 00 ff ff 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 40 00 10 2c 01 07 01 00 00 00 ff 03 00 00
70: 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
	Subsystem: Fujitsu Siemens Computers Unknown device 111e
	Flags: bus master, slow devsel, latency 64, IRQ 16
	Memory at f8900000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel
00: 02 10 83 43 06 00 10 04 00 00 03 04 08 40 00 00
10: 04 00 90 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 1e 11
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 00 00 00
40: 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
	Subsystem: Fujitsu Siemens Computers Unknown device 10d1
	Flags: bus master, 66MHz, medium devsel, latency 0
00: 02 10 8d 43 0f 00 20 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 d1 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 04 00 00 00 f7 ff 43 ff 03 ff 42 01 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 06 0e 00 0f 00 f0 ff ff ff
70: 67 45 23 01 00 00 00 00 01 00 00 00 05 00 00 00
80: 08 00 03 a8 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 01 [Subtractive decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=0e, subordinate=13, sec-latency=64
	Memory behind bridge: f8600000-f86fffff
00: 02 10 84 43 07 00 a0 02 00 01 04 06 00 40 81 00
10: 00 00 00 00 00 00 00 00 00 0e 13 40 f0 00 80 22
20: 60 f8 60 f8 f0 ff 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00
40: 26 00 3c ff 00 00 00 00 0c 01 3f d1 00 00 00 00
50: 01 00 00 00 08 00 03 a8 00 00 00 00 85 00 ff ff
60: ca 0e 17 00 ba 18 10 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 02 06
e0: 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
60: 00 00 01 00 e4 00 00 00 20 c8 2f 0f 3c 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 00 01 21 20 a8 11 11 22 05 35 80 02 00 00 00
90: 78 01 70 01 00 00 ff 00 07 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 3f 00 00 00 00 00 01 00 00 00
50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00
60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00
70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00
80: 03 30 f8 00 00 ff ff 00 03 20 f8 00 80 2f f8 00
90: 03 00 f8 00 00 1f f8 00 03 00 f0 00 80 ff f7 00
a0: 03 0a 00 00 00 0b 00 00 03 00 f0 00 00 ff ef 00
b0: 03 00 e0 00 80 ff ef 00 03 00 40 00 00 ff df 00
c0: 00 00 00 00 00 00 00 00 13 10 00 00 00 f0 0f 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 ff 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 00 00 01 01 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: e0 3e 38 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 46 00 00 00 00 00 00 00
80: 01 00 00 00 00 00 00 00 24 c2 aa 5d 20 13 12 00
90: 20 0c 01 00 5a 80 00 a7 39 00 00 80 00 00 00 00
a0: ef 06 00 5d 00 00 00 00 00 00 00 00 00 00 00 00
b0: 7e b6 b5 e7 7e 00 00 00 9b 7e 1a 3f d8 3f 72 78
c0: 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 44 e0 dc e1 12 11 91 6f 21 17 c1 06 88 24 80 87
e0: a4 e2 76 81 2b 3a b7 af 60 4b 5a 04 0a 70 c9 ad
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp
	Kernel modules: k8temp
00: 22 10 03 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00
40: ff 3b 04 00 40 00 10 0a 00 00 00 00 00 00 00 00
50: 00 00 00 05 08 00 00 00 00 00 00 00 80 01 00 94
60: 88 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 01 32 51 21 40 30 50 00 2a 00 08 1b 21 00 00
80: 31 37 07 33 13 31 13 31 00 00 00 00 00 00 00 00
90: 00 00 00 00 26 56 00 00 50 01 d2 85 00 00 00 00
a0: 9e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 01 a7 0d 00 00 00 00 09 25 26 26 00
e0: 00 00 00 00 24 0e 4f 00 01 17 00 00 00 00 00 00
f0: 0f 00 10 00 00 00 00 00 00 00 00 00 82 0f 04 00

01:05.0 VGA compatible controller: ATI Technologies Inc RS690M [Radeon X1200 Series] (prog-if 00 [VGA controller])
	Subsystem: Fujitsu Siemens Computers Unknown device 111d
	Flags: bus master, fast devsel, latency 64, IRQ 10
	Memory at f0000000 (64-bit, prefetchable) [size=128M]
	Memory at f8300000 (64-bit, non-prefetchable) [size=64K]
	I/O ports at 9000 [size=256]
	Memory at f8200000 (32-bit, non-prefetchable) [size=1M]
	Capabilities: [50] Power Management version 2
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
00: 02 10 1f 79 07 00 10 00 00 00 00 03 08 40 80 00
10: 0c 00 00 f0 00 00 00 00 04 00 30 f8 00 00 00 00
20: 01 90 00 00 00 00 20 f8 00 00 00 00 34 17 1d 11
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 1d 11
50: 01 80 02 06 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:05.2 Audio device: ATI Technologies Inc Radeon X1200 Series Audio Controller
	Subsystem: ATI Technologies Inc Radeon X1200 Series Audio Controller
	Flags: bus master, fast devsel, latency 64, IRQ 17
	Memory at f8310000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel
00: 02 10 19 79 06 00 18 00 00 00 03 04 08 40 00 00
10: 04 00 31 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 19 79
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 19 79
50: 01 60 02 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: Fujitsu Siemens Computers Unknown device 111d
	Flags: bus master, fast devsel, latency 0, IRQ 2301
	I/O ports at a000 [size=256]
	Memory at f8400000 (64-bit, non-prefetchable) [size=4K]
	Memory at f8000000 (64-bit, prefetchable) [size=64K]
	[virtual] Expansion ROM at f8020000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
	Capabilities: [70] Express Endpoint, MSI 01
	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
	Capabilities: [d0] Vital Product Data <?>
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 81-68-10-ec-00-00-00-00
	Kernel driver in use: r8169
	Kernel modules: r8169
00: ec 10 68 81 07 04 10 00 02 00 00 02 10 00 00 00
10: 01 a0 00 00 00 00 00 00 04 00 40 f8 00 00 00 00
20: 0c 00 00 f8 00 00 00 00 00 00 00 00 34 17 1d 11
30: 00 00 00 00 40 00 00 00 00 00 00 00 05 01 00 00
40: 01 50 c3 ff 08 00 00 00 00 00 00 00 00 00 00 00
50: 05 70 81 00 0c 10 e0 fe 00 00 00 00 81 41 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 b0 01 02 c1 86 64 00 10 20 19 00 11 3c 07 00
80: 42 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 11 d0 01 00 04 00 00 00 04 08 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

08:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: Fujitsu Siemens Computers Unknown device 111d
	Flags: bus master, fast devsel, latency 0, IRQ 2300
	I/O ports at b000 [size=256]
	Memory at f8500000 (64-bit, non-prefetchable) [size=4K]
	Memory at f8100000 (64-bit, prefetchable) [size=64K]
	[virtual] Expansion ROM at f8120000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
	Capabilities: [70] Express Endpoint, MSI 01
	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
	Capabilities: [d0] Vital Product Data <?>
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 81-68-10-ec-00-00-00-00
	Kernel driver in use: r8169
	Kernel modules: r8169
00: ec 10 68 81 07 04 10 00 02 00 00 02 10 00 00 00
10: 01 b0 00 00 00 00 00 00 04 00 50 f8 00 00 00 00
20: 0c 00 10 f8 00 00 00 00 00 00 00 00 34 17 1d 11
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00
40: 01 50 c3 ff 08 00 00 00 00 00 00 00 00 00 00 00
50: 05 70 81 00 0c 30 e0 fe 00 00 00 00 89 41 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 b0 01 02 c1 86 64 00 10 20 19 00 11 3c 07 00
80: 42 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 11 d0 01 00 04 00 00 00 04 08 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0e:04.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 70) (prog-if 10 [OHCI])
	Subsystem: Agere Systems FW323
	Flags: bus master, fast Back2Back, medium devsel, latency 96, IRQ 23
	Memory at f8600000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci
00: c1 11 11 58 16 02 90 02 70 10 00 0c 08 60 00 00
10: 00 00 60 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 c1 11 11 58
30: 00 00 00 00 44 00 00 00 00 00 00 00 0a 01 0c 18
40: 00 00 00 00 01 00 02 7e 00 80 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

