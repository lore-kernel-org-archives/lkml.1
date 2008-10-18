Return-Path: <linux-kernel-owner+w=401wt.eu-S1750878AbYJRWFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878AbYJRWFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 18:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYJRWFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 18:05:34 -0400
Received: from 75-32-10-169.lightspeed.dllstx.sbcglobal.net ([75.32.10.169]:41785
	"EHLO saluki.dogpad.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYJRWFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 18:05:33 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2008 18:05:33 EDT
Message-ID: <48FA5BDC.6070108@dogpad.net>
Date: Sat, 18 Oct 2008 16:57:48 -0500
From: Joe Harvell <jharvell+lists.linux-kernel@dogpad.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080818)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sw-iommu leak with Ethernet jumbo frames and nfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed a problem with SW-IOMMU allocation failures when using NFS 
over my PCI Ethernet network interface using jumbo frames.  I think it's 
a leak, rather than under-engineered because the problem only happens 
when using NFS and jumbo frames.  When I run netperf at a much higher 
data rate over the NIC, I don't see any problems.  Also, I think it's a 
leak because the problem still occurrs very quickly even when I double 
the SW-IOMMU heap size.

Since this is so easy to reproduce, I am looking for information about 
what data I can collect to help identify the suspected bug.

Here are the details:

Saluki is the machine seeing the exhaustion.  It is an Intel P35 Chipset 
(ASUS-P5K-Deluxe/Wifi)  board with a Core2 E8400 CPU with 4GiB of 
DDR2-800 RAM.  I am running Gentoo kernel 2.6.25-gentoo-r5.   I see the 
problem when reading files from NFS server cujo.  I have seen the 
problem most recently when using mplayer to play a file that resides on 
the NFS server.  I have also seen it when using mytharchive; in this 
case, it is just copying the file from the NFS server.

The Ethernet controller is an on-board Realtek R8110SC using driver 
r8169.  The NFS traffic is going over a tagged VLAN interface using that 
device.  I have set the MTU of both the real and vlan interfaces to 
7200.  The switch supports jumbo frames up to 10240 bytes.

I mount the filesystem from the following entry in my /etc/fstab:

192.168.12.2:/mnt/cujo/mythrec /mnt/cujo/mythrec       nfs,noauto     
bg,rsize=7000,wsize=7000,hard,intr,nfsvers=3,actimeo=0      0 0


Relevant logs on saluki and lspci output are given below:


Oct 17 20:15:30 saluki Linux version 2.6.25-gentoo-r5-saluki 
(joey@saluki) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #1 SMP PREEMPT Sat 
Aug 2 17:37:31 CDT 2008
Oct 17 20:15:30 saluki Kernel command line: root=/dev/ram0 
ramdisk_size=8192 init=/init iommu=soft swiotlb=65536 rw
[...]
Oct 17 20:15:30 saluki PCI-DMA: Using software bounce buffering for IO 
(SWIOTLB)
Oct 17 20:15:30 saluki Placing software IO TLB between 0x9e21000 - 
0x11e21000
Oct 17 20:15:30 saluki Memory: 3977400k/4980736k available (2812k kernel 
code, 215316k reserved, 1371k data, 260k init)
[...]
Oct 17 21:54:13 saluki DMA: Out of SW-IOMMU space for 7214 bytes at 
device 0000:05:04.0
Oct 17 21:54:13 saluki DMA: Out of SW-IOMMU space for 7214 bytes at 
device 0000:05:04.0
Oct 17 21:54:13 saluki DMA: Out of SW-IOMMU space for 7214 bytes at 
device 0000:05:04.0
Oct 17 21:54:13 saluki DMA: Out of SW-IOMMU space for 7214 bytes at 
device 0000:05:04.0
Oct 17 21:54:13 saluki DMA: Out of SW-IOMMU space for 7214 bytes at 
device 0000:05:04.0
Oct 17 21:54:13 saluki DMA: Out of SW-IOMMU space for 7214 bytes at 
device 0000:05:04.0
Oct 17 21:54:13 saluki DMA: Out of SW-IOMMU space for 7214 bytes at 
device 0000:05:04.0
Oct 17 21:54:13 saluki DMA: Out of SW-IOMMU space for 7214 bytes at 
device 0000:05:04.0
[... total of 230 of the above log with the 21:54:13 timestamp alone]

lspci output:
saluki log # lspci -v
00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 8295
        Flags: bus master, fast devsel, latency 0
        Capabilities: [e0] Vendor Specific Information <?>

