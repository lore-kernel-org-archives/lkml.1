Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbXEJHUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbXEJHUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbXEJHUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:20:38 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:43609 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785AbXEJHUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:20:36 -0400
Date: Thu, 10 May 2007 16:20:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: jeff@garzik.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: libata reset-seq merge broke sata_sil on sh
Message-ID: <20070510072005.GA27316@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, jeff@garzik.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current git fails to boot via SATA on SH with the recent libata merge:

sata_sil 0000:00:01.0: cache line size not set.  Driver may not function
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 cmd 0xfd000280 ctl 0xfd00028a bmdma 0xfd000200 irq 0
ata2: SATA max UDMA/100 cmd 0xfd0002c0 ctl 0xfd0002ca bmdma 0xfd000208 irq 0
ata1: device not ready (errno=-19), forcing hardreset
ata1: COMRESET failed (errno=-19)
ata1: reset failed (errno=-19), retrying in 10 secs
ata1: COMRESET failed (errno=-19)
ata1: reset failed (errno=-19), retrying in 10 secs
ata1: COMRESET failed (errno=-19)
ata1: reset failed (errno=-19), retrying in 35 secs
ata1: COMRESET failed (errno=-19)
ata1: reset failed, giving up
ata2: SATA link down (SStatus 0 SControl 310)
...

bisect points to the reset-seq merge as the bad change. Going back
a bit further from this, these are where the problems first started
showing up (but still managed to find the disk, which current git is
not able to).

At b8cffc6ad8c000410186815b7bcc6b76ef1bbb13 it's still working, even
though it's started complaining about the reset..

sata_sil 0000:00:01.0: version 2.2
sata_sil 0000:00:01.0: cache line size not set.  Driver may not function
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 cmd 0xfd000280 ctl 0xfd00028a bmdma 0xfd000200 irq 0
ata2: SATA max UDMA/100 cmd 0xfd0002c0 ctl 0xfd0002ca bmdma 0xfd000208 irq 0
ata1: device not ready (errno=-19), forcing hardreset
ata1: COMRESET failed (errno=-19)
ata1: hardreset failed, retrying in 5 secs
ata1: COMRESET failed (errno=-19)
ata1: hardreset failed, retrying in 5 secs
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
ata1.00: ATA-5: HHD424020F7SV00, 00MLA0A5, max UDMA/100
ata1.00: 39070080 sectors, multi 0: LBA
ata1.00: applying bridge limits
ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 310)
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      HHD424020F7SV00  00ML PQ: 0 ANSI: 5
SCSI device sda: 39070080 512-byte hdwr sectors (20004 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 39070080 512-byte hdwr sectors (20004 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: Attached scsi disk sda

at 27c78b372d05e47bbd059c9bb003c6d716abff54 the retry time was changed
to 10 seconds, which still manages to find the device..

sata_sil 0000:00:01.0: cache line size not set.  Driver may not function
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 cmd 0xfd000280 ctl 0xfd00028a bmdma 0xfd000200 irq 0
ata2: SATA max UDMA/100 cmd 0xfd0002c0 ctl 0xfd0002ca bmdma 0xfd000208 irq 0
ata1: device not ready (errno=-19), forcing hardreset
ata1: COMRESET failed (errno=-19)
ata1: reset failed (errno=-19), retrying in 10 secs
ata1: COMRESET failed (errno=-19)
ata1: reset failed (errno=-19), retrying in 10 secs
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
ata1.00: ATA-5: HHD424020F7SV00, 00MLA0A5, max UDMA/100
ata1.00: 39070080 sectors, multi 0: LBA
ata1.00: applying bridge limits
ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 310)
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      HHD424020F7SV00  00ML PQ: 0 ANSI: 5
SCSI device sda: 39070080 512-byte hdwr sectors (20004 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 39070080 512-byte hdwr sectors (20004 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: Attached scsi disk sda

However, if I go back before any of the reset changes were introduced,
things were working fine, and there were no problems with waiting for
the reset. Ideas?
