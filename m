Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYDPAeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYDPAeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbYDPAd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:33:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:40543 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896AbYDPAd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:33:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=wq5v0WgCTljsDTGVURwstnfFB8aUipybB/zeTPQhnWVZ32CH+THtQEn8Kxd/D7rTrnJYR6klW922BI77RDaCO9KC9NSeAWKcILcCicShxGpE16J9W3amzp60XTCbm1HhdP4EKs8CD7On2wUJaTOrOBrfJOWRv5H1CmylwabwNDc=
Message-ID: <4805496E.7000306@gmail.com>
Date: Wed, 16 Apr 2008 09:33:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: ata2: SATA link down (SStatus 611 SControl 300)
References: <87od8cxg45.fsf@burly.wgtn.ondioline.org>	<48040AB5.6050300@gmail.com> <87hce3yhmi.fsf@burly.wgtn.ondioline.org>	<480419B6.1050309@gmail.com> <87d4oryf4u.fsf@burly.wgtn.ondioline.org>	<4804288D.5090504@gmail.com> <87y77ex1oh.fsf@burly.wgtn.ondioline.org>	<48052BB3.2090509@gmail.com> <87od8awxh5.fsf@burly.wgtn.ondioline.org> <48054515.4020202@gmail.com>
In-Reply-To: <48054515.4020202@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------040907020707010000010101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040907020707010000010101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> Paul Collins wrote:
>> Tejun Heo <htejun@gmail.com> writes:
>>
>>> Paul Collins wrote:
>>>> I found a setting labelled "SATA Power Management".  It was set to
>>>> "Enable".  When I set it to "Disable", 2.6.25-rc9 detected the optical
>>>> drive.
>>> This can't be something changed between 2.6.24 and 2.6.25-rc9.  Can
>>> you please double check that?
>>
>> I double-checked as follows:
>>
>> * Verified "SATA Power Management" set to "Enable"
>> * Verified optical device present in 2.6.24.3
>> * Verified optical device not present in 2.6.25-rc9
> 
> Thanks for checking.  Yeah, on the second though, ata_piix as of 
> 2.6.24.3 doesn't have SCR access at all, so it would have just worked. 
> Maybe what's necessary is more refined link onlineness test.  I'll prep 
> a patch.
> 

Can you please try the attached patch?  Thanks.

-- 
tejun

--------------040907020707010000010101
Content-Type: text/x-patch;
 name="ata_piix-debug-3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ata_piix-debug-3.patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index be95fdb..e3ddefd 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3966,11 +3966,26 @@ int ata_std_prereset(struct ata_link *link, unsigned long deadline)
 
 	/* if SATA, resume link */
 	if (ap->flags & ATA_FLAG_SATA) {
+		u32 sstatus;
+
 		rc = sata_link_resume(link, timing, deadline);
 		/* whine about phy resume failure but proceed */
 		if (rc && rc != -EOPNOTSUPP)
 			ata_link_printk(link, KERN_WARNING, "failed to resume "
 					"link for reset (errno=%d)\n", rc);
+
+		/* force hardreset if the link is sleeping */
+		if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0) {
+			u8 ipm = sstatus >> 8;
+
+			if (ipm == 2 || ipm == 6) {
+				ata_link_printk(link, KERN_INFO,
+					"link in %s mode, forcing hardreset\n",
+					ipm == 2 ? "partial" : "slumber");
+				ehc->i.action |= ATA_EH_HARDRESET;
+				return 0;
+			}
+		}
 	}
 
 	/* Wait for !BSY if the controller can wait for the first D2H
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c

--------------040907020707010000010101--
