Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbZGXDCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbZGXDCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZGXDCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:02:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:60191 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbZGXDCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:02:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,259,1246863600"; 
   d="scan'208";a="710608371"
Subject: [PATCH V2 4/4] i8042: support async suspend and shutdown
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, dtor@mail.ru,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 11:02:12 +0800
Message-Id: <1248404532.2670.112.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i8042 controller support device async actions.

If boot option "dev_async_action" is added,
i8042 controller and its child devices can be
suspended/shutdown asynchronously.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/input/serio/i8042.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/input/serio/i8042.c
===================================================================
--- linux-2.6.orig/drivers/input/serio/i8042.c
+++ linux-2.6/drivers/input/serio/i8042.c
@@ -1285,14 +1285,21 @@ static int __init i8042_init(void)
 		goto err_unregister_driver;
 	}
 
-	err = platform_device_add(i8042_platform_device);
+	err = dev_async_register(&i8042_platform_device->dev,
+			DEV_ASYNC_SUSPEND | DEV_ASYNC_SHUTDOWN);
 	if (err)
 		goto err_free_device;
 
+	err = platform_device_add(i8042_platform_device);
+	if (err)
+		goto err_dev_async_unregister;
+
 	panic_blink = i8042_panic_blink;
 
 	return 0;
 
+ err_dev_async_unregister:
+	dev_async_unregister(&i8042_platform_device->dev);
  err_free_device:
 	platform_device_put(i8042_platform_device);
  err_unregister_driver:
@@ -1305,6 +1312,7 @@ static int __init i8042_init(void)
 
 static void __exit i8042_exit(void)
 {
+	dev_async_unregister(&i8042_platform_device->dev);
 	platform_device_unregister(i8042_platform_device);
 	platform_driver_unregister(&i8042_driver);
 	i8042_platform_exit();


