Return-Path: <linux-kernel-owner+w=401wt.eu-S1750950AbZCMEwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950AbZCMEwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZCMEvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:51:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41362 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbZCMEvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:51:47 -0400
From: Gabor Kovacs <kgabor@bolyai.elte.hu>
To: linux-kernel@vger.kernel.org
Subject: Lava dual parallel PCI card IRQ problem
Date: Fri, 13 Mar 2009 00:51:18 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903130051.18119.kgabor@bolyai.elte.hu>
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have problems in setting up IRQ mode operation of parallel ports using 
onboard port and a LAVA dual parallel PCI card. IRQ is needed to catch events 
of an external instrument.

Motherboard is a K9N2G-Neo (MS-7511) with one onboard parallel port, x86_64 
Debian lenny, kernel custom compiled 2.6.26.5.

In the example below, parport_pc is loaded without any arguments, onboard port 
works OK in IRQ mode. LAVA card ports are detected but do not have IRQs, work 
in polled operation:

modprobe parport_pc
===
parport_pc 00:04: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP]
ACPI: Power Button (CM) [PWRB]
parport_pc 00:04: driver attached
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 16
ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [LNKC] -> GSI 16 (level, low) -> 
IRQ 16
PCI parallel port detected: 1407:8002, I/O at 0xb400(0x0)
parport1: PC-style at 0xb400 [PCSPP,TRISTATE,EPP]
ACPI: PCI Interrupt 0000:01:06.1[A] -> Link [LNKC] -> GSI 16 (level, low) -> 
IRQ 16
PCI parallel port detected: 1407:8003, I/O at 0xb080(0x0)
parport2: PC-style at 0xb080 [PCSPP,TRISTATE,EPP]

If "io" and "irq" options are specified, parport_pc falls back to some "dumb" 
mode. Onboard port does not work at all (lack of PNP/ACPI initialization ?), 
LAVA card may work if proper IRQ and IO address are specified (reported by 
lspci -v). In most cases, however, this IRQ is already used by an NEC USB 
card in my box. Actually, I could not find any way to control IRQ assignment 
for cards. The only way is to remove some cards or playing with card order  
in slots.

- Is there a way to autodetect and activate LAVA card in IRQ mode? 
- What kind of PnP/ACPI initialization steps are omitted if IO/IRQ parameters 
are passed to parport_pc?
- Why can't parport_pc share IRQ? (Other devices apparently share IRQs in the 
box. See irq 17 below) 

Thanks
Gabor Kovacs

===========
Scenarios:

Lava card works in polled operation, onboard port does not work at all:

modprobe parport_pc io=0x378,0xb400,0xb080 irq=auto,auto,auto
===
parport 0x378 (WARNING): CTR: wrote 0x0c, read 0xff
parport 0x378 (WARNING): DATA: wrote 0xaa, read 0xff
parport 0x378: You gave this address, but there is probably no parallel port 
there!
parport0: PC-style at 0x378 [PCSPP,TRISTATE]
parport1: PC-style at 0xb400 [PCSPP,TRISTATE,EPP]
parport2: PC-style at 0xb080 [PCSPP,TRISTATE,EPP]

=========

IRQ conflict is reported by parport_pc:
modprobe parport_pc io=0xb400,0xb080 irq=auto,16
===
parport0: PC-style at 0xb400 [PCSPP,TRISTATE,EPP]
parport1: PC-style at 0xb080, irq 16 [PCSPP,TRISTATE,EPP]
parport1: irq 16 in use, resorting to polled operation

cat /proc/interrupts:

           CPU0       CPU1       CPU2       CPU3
  0:         37          0          0          0   IO-APIC-edge      timer
  1:          0          0          0        676   IO-APIC-edge      i8042
  7:          2          0          0          0   IO-APIC-edge
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          0          0          8       5194   IO-APIC-edge      i8042
 14:          0          0          0          0   IO-APIC-edge      pata_amd
 15:          0          0          0          0   IO-APIC-edge      pata_amd
 16:          0          0          0          0   IO-APIC-fasteoi   
