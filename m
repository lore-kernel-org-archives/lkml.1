Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbXFWHDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbXFWHDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 03:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbXFWHDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 03:03:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36236 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbXFWHDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 03:03:41 -0400
Message-ID: <467CC5C5.6040201@garzik.org>
Date: Sat, 23 Jun 2007 03:03:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Carlo Wood <carlo@alinoe.com>
CC: Tejun Heo <htejun@gmail.com>, Manoj Kasichainula <manoj@io.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <20070622214859.GC6970@alinoe.com>
In-Reply-To: <20070622214859.GC6970@alinoe.com>
Content-Type: multipart/mixed;
 boundary="------------030600080503070105010006"
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030600080503070105010006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Carlo Wood wrote:
> The dmesg output of 33480a0ede8dcc7e6483054279008f972bd56fd3 (thus
> "before") is:
[...]
> And the dmesg output of 551c012d7eea3dc5ec063c7ff9c718d39e77634f (thus
> "after") is:
[...]

Your disk configurations are quite radically different between the two 
kernels (see attached diff for key highlights).

The new behavior of the more recent kernel (551c012d7...) is that it now 
fully drives your hardware :)  The reset problems go away, NCQ is 
enabled, and if you had 3.0Gbps drives (you don't) they would be driven 
at a faster speed.

Given that some drives might be better tuned for benchmarks in 
non-queued mode, and that a major behavior difference is that your 
drives are now NCQ-enabled, the first thing I would suggest you try is 
disabling NCQ:
	http://linux-ata.org/faq.html#ncq

Other indicators are the other changes in the "ahci 0000:00:1f.2: 
flags:" line, which do affect other behaviors, though none so important 
to RAID5 performance as NCQ, I would think.

Turning on NCQ also potentially affects barrier behavior in RAID, though 
I'm guessing that is not a factor here.

	Jeff



--------------030600080503070105010006
Content-Type: text/plain;
 name="diff.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff.txt"

-ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports ? Gbps 0x3f impl SATA mode
-ahci 0000:00:1f.2: flags: 64bit ilck stag led pmp pio 
+ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
+ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
 scsi0 : ahci
-ata1: softreset failed (port busy but CLO unavailable)
-ata1: softreset failed, retrying in 5 secs
 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
-ata1.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 0/32)
+ata1.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 31/32)
 ata1.00: ata1: dev 0 multi count 0
 ata1.00: configured for UDMA/133
 scsi1 : ahci
-ata2: softreset failed (port busy but CLO unavailable)
-ata2: softreset failed, retrying in 5 secs
 ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
-ata2.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 0/32)
+ata2.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 31/32)
 ata2.00: ata2: dev 0 multi count 0
 ata2.00: configured for UDMA/133
 scsi2 : ahci
 ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
-ata3.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 0/32)
+ata3.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 31/32)
 ata3.00: ata3: dev 0 multi count 0
 ata3.00: configured for UDMA/133
 scsi3 : ahci
 ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
-ata4.00: ATA-7, max UDMA/133, 625142448 sectors: LBA48 NCQ (depth 0/32)
+ata4.00: ATA-7, max UDMA/133, 625142448 sectors: LBA48 NCQ (depth 31/32)
 ata4.00: configured for UDMA/133
 scsi4 : ahci
 ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)

--------------030600080503070105010006--
