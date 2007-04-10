Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbXDJLJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbXDJLJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXDJLJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:09:19 -0400
Received: from ozlabs.org ([203.10.76.45]:56271 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbXDJLJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:09:18 -0400
Subject: [PATCH 5/8] lguest: the console driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <1176203285.26372.29.camel@localhost.localdomain>
References: <1176203068.26372.21.camel@localhost.localdomain>
	 <1176203130.26372.23.camel@localhost.localdomain>
	 <1176203176.26372.25.camel@localhost.localdomain>
	 <1176203231.26372.27.camel@localhost.localdomain>
	 <1176203285.26372.29.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 21:08:53 +1000
Message-Id: <1176203333.26372.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A simple console driver for lguest.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/Makefile     |    1 
 drivers/char/hvc_lguest.c |   99 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

===================================================================
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_SX)		+= sx.o generic_serial
 obj-$(CONFIG_SX)		+= sx.o generic_serial.o
 obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
 obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
+obj-$(CONFIG_LGUEST_GUEST)	+= hvc_lguest.o
 obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
 obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
 obj-$(CONFIG_HVC_BEAT)		+= hvc_beat.o
===================================================================
--- /dev/null
+++ b/drivers/char/hvc_lguest.c
@@ -0,0 +1,99 @@
+/* Simple console for lguest.
+ *
+ * Copyright (C) 2006 Rusty Russell, IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/lguest_bus.h>
+#include "hvc_console.h"
+
+static char inbuf[256];
+static struct lguest_dma cons_input = { .used_len = 0,
+					.addr[0] = __pa(inbuf),
+					.len[0] = sizeof(inbuf),
+					.len[1] = 0 };
+
+static int put_chars(u32 vtermno, const char *buf, int count)
+{
+	struct lguest_dma dma;
+
+	/* FIXME: what if it's over a page boundary? */
+	dma.len[0] = count;
+	dma.len[1] = 0;
+	dma.addr[0] = __pa(buf);
+
+	hcall(LHCALL_SEND_DMA, LGUEST_CONSOLE_DMA_KEY, __pa(&dma), 0);
+	return count;
+}
+
+static int get_chars(u32 vtermno, char *buf, int count)
+{
+	static int cons_offset;
+
+	if (!cons_input.used_len)
+		return 0;
+
+	if (cons_input.used_len - cons_offset < count)
+		count = cons_input.used_len - cons_offset;
+
+	memcpy(buf, inbuf + cons_offset, count);
+	cons_offset += count;
+	if (cons_offset == cons_input.used_len) {
+		cons_offset = 0;
+		cons_input.used_len = 0;
+	}
+	return count;
+}
+
+struct hv_ops lguest_cons = {
+	.get_chars = get_chars,
+	.put_chars = put_chars,
+};
+
+static int __init cons_init(void)
+{
+	if (strcmp(paravirt_ops.name, "lguest") != 0)
+		return 0;
+
+	return hvc_instantiate(0, 0, &lguest_cons);
+}
+console_initcall(cons_init);
+
+static int lguestcons_probe(struct lguest_device *lgdev)
+{
+	lgdev->private = hvc_alloc(0, lgdev->index+1, &lguest_cons, 256);
+	if (IS_ERR(lgdev->private))
+		return PTR_ERR(lgdev->private);
+
+	if (!hcall(LHCALL_BIND_DMA, LGUEST_CONSOLE_DMA_KEY, __pa(&cons_input),
+		   (1<<8) + lgdev->index+1))
+		printk("lguest console: failed to bind buffer.\n");
+	return 0;
+}
+
+static struct lguest_driver lguestcons_drv = {
+	.name = "lguestcons",
+	.owner = THIS_MODULE,
+	.device_type = LGUEST_DEVICE_T_CONSOLE,
+	.probe = lguestcons_probe,
+};
+
+static int __init hvc_lguest_init(void)
+{
+	return register_lguest_driver(&lguestcons_drv);
+}
+module_init(hvc_lguest_init);


