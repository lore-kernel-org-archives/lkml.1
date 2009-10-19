Return-Path: <linux-kernel-owner+w=401wt.eu-S932342AbZJSXIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbZJSXIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 19:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbZJSXII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 19:08:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:20138 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbZJSXIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 19:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pxn1RQYy6lx+GWtMzc7rTzteO3hjK4gl5XrEqNPEz/TVj4x+xxCR/jeNZVRnR9N5wn
         fw0V5kznknGwcwOhMgtcY5krL68o8cd+PlNW9EtK1+8DkZnrrrBhNSXdW+XqlU0f9oUG
         UCYppNALNFrA7HwgCA6a8/mZPhqjUF0Mcb2Sk=
Date: Tue, 20 Oct 2009 03:09:52 +0400
From: Paul Fertser <fercerpav@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 5/7] mfd: pcf50633: Cleanup pcf50633_probe error
	handling
Message-ID: <20091019230952.GB19580@home.pavel.comp>
References: <1255471956-29201-1-git-send-email-fercerpav@gmail.com> <1255471956-29201-2-git-send-email-fercerpav@gmail.com> <1255471956-29201-3-git-send-email-fercerpav@gmail.com> <1255471956-29201-4-git-send-email-fercerpav@gmail.com> <1255471956-29201-5-git-send-email-fercerpav@gmail.com> <20091019150812.GC3885@sortiz.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20091019150812.GC3885@sortiz.org>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Samuel,

Big thanks for your comments, next time i send anything upstream i
will certainly provide a minimal changelog for every patch :)

On Mon, Oct 19, 2009 at 05:08:13PM +0200, Samuel Ortiz wrote:
> On Wed, Oct 14, 2009 at 02:12:34AM +0400, Paul Fertser wrote:
> >  	if (enable_irq_wake(client->irq) < 0)
> > -		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
> > +		dev_info(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
> >  			"in this hardware revision", client->irq);
> 2 things here: This doesnt really belong to this patch, and also I'd prefer to
> keep that as an error message.
[...]
> >  	ret = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
> >  	if (ret)
> > -		dev_err(pcf->dev, "error creating sysfs entries\n");
> > +		dev_info(pcf->dev, "Failed to create sysfs entries\n");
> Same here.

Sure. Please find amended version in attachement.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0005-mfd-pcf50633-Cleanup-pcf50633_probe-error-handling.patch"

>From 7f982d01515371fcbab0086bf77448f351b09a42 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Thu, 8 Oct 2009 00:24:54 +0200
Subject: [PATCH] mfd: pcf50633: Cleanup pcf50633_probe error handling

Currently the child devices were not freed if the irq could not be requested.
This patch restructures the function, that in case of an error all previously
allocated resources are freed.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/mfd/pcf50633-core.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 69cdbdc..5aed527 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -553,9 +553,14 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 {
 	struct pcf50633 *pcf;
 	struct pcf50633_platform_data *pdata = client->dev.platform_data;
-	int i, ret = 0;
+	int i, ret;
 	int version, variant;
 
+	if (!client->irq) {
+		dev_err(&client->dev, "Missing IRQ\n");
+		return -ENOENT;
+	}
+
 	pcf = kzalloc(sizeof(*pcf), GFP_KERNEL);
 	if (!pcf)
 		return -ENOMEM;
@@ -570,6 +575,12 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf->irq = client->irq;
 	pcf->work_queue = create_singlethread_workqueue("pcf50633");
 
+	if (!pcf->work_queue) {
+		dev_err(&client->dev, "Failed to alloc workqueue\n");
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
 	INIT_WORK(&pcf->irq_work, pcf50633_irq_worker);
 
 	version = pcf50633_reg_read(pcf, 0);
@@ -577,7 +588,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	if (version < 0 || variant < 0) {
 		dev_err(pcf->dev, "Unable to probe pcf50633\n");
 		ret = -ENODEV;
-		goto err;
+		goto err_destroy_workqueue;
 	}
 
 	dev_info(pcf->dev, "Probed device version %d variant %d\n",
@@ -591,6 +602,14 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf50633_reg_write(pcf, PCF50633_REG_INT4M, 0x00);
 	pcf50633_reg_write(pcf, PCF50633_REG_INT5M, 0x00);
 
+	ret = request_irq(client->irq, pcf50633_irq,
+					IRQF_TRIGGER_LOW, "pcf50633", pcf);
+
+	if (ret) {
+		dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
+		goto err_destroy_workqueue;
+	}
+
 	/* Create sub devices */
 	pcf50633_client_dev_register(pcf, "pcf50633-input",
 						&pcf->input_pdev);
@@ -606,7 +625,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 		pdev = platform_device_alloc("pcf50633-regltr", i);
 		if (!pdev) {
-			dev_err(pcf->dev, "Cannot create regulator\n");
+			dev_err(pcf->dev, "Cannot create regulator %d\n", i);
 			continue;
 		}
 
@@ -618,19 +637,6 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 		platform_device_add(pdev);
 	}
 
-	if (client->irq) {
-		ret = request_irq(client->irq, pcf50633_irq,
-				IRQF_TRIGGER_LOW, "pcf50633", pcf);
-
-		if (ret) {
-			dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
-			goto err;
-		}
-	} else {
-		dev_err(pcf->dev, "No IRQ configured\n");
-		goto err;
-	}
-
 	if (enable_irq_wake(client->irq) < 0)
 		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
 			"in this hardware revision", client->irq);
@@ -644,9 +650,12 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 	return 0;
 
-err:
+err_destroy_workqueue:
 	destroy_workqueue(pcf->work_queue);
+err_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(pcf);
+
 	return ret;
 }
 
-- 
1.6.0.6


--LQksG6bCIzRHxTLp--
