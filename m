Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbYDOByR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbYDOByR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbYDOByH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:54:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:44940 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbYDOByF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=NMmwH5niaZtrC3DidIW3lQuq2oTY4nzCMrQmg5ZFxHnND3GYIJ/PeDDNFyabnoz4LP1cd2/S6B9PDCjASGdQKw3c0pYm/nwhLKOMoMq16TVsjd6PekKGZF174T4iaCZidksyWHLEXw2canyFAoW6a3hrtbBdgwzg6a3lHoGApEM=
Message-ID: <48040AB5.6050300@gmail.com>
Date: Tue, 15 Apr 2008 10:53:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: ata2: SATA link down (SStatus 611 SControl 300)
References: <87od8cxg45.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87od8cxg45.fsf@burly.wgtn.ondioline.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------050102070505050308090008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050102070505050308090008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Paul Collins wrote:
> I just noticed that my optical drive no longer works with 2.6.25-rc9.
> It works with 2.6.24.3.  git bisect claims the culprit is
> c729072459446885c5c200137de1db32da5db4dc ("ata_piix: implement SIDPR SCR
> access").
> 
>   $ diff -u cd.{ok,no} | grep '^.ata'
>    ata_piix 0000:00:1f.2: version 2.12
>   -ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
>   +ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
>    ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x20e0 irq 14
>    ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x20e8 irq 15
>   +ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>    ata1.00: ATA-7: SAMSUNG HD080HJ/P, ZH100-51, max UDMA/100
>    ata1.00: 156301488 sectors, multi 16: LBA48 
>    ata1.00: configured for UDMA/100
>   -ata2.00: ATAPI: HL-DT-ST RW/DVD GCC-H10N, 1.03, max UDMA/100
>   -ata2.00: configured for UDMA/100
>   +ata2: SATA link down (SStatus 611 SControl 300)

That's very strange.  The link is in slumber powersave mode.  I wonder 
how it got there.  Can you please try the attached patch and report 
resulting boot log?

-- 
tejun

--------------050102070505050308090008
Content-Type: text/x-patch;
 name="ata_piix-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ata_piix-debug.patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index fae8404..4bca85d 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1161,9 +1161,12 @@ static int piix_sidpr_scr_write(struct ata_port *ap, unsigned int reg, u32 val)
 		return -EINVAL;
 
 	piix_sidpr_write(&ap->link.device[0], reg, val);
+	ata_port_printk(ap, KERN_INFO, "XXX SCR WRITE master %d:%x\n", reg, val);
 
-	if (ap->flags & ATA_FLAG_SLAVE_POSS)
+	if (ap->flags & ATA_FLAG_SLAVE_POSS) {
 		piix_sidpr_write(&ap->link.device[1], reg, val);
+		ata_port_printk(ap, KERN_INFO, "XXX SCR WRITE slave %d:%x\n", reg, val);
+	}
 
 	return 0;
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index be95fdb..4760d9d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -7172,7 +7172,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 			ehi->probe_mask =
 				(1 << ata_link_max_devices(&ap->link)) - 1;
 			ehi->action |= ATA_EH_SOFTRESET;
-			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+			ehi->flags |= ATA_EHI_NO_AUTOPSY/* | ATA_EHI_QUIET*/;
 
 			ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 			ap->pflags |= ATA_PFLAG_LOADING;
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c

--------------050102070505050308090008--
