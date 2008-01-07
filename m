Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYAGPGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYAGPGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYAGPGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:06:40 -0500
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:52633
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbYAGPGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:06:38 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2008 10:06:35 EST
Mime-Version: 1.0 (Apple Message framework v753)
To: linux-kernel@vger.kernel.org
Message-Id: <F59D6EFA-C8EC-4678-97CE-8726260606EE@neuf.fr>
Content-Type: multipart/mixed; boundary=Apple-Mail-19-219894249
From: =?ISO-8859-1?Q?Guillaume_Laur=E8s?= <guillaume-laures@neuf.fr>
Subject: PROBLEM: I/O scheduler problem with an 8 SATA disks raid 5 under heavy load  ?
Date: Mon, 7 Jan 2008 15:58:29 +0100
X-Mailer: Apple Mail (2.753)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-19-219894249
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Hello,

Dear kernel developers, my dmesg asked me to report this, so here I  
go ;)
Here is what I found in my dmesg: "anticipatory: forced dispatching  
is broken (nr_sorted=1), please report this".

- First, let's talk about the machine: it's quite pushed so maybe the  
cause is me doing something wrong rather than a bug in the kernel.

I got this alert on a dual core amd64 xen host. It has 8 SATA drives  
making a raid 5 array. This array makes a virtual block device for  
one of the virtual machines:  an Openfiler appliance. Openfiler then  
manages logical volumes on this device including an XFS partition  
shared via NFS. 2 MythTV hosts continuously write MPEG2 tv shows on  
it (1 to 4Gb each).
Still following ? Here is a summary: MPEG2 files -> NFS -> XFS -> LVM  
-> Xen VBD -> RAID 5 -> 8x SATA disks.

- Next, the symptoms.

This setup is only 2 weeks old. Behavior was quite good, except for  
some unexplained failures from the sata_nv attached disks. Not always  
from the same disk. Never from any disks attached through the  
sata_sil HBA.
Eventually a second disk would go down before the end of the raid  
reconstruction (still a sata_nv attached one).
Since the disks showed nothing wrong with smartmontools I re-added  
them each time. So far the raid array was strong enough to be fully  
recovered, mdadm --force and xfs_check are my friends ;-)
It seems to happen more often now that the XFS partition is quite  
heavily fragmented, and I can't even run the defragmenter without a  
quick failure.
I didn't payed big attention to the logs and quickly decided to buy a  
SATA Sil PCI card to get rid of the Nvidia SATA HBA.

- Now the problem.

Yesterday, however, the MPEG2 streams hanged for a few tens of  
seconds just as usual. But there were no disk failure. The array was  
still in good shape, although dmesg showed the same "ata[56]:  
Resetting port", "SCSI errors" etc. fuss.
However this was new in dmesg: "anticipatory: forced dispatching is  
broken (nr_sorted=1), please report this". Got 4 identical in a row.
Maybe managing 8 block devices queues under load with the  
anticipatory scheduler is too much ? I immediately switched to  
deadline on the 8 disks, and I'll see if it it happens again by  
stressing the whole system more and more.
I have no clue if anticipatory is a good choice or definitely not in  
my case, anyone can point some documentation or good advices ?

- How to reproduce.

Here is what I would do:
Harness a small CPU with lots of sata/scsi drives.
Do raid 5 with big block size (1-4Mb) on it.
Make a 50G XFS file system with sunit/swidth options
Trigger bonnie++ with 1G<files<4G and fill the FS to 80-95%, trying  
to achieve 98%+ fragmentation.
Defrag !

- Finally the usual bug report stuff is attached.

--Apple-Mail-19-219894249
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name=cpuinfo
Content-Disposition: attachment;
	filename=cpuinfo

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 43
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping	: 1
cpu MHz		: 2210.216
cache size	: 512 KB
physical id	: 0
siblings	: 1
core id		: 0
cpu cores	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu tsc msr pae mce cx8 apic mtrr mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips	: 4422.01
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 43
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping	: 1
cpu MHz		: 2210.216
cache size	: 512 KB
physical id	: 1
siblings	: 1
core id		: 0
cpu cores	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu tsc msr pae mce cx8 apic mtrr mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips	: 4422.01
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp


--Apple-Mail-19-219894249
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name=dmesg-06-01_07-01.txt
Content-Disposition: attachment;
	filename=dmesg-06-01_07-01.txt

