Return-Path: <linux-kernel-owner+w=401wt.eu-S1751117AbZIJOgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbZIJOgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 10:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZIJOgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 10:36:07 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:52843 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZIJOgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 10:36:07 -0400
Content-Disposition: inline
From: iceberg <strakh@ispras.ru>
Organization: ISP RAS
To: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fix lock imbalances in /drivers/media/video/cafe_ccic.c
Date: Thu, 10 Sep 2009 18:37:34 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909101837.34472.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ./drivers/media/video/cafe_ccic.c, in function cafe_pci_probe: 
Mutex must be unlocked before exit
	1. On paths starting with mutex lock in line 1912, then continuing in lines: 
1929, 1936 (goto unreg) and 1940 (goto iounmap) . 
	2. On path starting in line 1971 mutex lock, and then continuing in line 1978 
(goto out_smbus) mutex.

Fix lock imbalances in function cafe_pci_probe.
Found by Linux Driver Verification project.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>

---
diff --git a/./a/drivers/media/video/cafe_ccic.c 
b/./b/drivers/media/video/cafe_ccic.c
index c4d181d..2987433 100644
--- a/./a/drivers/media/video/cafe_ccic.c
+++ b/./b/drivers/media/video/cafe_ccic.c
@@ -1925,19 +1925,24 @@ static int cafe_pci_probe(struct pci_dev *pdev,
         * Get set up on the PCI bus.
         */
        ret = pci_enable_device(pdev);
-       if (ret)
+       if (ret) {
+               mutex_unlock(&cam->s_mutex);
                goto out_unreg;
+       }
        pci_set_master(pdev);

        ret = -EIO;
        cam->regs = pci_iomap(pdev, 0, 0);
        if (! cam->regs) {
                printk(KERN_ERR "Unable to ioremap cafe-ccic regs\n");
+               mutex_unlock(&cam->s_mutex);
                goto out_unreg;
        }
        ret = request_irq(pdev->irq, cafe_irq, IRQF_SHARED, "cafe-ccic", cam);
-       if (ret)
+       if (ret) {
+               mutex_unlock(&cam->s_mutex);
                goto out_iounmap;
+       }
        /*
         * Initialize the controller and leave it powered up.  It will
         * stay that way until the sensor driver shows up.
@@ -1974,8 +1979,10 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 /*     cam->vdev.debug = V4L2_DEBUG_IOCTL_ARG;*/
        cam->vdev.v4l2_dev = &cam->v4l2_dev;
        ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
-       if (ret)
+       if (ret) {
+               mutex_unlock(&cam->s_mutex);
                goto out_smbus;
+       }
        video_set_drvdata(&cam->vdev, cam);

        /*