ohci_hcd:usb1
 17:          0          0          0          4   IO-APIC-fasteoi
 18:          0          0          0          0   IO-APIC-fasteoi   
ehci_hcd:usb3
 19:          0          0          0          0   IO-APIC-fasteoi   
ohci_hcd:usb2
507:          0          0        238    2024744   PCI-MSI-edge      eth0
508:          0          0         60     176614   PCI-MSI-edge      ahci
NMI:          0          0          0          0   Non-maskable interrupts
LOC:    4898793    4898779    4898752    4898724   Local timer interrupts
RES:      20033      12217      15650      29497   Rescheduling interrupts
CAL:        517        602        607        137   function call interrupts
TLB:       1200        992        869        796   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          1

lspci -v:
========
00:00.0 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller 
(rev a2)
        Subsystem: Micro-Star International Co., Ltd. Device 7511
        Flags: bus master, 66MHz, fast devsel, latency 0
        Capabilities: [94] HyperTransport: #1a
        Capabilities: [60] HyperTransport: Retry Mode
        Capabilities: [44] HyperTransport: Slave or Primary Interface
        Capabilities: [d0] HyperTransport: #1c

00:01.0 ISA bridge: nVidia Corporation MCP78S [GeForce 8200] LPC Bridge (rev 
a2)
        Subsystem: Micro-Star International Co., Ltd. Device 7511
        Flags: bus master, 66MHz, fast devsel, latency 0
        I/O ports at 2f00 [size=256]

00:01.1 SMBus: nVidia Corporation MCP78S [GeForce 8200] SMBus (rev a1)
        Subsystem: Micro-Star International Co., Ltd. Device 7511
        Flags: 66MHz, fast devsel, IRQ 11
        I/O ports at 2900 [size=64]
        I/O ports at 2d00 [size=64]
        I/O ports at 2e00 [size=64]
        Capabilities: [44] Power Management version 2

00:01.2 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller 
(rev a1)
        Subsystem: Micro-Star International Co., Ltd. Device 7511
        Flags: 66MHz, fast devsel

00:01.3 Co-processor: nVidia Corporation MCP78S [GeForce 8200] Co-Processor 
(rev a2)
        Subsystem: Micro-Star International Co., Ltd. Device 7511
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 15
        Memory at fcf80000 (32-bit, non-prefetchable) [size=512K]

00:01.4 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller 
(rev a1)
        Subsystem: Micro-Star International Co., Ltd. Device 7511
        Flags: 66MHz, fast devsel

00:06.0 IDE interface: nVidia Corporation MCP78S [GeForce 8200] IDE (rev a1) 
(prog-if 8a [Master SecP PriP])
        Subsystem: Device f462:7511
        Flags: bus master, 66MHz, fast devsel, latency 0
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] 
[size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] 
[size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] 
[size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] 
[size=1]
        I/O ports at ffa0 [size=16]
        Capabilities: [44] Power Management version 2
        Kernel driver in use: pata_amd
        Kernel modules: pata_amd, ide-pci-generic

00:08.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev 
a1) (prog-if 01 [Subtractive decode])
        Flags: bus master, 66MHz, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 0000b000-0000bfff
        Capabilities: [b8] Subsystem: Micro-Star International Co., Ltd. 
Device 7511
        Capabilities: [8c] HyperTransport: MSI Mapping Enable+ Fixed-

00:09.0 SATA controller: nVidia Corporation MCP78S [GeForce 8200] AHCI 
Controller (rev a2) (prog-if 01 [AHCI 1.0])
        Subsystem: Micro-Star International Co., Ltd. Device 7511
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 508
        I/O ports at a480 [size=8]
        I/O ports at a400 [size=4]
        I/O ports at a080 [size=8]
        I/O ports at a000 [size=4]
        I/O ports at 9c00 [size=16]
        Memory at fcf7e000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [44] Power Management version 2
        Capabilities: [8c] SATA HBA <?>
        Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/3 Enable+
        Capabilities: [ec] HyperTransport: MSI Mapping Enable+ Fixed+
        Kernel driver in use: ahci
        Kernel modules: ahci

