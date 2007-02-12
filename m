Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXBLDyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXBLDyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932962AbXBLDyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:54:14 -0500
Received: from ozlabs.org ([203.10.76.45]:51111 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961AbXBLDyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:54:12 -0500
Subject: [PATCH 6/8] lguest: trivial guest console driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <1171252321.10409.36.camel@localhost.localdomain>
References: <1171251120.10409.2.camel@localhost.localdomain>
	 <1171251185.10409.4.camel@localhost.localdomain>
	 <1171251258.10409.7.camel@localhost.localdomain>
	 <1171251335.10409.10.camel@localhost.localdomain>
	 <1171251406.10409.13.camel@localhost.localdomain>
	 <1171251471.10409.15.camel@localhost.localdomain>
	 <1171251578.10409.17.camel@localhost.localdomain>
	 <1171251698.10409.20.camel@localhost.localdomain>
	 <1171251770.10409.23.camel@localhost.localdomain>
	 <1171251894.10409.26.camel@localhost.localdomain>
	 <1171251965.10409.28.camel@localhost.localdomain>
	 <1171252113.10409.30.camel@localhost.localdomain>
	 <1171252219.10409.33.camel@localhost.localdomain>
	 <1171252321.10409.36.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:53:25 +1100
Message-Id: <1171252405.10409.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A trivial driver to have a basic lguest console, using the hvc_console
infrastructure.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r aaa62bd9788a drivers/char/Makefile
--- a/drivers/char/Makefile	Mon Feb 12 13:01:16 2007 +1100
+++ b/drivers/char/Makefile	Mon Feb 12 13:01:45 2007 +1100
@@ -44,6 +44,7 @@ obj-$(CONFIG_SX)		+= sx.o generic_serial
 obj-$(CONFIG_SX)		+= sx.o generic_serial.o
 obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
 obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
+obj-$(CONFIG_LGUEST_GUEST)	+= hvc_lguest.o
 obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
 obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
 obj-$(CONFIG_HVC_DRIVER)	+= hvc_console.o
diff -r aaa62bd9788a drivers/char/hvc_lguest.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/char/hvc_lguest.c	Mon Feb 12 13:01:19 2007 +1100
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
+#include <asm/lguest_device.h>
+#include "hvc_console.h"
+
+static int cons_irq;
+static int cons_offset;
+static char inbuf[256];
+static struct lguest_dma cons_input = { .used_len = 0,
+					.addr[0] = __pa(inbuf),
+					.len[0] = sizeof(inbuf),
+					.len[1] = 0 };
+
+static int get_chars(u32 vtermno, char *buf, int count)
+{
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
+static int put_chars(u32 vtermno, const char *buf, int count)
+{
+	struct lguest_dma dma;
+
+	/* FIXME: what if it's over a page boundary? */
+	dma.len[0] = count;
+	dma.len[1] = 0;
+	dma.addr[0] = __pa(buf);
+
+	hcall(LHCALL_SEND_DMA, 4, __pa(&dma), 0);
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
+static int lguestcons_probe(struct lguest_device *lhdev)
+{
+	cons_irq = lhdev->index+1;
+	lhdev->private = hvc_alloc(0, cons_irq, &lguest_cons, 256);
+	if (IS_ERR(lhdev->private))
+		return PTR_ERR(lhdev->private);
+
+	if (!hcall(LHCALL_BIND_DMA, 0, __pa(&cons_input), (1<<8)+cons_irq))
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


