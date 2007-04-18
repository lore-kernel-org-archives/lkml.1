Return-Path: <linux-kernel-owner+w=401wt.eu-S1422778AbXDRKHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422778AbXDRKHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422791AbXDRKHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:07:01 -0400
Received: from mx0.karneval.cz ([81.27.192.15]:64411 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422778AbXDRKG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:06:59 -0400
Message-id: <3022717953242262423@karneval.cz>
In-reply-to: <2428225437641930190@karneval.cz>
Subject: [PATCH 8/11] Char: cyclades, cy_init error handling
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2007 12:06:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, cy_init error handling

- do not panic if tty_register_driver fails
- handle fail paths properly

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 8c76c370ee1c1efa31f64807162c15922fae1e3a
tree 19fe12eba568aece1d0b406a4d735f393f2cd3dd
parent b1b13ea51dcaef72c5298a04d233b92206adf978
author Jiri Slaby <jirislaby@gmail.com> Mon, 02 Apr 2007 15:47:49 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 10 Apr 2007 10:48:06 +0200

 drivers/char/cyclades.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 1baf7d7..22f8ec4 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -5460,10 +5460,11 @@ static const struct tty_operations cy_ops = {
 static int __init cy_init(void)
 {
 	unsigned int i, nboards;
+	int retval = -ENOMEM;
 
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!cy_serial_driver)
-		return -ENOMEM;
+		goto err;
 	show_version();
 
 	/* Initialize the tty_driver structure */
@@ -5481,8 +5482,11 @@ static int __init cy_init(void)
 	cy_serial_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(cy_serial_driver, &cy_ops);
 
-	if (tty_register_driver(cy_serial_driver))
-		panic("Couldn't register Cyclades serial driver\n");
+	retval = tty_register_driver(cy_serial_driver);
+	if (retval) {
+		printk(KERN_ERR "Couldn't register Cyclades serial driver\n");
+		goto err_frtty;
+	}
 
 	for (i = 0; i < NR_CARDS; i++) {
 		/* base_addr=0 indicates board not found */
@@ -5508,7 +5512,18 @@ static int __init cy_init(void)
 	/* look for pci boards */
 	nboards += cy_detect_pci();
 
-	return nboards ? 0 : -ENODEV;
+	if (nboards == 0) {
+		retval = -ENODEV;
+		goto err_unr;
+	}
+
+	return 0;
+err_unr:
+	tty_unregister_driver(cy_serial_driver);
+err_frtty:
+	put_tty_driver(cy_serial_driver);
+err:
+	return retval;
 }				/* cy_init */
 
 static void __exit cy_cleanup_module(void)
