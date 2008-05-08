Return-Path: <linux-kernel-owner+w=401wt.eu-S1763725AbYEHPfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763725AbYEHPfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYEHPfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:35:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43048 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642AbYEHPfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:35:17 -0400
Message-ID: <48231DAF.7070900@garzik.org>
Date: Thu, 08 May 2008 11:35:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-ide@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, htejun@gmail.com,
       Takashi Iwai <tiwai@suse.de>, marc.c.dionne@gmail.com, dl9pf@gmx.de,
       bug-track@fisher-privat.net, sitsofe@yahoo.com
Subject: [PATCH] Re: [git patches] libata updates - (improve post-reset device
 ready test) regression
References: <20080506154847.GA15299@havoc.gtf.org> <20080507145616.GA2210@gentoox2.trippelsdorf.de>
In-Reply-To: <20080507145616.GA2210@gentoox2.trippelsdorf.de>
Content-Type: multipart/mixed;
 boundary="------------030603000401050006040109"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030603000401050006040109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Markus Trippelsdorf wrote:
>> Tejun Heo (12):
>>       libata: improve post-reset device ready test
> 
> This commit (78ab88f04f44bed566d51dce0c7cbfeff6449a06) causes a long
> boot delay with my onboard Promise controller. It seems like libata
> probes for a nonexisting PATA drive...
> 
> ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 18 (level, low) -> IRQ 18
> scsi0 : sata_promise
> scsi1 : sata_promise
> scsi2 : sata_promise
> ata1: SATA max UDMA/133 mmio m4096@0xfb600000 port 0xfb600200 irq 18
> ata2: SATA max UDMA/133 mmio m4096@0xfb600000 port 0xfb600280 irq 18
> ata3: PATA max UDMA/133 mmio m4096@0xfb600000 port 0xfb600300 irq 18
> ata1: SATA link down (SStatus 0 SControl 300)
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata2.00: ATA-7: SAMSUNG HD753LJ, 1AA01109, max UDMA7
> ata2.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 0/32)
> ata2.00: configured for UDMA/133                                                                                          
> ata3: link is slow to respond, please be patient (ready=0)
> ata3: device not ready (errno=-16), forcing hardreset
> ata3: link is slow to respond, please be patient (ready=0)
> ata3: SRST failed (errno=-16)
> ata3: link is slow to respond, please be patient (ready=0)
> ata3: SRST failed (errno=-16)
> ata3: link is slow to respond, please be patient (ready=0)
> ata3: SRST failed (errno=-16)
>   - Last output repeated twice -
> ata3: reset failed, giving up

Does the attached patch fix things?

It basically reverts the patch, while still maintaining the 
consolidation.  It looks like that status evaluation is not as universal 
as believed.

	Jeff




--------------030603000401050006040109
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7e206da..0f17643 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1384,17 +1384,14 @@ static inline struct ata_port *ata_shost_to_port(struct Scsi_Host *host)
 
 static inline int ata_check_ready(u8 status)
 {
-	/* Some controllers report 0x77 or 0x7f during intermediate
-	 * not-ready stages.
-	 */
-	if (status == 0x77 || status == 0x7f)
-		return 0;
+	if (!(status & ATA_BUSY))
+		return 1;
 
 	/* 0xff indicates either no device or device not ready */
 	if (status == 0xff)
 		return -ENODEV;
 
-	return !(status & ATA_BUSY);
+	return 0;
 }
 
 

--------------030603000401050006040109--
