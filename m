Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZJLHnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZJLHnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZJLHnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:43:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37401 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbZJLHnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:43:18 -0400
Date: Mon, 12 Oct 2009 09:42:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Mike Frysinger <vapier@gentoo.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [origin tree build failure] [PATCH] Revert "USB: musb: make
	HAVE_CLK support optional"
Message-ID: <20091012074221.GA19198@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> As usual, please test this for regressions, both new and old. 

>       USB: musb: make HAVE_CLK support optional

This USB/Blackfin commit broke the x86 build with these config options:

 CONFIG_USB_MUSB_HDRC=y
 CONFIG_USB_MUSB_HOST=y
 # CONFIG_USB_MUSB_PERIPHERAL is not set
 # CONFIG_USB_MUSB_OTG is not set
 # CONFIG_USB_GADGET_MUSB_HDRC is not set
 CONFIG_USB_MUSB_HDRC_HCD=y
 CONFIG_MUSB_PIO_ONLY=y
 CONFIG_USB_MUSB_DEBUG=y

Because a side-effect of the patch was that it enabled the driver on x86 
too which doesnt have HAVE_CLK. So this formerly embedded-only driver 
got exposed on the more widely tested x86 platform.

The changelog does not mention this side-effect so i suspect it was 
unintended - so below is the revert of the commit.

	Ingo

-------------------->
>From 64f59376a1259cbce3da07f7e7d4c9d5830b68e4 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 12 Oct 2009 09:31:32 +0200
Subject: [PATCH] Revert "USB: musb: make HAVE_CLK support optional"

This reverts commit b20cf90650badaa5e6ec1bdbe61a63528818e8ce.

It breaks the x86 build:

  drivers/built-in.o: In function `musb_stop':
  (.text+0x417427): undefined reference to `musb_platform_disable'
  drivers/built-in.o: In function `musb_shutdown':
  musb_core.c:(.text+0x4174c6): undefined reference to `musb_platform_disable'
  drivers/built-in.o: In function `musb_mode_store':
  musb_core.c:(.text+0x417729): undefined reference to `musb_platform_set_mode'
  drivers/built-in.o: In function `musb_free':
  musb_core.c:(.text+0x4177cc): undefined reference to `dma_controller_destroy'
  musb_core.c:(.text+0x4177e0): undefined reference to `musb_platform_exit'
  drivers/built-in.o: In function `musb_start':
  (.text+0x418097): undefined reference to `musb_platform_enable'
  drivers/built-in.o: In function `musb_probe':
  musb_core.c:(.init.text+0x18db5): undefined reference to `musb_platform_init'
  musb_core.c:(.init.text+0x18df3): undefined reference to `dma_controller_create'
  musb_core.c:(.init.text+0x18e21): undefined reference to `musb_platform_disable'
  musb_core.c:(.init.text+0x1970c): undefined reference to `musb_platform_exit'
  make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/usb/musb/Kconfig     |    2 +-
 drivers/usb/musb/blackfin.c  |    1 +
 drivers/usb/musb/musb_core.h |    7 -------
 drivers/usb/musb/musb_regs.h |    9 +++++++++
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 760e727..803adcb 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -8,7 +8,7 @@ comment "Enable Host or Gadget support to see Inventra options"
 
 # (M)HDRC = (Multipoint) Highspeed Dual-Role Controller
 config USB_MUSB_HDRC
-	depends on (USB || USB_GADGET)
+	depends on (USB || USB_GADGET) && HAVE_CLK
 	depends on !SUPERH
 	select NOP_USB_XCEIV if ARCH_DAVINCI
 	select TWL4030_USB if MACH_OMAP_3430SDP
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index fcec87e..f2f66eb 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/clk.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
 
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 6aa5f22..381d648 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -95,13 +95,6 @@ struct musb_ep;
 #endif
 #endif	/* need MUSB gadget selection */
 
-#ifndef CONFIG_HAVE_CLK
-/* Dummy stub for clk framework */
-#define clk_get(dev, id)	NULL
-#define clk_put(clock)		do {} while (0)
-#define clk_enable(clock)	do {} while (0)
-#define clk_disable(clock)	do {} while (0)
-#endif
 
 #ifdef CONFIG_PROC_FS
 #include <linux/fs.h>
diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
index cc1d71b..fbfd3fd 100644
--- a/drivers/usb/musb/musb_regs.h
+++ b/drivers/usb/musb/musb_regs.h
@@ -439,6 +439,15 @@ static inline void  musb_write_txhubport(void __iomem *mbase, u8 epnum,
 /* Not implemented - HW has seperate Tx/Rx FIFO */
 #define MUSB_TXCSR_MODE			0x0000
 
+/*
+ * Dummy stub for clk framework, it will be removed
+ * until Blackfin supports clk framework
+ */
+#define clk_get(dev, id)	NULL
+#define clk_put(clock)		do {} while (0)
+#define clk_enable(clock)	do {} while (0)
+#define clk_disable(clock)	do {} while (0)
+
 static inline void musb_write_txfifosz(void __iomem *mbase, u8 c_size)
 {
 }
