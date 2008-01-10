Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYAJOO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYAJOO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 09:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYAJOOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 09:14:19 -0500
Received: from fallback.mail.ru ([194.67.57.14]:11298 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbYAJOOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 09:14:16 -0500
X-Greylist: delayed 1735 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 09:14:14 EST
Message-ID: <4786213F.6070601@mail.ru>
Date: Thu, 10 Jan 2008 15:44:31 +0200
From: Alexander <aledin@mail.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM REMAINS: [sata_nv ADMA breaks ATAPI] Crash on accessing DVD-RAM
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The problem described at https://bugzilla.redhat.com/show_bug.cgi?id=351451 and
at http://ubuntuforums.org/showthread.php?t=655772 and supposedly fixed by the
patch http://kerneltrap.org/mailarchive/linux-kernel/2007/11/25/445094 is still
there. I have compiled 2.6.24-rc7 kernel and booted my PC with it just to find
out that my SATA DVD-RW is

sr0: scsi3-mmc drive: 0x/0x caddy

as it was before with 2.6.23.12 and earlier 2.6 kernels compiled for x86_64.
Trying to use sr0 after this results in dead hang or reboot.
When I put sata_nv.adma=0 or mem=4096M then it's all ok:

sr0: scsi3-mmc drive: 94x/94x writer dvd-ram cd/rw xa/form2 cdda tray

and DVD works normally.

My system has 4G of physical memory, but when I use mem=4096M kernel sees only
3406720k. It is obvious that when limiting memory by mem=4096M kernel doesn't
use the last range provided by BIOS:

Command line: BOOT_IMAGE=new ro root=805 mem=4096M 1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
 BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
 BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
 BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 851680) 1 entries of 256 used
end_pfn_map = 1048576

I guess it is because of holes in between those ranges. And my SATA DVD-RW works
ok. But when I don't limit memory or limit it starting from mem=4098M and above,
my SATA DVD-RW is not detected correctly and does not work.

I noticed that when memory is not limited, the buffer pointed to by unsinged
char *buffer in function get_capabilites in driver sr.c contains all zeros
instead of some reasonable values when function scsi_mode_sense returns on the
line 766. This leads to

sr0: scsi3-mmc drive: 0x/0x caddy

and wrong device behavior.

By the way, there is no such problem with kernels compiled for x86_32.

lspci -vv

00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
	Subsystem: ASUSTeK Computer Inc. A8N-E Mainboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn-
LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn-
LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn-
LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn-
LWO=8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+
1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz-
1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE-
ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [e0] HyperTransport: MSI Mapping

00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev f3)
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0

00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 255
	Region 0: I/O ports at fc00 [size=32]
	Region 4: I/O ports at 4c00 [size=64]
	Region 5: I/O ports at 4c40 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
(prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 255
	Region 0: Memory at fe02f000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
(prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 255
	Region 0: Memory at feb00000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio
Controller (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 822c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at f000 [size=256]
	Region 1: I/O ports at ec00 [size=256]
	Region 2: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2) (prog-if 8a [Master
SecP PriP])
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled]
[size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled]
[size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled]
[size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled]
[size=1]
	Region 4: I/O ports at e800 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
(prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. A8N-E Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at 09f0 [size=8]
	Region 1: I/O ports at 0bf0 [size=4]
	Region 2: I/O ports at 0970 [size=8]
	Region 3: I/O ports at 0b70 [size=4]
	Region 4: I/O ports at d400 [size=16]
	Region 5: Memory at fe02c000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
(prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at 09e0 [size=8]
	Region 1: I/O ports at 0be0 [size=4]
	Region 2: I/O ports at 0960 [size=8]
	Region 3: I/O ports at 0b60 [size=4]
	Region 4: I/O ports at c000 [size=16]
	Region 5: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev f2) (prog-if 01
[Subtractive decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=128
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev f3)
	Subsystem: ASUSTeK Computer Inc. Unknown device 812a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at bc00 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) (prog-if 00
[Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [58] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x2, ASPM L0s, Port 3
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 8, PowerLimit 25.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-

00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) (prog-if 00
[Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [58] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 2
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 4, PowerLimit 10.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-

00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) (prog-if 00
[Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [58] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 1
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 2, PowerLimit 10.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-

00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00
[Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: fa000000-fdffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [58] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s, Port 0
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 1, PowerLimit 75.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM
Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Capabilities: [f0] #0f [0010]

05:00.0 VGA compatible controller: nVidia Corporation GeForce 8500 GT (rev a1)
(prog-if 00 [VGA])
	Subsystem: CardExpert Technology Unknown device 1401
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at ac00 [size=128]
	Expansion ROM at fdfe0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <512ns, L1 <4us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x16





dmidecode


# dmidecode 2.9
SMBIOS 2.4 present.
67 structures occupying 2021 bytes.
Table at 0x000F0000.

Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
	Vendor: Phoenix Technologies, LTD
	Version: ASUS M2N4-SLI ACPI BIOS Revision 1203
	Release Date: 09/10/2007
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 512 kB
	Characteristics:
		PCI is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/360 KB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported

Handle 0x0001, DMI type 1, 25 bytes
System Information
	Manufacturer: System manufacturer
	Product Name: System Product Name
	Version: System Version
	Serial Number: System Serial Number
	UUID: 80C22D9C-9C7A-DA11-AC1C-00173158F855
	Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: ASUSTeK Computer INC.
	Product Name: M2N4-SLI
	Version: 1.XX
	Serial Number: 123456789000

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: Chassis Manufacture
	Type: Desktop
	Lock: Not Present
	Version: Chassis Version
	Serial Number: EVAL
	Asset Tag: 123456789000
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000001

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: Socket AM2
	Type: Central Processor
	Family: Athlon 64
	Manufacturer: AMD
	ID: 33 0F 04 00 FF FB 8B 17
	Signature: Family 15, Model 67, Stepping 3
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		HTT (Hyper-threading technology)
	Version: AMD Athlon(tm) 64 X2 Dual Core Processor 5600+
	Voltage: 1.3 V
	External Clock: 200 MHz
	Max Speed: 3700 MHz
	Current Speed: 2800 MHz
	Status: Populated, Enabled
	Upgrade: Socket 940
	L1 Cache Handle: 0x000B
	L2 Cache Handle: 0x000D
	L3 Cache Handle: Not Provided
	Serial Number:
	Asset Tag:
	Part Number:

Handle 0x0005, DMI type 4, 35 bytes
Processor Information
	Socket Designation: Socket AM2
	Type: Central Processor
	Family: Athlon 64
	Manufacturer: AMD
	ID: 33 0F 04 00 FF FB 8B 17
	Signature: Family 15, Model 67, Stepping 3
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		HTT (Hyper-threading technology)
	Version: AMD Athlon(tm) 64 X2 Dual Core Processor 5600+
	Voltage: 1.3 V
	External Clock: 200 MHz
	Max Speed: 3700 MHz
	Current Speed: 2800 MHz
	Status: Populated, Enabled
	Upgrade: Socket 940
	L1 Cache Handle: 0x000C
	L2 Cache Handle: 0x000E
	L3 Cache Handle: Not Provided
	Serial Number:
	Asset Tag:
	Part Number:

Handle 0x0006, DMI type 5, 24 bytes
Memory Controller Information
	Error Detecting Method: 64-bit ECC
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 1024 MB
	Maximum Total Memory Size: 4096 MB
	Supported Speeds:
		70 ns
		60 ns
		50 ns
	Supported Memory Types:
		Standard
		SDRAM
	Memory Module Voltage: 2.9 V
	Associated Memory Slots: 4
		0x0007
		0x0008
		0x0009
		0x000A
	Enabled Error Correcting Capabilities: None

Handle 0x0007, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM_A1
	Bank Connections: 0 1
	Current Speed: 5 ns
	Type: Unknown EDO
	Installed Size: 2048 MB (Double-bank Connection)
	Enabled Size: 2048 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM_B1
	Bank Connections: 2 3
	Current Speed: 5 ns
	Type: Unknown EDO
	Installed Size: 2048 MB (Double-bank Connection)
	Enabled Size: 2048 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM_A2
	Bank Connections: None
	Current Speed: Unknown
	Type: Unknown
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x000A, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM_B2
	Bank Connections: None
	Current Speed: Unknown
	Type: Unknown
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 KB
	Maximum Size: 128 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 4-way Set-associative

Handle 0x000C, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 KB
	Maximum Size: 128 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 4-way Set-associative

Handle 0x000D, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 1024 KB
	Maximum Size: 1024 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x000E, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 1024 KB
	Maximum Size: 1024 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PRI_IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SEC_IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: FLOPPY
	Internal Connector Type: On Board Floppy
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: 8251 FIFO Compatible

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator:
	External Connector Type: DB-9 male
	Port Type: Serial Port 16450 Compatible

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LPT1
	Internal Connector Type: DB-25 female
	External Reference Designator:
	External Connector Type: DB-25 female
	Port Type: Parallel Port ECP/EPP

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS/2 Keyboard
	Internal Connector Type: PS/2
	External Reference Designator:
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS/2 Mouse
	Internal Connector Type: PS/2
	External Reference Designator:
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB1
	External Connector Type: Other
	Port Type: USB

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB2
	External Connector Type: Other
	Port Type: USB

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB3
	External Connector Type: Other
	Port Type: USB

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB4
	External Connector Type: Other
	Port Type: USB

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB5
	External Connector Type: Other
	Port Type: USB

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB6
	External Connector Type: Other
	Port Type: USB

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB7
	External Connector Type: Other
	Port Type: USB

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB8
	External Connector Type: Other
	Port Type: USB

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB9
	External Connector Type: Other
	Port Type: USB

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB10
	External Connector Type: Other
	Port Type: USB

Handle 0x0020, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LINE_IN
	Internal Connector Type: None
	External Reference Designator: LINE_IN
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0021, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LINE_OUT
	Internal Connector Type: None
	External Reference Designator: LINE_OUT
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0022, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: MIC_IN
	Internal Connector Type: None
	External Reference Designator: MIC_IN
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0023, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CD_IN
	Internal Connector Type: On Board Sound Input From CD-ROM
	External Reference Designator: CD_IN
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0024, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Aux In
	Internal Connector Type: On Board Sound Input From CD-ROM
	External Reference Designator: Aux In
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0025, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SPDIF_OUT
	Internal Connector Type: None
	External Reference Designator: SPDIF_OUT
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0026, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: FP_AUDIO
	Internal Connector Type: Other
	External Reference Designator: FP_AUDIO
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0027, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: LAN_1
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0028, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA1
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0029, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA2
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA3
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA4
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CHASSIS
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CPU_FAN1
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: None

Handle 0x002E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PWR_FAN1
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: None

Handle 0x002F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CHA_FAN1
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: None

Handle 0x0030, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 1
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0031, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 2
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0032, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIEX16_1
	Type: x16 PCI Express
	Current Usage: In Use
	Length: Short
	ID: 3
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0033, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIEX16_2
	Type: x16 PCI Express
	Current Usage: Available
	Length: Short
	ID: 4
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0034, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIEX1_1
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	ID: 5
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0035, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIEX1_2
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	ID: 6
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0036, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 3
		n|US|iso8859-1
		n|US|iso8859-1
		r|CA|iso8859-1
	Currently Installed Language: n|US|iso8859-1

Handle 0x0037, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x0038, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0037
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM_A1
	Bank Locator: Bank0/1
	Type: Unknown
	Type Detail: None
	Speed: 800 MHz (1.2 ns)
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x0039, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0037
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM_B1
	Bank Locator: Bank2/3
	Type: Unknown
	Type Detail: None
	Speed: 800 MHz (1.2 ns)
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x003A, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0037
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM_A2
	Bank Locator: Bank4/5
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x003B, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0037
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM_B2
	Bank Locator: Bank6/7
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x003C, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Array Handle: 0x0037
	Partition Width: 0

Handle 0x003D, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x0038
	Memory Array Mapped Address Handle: 0x003C
	Partition Row Position: 1

Handle 0x003E, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00080000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x0039
	Memory Array Mapped Address Handle: 0x003C
	Partition Row Position: 1

Handle 0x003F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x003A
	Memory Array Mapped Address Handle: 0x003C
	Partition Row Position: 1

Handle 0x0040, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x003B
	Memory Array Mapped Address Handle: 0x003C
	Partition Row Position: 1

Handle 0x0041, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0042, DMI type 127, 4 bytes
End Of Table



Several dmesg (compare all those 'sr0:' lines and 'Memory:' lines):


Linux version 2.6.24-rc7 (aledin@linsta) (gcc version 4.1.2) #2 SMP PREEMPT Wed
Jan 9 23:54:52 EET 2008
Command line: BOOT_IMAGE=new ro root=805 1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
 BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
 BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
 BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 851680) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
end_pfn_map = 1245184
DMI 2.4 present.
ACPI: RSDP 000F6F10, 0024 (r2 Nvidia)
ACPI: XSDT CFEE30C0, 0044 (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
ACPI: FACP CFEE9A40, 00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD        0)
ACPI: DSDT CFEE3240, 67BD (r1 NVIDIA ASUSACPI     1000 MSFT  3000000)
ACPI: FACS CFEE0000, 0040
ACPI: SSDT CFEE9C40, 02CC (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: MCFG CFEE9F80, 003C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
ACPI: APIC CFEE9B80, 007C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 851680) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1245184
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      159
    0:      256 ->   851680
    0:  1048576 ->  1245184
On node 0 totalpages: 1048191
  DMA zone: 56 pages used for memmap
  DMA zone: 1271 pages reserved
  DMA zone: 2672 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 833304 pages, LIFO batch:31
  Normal zone: 2688 pages used for memmap
  Normal zone: 193920 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
swsusp: Registered nosave memory region: 00000000cfee0000 - 00000000cfee3000
swsusp: Registered nosave memory region: 00000000cfee3000 - 00000000cfef0000
swsusp: Registered nosave memory region: 00000000cfef0000 - 00000000cff00000
swsusp: Registered nosave memory region: 00000000cff00000 - 00000000e0000000
swsusp: Registered nosave memory region: 00000000e0000000 - 00000000f0000000
swsusp: Registered nosave memory region: 00000000f0000000 - 00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at d0000000 (gap: cff00000:10100000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 24288 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1029896
Kernel command line: BOOT_IMAGE=new ro root=805 1
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2814.422 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
CPU 0: aperture @ 8000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 8000000
Memory: 4047516k/4980736k available (3166k kernel code, 145080k reserved, 1195k
data, 244k init)
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 5633.55 BogoMIPS (lpj=9384880)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
..MP-BIOS bug: 8254 timer not connected to IO-APIC
Using local APIC timer interrupts.
APIC timer calibration result 12564364
Detected 12.564 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 5631.40 BogoMIPS (lpj=9381450)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ stepping 03
Brought up 2 CPUs
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnpacpi: exceeded the max number of mem resources: 12
pnpacpi: exceeded the max number of mem resources: 12
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 8000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
system 00:01: ioport range 0x4000-0x407f has been reserved
system 00:01: ioport range 0x4080-0x40ff has been reserved
system 00:01: ioport range 0x4400-0x447f has been reserved
system 00:01: ioport range 0x4480-0x44ff has been reserved
system 00:01: ioport range 0x4800-0x487f has been reserved
system 00:01: ioport range 0x4880-0x48ff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x87f has been reserved
system 00:02: ioport range 0x290-0x297 has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0c: iomem range 0xccc00-0xcffff has been reserved
system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
system 00:0c: iomem range 0xcfee0000-0xcfefffff could not be reserved
system 00:0c: iomem range 0xffff0000-0xffffffff has been reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0x100000-0xcfedffff could not be reserved
system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0c: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:0c: iomem range 0xfefff000-0xfeffffff has been reserved
system 00:0c: iomem range 0xfff80000-0xfff80fff has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: a000-afff
  MEM window: fa000000-fdffffff
  PREFETCH window: d0000000-dfffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
fuse init (API version 7.9)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:05:00.0
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
vesafb: framebuffer at 0xfb000000, mapped to 0xffffc20000080000, using 1536k,
total 14336k
vesafb: mode is 1024x768x8, linelength=1024, pages=3
vesafb: scrolling: redraw
vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Fan [FAN] (on)
ACPI: Thermal Zone [THRM] (40 C)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x1374 @ 0, addr 00:17:31:58:f8:55
forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-CK804: IDE controller (0x10de:0x0053 rev 0xf2) at  PCI slot 0000:00:06.0
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev f2) UDMA133 controller
    ide0: BM-DMA at 0xe800-0xe807, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xe808-0xe80f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: ST340014A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: SONY CD-RW CRX320E, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 78165360 sectors (40020 MB) w/2048KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2 < hda5 hda6 hda7 hda8 >
hdc: ATAPI 52X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_nv 0000:00:07.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd400 irq 22
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd408 irq 22
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: Optiarc DVD RW AD-7173S, 1-01, max UDMA/66
ata2.00: configured for UDMA/66
scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7173S  1-01 PQ: 0 ANSI: 5
ata2: bounce limit 0xFFFFFFFF, segment boundary 0xFFFF, hw segs 127
sr0: scsi3-mmc drive: 0x/0x caddy
sr 1:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc000 irq 21
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc008 irq 21
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: SAMSUNG HD200HJ, KF100-06, max UDMA7
ata3.00: 390721968 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD200HJ  KF10 PQ: 0 ANSI: 5
ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 2:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 2:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 >
sd 2:0:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
i2c /dev entries driver
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
it87: Found IT8716F chip at 0x290, revision 0
it87: in3 is VCC (+5V)
atkbd.c: Unknown key pressed (translated set 2, code 0x0 on isa0060/serio0).
atkbd.c: Use 'setkeycodes 00 <keycode>' to make it known.
it87: in7 is VCCH (+5V Stand-By)
atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access
hardware directly.
psmouse.c: Failed to reset mouse on isa0060/serio1
input: ImPS/2 Generic Wheel Mouse as /class/input/input3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:42
2007 UTC).
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:04.0 to 64
intel8x0_measure_ac97_clock: measured 50770 usecs
intel8x0: clocking to 46865
ALSA device list:
  #0: NVidia CK804 with ALC850 at irq 20
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ processors
(2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0xa
powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xc
powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xe
powernow-k8:    3 : fid 0xe (2200 MHz), vid 0x10
powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 244k freed
Adding 4200988k swap on /dev/sda2.  Priority:-1 extents:1 across:4200988k
EXT3 FS on sda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.



dmesg (partial) when sata_nv.adma=0


Linux version 2.6.24-rc7 (aledin@linsta) (gcc version 4.1.2) #2 SMP PREEMPT Wed
Jan 9 23:54:52 EET 2008
Command line: BOOT_IMAGE=new ro root=805 sata_nv.adma=0 1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
 BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
 BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
 BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 851680) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
end_pfn_map = 1245184
...
Memory: 4047516k/4980736k available (3166k kernel code, 145080k reserved, 1195k
data, 244k init)
...
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_nv 0000:00:07.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd400 irq 22
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd408 irq 22
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: Optiarc DVD RW AD-7173S, 1-01, max UDMA/66
ata2.00: configured for UDMA/66
scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7173S  1-01 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 94x/94x writer dvd-ram cd/rw xa/form2 cdda tray
sr 1:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc000 irq 21
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc008 irq 21
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: SAMSUNG HD200HJ, KF100-06, max UDMA7
ata3.00: 390721968 sectors, multi 1: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD200HJ  KF10 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 2:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 >
sd 2:0:0:0: [sda] Attached SCSI disk
...



dmesg (partial) when mem=4096M


Linux version 2.6.24-rc7 (aledin@linsta) (gcc version 4.1.2) #2 SMP PREEMPT Wed
Jan 9 23:54:52 EET 2008
Command line: BOOT_IMAGE=new ro root=805 mem=4096M 1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
 BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
 BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
 BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 851680) 1 entries of 256 used
end_pfn_map = 1048576
...
Memory: 3348128k/3406720k available (3166k kernel code, 58012k reserved, 1195k
data, 244k init)
...
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_nv 0000:00:07.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd400 irq 22
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd408 irq 22
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: Optiarc DVD RW AD-7173S, 1-01, max UDMA/66
ata2.00: configured for UDMA/66
scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7173S  1-01 PQ: 0 ANSI: 5
ata2: bounce limit 0xFFFFFFFF, segment boundary 0xFFFF, hw segs 127
sr0: scsi3-mmc drive: 94x/94x writer dvd-ram cd/rw xa/form2 cdda tray
sr 1:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc000 irq 21
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc008 irq 21
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: SAMSUNG HD200HJ, KF100-06, max UDMA7
ata3.00: 390721968 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD200HJ  KF10 PQ: 0 ANSI: 5
ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 2:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 2:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 >
sd 2:0:0:0: [sda] Attached SCSI disk
...


dmesg (partial) when mem=4098M


Linux version 2.6.24-rc7 (aledin@linsta) (gcc version 4.1.2) #2 SMP PREEMPT Wed
Jan 9 23:54:52 EET 2008
Command line: BOOT_IMAGE=new ro root=805 mem=4098M 1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
 BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
 BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
 BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 851680) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1049088) 2 entries of 256 used
end_pfn_map = 1049088
...
Memory: 3273884k/4196352k available (3166k kernel code, 134360k reserved, 1195k
data, 244k init)
...
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_nv 0000:00:07.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd400 irq 22
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd408 irq 22
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: Optiarc DVD RW AD-7173S, 1-01, max UDMA/66
ata2.00: configured for UDMA/66
scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7173S  1-01 PQ: 0 ANSI: 5
ata2: bounce limit 0xFFFFFFFF, segment boundary 0xFFFF, hw segs 127
sr0: scsi3-mmc drive: 0x/0x caddy
sr 1:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc000 irq 21
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc008 irq 21
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: SAMSUNG HD200HJ, KF100-06, max UDMA7
ata3.00: 390721968 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD200HJ  KF10 PQ: 0 ANSI: 5
ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 2:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 2:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 >
sd 2:0:0:0: [sda] Attached SCSI disk
...




Alexander Pravdin.

