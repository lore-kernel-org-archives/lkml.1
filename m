Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYGKSoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYGKSoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYGKSno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:43:44 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:55473 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbYGKSnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:43:43 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@redhat.com>
Subject: Re: pata_it821x completely broken
Date: Fri, 11 Jul 2008 20:43:34 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <20080706230118.GA25905@devserv.devel.redhat.com> <200807102235.22651.linux@rainbow-software.org>
In-Reply-To: <200807102235.22651.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807112043.36772.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008 22:35:20 Ondrej Zary wrote:
> Hello,
> commenting out the error check after ata_dev_init_params() call in
> ata_dev_read_id() function (libata-core.c), I got at least the device name.
> The capacity is 0 so it doesn't work, obviously:
>
> pata_it821x: controller in smart mode.
> ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKC] -> GSI 11 (level, low)
> -> IRQ 11
> PCI: Setting latency timer of device 0000:00:12.0 to 64
> scsi2 : pata_it821x
> scsi3 : pata_it821x
> ata3: PATA max MWDMA2 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
> ata4: PATA max MWDMA2 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
> ata3.00: ATA-7: SAMSUNG HD400LD, WQ100-15, max UDMA/100
> ata3.00: 781422768 sectors, multi 0: LBA48
> ata3.01: ATA-0: Integrated Technology Express Inc, , max MWDMA2
> ata3.01: 0 sectors, multi 0, CHS 0/0/0
> IT821x RAID1 volume.
> ata3.00: configured for DMA
> ata3.01: configured for PIO
> scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD400LD  WQ10 PQ: 0 ANSI:
> 5 sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sdb: sdb1 sdb2 sdb3 sdb4
> sd 2:0:0:0: [sdb] Attached SCSI disk
> sd 2:0:0:0: Attached scsi generic sg2 type 0
> scsi 2:0:1:0: Direct-Access     ATA      Integrated Techn n/a  PQ: 0 ANSI:
> 5 sd 2:0:1:0: [sdc] Too big for this kernel. Use a kernel compiled with
> support for large block devices.
> sd 2:0:1:0: [sdc] 0 512-byte hardware sectors (0 MB)
> sd 2:0:1:0: [sdc] Write Protect is off
> sd 2:0:1:0: [sdc] Mode Sense: 00 3a 00 00
> sd 2:0:1:0: [sdc] Write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 2:0:1:0: [sdc] Attached SCSI disk
> sd 2:0:1:0: Attached scsi generic sg3 type 0
>
>
> (0 is too big for the kernel, interesting :)

Some more details:
ata_dev_read_id() is calling ata_dev_init_params with 0 heads and 0 sectors.
Also ata_id_n_sectors returns 0 (through the last return statement
(return id[1] * id[3] * id[6]).

I captured the IDENTIFY data from the virtual device. I'm not ATA guru but
looking at the data, there are zeros at many places where something should be.
That number starting at 0x78 looks like size of the array in sectors
(0x4C726C or 0x4C6C72 - the array is built from 2.5GB and 6.4GB drives).

ADDRESS      00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   ASCII
-------------------------------------------------------------------------------
0x00000000   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x00000010   00 00 00 00 20 08 11 07 18 06 17 05 01 01 00 0A   .... ...........
0x00000020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x00000030   00 00 00 00 00 00 49 6E 74 65 67 72 61 74 65 64   ......Integrated
0x00000040   20 54 65 63 68 6E 6F 6C 6F 67 79 20 45 78 70 72    Technology Expr
0x00000050   65 73 73 20 49 6E 63 20 20 20 20 20 20 20 00 00   ess Inc       ..
0x00000060   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x00000070   00 00 00 00 00 00 00 00 6C 72 00 4C 00 00 00 07   ........lr.L....
0x00000080   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x00000090   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000000A0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000000B0   00 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000000C0   00 00 00 00 00 00 00 00 6C 72 00 4C 00 00 00 00   ........lr.L....
0x000000D0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000000E0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000000F0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x00000100   00 00 00 01 00 0C 31 33 21 21 91 11 00 91 32 66   ......13!!....2f
0x00000110   00 21 00 21 00 01 05 05 00 05 05 00 00 00 00 05   .!.!............
0x00000120   00 05 00 05 00 40 00 00 00 00 00 00 00 00 00 00   .....@..........
0x00000130   00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00   ................
0x00000140   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x00000150   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x00000160   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x00000170   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x00000180   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x00000190   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000001A0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000001B0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000001C0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000001D0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000001E0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0x000001F0   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................


I've also looked at the driver source from ITE
http://www.ite.com.tw/product_info/file/pc/LinuxDriver_it8212_092005-09.zip
It contains some interesting structs and also one line of interesting text:

* Extra IDE commands supported by Accusys



-- 
Ondrej Zary
