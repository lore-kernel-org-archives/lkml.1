Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbYDOC6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbYDOC6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760411AbYDOC6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:58:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:43732 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357AbYDOC6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=cbuX/J5EgHaHj7d6yuXDYksVGUBMMGN3+0eKBdkLPX1Pske3PirI99yXQEjYRKG9UoNNF3++6zDnxpXqxLAurdcOR1NUGkW5zoYNiuACoPzVbJu1/s2d/jq7JZDTEyXXYraHIcaQHwOFjGqgGLUTEXNMR5v6BbsdUiFYbHe4YHU=
Message-ID: <480419B6.1050309@gmail.com>
Date: Tue, 15 Apr 2008 11:57:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: ata2: SATA link down (SStatus 611 SControl 300)
References: <87od8cxg45.fsf@burly.wgtn.ondioline.org>	<48040AB5.6050300@gmail.com> <87hce3yhmi.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87hce3yhmi.fsf@burly.wgtn.ondioline.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080604040202080001040703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080604040202080001040703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Paul Collins wrote:
> Tejun Heo <htejun@gmail.com> writes:
> 
>> That's very strange.  The link is in slumber powersave mode.  I wonder
>> how it got there.  Can you please try the attached patch and report
>> resulting boot log?

> ata2: XXX SCR WRITE master 2:300
> ata2: XXX SCR WRITE slave 2:300

This is the only write to the SCR control reg and the driver is 
*inhibiting* transition to either powersave mode.

> ata2: soft resetting link
> ata2: SATA link down (SStatus 611 SControl 300)

Yet, the device is in slumber ps mode.

> ata2: XXX SCR WRITE master 1:4050000
> ata2: XXX SCR WRITE slave 1:4050000

This is to clear SCR status.

Can you please do the followings?

1. With the previous patch applied, do cold reboot.  Power off the 
machine.  If possible turn off the master switch on the power supply. 
What ten secs.  Boot and see if anything is different.

2. If that doesn't make any difference, with the previous patch backed 
out (patch -R -p1) and the new patch attached here applied, do cold boot 
and post the log.

Thanks.

-- 
tejun

--------------080604040202080001040703
Content-Type: text/x-patch;
 name="ata_piix-debug-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ata_piix-debug-1.patch"

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
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c

--------------080604040202080001040703--