00:01.0 PCI bridge: Intel Corporation PCI Express Root Port (rev 02) 
(prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: fa000000-fe8fffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
        Capabilities: [88] Subsystem: ASUSTeK Computer Inc. Device 8295
        Capabilities: [80] Power Management version 3
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
        Capabilities: [a0] Express Root Port (Slot+), MSI 00
        Kernel driver in use: pcieport-driver

00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, medium devsel, latency 0, IRQ 16
        I/O ports at a800 [size=32]
        Capabilities: [50] Vendor Specific Information <?>
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, medium devsel, latency 0, IRQ 21
        I/O ports at a880 [size=32]
        Capabilities: [50] Vendor Specific Information <?>
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1a.2 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, medium devsel, latency 0, IRQ 18
        I/O ports at ac00 [size=32]
        Capabilities: [50] Vendor Specific Information <?>
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 
02) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, medium devsel, latency 0, IRQ 18
        Memory at f9fffc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] Vendor Specific Information <?>
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, fast devsel, latency 0, IRQ 22
        Memory at f9ff8000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation PCI Express Port 1 (rev 02) 
(prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        Prefetchable memory behind bridge: 00000000f8f00000-00000000f8ffffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8277
        Capabilities: [a0] Power Management version 2
        Kernel driver in use: pcieport-driver

00:1c.4 PCI bridge: Intel Corporation PCI Express Port 5 (rev 02) 
(prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fea00000-feafffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8277
        Capabilities: [a0] Power Management version 2
        Kernel driver in use: pcieport-driver

00:1c.5 PCI bridge: Intel Corporation PCI Express Port 6 (rev 02) 
(prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fe900000-fe9fffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8277
        Capabilities: [a0] Power Management version 2
        Kernel driver in use: pcieport-driver

00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, medium devsel, latency 0, IRQ 23
        I/O ports at a080 [size=32]
        Capabilities: [50] Vendor Specific Information <?>
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, medium devsel, latency 0, IRQ 19
        I/O ports at a400 [size=32]
        Capabilities: [50] Vendor Specific Information <?>
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 
02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, medium devsel, latency 0, IRQ 18
        I/O ports at a480 [size=32]
        Capabilities: [50] Vendor Specific Information <?>
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 
02) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, medium devsel, latency 0, IRQ 23
        Memory at f9fff800 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] Vendor Specific Information <?>
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 
01 [Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: feb00000-febfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f00fffff
        Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Device 8277

00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, medium devsel, latency 0
        Capabilities: [e0] Vendor Specific Information <?>
        Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation 6 port SATA AHCI Controller 
(rev 02) (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 315
        I/O ports at 9c00 [size=8]
        I/O ports at 9880 [size=4]
        I/O ports at 9800 [size=8]
        I/O ports at 9480 [size=4]
        I/O ports at 9400 [size=32]
        Memory at f9ffe800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/4 Enable+
        Capabilities: [70] Power Management version 3
        Capabilities: [a8] SATA HBA <?>
        Capabilities: [b0] Vendor Specific Information <?>
        Kernel driver in use: ahci
        Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 8277
        Flags: medium devsel, IRQ 18
        Memory at f9fff400 (64-bit, non-prefetchable) [size=256]
        I/O ports at 0400 [size=32]
        Kernel driver in use: i801_smbus
        Kernel modules: i2c-i801

01:00.0 VGA compatible controller: nVidia Corporation GeForce 8800 GT 
(rev a2) (prog-if 00 [VGA controller])
        Subsystem: eVga.com. Corp. Device c802
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
        I/O ports at bc00 [size=128]
        Expansion ROM at fe8e0000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 3
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Capabilities: [78] Express Endpoint, MSI 00
        Kernel driver in use: nvidia
        Kernel modules: nvidia

02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E 
Gigabit Ethernet Controller (rev 12)
        Subsystem: ASUSTeK Computer Inc. Device 81f8
        Flags: bus master, fast devsel, latency 0, IRQ 314
        Memory at fe9fc000 (64-bit, non-prefetchable) [size=16K]
        I/O ports at c800 [size=256]
        Expansion ROM at fe9c0000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 3
        Capabilities: [50] Vital Product Data <?>
        Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable+
        Capabilities: [e0] Express Legacy Endpoint, MSI 00
        Kernel driver in use: sky2
        Kernel modules: sky2

03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 
AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Device 824f
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at feafe000 (32-bit, non-prefetchable) [size=8K]
        Expansion ROM at feae0000 [disabled] [size=64K]
        Capabilities: [68] Power Management version 2
        Capabilities: [50] Express Legacy Endpoint, MSI 01
        Kernel driver in use: ahci
        Kernel modules: ahci

03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 
AHCI Controller (rev 03) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Device 824f
        Flags: bus master, fast devsel, latency 0, IRQ 17
        I/O ports at dc00 [size=8]
        I/O ports at d880 [size=4]
        I/O ports at d800 [size=8]
        I/O ports at d480 [size=4]
        I/O ports at d400 [size=16]
        Capabilities: [68] Power Management version 2
        Kernel driver in use: JMicron IDE
        Kernel modules: ata_generic, pata_jmicron, jmicron

05:04.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8110SC/8169SC Gigabit Ethernet (rev 10)
        Subsystem: ASUSTeK Computer Inc. Device 820d
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
        I/O ports at e800 [size=256]
        Memory at febffc00 (32-bit, non-prefetchable) [size=256]
        Expansion ROM at f0000000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
        Kernel driver in use: r8169
        Kernel modules: r8169




