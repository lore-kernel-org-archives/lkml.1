Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbXI2EQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbXI2EQB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 00:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbXI2EPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 00:15:53 -0400
Received: from avenger.chmurka.net ([62.121.68.209]:50989 "EHLO chmurka.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbXI2EPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 00:15:52 -0400
X-Greylist: delayed 1992 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Sep 2007 00:15:52 EDT
Date: Sat, 29 Sep 2007 05:42:37 +0200 (CEST)
From: Adam Wysocki <gophi-lkml@chmurka.net>
To: linux-kernel@vger.kernel.org
cc: drzeus-list@drzeus.cx, giometti@enneenne.com
Subject: [sdhci] mmc0: unrecognised SCR structure version 1
Message-ID: <Pine.LNX.4.64.0709290538240.5571@news.chmurka.net>
X-Tree: ;>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[CCd to possibly interested Pierre Ossman and Rodolfo Giometti]

Hi there,

First, sorry for my poor english - I am not a native.

I know there have been a thread about this problem few months ago, but as 
far as I see it did not led to any results: 
http://groups.google.com/group/linux.kernel/browse_thread/thread/19116cafe8a20b5/4a28c3b15bb999df

I have the same problem, as described there, with Kingston 2GB SD card. My 
card reader is embedded into Fujitsu-Siemens AMILO Pro V3505 notebook and 
Linux sees it as:

[gophi@amilo ~]$ sudo lspci -vvvs 0a:06.2
0a:06.2 Generic system peripheral [0805]: ENE Technology Inc ENE PCI Secure Digital Card Reader Controller (rev 01) (prog-if 01)
        Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10c1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (8000ns min, 18000ns max), Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 22
        Region 0: Memory at d4101400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

This is the one to which the sdhci driver attached, as regards to sysfs:

[gophi@amilo /sys/bus/pci/drivers/sdhci]$ ls -l
razem 0
lrwxrwxrwx 1 root root    0 2007-09-29 05:03 0000:0a:06.2 -> ../../../../devices/pci0000:00/0000:00:1e.0/0000:0a:06.2
--w------- 1 root root 4096 2007-09-29 05:03 bind
lrwxrwxrwx 1 root root    0 2007-09-29 05:03 module -> ../../../../module/sdhci
--w------- 1 root root 4096 2007-09-29 05:03 new_id
--w------- 1 root root 4096 2007-09-29 05:03 unbind

I also have some other devices in system relevant to the card reader - Memory 
Stick reader and one "unknown device":

[gophi@amilo ~]$ sudo lspci -vvvs 0a:06.4
0a:06.4 FLASH memory: ENE Technology Inc Unknown device 0551 (rev 01)
        Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10c1
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (8000ns min, 18000ns max), Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 255
        Region 0: Memory at d4101100 (32-bit, non-prefetchable) [disabled] [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Kernel version:

[gophi@amilo ~]$ uname -a
Linux amilo 2.6.22.7-amilo #5 SMP PREEMPT Wed Sep 26 16:35:47 CEST 2007 i686 GNU/Linux

I have posted some debugging messages from sdhci here (ca. 44 kB): 
http://www.chmurka.net/r/mmc-debug.txt 

PCMCIA (ide-cs) card reader does not see this card neither, but does not spit 
any error messages - just that the card is not seen in /proc/partitions:

pccard: PCMCIA card inserted into slot 0
cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xdc000-0xfffff
cs: memory probe 0x50000000-0x53ffffff: excluding 0x50000000-0x53ffffff
cs: memory probe 0x60000000-0x60ffffff: clean.
cs: memory probe 0xa0000000-0xa0ffffff: clean.
cs: memory probe 0xd4100000-0xd41fffff: excluding 0xd4100000-0xd410ffff
pcmcia: registering new device pcmcia0.0
Probing IDE interface ide1...
hdc: Memory Card Adapter II, CFA DISK drive
ide1 at 0x3100-0x3107,0x310e on irq 18
ide-cs: hdc: Vpp = 0.0

On the other side, my Canon A610 camera sees and handles this card properly. 
Also does the usb-storage reader:

Initializing USB Mass Storage driver...
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device scan complete
scsi 4:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
scsi 4:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
scsi 4:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
scsi 4:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
sd 4:0:0:0: [sdb] 4022272 512-byte hardware sectors (2059 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] 4022272 512-byte hardware sectors (2059 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 4:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 4:0:0:0: [sdb] Attached SCSI removable disk
sd 4:0:0:1: [sdc] Attached SCSI removable disk
sd 4:0:0:2: [sdd] Attached SCSI removable disk
sd 4:0:0:3: [sde] Attached SCSI removable disk

Any ideas or suggestions?

Thanks in advance.

-- 
[[:pl:user:gophi]]
