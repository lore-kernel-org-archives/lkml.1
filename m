Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbXFGHiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbXFGHiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXFGHil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:38:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:56000 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXFGHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=pD94UJJpZGMhUTfbOylFTp0k/zL2Wofv2Q6icD/dJxBFPQyJXjrfX5CqevPRdBmMhPl6S9bwAcvxz9xiSLwewTvKmjc3DZopIOAHBKVbA18MiceqO9IEfrs9MQVXge3OtJfecM9G5LFpN1GeAPnmdl42ICzIQJFOHLP0d2L2jrQ=
Message-ID: <4667B39D.209@gmail.com>
Date: Thu, 07 Jun 2007 16:28:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Robert de Rooy <robert.de.rooy@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com>	<464C1575.8070005@gmail.com>	<464CB7C9.2080807@gmail.com>	<46503192.1040300@gmail.com>	<4650B9E3.7070409@gmail.com>	<46518798.2020808@gmail.com>	<4651B66E.6030505@gmail.com>	<4651B834.3060702@gmail.com>	<4651C4A1.6000101@gmail.com>	<4651C74B.7020108@gmail.com>	<46520B36.90409@garzik.org> <20070523150229.00a0c3c4@the-village.bc.nu> <466718B6.4080105@gmail.com>
In-Reply-To: <466718B6.4080105@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------060806070008010309040601"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060806070008010309040601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Robert de Rooy wrote:
> Alan Cox wrote:
>>>>   http://thread.gmane.org/gmane.linux.kernel/530099
>>>>
>>>> It seems we're losing interrupts from the CFA device.  Any ideas?
>>>>       
>>> Alan probably knows more, but ISTR some CFA PCMCIA devices that
>>> needed polling...
>>>     
>>
>> Not that I know of. Not devices anyway - there are embedded boxes with no
>> IRQ configuration for the CF slot but we've never supported those (indeed
>> there are even people who bitbang ATA on GPIO pins...)
>>
>>   
> I was able to test the same PCMCIA adapter in a different ThinkPad, an X40.
> The X40 also fails although it has a totally different Cardbus
> controller (TI on the T40 vs Ricoh on the X40)
> 
> Here is the log from the X40 running the same kernel as before
> (2.6.22rc1-git5 + timing-debug.patch +
> disable-dev_init_param-and-setxfermode-for-CFA.patch)

Can you test the attached patch?

-- 
tejun

--------------060806070008010309040601
Content-Type: text/x-patch;
 name*0="libata-dont-test-slave-register-readiness-after-srst.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="libata-dont-test-slave-register-readiness-after-srst.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4733f00..bac5e1f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3042,7 +3042,6 @@ int ata_wait_ready(struct ata_port *ap, unsigned long deadline)
 static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 			      unsigned long deadline)
 {
-	struct ata_ioports *ioaddr = &ap->ioaddr;
 	unsigned int dev0 = devmask & (1 << 0);
 	unsigned int dev1 = devmask & (1 << 1);
 	int rc, ret = 0;
@@ -3059,22 +3058,9 @@ static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 		}
 	}
 
-	/* if device 1 was found in ata_devchk, wait for
-	 * register access, then wait for BSY to clear
-	 */
-	while (dev1) {
-		u8 nsect, lbal;
-
-		ap->ops->dev_select(ap, 1);
-		nsect = ioread8(ioaddr->nsect_addr);
-		lbal = ioread8(ioaddr->lbal_addr);
-		if ((nsect == 1) && (lbal == 1))
-			break;
-		if (time_after(jiffies, deadline))
-			return -EBUSY;
-		msleep(50);	/* give drive a breather */
-	}
+	/* wait for device 1 */
 	if (dev1) {
+		ap->ops->dev_select(ap, 1);
 		rc = ata_wait_ready(ap, deadline);
 		if (rc) {
 			if (rc != -ENODEV)

--------------060806070008010309040601--
