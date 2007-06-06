Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbXFFIqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbXFFIqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXFFIqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:46:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31316 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbXFFIqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=OPOPhjUbpKIndWY/HSjdQ3vdAxPOy1hh609nTg2aT5M4ntJvUR74q5TJ9CrQuKpyhNhKiTEFAxsEJ5zSylpqwPsheMH64RL/G6UW2cK76dZiNYCVVZ5JaZf6ndDEfLrY+9lZfoG4yOtEdkz5lE2ae34J6omsp6Qf7jqvPjVetWE=
Message-ID: <46667466.4010500@gmail.com>
Date: Wed, 06 Jun 2007 17:46:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>	 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>	 <466196AD.3090502@garzik.org> <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>
In-Reply-To: <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------010506040506040407080802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010506040506040407080802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Gregor Jasny wrote:
> 2007/6/2, Jeff Garzik <jeff@garzik.org>:
>> Does this patch change the behavior at all?
> 
> No. It still times out. I've raised the first timeout to 60 seconds
> but still no luck.

Let's see where we're failing.  Please apply the attached patch and
report what kernel says.

Thanks.

-- 
tejun

--------------010506040506040407080802
Content-Type: text/x-patch;
 name="srst-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srst-debug.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4733f00..ae6f177 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3053,8 +3053,11 @@ static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 	if (dev0) {
 		rc = ata_wait_ready(ap, deadline);
 		if (rc) {
-			if (rc != -ENODEV)
+			if (rc != -ENODEV) {
+				ata_port_printk(ap, KERN_WARNING,
+						"ata_bus_post_reset: EXIT0\n");
 				return rc;
+			}
 			ret = rc;
 		}
 	}
@@ -3070,15 +3073,21 @@ static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 		lbal = ioread8(ioaddr->lbal_addr);
 		if ((nsect == 1) && (lbal == 1))
 			break;
-		if (time_after(jiffies, deadline))
+		if (time_after(jiffies, deadline)) {
+			ata_port_printk(ap, KERN_WARNING,
+					"ata_bus_post_reset: EXIT1\n");
 			return -EBUSY;
+		}
 		msleep(50);	/* give drive a breather */
 	}
 	if (dev1) {
 		rc = ata_wait_ready(ap, deadline);
 		if (rc) {
-			if (rc != -ENODEV)
+			if (rc != -ENODEV) {
+				ata_port_printk(ap, KERN_WARNING,
+						"ata_bus_post_reset: EXIT2\n");
 				return rc;
+			}
 			ret = rc;
 		}
 	}
@@ -3090,6 +3099,7 @@ static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 	if (dev0)
 		ap->ops->dev_select(ap, 0);
 
+	ata_port_printk(ap, KERN_WARNING, "ata_bus_post_reset: EXIT3\n");
 	return ret;
 }
 

--------------010506040506040407080802--
