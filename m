Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYFIVGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYFIVGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYFIVGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:06:30 -0400
Received: from ccfadm.eeg.ccf.org ([139.137.100.1]:1126 "HELO
	gateway.eeg.ccf.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751529AbYFIVG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:06:29 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 17:06:29 EDT
Date: Mon, 9 Jun 2008 16:59:41 -0400
From: Greg Wooledge <wooledg@eeg.ccf.org>
To: linux-kernel@vger.kernel.org
Subject: mptspi only sees first LUN
Message-ID: <20080609205941.GM3925@eeg.ccf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not subscribed; please Cc me if you reply.

I've got an Arena Maxtronic SA-6640S RAID cabinet that exports
four array slices as "virtual" disks (same SCSI ID, but a different
LUN for each slice).  However, the mptspi driver in Linux is only
seeing the first LUN.

I am running Debian, and I have tried with etch kernel 2.6.18-6-k7
and with lenny kernel 2.6.24-1-686.  Both give me the same results.

I'm confident that the LUNs are there, because when the computer is
booting, I can see them as devices in both the BIOS setup ("press F2")
and in the LSI SCSI controller's scan (if I don't "press Ctrl-C").
This is all before GRUB loads.

The computer itself is a Sunfire server.  I don't have the model number
handy, but I can find out if needed.

Here are the details from the 2.6.24 kernel.  2.6.24 shows the first
LUN of the RAID array as sda, and then the two internal SATA disks
as sdb and sdc.  2.6.18 found the SATAs as sda and sdb, and then the
first LUN of the array as sdc.  Neither one sees the other three LUNs.

# uname -a
Linux megsvr1 2.6.24-1-686 #1 SMP Thu May 8 02:16:39 UTC 2008 i686 GNU/Linux

# grep _LUN /boot/config-$(uname -r)
CONFIG_SCSI_MULTI_LUN=y

# lsmod | grep mpt
mptspi                 17832  0 
mptscsih               25216  1 mptspi
mptbase                55140  2 mptspi,mptscsih
scsi_transport_spi     22816  1 mptspi
scsi_mod              141164  5 sd_mod,libata,mptspi,mptscsih,scsi_transport_spi

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor:          Model:                  Rev: R0.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SEAGATE ST32500N Rev: n/a 
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SEAGATE ST32500N Rev: n/a 
  Type:   Direct-Access                    ANSI  SCSI revision: 05

# cat /proc/mpt/summary 
ioc0: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=16
ioc1: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=19

# cat /proc/mpt/ioc0/summary 
ioc0: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=16

# cat /proc/mpt/ioc0/info 
ioc0:
  ProductID = 0x0202 (LSI53C1030 C0)
  FWVersion = 0x01032700 (fw_size=40752)
  MsgVersion = 0x0102
  FirstWhoInit = 0x00
  EventState = 0x01
  CurrentHostMfaHighAddr = 0x00000000
  CurrentSenseBufferHighAddr = 0x00000000
  MaxChainDepth = 0x30 frames
  MinBlockSize = 0x20 bytes
  RequestFrames @ 0xdfa02800 (Dma @ 0x1fa02800)
    {CurReqSz=96} x {CurReqDepth=255} = 24480 bytes ^= 0x7000
    {MaxReqSz=96}   {MaxReqDepth=255}
  Frames   @ 0xdfa00000 (Dma @ 0x1fa00000)
    {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^= 0x2880
    {MaxRepSz=128}   {MaxRepDepth=255}
  MaxDevices = 16
  MaxBuses = 1
  PortNumber = 1 (of 1)

# lspci | grep SCSI
03:08.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
03:08.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)

# lspci -n | grep '^03:08\.[01]'
03:08.0 0100: 1000:0030 (rev 08)
03:08.1 0100: 1000:0030 (rev 08)