t-Access     ATA      Maxtor 6L200S0   BACE PQ: 0 ANSI: 5
SCSI device sdb: 398297088 512-byte hdwr sectors (203928 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 398297088 512-byte hdwr sectors (203928 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 1:0:0:0: Attached scsi disk sdb
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L200S0   BACE PQ: 0 ANSI: 5
SCSI device sdc: 398297088 512-byte hdwr sectors (203928 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 398297088 512-byte hdwr sectors (203928 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 sdc3
sd 2:0:0:0: Attached scsi disk sdc
scsi 3:0:0:0: Direct-Access     ATA      Maxtor 6L200S0   BACE PQ: 0 ANSI: 5
SCSI device sdd: 398297088 512-byte hdwr sectors (203928 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdd: 398297088 512-byte hdwr sectors (203928 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: Attached scsi disk sdd
sata_nv 0000:00:07.0: version 3.2
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
ata5: SATA max UDMA/133 cmd 0xFFFFC20000006480 ctl 0xFFFFC200000064A0 bmdma 0xCC00 irq 21
ata6: SATA max UDMA/133 cmd 0xFFFFC20000006580 ctl 0xFFFFC200000065A0 bmdma 0xCC08 irq 21
scsi4 : sata_nv
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATA-7, max UDMA/133, 398297088 sectors: LBA48 NCQ (depth 31/32)
ata5.00: ata5: dev 0 multi count 16
ata5.00: configured for UDMA/133
scsi5 : sata_nv
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-7, max UDMA/133, 390721968 sectors: LBA48 NCQ (depth 31/32)
ata6.00: ata6: dev 0 multi count 16
ata6.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      Maxtor 6B200M0   BANC PQ: 0 ANSI: 5
ata5: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1 sde2 sde3
sd 4:0:0:0: Attached scsi disk sde
scsi 5:0:0:0: Direct-Access     ATA      ST3200827AS      3.AA PQ: 0 ANSI: 5
ata6: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
SCSI device sdf: 390721968 512-byte hdwr sectors (200050 MB)
sdf: Write Protect is off
sdf: Mode Sense: 00 3a 00 00
SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdf: 390721968 512-byte hdwr sectors (200050 MB)
sdf: Write Protect is off
sdf: Mode Sense: 00 3a 00 00
SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1
sd 5:0:0:0: Attached scsi disk sdf
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 20 (level, low) -> IRQ 20
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata7: SATA max UDMA/133 cmd 0xFFFFC20000028480 ctl 0xFFFFC200000284A0 bmdma 0xB800 irq 20
ata8: SATA max UDMA/133 cmd 0xFFFFC20000028580 ctl 0xFFFFC200000285A0 bmdma 0xB808 irq 20
scsi6 : sata_nv
ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.00: ATA-7, max UDMA/133, 390721968 sectors: LBA48 NCQ (depth 31/32)
ata7.00: ata7: dev 0 multi count 16
ata7.00: configured for UDMA/133
scsi7 : sata_nv
ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata8.00: ATA-6, max UDMA/133, 390721968 sectors: LBA48 
ata8.00: ata8: dev 0 multi count 16
ata8.00: configured for UDMA/133
scsi 6:0:0:0: Direct-Access     ATA      ST3200827AS      3.AA PQ: 0 ANSI: 5
ata7: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
SCSI device sdg: 390721968 512-byte hdwr sectors (200050 MB)
sdg: Write Protect is off
sdg: Mode Sense: 00 3a 00 00
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdg: 390721968 512-byte hdwr sectors (200050 MB)
sdg: Write Protect is off
sdg: Mode Sense: 00 3a 00 00
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdg: sdg1
sd 6:0:0:0: Attached scsi disk sdg
scsi 7:0:0:0: Direct-Access     ATA      ST3200822AS      3.01 PQ: 0 ANSI: 5
ata8: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
SCSI device sdh: 390721968 512-byte hdwr sectors (200050 MB)
sdh: Write Protect is off
sdh: Mode Sense: 00 3a 00 00
SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdh: 390721968 512-byte hdwr sectors (200050 MB)
sdh: Write Protect is off
sdh: Mode Sense: 00 3a 00 00
SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdh: sdh1
sd 7:0:0:0: Attached scsi disk sdh
pata_amd 0000:00:06.0: version 0.2.7
ata: 0x170 IDE port busy
ata: conflict with ide1
PCI: Setting latency timer of device 0000:00:06.0 to 64
ata9: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xE000 irq 14
ata10: DUMMY
scsi8 : pata_amd
ATA: abnormal status 0x8 on port 0x1F7
scsi9 : pata_amd
usbmon: debugfs is not available
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 23, io mem 0xfe02f000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
usb 1-5: new low speed USB device using ohci_hcd and address 2
usb 1-5: configuration #1 chosen from 1 choice
usb 1-6: new full speed USB device using ohci_hcd and address 3
usb 1-6: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /class/input/input0
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:02.0-5
input: Logitech USB Receiver as /class/input/input1
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-5
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: raid10 personality registered for level 10
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 15
md: Skipping autodetection of RAID arrays. (raid=noautodetect)
md: Loading md_d1: /dev/sda3
md: bind<sda3>
md: bind<sdb3>
md: bind<sdc3>
md: bind<sdd3>
md: bind<sde3>
raid10: raid set md_d1 active with 5 out of 6 devices
md_d1: bitmap initialized from disk: read 11/11 pages, set 228531 bits, status: 0
created bitmap (167 pages) for device md_d1
 md_d1: p1 p2 p3
 md_d1: p1 p2 p3
ReiserFS: md_d1p2: found reiserfs format "3.6" with standard journal
ReiserFS: md_d1p2: using ordered data mode
ReiserFS: md_d1p2: journal params: device md_d1p2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: md_d1p2: checking transaction log (md_d1p2)
ReiserFS: md_d1p2: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem).
Freeing unused kernel memory: 228k freed
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 3:0:0:0: Attached scsi generic sg3 type 0
sd 4:0:0:0: Attached scsi generic sg4 type 0
sd 5:0:0:0: Attached scsi generic sg5 type 0
sd 6:0:0:0: Attached scsi generic sg6 type 0
sd 7:0:0:0: Attached scsi generic sg7 type 0
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.59.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
Initializing USB Mass Storage driver...
scsi10 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
ieee1394: Initialized config rom entry `ip1394'
eth0: forcedeth.c: subsystem: 01462:7125 bound to 0000:00:0a.0
i2c_adapter i2c-0: nForce2 SMBus adapter at 0x4c00
i2c_adapter i2c-1: nForce2 SMBus adapter at 0x4c40
ACPI: PCI Interrupt 0000:01:0c.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
udev: renamed network interface eth0 to eth1
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[fdeff000-fdeff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0010dc0000cbb4fa]
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
ACPI: Fan [FAN] (on)
ACPI: Thermal Zone [THRM] (22 C)
Capability LSM initialized
Bridge firewalling registered
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
md: md0 stopped.
md: bind<sdb2>
md: bind<sdc2>
md: bind<sdd2>
md: bind<sde2>
md: bind<sda2>
md: raid1 personality registered for level 1
raid1: raid set md0 active with 5 out of 5 mirrors
md0: bitmap initialized from disk: read 2/2 pages, set 0 bits, status: 0
created bitmap (17 pages) for device md0
md: md2 stopped.
md: bind<sdf1>
md: bind<sdg1>
md: bind<sdh1>
md: bind<sdd1>
md: bind<sdc1>
md: bind<sde1>
md: bind<sda1>
md: bind<sdb1>
raid5: automatically using best checksumming function: generic_sse
   generic_sse:  5276.000 MB/sec
raid5: using function: generic_sse (5276.000 MB/sec)
raid6: int64x1   2046 MB/s
raid6: int64x2   2750 MB/s
raid6: int64x4   2890 MB/s
raid6: int64x8   1953 MB/s
raid6: sse2x1    1637 MB/s
raid6: sse2x2    1851 MB/s
raid6: sse2x4    2289 MB/s
raid6: using algorithm sse2x4 (2289 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: device sdb1 operational as raid disk 0
raid5: device sda1 operational as raid disk 7
raid5: device sde1 operational as raid disk 6
raid5: device sdc1 operational as raid disk 5
raid5: device sdd1 operational as raid disk 4
raid5: device sdh1 operational as raid disk 3
raid5: device sdg1 operational as raid disk 2
raid5: device sdf1 operational as raid disk 1
raid5: allocated 8462kB for md2
raid5: raid level 5 set md2 active with 8 out of 8 devices, algorithm 2
RAID5 conf printout:
 --- rd:8 wd:8
 disk 0, o:1, dev:sdb1
 disk 1, o:1, dev:sdf1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 4, o:1, dev:sdd1
 disk 5, o:1, dev:sdc1
 disk 6, o:1, dev:sde1
 disk 7, o:1, dev:sda1
md2: bitmap initialized from disk: read 12/12 pages, set 0 bits, status: 0
created bitmap (187 pages) for device md2
ReiserFS: md0: warning: read_super_block: found reiserfs format "3.6" with non-standard journal
ReiserFS: md0: using ordered data mode
ReiserFS: md0: journal params: device md0, size 512, journal first block 18, max trans len 256, max batch 225, max commit age 30, max trans age 30
ReiserFS: md0: checking transaction log (md0)
ReiserFS: md0: Using r5 hash to sort names
Adding 2097144k swap on /dev/md_d1p1.  Priority:-1 extents:1 across:2097144k
scsi 10:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
sd 10:0:0:0: Attached scsi removable disk sdi
sd 10:0:0:0: Attached scsi generic sg8 type 0
scsi 10:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
sd 10:0:0:1: Attached scsi removable disk sdj
sd 10:0:0:1: Attached scsi generic sg9 type 0
scsi 10:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
sd 10:0:0:2: Attached scsi removable disk sdk
sd 10:0:0:2: Attached scsi generic sg10 type 0
scsi 10:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
sd 10:0:0:3: Attached scsi removable disk sdl
sd 10:0:0:3: Attached scsi generic sg11 type 0
usb-storage: device scan complete
eth1.1: dev_set_promiscuity(master, 1)
device eth1 entered promiscuous mode
device eth1.1 entered promiscuous mode
eth1.6: dev_set_promiscuity(master, 1)
device eth1.6 entered promiscuous mode
eth1.8: dev_set_promiscuity(master, 1)
device eth1.8 entered promiscuous mode
eth1.9: dev_set_promiscuity(master, 1)
device eth1.9 entered promiscuous mode
xenbr1: port 1(eth1.1) entering learning state
xenbr1: topology change detected, propagating
xenbr1: port 1(eth1.1) entering forwarding state
xenbr6: port 1(eth1.6) entering learning state
xenbr6: topology change detected, propagating
xenbr6: port 1(eth1.6) entering forwarding state
xenbr8: port 1(eth1.8) entering learning state
xenbr8: topology change detected, propagating
xenbr8: port 1(eth1.8) entering forwarding state
xenbr9: port 1(eth1.9) entering learning state
xenbr9: topology change detected, propagating
xenbr9: port 1(eth1.9) entering forwarding state
NET: Registered protocol family 17
device vif1.0 entered promiscuous mode
xenbr9: port 2(vif1.0) entering learning state
xenbr9: topology change detected, propagating
xenbr9: port 2(vif1.0) entering forwarding state
device vif2.0 entered promiscuous mode
xenbr9: port 3(vif2.0) entering learning state
xenbr9: topology change detected, propagating
xenbr9: port 3(vif2.0) entering forwarding state
blkback: ring-ref 8, event-channel 6, protocol 2 (x86_32-abi)
blkback: ring-ref 8, event-channel 6, protocol 2 (x86_32-abi)
blkback: ring-ref 9, event-channel 7, protocol 2 (x86_32-abi)
ata5: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 9: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 10: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 11: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 12: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata5: Resetting port
ata5.00: exception Emask 0x0 SAct 0x1f02 SErr 0x0 action 0x2 frozen
ata5.00: cmd 60/40:08:8f:eb:67/00:00:03:00:00/40 tag 1 cdb 0x0 data 32768 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:40:17:eb:67/00:00:03:00:00/40 tag 8 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/18:48:47:eb:67/00:00:03:00:00/40 tag 9 cdb 0x0 data 12288 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:50:77:eb:67/00:00:03:00:00/40 tag 10 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:58:87:eb:67/00:00:03:00:00/40 tag 11 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/48:60:d7:eb:67/00:00:03:00:00/40 tag 12 cdb 0x0 data 36864 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/133
ata5: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
anticipatory: forced dispatching is broken (nr_sorted=1), please report this
anticipatory: forced dispatching is broken (nr_sorted=1), please report this
anticipatory: forced dispatching is broken (nr_sorted=1), please report this
anticipatory: forced dispatching is broken (nr_sorted=1), please report this
ata5: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata5: Resetting port
ata5.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata5.00: cmd 61/08:00:12:52:bd/00:00:17:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x500
ata6: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata6: Resetting port
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336135
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336199
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336215
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164335991
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336295
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336375
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336407
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336423
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336439
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336455
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336519
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336567
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336575
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336495
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336431
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336415
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336503
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336527
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336551
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336591
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336599
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336615
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 164336695
ata5.00: configured for UDMA/133
ata5: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
raid5:md2: read error corrected (8 sectors at 164335928 on sdf1)
raid5:md2: read error corrected (8 sectors at 164335936 on sdf1)
raid5:md2: read error corrected (8 sectors at 164335944 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336072 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336080 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336088 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336096 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336104 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336136 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336152 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336160 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336168 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336176 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336184 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336192 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336200 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336208 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336216 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336232 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336240 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336248 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336256 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336264 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336272 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336280 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336288 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336296 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336312 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336320 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336328 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336344 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336352 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336360 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336368 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336376 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336392 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336400 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336408 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336416 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336424 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336432 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336440 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336456 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336464 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336472 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336488 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336496 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336504 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336512 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336520 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336528 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336536 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336552 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336560 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336568 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336576 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336584 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336592 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336600 on sdf1)
raid5:md2: read error corrected (8 sectors at 164336632 on sdf1)
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop anticipato not found
elevator: type noop [anticipat not found
elevator: type [deadline] not found
elevator: type [deadline] not found
elevator: type [deadline] not found
elevator: type [deadline] not found
elevator: type [deadline] not found
elevator: type [deadline] not found
elevator: type [deadline] not found
elevator: type [deadline] not found
ata5: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata5: Resetting port
ata5.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata5.00: cmd 61/08:00:1a:52:bd/00:00:17:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/133
ata5: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

--Apple-Mail-19-219894249
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name=lspci
Content-Disposition: attachment;
	filename=lspci

00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7125
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7125
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7125
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at fc00 [size=32]
	Region 4: I/O ports at 4c00 [size=64]
	Region 5: I/O ports at 4c40 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7125
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fe02f000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3) (prog-if 20 [EHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7125
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 22
	Region 0: Memory at feb00000 (32-bit, non-prefetchable) [disabled] [size=256]
	Capabilities: [44] Debug port
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio Controller (rev a2)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7585
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 23
	Region 0: I/O ports at f000 [disabled] [size=256]
	Region 1: I/O ports at ec00 [disabled] [size=256]
	Region 2: Memory at fe02d000 (32-bit, non-prefetchable) [disabled] [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2) (prog-if 8a [Master SecP PriP])
	Subsystem: Unknown device f462:7125
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at e000 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3) (prog-if 85 [Master SecO PriO])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7125
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at 09f0 [size=8]
	Region 1: I/O ports at 0bf0 [size=4]
	Region 2: I/O ports at 0970 [size=8]
	Region 3: I/O ports at 0b70 [size=4]
	Region 4: I/O ports at cc00 [size=16]
	Region 5: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3) (prog-if 85 [Master SecO PriO])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7125
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at 09e0 [size=8]
	Region 1: I/O ports at 0be0 [size=4]
	Region 2: I/O ports at 0960 [size=8]
	Region 3: I/O ports at 0b60 [size=4]
	Region 4: I/O ports at b800 [size=16]
	Region 5: Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 00009000-0000afff
	Memory behind bridge: fde00000-fdefffff
	Prefetchable memory behind bridge: fdf00000-fdffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat+ DiscTmrSERREn-

00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7125
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at fe029000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at b400 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-

00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00008000-00008fff
	Memory behind bridge: fdd00000-fddfffff
	Prefetchable memory behind bridge: 00000000fdc00000-00000000fdcfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [58] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x2, ASPM L0s, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  8, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel

00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00007000-00007fff
	Memory behind bridge: fdb00000-fdbfffff
	Prefetchable memory behind bridge: 00000000fda00000-00000000fdafffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [58] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  4, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel

00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: fd900000-fd9fffff
	Prefetchable memory behind bridge: 00000000fd800000-00000000fd8fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [58] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  2, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel

00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: fa000000-fcffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [58] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  1, PowerLimit 75.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:09.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 6834
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fdefc000 (32-bit, non-prefetchable) [disabled] [size=8K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:0c.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 80) (prog-if 10 [OHCI])
	Subsystem: Unknown device 0574:086c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fdeff000 (32-bit, non-prefetchable) [size=2K]
	Region 1: I/O ports at ac00 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=100mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:0d.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7125
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at a800 [size=8]
	Region 1: I/O ports at a400 [size=4]
	Region 2: I/O ports at a000 [size=8]
	Region 3: I/O ports at 9c00 [size=4]
	Region 4: I/O ports at 9800 [size=16]
	Region 5: Memory at fdefe000 (32-bit, non-prefetchable) [size=1K]
	[virtual] Expansion ROM at fdf00000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller (rev 15)
	Subsystem: Micro-Star International Co., Ltd. Marvell 88E8053 Gigabit Ethernet Controller (MSI)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR- INTx-
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fdbfc000 (64-bit, non-prefetchable) [disabled] [size=16K]
	Region 2: I/O ports at 7c00 [disabled] [size=256]
	[virtual] Expansion ROM at fda00000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <256ns, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting

05:00.0 VGA compatible controller: nVidia Corporation NV43 [GeForce 6600 GT] (rev a2) (prog-if 00 [VGA])
	Subsystem: Giga-byte Technology Unknown device 3126
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at fb000000 (64-bit, non-prefetchable) [size=16M]
	[virtual] Expansion ROM at fc000000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel
	Capabilities: [128] Power Budgeting


--Apple-Mail-19-219894249
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name=modules
Content-Disposition: attachment;
	filename=modules

af_packet 25612 0 - Live 0xffffffff880b8000
raid456 127776 1 - Live 0xffffffff88097000
xor 7056 1 raid456, Live 0xffffffff88094000
raid1 26048 1 - Live 0xffffffff8808c000
8021q 22928 0 - Live 0xffffffff88085000
bridge 61224 0 - Live 0xffffffff88075000
llc 9392 1 bridge, Live 0xffffffff88071000
capability 6408 0 - Live 0xffffffff8806e000
commoncap 8640 1 capability, Live 0xffffffff8806a000
thermal 16016 0 - Live 0xffffffff88065000
fan 5832 0 - Live 0xffffffff88062000
button 9248 0 - Live 0xffffffff8805e000
ohci1394 35976 0 - Live 0xffffffff88054000
ieee1394 110776 1 ohci1394, Live 0xffffffff88037000
k8temp 6848 0 - Live 0xffffffff88032000
usb_storage 74688 0 - Live 0xffffffff8801e000
i2c_nforce2 6848 0 - Live 0xffffffff88019000
forcedeth 47368 0 - Live 0xffffffff8800a000
sg 36328 0 - Live 0xffffffff88000000

--Apple-Mail-19-219894249
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name=scsi
Content-Disposition: attachment;
	filename=scsi

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6L250S0   Rev: BACE
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6L200S0   Rev: BACE
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6L200S0   Rev: BACE
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6L200S0   Rev: BACE
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6B200M0   Rev: BANC
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3200827AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3200827AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3200822AS      Rev: 3.01
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi10 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic  Model: USB SD Reader    Rev: 1.00
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi10 Channel: 00 Id: 00 Lun: 01
  Vendor: Generic  Model: USB CF Reader    Rev: 1.01
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi10 Channel: 00 Id: 00 Lun: 02
  Vendor: Generic  Model: USB SM Reader    Rev: 1.02
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi10 Channel: 00 Id: 00 Lun: 03
  Vendor: Generic  Model: USB MS Reader    Rev: 1.03
  Type:   Direct-Access                    ANSI SCSI revision: 02

--Apple-Mail-19-219894249
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name=ver_linux
Content-Disposition: attachment;
	filename=ver_linux

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux asterope0 2.6.20-xen-r6-xen0-smp #4 SMP Wed Dec 5 14:05:46 CET 2007 x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               Binutils
util-linux             2.12r
mount                  2.12r
module-init-tools      3.4
e2fsprogs              1.40.3
reiserfsprogs          3.6.19
xfsprogs               2.9.4
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.9
udev                   115
Modules Loaded         af_packet raid456 xor raid1 8021q bridge llc capability commoncap thermal fan button ohci1394 ieee1394 k8temp usb_storage i2c_nforce2 forcedeth sg

--Apple-Mail-19-219894249
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed


Thanks for your help !

GoM


--Apple-Mail-19-219894249--
