Return-Path: <linux-kernel-owner+w=401wt.eu-S1765304AbXJOQbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765304AbXJOQbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761777AbXJOQbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:31:11 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:58398 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760719AbXJOQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:31:09 -0400
Message-id: <147808606859926968@pripojeni.net>
In-reply-to: <25409162611123630013@pripojeni.net>
Subject: [PATCH 4/5] Char: rocket, remove potential leak in module_init
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 15 Oct 2007 12:31:09 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rocket, remove potential leak in module_init

if (controller && !request_region) then we leaked a tty driver struct,
fix it by adding function deinit tail with goto-ing into it (and from other
fail paths too)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 8aa70f167a6ae0f80af0d73a5365c81f2e146709
tree 3f44eb6baabbf501738c857b6114010ac408108e
parent 2b2c0385d705ce1f4207595f8fda12c25ee39de3
author Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:13:01 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:13:01 +0200

 drivers/char/rocket.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index e4bcfa2..27bb0cd 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -2355,14 +2355,14 @@ static const struct tty_operations rocket_ops = {
  */
 static int __init rp_init(void)
 {
-	int retval, pci_boards_found, isa_boards_found, i;
+	int ret = -ENOMEM, pci_boards_found, isa_boards_found, i;
 
 	printk(KERN_INFO "RocketPort device driver module, version %s, %s\n",
 	       ROCKET_VERSION, ROCKET_DATE);
 
 	rocket_driver = alloc_tty_driver(MAX_RP_PORTS);
 	if (!rocket_driver)
-		return -ENOMEM;
+		goto err;
 
 	/*
 	 *  If board 1 is non-zero, there is at least one ISA configured.  If controller is 
@@ -2377,8 +2377,11 @@ static int __init rp_init(void)
 
 	/*  If an ISA card is configured, reserve the 4 byte IO space for the Mudbac controller */
 	if (controller && (!request_region(controller, 4, "Comtrol RocketPort"))) {
-		printk(KERN_INFO "Unable to reserve IO region for first configured ISA RocketPort controller 0x%lx.  Driver exiting \n", controller);
-		return -EBUSY;
+		printk(KERN_ERR "Unable to reserve IO region for first "
+			"configured ISA RocketPort controller 0x%lx.  "
+			"Driver exiting\n", controller);
+		ret = -EBUSY;
+		goto err_tty;
 	}
 
 	/*  Store ISA variable retrieved from command line or .conf file. */
@@ -2419,11 +2422,10 @@ static int __init rp_init(void)
 #endif
 	tty_set_operations(rocket_driver, &rocket_ops);
 
-	retval = tty_register_driver(rocket_driver);
-	if (retval < 0) {
-		printk(KERN_INFO "Couldn't install tty RocketPort driver (error %d)\n", -retval);
-		put_tty_driver(rocket_driver);
-		return -1;
+	ret = tty_register_driver(rocket_driver);
+	if (ret < 0) {
+		printk(KERN_ERR "Couldn't install tty RocketPort driver\n");
+		goto err_tty;
 	}
 
 #ifdef ROCKET_DEBUG_OPEN
@@ -2450,14 +2452,18 @@ static int __init rp_init(void)
 	max_board = pci_boards_found + isa_boards_found;
 
 	if (max_board == 0) {
-		printk(KERN_INFO "No rocketport ports found; unloading driver.\n");
-		del_timer_sync(&rocket_timer);
-		tty_unregister_driver(rocket_driver);
-		put_tty_driver(rocket_driver);
-		return -ENXIO;
+		printk(KERN_ERR "No rocketport ports found; unloading driver\n");
+		ret = -ENXIO;
+		goto err_ttyu;
 	}
 
 	return 0;
+err_ttyu:
+	tty_unregister_driver(rocket_driver);
+err_tty:
+	put_tty_driver(rocket_driver);
+err:
+	return ret;
 }
 
 
