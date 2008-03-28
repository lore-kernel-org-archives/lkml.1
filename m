Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYC1TYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYC1TYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYC1TY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:24:27 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38443 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYC1TYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:24:25 -0400
Date: Fri, 28 Mar 2008 12:24:02 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
Message-ID: <20080328192402.GA6233@us.ibm.com>
References: <20080326180701.GA6249@us.ibm.com> <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org> <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org> <20080326205828.GA15225@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org> <20080326232922.GA15784@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261638350.2775@woody.linux-foundation.org> <alpine.LFD.1.00.0803271004380.2775@woody.linux-foundation.org> <20080327221851.GA9675@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327221851.GA9675@jurassic.park.msu.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 01:18:51AM +0300, Ivan Kokshaysky wrote:
> On Thu, Mar 27, 2008 at 10:12:10AM -0700, Linus Torvalds wrote:
> > Actually, before we go any further, there might be a less intrusive 
> > alternative: add just a couple of flags to the resource flags field (we 
> > still have something like 8 unused bits on 32-bit), and use those to 
> > implement a generic "resource_alignment()" routine.
> > 
> > Two flags would do it:
> > 
> >  - IORESOURCE_SIZEALIGN: size indicates alignment (regular PCI device 
> >    resources)
> > 
> >  - IORESOURCE_STARTALIGN: start field is alignment (PCI bus resources 
> >    during probing)
> 
> Sounds good to me. So here we go (completely untested, just for review).

Ivan, After adding a resource_alignment() prototype to
include/linux/ioport.h to get rid of
  drivers/pci/setup-res.c: In function `pci_assign_resource':
  drivers/pci/setup-res.c:141: error: implicit declaration of function `resource_alignment'
  make[2]: *** [drivers/pci/setup-res.o] Error 1
  make[1]: *** [drivers/pci] Error 2
I verified that pdev_sort_resources() longer encounters an Oops when
the ThinkPad is hot-added to the Dock II with the change that
exposed the problem (transparent bridge sizing removal) included.
So, although it is no suprise, I can at least say that the
pdev_sort_resources() bulletproofing has been test verified. :)

However, while doing the above I did see some "bogus alignment
of resource" messages both during boot with ThinkPad attached to
the Dock II and during hot-add of the ThinkPad to the Dock II.
The messages are associated with the cardbus bridges on the
docking station.  dmesg and lspci output collected after the
hot-add included below.

Note that the
  PCI: Cannot allocate resource region 7 of bridge 0000:02:03.0
  PCI: Cannot allocate resource region 8 of bridge 0000:02:03.0
  PCI: Cannot allocate resource region 9 of bridge 0000:02:03.0
messages associated with the transparent p2p bridge on the 
docking station are _not_ new and come from
	if (!r->start || !pr ||
	    request_resource(pr, r) < 0) {
		printk(KERN_ERR "PCI: Cannot allocate "
			"resource region %d "
			"of bridge %s\n",
			idx, pci_name(dev));
			/*
			* Something is wrong with the region.
			* Invalidate the resource to prevent
			* child resource allocations in this
			* range.
			*/
			r->flags = 0;
		}
in pcibios_allocate_bus_resources() [arch/x86/pci/i386.c] which
is visited during boot but not during the hot-add.  This is where
the resource flags were cleared preventing the Oops from happening
during boot when the ThinkPad was already attached to the docking
station.  This code should probably be modified to reduce dmesg
pollution.

Will now try on one of our servers that I am the most concerned
about.

Thanks for doing this.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

# lspci
00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 03)
00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 01)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 01)
01:00.0 VGA compatible controller: ATI Technologies Inc M10 NT [FireGL Mobility T2] (rev 80)
02:00.0 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller (rev 01)
02:00.1 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller (rev 01)
02:01.0 Ethernet controller: Intel Corporation 82540EP Gigabit Ethernet Controller (Mobile) (rev 03)
02:02.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
02:03.0 PCI bridge: Texas Instruments PCI2032 PCI Docking Bridge
18:01.0 IDE interface: Silicon Image, Inc. PCI0648 (rev 01)
18:02.0 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
18:02.1 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller

