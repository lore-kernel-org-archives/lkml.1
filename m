Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZLYJW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZLYJW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 04:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZLYJWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 04:22:25 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:49971 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZLYJWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 04:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Eqjn5VB+dZ9SbJN3S8lNL4s5RyTnbMADb050rSlOWM9UM7LrgXTyrNJwmlADLnMHZP
         QLcdBKYalOuE5J8ryfBtQKk5iP34HlZKkygAs5E+e3HPwij2qmgkUulJwlf1NN2BjwMO
         G9iz9cD7AsX+CbU+GF4rAZ7bHxBcPxjMPKipE=
MIME-Version: 1.0
Date: Fri, 25 Dec 2009 10:22:17 +0100
Message-ID: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>
Subject: MSI broken in libata?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Content-Type: multipart/mixed; boundary=001517478afc8d25a4047b8a1721
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001517478afc8d25a4047b8a1721
Content-Type: text/plain; charset=ISO-8859-1

As reported in http://lkml.org/lkml/2009/12/19/82 the new MSI support
for sata_sil24 does not work for me.
This is still the same with 2.6.33-rc2.

Why I think, this might be a problem within libata:
 * other drivers can use MSI successful on my system (tg3, radeon, hda-intel)
 * happens both in sata_sil24 and sata_nv
 * the count in /proc/interrupts increases for the MSIs assigned to
sata_sil24/sata_nv, so interrupt delivery seems to work
 * only writing seems to fail

These are the changes in /proc/interrupts:
Normal boot, without additional cmdline options:
-  4:          0          0         96        174   IO-APIC-edge      serial

- 19:      18058          2          3       4738   IO-APIC-fasteoi
sata_sil24, bttv0, Bt87x audio
- 21:          0          0          0          0   IO-APIC-fasteoi   sata_nv
- 22:          0          0          0          0   IO-APIC-fasteoi   sata_nv
- 23:        872        357          4       1514   IO-APIC-fasteoi
sata_nv, ohci_hcd:usb2

- 29:          4        405          0        140   PCI-MSI-edge      HDA Intel
- 30:          0          0          0          3   PCI-MSI-edge      eth0
- 31:       3354          0          0         38   PCI-MSI-edge      eth1

Boot with sata_nv.msi=1 and sata_sil24.msi=1, only booted into a
rescue shell, thats why serial and eth0+1 are missing:
+ 19:          0          0          0          1   IO-APIC-fasteoi
bttv0, Bt87x audio
+ 23:          0          0          5         13   IO-APIC-fasteoi
ohci_hcd:usb2

+ 29:          0          0          0         73   PCI-MSI-edge      sata_sil24
+ 30:          0          0          0       2590   PCI-MSI-edge      sata_nv
+ 31:          0          0          0          0   PCI-MSI-edge      sata_nv
+ 32:          0          0          0          0   PCI-MSI-edge      sata_nv
+ 33:          0          0          0         89   PCI-MSI-edge      HDA Intel

Attached is the output from lspci -vv from a normal boot and from a
boot with MSI enabled for both libata drivers.
The errors messages from libata and other information about my system
can be found in http://lkml.org/lkml/2009/12/19/82 ,or just ask if you
need to know something else.

Here are the differences from the lspci-outputs:

lspci-vv-rc2.txt: complete, normal boot
lspci-vv-rc2.msi.txt: init=/bin/sash, MSI for sata_sil24+sata_nv,
network cards not initialised
--- lspci-vv-rc2.txt	2009-12-25 00:11:19.992078760 +0100
+++ lspci-vv-rc2.msi.txt	2009-12-25 00:04:26.713756803 +0100
@@ -1,631 +1,586 @@
 00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1) (prog-if
8a [Master SecP PriP])
 	Subsystem: ASUSTeK Computer Inc. Device 81f0
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0 (750ns min, 250ns max)
 	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
-	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
+	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
 	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
-	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
+	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
 	Region 4: I/O ports at ffa0 [size=16]
 	Capabilities: [44] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

 00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev
a3) (prog-if 85 [Master SecO PriO])
 	Subsystem: ASUSTeK Computer Inc. Device 81f0
-	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
+	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0 (750ns min, 250ns max)
-	Interrupt: pin A routed to IRQ 23
+	Interrupt: pin A routed to IRQ 30
 	Region 0: I/O ports at cc00 [size=8]
 	Region 1: I/O ports at c880 [size=4]
 	Region 2: I/O ports at c800 [size=8]
 	Region 3: I/O ports at c480 [size=4]
 	Region 4: I/O ports at c400 [size=16]
 	Region 5: Memory at efafb000 (32-bit, non-prefetchable) [size=4K]
 	Capabilities: [44] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
-	Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
-		Address: 0000000000000000  Data: 0000
+	Capabilities: [b0] MSI: Enable+ Count=1/4 Maskable- 64bit+
+		Address: 00000000fee0f00c  Data: 4189
 	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+

 00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev
a3) (prog-if 85 [Master SecO PriO])
 	Subsystem: ASUSTeK Computer Inc. Device 81f0
-	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
+	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0 (750ns min, 250ns max)
-	Interrupt: pin B routed to IRQ 22
+	Interrupt: pin B routed to IRQ 31
 	Region 0: I/O ports at c080 [size=8]
 	Region 1: I/O ports at c000 [size=4]
 	Region 2: I/O ports at bc00 [size=8]
 	Region 3: I/O ports at b880 [size=4]
 	Region 4: I/O ports at b800 [size=16]
 	Region 5: Memory at efafa000 (32-bit, non-prefetchable) [size=4K]
 	Capabilities: [44] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
-	Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
-		Address: 0000000000000000  Data: 0000
+	Capabilities: [b0] MSI: Enable+ Count=1/4 Maskable- 64bit+
+		Address: 00000000fee0f00c  Data: 4199
 	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+

 00:05.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev
a3) (prog-if 85 [Master SecO PriO])
 	Subsystem: ASUSTeK Computer Inc. Device 81f0
-	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
+	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0 (750ns min, 250ns max)
-	Interrupt: pin C routed to IRQ 21
+	Interrupt: pin C routed to IRQ 32
 	Region 0: I/O ports at b480 [size=8]
 	Region 1: I/O ports at b400 [size=4]
 	Region 2: I/O ports at b080 [size=8]
 	Region 3: I/O ports at b000 [size=4]
 	Region 4: I/O ports at ac00 [size=16]
 	Region 5: Memory at efaf9000 (32-bit, non-prefetchable) [size=4K]
 	Capabilities: [44] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
-	Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
-		Address: 0000000000000000  Data: 0000
+	Capabilities: [b0] MSI: Enable+ Count=1/4 Maskable- 64bit+
+		Address: 00000000fee0f00c  Data: 41a9
 	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+

 00:06.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)
 	Subsystem: ASUSTeK Computer Inc. Device 8210
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0 (500ns min, 1250ns max)
-	Interrupt: pin B routed to IRQ 29
+	Interrupt: pin B routed to IRQ 33
 	Region 0: Memory at efafc000 (32-bit, non-prefetchable) [size=16K]
 	Capabilities: [44] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable+ 64bit+
-		Address: 00000000fee0200c  Data: 41b1
+		Address: 00000000fee0f00c  Data: 41d1
 		Masking: 00000000  Pending: 00000000
 	Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+

 00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev
