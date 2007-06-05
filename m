Return-Path: <linux-kernel-owner+w=401wt.eu-S933538AbXFEVVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538AbXFEVVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933090AbXFEVVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:21:41 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:60313 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933011AbXFEVVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:21:39 -0400
Message-id: <2351455612530019793@wsc.cz>
In-reply-to: <1058130869771517818@wsc.cz>
Subject: [PATCH 2/3] Char: stallion, alloc tty before pci devices init
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Ingo Korb" <ingo@akana.de>
Date: Tue,  5 Jun 2007 23:21:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

stallion, alloc tty before pci devices init

this causes oops, because pci prboe function calls tty_register_device for
each device found. Thanks to Ingo.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: "Ingo Korb" <ingo@akana.de>

---
commit e7488128b7b4f61c82b6e323067d221c9397c43b
tree 70ea5eb90ca649e3bf6b04db30006afec873fb28
parent aa7cfc04f92ec2b20a07b29a89527d836a93d00f
author Jiri Slaby <jirislaby@gmail.com> Mon, 04 Jun 2007 10:39:41 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 05 Jun 2007 23:14:34 +0200

 drivers/char/stallion.c |   73 ++++++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 265abad..23ea4c8 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -4710,6 +4710,29 @@ static int __init stallion_module_init(void)
 	spin_lock_init(&stallion_lock);
 	spin_lock_init(&brd_lock);
 
+	stl_serial = alloc_tty_driver(STL_MAXBRDS * STL_MAXPORTS);
+	if (!stl_serial) {
+		retval = -ENOMEM;
+		goto err;
+	}
+
+	stl_serial->owner = THIS_MODULE;
+	stl_serial->driver_name = stl_drvname;
+	stl_serial->name = "ttyE";
+	stl_serial->major = STL_SERIALMAJOR;
+	stl_serial->minor_start = 0;
+	stl_serial->type = TTY_DRIVER_TYPE_SERIAL;
+	stl_serial->subtype = SERIAL_TYPE_NORMAL;
+	stl_serial->init_termios = stl_deftermios;
+	stl_serial->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	tty_set_operations(stl_serial, &stl_ops);
+
+	retval = tty_register_driver(stl_serial);
+	if (retval) {
+		printk("STALLION: failed to register serial driver\n");
+		goto err_frtty;
+	}
+
 /*
  *	Find any dynamically supported boards. That is via module load
  *	line options.
@@ -4739,13 +4762,9 @@ static int __init stallion_module_init(void)
 
 	/* this has to be _after_ isa finding because of locking */
 	retval = pci_register_driver(&stl_pcidriver);
-	if (retval && stl_nrbrds == 0)
-		goto err;
-
-	stl_serial = alloc_tty_driver(STL_MAXBRDS * STL_MAXPORTS);
-	if (!stl_serial) {
-		retval = -ENOMEM;
-		goto err_pcidr;
+	if (retval && stl_nrbrds == 0) {
+		printk(KERN_ERR "STALLION: can't register pci driver\n");
+		goto err_unrtty;
 	}
 
 /*
@@ -4756,43 +4775,18 @@ static int __init stallion_module_init(void)
 		printk("STALLION: failed to register serial board device\n");
 
 	stallion_class = class_create(THIS_MODULE, "staliomem");
-	if (IS_ERR(stallion_class)) {
-		retval = PTR_ERR(stallion_class);
-		goto err_reg;
-	}
+	if (IS_ERR(stallion_class))
+		printk("STALLION: failed to create class\n");
 	for (i = 0; i < 4; i++)
 		class_device_create(stallion_class, NULL,
 				    MKDEV(STL_SIOMEMMAJOR, i), NULL,
 				    "staliomem%d", i);
 
-	stl_serial->owner = THIS_MODULE;
-	stl_serial->driver_name = stl_drvname;
-	stl_serial->name = "ttyE";
-	stl_serial->major = STL_SERIALMAJOR;
-	stl_serial->minor_start = 0;
-	stl_serial->type = TTY_DRIVER_TYPE_SERIAL;
-	stl_serial->subtype = SERIAL_TYPE_NORMAL;
-	stl_serial->init_termios = stl_deftermios;
-	stl_serial->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
-	tty_set_operations(stl_serial, &stl_ops);
-
-	retval = tty_register_driver(stl_serial);
-	if (retval) {
-		printk("STALLION: failed to register serial driver\n");
-		goto err_clsdev;
-	}
-
 	return 0;
-err_clsdev:
-	for (i = 0; i < 4; i++)
-		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
-	class_destroy(stallion_class);
-err_reg:
-	unregister_chrdev(STL_SIOMEMMAJOR, "staliomem");
+err_unrtty:
+	tty_unregister_driver(stl_serial);
+err_frtty:
 	put_tty_driver(stl_serial);
-err_pcidr:
-	pci_unregister_driver(&stl_pcidriver);
-	stl_free_isabrds();
 err:
 	return retval;
 }
@@ -4821,8 +4815,6 @@ static void __exit stallion_module_exit(void)
 			tty_unregister_device(stl_serial,
 				brdp->brdnr * STL_MAXPORTS + j);
 	}
-	tty_unregister_driver(stl_serial);
-	put_tty_driver(stl_serial);
 
 	for (i = 0; i < 4; i++)
 		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
@@ -4834,6 +4826,9 @@ static void __exit stallion_module_exit(void)
 	pci_unregister_driver(&stl_pcidriver);
 
 	stl_free_isabrds();
+
+	tty_unregister_driver(stl_serial);
+	put_tty_driver(stl_serial);
 }
 
 module_init(stallion_module_init);
