Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbYJVUxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbYJVUxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbYJVUx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:53:29 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:38063 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYJVUx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:53:28 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Rodolfo Giometti <giometti@linux.it>
Date: Wed, 22 Oct 2008 22:53:21 +0200
Message-Id: <1224708801-16675-3-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1224708801-16675-2-git-send-email-giometti@linux.it>
References: <>
 <1224708801-16675-1-git-send-email-giometti@linux.it>
 <1224708801-16675-2-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 2/2] c2port: add c2port support for Eurotech Duramar 2150.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/misc/c2port/Kconfig              |   11 ++
 drivers/misc/c2port/Makefile             |    2 +
 drivers/misc/c2port/c2port-duramar2150.c |  158 ++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/c2port/c2port-duramar2150.c

diff --git a/drivers/misc/c2port/Kconfig b/drivers/misc/c2port/Kconfig
index f1bad2b..e46af9a 100644
--- a/drivers/misc/c2port/Kconfig
+++ b/drivers/misc/c2port/Kconfig
@@ -21,4 +21,15 @@ menuconfig C2PORT
 
 if C2PORT
 
+config C2PORT_DURAMAR_2150
+	tristate "C2 port support for Eurotech's Duramar 2150 (EXPERIMENTAL)"
+	depends on X86 && C2PORT
+	default no
+	help
+	  This option enables C2 support for the Eurotech's Duramar 2150
+	  on board micro controller.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called c2port-duramar2150.
+
 endif # C2PORT
diff --git a/drivers/misc/c2port/Makefile b/drivers/misc/c2port/Makefile
index 3c610a2..3b2cf43 100644
--- a/drivers/misc/c2port/Makefile
+++ b/drivers/misc/c2port/Makefile
@@ -1 +1,3 @@
 obj-$(CONFIG_C2PORT)		+= core.o
+
+obj-$(CONFIG_C2PORT_DURAMAR_2150)	+= c2port-duramar2150.o
diff --git a/drivers/misc/c2port/c2port-duramar2150.c b/drivers/misc/c2port/c2port-duramar2150.c
new file mode 100644
index 0000000..338dcc1
--- /dev/null
+++ b/drivers/misc/c2port/c2port-duramar2150.c
@@ -0,0 +1,158 @@
+/*
+ *  Silicon Labs C2 port Linux support for Eurotech Duramar 2150
+ *
+ *  Copyright (c) 2008 Rodolfo Giometti <giometti@linux.it>
+ *  Copyright (c) 2008 Eurotech S.p.A. <info@eurotech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation
+ */
+
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/c2port.h>
+
+#define DATA_PORT	0x325
+#define DIR_PORT	0x326
+#define    C2D		   (1 << 0)
+#define    C2CK		   (1 << 1)
+
+static DEFINE_MUTEX(update_lock);
+
+/*
+ * C2 port operations
+ */
+
+static void duramar2150_c2port_access(struct c2port_device *dev, int status)
+{
+	u8 v;
+
+	mutex_lock(&update_lock);
+
+	v = inb(DIR_PORT);
+
+	/* 0 = input, 1 = output */
+	if (status)
+		outb(v | (C2D | C2CK), DIR_PORT);
+	else
+		/* When access is "off" is important that both lines are set
+		 * as inputs or hi-impedence */
+		outb(v & ~(C2D | C2CK), DIR_PORT);
+
+	mutex_unlock(&update_lock);
+}
+
+static void duramar2150_c2port_c2d_dir(struct c2port_device *dev, int dir)
+{
+	u8 v;
+
+	mutex_lock(&update_lock);
+
+	v = inb(DIR_PORT);
+
+	if (dir)
+		outb(v & ~C2D, DIR_PORT);
+	else
+		outb(v | C2D, DIR_PORT);
+
+	mutex_unlock(&update_lock);
+}
+
+static int duramar2150_c2port_c2d_get(struct c2port_device *dev)
+{
+	return inb(DATA_PORT) & C2D;
+}
+
+static void duramar2150_c2port_c2d_set(struct c2port_device *dev, int status)
+{
+	u8 v;
+
+	mutex_lock(&update_lock);
+
+	v = inb(DATA_PORT);
+
+	if (status)
+		outb(v | C2D, DATA_PORT);
+	else
+		outb(v & ~C2D, DATA_PORT);
+
+	mutex_unlock(&update_lock);
+}
+
+static void duramar2150_c2port_c2ck_set(struct c2port_device *dev, int status)
+{
+	u8 v;
+
+	mutex_lock(&update_lock);
+
+	v = inb(DATA_PORT);
+
+	if (status)
+		outb(v | C2CK, DATA_PORT);
+	else
+		outb(v & ~C2CK, DATA_PORT);
+
+	mutex_unlock(&update_lock);
+}
+
+static struct c2port_ops duramar2150_c2port_ops = {
+	.block_size	= 512,	/* bytes */
+	.blocks_num	= 30,	/* total flash size: 15360 bytes */
+
+	.access		= duramar2150_c2port_access,
+	.c2d_dir	= duramar2150_c2port_c2d_dir,
+	.c2d_get	= duramar2150_c2port_c2d_get,
+	.c2d_set	= duramar2150_c2port_c2d_set,
+	.c2ck_set	= duramar2150_c2port_c2ck_set,
+};
+
+static struct c2port_device *duramar2150_c2port_dev;
+
+/*
+ * Module stuff
+ */
+
+static int __init duramar2150_c2port_init(void)
+{
+	struct resource *res;
+	int ret = 0;
+
+	res = request_region(0x325, 2, "c2port");
+	if (!res)
+		return -EBUSY;
+
+	duramar2150_c2port_dev = c2port_device_register("uc",
+					&duramar2150_c2port_ops, NULL);
+	if (!duramar2150_c2port_dev) {
+		ret = -ENODEV;
+		goto free_region;
+	}
+
+	return 0;
+
+free_region:
+	release_region(0x325, 2);
+	return ret;
+}
+
+static void __exit duramar2150_c2port_exit(void)
+{
+	/* Setup the GPIOs as input by default (access = 0) */
+	duramar2150_c2port_access(duramar2150_c2port_dev, 0);
+
+	c2port_device_unregister(duramar2150_c2port_dev);
+
+	release_region(0x325, 2);
+}
+
+module_init(duramar2150_c2port_init);
+module_exit(duramar2150_c2port_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("Silicon Labs C2 port Linux support for Duramar 2150");
+MODULE_LICENSE("GPL");
-- 
1.5.4.3

