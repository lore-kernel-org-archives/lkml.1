Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZFXLiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZFXLiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbZFXLge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:34 -0400
Received: from smtp.nokia.com ([192.100.105.134]:58170 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbZFXLgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:32 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 16/20] omapfb: dispc: Allow multiple external IRQ handlers
Date: Wed, 24 Jun 2009 14:33:41 +0300
Message-Id: <a9da40529f3dc3d0bf304c4d15cb45f1af8ae150.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <b11909c54018be72619164782fcf3d6743d0fddd.1245842329.git.imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
 <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
 <f2b49525146391a3d01b944bf4ebce045cb503d4.1245842329.git.imre.deak@nokia.com>
 <9cecdc5077b72042551eb8e3dc96911e9f4fa3fd.1245842329.git.imre.deak@nokia.com>
 <a3b6ef17cc694c350bc3a585a1697cf57cb0b1c1.1245842329.git.imre.deak@nokia.com>
 <0e2b7b0555c657a8eab00df0091b9828fb292f4c.1245842329.git.imre.deak@nokia.com>
 <af3d1e0dff22f0bb72f6ccee57dfa9a1e5f31abb.1245842329.git.imre.deak@nokia.com>
 <6881ca5b34fcf36c3f39b13de85857dcc20f568d.1245842329.git.imre.deak@nokia.com>
 <726d4af0547b42ec8a9af7c6f0079cf9b7fadf5c.1245842329.git.imre.deak@nokia.com>
 <742d96c9c8d6826eddd49a913b6adaa8f176edbe.1245842329.git.imre.deak@nokia.com>
 <279625bb9ea911185e017cdf8d18a46f263fbb5c.1245842329.git.imre.deak@nokia.com>
 <db880b91c36cbd5672f503e249d44411448533bd.1245842329.git.imre.deak@nokia.com>
 <1ad64c0995ee88d15ebce74dec4d1da9746367f0.1245842329.git.imre.deak@nokia.com>
 <cba1956a016f911d20cce07f38a33ebbf6c6186e.1245842329.git.imre.deak@nokia.com>
 <b11909c54018be72619164782fcf3d6743d0fddd.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:36:18.0543 (UTC) FILETIME=[FD7B7FF0:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stone <daniel.stone@nokia.com>

Previously, the only external (to dispc.c) IRQ handler was RFBI's
frame done handler.  dispc's IRQ framework was very dumb: you could only
have one handler, and the semantics of {request,free}_irq were odd, to
say the least.

The new framework allows multiple consumers to register arbitrary IRQ
masks.

Signed-off-by: Daniel Stone <daniel.stone@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 drivers/video/omap/dispc.c |   95 +++++++++++++++++++++++++++-----------------
 drivers/video/omap/dispc.h |    7 ++-
 drivers/video/omap/rfbi.c  |    7 ++-
 3 files changed, 67 insertions(+), 42 deletions(-)

diff --git a/drivers/video/omap/dispc.c b/drivers/video/omap/dispc.c
index 9adf54e..350b444 100644
--- a/drivers/video/omap/dispc.c
+++ b/drivers/video/omap/dispc.c
@@ -155,6 +155,8 @@ struct resmap {
 	unsigned long	*map;
 };
 
+#define MAX_IRQ_HANDLERS            4
+
 static struct {
 	void __iomem	*base;
 
@@ -167,9 +169,11 @@ static struct {
 
 	int		ext_mode;
 
-	unsigned long	enabled_irqs;
-	void		(*irq_callback)(void *);
-	void		*irq_callback_data;
+	struct {
+		u32	irq_mask;
+		void	(*callback)(void *);
+		void	*data;
+	} irq_handlers[MAX_IRQ_HANDLERS];
 	struct completion	frame_done;
 
 	int		fir_hinc[OMAPFB_PLANE_NUM];
@@ -809,56 +813,70 @@ static void set_lcd_timings(void)
 	panel->pixel_clock = fck / lck_div / pck_div / 1000;
 }
 
-int omap_dispc_request_irq(void (*callback)(void *data), void *data)
+static void recalc_irq_mask(void)
 {
-	int r = 0;
+	int i;
+	unsigned long irq_mask = DISPC_IRQ_MASK_ERROR;
 
-	BUG_ON(callback == NULL);
+	for (i = 0; i < MAX_IRQ_HANDLERS; i++) {
+		if (!dispc.irq_handlers[i].callback)
+			continue;
 
-	if (dispc.irq_callback)
-		r = -EBUSY;
-	else {
-		dispc.irq_callback = callback;
-		dispc.irq_callback_data = data;
+		irq_mask |= dispc.irq_handlers[i].irq_mask;
 	}
 
-	return r;
-}
-EXPORT_SYMBOL(omap_dispc_request_irq);
-
-void omap_dispc_enable_irqs(int irq_mask)
-{
 	enable_lcd_clocks(1);
-	dispc.enabled_irqs = irq_mask;
-	irq_mask |= DISPC_IRQ_MASK_ERROR;
 	MOD_REG_FLD(DISPC_IRQENABLE, 0x7fff, irq_mask);
 	enable_lcd_clocks(0);
 }
-EXPORT_SYMBOL(omap_dispc_enable_irqs);
 
-void omap_dispc_disable_irqs(int irq_mask)
+int omap_dispc_request_irq(unsigned long irq_mask, void (*callback)(void *data),
+			   void *data)
 {
-	enable_lcd_clocks(1);
-	dispc.enabled_irqs &= ~irq_mask;
-	irq_mask &= ~DISPC_IRQ_MASK_ERROR;
-	MOD_REG_FLD(DISPC_IRQENABLE, 0x7fff, irq_mask);
-	enable_lcd_clocks(0);
+	int i;
+
+	BUG_ON(callback == NULL);
+
+	for (i = 0; i < MAX_IRQ_HANDLERS; i++) {
+		if (dispc.irq_handlers[i].callback)
+			continue;
+
+		dispc.irq_handlers[i].irq_mask = irq_mask;
+		dispc.irq_handlers[i].callback = callback;
+		dispc.irq_handlers[i].data = data;
+		recalc_irq_mask();
+
+		return 0;
+	}
+
+	return -EBUSY;
 }
-EXPORT_SYMBOL(omap_dispc_disable_irqs);
+EXPORT_SYMBOL(omap_dispc_request_irq);
 
-void omap_dispc_free_irq(void)
+void omap_dispc_free_irq(unsigned long irq_mask, void (*callback)(void *data),
+			 void *data)
 {
-	enable_lcd_clocks(1);
-	omap_dispc_disable_irqs(DISPC_IRQ_MASK_ALL);
-	dispc.irq_callback = NULL;
-	dispc.irq_callback_data = NULL;
-	enable_lcd_clocks(0);
+	int i;
+
+	for (i = 0; i < MAX_IRQ_HANDLERS; i++) {
+		if (dispc.irq_handlers[i].callback == callback &&
+		    dispc.irq_handlers[i].data == data) {
+			dispc.irq_handlers[i].irq_mask = 0;
+			dispc.irq_handlers[i].callback = NULL;
+			dispc.irq_handlers[i].data = NULL;
+			recalc_irq_mask();
+			return;
+		}
+	}
+
+	BUG();
 }
 EXPORT_SYMBOL(omap_dispc_free_irq);
 
 static irqreturn_t omap_dispc_irq_handler(int irq, void *dev)
 {
 	u32 stat;
+	int i = 0;
 
 	enable_lcd_clocks(1);
 
@@ -873,8 +891,12 @@ static irqreturn_t omap_dispc_irq_handler(int irq, void *dev)
 		}
 	}
 
-	if ((stat & dispc.enabled_irqs) && dispc.irq_callback)
-		dispc.irq_callback(dispc.irq_callback_data);
+	for (i = 0; i < MAX_IRQ_HANDLERS; i++) {
+		if (unlikely(dispc.irq_handlers[i].callback &&
+			     (stat & dispc.irq_handlers[i].irq_mask)))
+			dispc.irq_handlers[i].callback(
+						dispc.irq_handlers[i].data);
+	}
 
 	dispc_write_reg(DISPC_IRQSTATUS, stat);
 
@@ -1410,8 +1432,7 @@ static int omap_dispc_init(struct omapfb_device *fbdev, int ext_mode,
 	l = dispc_read_reg(DISPC_IRQSTATUS);
 	dispc_write_reg(DISPC_IRQSTATUS, l);
 
-	/* Enable those that we handle always */
-	omap_dispc_enable_irqs(DISPC_IRQ_FRAMEMASK);
+	recalc_irq_mask();
 
 	if ((r = request_irq(INT_24XX_DSS_IRQ, omap_dispc_irq_handler,
 			   0, MODULE_NAME, fbdev)) < 0) {
diff --git a/drivers/video/omap/dispc.h b/drivers/video/omap/dispc.h
index ef720a7..c15ea77 100644
--- a/drivers/video/omap/dispc.h
+++ b/drivers/video/omap/dispc.h
@@ -37,9 +37,10 @@ extern void omap_dispc_set_lcd_size(int width, int height);
 extern void omap_dispc_enable_lcd_out(int enable);
 extern void omap_dispc_enable_digit_out(int enable);
 
-extern int  omap_dispc_request_irq(void (*callback)(void *data), void *data);
-extern void omap_dispc_free_irq(void);
+extern int omap_dispc_request_irq(unsigned long irq_mask,
+				   void (*callback)(void *data), void *data);
+extern void omap_dispc_free_irq(unsigned long irq_mask,
+				 void (*callback)(void *data), void *data);
 
 extern const struct lcd_ctrl omap2_int_ctrl;
-
 #endif
diff --git a/drivers/video/omap/rfbi.c b/drivers/video/omap/rfbi.c
index 9332d6c..ee01e84 100644
--- a/drivers/video/omap/rfbi.c
+++ b/drivers/video/omap/rfbi.c
@@ -57,6 +57,7 @@
 
 #define DISPC_BASE		0x48050400
 #define DISPC_CONTROL		0x0040
+#define DISPC_IRQ_FRAMEMASK     0x0001
 
 static struct {
 	void __iomem	*base;
@@ -553,7 +554,9 @@ static int rfbi_init(struct omapfb_device *fbdev)
 	l = (0x01 << 2);
 	rfbi_write_reg(RFBI_CONTROL, l);
 
-	if ((r = omap_dispc_request_irq(rfbi_dma_callback, NULL)) < 0) {
+	r = omap_dispc_request_irq(DISPC_IRQ_FRAMEMASK, rfbi_dma_callback,
+				   NULL);
+	if (r < 0) {
 		dev_err(fbdev->dev, "can't get DISPC irq\n");
 		rfbi_enable_clocks(0);
 		return r;
@@ -570,7 +573,7 @@ static int rfbi_init(struct omapfb_device *fbdev)
 
 static void rfbi_cleanup(void)
 {
-	omap_dispc_free_irq();
+	omap_dispc_free_irq(DISPC_IRQ_FRAMEMASK, rfbi_dma_callback, NULL);
 	rfbi_put_clocks();
 	iounmap(rfbi.base);
 }
-- 
1.6.3.2

