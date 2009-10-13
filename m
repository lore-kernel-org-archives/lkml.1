Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbZJMXT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbZJMXT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbZJMXTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:19:24 -0400
Received: from khc.piap.pl ([195.187.100.11]:56630 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761458AbZJMXTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:19:23 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: Re: sata_via: SError: { UnrecovData Proto TrStaTrns }
References: <m3my46yo5g.fsf@intrepid.localdomain>
	<19147.28614.505296.752363@pilspetsen.it.uu.se>
Date: Wed, 14 Oct 2009 01:18:43 +0200
In-Reply-To: <19147.28614.505296.752363@pilspetsen.it.uu.se> (Mikael
	Pettersson's message of "Tue, 6 Oct 2009 18:26:46 +0200")
Message-ID: <m3vdii51d8.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> writes:

> I couldn't do much about it other than ask the person to take
> it to linux-ide (which I don't think he did), but it does make
> one wonder if there is some issue with the vt6421a when connected
> to an ixp4xx.

I have performed some tests. Is there anything else I can do to fix
this?

VIA VT6421A mini-PCI (Commell MP-6421) card and SATA II SSD from
Transcend.

Machine A: IXP425 (ARM) CPU, 266 MHz. 64 MB RAM - this time all RAM is
accessible to VT6421A. PCI 33 MHz (using mini-PCI adapter). Both
little-endian and big-endian CPU modes exhibit the problems.

Machine B: AMD64 X2, 64-bit kernel, 2 GB RAM. Mini-PCI 33 MHz.

I've written a small program which only reads from disk, using the same
read pattern that was needed for e2fsck. It constists of about 6500 of
(quite random) lseek()s, each followed by read() (sizes from 524 to
32768 bytes). I do ioctl(fd, BLKFLSBUF, 0) first.

It seems I can trigger the problems almost reliably on Machine A with
rmmod sata_via; modprobe sata_via; test_program. Subsequent runs
(without rmmod/modprobe usually don't show any issue).

It usually shows up on Machine B but only once after reboot, subsequent
rmmod + modprobe doesn't seem to trigger it. The test takes about
4 seconds (if the errors don't show up).

The SSD shows no issues when connected directly to SATA port on the
machine B motherboard (NVidia MCP-55).

Machine A shows no issues when connected to a SATA disk. However, the
disk is much slower (seeks are slow, linear transfer from either device
is way above IXP425 ability). The test takes about 10 seconds with SSD
and 20 seconds with the disk. I wonder if it could be a factor.

Machine A (IXP425) doesn't obviously use the card's BIOS, so the
VT6421A is configured a bit differently (ignoring differences in
addresses etc):

--- Machine A (IXP425)
+++ Machine B (x86-64)
-RAID bus controller: VT6421 IDE RAID Controller (rev 50)
+IDE interface: VT6421 IDE RAID Controller (rev 50) (prog-if 8f [Master
         SecP SecO PriP PriO])

-        Control: Mem- FastB2B+ ...
+        Control: Mem+ FastB2B- ...

Mem - I guess x86-64 enables it for BIOS access. This is the only PCI
device in machine A (ARM).

-        Latency: 32
+        Latency: 64

         Capabilities: [e0] Power Management version 2
-                Status: ...
+                Status: NoSoftRst- ...

-00: 06 11 49 32 05 02 90 02 50 00 04 01 00 20 00 00
+00: 06 11 49 32 07 00 90 02 50 8f 01 01 00 40 00 00
-10: 21 14 00 00 31 14 00 00 41 14 00 00 51 14 00 00
+10: 01 dc 00 00 81 d8 00 00 01 d8 00 00 81 d4 00 00
-20: 01 14 00 00 01 10 00 00 00 00 00 00 06 11 49 32
+20: 01 d4 00 00 01 d0 00 00 00 00 00 00 06 11 49 32
-30: 00 00 ff ff e0 00 00 00 00 00 00 00 1d 01 00 00
+30: 00 00 af fe e0 00 00 00 00 00 00 00 0b 01 00 00
-40: 33 03 f1 44 0e af 00 00 00 00 00 03 00 00 00 00
+40: 33 03 f1 44 06 af 00 00 00 00 00 03 00 00 00 00

-70: 00 00 00 00 01 f0 00 00 01 00 01 00 11 00 00 00
+70: 00 00 00 00 01 f0 00 00 01 00 01 00 10 00 00 00
-80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+80: 00 00 00 00 00 00 00 00 00 80 c7 7d 00 00 00 00


Machine A (IXP425):

RAID bus controller: VIA Technologies, Inc. VT6421 IDE RAID Controller (rev 50)
        Subsystem: VIA Technologies, Inc. VT6421 IDE RAID Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B+ DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 29
        Region 0: I/O ports at 1420 [size=16]
        Region 1: I/O ports at 1430 [size=16]
        Region 2: I/O ports at 1440 [size=16]
        Region 3: I/O ports at 1450 [size=16]
        Region 4: I/O ports at 1400 [size=32]
        Region 5: I/O ports at 1000 [size=256]
        Expansion ROM at 48000000 [disabled] [size=64K]
        Capabilities: [e0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: sata_via
        Kernel modules: sata_via
00: 06 11 49 32 05 02 90 02 50 00 04 01 00 20 00 00
10: 21 14 00 00 31 14 00 00 41 14 00 00 51 14 00 00
20: 01 14 00 00 01 10 00 00 00 00 00 00 06 11 49 32
30: 00 00 ff ff e0 00 00 00 00 00 00 00 1d 01 00 00
40: 33 03 f1 44 0e af 00 00 00 00 00 03 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 10 10 00 05 00 10 00
60: 00 00 ff ff 00 00 00 00 00 00 00 00 00 00 ff ff
70: 00 00 00 00 01 f0 00 00 01 00 01 00 11 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 0b f2 c9 35 10 ac c0 00 a8 a8 a8 a8 ff 00 b6 b6
b0: 0f 0f 1f 1f 34 00 00 00 00 00 20 00 00 00 00 00
c0: 00 02 00 00 00 00 00 00 00 02 00 00 00 00 00 00
d0: 82 01 00 00 00 00 00 00 02 01 00 00 00 00 00 00
e0: 01 00 02 00 00 00 00 00 50 01 49 32 06 11 49 32
f0: 00 00 70 00 00 00 00 00 00 00 00 00 00 00 00 00

ata7: SATA max UDMA/133 port i16@0x1420 bmdma 0x1400 irq 29
ata8: SATA max UDMA/133 port i16@0x1430 bmdma 0x1408 irq 29
ata9: PATA max UDMA/133 port i16@0x1440 bmdma 0x1410 irq 29
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata7.00: ATA-8: TS32GSSD25S-M, V1210, max UDMA/100
ata7.00: 62586880 sectors, multi 0: LBA48 NCQ (depth 0/1)
ata7.00: applying bridge limits
ata7.00: configured for UDMA/100
scsi 6:0:0:0: Direct-Access     ATA      TS32GSSD25S-M    V121 PQ: 0 ANSI: 5
sd 6:0:0:0: [sda] 62586880 512-byte logical blocks: (32.0 GB/29.8 GiB)
sd 6:0:0:0: [sda] Write Protect is off
sd 6:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sda] Attached SCSI disk
ata8: SATA link down (SStatus 0 SControl 310)

*** running the test program ***

ata7.00: exception Emask 0x12 SAct 0x0 SErr 0x1000500 action 0x6
ata7: SError: { UnrecovData Proto TrStaTrns }
ata7.00: cmd c8/00:98:38:04:74/00:00:00:00:00/e0 tag 0 dma 77824 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x32 (host bus error)
ata7.00: status: { DRDY }
ata7: hard resetting link
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata7.00: configured for UDMA/100
ata7.00: device reported invalid CHS sector 0
ata7: EH complete
ata7.00: exception Emask 0x12 SAct 0x0 SErr 0x1000500 action 0x6
ata7.00: BMDMA stat 0x65
ata7: SError: { UnrecovData Proto TrStaTrns }
ata7.00: cmd c8/00:00:d0:05:a8/00:00:00:00:00/e1 tag 0 dma 131072 in
         res 51/40:00:d0:05:a8/00:00:00:00:00/e1 Emask 0x12 (ATA bus error)
ata7.00: status: { DRDY ERR }
ata7.00: error: { UNC }
ata7: hard resetting link
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata7.00: configured for UDMA/100
ata7: EH complete
ata7.00: exception Emask 0x12 SAct 0x0 SErr 0x1000500 action 0x6
ata7: SError: { UnrecovData Proto TrStaTrns }
ata7.00: cmd c8/00:40:10:00:2c/00:00:00:00:00/e2 tag 0 dma 32768 in
         res 40/00:00:d0:05:a8/00:00:00:00:00/e1 Emask 0x32 (host bus error)
ata7.00: status: { DRDY }
ata7: hard resetting link
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata7.00: configured for UDMA/100
ata7: EH complete
ata7.00: limiting speed to UDMA/66:PIO4
ata7.00: exception Emask 0x12 SAct 0x0 SErr 0x1000500 action 0x6
ata7: SError: { UnrecovData Proto TrStaTrns }
ata7.00: cmd c8/00:00:d0:05:30/00:00:00:00:00/e2 tag 0 dma 131072 in
         res 40/00:00:d0:05:a8/00:00:00:00:00/e1 Emask 0x32 (host bus error)
ata7.00: status: { DRDY }
ata7: hard resetting link
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata7.00: configured for UDMA/66
ata7: EH complete



Machine B (x86-64):

IDE interface: VIA Technologies, Inc. VT6421 IDE RAID Controller (rev 50) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: VIA Technologies, Inc. VT6421 IDE RAID Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at dc00 [size=16]
        Region 1: I/O ports at d880 [size=16]
        Region 2: I/O ports at d800 [size=16]
        Region 3: I/O ports at d480 [size=16]
        Region 4: I/O ports at d400 [size=32]
        Region 5: I/O ports at d000 [size=256]
        Expansion ROM at 88000000 [disabled] [size=64K]
        Capabilities: [e0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: sata_via
        Kernel modules: sata_via
00: 06 11 49 32 07 00 90 02 50 8f 01 01 00 40 00 00
10: 01 dc 00 00 81 d8 00 00 01 d8 00 00 81 d4 00 00
20: 01 d4 00 00 01 d0 00 00 00 00 00 00 06 11 49 32
30: 00 00 af fe e0 00 00 00 00 00 00 00 0b 01 00 00
40: 33 03 f1 44 06 af 00 00 00 00 00 03 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 10 10 00 05 00 10 00
60: 00 00 ff ff 00 00 00 00 00 00 00 00 00 00 ff ff
70: 00 00 00 00 01 f0 00 00 01 00 01 00 10 00 00 00
80: 00 00 00 00 00 00 00 00 00 80 c7 7d 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 0b f2 c9 35 10 ac c0 00 a8 a8 a8 a8 ff 00 b6 b6
b0: 0f 0f 1f 1f 34 00 00 00 00 00 20 00 00 00 00 00
c0: 00 02 00 00 00 00 00 00 00 02 00 00 00 00 00 00
d0: 82 01 00 00 00 00 00 00 02 01 00 00 00 00 00 00
e0: 01 00 02 00 00 00 00 00 50 01 49 32 06 11 49 32
f0: 00 00 70 00 00 00 00 00 00 00 00 00 00 00 00 00

ata5: SATA max UDMA/133 port i16@0xdc00 bmdma 0xd400 irq 19
ata6: SATA max UDMA/133 port i16@0xd880 bmdma 0xd408 irq 19
ata7: PATA max UDMA/133 port i16@0xd800 bmdma 0xd410 irq 19
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata5.00: ATA-8: TS32GSSD25S-M, V1210, max UDMA/100
ata5.00: 62586880 sectors, multi 0: LBA48 NCQ (depth 0/1)
ata5.00: applying bridge limits
ata5.00: configured for UDMA/100
scsi 4:0:0:0: Direct-Access     ATA      TS32GSSD25S-M    V121 PQ: 0 ANSI: 5
sd 4:0:0:0: Attached scsi generic sg2 type 0
sd 4:0:0:0: [sdb] 62586880 512-byte hardware sectors: (32.0 GB/29.8 GiB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdb] Attached SCSI disk
ata6: SATA link down (SStatus 0 SControl 310)

*** running the test program ***

ata5.00: exception Emask 0x12 SAct 0x0 SErr 0x1000500 action 0x6 frozen
ata5: SError: { UnrecovData Proto TrStaTrns }
ata5.00: cmd c8/00:00:e0:21:00/00:00:00:00:00/e0 tag 0 dma 131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x16 (ATA bus error)
ata5.00: status: { DRDY }
ata5: hard resetting link
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata5.00: configured for UDMA/100
ata5.00: device reported invalid CHS sector 0
ata5: EH complete
-- 
Krzysztof Halasa