a3) (prog-if 00 [Normal decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
 	I/O behind bridge: 0000d000-0000dfff
 	Memory behind bridge: efb00000-efbfffff
 	Prefetchable memory behind bridge: 00000000e0000000-00000000e7ffffff
-	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
+	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
 	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 	Capabilities: [40] Subsystem: nVidia Corporation Device 0000
 	Capabilities: [48] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
 		Address: 00000000fee0f00c  Data: 4161
 	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
 		Mapping Address Base: 00000000fee00000
 	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
 		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
 			ExtTag- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
 			MaxPayload 128 bytes, MaxReadReq 512 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
 		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0
<512ns, L1 <4us
 			ClockPM- Surprise- LLActRep+ BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
 			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
 			Control: AttnInd Off, PwrInd On, Power- Interlock-
 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
 			Changed: MRL- PresDet+ LinkState+
 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
 		RootCap: CRSVisible-
 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-

 01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60
[Radeon X300 (PCIE)] (prog-if 00 [VGA controller])
 	Subsystem: ASUSTeK Computer Inc. Device 0083
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Interrupt: pin A routed to IRQ 28
 	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
 	Region 1: I/O ports at d000 [size=256]
 	Region 2: Memory at efbf0000 (32-bit, non-prefetchable) [size=64K]
 	Expansion ROM at efbc0000 [disabled] [size=128K]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [58] Express (v1) Endpoint, MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
 			MaxPayload 128 bytes, MaxReadReq 128 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
 		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0
<128ns, L1 <1us
 			ClockPM- Surprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
-		Address: 00000000fee0100c  Data: 4171
+		Address: 00000000fee0f00c  Data: 4171

 02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5754
Gigabit Ethernet PCI Express (rev 02)
 	Subsystem: ASUSTeK Computer Inc. Device 8209
-	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
+	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
-	Interrupt: pin A routed to IRQ 31
+	Interrupt: pin A routed to IRQ 17
 	Region 0: Memory at efcf0000 (64-bit, non-prefetchable) [size=64K]
-	Expansion ROM at <ignored> [disabled]
 	Capabilities: [48] Power Management version 3
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
 	Capabilities: [50] Vital Product Data
-		Product Name: Broadcom NetXtreme Gigabit Ethernet Controller
-		Read-only fields:
-			[PN] Part number: BCM95700A6
-			[EC] Engineering changes: 106679-15
-			[SN] Serial number: 0123456789
-			[MN] Manufacture ID: 31 34 65 34
-			[RV] Reserved: checksum bad, 26 byte(s) reserved
-		Read/write fields:
-			[YA] Asset tag: XYZ01234567
-			[RW] Read-write area: 107 byte(s) free
-		End
+		Not readable
 	Capabilities: [58] Vendor Specific Information <?>
-	Capabilities: [e8] MSI: Enable+ Count=1/1 Maskable- 64bit+
+	Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
 		Address: 00000000fee0100c  Data: 41c1
 	Capabilities: [d0] Express (v1) Endpoint, MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 4096 bytes
-		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
+		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <4us, L1 <64us
 			ClockPM- Surprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-

 03:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5754
Gigabit Ethernet PCI Express (rev 02)
 	Subsystem: ASUSTeK Computer Inc. Device 8209
-	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
+	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
-	Interrupt: pin A routed to IRQ 30
+	Interrupt: pin A routed to IRQ 18
 	Region 0: Memory at efdf0000 (64-bit, non-prefetchable) [size=64K]
-	Expansion ROM at <ignored> [disabled]
 	Capabilities: [48] Power Management version 3
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
 	Capabilities: [50] Vital Product Data
-		Product Name: Broadcom NetXtreme Gigabit Ethernet Controller
-		Read-only fields:
-			[PN] Part number: BCM95700A6
-			[EC] Engineering changes: 106679-15
-			[SN] Serial number: 0123456789
-			[MN] Manufacture ID: 31 34 65 34
-			[RV] Reserved: checksum bad, 26 byte(s) reserved
-		Read/write fields:
-			[YA] Asset tag: XYZ01234567
-			[RW] Read-write area: 107 byte(s) free
-		End
+		Not readable
 	Capabilities: [58] Vendor Specific Information <?>
-	Capabilities: [e8] MSI: Enable+ Count=1/1 Maskable- 64bit+
+	Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
 		Address: 00000000fee0f00c  Data: 41b9
 	Capabilities: [d0] Express (v1) Endpoint, MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 4096 bytes
-		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
+		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <4us, L1 <64us
 			ClockPM- Surprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-

 04:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial
ATA Raid II Controller (rev 01)
 	Subsystem: ASUSTeK Computer Inc. Device 819f
-	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
+	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
-	Interrupt: pin A routed to IRQ 19
+	Interrupt: pin A routed to IRQ 29
 	Region 0: Memory at efeffc00 (64-bit, non-prefetchable) [size=128]
 	Region 2: Memory at efef8000 (64-bit, non-prefetchable) [size=16K]
 	Region 4: I/O ports at ec00 [size=128]
 	Expansion ROM at efe00000 [disabled] [size=512K]
 	Capabilities: [54] Power Management version 2
 		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
-	Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
-		Address: 0000000000000000  Data: 0000
+	Capabilities: [5c] MSI: Enable+ Count=1/1 Maskable- 64bit+
+		Address: 00000000fee0f00c  Data: 4179
 	Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
 		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 4096 bytes
 		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0
unlimited, L1 unlimited
 			ClockPM- Surprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-

--001517478afc8d25a4047b8a1721
Content-Type: text/plain; charset=US-ASCII; name="lspci-vv-rc2.txt"
Content-Disposition: attachment; filename="lspci-vv-rc2.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3mqj7i70

MDA6MDAuMCBSQU0gbWVtb3J5OiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQNTUgTWVtb3J5IENvbnRy
b2xsZXIgKHJldiBhMikKCVN1YnN5c3RlbTogQVNVU1RlSyBDb21wdXRlciBJbmMuIERldmljZSA4
MWYwCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZH
QVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSKyBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVz
OiBDYXArIDY2TUh6KyBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0g
PFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMAoJQ2FwYWJp
bGl0aWVzOiBbNDRdIEh5cGVyVHJhbnNwb3J0OiBTbGF2ZSBvciBQcmltYXJ5IEludGVyZmFjZQoJ
CUNvbW1hbmQ6IEJhc2VVbml0SUQ9MCBVbml0Q250PTE1IE1hc3RIb3N0LSBEZWZEaXItIERVTC0K
CQlMaW5rIENvbnRyb2wgMDogQ0ZsRSsgQ1NULSBDRkUtIDxMa0ZhaWwtIEluaXQrIEVPQy0gVFhP
LSA8Q1JDRXJyPTAgSXNvY0VuLSBMU0VuKyBFeHRDVEwtIDY0Yi0KCQlMaW5rIENvbmZpZyAwOiBN
TFdJPTE2Yml0IER3RmNJbi0gTUxXTz0xNmJpdCBEd0ZjT3V0LSBMV0k9MTZiaXQgRHdGY0luRW4t
IExXTz0xNmJpdCBEd0ZjT3V0RW4tCgkJTGluayBDb250cm9sIDE6IENGbEUtIENTVC0gQ0ZFLSA8
TGtGYWlsKyBJbml0LSBFT0MrIFRYTysgPENSQ0Vycj0wIElzb2NFbi0gTFNFbi0gRXh0Q1RMLSA2
NGItCgkJTGluayBDb25maWcgMTogTUxXST04Yml0IER3RmNJbi0gTUxXTz04Yml0IER3RmNPdXQt
IExXST04Yml0IER3RmNJbkVuLSBMV089OGJpdCBEd0ZjT3V0RW4tCgkJUmV2aXNpb24gSUQ6IDEu
MDMKCQlMaW5rIEZyZXF1ZW5jeSAwOiAxLjBHSHoKCQlMaW5rIEVycm9yIDA6IDxQcm90LSA8T3Zm
bC0gPEVPQy0gQ1RMVG0tCgkJTGluayBGcmVxdWVuY3kgQ2FwYWJpbGl0eSAwOiAyMDBNSHorIDMw
ME1IeisgNDAwTUh6KyA1MDBNSHorIDYwME1IeisgODAwTUh6KyAxLjBHSHorIDEuMkdIei0gMS40
R0h6LSAxLjZHSHotIFZlbmQtCgkJRmVhdHVyZSBDYXBhYmlsaXR5OiBJc29jRkMrIExEVFNUT1Ar
IENSQ1RNLSBFQ1RMVC0gNjRiQS0gVUlEUkQtCgkJTGluayBGcmVxdWVuY3kgMTogMjAwTUh6CgkJ
TGluayBFcnJvciAxOiA8UHJvdC0gPE92ZmwtIDxFT0MtIENUTFRtLQoJCUxpbmsgRnJlcXVlbmN5
IENhcGFiaWxpdHkgMTogMjAwTUh6LSAzMDBNSHotIDQwME1Iei0gNTAwTUh6LSA2MDBNSHotIDgw
ME1Iei0gMS4wR0h6LSAxLjJHSHotIDEuNEdIei0gMS42R0h6LSBWZW5kLQoJCUVycm9yIEhhbmRs
aW5nOiBQRmxFKyBPRmxFKyBQRkUtIE9GRS0gRU9DRkUtIFJGRS0gQ1JDRkUtIFNFUlJGRS0gQ0Yt
IFJFLSBQTkZFLSBPTkZFLSBFT0NORkUtIFJORkUtIENSQ05GRS0gU0VSUk5GRS0KCQlQcmVmZXRj
aGFibGUgbWVtb3J5IGJlaGluZCBicmlkZ2UgVXBwZXI6IDAwLTAwCgkJQnVzIE51bWJlcjogMDAK
CUNhcGFiaWxpdGllczogW2RjXSBIeXBlclRyYW5zcG9ydDogTVNJIE1hcHBpbmcgRW5hYmxlKyBG
aXhlZC0KCQlNYXBwaW5nIEFkZHJlc3MgQmFzZTogMDAwMDAwMDBmZWUwMDAwMAoKMDA6MDEuMCBJ
U0EgYnJpZGdlOiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQNTUgTFBDIEJyaWRnZSAocmV2IGEzKQoJ
U3Vic3lzdGVtOiBBU1VTVGVLIENvbXB1dGVyIEluYy4gRGV2aWNlIDgxZjAKCUNvbnRyb2w6IEkv
TysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZSsgTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0g
U3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcC0gNjZNSHorIFVE
Ri0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0
LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglSZWdpb24gMDogSS9PIHBvcnRzIGF0
IDJmMDAgW3NpemU9MTI4XQoKMDA6MDEuMSBTTUJ1czogblZpZGlhIENvcnBvcmF0aW9uIE1DUDU1
IFNNQnVzIChyZXYgYTMpCglTdWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2Ug
ODFmMAoJQ29udHJvbDogSS9PKyBNZW0tIEJ1c01hc3Rlci0gU3BlY0N5Y2xlLSBNZW1XSU5WLSBW
R0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1
czogQ2FwKyA2Nk1IeisgVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQt
IDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUludGVycnVwdDogcGluIEEg
cm91dGVkIHRvIElSUSAxMQoJUmVnaW9uIDA6IEkvTyBwb3J0cyBhdCBhODgwIFtzaXplPTY0XQoJ
UmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCAyYTAwIFtzaXplPTY0XQoJUmVnaW9uIDU6IEkvTyBwb3J0
cyBhdCAyYTgwIFtzaXplPTY0XQoJQ2FwYWJpbGl0aWVzOiBbNDRdIFBvd2VyIE1hbmFnZW1lbnQg
dmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBN
RShEMC0sRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1F
LUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBuRm9y
Y2UyX3NtYnVzCgowMDowMi4wIFVTQiBDb250cm9sbGVyOiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQ
NTUgVVNCIENvbnRyb2xsZXIgKHJldiBhMSkgKHByb2ctaWYgMTAgW09IQ0ldKQoJU3Vic3lzdGVt
OiBBU1VTVGVLIENvbXB1dGVyIEluYy4gRGV2aWNlIDgxZjAKCUNvbnRyb2w6IEkvTysgTWVtKyBC
dXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmct
IFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHorIFVERi0gRmFzdEIy
QisgUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0g
PFBFUlItIElOVHgtCglMYXRlbmN5OiAwICg3NTBucyBtaW4sIDI1MG5zIG1heCkKCUludGVycnVw
dDogcGluIEEgcm91dGVkIHRvIElSUSAyMwoJUmVnaW9uIDA6IE1lbW9yeSBhdCBlZmFmODAwMCAo
MzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT00S10KCUNhcGFiaWxpdGllczogWzQ0XSBQ
b3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDErIEQyKyBB
dXhDdXJyZW50PTBtQSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBE
MCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglLZXJuZWwgZHJp
dmVyIGluIHVzZTogb2hjaV9oY2QKCjAwOjAyLjEgVVNCIENvbnRyb2xsZXI6IG5WaWRpYSBDb3Jw
b3JhdGlvbiBNQ1A1NSBVU0IgQ29udHJvbGxlciAocmV2IGEyKSAocHJvZy1pZiAyMCBbRUhDSV0p
CglTdWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2UgODFmMAoJQ29udHJvbDog
SS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJy
LSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Ieisg
VURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJv
cnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAgKDc1MG5zIG1pbiwgMjUwbnMgbWF4
KQoJSW50ZXJydXB0OiBwaW4gQiByb3V0ZWQgdG8gSVJRIDIwCglSZWdpb24gMDogTWVtb3J5IGF0
IGVmYWViYzAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTI1Nl0KCUNhcGFiaWxp
dGllczogWzQ0XSBEZWJ1ZyBwb3J0OiBCQVI9MSBvZmZzZXQ9MDA5OAoJQ2FwYWJpbGl0aWVzOiBb
ODBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMSsg
RDIrIEF1eEN1cnJlbnQ9MG1BIFBNRShEMCssRDErLEQyKyxEM2hvdCssRDNjb2xkKykKCQlTdGF0
dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBlaGNpX2hjZAoKMDA6MDQuMCBJREUgaW50ZXJmYWNlOiBuVmlkaWEg
Q29ycG9yYXRpb24gTUNQNTUgSURFIChyZXYgYTEpIChwcm9nLWlmIDhhIFtNYXN0ZXIgU2VjUCBQ
cmlQXSkKCVN1YnN5c3RlbTogQVNVU1RlSyBDb21wdXRlciBJbmMuIERldmljZSA4MWYwCglDb250
cm9sOiBJL08rIE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQ
YXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2
TUh6KyBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0g
PE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCAoNzUwbnMgbWluLCAyNTBu
cyBtYXgpCglSZWdpb24gMDogW3ZpcnR1YWxdIE1lbW9yeSBhdCAwMDAwMDFmMCAoMzItYml0LCBu
b24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT04XQoJUmVnaW9uIDE6IFt2aXJ0dWFsXSBNZW1vcnkgYXQg
MDAwMDAzZjAgKHR5cGUgMywgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MV0KCVJlZ2lvbiAyOiBb
dmlydHVhbF0gTWVtb3J5IGF0IDAwMDAwMTcwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtz
aXplPThdCglSZWdpb24gMzogW3ZpcnR1YWxdIE1lbW9yeSBhdCAwMDAwMDM3MCAodHlwZSAzLCBu
b24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0xXQoJUmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCBmZmEwIFtz
aXplPTE2XQoJQ2FwYWJpbGl0aWVzOiBbNDRdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJ
RmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQy
LSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNl
bD0wIERTY2FsZT0wIFBNRS0KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBwYXRhX2FtZAoKMDA6MDUu
MCBJREUgaW50ZXJmYWNlOiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQNTUgU0FUQSBDb250cm9sbGVy
IChyZXYgYTMpIChwcm9nLWlmIDg1IFtNYXN0ZXIgU2VjTyBQcmlPXSkKCVN1YnN5c3RlbTogQVNV
U1RlSyBDb21wdXRlciBJbmMuIERldmljZSA4MWYwCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJS
LSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6KyBVREYtIEZhc3RCMkIrIFBh
ckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJS
LSBJTlR4LQoJTGF0ZW5jeTogMCAoNzUwbnMgbWluLCAyNTBucyBtYXgpCglJbnRlcnJ1cHQ6IHBp
biBBIHJvdXRlZCB0byBJUlEgMjMKCVJlZ2lvbiAwOiBJL08gcG9ydHMgYXQgY2MwMCBbc2l6ZT04
XQoJUmVnaW9uIDE6IEkvTyBwb3J0cyBhdCBjODgwIFtzaXplPTRdCglSZWdpb24gMjogSS9PIHBv
cnRzIGF0IGM4MDAgW3NpemU9OF0KCVJlZ2lvbiAzOiBJL08gcG9ydHMgYXQgYzQ4MCBbc2l6ZT00
XQoJUmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCBjNDAwIFtzaXplPTE2XQoJUmVnaW9uIDU6IE1lbW9y
eSBhdCBlZmFmYjAwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT00S10KCUNhcGFi
aWxpdGllczogWzQ0XSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGst
IERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3QtLEQzY29s
ZC0pCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQ
TUUtCglDYXBhYmlsaXRpZXM6IFtiMF0gTVNJOiBFbmFibGUtIENvdW50PTEvNCBNYXNrYWJsZS0g
NjRiaXQrCgkJQWRkcmVzczogMDAwMDAwMDAwMDAwMDAwMCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0
aWVzOiBbY2NdIEh5cGVyVHJhbnNwb3J0OiBNU0kgTWFwcGluZyBFbmFibGUtIEZpeGVkKwoJS2Vy
bmVsIGRyaXZlciBpbiB1c2U6IHNhdGFfbnYKCjAwOjA1LjEgSURFIGludGVyZmFjZTogblZpZGlh
IENvcnBvcmF0aW9uIE1DUDU1IFNBVEEgQ29udHJvbGxlciAocmV2IGEzKSAocHJvZy1pZiA4NSBb
TWFzdGVyIFNlY08gUHJpT10pCglTdWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZp
Y2UgODFmMAoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5W
LSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0
YXR1czogQ2FwKyA2Nk1IeisgVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJv
cnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAgKDc1
MG5zIG1pbiwgMjUwbnMgbWF4KQoJSW50ZXJydXB0OiBwaW4gQiByb3V0ZWQgdG8gSVJRIDIyCglS
ZWdpb24gMDogSS9PIHBvcnRzIGF0IGMwODAgW3NpemU9OF0KCVJlZ2lvbiAxOiBJL08gcG9ydHMg
YXQgYzAwMCBbc2l6ZT00XQoJUmVnaW9uIDI6IEkvTyBwb3J0cyBhdCBiYzAwIFtzaXplPThdCglS
ZWdpb24gMzogSS9PIHBvcnRzIGF0IGI4ODAgW3NpemU9NF0KCVJlZ2lvbiA0OiBJL08gcG9ydHMg
YXQgYjgwMCBbc2l6ZT0xNl0KCVJlZ2lvbiA1OiBNZW1vcnkgYXQgZWZhZmEwMDAgKDMyLWJpdCwg
bm9uLXByZWZldGNoYWJsZSkgW3NpemU9NEtdCglDYXBhYmlsaXRpZXM6IFs0NF0gUG93ZXIgTWFu
YWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVu
dD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1czogRDAgTm9Tb2Z0
UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbYjBd
IE1TSTogRW5hYmxlLSBDb3VudD0xLzQgTWFza2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAw
MDAwMDAwMDAwMDAgIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogW2NjXSBIeXBlclRyYW5zcG9y
dDogTVNJIE1hcHBpbmcgRW5hYmxlLSBGaXhlZCsKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBzYXRh
X252CgowMDowNS4yIElERSBpbnRlcmZhY2U6IG5WaWRpYSBDb3Jwb3JhdGlvbiBNQ1A1NSBTQVRB
IENvbnRyb2xsZXIgKHJldiBhMykgKHByb2ctaWYgODUgW01hc3RlciBTZWNPIFByaU9dKQoJU3Vi
c3lzdGVtOiBBU1VTVGVLIENvbXB1dGVyIEluYy4gRGV2aWNlIDgxZjAKCUNvbnRyb2w6IEkvTysg
TWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3Rl
cHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHorIFVERi0g
RmFzdEIyQisgUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+
U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwICg3NTBucyBtaW4sIDI1MG5zIG1heCkKCUlu
dGVycnVwdDogcGluIEMgcm91dGVkIHRvIElSUSAyMQoJUmVnaW9uIDA6IEkvTyBwb3J0cyBhdCBi
NDgwIFtzaXplPThdCglSZWdpb24gMTogSS9PIHBvcnRzIGF0IGI0MDAgW3NpemU9NF0KCVJlZ2lv
biAyOiBJL08gcG9ydHMgYXQgYjA4MCBbc2l6ZT04XQoJUmVnaW9uIDM6IEkvTyBwb3J0cyBhdCBi
MDAwIFtzaXplPTRdCglSZWdpb24gNDogSS9PIHBvcnRzIGF0IGFjMDAgW3NpemU9MTZdCglSZWdp
b24gNTogTWVtb3J5IGF0IGVmYWY5MDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXpl
PTRLXQoJQ2FwYWJpbGl0aWVzOiBbNDRdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxh
Z3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxE
M2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0w
IERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogW2IwXSBNU0k6IEVuYWJsZS0gQ291bnQ9MS80
IE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMDAwMDAwMDAwICBEYXRhOiAwMDAw
CglDYXBhYmlsaXRpZXM6IFtjY10gSHlwZXJUcmFuc3BvcnQ6IE1TSSBNYXBwaW5nIEVuYWJsZS0g
Rml4ZWQrCglLZXJuZWwgZHJpdmVyIGluIHVzZTogc2F0YV9udgoKMDA6MDYuMCBQQ0kgYnJpZGdl
OiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQNTUgUENJIGJyaWRnZSAocmV2IGEyKSAocHJvZy1pZiAw
MSBbU3VidHJhY3RpdmUgZGVjb2RlXSkKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNw
ZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RC
MkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHorIFVERi0gRmFzdEIyQisgUGFyRXJyLSBE
RVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgt
CglMYXRlbmN5OiAwCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wNSwgc3Vib3JkaW5hdGU9
MDUsIHNlYy1sYXRlbmN5PTY0CglNZW1vcnkgYmVoaW5kIGJyaWRnZTogZWZmMDAwMDAtZWZmZmZm
ZmYKCVByZWZldGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTogZWVmMDAwMDAtZWVmZmZmZmYK
CVNlY29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1tZWRpdW0g
PlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPFNFUlItIDxQRVJSLQoJQnJpZGdlQ3RsOiBQYXJp
dHktIFNFUlIrIE5vSVNBLSBWR0EtIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJCVByaURpc2NU
bXItIFNlY0Rpc2NUbXIrIERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVz
OiBbYjhdIFN1YnN5c3RlbTogblZpZGlhIENvcnBvcmF0aW9uIERldmljZSBjYjg0CglDYXBhYmls
aXRpZXM6IFs4Y10gSHlwZXJUcmFuc3BvcnQ6IE1TSSBNYXBwaW5nIEVuYWJsZS0gRml4ZWQtCgkJ
TWFwcGluZyBBZGRyZXNzIEJhc2U6IDAwMDAwMDAwZmVlMDAwMDAKCjAwOjA2LjEgQXVkaW8gZGV2
aWNlOiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQNTUgSGlnaCBEZWZpbml0aW9uIEF1ZGlvIChyZXYg
YTIpCglTdWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2UgODIxMAoJQ29udHJv
bDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFy
RXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeCsKCVN0YXR1czogQ2FwKyA2Nk1I
eisgVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxN
QWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAgKDUwMG5zIG1pbiwgMTI1MG5z
IG1heCkKCUludGVycnVwdDogcGluIEIgcm91dGVkIHRvIElSUSAyOQoJUmVnaW9uIDA6IE1lbW9y
eSBhdCBlZmFmYzAwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0xNktdCglDYXBh
YmlsaXRpZXM6IFs0NF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xr
LSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90KyxEM2Nv
bGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAg
UE1FLQoJQ2FwYWJpbGl0aWVzOiBbNTBdIE1TSTogRW5hYmxlKyBDb3VudD0xLzEgTWFza2FibGUr
IDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAwZmVlMDIwMGMgIERhdGE6IDQxYjEKCQlNYXNraW5n
OiAwMDAwMDAwMCAgUGVuZGluZzogMDAwMDAwMDAKCUNhcGFiaWxpdGllczogWzZjXSBIeXBlclRy
YW5zcG9ydDogTVNJIE1hcHBpbmcgRW5hYmxlLSBGaXhlZCsKCUtlcm5lbCBkcml2ZXIgaW4gdXNl
OiBIREEgSW50ZWwKCjAwOjBiLjAgUENJIGJyaWRnZTogblZpZGlhIENvcnBvcmF0aW9uIE1DUDU1
IFBDSSBFeHByZXNzIGJyaWRnZSAocmV2IGEzKSAocHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0p
CglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNu
b29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBD
YXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRB
Ym9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGlu
ZSBTaXplOiA2NCBieXRlcwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MDQsIHN1Ym9yZGlu
YXRlPTA0LCBzZWMtbGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGUwMDAtMDAwMGVm
ZmYKCU1lbW9yeSBiZWhpbmQgYnJpZGdlOiBlZmUwMDAwMC1lZmVmZmZmZgoJU2Vjb25kYXJ5IHN0
YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9y
dC0gPE1BYm9ydC0gPFNFUlItIDxQRVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlIrIE5vSVNB
LSBWR0EtIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJCVByaURpc2NUbXItIFNlY0Rpc2NUbXIt
IERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVzOiBbNDBdIFN1YnN5c3Rl
bTogblZpZGlhIENvcnBvcmF0aW9uIERldmljZSAwMDAwCglDYXBhYmlsaXRpZXM6IFs0OF0gUG93
ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4
Q3VycmVudD0wbUEgUE1FKEQwKyxEMSssRDIrLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAg
Tm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVz
OiBbNTBdIE1TSTogRW5hYmxlKyBDb3VudD0xLzIgTWFza2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6
IDAwMDAwMDAwZmVlMGYwMGMgIERhdGE6IDQxNDkKCUNhcGFiaWxpdGllczogWzYwXSBIeXBlclRy
YW5zcG9ydDogTVNJIE1hcHBpbmcgRW5hYmxlLSBGaXhlZC0KCQlNYXBwaW5nIEFkZHJlc3MgQmFz
ZTogMDAwMDAwMDBmZWUwMDAwMAoJQ2FwYWJpbGl0aWVzOiBbODBdIEV4cHJlc3MgKHYxKSBSb290
IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDI1NiBieXRlcywgUGhh
bnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0gUkJFKyBGTFJl
c2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0
YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkKyBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBO
b1Nub29wKwoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSA1MTIgYnl0ZXMKCQlE
ZXZTdGE6CUNvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyLSBU
cmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICM0LCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQ
TSBMMHMgTDEsIExhdGVuY3kgTDAgPDUxMm5zLCBMMSA8NHVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMg
RGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGstCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWRE
aXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBU
ckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQtIEFCV01nbXQtCgkJU2x0Q2Fw
OglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0gSG90UGx1Zy0gU3VycGlz
ZS0KCQkJU2xvdCAjICAwLCBQb3dlckxpbWl0IDAuMDAwMDAwOyBJbnRlcmxvY2stIE5vQ29tcGwt
CgkJU2x0Q3RsOglFbmFibGU6IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0LSBDbWRDcGx0
LSBIUElycS0gTGlua0NoZy0KCQkJQ29udHJvbDogQXR0bkluZCBPZmYsIFB3ckluZCBPbiwgUG93
ZXItIEludGVybG9jay0KCQlTbHRTdGE6CVN0YXR1czogQXR0bkJ0bi0gUG93ZXJGbHQtIE1STC0g
Q21kQ3BsdC0gUHJlc0RldCsgSW50ZXJsb2NrLQoJCQlDaGFuZ2VkOiBNUkwtIFByZXNEZXQrIExp
bmtTdGF0ZSsKCQlSb290Q3RsOiBFcnJDb3JyZWN0YWJsZS0gRXJyTm9uLUZhdGFsLSBFcnJGYXRh
bC0gUE1FSW50RW5hLSBDUlNWaXNpYmxlLQoJCVJvb3RDYXA6IENSU1Zpc2libGUtCgkJUm9vdFN0
YTogUE1FIFJlcUlEIDAwMDAsIFBNRVN0YXR1cy0gUE1FUGVuZGluZy0KCUtlcm5lbCBkcml2ZXIg
aW4gdXNlOiBwY2llcG9ydAoKMDA6MGMuMCBQQ0kgYnJpZGdlOiBuVmlkaWEgQ29ycG9yYXRpb24g
TUNQNTUgUENJIEV4cHJlc3MgYnJpZGdlIChyZXYgYTMpIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVj
b2RlXSkKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0g
VkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0
dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0
LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNo
ZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wMywgc3Vi
b3JkaW5hdGU9MDMsIHNlYy1sYXRlbmN5PTAKCU1lbW9yeSBiZWhpbmQgYnJpZGdlOiBlZmQwMDAw
MC1lZmRmZmZmZgoJU2Vjb25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVW
U0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPFNFUlItIDxQRVJSLQoJQnJpZGdl
Q3RsOiBQYXJpdHktIFNFUlIrIE5vSVNBLSBWR0EtIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJ
CVByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2Fw
YWJpbGl0aWVzOiBbNDBdIFN1YnN5c3RlbTogblZpZGlhIENvcnBvcmF0aW9uIERldmljZSAwMDAw
CglDYXBhYmlsaXRpZXM6IFs0OF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczog
UE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMSssRDIrLEQzaG90
KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNj
YWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNTBdIE1TSTogRW5hYmxlKyBDb3VudD0xLzIgTWFz
a2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAwZmVlMGYwMGMgIERhdGE6IDQxNTEKCUNh
cGFiaWxpdGllczogWzYwXSBIeXBlclRyYW5zcG9ydDogTVNJIE1hcHBpbmcgRW5hYmxlLSBGaXhl
ZC0KCQlNYXBwaW5nIEFkZHJlc3MgQmFzZTogMDAwMDAwMDBmZWUwMDAwMAoJQ2FwYWJpbGl0aWVz
OiBbODBdIEV4cHJlc3MgKHYxKSBSb290IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJRGV2Q2FwOglN
YXhQYXlsb2FkIDI1NiBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8
MXVzCgkJCUV4dFRhZy0gUkJFKyBGTFJlc2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29y
cmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkKyBFeHRU
YWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wKwoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywg
TWF4UmVhZFJlcSA1MTIgYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnItIFVuY29yckVyci0gRmF0YWxF
cnItIFVuc3VwcFJlcS0gQXV4UHdyLSBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMzLCBTcGVl
ZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIExhdGVuY3kgTDAgPDUxMm5zLCBMMSA8
NHVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BN
IERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4
dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNw
ZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBC
V01nbXQtIEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQt
IFB3ckluZC0gSG90UGx1Zy0gU3VycGlzZS0KCQkJU2xvdCAjICAwLCBQb3dlckxpbWl0IDAuMDAw
MDAwOyBJbnRlcmxvY2stIE5vQ29tcGwtCgkJU2x0Q3RsOglFbmFibGU6IEF0dG5CdG4tIFB3ckZs
dC0gTVJMLSBQcmVzRGV0LSBDbWRDcGx0LSBIUElycS0gTGlua0NoZy0KCQkJQ29udHJvbDogQXR0
bkluZCBPZmYsIFB3ckluZCBPbiwgUG93ZXItIEludGVybG9jay0KCQlTbHRTdGE6CVN0YXR1czog
QXR0bkJ0bi0gUG93ZXJGbHQtIE1STC0gQ21kQ3BsdC0gUHJlc0RldCsgSW50ZXJsb2NrLQoJCQlD
aGFuZ2VkOiBNUkwtIFByZXNEZXQrIExpbmtTdGF0ZSsKCQlSb290Q3RsOiBFcnJDb3JyZWN0YWJs
ZS0gRXJyTm9uLUZhdGFsLSBFcnJGYXRhbC0gUE1FSW50RW5hLSBDUlNWaXNpYmxlLQoJCVJvb3RD
YXA6IENSU1Zpc2libGUtCgkJUm9vdFN0YTogUE1FIFJlcUlEIDAwMDAsIFBNRVN0YXR1cy0gUE1F
UGVuZGluZy0KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAoKMDA6MGQuMCBQQ0kgYnJp
ZGdlOiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQNTUgUENJIEV4cHJlc3MgYnJpZGdlIChyZXYgYTMp
IChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0
ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIt
IEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFy
RXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlIt
IElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglCdXM6IHByaW1h
cnk9MDAsIHNlY29uZGFyeT0wMiwgc3Vib3JkaW5hdGU9MDIsIHNlYy1sYXRlbmN5PTAKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBlZmMwMDAwMC1lZmNmZmZmZgoJU2Vjb25kYXJ5IHN0YXR1czogNjZN
SHotIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9y
dCsgPFNFUlItIDxQRVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlIrIE5vSVNBLSBWR0EtIE1B
Ym9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJCVByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJT
dGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVzOiBbNDBdIFN1YnN5c3RlbTogblZpZGlh
IENvcnBvcmF0aW9uIERldmljZSAwMDAwCglDYXBhYmlsaXRpZXM6IFs0OF0gUG93ZXIgTWFuYWdl
bWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0w
bUEgUE1FKEQwKyxEMSssRDIrLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0
LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNTBdIE1T
STogRW5hYmxlKyBDb3VudD0xLzIgTWFza2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAw
ZmVlMGYwMGMgIERhdGE6IDQxNTkKCUNhcGFiaWxpdGllczogWzYwXSBIeXBlclRyYW5zcG9ydDog
TVNJIE1hcHBpbmcgRW5hYmxlLSBGaXhlZC0KCQlNYXBwaW5nIEFkZHJlc3MgQmFzZTogMDAwMDAw
MDBmZWUwMDAwMAoJQ2FwYWJpbGl0aWVzOiBbODBdIEV4cHJlc3MgKHYxKSBSb290IFBvcnQgKFNs
b3QrKSwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDI1NiBieXRlcywgUGhhbnRGdW5jIDAs
IExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0gUkJFKyBGTFJlc2V0LQoJCURl
dkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3Vw
cG9ydGVkLQoJCQlSbHhkT3JkKyBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wKwoJ
CQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSA1MTIgYnl0ZXMKCQlEZXZTdGE6CUNv
cnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyLSBUcmFuc1BlbmQt
CgkJTG5rQ2FwOglQb3J0ICMyLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEs
IExhdGVuY3kgTDAgPDUxMm5zLCBMMSA8NHVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJl
cCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQt
IFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50
LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJh
aW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQtIEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRu
LSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0gSG90UGx1Zy0gU3VycGlzZS0KCQkJU2xv
dCAjICAwLCBQb3dlckxpbWl0IDAuMDAwMDAwOyBJbnRlcmxvY2stIE5vQ29tcGwtCgkJU2x0Q3Rs
OglFbmFibGU6IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0LSBDbWRDcGx0LSBIUElycS0g
TGlua0NoZy0KCQkJQ29udHJvbDogQXR0bkluZCBPZmYsIFB3ckluZCBPbiwgUG93ZXItIEludGVy
bG9jay0KCQlTbHRTdGE6CVN0YXR1czogQXR0bkJ0bi0gUG93ZXJGbHQtIE1STC0gQ21kQ3BsdC0g
UHJlc0RldCsgSW50ZXJsb2NrLQoJCQlDaGFuZ2VkOiBNUkwtIFByZXNEZXQrIExpbmtTdGF0ZSsK
CQlSb290Q3RsOiBFcnJDb3JyZWN0YWJsZS0gRXJyTm9uLUZhdGFsLSBFcnJGYXRhbC0gUE1FSW50
RW5hLSBDUlNWaXNpYmxlLQoJCVJvb3RDYXA6IENSU1Zpc2libGUtCgkJUm9vdFN0YTogUE1FIFJl
cUlEIDAwMDAsIFBNRVN0YXR1cy0gUE1FUGVuZGluZy0KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBw
Y2llcG9ydAoKMDA6MGYuMCBQQ0kgYnJpZGdlOiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQNTUgUENJ
IEV4cHJlc3MgYnJpZGdlIChyZXYgYTMpIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNv
bnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3At
IFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsg
NjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0
LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNp
emU6IDY0IGJ5dGVzCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wMSwgc3Vib3JkaW5hdGU9
MDEsIHNlYy1sYXRlbmN5PTAKCUkvTyBiZWhpbmQgYnJpZGdlOiAwMDAwZDAwMC0wMDAwZGZmZgoJ
TWVtb3J5IGJlaGluZCBicmlkZ2U6IGVmYjAwMDAwLWVmYmZmZmZmCglQcmVmZXRjaGFibGUgbWVt
b3J5IGJlaGluZCBicmlkZ2U6IDAwMDAwMDAwZTAwMDAwMDAtMDAwMDAwMDBlN2ZmZmZmZgoJU2Vj
b25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9y
dC0gPFRBYm9ydC0gPE1BYm9ydC0gPFNFUlItIDxQRVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNF
UlIrIE5vSVNBLSBWR0ErIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJCVByaURpc2NUbXItIFNl
Y0Rpc2NUbXItIERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVzOiBbNDBd
IFN1YnN5c3RlbTogblZpZGlhIENvcnBvcmF0aW9uIERldmljZSAwMDAwCglDYXBhYmlsaXRpZXM6
IFs0OF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQx
LSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMSssRDIrLEQzaG90KyxEM2NvbGQrKQoJCVN0
YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2Fw
YWJpbGl0aWVzOiBbNTBdIE1TSTogRW5hYmxlKyBDb3VudD0xLzIgTWFza2FibGUtIDY0Yml0KwoJ
CUFkZHJlc3M6IDAwMDAwMDAwZmVlMGYwMGMgIERhdGE6IDQxNjEKCUNhcGFiaWxpdGllczogWzYw
XSBIeXBlclRyYW5zcG9ydDogTVNJIE1hcHBpbmcgRW5hYmxlLSBGaXhlZC0KCQlNYXBwaW5nIEFk
ZHJlc3MgQmFzZTogMDAwMDAwMDBmZWUwMDAwMAoJQ2FwYWJpbGl0aWVzOiBbODBdIEV4cHJlc3Mg
KHYxKSBSb290IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDI1NiBi
eXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0g
UkJFKyBGTFJlc2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1G
YXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkKyBFeHRUYWctIFBoYW50RnVuYy0g
QXV4UHdyLSBOb1Nub29wKwoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSA1MTIg
Ynl0ZXMKCQlEZXZTdGE6CUNvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0g
QXV4UHdyLSBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMwLCBTcGVlZCAyLjVHVC9zLCBXaWR0
aCB4MTYsIEFTUE0gTDBzIEwxLCBMYXRlbmN5IEwwIDw1MTJucywgTDEgPDR1cwoJCQlDbG9ja1BN
LSBTdXJwcmlzZS0gTExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNC
IDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJCQlFeHRTeW5jaC0gQ2xvY2tQ
TS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBX
aWR0aCB4MTYsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3RpdmUrIEJXTWdtdC0gQUJXTWdt
dC0KCQlTbHRDYXA6CUF0dG5CdG4tIFB3ckN0cmwtIE1STC0gQXR0bkluZC0gUHdySW5kLSBIb3RQ
bHVnLSBTdXJwaXNlLQoJCQlTbG90ICMgIDAsIFBvd2VyTGltaXQgMC4wMDAwMDA7IEludGVybG9j
ay0gTm9Db21wbC0KCQlTbHRDdGw6CUVuYWJsZTogQXR0bkJ0bi0gUHdyRmx0LSBNUkwtIFByZXNE
ZXQtIENtZENwbHQtIEhQSXJxLSBMaW5rQ2hnLQoJCQlDb250cm9sOiBBdHRuSW5kIE9mZiwgUHdy
SW5kIE9uLCBQb3dlci0gSW50ZXJsb2NrLQoJCVNsdFN0YToJU3RhdHVzOiBBdHRuQnRuLSBQb3dl
ckZsdC0gTVJMLSBDbWRDcGx0LSBQcmVzRGV0KyBJbnRlcmxvY2stCgkJCUNoYW5nZWQ6IE1STC0g
UHJlc0RldCsgTGlua1N0YXRlKwoJCVJvb3RDdGw6IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0
YWwtIEVyckZhdGFsLSBQTUVJbnRFbmEtIENSU1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJs
ZS0KCQlSb290U3RhOiBQTUUgUmVxSUQgMDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoJS2Vy
bmVsIGRyaXZlciBpbiB1c2U6IHBjaWVwb3J0CgowMDoxOC4wIEhvc3QgYnJpZGdlOiBBZHZhbmNl
ZCBNaWNybyBEZXZpY2VzIFtBTURdIEs4IFtBdGhsb242NC9PcHRlcm9uXSBIeXBlclRyYW5zcG9y
dCBUZWNobm9sb2d5IENvbmZpZ3VyYXRpb24KCUNvbnRyb2w6IEkvTy0gTWVtLSBCdXNNYXN0ZXIt
IFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZh
c3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJy
LSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElO
VHgtCglDYXBhYmlsaXRpZXM6IFs4MF0gSHlwZXJUcmFuc3BvcnQ6IEhvc3Qgb3IgU2Vjb25kYXJ5
IEludGVyZmFjZQoJCUNvbW1hbmQ6IFdhcm1Sc3QrIERibEVuZC0gRGV2TnVtPTAgQ2hhaW5TaWRl
LSBIb3N0SGlkZSsgU2xhdmUtIDxFT0NFcnItIERVTC0KCQlMaW5rIENvbnRyb2w6IENGbEUtIENT
VC0gQ0ZFLSA8TGtGYWlsLSBJbml0KyBFT0MtIFRYTy0gPENSQ0Vycj0wIElzb2NFbi0gTFNFbi0g
RXh0Q1RMLSA2NGItCgkJTGluayBDb25maWc6IE1MV0k9MTZiaXQgRHdGY0luLSBNTFdPPTE2Yml0
IER3RmNPdXQtIExXST0xNmJpdCBEd0ZjSW5Fbi0gTFdPPTE2Yml0IER3RmNPdXRFbi0KCQlSZXZp
c2lvbiBJRDogMS4wMgoJCUxpbmsgRnJlcXVlbmN5OiAxLjBHSHoKCQlMaW5rIEVycm9yOiA8UHJv
dC0gPE92ZmwtIDxFT0MtIENUTFRtLQoJCUxpbmsgRnJlcXVlbmN5IENhcGFiaWxpdHk6IDIwME1I
eisgMzAwTUh6LSA0MDBNSHorIDUwME1Iei0gNjAwTUh6KyA4MDBNSHorIDEuMEdIeisgMS4yR0h6
LSAxLjRHSHotIDEuNkdIei0gVmVuZC0KCQlGZWF0dXJlIENhcGFiaWxpdHk6IElzb2NGQy0gTERU
U1RPUCsgQ1JDVE0tIEVDVExULSA2NGJBLSBVSURSRC0gRXh0UlMtIFVDbmZFLQoJQ2FwYWJpbGl0
aWVzOiBbYTBdIEh5cGVyVHJhbnNwb3J0OiBIb3N0IG9yIFNlY29uZGFyeSBJbnRlcmZhY2UKCQlD
b21tYW5kOiBXYXJtUnN0KyBEYmxFbmQtIERldk51bT0wIENoYWluU2lkZS0gSG9zdEhpZGUrIFNs
YXZlLSA8RU9DRXJyLSBEVUwtCgkJTGluayBDb250cm9sOiBDRmxFLSBDU1QtIENGRS0gPExrRmFp
bC0gSW5pdCsgRU9DLSBUWE8tIDxDUkNFcnI9MCBJc29jRW4tIExTRW4tIEV4dENUTC0gNjRiLQoJ
CUxpbmsgQ29uZmlnOiBNTFdJPTE2Yml0IER3RmNJbi0gTUxXTz0xNmJpdCBEd0ZjT3V0LSBMV0k9
MTZiaXQgRHdGY0luRW4tIExXTz0xNmJpdCBEd0ZjT3V0RW4tCgkJUmV2aXNpb24gSUQ6IDEuMDIK
CQlMaW5rIEZyZXF1ZW5jeTogMS4wR0h6CgkJTGluayBFcnJvcjogPFByb3QtIDxPdmZsLSA8RU9D
LSBDVExUbS0KCQlMaW5rIEZyZXF1ZW5jeSBDYXBhYmlsaXR5OiAyMDBNSHorIDMwME1Iei0gNDAw
TUh6KyA1MDBNSHotIDYwME1IeisgODAwTUh6KyAxLjBHSHorIDEuMkdIei0gMS40R0h6LSAxLjZH
SHotIFZlbmQtCgkJRmVhdHVyZSBDYXBhYmlsaXR5OiBJc29jRkMtIExEVFNUT1ArIENSQ1RNLSBF
Q1RMVC0gNjRiQS0gVUlEUkQtIEV4dFJTLSBVQ25mRS0KCUNhcGFiaWxpdGllczogW2MwXSBIeXBl
clRyYW5zcG9ydDogSG9zdCBvciBTZWNvbmRhcnkgSW50ZXJmYWNlCgkJQ29tbWFuZDogV2FybVJz
dCsgRGJsRW5kLSBEZXZOdW09MCBDaGFpblNpZGUtIEhvc3RIaWRlKyBTbGF2ZS0gPEVPQ0Vyci0g
RFVMLQoJCUxpbmsgQ29udHJvbDogQ0ZsRS0gQ1NULSBDRkUtIDxMa0ZhaWwrIEluaXQtIEVPQysg
VFhPKyA8Q1JDRXJyPTAgSXNvY0VuLSBMU0VuLSBFeHRDVEwtIDY0Yi0KCQlMaW5rIENvbmZpZzog
TUxXST0xNmJpdCBEd0ZjSW4tIE1MV089MTZiaXQgRHdGY091dC0gTFdJPU4vQyBEd0ZjSW5Fbi0g
TFdPPU4vQyBEd0ZjT3V0RW4tCgkJUmV2aXNpb24gSUQ6IDEuMDIKCQlMaW5rIEZyZXF1ZW5jeTog
MjAwTUh6CgkJTGluayBFcnJvcjogPFByb3QtIDxPdmZsLSA8RU9DLSBDVExUbS0KCQlMaW5rIEZy
ZXF1ZW5jeSBDYXBhYmlsaXR5OiAyMDBNSHorIDMwME1Iei0gNDAwTUh6KyA1MDBNSHotIDYwME1I
eisgODAwTUh6KyAxLjBHSHorIDEuMkdIei0gMS40R0h6LSAxLjZHSHotIFZlbmQtCgkJRmVhdHVy
ZSBDYXBhYmlsaXR5OiBJc29jRkMtIExEVFNUT1ArIENSQ1RNLSBFQ1RMVC0gNjRiQS0gVUlEUkQt
IEV4dFJTLSBVQ25mRS0KCjAwOjE4LjEgSG9zdCBicmlkZ2U6IEFkdmFuY2VkIE1pY3JvIERldmlj
ZXMgW0FNRF0gSzggW0F0aGxvbjY0L09wdGVyb25dIEFkZHJlc3MgTWFwCglDb250cm9sOiBJL08t
IE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0
ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2TUh6LSBVREYt
IEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0g
PlNFUlItIDxQRVJSLSBJTlR4LQoKMDA6MTguMiBIb3N0IGJyaWRnZTogQWR2YW5jZWQgTWljcm8g
RGV2aWNlcyBbQU1EXSBLOCBbQXRobG9uNjQvT3B0ZXJvbl0gRFJBTSBDb250cm9sbGVyCglDb250
cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQ
YXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2
TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0g
PE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGFtZDY0
X2VkYWMKCjAwOjE4LjMgSG9zdCBicmlkZ2U6IEFkdmFuY2VkIE1pY3JvIERldmljZXMgW0FNRF0g
SzggW0F0aGxvbjY0L09wdGVyb25dIE1pc2NlbGxhbmVvdXMgQ29udHJvbAoJQ29udHJvbDogSS9P
LSBNZW0tIEJ1c01hc3Rlci0gU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBT
dGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURG
LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQt
ID5TRVJSLSA8UEVSUi0gSU5UeC0KCUNhcGFiaWxpdGllczogW2YwXSBTZWN1cmUgZGV2aWNlIDw/
PgoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGs4dGVtcAoKMDA6MTkuMCBIb3N0IGJyaWRnZTogQWR2
YW5jZWQgTWljcm8gRGV2aWNlcyBbQU1EXSBLOCBbQXRobG9uNjQvT3B0ZXJvbl0gSHlwZXJUcmFu
c3BvcnQgVGVjaG5vbG9neSBDb25maWd1cmF0aW9uCglDb250cm9sOiBJL08tIE1lbS0gQnVzTWFz
dGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJS
LSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBh
ckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJS
LSBJTlR4LQoJQ2FwYWJpbGl0aWVzOiBbODBdIEh5cGVyVHJhbnNwb3J0OiBIb3N0IG9yIFNlY29u
ZGFyeSBJbnRlcmZhY2UKCQlDb21tYW5kOiBXYXJtUnN0KyBEYmxFbmQtIERldk51bT0wIENoYWlu
U2lkZS0gSG9zdEhpZGUrIFNsYXZlLSA8RU9DRXJyLSBEVUwtCgkJTGluayBDb250cm9sOiBDRmxF
LSBDU1QtIENGRS0gPExrRmFpbCsgSW5pdC0gRU9DKyBUWE8rIDxDUkNFcnI9MCBJc29jRW4tIExT
RW4tIEV4dENUTC0gNjRiLQoJCUxpbmsgQ29uZmlnOiBNTFdJPTE2Yml0IER3RmNJbi0gTUxXTz0x
NmJpdCBEd0ZjT3V0LSBMV0k9Ti9DIER3RmNJbkVuLSBMV089Ti9DIER3RmNPdXRFbi0KCQlSZXZp
c2lvbiBJRDogMS4wMgoJCUxpbmsgRnJlcXVlbmN5OiAyMDBNSHoKCQlMaW5rIEVycm9yOiA8UHJv
dC0gPE92ZmwtIDxFT0MtIENUTFRtLQoJCUxpbmsgRnJlcXVlbmN5IENhcGFiaWxpdHk6IDIwME1I
eisgMzAwTUh6LSA0MDBNSHorIDUwME1Iei0gNjAwTUh6KyA4MDBNSHorIDEuMEdIeisgMS4yR0h6
LSAxLjRHSHotIDEuNkdIei0gVmVuZC0KCQlGZWF0dXJlIENhcGFiaWxpdHk6IElzb2NGQy0gTERU
U1RPUCsgQ1JDVE0tIEVDVExULSA2NGJBLSBVSURSRC0gRXh0UlMtIFVDbmZFLQoJQ2FwYWJpbGl0
aWVzOiBbYTBdIEh5cGVyVHJhbnNwb3J0OiBIb3N0IG9yIFNlY29uZGFyeSBJbnRlcmZhY2UKCQlD
b21tYW5kOiBXYXJtUnN0KyBEYmxFbmQtIERldk51bT0wIENoYWluU2lkZS0gSG9zdEhpZGUrIFNs
YXZlLSA8RU9DRXJyLSBEVUwtCgkJTGluayBDb250cm9sOiBDRmxFLSBDU1QtIENGRS0gPExrRmFp
bC0gSW5pdCsgRU9DLSBUWE8tIDxDUkNFcnI9MCBJc29jRW4tIExTRW4tIEV4dENUTC0gNjRiLQoJ
CUxpbmsgQ29uZmlnOiBNTFdJPTE2Yml0IER3RmNJbi0gTUxXTz0xNmJpdCBEd0ZjT3V0LSBMV0k9
MTZiaXQgRHdGY0luRW4tIExXTz0xNmJpdCBEd0ZjT3V0RW4tCgkJUmV2aXNpb24gSUQ6IDEuMDIK
CQlMaW5rIEZyZXF1ZW5jeTogMS4wR0h6CgkJTGluayBFcnJvcjogPFByb3QtIDxPdmZsLSA8RU9D
LSBDVExUbS0KCQlMaW5rIEZyZXF1ZW5jeSBDYXBhYmlsaXR5OiAyMDBNSHorIDMwME1Iei0gNDAw
TUh6KyA1MDBNSHotIDYwME1IeisgODAwTUh6KyAxLjBHSHorIDEuMkdIei0gMS40R0h6LSAxLjZH
SHotIFZlbmQtCgkJRmVhdHVyZSBDYXBhYmlsaXR5OiBJc29jRkMtIExEVFNUT1ArIENSQ1RNLSBF
Q1RMVC0gNjRiQS0gVUlEUkQtIEV4dFJTLSBVQ25mRS0KCUNhcGFiaWxpdGllczogW2MwXSBIeXBl
clRyYW5zcG9ydDogSG9zdCBvciBTZWNvbmRhcnkgSW50ZXJmYWNlCgkJQ29tbWFuZDogV2FybVJz
dCsgRGJsRW5kLSBEZXZOdW09MCBDaGFpblNpZGUtIEhvc3RIaWRlKyBTbGF2ZS0gPEVPQ0Vyci0g
RFVMLQoJCUxpbmsgQ29udHJvbDogQ0ZsRS0gQ1NULSBDRkUtIDxMa0ZhaWwrIEluaXQtIEVPQysg
VFhPKyA8Q1JDRXJyPTAgSXNvY0VuLSBMU0VuLSBFeHRDVEwtIDY0Yi0KCQlMaW5rIENvbmZpZzog
TUxXST0xNmJpdCBEd0ZjSW4tIE1MV089MTZiaXQgRHdGY091dC0gTFdJPU4vQyBEd0ZjSW5Fbi0g
TFdPPU4vQyBEd0ZjT3V0RW4tCgkJUmV2aXNpb24gSUQ6IDEuMDIKCQlMaW5rIEZyZXF1ZW5jeTog
MjAwTUh6CgkJTGluayBFcnJvcjogPFByb3QtIDxPdmZsLSA8RU9DLSBDVExUbS0KCQlMaW5rIEZy
ZXF1ZW5jeSBDYXBhYmlsaXR5OiAyMDBNSHorIDMwME1Iei0gNDAwTUh6KyA1MDBNSHotIDYwME1I
eisgODAwTUh6KyAxLjBHSHorIDEuMkdIei0gMS40R0h6LSAxLjZHSHotIFZlbmQtCgkJRmVhdHVy
ZSBDYXBhYmlsaXR5OiBJc29jRkMtIExEVFNUT1ArIENSQ1RNLSBFQ1RMVC0gNjRiQS0gVUlEUkQt
IEV4dFJTLSBVQ25mRS0KCjAwOjE5LjEgSG9zdCBicmlkZ2U6IEFkdmFuY2VkIE1pY3JvIERldmlj
ZXMgW0FNRF0gSzggW0F0aGxvbjY0L09wdGVyb25dIEFkZHJlc3MgTWFwCglDb250cm9sOiBJL08t
IE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0
ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2TUh6LSBVREYt
IEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0g
PlNFUlItIDxQRVJSLSBJTlR4LQoKMDA6MTkuMiBIb3N0IGJyaWRnZTogQWR2YW5jZWQgTWljcm8g
RGV2aWNlcyBbQU1EXSBLOCBbQXRobG9uNjQvT3B0ZXJvbl0gRFJBTSBDb250cm9sbGVyCglDb250
cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQ
YXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2
TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0g
PE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGFtZDY0
X2VkYWMKCjAwOjE5LjMgSG9zdCBicmlkZ2U6IEFkdmFuY2VkIE1pY3JvIERldmljZXMgW0FNRF0g
SzggW0F0aGxvbjY0L09wdGVyb25dIE1pc2NlbGxhbmVvdXMgQ29udHJvbAoJQ29udHJvbDogSS9P
LSBNZW0tIEJ1c01hc3Rlci0gU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBT
dGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURG
LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQt
ID5TRVJSLSA8UEVSUi0gSU5UeC0KCUNhcGFiaWxpdGllczogW2YwXSBTZWN1cmUgZGV2aWNlIDw/
PgoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGs4dGVtcAoKMDE6MDAuMCBWR0EgY29tcGF0aWJsZSBj
b250cm9sbGVyOiBBVEkgVGVjaG5vbG9naWVzIEluYyBSVjM3MCA1QjYwIFtSYWRlb24gWDMwMCAo
UENJRSldIChwcm9nLWlmIDAwIFtWR0EgY29udHJvbGxlcl0pCglTdWJzeXN0ZW06IEFTVVNUZUsg
Q29tcHV0ZXIgSW5jLiBEZXZpY2UgMDA4MwoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3Rlcisg
U3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFz
dEIyQi0gRGlzSU5UeCsKCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnIt
IERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5U
eC0KCUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUludGVycnVwdDogcGlu
IEEgcm91dGVkIHRvIElSUSAyOAoJUmVnaW9uIDA6IE1lbW9yeSBhdCBlMDAwMDAwMCAoMzItYml0
LCBwcmVmZXRjaGFibGUpIFtzaXplPTEyOE1dCglSZWdpb24gMTogSS9PIHBvcnRzIGF0IGQwMDAg
W3NpemU9MjU2XQoJUmVnaW9uIDI6IE1lbW9yeSBhdCBlZmJmMDAwMCAoMzItYml0LCBub24tcHJl
ZmV0Y2hhYmxlKSBbc2l6ZT02NEtdCglFeHBhbnNpb24gUk9NIGF0IGVmYmMwMDAwIFtkaXNhYmxl
ZF0gW3NpemU9MTI4S10KCUNhcGFiaWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNp
b24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDErIEQyKyBBdXhDdXJyZW50PTBtQSBQTUUoRDAt
LEQxLSxEMi0sRDNob3QtLEQzY29sZC0pCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFi
bGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs1OF0gRXhwcmVzcyAodjEp
IEVuZHBvaW50LCBNU0kgMDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBQaGFudEZ1
bmMgMCwgTGF0ZW5jeSBMMHMgPDEyOG5zLCBMMSA8MnVzCgkJCUV4dFRhZysgQXR0bkJ0bi0gQXR0
bkluZC0gUHdySW5kLSBSQkUtIEZMUmVzZXQtCgkJRGV2Q3RsOglSZXBvcnQgZXJyb3JzOiBDb3Jy
ZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBwb3J0ZWQtCgkJCVJseGRPcmQrIEV4dFRh
Zy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3ArCgkJCU1heFBheWxvYWQgMTI4IGJ5dGVzLCBN
YXhSZWFkUmVxIDEyOCBieXRlcwoJCURldlN0YToJQ29yckVyci0gVW5jb3JyRXJyLSBGYXRhbEVy
ci0gVW5zdXBwUmVxLSBBdXhQd3ItIFRyYW5zUGVuZC0KCQlMbmtDYXA6CVBvcnQgIzAsIFNwZWVk
IDIuNUdUL3MsIFdpZHRoIHgxNiwgQVNQTSBMMHMgTDEsIExhdGVuY3kgTDAgPDEyOG5zLCBMMSA8
MXVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcC0gQndOb3QtCgkJTG5rQ3RsOglBU1BN
IERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGstCgkJCUV4
dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNw
ZWVkIDIuNUdUL3MsIFdpZHRoIHgxNiwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZS0g
QldNZ210LSBBQldNZ210LQoJQ2FwYWJpbGl0aWVzOiBbODBdIE1TSTogRW5hYmxlKyBDb3VudD0x
LzEgTWFza2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAwZmVlMDEwMGMgIERhdGE6IDQx
NzEKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiByYWRlb24KCjAxOjAwLjEgRGlzcGxheSBjb250cm9s
bGVyOiBBVEkgVGVjaG5vbG9naWVzIEluYyBSVjM3MCBbUmFkZW9uIFgzMDBTRV0KCVN1YnN5c3Rl
bTogQVNVU1RlSyBDb21wdXRlciBJbmMuIERldmljZSAwMDgyCglDb250cm9sOiBJL08rIE1lbSsg
QnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5n
LSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlIt
IDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJUmVn
aW9uIDA6IE1lbW9yeSBhdCBlZmJlMDAwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6
ZT02NEtdCglDYXBhYmlsaXRpZXM6IFs1MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlG
bGFnczogUE1FQ2xrLSBEU0ktIEQxKyBEMisgQXV4Q3VycmVudD0wbUEgUE1FKEQwLSxEMS0sRDIt
LEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2Vs
PTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNThdIEV4cHJlc3MgKHYxKSBFbmRwb2lu
dCwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExh
dGVuY3kgTDBzIDwxMjhucywgTDEgPDJ1cwoJCQlFeHRUYWctIEF0dG5CdG4tIEF0dG5JbmQtIFB3
ckluZC0gUkJFLSBGTFJlc2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUt
IE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkLSBFeHRUYWctIFBoYW50
RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJl
cSAxMjggYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3Vw
cFJlcS0gQXV4UHdyLSBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMwLCBTcGVlZCAyLjVHVC9z
LCBXaWR0aCB4MTYsIEFTUE0gTDBzIEwxLCBMYXRlbmN5IEwwIDwxMjhucywgTDEgPDF1cwoJCQlD
bG9ja1BNLSBTdXJwcmlzZS0gTExBY3RSZXAtIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxl
ZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJCQlFeHRTeW5jaC0g
Q2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVH
VC9zLCBXaWR0aCB4MTYsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3RpdmUtIEJXTWdtdC0g
QUJXTWdtdC0KCjAyOjAwLjAgRXRoZXJuZXQgY29udHJvbGxlcjogQnJvYWRjb20gQ29ycG9yYXRp
b24gTmV0WHRyZW1lIEJDTTU3NTQgR2lnYWJpdCBFdGhlcm5ldCBQQ0kgRXhwcmVzcyAocmV2IDAy
KQoJU3Vic3lzdGVtOiBBU1VTVGVLIENvbXB1dGVyIEluYy4gRGV2aWNlIDgyMDkKCUNvbnRyb2w6
IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVy
ci0gU3RlcHBpbmctIFNFUlIrIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsgNjZNSHot
IFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFi
b3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0
IGJ5dGVzCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMzEKCVJlZ2lvbiAwOiBNZW1v
cnkgYXQgZWZjZjAwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9NjRLXQoJRXhw
YW5zaW9uIFJPTSBhdCA8aWdub3JlZD4gW2Rpc2FibGVkXQoJQ2FwYWJpbGl0aWVzOiBbNDhdIFBv
d2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1
eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQw
IE5vU29mdFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0xIFBNRS0KCUNhcGFiaWxpdGll
czogWzUwXSBWaXRhbCBQcm9kdWN0IERhdGEKCQlQcm9kdWN0IE5hbWU6IEJyb2FkY29tIE5ldFh0
cmVtZSBHaWdhYml0IEV0aGVybmV0IENvbnRyb2xsZXIKCQlSZWFkLW9ubHkgZmllbGRzOgoJCQlb
UE5dIFBhcnQgbnVtYmVyOiBCQ005NTcwMEE2CgkJCVtFQ10gRW5naW5lZXJpbmcgY2hhbmdlczog
MTA2Njc5LTE1CgkJCVtTTl0gU2VyaWFsIG51bWJlcjogMDEyMzQ1Njc4OQoJCQlbTU5dIE1hbnVm
YWN0dXJlIElEOiAzMSAzNCA2NSAzNAoJCQlbUlZdIFJlc2VydmVkOiBjaGVja3N1bSBiYWQsIDI2
IGJ5dGUocykgcmVzZXJ2ZWQKCQlSZWFkL3dyaXRlIGZpZWxkczoKCQkJW1lBXSBBc3NldCB0YWc6
IFhZWjAxMjM0NTY3CgkJCVtSV10gUmVhZC13cml0ZSBhcmVhOiAxMDcgYnl0ZShzKSBmcmVlCgkJ
RW5kCglDYXBhYmlsaXRpZXM6IFs1OF0gVmVuZG9yIFNwZWNpZmljIEluZm9ybWF0aW9uIDw/PgoJ
Q2FwYWJpbGl0aWVzOiBbZThdIE1TSTogRW5hYmxlKyBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0
KwoJCUFkZHJlc3M6IDAwMDAwMDAwZmVlMDEwMGMgIERhdGE6IDQxYzEKCUNhcGFiaWxpdGllczog
W2QwXSBFeHByZXNzICh2MSkgRW5kcG9pbnQsIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5bG9hZCAx
MjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NHVzLCBMMSB1bmxpbWl0ZWQKCQkJ
RXh0VGFnKyBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6
CVJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJTWF4
UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgNDA5NiBieXRlcwoJCURldlN0YToJQ29yckVy
ci0gVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBBdXhQd3IrIFRyYW5zUGVuZC0KCQlM
bmtDYXA6CVBvcnQgIzAsIFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcywgTGF0ZW5j
eSBMMCA8NHVzLCBMMSA8NjR1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0gTExBY3RSZXAtIEJ3Tm90
LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWlu
LSBDb21tQ2xrKwoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJ
bnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgVHJFcnItIFRyYWluLSBTbG90
Q2xrKyBETEFjdGl2ZS0gQldNZ210LSBBQldNZ210LQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHRn
MwoKMDM6MDAuMCBFdGhlcm5ldCBjb250cm9sbGVyOiBCcm9hZGNvbSBDb3Jwb3JhdGlvbiBOZXRY
dHJlbWUgQkNNNTc1NCBHaWdhYml0IEV0aGVybmV0IFBDSSBFeHByZXNzIChyZXYgMDIpCglTdWJz
eXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2UgODIwOQoJQ29udHJvbDogSS9PLSBN
ZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVw
cGluZy0gU0VSUisgRmFzdEIyQi0gRGlzSU5UeCsKCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBG
YXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5T
RVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMK
CUludGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAzMAoJUmVnaW9uIDA6IE1lbW9yeSBhdCBl
ZmRmMDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT02NEtdCglFeHBhbnNpb24g
Uk9NIGF0IDxpZ25vcmVkPiBbZGlzYWJsZWRdCglDYXBhYmlsaXRpZXM6IFs0OF0gUG93ZXIgTWFu
YWdlbWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVu
dD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0
UnN0KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTEgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNTBd
IFZpdGFsIFByb2R1Y3QgRGF0YQoJCVByb2R1Y3QgTmFtZTogQnJvYWRjb20gTmV0WHRyZW1lIEdp
Z2FiaXQgRXRoZXJuZXQgQ29udHJvbGxlcgoJCVJlYWQtb25seSBmaWVsZHM6CgkJCVtQTl0gUGFy
dCBudW1iZXI6IEJDTTk1NzAwQTYKCQkJW0VDXSBFbmdpbmVlcmluZyBjaGFuZ2VzOiAxMDY2Nzkt
MTUKCQkJW1NOXSBTZXJpYWwgbnVtYmVyOiAwMTIzNDU2Nzg5CgkJCVtNTl0gTWFudWZhY3R1cmUg
SUQ6IDMxIDM0IDY1IDM0CgkJCVtSVl0gUmVzZXJ2ZWQ6IGNoZWNrc3VtIGJhZCwgMjYgYnl0ZShz
KSByZXNlcnZlZAoJCVJlYWQvd3JpdGUgZmllbGRzOgoJCQlbWUFdIEFzc2V0IHRhZzogWFlaMDEy
MzQ1NjcKCQkJW1JXXSBSZWFkLXdyaXRlIGFyZWE6IDEwNyBieXRlKHMpIGZyZWUKCQlFbmQKCUNh
cGFiaWxpdGllczogWzU4XSBWZW5kb3IgU3BlY2lmaWMgSW5mb3JtYXRpb24gPD8+CglDYXBhYmls
aXRpZXM6IFtlOF0gTVNJOiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQrCgkJQWRk
cmVzczogMDAwMDAwMDBmZWUwZjAwYyAgRGF0YTogNDFiOQoJQ2FwYWJpbGl0aWVzOiBbZDBdIEV4
cHJlc3MgKHYxKSBFbmRwb2ludCwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRl
cywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw0dXMsIEwxIHVubGltaXRlZAoJCQlFeHRUYWcr
IEF0dG5CdG4tIEF0dG5JbmQtIFB3ckluZC0gUkJFKyBGTFJlc2V0LQoJCURldkN0bDoJUmVwb3J0
IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlS
bHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXlsb2Fk
IDEyOCBieXRlcywgTWF4UmVhZFJlcSA0MDk2IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBVbmNv
cnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQZW5kLQoJCUxua0NhcDoJ
UG9ydCAjMCwgU3BlZWQgMi41R1QvcywgV2lkdGggeDEsIEFTUE0gTDBzLCBMYXRlbmN5IEwwIDw0
dXMsIEwxIDw2NHVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcC0gQndOb3QtCgkJTG5r
Q3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1D
bGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlM
bmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERM
QWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCglLZXJuZWwgZHJpdmVyIGluIHVzZTogdGczCgowNDow
MC4wIE1hc3Mgc3RvcmFnZSBjb250cm9sbGVyOiBTaWxpY29uIEltYWdlLCBJbmMuIFNpSSAzMTMy
IFNlcmlhbCBBVEEgUmFpZCBJSSBDb250cm9sbGVyIChyZXYgMDEpCglTdWJzeXN0ZW06IEFTVVNU
ZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2UgODE5ZgoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3Rl
cisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUisg
RmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJF
cnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0g
SU5UeC0KCUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUludGVycnVwdDog
cGluIEEgcm91dGVkIHRvIElSUSAxOQoJUmVnaW9uIDA6IE1lbW9yeSBhdCBlZmVmZmMwMCAoNjQt
Yml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0xMjhdCglSZWdpb24gMjogTWVtb3J5IGF0IGVm
ZWY4MDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTE2S10KCVJlZ2lvbiA0OiBJ
L08gcG9ydHMgYXQgZWMwMCBbc2l6ZT0xMjhdCglFeHBhbnNpb24gUk9NIGF0IGVmZTAwMDAwIFtk
aXNhYmxlZF0gW3NpemU9NTEyS10KCUNhcGFiaWxpdGllczogWzU0XSBQb3dlciBNYW5hZ2VtZW50
IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSSsgRDErIEQyKyBBdXhDdXJyZW50PTBtQSBQ
TUUoRDAtLEQxLSxEMi0sRDNob3QtLEQzY29sZC0pCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBN
RS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MSBQTUUtCglDYXBhYmlsaXRpZXM6IFs1Y10gTVNJOiBF
bmFibGUtIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQrCgkJQWRkcmVzczogMDAwMDAwMDAwMDAw
MDAwMCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbNzBdIEV4cHJlc3MgKHYxKSBMZWdhY3kg
RW5kcG9pbnQsIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5bG9hZCAxMDI0IGJ5dGVzLCBQaGFudEZ1
bmMgMCwgTGF0ZW5jeSBMMHMgPDY0bnMsIEwxIDwxdXMKCQkJRXh0VGFnLSBBdHRuQnRuLSBBdHRu
SW5kLSBQd3JJbmQtIFJCRS0gRkxSZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJl
Y3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9yZC0gRXh0VGFn
LSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1h
eFJlYWRSZXEgNDA5NiBieXRlcwoJCURldlN0YToJQ29yckVyci0gVW5jb3JyRXJyKyBGYXRhbEVy
ci0gVW5zdXBwUmVxKyBBdXhQd3ItIFRyYW5zUGVuZC0KCQlMbmtDYXA6CVBvcnQgIzAsIFNwZWVk
IDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcywgTGF0ZW5jeSBMMCB1bmxpbWl0ZWQsIEwxIHVu
bGltaXRlZAoJCQlDbG9ja1BNLSBTdXJwcmlzZS0gTExBY3RSZXAtIEJ3Tm90LQoJCUxua0N0bDoJ
QVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJ
CQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3Rh
OglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2
ZS0gQldNZ210LSBBQldNZ210LQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHNhdGFfc2lsMjQKCjA1
OjA2LjAgTXVsdGltZWRpYSB2aWRlbyBjb250cm9sbGVyOiBCcm9va3RyZWUgQ29ycG9yYXRpb24g
QnQ4NzggVmlkZW8gQ2FwdHVyZSAocmV2IDExKQoJU3Vic3lzdGVtOiBIYXVwcGF1Z2UgY29tcHV0
ZXIgd29ya3MgSW5jLiBXaW5UViBTZXJpZXMKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIr
IFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIrIEZh
c3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJy
LSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0g
SU5UeC0KCUxhdGVuY3k6IDY0ICg0MDAwbnMgbWluLCAxMDAwMG5zIG1heCkKCUludGVycnVwdDog
cGluIEEgcm91dGVkIHRvIElSUSAxOQoJUmVnaW9uIDA6IE1lbW9yeSBhdCBlZWZmZjAwMCAoMzIt
Yml0LCBwcmVmZXRjaGFibGUpIFtzaXplPTRLXQoJQ2FwYWJpbGl0aWVzOiBbNDRdIFZpdGFsIFBy
b2R1Y3QgRGF0YQoJCVVua25vd24gc21hbGwgcmVzb3VyY2UgdHlwZSAwMCwgd2lsbCBub3QgZGVj
b2RlIG1vcmUuCglDYXBhYmlsaXRpZXM6IFs0Y10gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIK
CQlGbGFnczogUE1FQ2xrLSBEU0krIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwLSxEMS0s
RDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBE
U2VsPTAgRFNjYWxlPTAgUE1FLQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGJ0dHYKCjA1OjA2LjEg
TXVsdGltZWRpYSBjb250cm9sbGVyOiBCcm9va3RyZWUgQ29ycG9yYXRpb24gQnQ4NzggQXVkaW8g
Q2FwdHVyZSAocmV2IDExKQoJU3Vic3lzdGVtOiBIYXVwcGF1Z2UgY29tcHV0ZXIgd29ya3MgSW5j
LiBXaW5UViBTZXJpZXMKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0g
TWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIrIEZhc3RCMkItIERpc0lO
VHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVk
aXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVu
Y3k6IDY0ICgxMDAwbnMgbWluLCA2Mzc1MG5zIG1heCkKCUludGVycnVwdDogcGluIEEgcm91dGVk
IHRvIElSUSAxOQoJUmVnaW9uIDA6IE1lbW9yeSBhdCBlZWZmZTAwMCAoMzItYml0LCBwcmVmZXRj
aGFibGUpIFtzaXplPTRLXQoJQ2FwYWJpbGl0aWVzOiBbNDRdIFZpdGFsIFByb2R1Y3QgRGF0YQoJ
CVVua25vd24gc21hbGwgcmVzb3VyY2UgdHlwZSAwMCwgd2lsbCBub3QgZGVjb2RlIG1vcmUuCglD
YXBhYmlsaXRpZXM6IFs0Y10gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1F
Q2xrLSBEU0krIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxE
M2NvbGQtKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxl
PTAgUE1FLQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IEJ0ODd4CgowNTowOC4wIEZpcmVXaXJlIChJ
RUVFIDEzOTQpOiBUZXhhcyBJbnN0cnVtZW50cyBUU0I0M0FCMjIvQSBJRUVFLTEzOTRhLTIwMDAg
Q29udHJvbGxlciAoUEhZL0xpbmspIChwcm9nLWlmIDEwIFtPSENJXSkKCVN1YnN5c3RlbTogQVNV
U1RlSyBDb21wdXRlciBJbmMuIFA1VyBESCBEZWx1eGUgTW90aGVyYm9hcmQKCUNvbnRyb2w6IEkv
Ty0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVisgVkdBU25vb3AtIFBhckVyci0g
U3RlcHBpbmctIFNFUlIrIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVE
Ri0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJv
cnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDY0ICg1MDBucyBtaW4sIDEwMDBucyBt
YXgpLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0
byBJUlEgMTYKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZWZmZmY4MDAgKDMyLWJpdCwgbm9uLXByZWZl
dGNoYWJsZSkgW3NpemU9MktdCglSZWdpb24gMTogTWVtb3J5IGF0IGVmZmY4MDAwICgzMi1iaXQs
IG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTE2S10KCUNhcGFiaWxpdGllczogWzQ0XSBQb3dlciBN
YW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDErIEQyKyBBdXhDdXJy
ZW50PTBtQSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZC0pCgkJU3RhdHVzOiBEMCBOb1Nv
ZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUrCglLZXJuZWwgZHJpdmVyIGlu
IHVzZTogb2hjaTEzOTQKCg==
--001517478afc8d25a4047b8a1721
Content-Type: text/plain; charset=US-ASCII; name="lspci-vv-rc2.msi.txt"
Content-Disposition: attachment; filename="lspci-vv-rc2.msi.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3mqjsyk1

MDA6MDAuMCBSQU0gbWVtb3J5OiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQNTUgTWVtb3J5IENvbnRy
b2xsZXIgKHJldiBhMikKCVN1YnN5c3RlbTogQVNVU1RlSyBDb21wdXRlciBJbmMuIERldmljZSA4
MWYwCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZH
QVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSKyBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVz
OiBDYXArIDY2TUh6KyBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0g
PFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMAoJQ2FwYWJp
bGl0aWVzOiBbNDRdIEh5cGVyVHJhbnNwb3J0OiBTbGF2ZSBvciBQcmltYXJ5IEludGVyZmFjZQoJ
CUNvbW1hbmQ6IEJhc2VVbml0SUQ9MCBVbml0Q250PTE1IE1hc3RIb3N0LSBEZWZEaXItIERVTC0K
CQlMaW5rIENvbnRyb2wgMDogQ0ZsRSsgQ1NULSBDRkUtIDxMa0ZhaWwtIEluaXQrIEVPQy0gVFhP
LSA8Q1JDRXJyPTAgSXNvY0VuLSBMU0VuKyBFeHRDVEwtIDY0Yi0KCQlMaW5rIENvbmZpZyAwOiBN
TFdJPTE2Yml0IER3RmNJbi0gTUxXTz0xNmJpdCBEd0ZjT3V0LSBMV0k9MTZiaXQgRHdGY0luRW4t
IExXTz0xNmJpdCBEd0ZjT3V0RW4tCgkJTGluayBDb250cm9sIDE6IENGbEUtIENTVC0gQ0ZFLSA8
TGtGYWlsKyBJbml0LSBFT0MrIFRYTysgPENSQ0Vycj0wIElzb2NFbi0gTFNFbi0gRXh0Q1RMLSA2
NGItCgkJTGluayBDb25maWcgMTogTUxXST04Yml0IER3RmNJbi0gTUxXTz04Yml0IER3RmNPdXQt
IExXST04Yml0IER3RmNJbkVuLSBMV089OGJpdCBEd0ZjT3V0RW4tCgkJUmV2aXNpb24gSUQ6IDEu
MDMKCQlMaW5rIEZyZXF1ZW5jeSAwOiAxLjBHSHoKCQlMaW5rIEVycm9yIDA6IDxQcm90LSA8T3Zm
bC0gPEVPQy0gQ1RMVG0tCgkJTGluayBGcmVxdWVuY3kgQ2FwYWJpbGl0eSAwOiAyMDBNSHorIDMw
ME1IeisgNDAwTUh6KyA1MDBNSHorIDYwME1IeisgODAwTUh6KyAxLjBHSHorIDEuMkdIei0gMS40
R0h6LSAxLjZHSHotIFZlbmQtCgkJRmVhdHVyZSBDYXBhYmlsaXR5OiBJc29jRkMrIExEVFNUT1Ar
IENSQ1RNLSBFQ1RMVC0gNjRiQS0gVUlEUkQtCgkJTGluayBGcmVxdWVuY3kgMTogMjAwTUh6CgkJ
TGluayBFcnJvciAxOiA8UHJvdC0gPE92ZmwtIDxFT0MtIENUTFRtLQoJCUxpbmsgRnJlcXVlbmN5
IENhcGFiaWxpdHkgMTogMjAwTUh6LSAzMDBNSHotIDQwME1Iei0gNTAwTUh6LSA2MDBNSHotIDgw
ME1Iei0gMS4wR0h6LSAxLjJHSHotIDEuNEdIei0gMS42R0h6LSBWZW5kLQoJCUVycm9yIEhhbmRs
aW5nOiBQRmxFKyBPRmxFKyBQRkUtIE9GRS0gRU9DRkUtIFJGRS0gQ1JDRkUtIFNFUlJGRS0gQ0Yt
IFJFLSBQTkZFLSBPTkZFLSBFT0NORkUtIFJORkUtIENSQ05GRS0gU0VSUk5GRS0KCQlQcmVmZXRj
aGFibGUgbWVtb3J5IGJlaGluZCBicmlkZ2UgVXBwZXI6IDAwLTAwCgkJQnVzIE51bWJlcjogMDAK
CUNhcGFiaWxpdGllczogW2RjXSBIeXBlclRyYW5zcG9ydDogTVNJIE1hcHBpbmcgRW5hYmxlKyBG
aXhlZC0KCQlNYXBwaW5nIEFkZHJlc3MgQmFzZTogMDAwMDAwMDBmZWUwMDAwMAoKMDA6MDEuMCBJ
U0EgYnJpZGdlOiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQNTUgTFBDIEJyaWRnZSAocmV2IGEzKQoJ
U3Vic3lzdGVtOiBBU1VTVGVLIENvbXB1dGVyIEluYy4gRGV2aWNlIDgxZjAKCUNvbnRyb2w6IEkv
TysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZSsgTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0g
U3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcC0gNjZNSHorIFVE
Ri0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0
LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglSZWdpb24gMDogSS9PIHBvcnRzIGF0
IDJmMDAgW3NpemU9MTI4XQoKMDA6MDEuMSBTTUJ1czogblZpZGlhIENvcnBvcmF0aW9uIE1DUDU1
IFNNQnVzIChyZXYgYTMpCglTdWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2Ug
ODFmMAoJQ29udHJvbDogSS9PKyBNZW0tIEJ1c01hc3Rlci0gU3BlY0N5Y2xlLSBNZW1XSU5WLSBW
R0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1
czogQ2FwKyA2Nk1IeisgVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQt
IDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUludGVycnVwdDogcGluIEEg
cm91dGVkIHRvIElSUSAxMQoJUmVnaW9uIDA6IEkvTyBwb3J0cyBhdCBhODgwIFtzaXplPTY0XQoJ
UmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCAyYTAwIFtzaXplPTY0XQoJUmVnaW9uIDU6IEkvTyBwb3J0
cyBhdCAyYTgwIFtzaXplPTY0XQoJQ2FwYWJpbGl0aWVzOiBbNDRdIFBvd2VyIE1hbmFnZW1lbnQg
dmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBN
RShEMC0sRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1F
LUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCjAwOjAyLjAgVVNCIENvbnRyb2xsZXI6IG5W
aWRpYSBDb3Jwb3JhdGlvbiBNQ1A1NSBVU0IgQ29udHJvbGxlciAocmV2IGExKSAocHJvZy1pZiAx
MCBbT0hDSV0pCglTdWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2UgODFmMAoJ
Q29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9v
cC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2Fw
KyA2Nk1IeisgVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJv
cnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAgKDc1MG5zIG1pbiwg
MjUwbnMgbWF4KQoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDIzCglSZWdpb24gMDog
TWVtb3J5IGF0IGVmYWY4MDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTRLXQoJ
Q2FwYWJpbGl0aWVzOiBbNDRdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBN
RUNsay0gRFNJLSBEMSsgRDIrIEF1eEN1cnJlbnQ9MG1BIFBNRShEMCssRDErLEQyKyxEM2hvdCss
RDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2Fs
ZT0wIFBNRS0KCjAwOjAyLjEgVVNCIENvbnRyb2xsZXI6IG5WaWRpYSBDb3Jwb3JhdGlvbiBNQ1A1
NSBVU0IgQ29udHJvbGxlciAocmV2IGEyKSAocHJvZy1pZiAyMCBbRUhDSV0pCglTdWJzeXN0ZW06
IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2UgODFmMAoJQ29udHJvbDogSS9PLSBNZW0rIEJ1
c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0g
U0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1IeisgVURGLSBGYXN0QjJC
KyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8
UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAgKDc1MG5zIG1pbiwgMjUwbnMgbWF4KQoJSW50ZXJydXB0
OiBwaW4gQiByb3V0ZWQgdG8gSVJRIDIwCglSZWdpb24gMDogTWVtb3J5IGF0IGVmYWViYzAwICgz
Mi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTI1Nl0KCUNhcGFiaWxpdGllczogWzQ0XSBE
ZWJ1ZyBwb3J0OiBCQVI9MSBvZmZzZXQ9MDA5OAoJQ2FwYWJpbGl0aWVzOiBbODBdIFBvd2VyIE1h
bmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMSsgRDIrIEF1eEN1cnJl
bnQ9MG1BIFBNRShEMCssRDErLEQyKyxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29m
dFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCjAwOjA0LjAgSURFIGludGVy
ZmFjZTogblZpZGlhIENvcnBvcmF0aW9uIE1DUDU1IElERSAocmV2IGExKSAocHJvZy1pZiA4YSBb
TWFzdGVyIFNlY1AgUHJpUF0pCglTdWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZp
Y2UgODFmMAoJQ29udHJvbDogSS9PKyBNZW0tIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5W
LSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0
YXR1czogQ2FwKyA2Nk1IeisgVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJv
cnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAgKDc1
MG5zIG1pbiwgMjUwbnMgbWF4KQoJUmVnaW9uIDA6IFt2aXJ0dWFsXSBNZW1vcnkgYXQgMDAwMDAx
ZjAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9OF0KCVJlZ2lvbiAxOiBbdmlydHVh
bF0gTWVtb3J5IGF0IDAwMDAwM2YwICh0eXBlIDMsIG5vbi1wcmVmZXRjaGFibGUpCglSZWdpb24g
MjogW3ZpcnR1YWxdIE1lbW9yeSBhdCAwMDAwMDE3MCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxl
KSBbc2l6ZT04XQoJUmVnaW9uIDM6IFt2aXJ0dWFsXSBNZW1vcnkgYXQgMDAwMDAzNzAgKHR5cGUg
Mywgbm9uLXByZWZldGNoYWJsZSkKCVJlZ2lvbiA0OiBJL08gcG9ydHMgYXQgZmZhMCBbc2l6ZT0x
Nl0KCUNhcGFiaWxpdGllczogWzQ0XSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdz
OiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNo
b3QtLEQzY29sZC0pCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBE
U2NhbGU9MCBQTUUtCgowMDowNS4wIElERSBpbnRlcmZhY2U6IG5WaWRpYSBDb3Jwb3JhdGlvbiBN
Q1A1NSBTQVRBIENvbnRyb2xsZXIgKHJldiBhMykgKHByb2ctaWYgODUgW01hc3RlciBTZWNPIFBy
aU9dKQoJU3Vic3lzdGVtOiBBU1VTVGVLIENvbXB1dGVyIEluYy4gRGV2aWNlIDgxZjAKCUNvbnRy
b2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBh
ckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsgNjZN
SHorIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8
TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwICg3NTBucyBtaW4sIDI1MG5z
IG1heCkKCUludGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAzMAoJUmVnaW9uIDA6IEkvTyBw
b3J0cyBhdCBjYzAwIFtzaXplPThdCglSZWdpb24gMTogSS9PIHBvcnRzIGF0IGM4ODAgW3NpemU9
NF0KCVJlZ2lvbiAyOiBJL08gcG9ydHMgYXQgYzgwMCBbc2l6ZT04XQoJUmVnaW9uIDM6IEkvTyBw
b3J0cyBhdCBjNDgwIFtzaXplPTRdCglSZWdpb24gNDogSS9PIHBvcnRzIGF0IGM0MDAgW3NpemU9
MTZdCglSZWdpb24gNTogTWVtb3J5IGF0IGVmYWZiMDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFi
bGUpIFtzaXplPTRLXQoJQ2FwYWJpbGl0aWVzOiBbNDRdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lv
biAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0s
RDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJs
ZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogW2IwXSBNU0k6IEVuYWJsZSsg
Q291bnQ9MS80IE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMGZlZTBmMDBjICBE
YXRhOiA0MTg5CglDYXBhYmlsaXRpZXM6IFtjY10gSHlwZXJUcmFuc3BvcnQ6IE1TSSBNYXBwaW5n
IEVuYWJsZS0gRml4ZWQrCgowMDowNS4xIElERSBpbnRlcmZhY2U6IG5WaWRpYSBDb3Jwb3JhdGlv
biBNQ1A1NSBTQVRBIENvbnRyb2xsZXIgKHJldiBhMykgKHByb2ctaWYgODUgW01hc3RlciBTZWNP
IFByaU9dKQoJU3Vic3lzdGVtOiBBU1VTVGVLIENvbXB1dGVyIEluYy4gRGV2aWNlIDgxZjAKCUNv
bnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3At
IFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsg
NjZNSHorIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0
LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwICg3NTBucyBtaW4sIDI1
MG5zIG1heCkKCUludGVycnVwdDogcGluIEIgcm91dGVkIHRvIElSUSAzMQoJUmVnaW9uIDA6IEkv
TyBwb3J0cyBhdCBjMDgwIFtzaXplPThdCglSZWdpb24gMTogSS9PIHBvcnRzIGF0IGMwMDAgW3Np
emU9NF0KCVJlZ2lvbiAyOiBJL08gcG9ydHMgYXQgYmMwMCBbc2l6ZT04XQoJUmVnaW9uIDM6IEkv
TyBwb3J0cyBhdCBiODgwIFtzaXplPTRdCglSZWdpb24gNDogSS9PIHBvcnRzIGF0IGI4MDAgW3Np
emU9MTZdCglSZWdpb24gNTogTWVtb3J5IGF0IGVmYWZhMDAwICgzMi1iaXQsIG5vbi1wcmVmZXRj
aGFibGUpIFtzaXplPTRLXQoJQ2FwYWJpbGl0aWVzOiBbNDRdIFBvd2VyIE1hbmFnZW1lbnQgdmVy
c2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShE
MC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVu
YWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogW2IwXSBNU0k6IEVuYWJs
ZSsgQ291bnQ9MS80IE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMGZlZTBmMDBj
ICBEYXRhOiA0MTk5CglDYXBhYmlsaXRpZXM6IFtjY10gSHlwZXJUcmFuc3BvcnQ6IE1TSSBNYXBw
aW5nIEVuYWJsZS0gRml4ZWQrCgowMDowNS4yIElERSBpbnRlcmZhY2U6IG5WaWRpYSBDb3Jwb3Jh
dGlvbiBNQ1A1NSBTQVRBIENvbnRyb2xsZXIgKHJldiBhMykgKHByb2ctaWYgODUgW01hc3RlciBT
ZWNPIFByaU9dKQoJU3Vic3lzdGVtOiBBU1VTVGVLIENvbXB1dGVyIEluYy4gRGV2aWNlIDgxZjAK
CUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25v
b3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENh
cCsgNjZNSHorIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFi
b3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwICg3NTBucyBtaW4s
IDI1MG5zIG1heCkKCUludGVycnVwdDogcGluIEMgcm91dGVkIHRvIElSUSAzMgoJUmVnaW9uIDA6
IEkvTyBwb3J0cyBhdCBiNDgwIFtzaXplPThdCglSZWdpb24gMTogSS9PIHBvcnRzIGF0IGI0MDAg
W3NpemU9NF0KCVJlZ2lvbiAyOiBJL08gcG9ydHMgYXQgYjA4MCBbc2l6ZT04XQoJUmVnaW9uIDM6
IEkvTyBwb3J0cyBhdCBiMDAwIFtzaXplPTRdCglSZWdpb24gNDogSS9PIHBvcnRzIGF0IGFjMDAg
W3NpemU9MTZdCglSZWdpb24gNTogTWVtb3J5IGF0IGVmYWY5MDAwICgzMi1iaXQsIG5vbi1wcmVm
ZXRjaGFibGUpIFtzaXplPTRLXQoJQ2FwYWJpbGl0aWVzOiBbNDRdIFBvd2VyIE1hbmFnZW1lbnQg
dmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBN
RShEMC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1F
LUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogW2IwXSBNU0k6IEVu
YWJsZSsgQ291bnQ9MS80IE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMGZlZTBm
MDBjICBEYXRhOiA0MWE5CglDYXBhYmlsaXRpZXM6IFtjY10gSHlwZXJUcmFuc3BvcnQ6IE1TSSBN
YXBwaW5nIEVuYWJsZS0gRml4ZWQrCgowMDowNi4wIFBDSSBicmlkZ2U6IG5WaWRpYSBDb3Jwb3Jh
dGlvbiBNQ1A1NSBQQ0kgYnJpZGdlIChyZXYgYTIpIChwcm9nLWlmIDAxIFtTdWJ0cmFjdGl2ZSBk
ZWNvZGVdKQoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5W
LSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0
YXR1czogQ2FwKyA2Nk1IeisgVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJv
cnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAKCUJ1
czogcHJpbWFyeT0wMCwgc2Vjb25kYXJ5PTA1LCBzdWJvcmRpbmF0ZT0wNSwgc2VjLWxhdGVuY3k9
NjQKCU1lbW9yeSBiZWhpbmQgYnJpZGdlOiBlZmYwMDAwMC1lZmZmZmZmZgoJUHJlZmV0Y2hhYmxl
IG1lbW9yeSBiZWhpbmQgYnJpZGdlOiBlZWYwMDAwMC1lZWZmZmZmZgoJU2Vjb25kYXJ5IHN0YXR1
czogNjZNSHotIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0
LSA8TUFib3J0LSA8U0VSUi0gPFBFUlItCglCcmlkZ2VDdGw6IFBhcml0eS0gU0VSUisgTm9JU0Et
IFZHQS0gTUFib3J0LSA+UmVzZXQtIEZhc3RCMkItCgkJUHJpRGlzY1Rtci0gU2VjRGlzY1Rtcisg
RGlzY1RtclN0YXQtIERpc2NUbXJTRVJSRW4tCglDYXBhYmlsaXRpZXM6IFtiOF0gU3Vic3lzdGVt
OiBuVmlkaWEgQ29ycG9yYXRpb24gRGV2aWNlIGNiODQKCUNhcGFiaWxpdGllczogWzhjXSBIeXBl
clRyYW5zcG9ydDogTVNJIE1hcHBpbmcgRW5hYmxlLSBGaXhlZC0KCQlNYXBwaW5nIEFkZHJlc3Mg
QmFzZTogMDAwMDAwMDBmZWUwMDAwMAoKMDA6MDYuMSBBdWRpbyBkZXZpY2U6IG5WaWRpYSBDb3Jw
b3JhdGlvbiBNQ1A1NSBIaWdoIERlZmluaXRpb24gQXVkaW8gKHJldiBhMikKCVN1YnN5c3RlbTog
QVNVU1RlSyBDb21wdXRlciBJbmMuIERldmljZSA4MjEwCglDb250cm9sOiBJL08tIE1lbSsgQnVz
TWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6KyBVREYtIEZhc3RCMkIr
IFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQ
RVJSLSBJTlR4LQoJTGF0ZW5jeTogMCAoNTAwbnMgbWluLCAxMjUwbnMgbWF4KQoJSW50ZXJydXB0
OiBwaW4gQiByb3V0ZWQgdG8gSVJRIDMzCglSZWdpb24gMDogTWVtb3J5IGF0IGVmYWZjMDAwICgz
Mi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTE2S10KCUNhcGFiaWxpdGllczogWzQ0XSBQ
b3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBB
dXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBE
MCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRp
ZXM6IFs1MF0gTVNJOiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZSsgNjRiaXQrCgkJQWRkcmVz
czogMDAwMDAwMDBmZWUwZjAwYyAgRGF0YTogNDFkMQoJCU1hc2tpbmc6IDAwMDAwMDAwICBQZW5k
aW5nOiAwMDAwMDAwMAoJQ2FwYWJpbGl0aWVzOiBbNmNdIEh5cGVyVHJhbnNwb3J0OiBNU0kgTWFw
cGluZyBFbmFibGUtIEZpeGVkKwoKMDA6MGIuMCBQQ0kgYnJpZGdlOiBuVmlkaWEgQ29ycG9yYXRp
b24gTUNQNTUgUENJIEV4cHJlc3MgYnJpZGdlIChyZXYgYTMpIChwcm9nLWlmIDAwIFtOb3JtYWwg
ZGVjb2RlXSkKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lO
Vi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglT
dGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFi
b3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBD
YWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wNCwg
c3Vib3JkaW5hdGU9MDQsIHNlYy1sYXRlbmN5PTAKCUkvTyBiZWhpbmQgYnJpZGdlOiAwMDAwZTAw
MC0wMDAwZWZmZgoJTWVtb3J5IGJlaGluZCBicmlkZ2U6IGVmZTAwMDAwLWVmZWZmZmZmCglTZWNv
bmRhcnkgc3RhdHVzOiA2Nk1Iei0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0
LSA8VEFib3J0LSA8TUFib3J0LSA8U0VSUi0gPFBFUlItCglCcmlkZ2VDdGw6IFBhcml0eS0gU0VS
UisgTm9JU0EtIFZHQS0gTUFib3J0LSA+UmVzZXQtIEZhc3RCMkItCgkJUHJpRGlzY1Rtci0gU2Vj
RGlzY1Rtci0gRGlzY1RtclN0YXQtIERpc2NUbXJTRVJSRW4tCglDYXBhYmlsaXRpZXM6IFs0MF0g
U3Vic3lzdGVtOiBuVmlkaWEgQ29ycG9yYXRpb24gRGV2aWNlIDAwMDAKCUNhcGFiaWxpdGllczog
WzQ4XSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEt
IEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZCspCgkJU3Rh
dHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBh
YmlsaXRpZXM6IFs1MF0gTVNJOiBFbmFibGUrIENvdW50PTEvMiBNYXNrYWJsZS0gNjRiaXQrCgkJ
QWRkcmVzczogMDAwMDAwMDBmZWUwZjAwYyAgRGF0YTogNDE0OQoJQ2FwYWJpbGl0aWVzOiBbNjBd
IEh5cGVyVHJhbnNwb3J0OiBNU0kgTWFwcGluZyBFbmFibGUtIEZpeGVkLQoJCU1hcHBpbmcgQWRk
cmVzcyBCYXNlOiAwMDAwMDAwMGZlZTAwMDAwCglDYXBhYmlsaXRpZXM6IFs4MF0gRXhwcmVzcyAo
djEpIFJvb3QgUG9ydCAoU2xvdCspLCBNU0kgMDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMjU2IGJ5
dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgPDY0bnMsIEwxIDwxdXMKCQkJRXh0VGFnLSBS
QkUrIEZMUmVzZXQtCgkJRGV2Q3RsOglSZXBvcnQgZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZh
dGFsLSBGYXRhbC0gVW5zdXBwb3J0ZWQtCgkJCVJseGRPcmQrIEV4dFRhZy0gUGhhbnRGdW5jLSBB
dXhQd3ItIE5vU25vb3ArCgkJCU1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDUxMiBi
eXRlcwoJCURldlN0YToJQ29yckVyci0gVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBB
dXhQd3ItIFRyYW5zUGVuZC0KCQlMbmtDYXA6CVBvcnQgIzQsIFNwZWVkIDIuNUdUL3MsIFdpZHRo
IHgxLCBBU1BNIEwwcyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDw0dXMKCQkJQ2xvY2tQTS0g
U3VycHJpc2UtIExMQWN0UmVwKyBCd05vdC0KCQlMbmtDdGw6CUFTUE0gRGlzYWJsZWQ7IFJDQiA2
NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsay0KCQkJRXh0U3luY2gtIENsb2NrUE0t
IEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3BlZWQgMi41R1QvcywgV2lk
dGggeDEsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3RpdmUrIEJXTWdtdC0gQUJXTWdtdC0K
CQlTbHRDYXA6CUF0dG5CdG4tIFB3ckN0cmwtIE1STC0gQXR0bkluZC0gUHdySW5kLSBIb3RQbHVn
LSBTdXJwaXNlLQoJCQlTbG90ICMgIDAsIFBvd2VyTGltaXQgMC4wMDAwMDA7IEludGVybG9jay0g
Tm9Db21wbC0KCQlTbHRDdGw6CUVuYWJsZTogQXR0bkJ0bi0gUHdyRmx0LSBNUkwtIFByZXNEZXQt
IENtZENwbHQtIEhQSXJxLSBMaW5rQ2hnLQoJCQlDb250cm9sOiBBdHRuSW5kIE9mZiwgUHdySW5k
IE9uLCBQb3dlci0gSW50ZXJsb2NrLQoJCVNsdFN0YToJU3RhdHVzOiBBdHRuQnRuLSBQb3dlckZs
dC0gTVJMLSBDbWRDcGx0LSBQcmVzRGV0KyBJbnRlcmxvY2stCgkJCUNoYW5nZWQ6IE1STC0gUHJl
c0RldCsgTGlua1N0YXRlKwoJCVJvb3RDdGw6IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwt
IEVyckZhdGFsLSBQTUVJbnRFbmEtIENSU1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJsZS0K
CQlSb290U3RhOiBQTUUgUmVxSUQgMDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoKMDA6MGMu
MCBQQ0kgYnJpZGdlOiBuVmlkaWEgQ29ycG9yYXRpb24gTUNQNTUgUENJIEV4cHJlc3MgYnJpZGdl
IChyZXYgYTMpIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNvbnRyb2w6IEkvTy0gTWVt
KyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBp
bmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFz
dEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VS
Ui0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglC
dXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wMywgc3Vib3JkaW5hdGU9MDMsIHNlYy1sYXRlbmN5
PTAKCU1lbW9yeSBiZWhpbmQgYnJpZGdlOiBlZmQwMDAwMC1lZmRmZmZmZgoJU2Vjb25kYXJ5IHN0
YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9y
dC0gPE1BYm9ydCsgPFNFUlItIDxQRVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlIrIE5vSVNB
LSBWR0EtIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJCVByaURpc2NUbXItIFNlY0Rpc2NUbXIt
IERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVzOiBbNDBdIFN1YnN5c3Rl
bTogblZpZGlhIENvcnBvcmF0aW9uIERldmljZSAwMDAwCglDYXBhYmlsaXRpZXM6IFs0OF0gUG93
ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4
Q3VycmVudD0wbUEgUE1FKEQwKyxEMSssRDIrLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAg
Tm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVz
OiBbNTBdIE1TSTogRW5hYmxlKyBDb3VudD0xLzIgTWFza2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6
IDAwMDAwMDAwZmVlMGYwMGMgIERhdGE6IDQxNTEKCUNhcGFiaWxpdGllczogWzYwXSBIeXBlclRy
YW5zcG9ydDogTVNJIE1hcHBpbmcgRW5hYmxlLSBGaXhlZC0KCQlNYXBwaW5nIEFkZHJlc3MgQmFz
ZTogMDAwMDAwMDBmZWUwMDAwMAoJQ2FwYWJpbGl0aWVzOiBbODBdIEV4cHJlc3MgKHYxKSBSb290
IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDI1NiBieXRlcywgUGhh
bnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0gUkJFKyBGTFJl
c2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0
YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkKyBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBO
b1Nub29wKwoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSA1MTIgYnl0ZXMKCQlE
ZXZTdGE6CUNvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyLSBU
cmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMzLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQ
TSBMMHMgTDEsIExhdGVuY3kgTDAgPDUxMm5zLCBMMSA8NHVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMg
RGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWRE
aXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBU
ckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQtIEFCV01nbXQtCgkJU2x0Q2Fw
OglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0gSG90UGx1Zy0gU3VycGlz
ZS0KCQkJU2xvdCAjICAwLCBQb3dlckxpbWl0IDAuMDAwMDAwOyBJbnRlcmxvY2stIE5vQ29tcGwt
CgkJU2x0Q3RsOglFbmFibGU6IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0LSBDbWRDcGx0
LSBIUElycS0gTGlua0NoZy0KCQkJQ29udHJvbDogQXR0bkluZCBPZmYsIFB3ckluZCBPbiwgUG93
ZXItIEludGVybG9jay0KCQlTbHRTdGE6CVN0YXR1czogQXR0bkJ0bi0gUG93ZXJGbHQtIE1STC0g
Q21kQ3BsdC0gUHJlc0RldCsgSW50ZXJsb2NrLQoJCQlDaGFuZ2VkOiBNUkwtIFByZXNEZXQrIExp
bmtTdGF0ZSsKCQlSb290Q3RsOiBFcnJDb3JyZWN0YWJsZS0gRXJyTm9uLUZhdGFsLSBFcnJGYXRh
bC0gUE1FSW50RW5hLSBDUlNWaXNpYmxlLQoJCVJvb3RDYXA6IENSU1Zpc2libGUtCgkJUm9vdFN0
YTogUE1FIFJlcUlEIDAwMDAsIFBNRVN0YXR1cy0gUE1FUGVuZGluZy0KCjAwOjBkLjAgUENJIGJy
aWRnZTogblZpZGlhIENvcnBvcmF0aW9uIE1DUDU1IFBDSSBFeHByZXNzIGJyaWRnZSAocmV2IGEz
KSAocHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJS
LSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBh
ckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJS
LSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJQnVzOiBwcmlt
YXJ5PTAwLCBzZWNvbmRhcnk9MDIsIHN1Ym9yZGluYXRlPTAyLCBzZWMtbGF0ZW5jeT0wCglNZW1v
cnkgYmVoaW5kIGJyaWRnZTogZWZjMDAwMDAtZWZjZmZmZmYKCVNlY29uZGFyeSBzdGF0dXM6IDY2
TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJv
cnQrIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFyaXR5LSBTRVJSKyBOb0lTQS0gVkdBLSBN
QWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlEaXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1y
U3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFiaWxpdGllczogWzQwXSBTdWJzeXN0ZW06IG5WaWRp
YSBDb3Jwb3JhdGlvbiBEZXZpY2UgMDAwMAoJQ2FwYWJpbGl0aWVzOiBbNDhdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9
MG1BIFBNRShEMCssRDErLEQyKyxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJz
dC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzUwXSBN
U0k6IEVuYWJsZSsgQ291bnQ9MS8yIE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAw
MGZlZTBmMDBjICBEYXRhOiA0MTU5CglDYXBhYmlsaXRpZXM6IFs2MF0gSHlwZXJUcmFuc3BvcnQ6
IE1TSSBNYXBwaW5nIEVuYWJsZS0gRml4ZWQtCgkJTWFwcGluZyBBZGRyZXNzIEJhc2U6IDAwMDAw
MDAwZmVlMDAwMDAKCUNhcGFiaWxpdGllczogWzgwXSBFeHByZXNzICh2MSkgUm9vdCBQb3J0IChT
bG90KyksIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5bG9hZCAyNTYgYnl0ZXMsIFBoYW50RnVuYyAw
LCBMYXRlbmN5IEwwcyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlE
ZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1
cHBvcnRlZC0KCQkJUmx4ZE9yZCsgRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcCsK
CQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgNTEyIGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyLSBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3ci0gVHJhbnNQZW5k
LQoJCUxua0NhcDoJUG9ydCAjMiwgU3BlZWQgMi41R1QvcywgV2lkdGggeDEsIEFTUE0gTDBzIEwx
LCBMYXRlbmN5IEwwIDw1MTJucywgTDEgPDR1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0gTExBY3RS
ZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVk
LSBSZXRyYWluLSBDb21tQ2xrKwoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0lu
dC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgVHJFcnItIFRy
YWluLSBTbG90Q2xrKyBETEFjdGl2ZSsgQldNZ210LSBBQldNZ210LQoJCVNsdENhcDoJQXR0bkJ0
bi0gUHdyQ3RybC0gTVJMLSBBdHRuSW5kLSBQd3JJbmQtIEhvdFBsdWctIFN1cnBpc2UtCgkJCVNs
b3QgIyAgMCwgUG93ZXJMaW1pdCAwLjAwMDAwMDsgSW50ZXJsb2NrLSBOb0NvbXBsLQoJCVNsdEN0
bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1STC0gUHJlc0RldC0gQ21kQ3BsdC0gSFBJcnEt
IExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5JbmQgT2ZmLCBQd3JJbmQgT24sIFBvd2VyLSBJbnRl
cmxvY2stCgkJU2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQt
IFByZXNEZXQrIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0KyBMaW5rU3RhdGUr
CgkJUm9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUlu
dEVuYS0gQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBS
ZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgowMDowZi4wIFBDSSBicmlkZ2U6IG5W
aWRpYSBDb3Jwb3JhdGlvbiBNQ1A1NSBQQ0kgRXhwcmVzcyBicmlkZ2UgKHJldiBhMykgKHByb2ct
aWYgMDAgW05vcm1hbCBkZWNvZGVdKQoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3Bl
Y0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIy
Qi0gRGlzSU5UeCsKCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERF
VlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0K
CUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUJ1czogcHJpbWFyeT0wMCwg
c2Vjb25kYXJ5PTAxLCBzdWJvcmRpbmF0ZT0wMSwgc2VjLWxhdGVuY3k9MAoJSS9PIGJlaGluZCBi
cmlkZ2U6IDAwMDBkMDAwLTAwMDBkZmZmCglNZW1vcnkgYmVoaW5kIGJyaWRnZTogZWZiMDAwMDAt
ZWZiZmZmZmYKCVByZWZldGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTogMDAwMDAwMDBlMDAw
MDAwMC0wMDAwMDAwMGU3ZmZmZmZmCglTZWNvbmRhcnkgc3RhdHVzOiA2Nk1Iei0gRmFzdEIyQi0g
UGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0KyA8U0VSUi0gPFBF
UlItCglCcmlkZ2VDdGw6IFBhcml0eS0gU0VSUisgTm9JU0EtIFZHQSsgTUFib3J0LSA+UmVzZXQt
IEZhc3RCMkItCgkJUHJpRGlzY1Rtci0gU2VjRGlzY1Rtci0gRGlzY1RtclN0YXQtIERpc2NUbXJT
RVJSRW4tCglDYXBhYmlsaXRpZXM6IFs0MF0gU3Vic3lzdGVtOiBuVmlkaWEgQ29ycG9yYXRpb24g
RGV2aWNlIDAwMDAKCUNhcGFiaWxpdGllczogWzQ4XSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24g
MgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQx
KyxEMissRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUt
IERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs1MF0gTVNJOiBFbmFibGUrIENv
dW50PTEvMiBNYXNrYWJsZS0gNjRiaXQrCgkJQWRkcmVzczogMDAwMDAwMDBmZWUwZjAwYyAgRGF0
YTogNDE2MQoJQ2FwYWJpbGl0aWVzOiBbNjBdIEh5cGVyVHJhbnNwb3J0OiBNU0kgTWFwcGluZyBF
bmFibGUtIEZpeGVkLQoJCU1hcHBpbmcgQWRkcmVzcyBCYXNlOiAwMDAwMDAwMGZlZTAwMDAwCglD
YXBhYmlsaXRpZXM6IFs4MF0gRXhwcmVzcyAodjEpIFJvb3QgUG9ydCAoU2xvdCspLCBNU0kgMDAK
CQlEZXZDYXA6CU1heFBheWxvYWQgMjU2IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMg
PDY0bnMsIEwxIDwxdXMKCQkJRXh0VGFnLSBSQkUrIEZMUmVzZXQtCgkJRGV2Q3RsOglSZXBvcnQg
ZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBwb3J0ZWQtCgkJCVJs
eGRPcmQrIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3ArCgkJCU1heFBheWxvYWQg
MTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDUxMiBieXRlcwoJCURldlN0YToJQ29yckVyci0gVW5jb3Jy
RXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBBdXhQd3ItIFRyYW5zUGVuZC0KCQlMbmtDYXA6CVBv
cnQgIzAsIFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxNiwgQVNQTSBMMHMgTDEsIExhdGVuY3kgTDAg
PDUxMm5zLCBMMSA8NHVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcCsgQndOb3QtCgkJ
TG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENv
bW1DbGstCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0K
CQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxNiwgVHJFcnItIFRyYWluLSBTbG90Q2xr
KyBETEFjdGl2ZSsgQldNZ210LSBBQldNZ210LQoJCVNsdENhcDoJQXR0bkJ0bi0gUHdyQ3RybC0g
TVJMLSBBdHRuSW5kLSBQd3JJbmQtIEhvdFBsdWctIFN1cnBpc2UtCgkJCVNsb3QgIyAgMCwgUG93
ZXJMaW1pdCAwLjAwMDAwMDsgSW50ZXJsb2NrLSBOb0NvbXBsLQoJCVNsdEN0bDoJRW5hYmxlOiBB
dHRuQnRuLSBQd3JGbHQtIE1STC0gUHJlc0RldC0gQ21kQ3BsdC0gSFBJcnEtIExpbmtDaGctCgkJ
CUNvbnRyb2w6IEF0dG5JbmQgT2ZmLCBQd3JJbmQgT24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0
U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQrIElu
dGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0KyBMaW5rU3RhdGUrCgkJUm9vdEN0bDog
RXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0gQ1JTVmlz
aWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJRCAwMDAwLCBQ
TUVTdGF0dXMtIFBNRVBlbmRpbmctCgowMDoxOC4wIEhvc3QgYnJpZGdlOiBBZHZhbmNlZCBNaWNy
byBEZXZpY2VzIFtBTURdIEs4IFtBdGhsb242NC9PcHRlcm9uXSBIeXBlclRyYW5zcG9ydCBUZWNo
bm9sb2d5IENvbmZpZ3VyYXRpb24KCUNvbnRyb2w6IEkvTy0gTWVtLSBCdXNNYXN0ZXItIFNwZWND
eWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkIt
IERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZT
RUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglD
YXBhYmlsaXRpZXM6IFs4MF0gSHlwZXJUcmFuc3BvcnQ6IEhvc3Qgb3IgU2Vjb25kYXJ5IEludGVy
ZmFjZQoJCUNvbW1hbmQ6IFdhcm1Sc3QrIERibEVuZC0gRGV2TnVtPTAgQ2hhaW5TaWRlLSBIb3N0
SGlkZSsgU2xhdmUtIDxFT0NFcnItIERVTC0KCQlMaW5rIENvbnRyb2w6IENGbEUtIENTVC0gQ0ZF
LSA8TGtGYWlsLSBJbml0KyBFT0MtIFRYTy0gPENSQ0Vycj0wIElzb2NFbi0gTFNFbi0gRXh0Q1RM
LSA2NGItCgkJTGluayBDb25maWc6IE1MV0k9MTZiaXQgRHdGY0luLSBNTFdPPTE2Yml0IER3RmNP
dXQtIExXST0xNmJpdCBEd0ZjSW5Fbi0gTFdPPTE2Yml0IER3RmNPdXRFbi0KCQlSZXZpc2lvbiBJ
RDogMS4wMgoJCUxpbmsgRnJlcXVlbmN5OiAxLjBHSHoKCQlMaW5rIEVycm9yOiA8UHJvdC0gPE92
ZmwtIDxFT0MtIENUTFRtLQoJCUxpbmsgRnJlcXVlbmN5IENhcGFiaWxpdHk6IDIwME1IeisgMzAw
TUh6LSA0MDBNSHorIDUwME1Iei0gNjAwTUh6KyA4MDBNSHorIDEuMEdIeisgMS4yR0h6LSAxLjRH
SHotIDEuNkdIei0gVmVuZC0KCQlGZWF0dXJlIENhcGFiaWxpdHk6IElzb2NGQy0gTERUU1RPUCsg
Q1JDVE0tIEVDVExULSA2NGJBLSBVSURSRC0gRXh0UlMtIFVDbmZFLQoJQ2FwYWJpbGl0aWVzOiBb
YTBdIEh5cGVyVHJhbnNwb3J0OiBIb3N0IG9yIFNlY29uZGFyeSBJbnRlcmZhY2UKCQlDb21tYW5k
OiBXYXJtUnN0KyBEYmxFbmQtIERldk51bT0wIENoYWluU2lkZS0gSG9zdEhpZGUrIFNsYXZlLSA8
RU9DRXJyLSBEVUwtCgkJTGluayBDb250cm9sOiBDRmxFLSBDU1QtIENGRS0gPExrRmFpbC0gSW5p
dCsgRU9DLSBUWE8tIDxDUkNFcnI9MCBJc29jRW4tIExTRW4tIEV4dENUTC0gNjRiLQoJCUxpbmsg
Q29uZmlnOiBNTFdJPTE2Yml0IER3RmNJbi0gTUxXTz0xNmJpdCBEd0ZjT3V0LSBMV0k9MTZiaXQg
RHdGY0luRW4tIExXTz0xNmJpdCBEd0ZjT3V0RW4tCgkJUmV2aXNpb24gSUQ6IDEuMDIKCQlMaW5r
IEZyZXF1ZW5jeTogMS4wR0h6CgkJTGluayBFcnJvcjogPFByb3QtIDxPdmZsLSA8RU9DLSBDVExU
bS0KCQlMaW5rIEZyZXF1ZW5jeSBDYXBhYmlsaXR5OiAyMDBNSHorIDMwME1Iei0gNDAwTUh6KyA1
MDBNSHotIDYwME1IeisgODAwTUh6KyAxLjBHSHorIDEuMkdIei0gMS40R0h6LSAxLjZHSHotIFZl
bmQtCgkJRmVhdHVyZSBDYXBhYmlsaXR5OiBJc29jRkMtIExEVFNUT1ArIENSQ1RNLSBFQ1RMVC0g
NjRiQS0gVUlEUkQtIEV4dFJTLSBVQ25mRS0KCUNhcGFiaWxpdGllczogW2MwXSBIeXBlclRyYW5z
cG9ydDogSG9zdCBvciBTZWNvbmRhcnkgSW50ZXJmYWNlCgkJQ29tbWFuZDogV2FybVJzdCsgRGJs
RW5kLSBEZXZOdW09MCBDaGFpblNpZGUtIEhvc3RIaWRlKyBTbGF2ZS0gPEVPQ0Vyci0gRFVMLQoJ
CUxpbmsgQ29udHJvbDogQ0ZsRS0gQ1NULSBDRkUtIDxMa0ZhaWwrIEluaXQtIEVPQysgVFhPKyA8
Q1JDRXJyPTAgSXNvY0VuLSBMU0VuLSBFeHRDVEwtIDY0Yi0KCQlMaW5rIENvbmZpZzogTUxXST0x
NmJpdCBEd0ZjSW4tIE1MV089MTZiaXQgRHdGY091dC0gTFdJPU4vQyBEd0ZjSW5Fbi0gTFdPPU4v
QyBEd0ZjT3V0RW4tCgkJUmV2aXNpb24gSUQ6IDEuMDIKCQlMaW5rIEZyZXF1ZW5jeTogMjAwTUh6
CgkJTGluayBFcnJvcjogPFByb3QtIDxPdmZsLSA8RU9DLSBDVExUbS0KCQlMaW5rIEZyZXF1ZW5j
eSBDYXBhYmlsaXR5OiAyMDBNSHorIDMwME1Iei0gNDAwTUh6KyA1MDBNSHotIDYwME1IeisgODAw
TUh6KyAxLjBHSHorIDEuMkdIei0gMS40R0h6LSAxLjZHSHotIFZlbmQtCgkJRmVhdHVyZSBDYXBh
YmlsaXR5OiBJc29jRkMtIExEVFNUT1ArIENSQ1RNLSBFQ1RMVC0gNjRiQS0gVUlEUkQtIEV4dFJT
LSBVQ25mRS0KCjAwOjE4LjEgSG9zdCBicmlkZ2U6IEFkdmFuY2VkIE1pY3JvIERldmljZXMgW0FN
RF0gSzggW0F0aGxvbjY0L09wdGVyb25dIEFkZHJlc3MgTWFwCglDb250cm9sOiBJL08tIE1lbS0g
QnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5n
LSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlIt
IDxQRVJSLSBJTlR4LQoKMDA6MTguMiBIb3N0IGJyaWRnZTogQWR2YW5jZWQgTWljcm8gRGV2aWNl
cyBbQU1EXSBLOCBbQXRobG9uNjQvT3B0ZXJvbl0gRFJBTSBDb250cm9sbGVyCglDb250cm9sOiBJ
L08tIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnIt
IFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2TUh6LSBV
REYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9y
dC0gPlNFUlItIDxQRVJSLSBJTlR4LQoKMDA6MTguMyBIb3N0IGJyaWRnZTogQWR2YW5jZWQgTWlj
cm8gRGV2aWNlcyBbQU1EXSBLOCBbQXRobG9uNjQvT3B0ZXJvbl0gTWlzY2VsbGFuZW91cyBDb250
cm9sCglDb250cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZH
QVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVz
OiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0g
PFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJQ2FwYWJpbGl0aWVzOiBbZjBd
IFNlY3VyZSBkZXZpY2UgPD8+CgowMDoxOS4wIEhvc3QgYnJpZGdlOiBBZHZhbmNlZCBNaWNybyBE
ZXZpY2VzIFtBTURdIEs4IFtBdGhsb242NC9PcHRlcm9uXSBIeXBlclRyYW5zcG9ydCBUZWNobm9s
b2d5IENvbmZpZ3VyYXRpb24KCUNvbnRyb2w6IEkvTy0gTWVtLSBCdXNNYXN0ZXItIFNwZWNDeWNs
ZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERp
c0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9
ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglDYXBh
YmlsaXRpZXM6IFs4MF0gSHlwZXJUcmFuc3BvcnQ6IEhvc3Qgb3IgU2Vjb25kYXJ5IEludGVyZmFj
ZQoJCUNvbW1hbmQ6IFdhcm1Sc3QrIERibEVuZC0gRGV2TnVtPTAgQ2hhaW5TaWRlLSBIb3N0SGlk
ZSsgU2xhdmUtIDxFT0NFcnItIERVTC0KCQlMaW5rIENvbnRyb2w6IENGbEUtIENTVC0gQ0ZFLSA8
TGtGYWlsKyBJbml0LSBFT0MrIFRYTysgPENSQ0Vycj0wIElzb2NFbi0gTFNFbi0gRXh0Q1RMLSA2
NGItCgkJTGluayBDb25maWc6IE1MV0k9MTZiaXQgRHdGY0luLSBNTFdPPTE2Yml0IER3RmNPdXQt
IExXST1OL0MgRHdGY0luRW4tIExXTz1OL0MgRHdGY091dEVuLQoJCVJldmlzaW9uIElEOiAxLjAy
CgkJTGluayBGcmVxdWVuY3k6IDIwME1IegoJCUxpbmsgRXJyb3I6IDxQcm90LSA8T3ZmbC0gPEVP
Qy0gQ1RMVG0tCgkJTGluayBGcmVxdWVuY3kgQ2FwYWJpbGl0eTogMjAwTUh6KyAzMDBNSHotIDQw
ME1IeisgNTAwTUh6LSA2MDBNSHorIDgwME1IeisgMS4wR0h6KyAxLjJHSHotIDEuNEdIei0gMS42
R0h6LSBWZW5kLQoJCUZlYXR1cmUgQ2FwYWJpbGl0eTogSXNvY0ZDLSBMRFRTVE9QKyBDUkNUTS0g
RUNUTFQtIDY0YkEtIFVJRFJELSBFeHRSUy0gVUNuZkUtCglDYXBhYmlsaXRpZXM6IFthMF0gSHlw
ZXJUcmFuc3BvcnQ6IEhvc3Qgb3IgU2Vjb25kYXJ5IEludGVyZmFjZQoJCUNvbW1hbmQ6IFdhcm1S
c3QrIERibEVuZC0gRGV2TnVtPTAgQ2hhaW5TaWRlLSBIb3N0SGlkZSsgU2xhdmUtIDxFT0NFcnIt
IERVTC0KCQlMaW5rIENvbnRyb2w6IENGbEUtIENTVC0gQ0ZFLSA8TGtGYWlsLSBJbml0KyBFT0Mt
IFRYTy0gPENSQ0Vycj0wIElzb2NFbi0gTFNFbi0gRXh0Q1RMLSA2NGItCgkJTGluayBDb25maWc6
IE1MV0k9MTZiaXQgRHdGY0luLSBNTFdPPTE2Yml0IER3RmNPdXQtIExXST0xNmJpdCBEd0ZjSW5F
bi0gTFdPPTE2Yml0IER3RmNPdXRFbi0KCQlSZXZpc2lvbiBJRDogMS4wMgoJCUxpbmsgRnJlcXVl
bmN5OiAxLjBHSHoKCQlMaW5rIEVycm9yOiA8UHJvdC0gPE92ZmwtIDxFT0MtIENUTFRtLQoJCUxp
bmsgRnJlcXVlbmN5IENhcGFiaWxpdHk6IDIwME1IeisgMzAwTUh6LSA0MDBNSHorIDUwME1Iei0g
NjAwTUh6KyA4MDBNSHorIDEuMEdIeisgMS4yR0h6LSAxLjRHSHotIDEuNkdIei0gVmVuZC0KCQlG
ZWF0dXJlIENhcGFiaWxpdHk6IElzb2NGQy0gTERUU1RPUCsgQ1JDVE0tIEVDVExULSA2NGJBLSBV
SURSRC0gRXh0UlMtIFVDbmZFLQoJQ2FwYWJpbGl0aWVzOiBbYzBdIEh5cGVyVHJhbnNwb3J0OiBI
b3N0IG9yIFNlY29uZGFyeSBJbnRlcmZhY2UKCQlDb21tYW5kOiBXYXJtUnN0KyBEYmxFbmQtIERl
dk51bT0wIENoYWluU2lkZS0gSG9zdEhpZGUrIFNsYXZlLSA8RU9DRXJyLSBEVUwtCgkJTGluayBD
b250cm9sOiBDRmxFLSBDU1QtIENGRS0gPExrRmFpbCsgSW5pdC0gRU9DKyBUWE8rIDxDUkNFcnI9
MCBJc29jRW4tIExTRW4tIEV4dENUTC0gNjRiLQoJCUxpbmsgQ29uZmlnOiBNTFdJPTE2Yml0IER3
RmNJbi0gTUxXTz0xNmJpdCBEd0ZjT3V0LSBMV0k9Ti9DIER3RmNJbkVuLSBMV089Ti9DIER3RmNP
dXRFbi0KCQlSZXZpc2lvbiBJRDogMS4wMgoJCUxpbmsgRnJlcXVlbmN5OiAyMDBNSHoKCQlMaW5r
IEVycm9yOiA8UHJvdC0gPE92ZmwtIDxFT0MtIENUTFRtLQoJCUxpbmsgRnJlcXVlbmN5IENhcGFi
aWxpdHk6IDIwME1IeisgMzAwTUh6LSA0MDBNSHorIDUwME1Iei0gNjAwTUh6KyA4MDBNSHorIDEu
MEdIeisgMS4yR0h6LSAxLjRHSHotIDEuNkdIei0gVmVuZC0KCQlGZWF0dXJlIENhcGFiaWxpdHk6
IElzb2NGQy0gTERUU1RPUCsgQ1JDVE0tIEVDVExULSA2NGJBLSBVSURSRC0gRXh0UlMtIFVDbmZF
LQoKMDA6MTkuMSBIb3N0IGJyaWRnZTogQWR2YW5jZWQgTWljcm8gRGV2aWNlcyBbQU1EXSBLOCBb
QXRobG9uNjQvT3B0ZXJvbl0gQWRkcmVzcyBNYXAKCUNvbnRyb2w6IEkvTy0gTWVtLSBCdXNNYXN0
ZXItIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIt
IEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcC0gNjZNSHotIFVERi0gRmFzdEIyQi0gUGFy
RXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlIt
IElOVHgtCgowMDoxOS4yIEhvc3QgYnJpZGdlOiBBZHZhbmNlZCBNaWNybyBEZXZpY2VzIFtBTURd
IEs4IFtBdGhsb242NC9PcHRlcm9uXSBEUkFNIENvbnRyb2xsZXIKCUNvbnRyb2w6IEkvTy0gTWVt
LSBCdXNNYXN0ZXItIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBp
bmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcC0gNjZNSHotIFVERi0gRmFz
dEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VS
Ui0gPFBFUlItIElOVHgtCgowMDoxOS4zIEhvc3QgYnJpZGdlOiBBZHZhbmNlZCBNaWNybyBEZXZp
Y2VzIFtBTURdIEs4IFtBdGhsb242NC9PcHRlcm9uXSBNaXNjZWxsYW5lb3VzIENvbnRyb2wKCUNv
bnRyb2w6IEkvTy0gTWVtLSBCdXNNYXN0ZXItIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3At
IFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsg
NjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0
LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglDYXBhYmlsaXRpZXM6IFtmMF0gU2VjdXJl
IGRldmljZSA8Pz4KCjAxOjAwLjAgVkdBIGNvbXBhdGlibGUgY29udHJvbGxlcjogQVRJIFRlY2hu
b2xvZ2llcyBJbmMgUlYzNzAgNUI2MCBbUmFkZW9uIFgzMDAgKFBDSUUpXSAocHJvZy1pZiAwMCBb
VkdBIGNvbnRyb2xsZXJdKQoJU3Vic3lzdGVtOiBBU1VTVGVLIENvbXB1dGVyIEluYy4gRGV2aWNl
IDAwODMKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0g
VkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0
dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0
LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNo
ZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMjgK
CVJlZ2lvbiAwOiBNZW1vcnkgYXQgZTAwMDAwMDAgKDMyLWJpdCwgcHJlZmV0Y2hhYmxlKSBbc2l6
ZT0xMjhNXQoJUmVnaW9uIDE6IEkvTyBwb3J0cyBhdCBkMDAwIFtzaXplPTI1Nl0KCVJlZ2lvbiAy
OiBNZW1vcnkgYXQgZWZiZjAwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9NjRL
XQoJRXhwYW5zaW9uIFJPTSBhdCBlZmJjMDAwMCBbZGlzYWJsZWRdIFtzaXplPTEyOEtdCglDYXBh
YmlsaXRpZXM6IFs1MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xr
LSBEU0ktIEQxKyBEMisgQXV4Q3VycmVudD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2Nv
bGQtKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAg
UE1FLQoJQ2FwYWJpbGl0aWVzOiBbNThdIEV4cHJlc3MgKHYxKSBFbmRwb2ludCwgTVNJIDAwCgkJ
RGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDwx
MjhucywgTDEgPDJ1cwoJCQlFeHRUYWcrIEF0dG5CdG4tIEF0dG5JbmQtIFB3ckluZC0gUkJFLSBG
TFJlc2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0g
RmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkKyBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdy
LSBOb1Nub29wKwoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSAxMjggYnl0ZXMK
CQlEZXZTdGE6CUNvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdy
LSBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMwLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MTYs
IEFTUE0gTDBzIEwxLCBMYXRlbmN5IEwwIDwxMjhucywgTDEgPDF1cwoJCQlDbG9ja1BNLSBTdXJw
cmlzZS0gTExBY3RSZXAtIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5
dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0
V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4
MTYsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3RpdmUtIEJXTWdtdC0gQUJXTWdtdC0KCUNh
cGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdCsK
CQlBZGRyZXNzOiAwMDAwMDAwMGZlZTBmMDBjICBEYXRhOiA0MTcxCgowMTowMC4xIERpc3BsYXkg
Y29udHJvbGxlcjogQVRJIFRlY2hub2xvZ2llcyBJbmMgUlYzNzAgW1JhZGVvbiBYMzAwU0VdCglT
dWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2UgMDA4MgoJQ29udHJvbDogSS9P
KyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBT
dGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURG
LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQt
ID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0
ZXMKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZWZiZTAwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJs
ZSkgW3NpemU9NjRLXQoJQ2FwYWJpbGl0aWVzOiBbNTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lv
biAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMSsgRDIrIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0s
RDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJs
ZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzU4XSBFeHByZXNzICh2MSkg
RW5kcG9pbnQsIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVu
YyAwLCBMYXRlbmN5IEwwcyA8MTI4bnMsIEwxIDwydXMKCQkJRXh0VGFnLSBBdHRuQnRuLSBBdHRu
SW5kLSBQd3JJbmQtIFJCRS0gRkxSZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJl
Y3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9yZC0gRXh0VGFn
LSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1h
eFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBVbmNvcnJFcnItIEZhdGFsRXJy
LSBVbnN1cHBSZXEtIEF1eFB3ci0gVHJhbnNQZW5kLQoJCUxua0NhcDoJUG9ydCAjMCwgU3BlZWQg
Mi41R1QvcywgV2lkdGggeDE2LCBBU1BNIEwwcyBMMSwgTGF0ZW5jeSBMMCA8MTI4bnMsIEwxIDwx
dXMKCQkJQ2xvY2tQTS0gU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KCQlMbmtDdGw6CUFTUE0g
RGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsay0KCQkJRXh0
U3luY2gtIENsb2NrUE0tIEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3Bl
ZWQgMi41R1QvcywgV2lkdGggeDE2LCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBC
V01nbXQtIEFCV01nbXQtCgowMjowMC4wIEV0aGVybmV0IGNvbnRyb2xsZXI6IEJyb2FkY29tIENv
cnBvcmF0aW9uIE5ldFh0cmVtZSBCQ001NzU0IEdpZ2FiaXQgRXRoZXJuZXQgUENJIEV4cHJlc3Mg
KHJldiAwMikKCVN1YnN5c3RlbTogQVNVU1RlSyBDb21wdXRlciBJbmMuIERldmljZSA4MjA5CglD
b250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29w
LSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSKyBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAr
IDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9y
dC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBT
aXplOiA2NCBieXRlcwoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDE3CglSZWdpb24g
MDogTWVtb3J5IGF0IGVmY2YwMDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTY0
S10KCUNhcGFiaWxpdGllczogWzQ4XSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMwoJCUZsYWdz
OiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNo
b3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QrIFBNRS1FbmFibGUtIERTZWw9MCBE
U2NhbGU9MSBQTUUtCglDYXBhYmlsaXRpZXM6IFs1MF0gVml0YWwgUHJvZHVjdCBEYXRhCgkJTm90
IHJlYWRhYmxlCglDYXBhYmlsaXRpZXM6IFs1OF0gVmVuZG9yIFNwZWNpZmljIEluZm9ybWF0aW9u
IDw/PgoJQ2FwYWJpbGl0aWVzOiBbZThdIE1TSTogRW5hYmxlLSBDb3VudD0xLzEgTWFza2FibGUt
IDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAwZmVlMDEwMGMgIERhdGE6IDQxYzEKCUNhcGFiaWxp
dGllczogW2QwXSBFeHByZXNzICh2MSkgRW5kcG9pbnQsIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5
bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NHVzLCBMMSB1bmxpbWl0
ZWQKCQkJRXh0VGFnKyBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRSsgRkxSZXNldC0KCQlE
ZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1
cHBvcnRlZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0K
CQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgNDA5NiBieXRlcwoJCURldlN0YToJ
Q29yckVycisgVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxKyBBdXhQd3IrIFRyYW5zUGVu
ZC0KCQlMbmtDYXA6CVBvcnQgIzAsIFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcywg
TGF0ZW5jeSBMMCA8NHVzLCBMMSA8NjR1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0gTExBY3RSZXAt
IEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBS
ZXRyYWluLSBDb21tQ2xrKwoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0g
QXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgVHJFcnItIFRyYWlu
LSBTbG90Q2xrKyBETEFjdGl2ZS0gQldNZ210LSBBQldNZ210LQoKMDM6MDAuMCBFdGhlcm5ldCBj
b250cm9sbGVyOiBCcm9hZGNvbSBDb3Jwb3JhdGlvbiBOZXRYdHJlbWUgQkNNNTc1NCBHaWdhYml0
IEV0aGVybmV0IFBDSSBFeHByZXNzIChyZXYgMDIpCglTdWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0
ZXIgSW5jLiBEZXZpY2UgODIwOQoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5
Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUisgRmFzdEIyQi0g
RGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNF
TD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxh
dGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUludGVycnVwdDogcGluIEEgcm91
dGVkIHRvIElSUSAxOAoJUmVnaW9uIDA6IE1lbW9yeSBhdCBlZmRmMDAwMCAoNjQtYml0LCBub24t
cHJlZmV0Y2hhYmxlKSBbc2l6ZT02NEtdCglDYXBhYmlsaXRpZXM6IFs0OF0gUG93ZXIgTWFuYWdl
bWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0w
bUEgUE1FKEQwLSxEMS0sRDItLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0
KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTEgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNTBdIFZp
dGFsIFByb2R1Y3QgRGF0YQoJCU5vdCByZWFkYWJsZQoJQ2FwYWJpbGl0aWVzOiBbNThdIFZlbmRv
ciBTcGVjaWZpYyBJbmZvcm1hdGlvbiA8Pz4KCUNhcGFiaWxpdGllczogW2U4XSBNU0k6IEVuYWJs
ZS0gQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMGZlZTBmMDBj
ICBEYXRhOiA0MWI5CglDYXBhYmlsaXRpZXM6IFtkMF0gRXhwcmVzcyAodjEpIEVuZHBvaW50LCBN
U0kgMDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5j
eSBMMHMgPDR1cywgTDEgdW5saW1pdGVkCgkJCUV4dFRhZysgQXR0bkJ0bi0gQXR0bkluZC0gUHdy
SW5kLSBSQkUrIEZMUmVzZXQtCgkJRGV2Q3RsOglSZXBvcnQgZXJyb3JzOiBDb3JyZWN0YWJsZS0g
Tm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBwb3J0ZWQtCgkJCVJseGRPcmQtIEV4dFRhZy0gUGhhbnRG
dW5jLSBBdXhQd3ItIE5vU25vb3AtCgkJCU1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVx
IDQwOTYgYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnIrIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3Vw
cFJlcSsgQXV4UHdyKyBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMwLCBTcGVlZCAyLjVHVC9z
LCBXaWR0aCB4MSwgQVNQTSBMMHMsIExhdGVuY3kgTDAgPDR1cywgTDEgPDY0dXMKCQkJQ2xvY2tQ
TS0gU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KCQlMbmtDdGw6CUFTUE0gRGlzYWJsZWQ7IFJD
QiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsaysKCQkJRXh0U3luY2gtIENsb2Nr
UE0tIEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3BlZWQgMi41R1Qvcywg
V2lkdGggeDEsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3RpdmUtIEJXTWdtdC0gQUJXTWdt
dC0KCjA0OjAwLjAgTWFzcyBzdG9yYWdlIGNvbnRyb2xsZXI6IFNpbGljb24gSW1hZ2UsIEluYy4g
U2lJIDMxMzIgU2VyaWFsIEFUQSBSYWlkIElJIENvbnRyb2xsZXIgKHJldiAwMSkKCVN1YnN5c3Rl
bTogQVNVU1RlSyBDb21wdXRlciBJbmMuIERldmljZSA4MTlmCglDb250cm9sOiBJL08rIE1lbSsg
QnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5n
LSBTRVJSKyBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlIt
IDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJSW50
ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDI5CglSZWdpb24gMDogTWVtb3J5IGF0IGVmZWZm
YzAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTEyOF0KCVJlZ2lvbiAyOiBNZW1v
cnkgYXQgZWZlZjgwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MTZLXQoJUmVn
aW9uIDQ6IEkvTyBwb3J0cyBhdCBlYzAwIFtzaXplPTEyOF0KCUV4cGFuc2lvbiBST00gYXQgZWZl
MDAwMDAgW2Rpc2FibGVkXSBbc2l6ZT01MTJLXQoJQ2FwYWJpbGl0aWVzOiBbNTRdIFBvd2VyIE1h
bmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJKyBEMSsgRDIrIEF1eEN1cnJl
bnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29m
dFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0xIFBNRS0KCUNhcGFiaWxpdGllczogWzVj
XSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAw
MDAwMGZlZTBmMDBjICBEYXRhOiA0MTc5CglDYXBhYmlsaXRpZXM6IFs3MF0gRXhwcmVzcyAodjEp
IExlZ2FjeSBFbmRwb2ludCwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDEwMjQgYnl0ZXMs
IFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIEF0dG5C
dG4tIEF0dG5JbmQtIFB3ckluZC0gUkJFLSBGTFJlc2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9y
czogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3Jk
LSBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXlsb2FkIDEyOCBi
eXRlcywgTWF4UmVhZFJlcSA0MDk2IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBVbmNvcnJFcnIr
IEZhdGFsRXJyLSBVbnN1cHBSZXErIEF1eFB3ci0gVHJhbnNQZW5kLQoJCUxua0NhcDoJUG9ydCAj
MCwgU3BlZWQgMi41R1QvcywgV2lkdGggeDEsIEFTUE0gTDBzLCBMYXRlbmN5IEwwIHVubGltaXRl
ZCwgTDEgdW5saW1pdGVkCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcC0gQndOb3QtCgkJ
TG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENv
bW1DbGstCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0K
CQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsr
IERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCgowNTowNi4wIE11bHRpbWVkaWEgdmlkZW8gY29u
dHJvbGxlcjogQnJvb2t0cmVlIENvcnBvcmF0aW9uIEJ0ODc4IFZpZGVvIENhcHR1cmUgKHJldiAx
MSkKCVN1YnN5c3RlbTogSGF1cHBhdWdlIGNvbXB1dGVyIHdvcmtzIEluYy4gV2luVFYgU2VyaWVz
CglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNu
b29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSKyBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBD
YXArIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8
VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiA2NCAoNDAwMG5z
IG1pbiwgMTAwMDBucyBtYXgpCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTkKCVJl
Z2lvbiAwOiBNZW1vcnkgYXQgZWVmZmYwMDAgKDMyLWJpdCwgcHJlZmV0Y2hhYmxlKSBbc2l6ZT00
S10KCUNhcGFiaWxpdGllczogWzQ0XSBWaXRhbCBQcm9kdWN0IERhdGEKCQlOb3QgcmVhZGFibGUK
CUNhcGFiaWxpdGllczogWzRjXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQ
TUVDbGstIERTSSsgRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3Qt
LEQzY29sZC0pCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2Nh
bGU9MCBQTUUtCgowNTowNi4xIE11bHRpbWVkaWEgY29udHJvbGxlcjogQnJvb2t0cmVlIENvcnBv
cmF0aW9uIEJ0ODc4IEF1ZGlvIENhcHR1cmUgKHJldiAxMSkKCVN1YnN5c3RlbTogSGF1cHBhdWdl
IGNvbXB1dGVyIHdvcmtzIEluYy4gV2luVFYgU2VyaWVzCglDb250cm9sOiBJL08tIE1lbSsgQnVz
TWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSKyBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIr
IFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0g
PFBFUlItIElOVHgtCglMYXRlbmN5OiA2NCAoMTAwMG5zIG1pbiwgNjM3NTBucyBtYXgpCglJbnRl
cnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTkKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZWVmZmUw
MDAgKDMyLWJpdCwgcHJlZmV0Y2hhYmxlKSBbc2l6ZT00S10KCUNhcGFiaWxpdGllczogWzQ0XSBW
aXRhbCBQcm9kdWN0IERhdGEKCQlOb3QgcmVhZGFibGUKCUNhcGFiaWxpdGllczogWzRjXSBQb3dl
ciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSSsgRDEtIEQyLSBBdXhD
dXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3QtLEQzY29sZC0pCgkJU3RhdHVzOiBEMCBO
b1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCgowNTowOC4wIEZpcmVX
aXJlIChJRUVFIDEzOTQpOiBUZXhhcyBJbnN0cnVtZW50cyBUU0I0M0FCMjIvQSBJRUVFLTEzOTRh
LTIwMDAgQ29udHJvbGxlciAoUEhZL0xpbmspIChwcm9nLWlmIDEwIFtPSENJXSkKCVN1YnN5c3Rl
bTogQVNVU1RlSyBDb21wdXRlciBJbmMuIFA1VyBESCBEZWx1eGUgTW90aGVyYm9hcmQKCUNvbnRy
b2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVisgVkdBU25vb3AtIFBh
ckVyci0gU3RlcHBpbmctIFNFUlIrIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZN
SHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQt
IDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDY0ICg1MDBucyBtaW4sIDEw
MDBucyBtYXgpLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglJbnRlcnJ1cHQ6IHBpbiBBIHJv
dXRlZCB0byBJUlEgMTYKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZWZmZmY4MDAgKDMyLWJpdCwgbm9u
LXByZWZldGNoYWJsZSkgW3NpemU9MktdCglSZWdpb24gMTogTWVtb3J5IGF0IGVmZmY4MDAwICgz
Mi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTE2S10KCUNhcGFiaWxpdGllczogWzQ0XSBQ
b3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDErIEQyKyBB
dXhDdXJyZW50PTBtQSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZC0pCgkJU3RhdHVzOiBE
MCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUrCgo=
--001517478afc8d25a4047b8a1721--