# lspci -vt
-[0000:00]-+-00.0  Intel Corporation 82855PM Processor to I/O Controller
           +-01.0-[0000:01]----00.0  ATI Technologies Inc M10 NT [FireGL Mobility T2]
           +-1d.0  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1
           +-1d.1  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2
           +-1d.2  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3
           +-1d.7  Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller
           +-1e.0-[0000:02-0f]--+-00.0  Texas Instruments PCI4520 PC card Cardbus Controller
           |                    +-00.1  Texas Instruments PCI4520 PC card Cardbus Controller
           |                    +-01.0  Intel Corporation 82540EP Gigabit Ethernet Controller (Mobile)
           |                    +-02.0  Atheros Communications, Inc. AR5212 802.11abg NIC
           |                    \-03.0-[0000:18-20]--+-01.0  Silicon Image, Inc. PCI0648
           |                                         +-02.0  Texas Instruments PCI1420 PC card Cardbus Controller
           |                                         \-02.1  Texas Instruments PCI1420 PC card Cardbus Controller
           +-1f.0  Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge
           +-1f.1  Intel Corporation 82801DBM (ICH4-M) IDE Controller
           +-1f.3  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller
           +-1f.5  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller
           \-1f.6  Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller

# lspci -vv
00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 03)
	Subsystem: IBM Thinkpad T41
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Capabilities: [e4] Vendor Specific Information
	Capabilities: [a0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=x1

00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 96
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: c0100000-c01fffff
	Prefetchable memory behind bridge: e0000000-e7ffffff
	Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: IBM ThinkPad
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 4: I/O ports at 1800 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: IBM ThinkPad
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 4: I/O ports at 1820 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: IBM ThinkPad
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 11
	Region 4: I/O ports at 1840 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: IBM ThinkPad
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 11
	Region 0: Memory at c0000000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Latency: 0
	Bus: primary=00, secondary=02, subordinate=0f, sec-latency=64
	I/O behind bridge: 00004000-00009fff
	Memory behind bridge: c0200000-cfffffff
	Prefetchable memory behind bridge: e8000000-efffffff
	Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: IBM ThinkPad
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 1860 [size=16]
	Region 5: Memory at 50000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 01)
	Subsystem: IBM ThinkPad
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 11
	Region 4: I/O ports at 1880 [size=32]

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
	Subsystem: IBM ThinkPad T41
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 0: I/O ports at 1c00 [size=256]
	Region 1: I/O ports at 18c0 [size=64]
	Region 2: Memory at c0000c00 (32-bit, non-prefetchable) [size=512]
	Region 3: Memory at c0000800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 01) (prog-if 00 [Generic])
	Subsystem: IBM ThinkPad
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 0: I/O ports at 2400 [size=256]
	Region 1: I/O ports at 2000 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc M10 NT [FireGL Mobility T2] (rev 80) (prog-if 00 [VGA])
	Subsystem: IBM: Unknown device 054f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B+
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 255 (2000ns min), Cache Line Size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at 3000 [size=256]
	Region 2: Memory at c0100000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [58] AGP version 2.0
		Status: RQ=80 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- FW- Rate=<none>
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.0 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller (rev 01)
	Subsystem: IBM ThinkPad
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at b0000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=10, subordinate=13, sec-latency=176
	Memory window 0: 04000000-07fff000 (prefetchable)
	Memory window 1: 04000000-07fff000 (prefetchable)
	I/O window 0: 00000100-000001ff
	I/O window 1: 00000100-000001ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite-
	16-bit legacy interface ports at 0001

02:00.1 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller (rev 01)
	Subsystem: IBM ThinkPad
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size 08
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at b1000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=14, subordinate=17, sec-latency=176
	Memory window 0: 04000000-07fff000 (prefetchable)
	Memory window 1: 04000000-07fff000 (prefetchable)
	I/O window 0: 00000100-000001ff
	I/O window 1: 00000100-000001ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite-
	16-bit legacy interface ports at 0001

