Return-Path: <linux-kernel-owner+w=401wt.eu-S1422792AbXBUSzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422792AbXBUSzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422803AbXBUSzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:55:18 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3250 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422792AbXBUSzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:55:16 -0500
Message-ID: <45DC9587.9010304@xs4all.nl>
Date: Wed, 21 Feb 2007 19:55:03 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain> <45DA7643.4020305@xs4all.nl> <200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl> <45DC0FCC.7010705@xs4all.nl> <20070221134411.GC22464@csclub.uwaterloo.ca>
In-Reply-To: <20070221134411.GC22464@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Wed, Feb 21, 2007 at 10:24:28AM +0100, Udo van den Heuvel wrote:
>> Udo van den Heuvel wrote:
>> So, if not (as in my situation) how can I find out what is wrong?
>> Or find out if the BIOS works OK with the card?
>> How can I verify that the correct routing for the IRQ is in place?
>> The DN is the only variable so INT lines are hardwired on the riser card?
>> Then same for the motherboard.
> 
> It is quite likely that the interrupts are set based on the DN.  Now if
> they use whatever the parent slot uses as INTD as INTA for the second
> slot (since it is set to 19 which is 1 below 20 of the main slot), then
> that probably isn't what the BIOS is likely to assign.  It really sounds
> like via decided to do things their own way and only riser cards done
> their way, or riser cards with a pci to pci bridge are going to work
> with it.
> 
>> I.o.w.: how can I find the root cause?
> 
> Does the documentation say which interrupts are INTA, B, C and D on the
> main board?  I would expect slot 20 to have INTA mapped to INTA but then
> again being a weird main board it doesn't have to be that way.  It is
> certainly possible via decided to just support DN19 and 20 and assign
> them both INTA, which would certainly make for a very simple riser card.

I found something:

EPIA-EN User's Manual v.1.10.pdf, chapter 2, Slots (page 26):

PCI Interrupt Request Routing

The IRQ (interrupt request line) are hardware lines over which devices
can send interrupt signals to the microprocessor. The “PCI & LAN” IRQ
pins are typically connected to the PCI bus INT A# ~ INT D# pins as follows:
		Order 1		Order 2 	Order 3 	Order 4
PCI Slot 1	INT B# 		INT C# 		INT D# 		INT A#
IEEE1394 	INT B#

`The slot` and IEEE1394 are indeed on the same IRQ 20 when I use the
default setting of DN19 for the extra slot.



00:00.0 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
        Subsystem: VIA Technologies, Inc. Unknown device aa08
        Flags: bus master, 66MHz, medium devsel, latency 8
        Memory at e8000000 (32-bit, prefetchable) [size=128M]
        Capabilities: [80] AGP version 3.5
        Capabilities: [50] Power Management version 2

00:00.1 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
        Flags: bus master, medium devsel, latency 0

00:00.2 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
        Flags: bus master, medium devsel, latency 0

00:00.3 Host bridge: VIA Technologies, Inc. PT890 Host Bridge
        Flags: bus master, medium devsel, latency 0

00:00.4 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
        Flags: bus master, medium devsel, latency 0

00:00.7 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
        Flags: bus master, medium devsel, latency 0

00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge (prog-if 00
[Normal decode])
        Flags: bus master, 66MHz, medium devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: fb000000-fcffffff
        Prefetchable memory behind bridge: f4000000-f7ffffff
        Capabilities: [70] Power Management version 2

00:0d.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev 80) (prog-if 10 [OHCI])
        Subsystem: VIA Technologies, Inc. IEEE 1394 Host Controller
        Flags: bus master, stepping, medium devsel, latency 32, IRQ 20
        Memory at fdfff000 (32-bit, non-prefetchable) [size=2K]
        I/O ports at fc00 [size=128]
        Capabilities: [50] Power Management version 2

00:0e.0 Ethernet controller: VIA Technologies, Inc. VT6120/VT6121/VT6122
Gigabit Ethernet Adapter (rev 11)
        Subsystem: VIA Technologies, Inc. Unknown device 0110
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
        I/O ports at f800 [size=256]
        Memory at fdffe000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2

00:0f.0 IDE interface: VIA Technologies, Inc. VIA VT6420 SATA RAID
Controller (rev 80) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: VIA Technologies, Inc. VIA VT6420 SATA RAID Controller
        Flags: bus master, medium devsel, latency 32, IRQ 18
        I/O ports at f400 [size=8]
        I/O ports at f000 [size=4]
        I/O ports at ec00 [size=8]
        I/O ports at e800 [size=4]
        I/O ports at e400 [size=16]
        I/O ports at e000 [size=256]
        Capabilities: [c0] Power Management version 2

00:0f.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP])
        Subsystem: VIA Technologies, Inc.
VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
        Flags: bus master, medium devsel, latency 32, IRQ 18
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
        I/O ports at dc00 [size=16]
        Capabilities: [c0] Power Management version 2

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at d800 [size=32]
        Capabilities: [80] Power Management version 2

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at d400 [size=32]
        Capabilities: [80] Power Management version 2

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at d000 [size=32]
        Capabilities: [80] Power Management version 2

00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if
20 [EHCI])
        Subsystem: VIA Technologies, Inc. USB 2.0
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at fdffd000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2

00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge
[KT600/K8T800/K8T890 South]
        Subsystem: VIA Technologies, Inc. Unknown device aa08
        Flags: bus master, stepping, medium devsel, latency 0
        Capabilities: [c0] Power Management version 2

00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
        Subsystem: VIA Technologies, Inc. Unknown device aa08
        Flags: medium devsel, IRQ 21
        I/O ports at c800 [size=256]
        Capabilities: [c0] Power Management version 2

00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1157
        Flags: bus master, medium devsel, latency 32, IRQ 16
        Memory at fdffc000 (32-bit, non-prefetchable) [size=512]

00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1155
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at fdffb000 (32-bit, non-prefetchable) [size=512]

01:00.0 VGA compatible controller: VIA Technologies, Inc. UniChrome Pro
IGP (rev 01) (prog-if 00 [VGA])
        Subsystem: VIA Technologies, Inc. UniChrome Pro IGP
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
        Memory at f4000000 (32-bit, prefetchable) [size=64M]
        Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at fc000000 [disabled] [size=64K]
        Capabilities: [60] Power Management version 2
        Capabilities: [70] AGP version 3.0

           CPU0
  0:   24611141   IO-APIC-edge      timer
  1:         34   IO-APIC-edge      i8042
  8:          1   IO-APIC-edge      rtc
  9:          0   IO-APIC-fasteoi   acpi
 12:        105   IO-APIC-edge      i8042
 14:     881823   IO-APIC-edge      ide0
 16:    4916467   IO-APIC-fasteoi   saa7146 (0), via@pci:0000:01:00.0
 17:    3522084   IO-APIC-fasteoi   eth0
 18:     820707   IO-APIC-fasteoi   libata
 19:          0   IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb2,
uhci_hcd:usb3, ehci_hcd:usb4
 20:          2   IO-APIC-fasteoi   saa7146 (1), ohci1394
 21:    4582389   IO-APIC-fasteoi   VIA8237
NMI:          0
LOC:   24612000
ERR:          0
MIS:          0
