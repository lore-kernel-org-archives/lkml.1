Return-Path: <linux-kernel-owner+w=401wt.eu-S1761526AbZAPIbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526AbZAPIbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762024AbZAPI1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:27:52 -0500
Received: from smtp.nokia.com ([192.100.105.134]:28184 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761949AbZAPI1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:27:49 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 07/10] omap mailbox: add save_/restore_ctx() for PM
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:27:37 +0200
Message-ID: <20090116082737.17571.53738.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:27:38.0761 (UTC) FILETIME=[4AAF9790:01C977B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To preserve the registers during off-mode

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/mach-omap2/mailbox.c             |   35 +++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/mach/mailbox.h |   23 +++++++++++++++++++
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index a877305..544dde9 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -32,6 +32,8 @@
 #define MAILBOX_IRQ_NEWMSG(u)		(1 << (2 * (u)))
 #define MAILBOX_IRQ_NOTFULL(u)		(1 << (2 * (u) + 1))
 
+#define MBOX_REG_SIZE			0x120
+
 static void __iomem *mbox_base;
 
 struct omap_mbox2_fifo {
@@ -47,6 +49,7 @@ struct omap_mbox2_priv {
 	unsigned long irqstatus;
 	u32 newmsg_bit;
 	u32 notfull_bit;
+	char ctx[MBOX_REG_SIZE];
 };
 
 static struct clk *mbox_ick_handle;
@@ -167,6 +170,36 @@ static int omap2_mbox_is_irq(struct omap_mbox *mbox,
 	return (enable & status & bit);
 }
 
+static void omap2_mbox_save_ctx(struct omap_mbox *mbox)
+{
+	int i;
+	struct omap_mbox2_priv *p = mbox->priv;
+
+	for (i = 0; i < MBOX_REG_SIZE; i += sizeof(u32)) {
+		u32 val;
+
+		val = mbox_read_reg(i);
+		*(u32 *)(p->ctx + i) = val;
+
+		dev_dbg(mbox->dev, "%s\t[%02d] %08x\n", __func__, i, val);
+	}
+}
+
+static void omap2_mbox_restore_ctx(struct omap_mbox *mbox)
+{
+	int i;
+	struct omap_mbox2_priv *p = mbox->priv;
+
+	for (i = 0; i < MBOX_REG_SIZE; i += sizeof(u32)) {
+		u32 val;
+
+		val = *(u32 *)(p->ctx + i);
+		mbox_write_reg(val, i);
+
+		dev_dbg(mbox->dev, "%s\t[%02d] %08x\n", __func__, i, val);
+	}
+}
+
 static struct omap_mbox_ops omap2_mbox_ops = {
 	.type		= OMAP_MBOX_TYPE2,
 	.startup	= omap2_mbox_startup,
@@ -179,6 +212,8 @@ static struct omap_mbox_ops omap2_mbox_ops = {
 	.disable_irq	= omap2_mbox_disable_irq,
 	.ack_irq	= omap2_mbox_ack_irq,
 	.is_irq		= omap2_mbox_is_irq,
+	.save_ctx	= omap2_mbox_save_ctx,
+	.restore_ctx	= omap2_mbox_restore_ctx,
 };
 
 /*
diff --git a/arch/arm/plat-omap/include/mach/mailbox.h b/arch/arm/plat-omap/include/mach/mailbox.h
index 577db68..b7a6991 100644
--- a/arch/arm/plat-omap/include/mach/mailbox.h
+++ b/arch/arm/plat-omap/include/mach/mailbox.h
@@ -33,6 +33,9 @@ struct omap_mbox_ops {
 	void		(*disable_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
 	void		(*ack_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
 	int		(*is_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+	/* ctx */
+	void		(*save_ctx)(struct omap_mbox *mbox);
+	void		(*restore_ctx)(struct omap_mbox *mbox);
 };
 
 struct omap_mbox_queue {
@@ -70,4 +73,24 @@ void omap_mbox_put(struct omap_mbox *);
 int omap_mbox_register(struct device *parent, struct omap_mbox *);
 int omap_mbox_unregister(struct omap_mbox *);
 
+static inline void omap_mbox_save_ctx(struct omap_mbox *mbox)
+{
+	if (!mbox->ops->save_ctx) {
+		dev_err(mbox->dev, "%s:\tno save\n", __func__);
+		return;
+	}
+
+	mbox->ops->save_ctx(mbox);
+}
+
+static inline void omap_mbox_restore_ctx(struct omap_mbox *mbox)
+{
+	if (!mbox->ops->restore_ctx) {
+		dev_err(mbox->dev, "%s:\tno restore\n", __func__);
+		return;
+	}
+
+	mbox->ops->restore_ctx(mbox);
+}
+
 #endif /* MAILBOX_H */

