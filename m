Return-Path: <linux-kernel-owner+w=401wt.eu-S2992861AbXDRREl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992861AbXDRREl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992868AbXDRREl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:04:41 -0400
Received: from smtpauth11.prod.mesa1.secureserver.net ([64.202.165.35]:59994
	"HELO smtpauth12.prod.mesa1.secureserver.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with SMTP id S2992861AbXDRREk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:04:40 -0400
Message-ID: <46264FA5.1070304@seclark.us>
Date: Wed, 18 Apr 2007 13:04:37 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       7eggert@gmx.de, Chuck Ebbert <cebbert@redhat.com>,
       emisca <emisca.ml@gmail.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it>	<88Sov-662-3@gated-at.bofh.it>	<88SHV-6uL-29@gated-at.bofh.it>	<8agVk-3wc-81@gated-at.bofh.it>	<8b3IR-4mE-25@gated-at.bofh.it>	<8b3SA-4z3-5@gated-at.bofh.it>	<8b42g-51N-15@gated-at.bofh.it>	<8bbdm-7iS-27@gated-at.bofh.it>	<E1He8dA-0000mw-LI@be1.lrz>	<46260981.1040109@gmail.com>	<20070418132904.3322ba5f@the-village.bc.nu>	<46261337.3010406@gmail.com>	<20070418140346.636879a1@the-village.bc.nu>	<46262C0E.9000103@rtr.ca> <20070418160627.7ab77c30@the-village.bc.nu> <46263650.3080705@rtr.ca>
In-Reply-To: <46263650.3080705@rtr.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:

>Alan Cox wrote:
>  
>
>>>+		if (dev->needs_flush && ata_try_flush_cache(dev)) {
>>> 			return ata_scsi_flush_xlat;
>>>+			dev->needs_flush = 0;
>>>      
>>>
>>Works better if you swap the dev-> and return lines
>>    
>>
>
>Heh, yeah, I noticed that!
>
>Here it is, *tested* now, with another fix.
>
>It would be nice if somebody who can hear the "pop" would also test this,
>as it will confirm that this is a complete fix for the problem.
>My "pop" drives are busy elsewhere right now.
>
>Tejun might use something like this, or do something better in libata-core,
>but it's still helpful to have confirmation that we're on the right track.
>
>This patch eliminates the redundant "SYNCHRONIZE_CACHE" request at shutdown
>which is causing undue wear/tear/alarm to various systems.
>
>Signed-off-by: Mark Lord <mlord@pobox.com>
>---
>--- old/include/linux/libata.h	2007-04-18 10:30:25.000000000 -0400
>+++ linux/include/linux/libata.h	2007-04-18 10:30:28.000000000 -0400
>@@ -499,6 +499,7 @@
> 	struct ata_ering	ering;
> 	int			spdn_cnt;
> 	unsigned int		horkage;	/* List of broken features */
>+	int			needs_sync_cache; /* 0==sync-cache not needed */
> #ifdef CONFIG_SATA_ACPI
> 	/* ACPI objects info */
> 	acpi_handle obj_handle;
>--- old/drivers/ata/libata-scsi.c	2007-04-18 10:48:34.000000000 -0400
>+++ linux/drivers/ata/libata-scsi.c	2007-04-18 10:51:09.000000000 -0400
>@@ -2749,18 +2749,20 @@
> 			return atapi_xlat;
> 
> 	switch (cmd) {
>-	case READ_6:
>-	case READ_10:
>-	case READ_16:
>-
> 	case WRITE_6:
> 	case WRITE_10:
> 	case WRITE_16:
>+		dev->needs_sync_cache = 1;
>+	case READ_6:
>+	case READ_10:
>+	case READ_16:
> 		return ata_scsi_rw_xlat;
> 
> 	case SYNCHRONIZE_CACHE:
>-		if (ata_try_flush_cache(dev))
>+		if (dev->needs_sync_cache && ata_try_flush_cache(dev)) {
>+			dev->needs_sync_cache = 0;
> 			return ata_scsi_flush_xlat;
>+		}
> 		break;
> 
> 	case VERIFY:
>@@ -2769,6 +2771,7 @@
> 
> 	case ATA_12:
> 	case ATA_16:
>+		dev->needs_sync_cache = 1;
> 		return ata_scsi_pass_thru;
> 
> 	case START_STOP:
>-
>To unsubscribe from this list: send the line "unsubscribe linux-ide" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>
I tried this on 2.6.20.2 it applied to libata with some fuzz and I had 
to manually edit libata.h
When I did a shutdown I still got the click/pop.

I also noticed the last thing displayed on the lcd before it goes blank is
Synchronizing SCSI Disks - then the click/pop.

HTH,
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



