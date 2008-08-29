Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYH2Htk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYH2Htk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYH2Htb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:49:31 -0400
Received: from main.gmane.org ([80.91.229.2]:49756 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYH2Ht3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:49:29 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jari Aalto <jari.aalto@cante.net>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Date: Fri, 29 Aug 2008 10:49:11 +0300
Message-ID: <87vdxkb6rs.fsf@jondo.cante.net>
References: <48B76FF5.6010507@yahoo.com.ar>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: a91-155-179-127.elisa-laajakaista.fi
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:a0jCNWnVcKUQvXNUWTjsVWIJEoc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Thu, Aug 28, 2008 at 1:49 PM, Jari Aalto <jari.aalto@cante.net> wrote:
>
>> Krzysztof Halasa <khc@pm.waw.pl> writes:
>>
>>> Jari Aalto <jari.aalto@cante.net> writes:
>>>
>>>> What, if after booting to 2.6.26 and without any 'iommu' boot parameters,
>>>> there still appears "Out of Iommu space" messages? What kind of logs
>>>> should I post?
>>>
>>> You shouldn't be getting "Out of SW-IOMMU space" messages when not
>>> using SW-IOMMU.
>>
>> REF: http://article.gmane.org/gmane.linux.kernel/725293 (thread start)
>>
>> I regret to report that:
>>
>> - Upgraded to kernel 2.6.26-1-amd64 (Debian/unstable 2.6.26-3)
>
> can you send out whole boot log? with "debug initcall_debug"

See below.

> http://people.redhat.com/mingo/tip.git/readme.txt

Could you explain this document a bit. What git commands should I use to
retrive test kernel to build?

1 The vanilla boot. No IOMMU option, no SWIOTLB
  http://sial.org/pbot/32038

2 with iommu=memaper=3
  http://sial.org/pbot/32040

3 with iommu=memaper=3,noagp
  http://sial.org/pbot/32041

4 with iommu=memaper=3,noagp,soft swiotlb=65535
  http://sial.org/pbot/32042

I'm including the diff between [1] and [2]. The script I used is also
attached.

Jari


--=-=-=
Content-Disposition: inline; filename=kernel.bash
Content-Description: bash functions to take dmesg diffs

# DESCRIPTION
#
#    Take diffs between dmesg boot logs. After each boot, save log with:
#
#    $ dmesg > dmesg-$(date +"%Y%m%d%h%m").log
#
# USAGE
#
#
#    $ . kernel.bash
#    $ Diff dmesg1.log dmesg2.log

Clean ()
{
    awk -F: '{$1=""; print}' "$1"
}

Diff ()
{
    ${test+echo} diff -bwu --label "$1" --label "$2" <(Clean "$1") <(Clean "$2")
}

# End of file

--=-=-=


--- dmesg-2.6.26-20080829-vanilla.log
+++ dmesg-2.6.26-20080829-memaper3.log
@@ -1,7 +1,7 @@
 
 
  09 32 UTC 2008
-  root=UUID=cb9d814f-d885-435b-8e6d-ac17c0ac5aa1 ro quiet vga=0x317 debug initcall_debug
+  root=UUID=cb9d814f-d885-435b-8e6d-ac17c0ac5aa1 ro quiet vga=0x317 iommu=memaper=3 debug initcall_debug single
  
   0000000000000000 - 000000000009f000 (usable)
   000000000009f000 - 00000000000a0000 (reserved)
@@ -103,13 +103,13 @@
   32, nr_cpu_ids  4
   2063260
   Normal
-  root=UUID=cb9d814f-d885-435b-8e6d-ac17c0ac5aa1 ro quiet vga=0x317 debug initcall_debug
+  root=UUID=cb9d814f-d885-435b-8e6d-ac17c0ac5aa1 ro quiet vga=0x317 iommu=memaper=3 debug initcall_debug single
 
   4096 (order  12, 32768 bytes)
   2000
 
 
-  Detected 2310.513 MHz processor.
+  Detected 2310.518 MHz processor.
   IRQ7.
   colour dummy device 80x25
 
@@ -120,9 +120,8 @@
 
 
 
-
-  Registered nosave memory  0000000004000000 - 0000000008000000
-  8194600k/9437184k available (2224k kernel code, 192468k reserved, 1080k data, 392k init)
+  Registered nosave memory  0000000020000000 - 0000000030000000
+  7997992k/9437184k available (2224k kernel code, 389076k reserved, 1080k data, 392k init)
   page pool initialized 1 of 1 pages preallocated
 
 
@@ -528,9 +527,9 @@
 
 
   Disabling AGP.
-  aperture base @ 4000000 size 65536 KB
+  aperture base @ 20000000 size 262144 KB
   using GART IOMMU.
-  Reserving 64MB of IOMMU area in the AGP aperture
+  Reserving 256MB of IOMMU area in the AGP aperture
 
 
   at MMIO 0xfefff000, IRQs 2, 8, 31
@@ -964,7 +963,7 @@
 
 
 
- 05  setting system clock to 2008-08-29 06 54 38 UTC (1219992878)
+ 05  setting system clock to 2008-08-29 06 57 31 UTC (1219993051)
 
 
 
@@ -978,124 +977,111 @@
   Expecting a [Reference] package element, found type 0
   LNXTHERM 01 is registered as thermal_zone0
   Thermal Zone [THRM] (40 C)
-  PCI Interrupt Link [APCL] enabled at IRQ 23
-  PCI Interrupt 0000 00 0a.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 23
-  Setting latency timer of device 0000 00 0a.1 to 64
- 00 0a.1  EHCI Host Controller
- 00 0a.1  new USB bus registered, assigned bus number 1
- 00 0a.1  debug port 1
-  cache line size of 64 is not supported by device 0000 00 0a.1
- 00 0a.1  irq 23, io mem 0xfe02e000
-
   2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
+  PCI Interrupt Link [APCF] enabled at IRQ 23
+  PCI Interrupt 0000 00 0a.0[A] -> Link [APCF] -> GSI 23 (level, low) -> IRQ 23
+  Setting latency timer of device 0000 00 0a.0 to 64
+ 00 0a.0  OHCI Host Controller
+ 00 0a.0  new USB bus registered, assigned bus number 1
+ 00 0a.0  irq 23, io mem 0xfe02f000
+
 
 
- 00 0a.1  USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
   configuration #1 chosen from 1 choice
  1.0  USB hub found
  1.0  10 ports detected
   fd0 is 1.44M
 
-  New USB device found, idVendor=1d6b, idProduct=0002
-  New USB device strings  Mfr=3, Product=2, SerialNumber=1
-  Product  EHCI Host Controller
-  Manufacturer  Linux 2.6.26-1-amd64 ehci_hcd
-  SerialNumber  0000 00 0a.1
-  PCI Interrupt Link [APCF] enabled at IRQ 22
-  PCI Interrupt 0000 00 0a.0[A] -> Link [APCF] -> GSI 22 (level, low) -> IRQ 22
-  Setting latency timer of device 0000 00 0a.0 to 64
- 00 0a.0  OHCI Host Controller
- 00 0a.0  new USB bus registered, assigned bus number 2
- 00 0a.0  irq 22, io mem 0xfe02f000
-  configuration #1 chosen from 1 choice
- 1.0  USB hub found
- 1.0  10 ports detected
   New USB device found, idVendor=1d6b, idProduct=0001
   New USB device strings  Mfr=3, Product=2, SerialNumber=1
   Product  OHCI Host Controller
   Manufacturer  Linux 2.6.26-1-amd64 ohci_hcd
   SerialNumber  0000 00 0a.0
+  PCI Interrupt Link [APCL] enabled at IRQ 22
+  PCI Interrupt 0000 00 0a.1[B] -> Link [APCL] -> GSI 22 (level, low) -> IRQ 22
+  Setting latency timer of device 0000 00 0a.1 to 64
+ 00 0a.1  EHCI Host Controller
+ 00 0a.1  new USB bus registered, assigned bus number 2
+ 00 0a.1  debug port 1
+  cache line size of 64 is not supported by device 0000 00 0a.1
+ 00 0a.1  irq 22, io mem 0xfe02e000
+ 00 0a.1  USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
+  configuration #1 chosen from 1 choice
+ 1.0  USB hub found
+ 1.0  10 ports detected
+  New USB device found, idVendor=1d6b, idProduct=0002
+  New USB device strings  Mfr=3, Product=2, SerialNumber=1
+  Product  EHCI Host Controller
+  Manufacturer  Linux 2.6.26-1-amd64 ehci_hcd
+  SerialNumber  0000 00 0a.1
   Reverse Engineered nForce ethernet driver. Version 0.61.
   PCI Interrupt Link [APCH] enabled at IRQ 21
   PCI Interrupt 0000 00 10.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 21
   Setting latency timer of device 0000 00 10.0 to 64
-  new high speed USB device using ehci_hcd and address 3
-  configuration #1 chosen from 1 choice
-  New USB device found, idVendor=0781, idProduct=5406
-  New USB device strings  Mfr=1, Product=2, SerialNumber=3
-  Product  U3 Cruzer Micro
-  Manufacturer  SanDisk Corporation
-  SerialNumber  0000162152754B6C
-
  00 10.0  ifname eth0, PHY OUI 0x5043 @ 1, addr 00 18 f3 84 26 c0
  00 10.0  highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
   PCI Interrupt Link [AMC1] enabled at IRQ 20
   PCI Interrupt 0000 00 11.0[A] -> Link [AMC1] -> GSI 20 (level, low) -> IRQ 20
   Setting latency timer of device 0000 00 11.0 to 64
-  new high speed USB device using ehci_hcd and address 4
+  new high speed USB device using ehci_hcd and address 3
   configuration #1 chosen from 1 choice
   New USB device found, idVendor=0781, idProduct=5406
   New USB device strings  Mfr=1, Product=2, SerialNumber=3
   Product  U3 Cruzer Micro
   Manufacturer  SanDisk Corporation
-  SerialNumber  000016215275A63E
-  new high speed USB device using ehci_hcd and address 5
+  SerialNumber  0000162152754B6C
  00 11.0  ifname eth1, PHY OUI 0x5043 @ 1, addr 00 18 f3 84 36 c0
  00 11.0  highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
   PCI Interrupt Link [APC1] enabled at IRQ 16
   PCI Interrupt 0000 02 0b.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
   fw-host0  OHCI-1394 1.1 (PCI)  IRQ=[16]  MMIO=[fdfff000-fdfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
- 00 0d.0  version 3.5
+
  03 00.0  version 1.1
+  PCI Interrupt Link [APC7] enabled at IRQ 16
+  PCI Interrupt 0000 03 00.0[A] -> Link [APC7] -> GSI 16 (level, low) -> IRQ 16
+  Setting latency timer of device 0000 03 00.0 to 64
+ 00 0d.0  version 3.5
   PCI Interrupt Link [APSI] enabled at IRQ 23
   PCI Interrupt 0000 00 0d.0[A] -> Link [APSI] -> GSI 23 (level, low) -> IRQ 23
  00 0d.0  Using SWNCQ mode
   Setting latency timer of device 0000 00 0d.0 to 64
-  PCI Interrupt Link [APC7] enabled at IRQ 16
-  PCI Interrupt 0000 03 00.0[A] -> Link [APC7] -> GSI 16 (level, low) -> IRQ 16
-  Setting latency timer of device 0000 03 00.0 to 64
-
   Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
-  sata_nv
   sata_sil24
+  sata_nv
   sata_sil24
   SATA max UDMA/100 host m128@0xfdeff000 port 0xfdef8000 irq 16
   SATA max UDMA/100 host m128@0xfdeff000 port 0xfdefa000 irq 16
   sata_nv
   SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xe000 irq 23
   SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xe008 irq 23
+
+  new high speed USB device using ehci_hcd and address 4
   configuration #1 chosen from 1 choice
-  New USB device found, idVendor=0bda, idProduct=8187
+  New USB device found, idVendor=0781, idProduct=5406
   New USB device strings  Mfr=1, Product=2, SerialNumber=3
-  Product  RTL8187_Wireless
-  Manufacturer  Manufacturer_Realtek_RTL8187_
-  SerialNumber  0015AF0B59A6
-  new low speed USB device using ohci_hcd and address 2
+  Product  U3 Cruzer Micro
+  Manufacturer  SanDisk Corporation
+  SerialNumber  000016215275A63E
+  new high speed USB device using ehci_hcd and address 5
   SATA link up 3.0 Gbps (SStatus 123 SControl 300)
   ATA-7  ST31000340AS, SD01, max UDMA/133
   1953525168 sectors, multi 1  LBA48 NCQ (depth 31/32)
   configured for UDMA/133
   configuration #1 chosen from 1 choice
-  New USB device found, idVendor=046d, idProduct=c50c
-  New USB device strings  Mfr=1, Product=2, SerialNumber=0
-  Product  USB Receiver
-  Manufacturer  Logitech
+  New USB device found, idVendor=0bda, idProduct=8187
+  New USB device strings  Mfr=1, Product=2, SerialNumber=3
+  Product  RTL8187_Wireless
+  Manufacturer  Manufacturer_Realtek_RTL8187_
+  SerialNumber  0015AF0B59A6
   SCSI emulation for USB Mass Storage devices
   SCSI emulation for USB Mass Storage devices
-  registered new interface driver usb-storage
-
-  registered new interface driver hiddev
   device found at 3
   waiting for device to settle before scanning
+  registered new interface driver usb-storage
+
   device found at 4
   waiting for device to settle before scanning
-  Logitech USB Receiver as /class/input/input1
-  USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000 00 0a.0-2
-
-  Logitech USB Receiver as /class/input/input2
-  USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000 00 0a.0-2
-  registered new interface driver usbhid
-  v2.6 USB HID core driver
+  new low speed USB device using ohci_hcd and address 2
   SATA link up 1.5 Gbps (SStatus 113 SControl 300)
   ATAPI  TSSTcorp CDDVDW SH-S203N, SB00, max UDMA/100
   configured for UDMA/100
@@ -1109,7 +1095,20 @@
   sata_nv
   SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xcc00 irq 22
   SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xcc08 irq 22
+  configuration #1 chosen from 1 choice
+  New USB device found, idVendor=046d, idProduct=c50c
+  New USB device strings  Mfr=1, Product=2, SerialNumber=0
+  Product  USB Receiver
+  Manufacturer  Logitech
+  registered new interface driver hiddev
+  Logitech USB Receiver as /class/input/input1
+  USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000 00 0a.0-2
   Host added  ID BUS[0-00 1023]  GUID[0011d80000eaece5]
+
+  Logitech USB Receiver as /class/input/input2
+  USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000 00 0a.0-2
+  registered new interface driver usbhid
+  v2.6 USB HID core driver
   SATA link down (SStatus 0 SControl 300)
   SATA link down (SStatus 0 SControl 300)
   PCI Interrupt Link [ASA2] enabled at IRQ 21
@@ -1152,11 +1151,11 @@
 
   mounted filesystem with ordered data mode.
   device scan complete
-  device scan complete
- 0 0 0  Direct-Access     SanDisk  U3 Cruzer Micro  3.27 PQ  0 ANSI  2
  0 0 0  Direct-Access     SanDisk  U3 Cruzer Micro  3.27 PQ  0 ANSI  2
  0 0 1  CD-ROM            SanDisk  U3 Cruzer Micro  3.27 PQ  0 ANSI  2
  0 0 0  [sdb] 8015502 512-byte hardware sectors (4104 MB)
+  device scan complete
+ 0 0 0  Direct-Access     SanDisk  U3 Cruzer Micro  3.27 PQ  0 ANSI  2
  0 0 0  [sdb] Write Protect is off
  0 0 0  [sdb] Mode Sense  03 00 00 00
  0 0 0  [sdb] Assuming drive cache  write through
@@ -1166,8 +1165,8 @@
  0 0 0  [sdb] Assuming drive cache  write through
   sdb1
  0 0 0  [sdb] Attached SCSI removable disk
- 0 0 0  Attached scsi generic sg2 type 0
  0 0 1  CD-ROM            SanDisk  U3 Cruzer Micro  3.27 PQ  0 ANSI  2
+ 0 0 0  Attached scsi generic sg2 type 0
   scsi3-mmc drive  8x/40x writer xa/form2 cdda tray
  0 0 1  Attached scsi CD-ROM sr1
  0 0 1  Attached scsi generic sg3 type 5
@@ -1193,17 +1192,17 @@
   nForce2 SMBus adapter at 0x1c00
   nForce2 SMBus adapter at 0x1c40
   PC Speaker as /class/input/input5
+  Selected rate control algorithm 'pid'
+  Driver 'pcspkr' is already registered, aborting...
   PCI Interrupt Link [AAZA] enabled at IRQ 20
   PCI Interrupt 0000 00 0e.1[B] -> Link [AAZA] -> GSI 20 (level, low) -> IRQ 20
   Setting latency timer of device 0000 00 0e.1 to 64
-  Driver 'pcspkr' is already registered, aborting...
-  Selected rate control algorithm 'pid'
   the driver 'parport_pc' has been registered
  0a  reported by Plug and Play ACPI
   PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
- 0a  driver attached
   hwaddr 00 15 af 0b 59 a6, rtl8187 V1 + rtl8225z2
   registered new interface driver rtl8187
+ 0a  driver attached
 
   module loaded
   module license 'NVIDIA' taints kernel.
@@ -1223,43 +1222,19 @@
   Registered protocol family 10
   Disabled Privacy Extensions
   wlan0  link is not ready
-  Registered udp transport module.
-  Registered tcp transport module.
-
-  Found 1 AMD Athlon(tm) X2 Dual Core Processor BE-2400 processors (2 cpu cores) (version 2.20.00)
-  ACPI Processor support is required for SMP systems but is absent. Please load the ACPI Processor module before starting this driver.
-  ACPI Processor support is required for SMP systems but is absent. Please load the ACPI Processor module before starting this driver.
+  Initial auth_alg=0
+  authenticate with AP 00 18 39 c0 4f 1b
   Initial auth_alg=0
   authenticate with AP 00 18 39 c0 4f 1b
   RX authentication from 00 18 39 c0 4f 1b (alg=0 transaction=2 status=0)
   authenticated
   associate with AP 00 18 39 c0 4f 1b
+  authentication frame received from 00 18 39 c0 4f 1b, but not in authenticate state - ignored
   RX AssocResp from 00 18 39 c0 4f 1b (capab=0x411 status=0 aid=1)
   associated
   switched to short barker preamble (BSSID=00 18 39 c0 4f 1b)
   wlan0  link becomes ready
-  using parport0 (interrupt-driven).
-  user-space parallel port driver
-  Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
-  starting 90-second grace period
-  Trying to deactivate the NMI watchdog permanently...
-  Successfully done.
-  Found 2 processor cores.
-  fAsync=1 u64DiffCores=1150118.
-  TSC mode is 'asynchronous', kernel timer mode is 'normal'.
-  Successfully loaded version 1.6.2_OSE (interface 0x00070002).
-  `ntpd' uses 32-bit capabilities (legacy support in use)
+  Registered udp transport module.
+  Registered tcp transport module.
+
   no IPv6 routers present
-  Core ver 2.11
-  Registered protocol family 31
-  HCI device and connection manager initialized
-  HCI socket layer initialized
-  L2CAP ver 2.9
-  L2CAP socket layer initialized
-  RFCOMM socket layer initialized
-  RFCOMM TTY layer initialized
-  RFCOMM ver 1.8
-  no link during initialization.
-  eth1  link is not ready
-  no link during initialization.
-  eth0  link is not ready




--=-=-=--

