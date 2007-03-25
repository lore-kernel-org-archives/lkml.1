Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbXCYHb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbXCYHb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 03:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXCYHb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 03:31:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:34410 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbXCYHb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 03:31:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=iU1Y+5C2IuMrt/VSZn9oA49rTjJ0E4tlz4u7V5+rm1D+uhQDvu0qMbSqbU9lVmDGVMws39YvlbnG0BEYmtHTGAigSVjnX1ETcfMRc6znG9vlJQL5kiUpKxlnwrau8l2pWQBkzSCBtQ2f2H1rEgKPtVBYLZGWHrfIFm3XbLKIynw=
Date: Sun, 25 Mar 2007 11:27:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB Elan FTDI: check for driver registration status
Message-ID: <20070325072733.GA10257@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking of driver registration status
and if it fails release allocated resources.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Pete, please review the patch and Ack it then.

 drivers/usb/misc/ftdi-elan.c |   37 +++++++++++++++++++++++--------------
 1 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index bc3327e..3cd9ae3 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -2909,27 +2909,36 @@ static int __init ftdi_elan_init(void)
         init_MUTEX(&ftdi_module_lock);
         INIT_LIST_HEAD(&ftdi_static_list);
         status_queue = create_singlethread_workqueue("ftdi-status-control");
-	if (!status_queue)
-		goto err1;
         command_queue = create_singlethread_workqueue("ftdi-command-engine");
-	if (!command_queue)
-		goto err2;
         respond_queue = create_singlethread_workqueue("ftdi-respond-engine");
-	if (!respond_queue)
-		goto err3;
+	if (!status_queue || !command_queue || !respond_queue) {
+		printk(KERN_ERR "%s couldn't create workqueue\n",
+		       ftdi_elan_driver.name);
+		result = -ENOMEM;
+		goto err;
+	}
         result = usb_register(&ftdi_elan_driver);
-        if (result)
+        if (result) {
                 printk(KERN_ERR "usb_register failed. Error number %d\n",
 		       result);
+		goto err;
+	}
         return result;
 
- err3:
-	destroy_workqueue(command_queue);
- err2:
-	destroy_workqueue(status_queue);
- err1:
-	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
-	return -ENOMEM;
+ err:
+	if (status_queue) {
+		destroy_workqueue(status_queue);
+		status_queue = NULL;
+	}
+	if (command_queue) {
+		destroy_workqueue(command_queue);
+		command_queue = NULL;
+	}
+	if (respond_queue) {
+		destroy_workqueue(respond_queue);
+		respond_queue = NULL;
+	}
+	return result;
 }
 
 static void __exit ftdi_elan_exit(void)
