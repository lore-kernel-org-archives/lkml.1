Return-Path: <linux-kernel-owner+w=401wt.eu-S1761373AbXKPKyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373AbXKPKyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 05:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXKPKx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 05:53:58 -0500
Received: from ns2.suse.de ([195.135.220.15]:45938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbXKPKx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:53:57 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] drivers/firmware/dcdbas: rework to get uevents
Date: Fri, 16 Nov 2007 11:53:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matt Domsch <Matt_Domsch@dell.com>,
       Michael E Brown <Michael_E_Brown@dell.com>,
       Doug Warzecha <Douglas_Warzecha@dell.com>
References: <200711141932.03190.fseidel@suse.de>
In-Reply-To: <200711141932.03190.fseidel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711161153.54423.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch 14 November 2007 19:32:01, you (Frank Seidel) wrote:
> Hi,
> 
> this is a small trivial rework of the dcdbas driver so
> HAL can get uevents when platform devices are added or removed.

Sorry for the noise! In the meantime i realized (thanks to a nice
colleague) this isn't really necessary anymore since patch
43cc71eed1250755986da4c0f9898f9a635cb3bf is in mainline.

If you'd anyway to add this patch i gues this is a better version
of it.

Thanks,
Frank
---
Trivial little change to use new platform platform_register_device to
also get uevents on loading and unloading the driver (e.g. needed for HAL).

Signed-off-by: Frank Seidel <fseidel@suse.de>
---
 drivers/firmware/dcdbas.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -40,7 +40,7 @@
 #include "dcdbas.h"
 
 #define DRIVER_NAME		"dcdbas"
-#define DRIVER_VERSION		"5.6.0-3.2"
+#define DRIVER_VERSION		"5.6.0-3.3"
 #define DRIVER_DESCRIPTION	"Dell Systems Management Base Driver"
 
 static struct platform_device *dcdbas_pdev;
@@ -50,6 +50,7 @@ static dma_addr_t smi_data_buf_handle;
 static unsigned long smi_data_buf_size;
 static u32 smi_data_buf_phys_addr;
 static DEFINE_MUTEX(smi_data_lock);
+static char driver_name[] = DRIVER_NAME;
 
 static unsigned int host_control_action;
 static unsigned int host_control_smi_type;
@@ -596,6 +597,15 @@ static struct platform_driver dcdbas_dri
 	.remove		= __devexit_p(dcdbas_remove),
 };
 
+static void __devexit dcdbas_release(struct device *dev)
+{
+	struct platform_device *pd =
+			container_of(dev, struct platform_device, dev);
+
+	kfree(dev->platform_data);
+	kfree(pd->resource);
+}
+
 /**
  * dcdbas_init: initialize driver
  */
@@ -603,26 +613,27 @@ static int __init dcdbas_init(void)
 {
 	int error;
 
+	dcdbas_pdev = kmalloc(sizeof(*dcdbas_pdev), GFP_KERNEL);
+	if (!dcdbas_pdev)
+		return -ENOMEM;
+
 	error = platform_driver_register(&dcdbas_driver);
 	if (error)
-		return error;
+		goto err_malloc;
 
-	dcdbas_pdev = platform_device_alloc(DRIVER_NAME, -1);
-	if (!dcdbas_pdev) {
-		error = -ENOMEM;
-		goto err_unregister_driver;
-	}
-
-	error = platform_device_add(dcdbas_pdev);
+	dcdbas_pdev->name = driver_name;
+	dcdbas_pdev->id = -1;
+	dcdbas_pdev->dev.release = dcdbas_release;
+	error = platform_device_register(dcdbas_pdev);
 	if (error)
-		goto err_free_device;
+		goto err_unregister_driver;
 
 	return 0;
 
- err_free_device:
-	platform_device_put(dcdbas_pdev);
- err_unregister_driver:
+err_unregister_driver:
 	platform_driver_unregister(&dcdbas_driver);
+err_malloc:
+	kfree(dcdbas_pdev);
 	return error;
 }
 
@@ -647,6 +658,7 @@ static void __exit dcdbas_exit(void)
 	 * released.
 	 */
 	smi_data_buf_free();
+	kfree(dcdbas_pdev);
 }
 
 module_init(dcdbas_init);
