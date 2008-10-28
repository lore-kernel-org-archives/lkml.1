Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYJ1XZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYJ1XZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYJ1XZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:25:51 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:52525 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYJ1XZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JsGxtyEFT1bZXYOsTaV+zoDswwE5eYV+v3956SAzhm1XSmWLmmyqHzURVpN4ffWts0
         9RlAYtjbXGeSclv0xeU3xfPz/joolxLIASaXAtJViuX6jU9NyeTGwOLMteZ13veXv6rP
         1JRqJKII4gAz8DUHfDgK6kvsh0FHQYkXSMOg0=
Message-ID: <7a9b5c320810281625kbf8904x9ba432ff0ca8c2f8@mail.gmail.com>
Date: Wed, 29 Oct 2008 12:25:47 +1300
From: "Phillip O'Donnell" <phillip.odonnell@gmail.com>
To: "Oskar Liljeblad" <oskar@osk.mine.nu>, jeff@garzik.org
Subject: Re: sata errors with Seagate 1.5TB on AMD 780G/SB700 motherboard
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081028170105.GA21933@osk.mine.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081028170105.GA21933@osk.mine.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got this issue, and I'm involved in the thread on the Seagate
forums. I've been going through the libata code with a fine tooth comb
to see if I can find the issue, and so far - not a lot of joy.

However, and this is more directed to Jeff Garzik, there is a minor
display bug with drives that have more than 2^31 sectors.

The messages:

ata3.00: HPA detected: current 2930277168, native 18446744072344861488

is a bug. The two sector counts are calculated from different ATA
commands and are parsed differently:

   Current Sector Count is retrieved from the IDENTIFY result (words
100-103), and calculated with the ata_id_u64() macro
   Native Sector Count (LBA48 max) is retrieved from the READ NATIVE
MAX ADDRESS EXT command, and calculated with the ata_tf_to_lba48()
function.

ata_tf_to_lba48()  seems to be overflowing when the total size will be
greater than 2^31 sectors, while ata_id_u64() does not.

I noticed an identical bug in the latest release of hdparm 8.9, even
returning an identical native sector count, but hdparm gets its
information from the IDENTIFY result. I've been able to patch hdparm
to display correctly. Haven't yet tried to patch ata_tf_to_lba48()
because the data is stored differently and haven't had the time to
figure it out yet.

I have some code that shows the bug in action against the hdparm
implementation, won't be hard to modify to prove the bug against the
ata_tf_to_lba48() implementation, but I'm not at home at the moment
and can't send it through. I can also send through the appropriate
values for words 100 - 103.

All that said, this does NOT appear to be causing the issues that both
you and I are suffering from - I can't see anywhere in libata that
uses the ata_tf_to_lba48() function other than the HPA detection code,
and it seems purely display related only, although Jeff would
hopefully be able to comment further on this and whether there could
be other code doing LBA48 calculations like this.

Cheers,
Phillip











On Wed, Oct 29, 2008 at 6:01 AM, Oskar Liljeblad <oskar@osk.mine.nu> wrote:
>
> Can anyone make any sense of these SATA errors? They're killing my md RAID5
> (at least the second error did).
>
> Hard drives (ata1/sda, ata2/sdb, ata3/sdc): Seagate ST31500341AS 1.5TB SATA
> Motherboard: Asus M3A78-EH with AMD 780G/SB700 chipset
> SATA driver: ahci
> 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]
>
> Smart reports no errors on the drives, short & long tests have been run as
> well. The system is brand new.
>
> I've read some reports about SATA 3.0 Gbps vs 1.5 Gbps problems and I'm
> considering limiting the drives to 1.5 Gbps using jumpers. Would that be a
> good idea?
>
> 19:24:26 ata2: exception Emask 0x50 SAct 0x0 SErr 0x90a02 action 0xe frozen
> 19:24:26 ata2: irq_stat 0x00400000, PHY RDY changed
> 19:24:26 ata2: SError: { RecovComm Persist HostInt PHYRdyChg 10B8B }
> 19:24:26 ata2: hard resetting link
> 19:24:27 ata2: SATA link down (SStatus 0 SControl 300)
> 19:24:30 ata2: hard resetting link
> 19:24:35 ata2: link is slow to respond, please be patient (ready=0)
> 19:24:38 ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> 19:24:38 ata2.00: configured for UDMA/133
> 19:24:38 ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
> 19:24:38 ata2: irq_stat 0x00000040, connection status changed
> 19:24:38 ata2.00: configured for UDMA/133
> 19:24:38 ata2: EH complete
>
> And then the day after:
>
> 09:07:49 ata3.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x6 frozen
> 09:07:49 ata3: SError: { HostInt }
> 09:07:49 ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> 09:07:49          res 40/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x44 (timeout)
> 09:07:49 ata3.00: status: { DRDY }
> 09:07:49 ata3: hard resetting link
> 09:07:49 ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> 09:07:49 ata3.00: configured for UDMA/133
> 09:07:49 ata3: EH complete
> 09:07:49 sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
> 09:07:49 sd 2:0:0:0: [sdc] Write Protect is off
> 09:07:49 sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> 09:07:49 sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 09:07:49 end_request: I/O error, dev sdc, sector 8
> 09:07:49 md: super_written gets error=-5, uptodate=0
> 09:07:49 raid5: Disk failure on sdc, disabling device.
> 09:07:49 raid5: Operation continuing on 1 devices.
>
> For reference:
>
> ata1: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fff900 irq 22
> ata2: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fff980 irq 22
> ata3: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fffa00 irq 22
> ata4: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fffa80 irq 22
> ata5: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fffb00 irq 22
> ata6: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fffb80 irq 22
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: HPA detected: current 2930277168, native 18446744072344861488
> ata1.00: ATA-8: ST31500341AS, SD17, max UDMA/133
> ata1.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> ata1.00: configured for UDMA/133
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: HPA detected: current 2930277168, native 18446744072344861488
> ata2.00: ATA-8: ST31500341AS, SD17, max UDMA/133
> ata2.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> ata2.00: configured for UDMA/133
> ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata3.00: HPA detected: current 2930277168, native 18446744072344861488
> ata3.00: ATA-8: ST31500341AS, SD17, max UDMA/133
> ata3.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> ata3.00: configured for UDMA/133
>
> Regards,
>
> Oskar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
