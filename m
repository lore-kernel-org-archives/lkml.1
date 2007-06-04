Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbXFDIo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbXFDIo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 04:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXFDIoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 04:44:20 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:43506 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751634AbXFDIoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 04:44:19 -0400
Message-id: <21118142571565213847@wsc.cz>
From: Jiri Slaby <jirislaby@gmail.com>
To: "Ingo Korb" <ingo@akana.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: stallion driver dmesg notice
In-reply-to: <466362EA.6369.44946011@ingo.akana.de>
References: <46633BC8.3838.43FB8257@ml.akana.de>, <304615082222625376@wsc.cz> <304615082222625376@wsc.cz>
Date: Mon,  4 Jun 2007 10:44:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Korb wrote:
> > > Should I test it with an EC8/64-PCI? The /32 (ab)uses an IDE controller 
> > > chip as PCI interface, the /64 uses a PLX PCI9050.
> > 
> > I don't undestand this. IDE grabs the device? This is possible and if yes,
> > I'll fix the IDE driver.
> 
> Yes, IDE (specifically: generic IDE PCI support, generic.ko - not 
> compiled into my kernel) can grab the device. It's using an IDE 
> controller chip that reports itself as such, so that's not completely 
> unreasonable.

Good, thanks for the info.

> > Could you please try the patch below?
> 
> Oopsed:
> 
> === Cut ===
> Unloading Stallion Multiport Serial Driver: version 5.6.0
> Stallion Multiport Serial Driver: version 5.6.0
> stallion 0000:00:0b.0: please, report this to LKML: 100b/d001/ffffff
> STALLION: EC8/32-PCI found, board=0 io=d200 irq=17 nrpanels=1 nrports=8
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 00000074

Okay, tty alloc after pci init, attached patch should fix it. Could you
retest?

> > stallion, don't fail with less than max panels
> 
> I could try with more than one panel if neccecary - I think I have four 8-
> Port-Panels, one 8-Port-XP-Panel (different UART) and one 16-Port-Panel 
> stored somewhere.

Doesn't matter, needs fix anyway.

--

stallion, alloc tty before pci devices init

this causes oops, because pci prboe function calls tty_register_device for
each device found.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit f6d5d1877b0f7ac82f5e1fec2ead0429eeb069c8
tree 31beaaee84ef718acc5401b3cb07a7f2e340f0fe
parent a6c3fb453e98ba32291a4fc5a7d843fb27359182
author Jiri Slaby <jirislaby@gmail.com> Mon, 04 Jun 2007 10:39:41 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 04 Jun 2007 10:39:41 +0200

 drivers/char/stallion.c |   73 ++++++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 9820f49..45bf2a2 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -4714,6 +4714,29 @@ static int __init stallion_module_init(void)
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
@@ -4743,13 +4766,9 @@ static int __init stallion_module_init(void)
 
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
@@ -4760,43 +4779,18 @@ static int __init stallion_module_init(void)
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
@@ -4825,8 +4819,6 @@ static void __exit stallion_module_exit(void)
 			tty_unregister_device(stl_serial,
 				brdp->brdnr * STL_MAXPORTS + j);
 	}
-	tty_unregister_driver(stl_serial);
-	put_tty_driver(stl_serial);
 
 	for (i = 0; i < 4; i++)
 		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
@@ -4838,6 +4830,9 @@ static void __exit stallion_module_exit(void)
 	pci_unregister_driver(&stl_pcidriver);
 
 	stl_free_isabrds();
+
+	tty_unregister_driver(stl_serial);
+	put_tty_driver(stl_serial);
 }
 
 module_init(stallion_module_init);
