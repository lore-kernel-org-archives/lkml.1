Return-Path: <linux-kernel-owner+w=401wt.eu-S934474AbXILNTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474AbXILNTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932455AbXILNTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:19:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52188 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765985AbXILNTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:19:10 -0400
Date: Wed, 12 Sep 2007 08:19:04 -0500
From: Robin Holt <holt@sgi.com>
To: Mikael Pettersson <mikpe@it.uu.se>, Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Subject: Possible hang inside interrupt handler on sata_promise.
Message-ID: <20070912131904.GW14474@lnx-holt.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I have been experiencing hangs on a newly setup machine.  Unfortunately,
it appears to be hanging inside the interrupt handler as sysrq and
caps-lock led seem to stop working when the event occurs.  I am guessing
it is related to the sata_promise driver, but that is only a guess as
I don't get much for output.  I am running the debian unstable kernel
(2.6.22-1-686), but the problem also occurs with the debian stable kernel
(2.6.18-4-686).  I do need to boot with the acpi=off option, but am
not sure if that is related.  Unfortunately, I do not know much about
troubleshooting i386 when problems occur inside the interrupt handlers.

What can I do to help troubleshoot this problem.

Thanks,
Robin Holt


PS: A little background information:

# lspci -v
...
00:0b.0 Mass storage controller: Promise Technology, Inc. PDC40718 (SATA 300 TX4) (rev 02)
        Subsystem: Promise Technology, Inc. PDC40718 (SATA 300 TX4)
        Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 10
        I/O ports at d400 [size=128]
        I/O ports at d800 [size=256]
        Memory at f8042000 (32-bit, non-prefetchable) [size=4K]
        Memory at f8000000 (32-bit, non-prefetchable) [size=128K]
        [virtual] Expansion ROM at 30020000 [disabled] [size=32K]
        Capabilities: [60] Power Management version 2

00:0c.0 Mass storage controller: Promise Technology, Inc. PDC40718 (SATA 300 TX4) (rev 02)
        Subsystem: Promise Technology, Inc. PDC40718 (SATA 300 TX4)
        Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 11
        I/O ports at dc00 [size=128]
        I/O ports at e000 [size=256]
        Memory at f8041000 (32-bit, non-prefetchable) [size=4K]
        Memory at f8020000 (32-bit, non-prefetchable) [size=128K]
        [virtual] Expansion ROM at 30028000 [disabled] [size=32K]
        Capabilities: [60] Power Management version 2

# cat /proc/mdstat 
Personalities : [raid1] [raid6] [raid5] [raid4] 
md2 : active raid6 sda1[0] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
      1953535744 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]
...


The md2 device is a single pv in a vg (VG_DATA) and currently has a
single lv which is 40GB and contains an xfs filesystem.


# dmesg
...
sata_promise 0000:00:0b.0: version 2.07
sata_promise 0000:00:0b.0: applying SATAII TX4 port numbering workaround
scsi0 : sata_promise
scsi1 : sata_promise
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
scsi2 : sata_promise
scsi3 : sata_promise
ata1: SATA max UDMA/133 cmd 0xe080e380 ctl 0xe080e3b8 bmdma 0x00000000 irq 10
ata2: SATA max UDMA/133 cmd 0xe080e280 ctl 0xe080e2b8 bmdma 0x00000000 irq 10
ata3: SATA max UDMA/133 cmd 0xe080e200 ctl 0xe080e238 bmdma 0x00000000 irq 10
ata4: SATA max UDMA/133 cmd 0xe080e300 ctl 0xe080e338 bmdma 0x00000000 irq 10
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max UDMA/133
ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: WDC WD5000KS-00MNB0, 07.02E07, max UDMA/133
ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000KS-00M 07.0 PQ: 0 ANSI: 5
sata_promise 0000:00:0c.0: applying SATAII TX4 port numbering workaround
scsi4 : sata_promise
scsi5 : sata_promise
scsi6 : sata_promise
scsi7 : sata_promise
ata5: SATA max UDMA/133 cmd 0xe081c380 ctl 0xe081c3b8 bmdma 0x00000000 irq 11
ata6: SATA max UDMA/133 cmd 0xe081c280 ctl 0xe081c2b8 bmdma 0x00000000 irq 11
ata7: SATA max UDMA/133 cmd 0xe081c200 ctl 0xe081c238 bmdma 0x00000000 irq 11
ata8: SATA max UDMA/133 cmd 0xe081c300 ctl 0xe081c338 bmdma 0x00000000 irq 11
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-7: WDC WD5000KS-00MNB0, 07.02E07, max UDMA/133
ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata5.00: configured for UDMA/133
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-7: WDC WD5000KS-00MNB0, 07.02E07, max UDMA/133
ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata6.00: configured for UDMA/133
ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.00: ATA-7: WDC WD5000KS-00MNB0, 07.02E07, max UDMA/133
ata7.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata7.00: configured for UDMA/133
ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata8.00: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max UDMA/133
ata8.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata8.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      WDC WD5000KS-00M 07.0 PQ: 0 ANSI: 5
scsi 5:0:0:0: Direct-Access     ATA      WDC WD5000KS-00M 07.0 PQ: 0 ANSI: 5
scsi 6:0:0:0: Direct-Access     ATA      WDC WD5000KS-00M 07.0 PQ: 0 ANSI: 5
scsi 7:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5

