Return-Path: <linux-kernel-owner+w=401wt.eu-S1763757AbXJMPAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763757AbXJMPAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 11:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762930AbXJMOuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:50:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:31372 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762749AbXJMOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=CMaXy/SFaVyomxDnRpLmoMwOLO0Q5U2IgoAJi5W9305AfifyGsI0rxlZH92LT+W4sJbPgJx0vbizJNFV0FjOOkYBR7/+zel6hYLjHaCOQBUxfSVK6TDzTv4yLoPAXg6aQuRx9n4VPunbaB+nnmK61uTiB9KwuqIAA0zclsGR9rk=
Message-ID: <4710DB10.2000107@gmail.com>
Date: Sat, 13 Oct 2007 10:49:52 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: stoth@hauppauge.com
CC: mchehab@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Double-free in cx23885_initdev
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Both cx23885_initdev and cx23885_dev_setup free the device in their 
error path so a failure in the latter causes a double-free. Since 
cx23885_dev_setup is only called from cx23885_initdev, it should be safe 
to remove its deallocation and leave the cleanup up to the allocating 
function.

Coverity CID 1922.

Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 drivers/media/video/cx23885/cx23885-core.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index af16505..3cdd136 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -793,7 +793,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 		       dev->pci->subsystem_device);
 
 		cx23885_devcount--;
-		goto fail_free;
+		return -ENODEV;
 	}
 
 	/* PCIe stuff */
@@ -835,10 +835,6 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	}
 
 	return 0;
-
-fail_free:
-	kfree(dev);
-	return -ENODEV;
 }
 
 void cx23885_dev_unregister(struct cx23885_dev *dev)