02:01.0 Ethernet controller: Intel Corporation 82540EP Gigabit Ethernet Controller (Mobile) (rev 03)
	Subsystem: IBM PRO/1000 MT Mobile Connection
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (63750ns min), Cache Line Size 10
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at c0240000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at c0200000 (32-bit, non-prefetchable) [size=64K]
	Region 2: I/O ports at 8000 [size=64]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-

02:02.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
	Subsystem: Phillips Components: Unknown device 8331
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2500ns min, 7000ns max), Cache Line Size 10
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at c0210000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

02:03.0 PCI bridge: Texas Instruments PCI2032 PCI Docking Bridge (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size 10
	Bus: primary=02, secondary=18, subordinate=20, sec-latency=64
	I/O behind bridge: 00004000-00005fff
	Memory behind bridge: c2000000-cbffffff
	Prefetchable memory behind bridge: e8000000-efffffff
	Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [80] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+

18:01.0 IDE interface: Silicon Image, Inc. PCI0648 (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Silicon Image, Inc. PCI0648
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 1000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 4010 [size=8]
	Region 1: I/O ports at 4020 [size=4]
	Region 2: I/O ports at 4018 [size=8]
	Region 3: I/O ports at 4024 [size=4]
	Region 4: I/O ports at 4000 [size=16]
	Capabilities: [60] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=3 PME-

18:02.0 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
	Subsystem: IBM ThinkPad A20m
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at c2000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=18, secondary=19, subordinate=1c, sec-latency=176
	Memory window 0: 04000000-07fff000 (prefetchable)
	Memory window 1: 04000000-07fff000 (prefetchable)
	I/O window 0: 00000100-000001ff
	I/O window 1: 00000100-000001ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt- PostWrite-
	16-bit legacy interface ports at 0001

18:02.1 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
	Subsystem: IBM ThinkPad A20m
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin B routed to IRQ 255
	Region 0: Memory at c2001000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=18, secondary=1d, subordinate=20, sec-latency=176
	Memory window 0: 04000000-07fff000 (prefetchable)
	Memory window 1: 04000000-07fff000 (prefetchable)
	I/O window 0: 00000100-000001ff
	I/O window 1: 00000100-000001ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt- PostWrite-
	16-bit legacy interface ports at 0001


Linux version 2.6.25-rc6-gh (root@garyh.ibm.com) (gcc version 3.4.6 20060404 (Red Hat 3.4.6-9)) #4 Fri Mar 28 10:55:53 PDT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff60000 (usable)
 BIOS-e820: 000000003ff60000 - 000000003ff77000 (ACPI data)
 BIOS-e820: 000000003ff77000 - 000000003ff79000 (ACPI NVS)
 BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
Scan SMP from c009f000 for 1024 bytes.
Entering add_active_range(0, 0, 261984) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   261984
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   261984
On node 0 totalpages: 261984
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 254 pages used for memmap
  HighMem zone: 32354 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F6D70, 0024 (r2 IBM   )
ACPI: XSDT 3FF6A6CD, 004C (r1 IBM    TP-1R        3160  LTP        0)
ACPI: FACP 3FF6A800, 00F4 (r3 IBM    TP-1R        3160 IBM         1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 3FF6A9E7, C4D5 (r1 IBM    TP-1R        3160 MSFT  100000E)
ACPI: FACS 3FF78000, 0040
ACPI: SSDT 3FF6A9B4, 0033 (r1 IBM    TP-1R        3160 MSFT  100000E)
ACPI: ECDT 3FF76EBC, 0052 (r1 IBM    TP-1R        3160 IBM         1)
ACPI: TCPA 3FF76F0E, 0032 (r1 IBM    TP-1R        3160 PTL         1)
ACPI: BOOT 3FF76FD8, 0028 (r1 IBM    TP-1R        3160  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 50000000 (gap: 40000000:bf800000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259938
Kernel command line: ro root=LABEL=/ exec-shield=0 selinux=0 vga=788 resume=/dev/hda3
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (01808000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0426000 soft=c0425000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1698.585 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1033748k/1047936k available (2052k kernel code, 13412k reserved, 935k data, 216k init, 130432k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9a000 - 0xfffff000   ( 404 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03ec000 - 0xc0422000   ( 216 kB)
      .data : 0xc0301252 - 0xc03eaf9c   ( 935 kB)
      .text : 0xc0100000 - 0xc0301252   (2052 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 3399.49 BogoMIPS (lpj=6798997)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) M processor 1700MHz stepping 05
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0800)
khelper used greatest stack depth: 3420 bytes left
net_namespace: 568 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd8d6, last bus=15
PCI: Using configuration type 1
Setting up standard PCI resources
khelper used greatest stack depth: 3180 bytes left
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Transparent bridge - 0000:02:03.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1.DOCK._PRT]
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnpacpi: exceeded the max number of mem resources: 12
 00:00: mem resource (0x0-0x9ffff) overlaps 0000:02:03.0 BAR 8 (0x0-0xfffff), disabling
 00:00: mem resource (0xc0000-0xc3fff) overlaps 0000:02:03.0 BAR 8 (0x0-0xfffff), disabling
 00:00: mem resource (0xc4000-0xc7fff) overlaps 0000:02:03.0 BAR 8 (0x0-0xfffff), disabling
 00:00: mem resource (0xc8000-0xcbfff) overlaps 0000:02:03.0 BAR 8 (0x0-0xfffff), disabling
 00:00: mem resource (0xcc000-0xcffff) overlaps 0000:02:03.0 BAR 8 (0x0-0xfffff), disabling
 00:00: mem resource (0xd0000-0xd3fff) overlaps 0000:02:03.0 BAR 8 (0x0-0xfffff), disabling
 00:00: mem resource (0xdc000-0xdffff) overlaps 0000:02:03.0 BAR 8 (0x0-0xfffff), disabling
 00:00: mem resource (0xe0000-0xe3fff) overlaps 0000:02:03.0 BAR 8 (0x0-0xfffff), disabling
 00:00: mem resource (0xe4000-0xe7fff) overlaps 0000:02:03.0 BAR 8 (0x0-0xfffff), disabling
 00:00: mem resource (0xe8000-0xebfff) overlaps 0000:02:03.0 BAR 8 (0x0-0xfffff), disabling
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 7 of bridge 0000:02:03.0
PCI: Cannot allocate resource region 8 of bridge 0000:02:03.0
PCI: Cannot allocate resource region 9 of bridge 0000:02:03.0
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0x15e0-0x15ef has been reserved
system 00:02: ioport range 0x1600-0x162f has been reserved
system 00:02: ioport range 0x1632-0x167f has been reserved
system 00:02: ioport range 0x1630-0x1631 has been reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: 3000-3fff
  MEM window: 0xc0100000-0xc01fffff
  PREFETCH window: 0x00000000e0000000-0x00000000e7ffffff
PCI: bogus alignment of resource 7 [100:1ff] (flags 100) of 0000:02:00.0
PCI: bogus alignment of resource 8 [100:1ff] (flags 100) of 0000:02:00.0
PCI: bogus alignment of resource 9 [4000000:7ffffff] (flags 1200) of 0000:02:00.0
PCI: bogus alignment of resource 10 [4000000:7ffffff] (flags 200) of 0000:02:00.0
PCI: bogus alignment of resource 7 [100:1ff] (flags 100) of 0000:02:00.1
PCI: bogus alignment of resource 8 [100:1ff] (flags 100) of 0000:02:00.1
PCI: bogus alignment of resource 9 [4000000:7ffffff] (flags 1200) of 0000:02:00.1
PCI: bogus alignment of resource 10 [4000000:7ffffff] (flags 200) of 0000:02:00.1
PCI: Bus 16, cardbus bridge: 0000:02:00.0
  IO window: 0x00000100-0x000001ff
  IO window: 0x00000100-0x000001ff
  PREFETCH window: 0x04000000-0x07ffffff
  MEM window: 0x04000000-0x07ffffff
PCI: Bus 20, cardbus bridge: 0000:02:00.1
  IO window: 0x00000100-0x000001ff
  IO window: 0x00000100-0x000001ff
  PREFETCH window: 0x04000000-0x07ffffff
  MEM window: 0x04000000-0x07ffffff
PCI: bogus alignment of resource 7 [100:1ff] (flags 100) of 0000:09:02.0
PCI: bogus alignment of resource 8 [100:1ff] (flags 100) of 0000:09:02.0
PCI: bogus alignment of resource 9 [4000000:7ffffff] (flags 1200) of 0000:09:02.0
PCI: bogus alignment of resource 10 [4000000:7ffffff] (flags 200) of 0000:09:02.0
PCI: bogus alignment of resource 7 [100:1ff] (flags 100) of 0000:09:02.1
PCI: bogus alignment of resource 8 [100:1ff] (flags 100) of 0000:09:02.1
PCI: bogus alignment of resource 9 [4000000:7ffffff] (flags 1200) of 0000:09:02.1
PCI: bogus alignment of resource 10 [4000000:7ffffff] (flags 200) of 0000:09:02.1
PCI: Bus 10, cardbus bridge: 0000:09:02.0
  IO window: 0x00000100-0x000001ff
  IO window: 0x00000100-0x000001ff
  PREFETCH window: 0x04000000-0x07ffffff
  MEM window: 0x04000000-0x07ffffff
PCI: Bus 14, cardbus bridge: 0000:09:02.1
  IO window: 0x00000100-0x000001ff
  IO window: 0x00000100-0x000001ff
  PREFETCH window: 0x04000000-0x07ffffff
  MEM window: 0x04000000-0x07ffffff
PCI: Bridge: 0000:02:03.0
  IO window: 4000-4fff
  MEM window: 0xc4000000-0xcbffffff
  PREFETCH window: 0x00000000e8000000-0x00000000efffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 4000-9fff
  MEM window: 0xc0200000-0xcfffffff
  PREFETCH window: 0x00000000e8000000-0x00000000efffffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:02:00.1[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:09:02.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt 0000:09:02.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 727k freed
udev used greatest stack depth: 3108 bytes left
Simple Boot Flag at 0x35 set to 0x1
IBM machine detected. Enabling interrupts during APM calls.
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
type=2000 audit(1206702145.152:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0xe0000000, mapped to 0xf8880000, using 1875k, total 131008k
vesafb: mode is 800x600x16, linelength=1600, pages=135
vesafb: protected mode interface info at c000:5a0d
vesafb: pmi: set display start = c00c5a7b, set palette = c00c5ab5
vesafb: pmi: ports = 3010 3016 3054 3038 303c 305c 3000 3004 30b0 30b2 30b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU] (supports 8 throttling states)
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THM0] (51 C)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
agpgart: Detected an Intel 855PM Chipset.
agpgart: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial 00:0a: activated
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
brd: module loaded
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller (0x8086:0x24ca rev 0x01) at  PCI slot 0000:00:1f.1
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1860-0x1867, BIOS settings: hda:DMA, hdb:PIO
    ide1: BM-DMA at 0x1868-0x186f, BIOS settings: hdc:DMA, hdd:PIO
Probing IDE interface ide0...
hda: HTS541080G9AT00, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: TOSHIBA DVD-ROM SD-R9012, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
CMD648: IDE controller (0x1095:0x0648 rev 0x01) at  PCI slot 0000:09:01.0
ACPI: PCI Interrupt 0000:09:01.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
CMD648: 100% native mode on irq 11
    ide2: BM-DMA at 0x9000-0x9007, BIOS settings: hde:PIO, hdf:PIO
    ide3: BM-DMA at 0x9008-0x900f, BIOS settings: hdg:PIO, hdh:PIO
Probing IDE interface ide2...
Probing IDE interface ide3...
Probing IDE interface ide2...
Probing IDE interface ide3...
hda: max request size: 128KiB
hda: 156301488 sectors (80026 MB) w/7539KiB Cache, CHS=65535/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3
hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 1.00
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 216k freed
Write protecting the kernel read-only data: 736k
udevstart used greatest stack depth: 2936 bytes left
udev used greatest stack depth: 2904 bytes left
SCSI subsystem initialized
udev used greatest stack depth: 2700 bytes left
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
Marking TSC unstable due to: TSC halts in idle.
Time: acpi_pm clocksource has been installed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x2c6ab1, caps: 0x884793/0x0
serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1
modprobe used greatest stack depth: 2496 bytes left
hotplug used greatest stack depth: 2112 bytes left
Clocksource tsc unstable (delta = -388983397 ns)
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input2
warning: process `kmodule' used the deprecated sysctl system call with 1.23.
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
e1000: 0000:02:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:16:41:52:6f:b1
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.5 to 64
intel8x0_measure_ac97_clock: measured 55363 usecs
intel8x0: clocking to 48000
intel_rng: FWH not detected
ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.6 to 64
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001840
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 4 ports detected
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xc0000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
usb 1-1: USB disconnect, address 2
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
usb 4-1: new high speed USB device using ehci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
hub 4-1:1.0: USB hub found
hub 4-1:1.0: 4 ports detected
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
ACPI: ACPI Dock Station Driver 
EXT3 FS on hda2, internal journal
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Adding 1044216k swap on /dev/hda3.  Priority:-1 extents:1 across:1044216k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x3bc, irq 7 [PCSPP,TRISTATE]
parport_pc 00:0b: disabled
warning: process `kudzu' used the deprecated sysctl system call with 1.49.
warning: process `kudzu' used the deprecated sysctl system call with 1.49.
ip_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
ip_tables: (C) 2000-2006 Netfilter Core Team
warning: `nscd' uses 32-bit capabilities (legacy support in use)
parport_pc 00:0b: activated
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x3bc, irq 7 [PCSPP,TRISTATE]
lp0: using parport0 (interrupt-driven).
lp0: console ready
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Non-volatile memory driver v1.2
thinkpad_acpi: ThinkPad ACPI Extras v0.19
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 1RETDKWW (3.16 ), EC 1RHT71WW-3.04
thinkpad_acpi: IBM ThinkPad T41p
input: ThinkPad Extra Buttons as /class/input/input6
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:1e.0
decode_hpp: Could not get hotplug parameters. Use defaults
acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:02:03
acpiphp: Slot [1] registered
acpiphp_glue: Bus 0000:02 has 1 slot
acpiphp_glue: Total 1 slots
acpiphp: disable_slot - physical_slot = 1
ACPI: PCI interrupt for device 0000:09:02.0 disabled
ACPI: PCI interrupt for device 0000:09:02.1 disabled
ACPI: Delete PCI Interrupt Routing Table for 0:a
ACPI: Delete PCI Interrupt Routing Table for 0:e
ACPI: Delete PCI Interrupt Routing Table for 0:9
acpiphp_glue: handle_hotplug_event_func: Device eject notify on \_SB_.PCI0.PCI1.DOCK
ACPI: \_SB_.PCI0.PCI1.DOCK - undocking
usb 4-1: USB disconnect, address 2
e1000: eth0: e1000_watchdog: NIC Link is Down
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
ACPI: \_SB_.PCI0.PCI1.DOCK - docking
acpiphp_glue: handle_hotplug_event_func: Bus check notify on \_SB_.PCI0.PCI1.DOCK
PCI: Transparent bridge - 0000:02:03.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1.DOCK._PRT]
PCI: bogus alignment of resource 7 [100:1ff] (flags 100) of 0000:02:00.0
PCI: bogus alignment of resource 8 [100:1ff] (flags 100) of 0000:02:00.0
PCI: bogus alignment of resource 9 [4000000:7ffffff] (flags 1200) of 0000:02:00.0
PCI: bogus alignment of resource 10 [4000000:7ffffff] (flags 200) of 0000:02:00.0
PCI: bogus alignment of resource 7 [100:1ff] (flags 100) of 0000:02:00.1
PCI: bogus alignment of resource 8 [100:1ff] (flags 100) of 0000:02:00.1
PCI: bogus alignment of resource 9 [4000000:7ffffff] (flags 1200) of 0000:02:00.1
PCI: bogus alignment of resource 10 [4000000:7ffffff] (flags 200) of 0000:02:00.1
PCI: Bus 16, cardbus bridge: 0000:02:00.0
  IO window: 0x00000100-0x000001ff
  IO window: 0x00000100-0x000001ff
  PREFETCH window: 0x04000000-0x07ffffff
  MEM window: 0x04000000-0x07ffffff
PCI: Bus 20, cardbus bridge: 0000:02:00.1
  IO window: 0x00000100-0x000001ff
  IO window: 0x00000100-0x000001ff
  PREFETCH window: 0x04000000-0x07ffffff
  MEM window: 0x04000000-0x07ffffff
PCI: bogus alignment of resource 7 [100:1ff] (flags 100) of 0000:18:02.0
PCI: bogus alignment of resource 8 [100:1ff] (flags 100) of 0000:18:02.0
PCI: bogus alignment of resource 9 [4000000:7ffffff] (flags 1200) of 0000:18:02.0
PCI: bogus alignment of resource 10 [4000000:7ffffff] (flags 200) of 0000:18:02.0
PCI: bogus alignment of resource 7 [100:1ff] (flags 100) of 0000:18:02.1
PCI: bogus alignment of resource 8 [100:1ff] (flags 100) of 0000:18:02.1
PCI: bogus alignment of resource 9 [4000000:7ffffff] (flags 1200) of 0000:18:02.1
PCI: bogus alignment of resource 10 [4000000:7ffffff] (flags 200) of 0000:18:02.1
PCI: Bus 25, cardbus bridge: 0000:18:02.0
  IO window: 0x00000100-0x000001ff
  IO window: 0x00000100-0x000001ff
  PREFETCH window: 0x04000000-0x07ffffff
  MEM window: 0x04000000-0x07ffffff
PCI: Bus 29, cardbus bridge: 0000:18:02.1
  IO window: 0x00000100-0x000001ff
  IO window: 0x00000100-0x000001ff
  PREFETCH window: 0x04000000-0x07ffffff
  MEM window: 0x04000000-0x07ffffff
PCI: Bridge: 0000:02:03.0
  IO window: 4000-5fff
  MEM window: 0xc2000000-0xcbffffff
  PREFETCH window: 0x00000000e8000000-0x00000000efffffff
decode_hpp: Could not get hotplug parameters. Use defaults
PCI: Enabling device 0000:02:03.0 (0000 -> 0003)
PCI: Enabling device 0000:18:02.0 (0000 -> 0003)
ACPI: PCI Interrupt 0000:18:02.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:18:02.0 to 64
PCI: Enabling device 0000:18:02.1 (0000 -> 0003)
ACPI: Unable to derive IRQ for device 0000:18:02.1
ACPI: PCI Interrupt 0000:18:02.1[B]: no GSI
PCI: Setting latency timer of device 0000:18:02.1 to 64
CMD648: IDE controller (0x1095:0x0648 rev 0x01) at  PCI slot 0000:18:01.0
PCI: Enabling device 0000:18:01.0 (0000 -> 0001)
ACPI: PCI Interrupt 0000:18:01.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
CMD648: 100% native mode on irq 11
    ide4: BM-DMA at 0x4000-0x4007, BIOS settings: hdi:PIO, hdj:PIO
    ide5: BM-DMA at 0x4008-0x400f, BIOS settings: hdk:PIO, hdl:PIO
Probing IDE interface ide4...
usb 4-1: new high speed USB device using ehci_hcd and address 3
Probing IDE interface ide5...
usb 4-1: configuration #1 chosen from 1 choice
hub 4-1:1.0: USB hub found
hub 4-1:1.0: 4 ports detected
