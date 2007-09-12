Return-Path: <linux-kernel-owner+w=401wt.eu-S968001AbXILMdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968001AbXILMdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761695AbXILMdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:33:38 -0400
Received: from mythwiki.de ([85.214.77.21]:54258 "EHLO
	h1079978.serverkompetenz.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757541AbXILMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:33:37 -0400
X-Greylist: delayed 1777 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2007 08:33:36 EDT
Message-ID: <46E7D5AD.7040605@laga.ath.cx>
Date: Wed, 12 Sep 2007 14:03:57 +0200
From: Michael Haas <laga@laga.ath.cx>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: airlied@linux.ie
Subject: Problem: screen partially garbled in i830m (regression)
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------050409090308050707000503"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050409090308050707000503
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hello list,

I sent this mail to David Airlie two weeks ago but I haven't gotten a
reply so far, that's why I'm posting to LKML this time.  Short summary:
874808c6dd429f7431b906a32c7f78a68e7636af broke intel_agp.ko for me, I'm
getting a garbled screen.


--------------------------------

Hello David,

with recent kernels, there seems to be a problem with agpgart for my
i830m chipset. The upper part of the screen is garbled, e.g. I can make
out parts of the image that is to be displayed, but it's chopped and
repeated. The box with which I'm having this problem is a not a regular
PC, but a x86-based set top box called S100. It's got a fanless Celeron
733 MHz and 128M RAM and it's somewhat popular due to its cheapness.
Just makes a nice living-room computer :)  I'll attach the output of
lspci -vvv.
FYI, I'm not using the official X.org driver but its IEGD counterpart.
Unfortunately, the S100 comes with a TV-out encoder chip that's only
supported by their closed source driver. Since the kernel is not tainted
by that, it shouldn't be a problem - similar problems also occur with
X.org drivers.

With working kernels, I'd get the following messages in dmesg:

<--snip-->
[   40.188375] agpgart: Detected an Intel 830M Chipset.
[   40.188741] agpgart: Detected 380K stolen memory.
[   40.199908] agpgart: AGP aperture is 128M @ 0xf0000000
<--snap-->

A broken kernel will result in the following messages:

<--snip-->
Jul 25 16:29:42 mythbuntu-alpha2 kernel: [   44.941473] Linux agpgart
interface v0.102 (c) Dave Jones
Jul 25 16:29:42 mythbuntu-alpha2 kernel: [   44.957021] agpgart:
Detected an Intel 830M Chipset.
Jul 25 16:29:42 mythbuntu-alpha2 kernel: [   44.957605] agpgart: No
pre-allocated video memory detected.
Jul 25 16:29:42 mythbuntu-alpha2 kernel: [   44.968696] agpgart: AGP
aperture is 128M @ 0xf0000000
<--snap-->

I used git-bisect to narrow down change that introduced this problem and
came up with this:

<--snip-->

874808c6dd429f7431b906a32c7f78a68e7636af is first bad commit
commit 874808c6dd429f7431b906a32c7f78a68e7636af
Author: Wang Zhenyu <zhenyu.z.wang@intel.com>
Date:   Wed Jun 6 11:16:25 2007 +0800

  [AGPGART] intel_agp: Add support for G33, Q33 and Q35 chipsets

  This patch adds pci ids for G33, Q33 and Q35 chips, and update with new
  GTT size and stolen mem size detect method on these chips.

  Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
  Signed-off-by: Dave Jones <davej@redhat.com>

:040000 040000 39b18b6860f139cb28a80020dc9347314753e16d
da24fb8672087cdfe6509cd1d4cb189534f887d6 M  drivers
<--snap-->

Particulary, there's a change to agp.h:

<--snip-->
-#define I830_GMCH_GMS_MASK  0x70
+#define I830_GMCH_GMS_MASK  0xF0
<--snap-->

I reverted this change in my git tree and I'm now running
2.6.23-rc3-gb377fd39-dirty without any distortion at all. Do you think
this can be fixed? I'll be glad to provide more Information. Thank you
for your time!


Regards,

Michael





--------------050409090308050707000503
Content-Type: text/plain;
 name="lspci-verbose.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci-verbose.txt"

00:00.0 Host bridge: Intel Corporation 82830 830 Chipset Host Bridge (rev 04)
	Subsystem: Unknown device 7065:8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at <unassigned> (32-bit, prefetchable)
	Capabilities: [40] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation 82830 CGC [Chipset Graphics Controller] (rev 04) (prog-if 00 [VGA])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 0
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation 82830 CGC [Chipset Graphics Controller]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at ff980000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 24c0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 7
	Region 4: I/O ports at e000 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 24c0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 5
	Region 4: I/O ports at e080 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 24c0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 9
	Region 4: I/O ports at e400 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Unknown device 24c0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 10
	Region 0: Memory at ffa7f400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 82) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: ff700000-ff7fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface Bridge (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation Unknown device 24c0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ffa0 [size=16]
	Region 5: Memory at 10000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 02)
	Subsystem: Intel Corporation Unknown device 24c0
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 11
	Region 4: I/O ports at e480 [size=32]

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 02)
	Subsystem: Intel Corporation Unknown device 24c0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 0: I/O ports at e800 [size=256]
	Region 1: I/O ports at ec00 [size=64]
	Region 2: Memory at ffa7fc00 (32-bit, non-prefetchable) [size=512]
	Region 3: Memory at ffa7f800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RT8139
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at ff7fdc00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:07.0 Network controller: Intel Corporation PRO/Wireless 2915ABG Network Connection (rev 05)
	Subsystem: Hewlett-Packard Company Unknown device 1354
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at ff7ff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-


--------------050409090308050707000503--
