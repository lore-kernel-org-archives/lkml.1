Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbXBSSSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbXBSSSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932450AbXBSSSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:18:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:15297 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbXBSSSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:18:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=uUBk2WQZLapO0GgQPsgq3VwrEaswODdRwOZivXtePLd9kJVzZKybUjuyy6C/upMiMjVqkUFG/qRV58jQALNn2pD2nFMpXoRST2EDdgPMQc7gN6BKsCiCu8tDEkczX4HRgxLbvCVzWTqrcPlUkGVJWtajs/jFh2Z2KuC3nbTkhX4=
Date: Mon, 19 Feb 2007 21:15:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tony Olech <tony.olech@elandigitalsystems.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB Elan FTDI: check for workqueue creation
Message-ID: <20070219181549.GB10111@cvg>
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

 drivers/usb/misc/ftdi-elan.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 0c1d66d..67a25e9 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -57,9 +57,9 @@ module_param(distrust_firmware, bool, 0);
 MODULE_PARM_DESC(distrust_firmware, "true to distrust firmware power/overcurren"
         "t setup");
 extern struct platform_driver u132_platform_driver;
-static struct workqueue_struct *status_queue;
-static struct workqueue_struct *command_queue;
-static struct workqueue_struct *respond_queue;
+static struct workqueue_struct *status_queue = NULL;
+static struct workqueue_struct *command_queue = NULL;
+static struct workqueue_struct *respond_queue = NULL;
 /*
 * ftdi_module_lock exists to protect access to global variables
 *
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
