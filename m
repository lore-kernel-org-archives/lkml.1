Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbXJOQ3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbXJOQ3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbXJOQ3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:29:10 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:58382 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451AbXJOQ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:29:09 -0400
Message-id: <25409162611123630013@pripojeni.net>
Subject: [PATCH 1/5] Char: rocket, fix dynamic_dev tty
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 15 Oct 2007 12:29:09 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rocket, fix dynamic_dev tty

- register_device unconditionally (non-pci dependent) to have also isa
  devices in /dev
- unregister devices on module removal
- don't set TTY_DRIVER_DYNAMIC_DEV twice (removed the one dependent on some
  macro)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ferenc Wagner <wferi@niif.hu>

---
commit afb1b8bbdc2cc13a8c2c7d9fff49a3098a370971
tree 49f12cbadea0b74968a7626301028fb0ccb31209
parent 4b741d759e5b898bf1bf19631d5e5b14a221ce52
author Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 13:32:44 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 13:32:44 +0200

 drivers/char/rocket.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 56cbba7..94bb3d0 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -699,8 +699,8 @@ static void init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
 	spin_lock_init(&info->slock);
 	mutex_init(&info->write_mtx);
 	rp_table[line] = info;
-	if (pci_dev)
-		tty_register_device(rocket_driver, line, &pci_dev->dev);
+	tty_register_device(rocket_driver, line, pci_dev ? &pci_dev->dev :
+			NULL);
 }
 
 /*
@@ -2434,7 +2434,7 @@ static int __init rp_init(void)
 	rocket_driver->init_termios.c_ispeed = 9600;
 	rocket_driver->init_termios.c_ospeed = 9600;
 #ifdef ROCKET_SOFT_FLOW
-	rocket_driver->flags |= TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	rocket_driver->flags |= TTY_DRIVER_REAL_RAW;
 #endif
 	tty_set_operations(rocket_driver, &rocket_ops);
 
@@ -2491,10 +2491,14 @@ static void rp_cleanup_module(void)
 	if (retval)
 		printk(KERN_INFO "Error %d while trying to unregister "
 		       "rocketport driver\n", -retval);
-	put_tty_driver(rocket_driver);
 
 	for (i = 0; i < MAX_RP_PORTS; i++)
-		kfree(rp_table[i]);
+		if (rp_table[i]) {
+			tty_unregister_device(rocket_driver, i);
+			kfree(rp_table[i]);
+		}
+
+	put_tty_driver(rocket_driver);
 
 	for (i = 0; i < NUM_BOARDS; i++) {
 		if (rcktpt_io_addr[i] <= 0 || is_PCI[i])
