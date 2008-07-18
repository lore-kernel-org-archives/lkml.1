Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbYGRC3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbYGRC3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYGRC3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:29:40 -0400
Received: from ns.hanzlici.cz ([212.158.159.56]:48986 "EHLO franta.hanzlici.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751959AbYGRC3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:29:39 -0400
Message-ID: <487FFFFB.8050505@hanzlici.cz>
Date: Fri, 18 Jul 2008 04:29:15 +0200
From: Frantisek Hanzlik <franta@hanzlici.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.9.0.2pre) Gecko/2008071601 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: serverworks CSB5 IDE: DMA disabled on secondary channel
References: <fa.Fmf0CiaCc/J+JAWaZ5FS+ihhhzA@ifi.uio.no> <487FED33.2030207@shaw.ca>
In-Reply-To: <487FED33.2030207@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Frantisek Hanzlik wrote:
>> Server with Intel SHG2 board, servervorks CSB5 rev. 93: After
>> upgrade from kernel 2.6.22 (IDE serverworks driver) to 2.6.25
>> (Fedora 9: libata+pata_serverworks driver), SW RAID1 performance
>> is very bad. Problem is probably with secondary IDE channel,
>> which has disabled DMA:
>>
>> # hdparm -Tt /dev/sda
>> /dev/sda:
>> Timing cached reads: 828 MB in 2.00 seconds = 414.26 MB/sec
>> Timing buffered disk reads: 210 MB in 3.01 seconds = 69.83 MB/sec
>>
>> # hdparm -Tt /dev/sdb
>> /dev/sdb:
>> Timing cached reads: 408 MB in 2.00 seconds = 203.72 MB/sec
>> Timing buffered disk reads: 6 MB in 3.05 seconds = 1.96 MB/sec
>>
>> dmesg output:
>> ..
>> libata version 3.00 loaded.
>> PCI: Setting latency timer of device 0000:00:0f.1 to 64
>> scsi0 : pata_serverworks
>> scsi1 : pata_serverworks
>> ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2440 irq 14
>> ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2448 irq 15
>> ata1.00: ATA-7: ST3400620A, 3.AAE, max UDMA/100
>> ata1.00: 781422768 sectors, multi 16: LBA48
>> ata1.01: ATAPI: TOSHIBA DVD-ROM SD-M1612, 1004, max UDMA/33
>> ata1.00: configured for UDMA/100
>> ata1.01: configured for UDMA/33
>> ata2.00: ATA-7: ST3400620A, 3.AAE, max UDMA/100
>> ata2.00: 781422768 sectors, multi 16: LBA48
>> ata2.01: ATAPI: CD-W540E, 1.0D, max UDMA/33
>> ata2.00: simplex DMA is claimed by other device, disabling DMA
>> ata2.01: simplex DMA is claimed by other device, disabling DMA
>> ata2.00: configured for PIO4
>> ata2.01: configured for PIO4
>> ..
>>
>> # lsmod|grep ata
>> pata_serverworks 10496 8
>> pata_acpi 8320 0
>> libata 127328 2 pata_serverworks,pata_acpi
>> scsi_mod 120948 4 sg,sr_mod,libata,sd_mod
>>
>> It's some sort of pata_serverworks bug, or is needed any special
>> setup for this driver to work?
>> What is "simplex DMA" term?
>
> It means this controller can only do DMA on the primary or secondary
> channel, not both at the same time. It looks like libata currently deals
> with this by disabling DMA on the secondary channel. Not sure how the
> old IDE stuff handled it?
>
> ServerWorks IDE always seemed to pretty much suck, I always got the
> impression that they stuck it on there as an afterthought just to
> operate a CD drive enough to install the OS..
>

I'm sure on 2.6.22/IDE serverworks all worked fine and quickly.
And it was same HW configuration, disk partitioning unchanged and all
partition/RAID1 had same functions and type - SW RAID1 and ext3 fs.
Simply on /dev/md0 was system (all except "/home"), and md0 has now been
mke2fs-ed and Fedora 9 installed on it.

I no more can test it with 2.6.22, but I have its dmesg:
...
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SvrWks CSB5: IDE controller at PCI slot 0000:00:0f.1
SvrWks CSB5: chipset revision 147
SvrWks CSB5: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0x2440-0x2447, BIOS settings: hda:DMA, hdb:DMA
     ide1: BM-DMA at 0x2448-0x244f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: ST3400620A, ATA DISK drive
hdb: TOSHIBA DVD-ROM SD-M1612, ATAPI CD/DVD-ROM drive
hda: selected mode 0x22
hdb: selected mode 0x22
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: ST3400620A, ATA DISK drive
hdd: CD-W540E, ATAPI CD/DVD-ROM drive
hdc: selected mode 0x22
hdd: selected mode 0x22
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 781422768 sectors (400088 MB) w/16384KiB Cache, CHS=48641/255/63, (U)DMA
hda: cache flushes supported
  hda: hda1 hda2 hda3 hda4
