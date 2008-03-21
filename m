Return-Path: <linux-kernel-owner+w=401wt.eu-S1761920AbYCUWij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761920AbYCUWij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYCUWia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:38:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:34129 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbYCUWi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=DggKbMobJ14nOJKcxRW0a+x98ScobajdBgHe/op6q9GOFbNxzP3VWM988bNrg8UATV9RjblZJatd/LTBZh1T1uWeGcBgHWNxKM3STCHKD8sDaDKzTEtdpWhaU2KzNBDiKpVEHTRFp+U3aURdinlGV4hmYCC9Sgx86ccgxdirn3g=
Date: Fri, 21 Mar 2008 23:38:27 +0100 (CET)
To: Thomas Dahlmann <thomas.dahlmann@amd.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] mem leak fixes for AMD 5536 UDC high/full speed USB device
 controller driver
Message-ID: <alpine.LNX.1.00.0803212335130.10052@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In drivers/usb/gadget/amd5536udc.c::udc_pci_probe(),
sizeof(struct udc) storage is allocated for 'dev'.

There are many exit points from the function where
'dev' is not free'd but has also not yet been used
for anything. The following patch free's 'dev' at the
return points where it has not yet been used.

Please consider applying.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 amd5536udc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index b663f23..fc6f348 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3248,6 +3248,8 @@ static int udc_pci_probe(
 
 	/* pci setup */
 	if (pci_enable_device(pdev) < 0) {
+		kfree(dev);
+		dev = 0;
 		retval = -ENODEV;
 		goto finished;
 	}
@@ -3259,6 +3261,8 @@ static int udc_pci_probe(
 
 	if (!request_mem_region(resource, len, name)) {
 		dev_dbg(&pdev->dev, "pci device used already\n");
+		kfree(dev);
+		dev = 0;
 		retval = -EBUSY;
 		goto finished;
 	}
@@ -3267,18 +3271,24 @@ static int udc_pci_probe(
 	dev->virt_addr = ioremap_nocache(resource, len);
 	if (dev->virt_addr == NULL) {
 		dev_dbg(&pdev->dev, "start address cannot be mapped\n");
+		kfree(dev);
+		dev = 0;
 		retval = -EFAULT;
 		goto finished;
 	}
 
 	if (!pdev->irq) {
 		dev_err(&dev->pdev->dev, "irq not set\n");
+		kfree(dev);
+		dev = 0;
 		retval = -ENODEV;
 		goto finished;
 	}
 
 	if (request_irq(pdev->irq, udc_irq, IRQF_SHARED, name, dev) != 0) {
 		dev_dbg(&dev->pdev->dev, "request_irq(%d) fail\n", pdev->irq);
+		kfree(dev);
+		dev = 0;
 		retval = -EBUSY;
 		goto finished;
 	}



