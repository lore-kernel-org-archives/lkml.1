Return-Path: <linux-kernel-owner+w=401wt.eu-S2992562AbXDLP1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992562AbXDLP1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992564AbXDLP1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:27:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:50030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992562AbXDLP1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:27:35 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: akpm@osdl.org
Subject: [PATCH] Add keyboard blink driver
Date: Thu, 12 Apr 2007 17:27:27 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704121727.27892.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a blink driver for debugging

Simple driver that blinks the keyboard LEDs when loaded. Useful
for checking that the kernel is still alive or for crashdumping.
The kdump kernel currently typically doesn't give any feedback
on the screen because it often cannot reinitialize the graphics
state. This patch allows it to at least show blinking lights
like panic.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/misc/Kconfig  |    9 +++++++++
 drivers/misc/Makefile |    1 +
 drivers/misc/blink.c  |   26 ++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

Index: linux/drivers/misc/Kconfig
===================================================================
--- linux.orig/drivers/misc/Kconfig
+++ linux/drivers/misc/Kconfig
@@ -107,4 +107,13 @@ config MSI_LAPTOP
 
 	  If you have an MSI S270 laptop, say Y or M here.
 
+config BLINK
+	tristate "Keyboard blink driver"
+	help
+	  Driver that when loaded will blink the keyboard LEDs continuously.
+	  This is useful for debugging and for kernels that cannot necessarily
+	  output something to the screen like kexec kernels to give the user
+	  a visual indication that the kernel is doing something.
+
+
 endmenu
Index: linux/drivers/misc/Makefile
===================================================================
--- linux.orig/drivers/misc/Makefile
+++ linux/drivers/misc/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_LKDTM)		+= lkdtm.o
 obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
 obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
+obj-$(CONFIG_BLINK)		+= blink.o
Index: linux/drivers/misc/blink.c
===================================================================
--- /dev/null
+++ linux/drivers/misc/blink.c
@@ -0,0 +1,26 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+
+static void do_blink(unsigned long data);
+
+static DEFINE_TIMER(blink_timer, do_blink, 0 ,0);
+
+static void do_blink(unsigned long data)
+{
+	static long count;
+	panic_blink(count++);
+	blink_timer.expires = jiffies + msecs_to_jiffies(1);
+	add_timer(&blink_timer);
+}
+
+static int blink_init(void)
+{
+	printk(KERN_INFO "Enabling keyboard blinking\n");
+	do_blink(0);
+	return 0;
+}
+
+module_init(blink_init);
+
