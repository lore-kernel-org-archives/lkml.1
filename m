Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbZAPIcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbZAPIcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762087AbZAPI2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:28:03 -0500
Received: from smtp.nokia.com ([192.100.105.134]:28213 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762017AbZAPI17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:27:59 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 08/10] omap mailbox: move mailbox.h into mailbox.c
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:27:42 +0200
Message-ID: <20090116082742.17571.7783.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:27:43.0776 (UTC) FILETIME=[4DACD200:01C977B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no need to keep mailbox.h separately.

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/plat-omap/mailbox.c |   86 ++++++++++++++++++++++++++++++++++++
 arch/arm/plat-omap/mailbox.h |  100 ------------------------------------------
 2 files changed, 85 insertions(+), 101 deletions(-)
 delete mode 100644 arch/arm/plat-omap/mailbox.h

diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index 5e8cd65..db5a0c2 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -31,11 +31,95 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <mach/mailbox.h>
-#include "mailbox.h"
 
 static struct omap_mbox *mboxes;
 static DEFINE_RWLOCK(mboxes_lock);
 
+/*
+ * Mailbox sequence bit API
+ */
+#if defined(CONFIG_ARCH_OMAP1)
+#  define MBOX_USE_SEQ_BIT
+#elif defined(CONFIG_ARCH_OMAP2)
+#  define MBOX_USE_SEQ_BIT
+#endif
+
+#ifdef MBOX_USE_SEQ_BIT
+/* seq_rcv should be initialized with any value other than
+ * 0 and 1 << 31, to allow either value for the first
+ * message.  */
+static inline void mbox_seq_init(struct omap_mbox *mbox)
+{
+	/* any value other than 0 and 1 << 31 */
+	mbox->seq_rcv = 0xffffffff;
+}
+
+static inline void mbox_seq_toggle(struct omap_mbox *mbox, mbox_msg_t * msg)
+{
+	/* add seq_snd to msg */
+	*msg = (*msg & 0x7fffffff) | mbox->seq_snd;
+	/* flip seq_snd */
+	mbox->seq_snd ^= 1 << 31;
+}
+
+static inline int mbox_seq_test(struct omap_mbox *mbox, mbox_msg_t msg)
+{
+	mbox_msg_t seq = msg & (1 << 31);
+	if (seq == mbox->seq_rcv)
+		return -1;
+	mbox->seq_rcv = seq;
+	return 0;
+}
+#else
+static inline void mbox_seq_init(struct omap_mbox *mbox)
+{
+}
+static inline void mbox_seq_toggle(struct omap_mbox *mbox, mbox_msg_t * msg)
+{
+}
+static inline int mbox_seq_test(struct omap_mbox *mbox, mbox_msg_t msg)
+{
+	return 0;
+}
+#endif
+
+/* Mailbox FIFO handle functions */
+static inline mbox_msg_t mbox_fifo_read(struct omap_mbox *mbox)
+{
+	return mbox->ops->fifo_read(mbox);
+}
+static inline void mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
+{
+	mbox->ops->fifo_write(mbox, msg);
+}
+static inline int mbox_fifo_empty(struct omap_mbox *mbox)
+{
+	return mbox->ops->fifo_empty(mbox);
+}
+static inline int mbox_fifo_full(struct omap_mbox *mbox)
+{
+	return mbox->ops->fifo_full(mbox);
+}
+
+/* Mailbox IRQ handle functions */
+static inline void enable_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	mbox->ops->enable_irq(mbox, irq);
+}
+static inline void disable_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	mbox->ops->disable_irq(mbox, irq);
+}
+static inline void ack_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	if (mbox->ops->ack_irq)
+		mbox->ops->ack_irq(mbox, irq);
+}
+static inline int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	return mbox->ops->is_irq(mbox, irq);
+}
+
 /* Mailbox Sequence Bit function */
 void omap_mbox_init_seq(struct omap_mbox *mbox)
 {
diff --git a/arch/arm/plat-omap/mailbox.h b/arch/arm/plat-omap/mailbox.h
deleted file mode 100644
index 67c6740..0000000
--- a/arch/arm/plat-omap/mailbox.h
+++ /dev/null
@@ -1,100 +0,0 @@
-/*
- * Mailbox internal functions
- *
- * Copyright (C) 2006 Nokia Corporation
- * Written by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef __ARCH_ARM_PLAT_MAILBOX_H
-#define __ARCH_ARM_PLAT_MAILBOX_H
-
-/*
- * Mailbox sequence bit API
- */
-#if defined(CONFIG_ARCH_OMAP1)
-#  define MBOX_USE_SEQ_BIT
-#elif defined(CONFIG_ARCH_OMAP2)
-#  define MBOX_USE_SEQ_BIT
-#endif
-
-#ifdef MBOX_USE_SEQ_BIT
-/* seq_rcv should be initialized with any value other than
- * 0 and 1 << 31, to allow either value for the first
- * message.  */
-static inline void mbox_seq_init(struct omap_mbox *mbox)
-{
-	/* any value other than 0 and 1 << 31 */
-	mbox->seq_rcv = 0xffffffff;
-}
-
-static inline void mbox_seq_toggle(struct omap_mbox *mbox, mbox_msg_t * msg)
-{
-	/* add seq_snd to msg */
-	*msg = (*msg & 0x7fffffff) | mbox->seq_snd;
-	/* flip seq_snd */
-	mbox->seq_snd ^= 1 << 31;
-}
-
-static inline int mbox_seq_test(struct omap_mbox *mbox, mbox_msg_t msg)
-{
-	mbox_msg_t seq = msg & (1 << 31);
-	if (seq == mbox->seq_rcv)
-		return -1;
-	mbox->seq_rcv = seq;
-	return 0;
-}
-#else
-static inline void mbox_seq_init(struct omap_mbox *mbox)
-{
-}
-static inline void mbox_seq_toggle(struct omap_mbox *mbox, mbox_msg_t * msg)
-{
-}
-static inline int mbox_seq_test(struct omap_mbox *mbox, mbox_msg_t msg)
-{
-	return 0;
-}
-#endif
-
-/* Mailbox FIFO handle functions */
-static inline mbox_msg_t mbox_fifo_read(struct omap_mbox *mbox)
-{
-	return mbox->ops->fifo_read(mbox);
-}
-static inline void mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
-{
-	mbox->ops->fifo_write(mbox, msg);
-}
-static inline int mbox_fifo_empty(struct omap_mbox *mbox)
-{
-	return mbox->ops->fifo_empty(mbox);
-}
-static inline int mbox_fifo_full(struct omap_mbox *mbox)
-{
-	return mbox->ops->fifo_full(mbox);
-}
-
-/* Mailbox IRQ handle functions */
-static inline void enable_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	mbox->ops->enable_irq(mbox, irq);
-}
-static inline void disable_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	mbox->ops->disable_irq(mbox, irq);
-}
-static inline void ack_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	if (mbox->ops->ack_irq)
-		mbox->ops->ack_irq(mbox, irq);
-}
-static inline int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
-{
-	return mbox->ops->is_irq(mbox, irq);
-}
-
-#endif				/* __ARCH_ARM_PLAT_MAILBOX_H */

