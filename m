Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbZG3PYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbZG3PYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZG3PYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:24:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:27205 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZG3PYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PUb9MsIRFwCD9WT+MqQ+Op4I0aIk4UyfYS3LQLT+up+jtvyge/3RbcsOvtGeTGEhyZ
         77rLiGtWaQOS7ImNEDGKqobnszLMDlHXqcVkHem5ymb9/2Vf+LRXQHPCZCZ8kHVAmRu9
         G7sbG0tF1fIVkcoZxekme8PPhp8XTckIuvpyk=
MIME-Version: 1.0
In-Reply-To: <4A71B940.80607@uiuc.edu>
References: <1248958178-22599-1-git-send-email-sgayda2@uiuc.edu> 
	<4A719A27.8050509@linutronix.de> <ce9ab5790907300639k3173446csbd07198055bfe122@mail.gmail.com> 
	<4A71A483.30507@linutronix.de> <ce9ab5790907300714u5c88f1cdk8c0387de5ba9f413@mail.gmail.com> 
	<4A71AD5E.4080704@uiuc.edu> <4A71B401.1090208@linutronix.de> 
	<ce9ab5790907300813r2c35249csbce608a0f7533562@mail.gmail.com> 
	<4A71B940.80607@uiuc.edu>
From: vimal singh <vimal.newwork@gmail.com>
Date: Thu, 30 Jul 2009 20:54:27 +0530
Message-ID: <ce9ab5790907300824i919aa54m5b483f257051add6@mail.gmail.com>
Subject: Re: [PATCH] [mtd] fixed faulty check
To: Stoyan Gaydarov <sgayda2@uiuc.edu>
Cc: linux-kernel@vger.kernel.org, David.Woodhouse@intel.com, sr@denx.de,
       kay.sievers@vrfy.org, gregkh@suse.de, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a spelling error that has resulted from copy and
pasting. The location of the error was found using a semantic patch
but the semantic patch was not trying to find these errors. After
looking things over it seemed logical that this change was needed.

The patch also makes sure mtd_list is not being freed if it has not
been allocated

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
Signed-off-by: Vimal Singh <vimalsingh@ti.com>
---

diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 39d357b..584a1c8 100644
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
+err_flash_remove:
 	of_flash_remove(dev);

 	return err;
