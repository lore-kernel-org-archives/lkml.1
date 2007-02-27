Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbXB0Nd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbXB0Nd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbXB0Nd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:33:26 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:23870 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbXB0NdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Upl8cxwuMQH3TM+yELQia+eET063hsjGOpW51Jt0iH//nhHa+iUpIm9mlvEfZm0d+drhRZduwGDjpHMMkRnp/mFVT6Vvxgg6hN6SmcBjRW7pLzE65I384LJSOnTnU8dJr6tYXx2oM1sP7vAH38nysY/6SFZNeP5aZ3W93g1Nw6U=
Date: Tue, 27 Feb 2007 22:33:21 +0900
From: Tejun Heo <htejun@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Komuro <komurojun-mbn@nifty.com>
Subject: [PATCH] libata: clear drvdata in ata_host_release(), take#2
Message-ID: <20070227133321.GH20322@htj.dyndns.org>
References: <20070224074823.GA20322@htj.dyndns.org> <45E0EB9F.3050001@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E0EB9F.3050001@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clearing drvdata in ->remove_one causes NULL pointer deference.  Clear
drvdata only in ata_host_release() after all resources are freed.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
pata_pcmcia is fixed by Alan's patch.  This fixes other drivers and
make libata always clear drvdata after detach.

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bdde327..3bdb509 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5680,6 +5680,8 @@ static void ata_host_release(struct device *gendev, void *res)
 
 	if (host->ops->host_stop)
 		host->ops->host_stop(host);
+
+	dev_set_drvdata(gendev, NULL);
 }
 
 /**
@@ -5902,7 +5904,6 @@ int ata_device_add(const struct ata_probe_ent *ent)
 
  err_out:
 	devres_release_group(dev, ata_device_add);
-	dev_set_drvdata(dev, NULL);
 	VPRINTK("EXIT, returning %d\n", rc);
 	return 0;
 }
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index c1334c6..8ff2d58 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -306,7 +306,6 @@ static void __devexit cs5520_remove_one(struct pci_dev *pdev)
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
-	dev_set_drvdata(dev, NULL);
 }
 
 /**
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index d5f2e85..1a61cc8 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -128,7 +128,6 @@ static void isapnp_remove_one(struct pnp_dev *idev)
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
-	dev_set_drvdata(dev, NULL);
 }
 
 static struct pnp_device_id isapnp_devices[] = {
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 02ea95f..4b82a54 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -228,7 +228,6 @@ static int __devexit pata_platform_remove(struct platform_device *pdev)
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
-	dev_set_drvdata(dev, NULL);
 
 	return 0;
 }
