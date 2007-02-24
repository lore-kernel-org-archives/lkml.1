Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXBXHoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXBXHoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 02:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933414AbXBXHoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 02:44:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:33329 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413AbXBXHoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 02:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=tvE4WKoOMSsxzK5KU8U4HnBxB2TVCVfv4QcNvn4tjwJo022rKubhyKW49+N4V/XQw640cV/jd+I6+p0Re5jbnHg3MVZXQEmBFCJ2dkB8snYTAg2MVWEw6YcN/xVq3Z4ycx1/eh+uleYJ1I7M/ARaOJwc31esnjiPGaG7ykys7EA=
Date: Sat, 24 Feb 2007 10:41:15 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB Elan FTDI: check for workqueue creation v2
Message-ID: <20070224074115.GB10139@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents from NULL pointer usage if
workqueue creation failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Btw, Pete, you are right! C99 ANSI standart says that static pointer
if it not initialized explicitly has to be set to NULL by compiler ;)
Thanks a lot for comments and Ack the patch please.

 drivers/usb/misc/ftdi-elan.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 0c1d66d..bc3327e 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -2905,17 +2905,31 @@ static int __init ftdi_elan_init(void)
 {
         int result;
         printk(KERN_INFO "driver %s built at %s on %s\n", ftdi_elan_driver.name,
-                 __TIME__, __DATE__);
+	       __TIME__, __DATE__);
         init_MUTEX(&ftdi_module_lock);
         INIT_LIST_HEAD(&ftdi_static_list);
         status_queue = create_singlethread_workqueue("ftdi-status-control");
+	if (!status_queue)
+		goto err1;
         command_queue = create_singlethread_workqueue("ftdi-command-engine");
+	if (!command_queue)
+		goto err2;
         respond_queue = create_singlethread_workqueue("ftdi-respond-engine");
+	if (!respond_queue)
+		goto err3;
         result = usb_register(&ftdi_elan_driver);
         if (result)
                 printk(KERN_ERR "usb_register failed. Error number %d\n",
-                        result);
+		       result);
         return result;
+
+ err3:
+	destroy_workqueue(command_queue);
+ err2:
+	destroy_workqueue(status_queue);
+ err1:
+	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
+	return -ENOMEM;
 }
 
 static void __exit ftdi_elan_exit(void)