00:0a.0 Ethernet controller: nVidia Corporation MCP78S [GeForce 8200] Ethernet 
(rev a2)
        Subsystem: Micro-Star International Co., Ltd. Device 511c
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 507
        Memory at fcf7d000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at 9880 [size=8]
        Memory at fcf7cc00 (32-bit, non-prefetchable) [size=256]
        Memory at fcf7c800 (32-bit, non-prefetchable) [size=16]
        Capabilities: [44] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ 
Queue=0/4 Enable+
        Capabilities: [6c] HyperTransport: MSI Mapping Enable+ Fixed+
        Kernel driver in use: forcedeth
        Kernel modules: forcedeth

00:0b.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Express 
Bridge (rev a1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fd000000-fe8fffff
        Prefetchable memory behind bridge: 00000000ce000000-00000000dfffffff
        Capabilities: [40] Subsystem: Micro-Star International Co., Ltd. 
Device 7511
        Capabilities: [48] Power Management version 2
        Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-

00:10.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Express 
Bridge (rev a1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
        Memory behind bridge: fe900000-fe9fffff
        Capabilities: [40] Subsystem: Micro-Star International Co., Ltd. 
Device 7511
        Capabilities: [48] Power Management version 3
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable+
        Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
        Capabilities: [80] Express Root Port (Slot+), MSI 00
        Kernel driver in use: pcieport-driver

00:13.0 PCI bridge: nVidia Corporation Device 077a (rev a1) (prog-if 00 
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fea00000-feafffff
        Capabilities: [40] Subsystem: Micro-Star International Co., Ltd. 
Device 7511
        Capabilities: [48] Power Management version 3
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable+
        Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
        Capabilities: [80] Express Root Port (Slot+), MSI 00
        Kernel driver in use: pcieport-driver

00:14.0 PCI bridge: nVidia Corporation Device 077a (rev a1) (prog-if 00 
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: feb00000-febfffff
        Capabilities: [40] Subsystem: Micro-Star International Co., Ltd. 
Device 7511
        Capabilities: [48] Power Management version 3
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable+
        Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
        Capabilities: [80] Express Root Port (Slot+), MSI 00
        Kernel driver in use: pcieport-driver

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, 
Athlon64, Sempron] HyperTransport Configuration
        Flags: fast devsel
        Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, 
Athlon64, Sempron] Address Map
        Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, 
Athlon64, Sempron] DRAM Controller
        Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, 
Athlon64, Sempron] Miscellaneous Control
        Flags: fast devsel
        Capabilities: [f0] Secure device <?>

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, 
Athlon64, Sempron] Link Control
        Flags: fast devsel

01:05.0 Serial controller: Lava Computer mfg Inc Quattro-PCI A (rev 03) 
(prog-if 02 [16550])
        Subsystem: Lava Computer mfg Inc Quattro-PCI A
        Flags: medium devsel, IRQ 17
        I/O ports at bc00 [size=8]
        I/O ports at b880 [size=8]
        Kernel driver in use: serial
        Kernel modules: 8250_pci

01:05.1 Serial controller: Lava Computer mfg Inc Quattro-PCI B (rev 03) 
(prog-if 02 [16550])
        Subsystem: Lava Computer mfg Inc Quattro-PCI B
        Flags: medium devsel, IRQ 17
        I/O ports at b800 [size=8]
        I/O ports at b480 [size=8]
        Kernel driver in use: serial
        Kernel modules: 8250_pci

01:06.0 Parallel controller: Lava Computer mfg Inc Lava Dual Parallel port A 
(rev 03) (prog-if 01 [BiDir])
        Subsystem: Lava Computer mfg Inc Lava Dual Parallel port A
        Flags: medium devsel, IRQ 16
        I/O ports at b400 [size=8]
        Kernel modules: parport_pc

