Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYDOEBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYDOEBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 00:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbYDOEBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 00:01:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:50436 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYDOEBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 00:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=ibI1+QoVrrfFrooc1hGtaiVlI3cjPf/MsdnK7m0jSEtZYcSoQAJzU13sFdqsIKkDnoXd+aTtNwBh3mI14ACbWhJeigsHTLGCwGgqYgtYH9R18+0CnztZ2YE7n64oPJ2SknhHLRdXm8JB2OLuZTk0OjKycNS+p97Xb/kuOMoYPvA=
Message-ID: <4804288D.5090504@gmail.com>
Date: Tue, 15 Apr 2008 13:01:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: ata2: SATA link down (SStatus 611 SControl 300)
References: <87od8cxg45.fsf@burly.wgtn.ondioline.org>	<48040AB5.6050300@gmail.com> <87hce3yhmi.fsf@burly.wgtn.ondioline.org>	<480419B6.1050309@gmail.com> <87d4oryf4u.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87d4oryf4u.fsf@burly.wgtn.ondioline.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------010902090507090508060605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010902090507090508060605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Paul Collins wrote:
> Tejun Heo <htejun@gmail.com> writes:
> 
>> Can you please do the followings?
>>
>> 1. With the previous patch applied, do cold reboot.  Power off the
>> machine.  If possible turn off the master switch on the power
>> supply. What ten secs.  Boot and see if anything is different.
> 
> No difference observed.
> 
>> 2. If that doesn't make any difference, with the previous patch backed
>> out (patch -R -p1) and the new patch attached here applied, do cold
>> boot and post the log.

Thanks for testing.

> ata2: XXX about to resume
> ata2: SATA link down (SStatus 611 SControl 0)

The link is already in slumber mode before the driver doing anything to 
it.  Is there any related setting in BIOS?

Also, can you please give a shot at the attached patch?

-- 
tejun

--------------010902090507090508060605
Content-Type: text/x-patch;
 name="ata_piix-debug-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ata_piix-debug-2.patch"

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
index be95fdb..0350bec 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3966,7 +3966,13 @@ int ata_std_prereset(struct ata_link *link, unsigned long deadline)
 
 	/* if SATA, resume link */
 	if (ap->flags & ATA_FLAG_SATA) {
+		ata_link_printk(link, KERN_INFO, "XXX about to resume\n");
+		sata_print_link_status(link);
 		rc = sata_link_resume(link, timing, deadline);
+		ata_link_printk(link, KERN_INFO, "XXX after resume\n");
+		sata_print_link_status(link);
+		ssleep(1);
+		sata_print_link_status(link);
 		/* whine about phy resume failure but proceed */
 		if (rc && rc != -EOPNOTSUPP)
 			ata_link_printk(link, KERN_WARNING, "failed to resume "
@@ -7172,7 +7178,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 			ehi->probe_mask =
 				(1 << ata_link_max_devices(&ap->link)) - 1;
 			ehi->action |= ATA_EH_SOFTRESET;
-			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+			ehi->flags |= ATA_EHI_NO_AUTOPSY/* | ATA_EHI_QUIET*/;
 
 			ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 			ap->pflags |= ATA_PFLAG_LOADING;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a583032..6514157 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2191,6 +2191,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	}
 
 	/* prereset() might have modified ehc->i.action */
+	ehc->i.action |= ATA_EH_HARDRESET;
 	if (ehc->i.action & ATA_EH_HARDRESET)
 		reset = hardreset;
 	else if (ehc->i.action & ATA_EH_SOFTRESET)
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c

--------------010902090507090508060605--
