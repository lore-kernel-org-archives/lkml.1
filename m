Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0CBXh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:37:57 -0500
Received: from kroah.org ([198.145.64.141]:51663 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803Ab0CBXhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Breno Leitao <leitao@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/36] jsm: fixing error if the driver fails to load
Date: Tue,  2 Mar 2010 15:36:43 -0800
Message-Id: <1267573003-782-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitao <leitao@linux.vnet.ibm.com>

Currently if the driver fails to register on port, the kernel
crashes with the following stack:

cpu 0x1: Vector: 300 (Data Access) at [c0000000e0303090]
    pc: c00000000039aa74: .__mutex_lock_slowpath+0x44/0x10c
    lr: c00000000039aa58: .__mutex_lock_slowpath+0x28/0x10c
[c0000000e03033c0] c00000000026b074 .uart_remove_one_port+0xbc/0x16c
[c0000000e0303460] d0000000000e0554 .jsm_remove_uart_port+0x8c/0x10c [jsm]
[c0000000e03034f0] d0000000000dc034 .jsm_remove_one+0x34/0x108 [jsm]
[c0000000e0303590] c0000000001f4aa0 .pci_device_remove+0x48/0x74
...

This patch just fixes the code flow to abort the load when an
error is detected.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/jsm/jsm_tty.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index cd95e21..5673ca9 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -432,7 +432,7 @@ int __devinit jsm_tty_init(struct jsm_board *brd)
 
 int jsm_uart_port_init(struct jsm_board *brd)
 {
-	int i;
+	int i, rc;
 	unsigned int line;
 	struct jsm_channel *ch;
 
@@ -467,8 +467,11 @@ int jsm_uart_port_init(struct jsm_board *brd)
 		} else
 			set_bit(line, linemap);
 		brd->channels[i]->uart_port.line = line;
-		if (uart_add_one_port (&jsm_uart_driver, &brd->channels[i]->uart_port))
-			printk(KERN_INFO "jsm: add device failed\n");
+		rc = uart_add_one_port (&jsm_uart_driver, &brd->channels[i]->uart_port);
+		if (rc){
+			printk(KERN_INFO "jsm: Port %d failed. Aborting...\n", i);
+			return rc;
+		}
 		else
 			printk(KERN_INFO "jsm: Port %d added\n", i);
 	}
-- 
1.7.0.1