01:06.1 Parallel controller: Lava Computer mfg Inc Lava Dual Parallel port B 
(rev 03) (prog-if 01 [BiDir])
        Subsystem: Lava Computer mfg Inc Lava Dual Parallel port B
        Flags: medium devsel, IRQ 16
        I/O ports at b080 [size=8]
        Kernel modules: parport_pc

01:07.0 DPIO module: Quicklogic Corporation PC Watchdog (rev 01)
        Subsystem: Device 161c:046a
        Flags: medium devsel
        I/O ports at b000 [size=8]
        Kernel driver in use: pcwd_pci
        Kernel modules: pcwd_pci

02:00.0 VGA compatible controller: nVidia Corporation GeForce 8200 (rev a2) 
(prog-if 00 [VGA controller])
        Subsystem: Micro-Star International Co., Ltd. Device 7511
        Flags: bus master, fast devsel, latency 0, IRQ 10
        Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Memory at ce000000 (64-bit, prefetchable) [size=32M]
        I/O ports at cc00 [size=128]
        Expansion ROM at fe8e0000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Kernel modules: nvidiafb, nvidia

03:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI 
Bridge (rev 03) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=03, secondary=04, subordinate=04, sec-latency=64
        Memory behind bridge: fe900000-fe9fffff
        Capabilities: [50] Power Management version 2
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/4 Enable-
        Capabilities: [80] Subsystem: Gammagraphx, Inc. Device 0000
        Capabilities: [90] Express PCI/PCI-X Bridge, MSI 00

04:01.0 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
        Subsystem: NEC Corporation Hama USB 2.0 CardBus
        Flags: bus master, medium devsel, latency 64, IRQ 16
        Memory at fe9ff000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: ohci_hcd
        Kernel modules: ohci-hcd

04:01.1 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
        Subsystem: NEC Corporation Hama USB 2.0 CardBus
        Flags: bus master, medium devsel, latency 64, IRQ 19
        Memory at fe9fe000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: ohci_hcd
        Kernel modules: ohci-hcd

04:01.2 USB Controller: NEC Corporation USB 2.0 (rev 04) (prog-if 20 [EHCI])
        Subsystem: Device 1838:1074
        Flags: bus master, medium devsel, latency 64, IRQ 18
        Memory at fe9fdc00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

05:00.0 Ethernet controller: VIA Technologies, Inc. VT6120/VT6121/VT6122 
Gigabit Ethernet Adapter (rev 81)
        Subsystem: VIA Technologies, Inc. Device 0110
        Flags: fast devsel, IRQ 18
        I/O ports at d800 [size=256]
        Memory at feaffc00 (64-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 3
        Capabilities: [90] Express Endpoint, MSI 00
        Capabilities: [c0] Message Signalled Interrupts: Mask+ 64bit+ 
Queue=0/0 Enable-
        Kernel driver in use: via-velocity
        Kernel modules: via-velocity

06:00.0 Ethernet controller: VIA Technologies, Inc. VT6120/VT6121/VT6122 
Gigabit Ethernet Adapter (rev 82)
        Subsystem: VIA Technologies, Inc. Device 0110
        Flags: fast devsel, IRQ 17
        I/O ports at e800 [size=256]
        Memory at febffc00 (64-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 3
        Capabilities: [90] Express Endpoint, MSI 00
        Capabilities: [c0] Message Signalled Interrupts: Mask+ 64bit+ 
Queue=0/0 Enable-
        Kernel driver in use: via-velocity
        Kernel modules: via-velocity

=========

When the conflicting USB card is removed, Lava card  works with IRQ if proper 
IO and IRQ are specified:

modprobe parport_pc io=0xcc00,0xc880 irq=none,16
===
parport0: PC-style at 0xcc00 [PCSPP,TRISTATE,EPP]
parport1: PC-style at 0xc880, irq 16 [PCSPP,TRISTATE,EPP]