# dmesg
[... snipped ...]
SCSI subsystem initialized
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 18, io mem 0xfcffac00
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
ACPI: PCI Interrupt 0000:03:08.0[A] -> Link [LNEC] -> GSI 19 (level, low) -> IRQ 16
mptbase: ioc0: Initiating bringup
NFORCE-MCP55: IDE controller (0x10de:0x036e rev 0xa1) at  PCI slot 0000:00:04.0
NFORCE-MCP55: not 100% native mode: will probe irqs later
NFORCE-MCP55: 0000:00:04.0 (rev a1) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
NFORCE-MCP55: IDE port disabled
Probing IDE interface ide0...
libata version 3.00 loaded.
ioc0: LSI53C1030 C0: Capabilities={Initiator,Target}
scsi0 : ioc0: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=16
usb 1-1: new low speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
usb 1-8: new low speed USB device using ohci_hcd and address 3
hda: DV-28E-V, ATAPI CD/DVD-ROM drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
usb 1-8: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Virtual USB MULTIMEDIA KEYBOARD as /class/input/input0
input,hidraw0: USB HID v1.10 Keyboard [Virtual USB MULTIMEDIA KEYBOARD] on usb-0000:00:02.0-1
input: Virtual USB MULTIMEDIA KEYBOARD as /class/input/input1
input,hidraw1: USB HID v1.10 Mouse [Virtual USB MULTIMEDIA KEYBOARD] on usb-0000:00:02.0-1
input: CHICONY HP Basic USB Keyboard as /class/input/input2
input,hidraw2: USB HID v1.10 Keyboard [CHICONY HP Basic USB Keyboard] on usb-0000:00:02.0-8
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
ACPI: PCI Interrupt Link [LNED] enabled at IRQ 18
ACPI: PCI Interrupt 0000:03:08.1[B] -> Link [LNED] -> GSI 18 (level, low) -> IRQ 19
mptbase: ioc1: Initiating bringup
 target0:0:0: mptspi: ioc0: mpt_config failed
ioc1: LSI53C1030 C0: Capabilities={Initiator,Target}
scsi1 : ioc1: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=19
scsi 0:0:0:0: Direct-Access                               R0.0 PQ: 0 ANSI: 5
 target0:0:0: Beginning Domain Validation
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
tg3.c:v3.86 (November 9, 2007)
ACPI: PCI Interrupt 0000:07:04.0[A] -> Link [LNED] -> GSI 18 (level, low) -> IRQ 19
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LMAC] -> GSI 21 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:08.0 to 64
eth0: Tigon3 [partno(BCM95715) rev 9003 PHY(5714)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:1b:24:93:2f:8c
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76148000] dma_mask[64-bit]
ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 17
ACPI: PCI Interrupt 0000:07:04.1[B] -> Link [LNEA] -> GSI 17 (level, low) -> IRQ 21
eth1: Tigon3 [partno(BCM95715) rev 9003 PHY(5714)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:1b:24:93:2f:8d
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76148000] dma_mask[64-bit]
forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 2, addr 00:1b:24:93:2f:8e
forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LMAD] -> GSI 20 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:09.0 to 64
forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x5043 @ 3, addr 00:1b:24:93:2f:8f
forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
sata_nv 0000:00:05.0: version 3.5
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:05.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata1: SATA max UDMA/133 cmd 0xb480 ctl 0xb400 bmdma 0xac00 irq 17
ata2: SATA max UDMA/133 cmd 0xb080 ctl 0xb000 bmdma 0xac08 irq 17
hda: ATAPI 24X DVD-ROM drive, 198kB Cache
Uniform CD-ROM driver Revision: 3.20
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: HPA detected: current 488390625, native 488397168
ata1.00: ATA-7: SEAGATE ST32500NSSUN250G 0741B57R5M,    3.AZK, max UDMA/133
ata1.00: 488390625 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: HPA detected: current 488390625, native 488397168
ata2.00: ATA-7: SEAGATE ST32500NSSUN250G 0741B57R44,    3.AZK, max UDMA/133
ata2.00: 488390625 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
scsi: waiting for bus probes to complete ...
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 4294950912 512-byte hardware sectors (2199015 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: bf 00 00 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 4294950912 512-byte hardware sectors (2199015 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: bf 00 00 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 2:0:0:0: Direct-Access     ATA      SEAGATE ST32500N n/a  PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 488390625 512-byte hardware sectors (250056 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 488390625 512-byte hardware sectors (250056 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 2:0:0:0: [sdb] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      SEAGATE ST32500N n/a  PQ: 0 ANSI: 5
sd 3:0:0:0: [sdc] 488390625 512-byte hardware sectors (250056 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdc] 488390625 512-byte hardware sectors (250056 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2
sd 3:0:0:0: [sdc] Attached SCSI disk
[... snipped ...]
