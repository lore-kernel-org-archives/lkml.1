Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbZIQBKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbZIQBKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 21:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZIQBKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 21:10:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:50667 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbZIQBKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 21:10:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] USB: musb: make HAVE_CLK support optional
Date: Wed, 16 Sep 2009 21:10:53 -0400
Message-Id: <1253149853-11395-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin port doesn't support HAVE_CLK and the musb driver works fine
with support stubbed out, so take the existing Blackfin clk stubs and move
them to common musb code so we can drop the Kconfig dependency.

Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/Kconfig     |    2 +-
 drivers/usb/musb/blackfin.c  |    1 -
 drivers/usb/musb/musb_core.h |    7 +++++++
 drivers/usb/musb/musb_regs.h |    9 ---------
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 06135a1..24d4e60 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -8,7 +8,7 @@ comment "Enable Host or Gadget support to see Inventra options"
 
 # (M)HDRC = (Multipoint) Highspeed Dual-Role Controller
 config USB_MUSB_HDRC
-	depends on (USB || USB_GADGET) && HAVE_CLK
+	depends on (USB || USB_GADGET)
 	depends on !SUPERH
 	depends on !BLACKFIN || (BF54x && !BF544) || (BF52x && !BF522 && !BF523)
 	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index db099e2..fe4934d 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/list.h>
-#include <linux/clk.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
 
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 381d648..6aa5f22 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -95,6 +95,13 @@ struct musb_ep;
 #endif
 #endif	/* need MUSB gadget selection */
 
+#ifndef CONFIG_HAVE_CLK
+/* Dummy stub for clk framework */
+#define clk_get(dev, id)	NULL
+#define clk_put(clock)		do {} while (0)
+#define clk_enable(clock)	do {} while (0)
+#define clk_disable(clock)	do {} while (0)
+#endif
 
 #ifdef CONFIG_PROC_FS
 #include <linux/fs.h>
diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
index 0154e38..473a94e 100644
--- a/drivers/usb/musb/musb_regs.h
+++ b/drivers/usb/musb/musb_regs.h
@@ -439,15 +439,6 @@ static inline void  musb_write_txhubport(void __iomem *mbase, u8 epnum,
 /* Not implemented - HW has seperate Tx/Rx FIFO */
 #define MUSB_TXCSR_MODE			0x0000
 
-/*
- * Dummy stub for clk framework, it will be removed
- * until Blackfin supports clk framework
- */
-#define clk_get(dev, id)	NULL
-#define clk_put(clock)		do {} while (0)
-#define clk_enable(clock)	do {} while (0)
-#define clk_disable(clock)	do {} while (0)
-
 static inline void musb_write_txfifosz(void __iomem *mbase, u8 c_size)
 {
 }
-- 
1.6.5.rc1