hdc: max request size: 512KiB
hdc: 781422768 sectors (400088 MB) w/16384KiB Cache, CHS=48641/255/63, (U)DMA
hdc: cache flushes supported
  hdc: hdc1 hdc2 hdc3 hdc4
...
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdc4 ...
md:  adding hdc4 ...
md: hdc3 has different UUID to hdc4
md: hdc1 has different UUID to hdc4
md:  adding hda4 ...
md: hda3 has different UUID to hdc4
md: hda1 has different UUID to hdc4
md: created md2
md: bind<hda4>
md: bind<hdc4>
md: running: <hdc4><hda4>
raid1: raid set md2 active with 2 out of 2 mirrors
md: considering hdc3 ...
md:  adding hdc3 ...
md: hdc1 has different UUID to hdc3
md:  adding hda3 ...
md: hda1 has different UUID to hdc3
md: created md1
md: bind<hda3>
md: bind<hdc3>
md: running: <hdc3><hda3>
raid1: raid set md1 active with 2 out of 2 mirrors
md: considering hdc1 ...
md:  adding hdc1 ...
md:  adding hda1 ...
md: created md0
md: bind<hda1>
md: bind<hdc1>
md: running: <hdc1><hda1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
...
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on md0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on rd/c0d0p1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1606492k swap on /dev/hdc2.  Priority:-1 extents:1 across:1606492k
Adding 1606492k swap on /dev/hda2.  Priority:-2 extents:1 across:1606492k
...

One thing I not fully understood - I have "hdparm -i" outputs for both
old and new installations, and they are different in dma settings:

OLD cfg: 2.6.22 kernel, hdparm 6.6-2 (Fedora 6):
# hdparm -i /dev/hda
/dev/hda:
  Model=ST3400620A, FwRev=3.AAE, SerialNo=5QH08VS5
  Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
  BuffType=unknown, BuffSize=16384kB, MaxMultSect=16, MultSect=16
  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
  IORDY=on/off, tPIO={min:240,w/IORDY:120}, tDMA={min:120,rec:120}
  PIO modes:  pio0 pio1 pio2 pio3 pio4
  DMA modes:  mdma0 mdma1 *mdma2
  UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5
  AdvancedPM=no WriteCache=enabled
  Drive conforms to: Unspecified:  ATA/ATAPI-1 ATA/ATAPI-2 ATA/ATAPI-3 ATA/ATAPI-4 ATA/ATAPI-5 ATA/ATAPI-6 ATA/ATAPI-7

  * signifies the current active mode

# hdparm -i /dev/hdc
/dev/hdc:
  Model=ST3400620A, FwRev=3.AAE, SerialNo=5QG0GHTG
  Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
  BuffType=unknown, BuffSize=16384kB, MaxMultSect=16, MultSect=16
  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
  IORDY=on/off, tPIO={min:240,w/IORDY:120}, tDMA={min:120,rec:120}
  PIO modes:  pio0 pio1 pio2 pio3 pio4
  DMA modes:  mdma0 mdma1 *mdma2
  UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5
  AdvancedPM=no WriteCache=enabled
  Drive conforms to: Unspecified:  ATA/ATAPI-1 ATA/ATAPI-2 ATA/ATAPI-3 ATA/ATAPI-4 ATA/ATAPI-5 ATA/ATAPI-6 ATA/ATAPI-7

  * signifies the current active mode


NEW cfg: 2.6.25 kernel, hdparm 8.6-1 (Fedora 9):
# hdparm -i /dev/sda
/dev/sda:
  Model=ST3400620A                              , FwRev=3.AAE   , SerialNo=            5QH08VS5
  Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
  BuffType=unknown, BuffSize=16384kB, MaxMultSect=16, MultSect=?16?
  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=781422768
  IORDY=on/off, tPIO={min:240,w/IORDY:120}, tDMA={min:120,rec:120}
  PIO modes:  pio0 pio1 pio2 pio3 pio4
  DMA modes:  mdma0 mdma1 mdma2
  UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5
  AdvancedPM=no WriteCache=enabled
  Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

  * signifies the current active mode

# hdparm -i /dev/sdb
/dev/sdb:
  Model=ST3400620A                              , FwRev=3.AAE   , SerialNo=            5QG0GHTG
  Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
  BuffType=unknown, BuffSize=16384kB, MaxMultSect=16, MultSect=?16?
  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=781422768
  IORDY=on/off, tPIO={min:240,w/IORDY:120}, tDMA={min:120,rec:120}
  PIO modes:  pio0 pio1 pio2 pio3 pio4
  DMA modes:  mdma0 mdma1 mdma2
  UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5
  AdvancedPM=no WriteCache=enabled
  Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

  * signifies the current active mode

with old kernel hdparm show for both drives multiword DMA setting, with
new kernel UDMA5 setting - it's weird some way, because as hdparm man page
say about "-i" switch:

Display the identification info that was obtained from the drive at boot time...

then
1) Should not be boot time settings for both kernels same?
2) maybe BIOS set both drives to UDMA mode, but then driver disabled DMA
for second channel/drive.

Regardless this discrepances, truth is, old system has worked fine,
in contrast with new kernel. What now?

Franta Hanzlik





