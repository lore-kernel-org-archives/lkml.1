Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbZG3PON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbZG3PON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZG3POM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:14:12 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:47101 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbZG3POM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YixnuhCWrUHf/SOxqcO4/W4w+nKqbWV8jJDsPEHnO2rhO65NH460VMOqbsx4oHjk16
         TFR7yY1hYZDXP1wIh2qrj8uYh4BGTBDLKSrSpPNkruxyX2Eo1iDgxKxkPvVq2SftafSI
         2x5H5JjrOBidcShl4auVVK2GdPgJ/ebTTawpo=
MIME-Version: 1.0
In-Reply-To: <4A71B401.1090208@linutronix.de>
References: <1248958178-22599-1-git-send-email-sgayda2@uiuc.edu> 
	<4A719A27.8050509@linutronix.de> <ce9ab5790907300639k3173446csbd07198055bfe122@mail.gmail.com> 
	<4A71A483.30507@linutronix.de> <ce9ab5790907300714u5c88f1cdk8c0387de5ba9f413@mail.gmail.com> 
	<4A71AD5E.4080704@uiuc.edu> <4A71B401.1090208@linutronix.de>
From: vimal singh <vimal.newwork@gmail.com>
Date: Thu, 30 Jul 2009 20:43:51 +0530
Message-ID: <ce9ab5790907300813r2c35249csbce608a0f7533562@mail.gmail.com>
Subject: Re: [PATCH] [mtd] fixed faulty check
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Stoyan Gaydarov <sgayda2@uiuc.edu>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, sr@denx.de, kay.sievers@vrfy.org,
       gregkh@suse.de, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 8:23 PM, Sebastian Andrzej
Siewior<bigeasy@linutronix.de> wrote:
> Stoyan Gaydarov wrote:
>>>>
>>>> We have to and of_flash_remove() takes care of it.
>>>>
>>>
>>>
>>
>> Does this mean that the original patch is fine or does it still need the
>> kfree? From what i understand when going to err_out it will take care of
>> info using of_flash_remove() so then it is not needed in the if check.
>
> The original patch was fine but it leaked info. of_flash_remove() does the
> cleanup of info but only if it is part of driver's data (after the
> of_flash_remove()). So you have to call dev_set_drvdata(&dev->dev, info)
> earlier, after the kzalloc() to save the data or else there is no clean
> up.
>

Is this patch looks OK??


diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 39d357b..d104cfc 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -204,7 +204,7 @@ static int __devinit of_flash_probe(struct of_device *dev,
 		dev_err(&dev->dev, "Malformed reg property on %s\n",
 				dev->node->full_name);
 		err = -EINVAL;
-		goto err_out;
+		goto err_flash_remove;
 	}
 	count /= reg_tuple_size;

@@ -212,14 +212,14 @@ static int __devinit of_flash_probe(struct of_device *dev,
 	info = kzalloc(sizeof(struct of_flash) +
 		       sizeof(struct of_flash_list) * count, GFP_KERNEL);
 	if (!info)
-		goto err_out;
-
-	mtd_list = kzalloc(sizeof(struct mtd_info) * count, GFP_KERNEL);
-	if (!info)
-		goto err_out;
+		goto err_flash_remove;

 	dev_set_drvdata(&dev->dev, info);

+	mtd_list = kzalloc(sizeof(struct mtd_info) * count, GFP_KERNEL);
+	if (!mtd_list)
+		goto err_flash_remove;
+
 	for (i = 0; i < count; i++) {
 		err = -ENXIO;
 		if (of_address_to_resource(dp, i, &res)) {
@@ -338,6 +338,7 @@ static int __devinit of_flash_probe(struct of_device *dev,

 err_out:
 	kfree(mtd_list);
+eerr_flash_remov:
 	of_flash_remove(dev);

 	return err;
