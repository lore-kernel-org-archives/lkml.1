Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYEOH6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYEOH6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYEOH5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:57:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:8480 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbYEOH5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=ckm00UTBOu17P7NtOrjU/ifys0DQCCUtPuLMSqafumJo9P7veuQ8Ih1bWAJLVLOczCogJykUnodE6ucaxVkKvHn3+Zd7w8jP12NP762c2/9Pl4zIllB35GJW7XkvGJMpXhnzJ/2ufggzKBuoADY54U/qUtAyplD9KF9DmbqrAjc=
Message-ID: <482BECF5.2070801@gmail.com>
Date: Thu, 15 May 2008 16:57:41 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matthieu CASTET <matthieu.castet@parrot.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata_piix 2.6.25 sata failure
References: <482949CB.7000208@parrot.com> <482BE929.7090009@parrot.com>
In-Reply-To: <482BE929.7090009@parrot.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------030205070405010908020403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030205070405010908020403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Matthieu CASTET wrote:
> Hi Tejun,
> 
> Matthieu CASTET wrote:
>> Hi,
>>
>> the 2.6.25 from debian fail to make work the second port. I got a 
>> "SATA link down (SStatus 61 Scontrol 30)" for ata2. ata1 got "SATA 
>> link up 3.0 Gbps (SStatus 13 SControl 30)"
>> The 2.6.24 works [1]. But some previous kernel (IRRC 2.6.18) had the 
>> same problem, ie ata2 doesn't work.
>>
> I saw you post a patch for macbook for correcting a bug with ata_ppiix.
> But it doesn't seem the same problem. I don't get 0 but others values.
> 
> May be a problem occurs when merging the master and slave status register ?
> 
> 
> Any idea how to debug this.
> 
> For information this happen on a HP Compaq dc7700p, and there no way on 
> the bios to change the controller to ahci mode

Yeah, I wrote a patch for that yesterday and forgot to actually send it. 
  Can you please test the attached patch?

-- 
tejun

--------------030205070405010908020403
Content-Type: text/plain;
 name="libata-force-hardreset-if-link-pm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata-force-hardreset-if-link-pm"

From: Tejun Heo <teheo@suse.de>
Subject: libata: force hardreset if link is in powersave mode
References: 381795

Inhibiting link PM mode doesn't bring the link back online if it's
already in powersave mode.  If SRST is used in these cases, libata EH
thinks that the link is offline and fails detection.  Force hardreset
if link is in powersave mode.

Signed-off-by: Tejun Heo <teheo@suse.de>
---
 drivers/ata/libata-core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6.25/drivers/ata/libata-core.c
===================================================================
--- linux-2.6.25.orig/drivers/ata/libata-core.c
+++ linux-2.6.25/drivers/ata/libata-core.c
@@ -3960,6 +3960,7 @@ int ata_std_prereset(struct ata_link *li
 	struct ata_port *ap = link->ap;
 	struct ata_eh_context *ehc = &link->eh_context;
 	const unsigned long *timing = sata_ehc_deb_timing(ehc);
+	u32 sstatus;
 	int rc;
 
 	/* handle link resume */
@@ -3973,6 +3974,17 @@ int ata_std_prereset(struct ata_link *li
 	if (ap->flags & ATA_FLAG_PMP)
 		ehc->i.action |= ATA_EH_HARDRESET;
 
+	/* if link powersave is on, force hardreset */
+	if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0) {
+		u8 ipm = sstatus >> 8;
+
+		if (ipm == 2 || ipm == 6) {
+			ata_link_printk(link, KERN_INFO, "link in powersave "
+				"mode (ipm=%d), forcing hardreset\n", ipm);
+			ehc->i.action |= ATA_EH_HARDRESET;
+		}
+	}
+
 	/* if we're about to do hardreset, nothing more to do */
 	if (ehc->i.action & ATA_EH_HARDRESET)
 		return 0;

--------------030205070405010908020403--
