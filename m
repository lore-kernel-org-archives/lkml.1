Return-Path: <linux-kernel-owner+w=401wt.eu-S2993449AbXEBQRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993449AbXEBQRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993447AbXEBQRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:17:46 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:36301
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993449AbXEBQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:17:39 -0400
Subject: [PATCH] synclink_gt use dynamic tty device registration
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 02 May 2007 11:17:33 -0500
Message-Id: <1178122653.4485.2.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change synclink_gt driver to use dynamic tty device registration.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>


--- a/drivers/char/synclink_gt.c	2007-04-25 22:08:32.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2007-05-02 11:11:34.000000000 -0500
@@ -3415,6 +3415,9 @@ static void device_init(int adapter_num,
 			}
 		}
 	}
+
+	for (i=0; i < port_count; ++i)
+		tty_register_device(serial_driver, port_array[i]->line, &(port_array[i]->pdev->dev));
 }
 
 static int __devinit init_one(struct pci_dev *dev,
@@ -3466,6 +3469,8 @@ static void slgt_cleanup(void)
 	printk("unload %s %s\n", driver_name, driver_version);
 
 	if (serial_driver) {
+		for (info=slgt_device_list ; info != NULL ; info=info->next_device)
+			tty_unregister_device(serial_driver, info->line);
 		if ((rc = tty_unregister_driver(serial_driver)))
 			DBGERR(("tty_unregister_driver error=%d\n", rc));
 		put_tty_driver(serial_driver);
@@ -3506,23 +3511,10 @@ static int __init slgt_init(void)
 
  	printk("%s %s\n", driver_name, driver_version);
 
-	slgt_device_count = 0;
-	if ((rc = pci_register_driver(&pci_driver)) < 0) {
-		printk("%s pci_register_driver error=%d\n", driver_name, rc);
-		return rc;
-	}
-	pci_registered = 1;
-
-	if (!slgt_device_list) {
-		printk("%s no devices found\n",driver_name);
-		pci_unregister_driver(&pci_driver);
-		return -ENODEV;
-	}
-
 	serial_driver = alloc_tty_driver(MAX_DEVICES);
 	if (!serial_driver) {
-		rc = -ENOMEM;
-		goto error;
+		printk("%s can't allocate tty driver\n", driver_name);
+		return -ENOMEM;
 	}
 
 	/* Initialize the tty_driver structure */
@@ -3539,7 +3531,7 @@ static int __init slgt_init(void)
 		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
 	serial_driver->init_termios.c_ispeed = 9600;
 	serial_driver->init_termios.c_ospeed = 9600;
-	serial_driver->flags = TTY_DRIVER_REAL_RAW;
+	serial_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	tty_set_operations(serial_driver, &ops);
 	if ((rc = tty_register_driver(serial_driver)) < 0) {
 		DBGERR(("%s can't register serial driver\n", driver_name));
@@ -3552,6 +3544,16 @@ static int __init slgt_init(void)
 		driver_name, driver_version,
 		serial_driver->major);
 
+	slgt_device_count = 0;
+	if ((rc = pci_register_driver(&pci_driver)) < 0) {
+		printk("%s pci_register_driver error=%d\n", driver_name, rc);
+		goto error;
+	}
+	pci_registered = 1;
+
+	if (!slgt_device_list)
+		printk("%s no devices found\n",driver_name);
+
 	return 0;
 
 error:


