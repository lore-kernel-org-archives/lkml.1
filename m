Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbXKGUVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbXKGUVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 15:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXKGUVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 15:21:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969AbXKGUVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:21:39 -0500
Date: Wed, 7 Nov 2007 12:21:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Thomas Lindroth" <thomas.lindroth@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc1: pata_amd fails to detect 80-pin wire
Message-Id: <20071107122100.d203968f.akpm@linux-foundation.org>
In-Reply-To: <3d08dbff0711070714m32bd0abcg5906fdfe09d633d1@mail.gmail.com>
References: <3d08dbff0711070714m32bd0abcg5906fdfe09d633d1@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc: linux-ide)

(Rafael: please track as a post-2.623 regression)

> On Wed, 7 Nov 2007 16:14:10 +0100 "Thomas Lindroth" <thomas.lindroth@gmail.com> wrote:
> After upgrading to 2.6.24-rc1 I get the message ata6.00: limited to
> UDMA/33 due to 40-wire cable. The 2.6.23 kernel does not complain and
> activates DMA for the channel.
> 
> I'm using an nforce 4 board with the following ata devices:
>  channel1, master: disk IC35L120AVVA07-0 120gig
>  channel1, slave: dvd HITACHI DVD-ROM GD-7500
>  channel2, master: disk IC35L120AVV207-0 120gig
>  channel2, slave: cdrom LITE-ON LTR-40125S
> 
> I've made sure the cable is 80-pin and tried replacing it with a
> similar cable. Only channel2 gets UDMA33, channel1 works fine.
> The change was introduced in 2.6.24-rc1 but also exists in 2.6.24-rc2.
> It probably have something to do with the new function
> ata_acpi_cbl_80wire in drivers/ata/libata-acpi.c. I've added a return
> 1; at the beginning of that function as a quick workaround for the
> problem.
> 
> The non libata driver prints the waring "BIOS didn't set the cable
> bits correctly. Enabling workaround" which is probably related to
> this. However I am using the latest bios.
> 
> The thread "2.6.24-rc1: pata_acpi fails to activate DMA for DVD-ROM on
> ALi M5229 secondary channel" might be related to this.
> 
> Another thing that might be related is that I get bad throughput on
> the second channel disk even with my workaround but this also occurs
> with older kernels and with the non libata driver.
> 
> 
> # hdparm -tT /dev/sdb
> 
> /dev/sdb:
>  Timing cached reads:   1346 MB in  2.00 seconds = 673.35 MB/sec
>  Timing buffered disk reads:  138 MB in  3.04 seconds =  45.40 MB/sec
> # hdparm -tT /dev/sdc
> 
> /dev/sdc:
>  Timing cached reads:   1392 MB in  2.00 seconds = 696.02 MB/sec
>  Timing buffered disk reads:   34 MB in  3.39 seconds =  10.02 MB/sec
> # hdparm -I /dev/sdb
> 
> /dev/sdb:
> 
> ATA device, with non-removable media
> powers-up in standby; SET FEATURES subcmd spins-up.
>         Model Number:       IC35L120AVVA07-0
>         Serial Number:      VNC602A6G5LH4A
>         Firmware Revision:  VA6OA52A
> Standards:
>         Used: ATA/ATAPI-5 T13 1321D revision 1
>         Supported: 5 4 3 & some of 6
> Configuration:
>         Logical         max     current
>         cylinders       16383   65535
>         heads           16      16
>         sectors/track   63      0
>         --
>         CHS current addressable sectors:          0
>         LBA    user addressable sectors:  241254720
>         device size with M = 1024*1024:      117800 MBytes
>         device size with M = 1000*1000:      123522 MBytes (123 GB)
> Capabilities:
>         LBA, IORDY(can be disabled)
>         bytes avail on r/w long: 52     Queue depth: 32
>         Standby timer values: spec'd by Standard, no device specific minimum
>         R/W multiple sector transfer: Max = 16  Current = 1
>         Advanced power management level: unknown setting (0x0000)
>         Recommended acoustic management value: 128, current value: 254
>         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
>              Cycle time: min=120ns recommended=120ns
>         PIO: pio0 pio1 pio2 pio3 pio4
>              Cycle time: no flow control=240ns  IORDY flow control=120ns
> Commands/features:
>         Enabled Supported:
>            *    SMART feature set
>                 Security Mode feature set
>            *    Power Management feature set
>            *    Write cache
>            *    Look-ahead
>                 Release interrupt
>            *    Host Protected Area feature set
>            *    WRITE_BUFFER command
>            *    READ_BUFFER command
>            *    NOP cmd
>            *    READ/WRITE_DMA_QUEUED
>                 Advanced Power Management feature set
>                 Power-Up In Standby feature set
>                 SET_FEATURES required to spinup after power up
>                 Address Offset Reserved Area Boot
>                 SET_MAX security extension
>                 Automatic Acoustic Management feature set
>            *    Device Configuration Overlay feature set
>            *    Mandatory FLUSH_CACHE
> Security:
>         Master password revision code = 65534
>                 supported
>         not     enabled
>         not     locked
>         not     frozen
>         not     expired: security count
>         not     supported: enhanced erase
>         72min for SECURITY ERASE UNIT.
> HW reset results:
>         CBLID- above Vih
>         Device num = 0 determined by the jumper
> Checksum: correct
> # hdparm -I /dev/sdc
> 
> /dev/sdc:
> 
> ATA device, with non-removable media
> powers-up in standby; SET FEATURES subcmd spins-up.
>         Model Number:       IC35L120AVV207-0
>         Serial Number:      VNVD06G4CGKB5L
>         Firmware Revision:  V24OA66A
> Standards:
>         Used: ATA/ATAPI-6 T13 1410D revision 3a
>         Supported: 6 5 4
> Configuration:
>         Logical         max     current
>         cylinders       16383   16383
>         heads           16      16
>         sectors/track   63      63
>         --
>         CHS current addressable sectors:   16514064
>         LBA    user addressable sectors:  241254720
>         LBA48  user addressable sectors:  241254720
>         device size with M = 1024*1024:      117800 MBytes
>         device size with M = 1000*1000:      123522 MBytes (123 GB)
> Capabilities:
>         LBA, IORDY(can be disabled)
>         Queue depth: 32
>         Standby timer values: spec'd by Standard, no device specific minimum
>         R/W multiple sector transfer: Max = 16  Current = 1
>         Advanced power management level: unknown setting (0x0000)
>         Recommended acoustic management value: 128, current value: 254
>         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
>              Cycle time: min=120ns recommended=120ns
>         PIO: pio0 pio1 pio2 pio3 pio4
>              Cycle time: no flow control=240ns  IORDY flow control=120ns
> Commands/features:
>         Enabled Supported:
>            *    SMART feature set
>                 Security Mode feature set
>            *    Power Management feature set
>            *    Write cache
>            *    Look-ahead
>                 Release interrupt
>            *    Host Protected Area feature set
>            *    WRITE_BUFFER command
>            *    READ_BUFFER command
>            *    NOP cmd
>            *    READ/WRITE_DMA_QUEUED
>                 Advanced Power Management feature set
>                 Power-Up In Standby feature set
>                 SET_FEATURES required to spinup after power up
>                 Address Offset Reserved Area Boot
>                 SET_MAX security extension
>                 Automatic Acoustic Management feature set
>            *    48-bit Address feature set
>            *    Device Configuration Overlay feature set
>            *    Mandatory FLUSH_CACHE
>            *    FLUSH_CACHE_EXT
>            *    SMART error logging
>            *    SMART self-test
>            *    General Purpose Logging feature set
> Security:
>         Master password revision code = 65534
>                 supported
>         not     enabled
>         not     locked
>         not     frozen
>         not     expired: security count
>         not     supported: enhanced erase
>         60min for SECURITY ERASE UNIT.
> HW reset results:
>         CBLID- above Vih
>         Device num = 0 determined by the jumper
> Checksum: correct
> 
> relevant part of dmesg without my fix:
> sata_nv 0000:00:07.0: version 3.5
> ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 22 (level,
> low) -> IRQ 18
> sata_nv 0000:00:07.0: Using ADMA mode
> PCI: Setting latency timer of device 0000:00:07.0 to 64
> scsi0 : sata_nv
> scsi1 : sata_nv
> ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 irq 18
> ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808 irq 18
> ata1: SATA link down (SStatus 0 SControl 300)
> ata2: SATA link down (SStatus 0 SControl 300)
> ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
> ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 21 (level,
> low) -> IRQ 19
> sata_nv 0000:00:08.0: Using ADMA mode
> PCI: Setting latency timer of device 0000:00:08.0 to 64
> scsi2 : sata_nv
> scsi3 : sata_nv
> ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400 irq 19
> ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408 irq 19
> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata3.00: ATA-7: Maxtor 6L250S0, BACE1G20, max UDMA/133
> ata3.00: 490234752 sectors, multi 1: LBA48 NCQ (depth 31/32)
> ata3.00: configured for UDMA/133
> ata4: SATA link down (SStatus 0 SControl 300)
> scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BACE PQ: 0 ANSI: 5
> ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
> sd 2:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 2:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sda: sda1 sda2 < sda5 sda6 sda7 >
> sd 2:0:0:0: [sda] Attached SCSI disk
> sd 2:0:0:0: Attached scsi generic sg0 type 0
> pata_amd 0000:00:06.0: version 0.3.9
> PCI: Setting latency timer of device 0000:00:06.0 to 64
> scsi4 : pata_amd
> scsi5 : pata_amd
> ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
> ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
> ata5.00: ATA-5: IC35L120AVVA07-0, VA6OA52A, max UDMA/100
> ata5.00: 241254720 sectors, multi 1: LBA
> ata5.01: ATAPI: HITACHI DVD-ROM GD-7500, 0005, max UDMA/33
> ata5.00: configured for UDMA/100
> ata5.01: configured for UDMA/33
> ata6.00: ATA-6: IC35L120AVV207-0, V24OA66A, max UDMA/100
> ata6.00: 241254720 sectors, multi 1: LBA48
> ata6.01: ATAPI: LITE-ON LTR-40125S, ZS0P, max UDMA/33
> ata6.00: limited to UDMA/33 due to 40-wire cable
> ata6.00: configured for UDMA/33
> ata6.01: configured for UDMA/33
> scsi 4:0:0:0: Direct-Access     ATA      IC35L120AVVA07-0 VA6O PQ: 0 ANSI: 5
> sd 4:0:0:0: [sdb] 241254720 512-byte hardware sectors (123522 MB)
> sd 4:0:0:0: [sdb] Write Protect is off
> sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 4:0:0:0: [sdb] 241254720 512-byte hardware sectors (123522 MB)
> sd 4:0:0:0: [sdb] Write Protect is off
> sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sdb: sdb1 sdb2 < sdb5 sdb6 >
> sd 4:0:0:0: [sdb] Attached SCSI disk
> sd 4:0:0:0: Attached scsi generic sg1 type 0
> scsi 4:0:1:0: CD-ROM            HITACHI  DVD-ROM GD-7500  0005 PQ: 0 ANSI: 5
> sr0: scsi3-mmc drive: 14x/40x cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> sr 4:0:1:0: Attached scsi CD-ROM sr0
> sr 4:0:1:0: Attached scsi generic sg2 type 5
> scsi 5:0:0:0: Direct-Access     ATA      IC35L120AVV207-0 V24O PQ: 0 ANSI: 5
> sd 5:0:0:0: [sdc] 241254720 512-byte hardware sectors (123522 MB)
> sd 5:0:0:0: [sdc] Write Protect is off
> sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 5:0:0:0: [sdc] 241254720 512-byte hardware sectors (123522 MB)
> sd 5:0:0:0: [sdc] Write Protect is off
> sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sdc: sdc1 < sdc5 sdc6 >
> sd 5:0:0:0: [sdc] Attached SCSI disk
> sd 5:0:0:0: Attached scsi generic sg3 type 0
> scsi 5:0:1:0: CD-ROM            LITE-ON  LTR-40125S       ZS0P PQ: 0 ANSI: 5
> sr1: scsi3-mmc drive: 164x/48x writer cd/rw xa/form2 cdda tray
> sr 5:0:1:0: Attached scsi CD-ROM sr1
> sr 5:0:1:0: Attached scsi generic sg4 type 5

