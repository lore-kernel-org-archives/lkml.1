Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZGASZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZGASZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZGASYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:24:53 -0400
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:37643 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754074AbZGASYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:24:52 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: Problem with /proc/iomem on ARM
Date: Wed, 1 Jul 2009 14:24:52 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901A13854@mi8nycmail19.Mi8.com>
In-Reply-To: <ac3eb2510907011112k690e5c38y2a8871dde5db1f13@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Problem with /proc/iomem on ARM
Thread-Index: Acn6d4/oZ/lcX67ZQlqsNwaxvOyU2AAAOb2A
References: <BD79186B4FD85F4B8E60E381CAEE190901A13822@mi8nycmail19.Mi8.com> <ac3eb2510907011055r5d5f06c1k754e52ebae88efab@mail.gmail.com> <BD79186B4FD85F4B8E60E381CAEE190901A1383F@mi8nycmail19.Mi8.com> <ac3eb2510907011112k690e5c38y2a8871dde5db1f13@mail.gmail.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Jul 2009 18:24:54.0203 (UTC) FILETIME=[3AD898B0:01C9FA79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n61IPdoU032361

On Wednesday, July 01, 2009 11:13 AM, Kay Sievers wrote:
>> The serial ports on my system are amba bus devices.
>>
>>> After all, it seems like this should be fixed in arm somewhere, not to
>>> copy and store internal driver core pointers, but use the device
>>> itself to retrieve the values.
>>
>> Maybe the problem is in drivers/amba/bus.c? amba_device_register() does:
>>
>> Â  Â  Â  Â dev->res.name = dev_name(&dev->dev);
>
> Looks like. If you get the name directly from dev->init_name. Does that work?
>

The following patch does fix /proc/iomem for the amba uarts on my system.
Is this the correct approach to fixing the issue?

Regards,
Hartley

---

amba: set resource init_name

Noticed on ep93xx ARM system, /proc/iomem is missing the names for amba bus
devices.

I appears that drivers/amba/bus.c does not set the kobject to allow dev_name()
to return the device name.  Just use the init_name directly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 3d763fd..9bfb9f7 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -210,7 +210,7 @@ int amba_device_register(struct amba_device *dev, struct resource *parent)
 	dev->dev.release = amba_device_release;
 	dev->dev.bus = &amba_bustype;
 	dev->dev.dma_mask = &dev->dma_mask;
-	dev->res.name = dev_name(&dev->dev);
+	dev->res.name = dev->dev.init_name;
 
 	if (!dev->dev.coherent_dma_mask && dev->dma_mask)
 		dev_warn(&dev->dev, "coherent dma mask is unset\n"); 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
