Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYHAJkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYHAJkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYHAJij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:39 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:16382 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbYHAJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vnna3sYgIER1eJV0ZM/nE1e0KrtdvZFGeh8ZvBvG7PHjH/Igqs2p6Gu1iwPF98kae0
         w5gvUpRavPiglOKFpf3ceZLQXB+6ySvOXfnO42b7BUe2VYIj9COQg8mE/fZuIBUnSDGh
         /c1/JZHGbUc7mjmwGMew47NycwqnFLP/DdjIo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 06/16] make irq_desc to use dyn_array
Date: Fri,  1 Aug 2008 02:37:34 -0700
Message-Id: <1217583464-28494-7-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 include/linux/irq.h |    4 ++++
 kernel/irq/handle.c |   31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -181,7 +181,11 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
+extern struct irq_desc *irq_desc;
+#else
 extern struct irq_desc irq_desc[NR_IRQS];
+#endif
 
 /*
  * Migration helpers for obsolete names, they will go away:
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -48,6 +48,36 @@ handle_bad_irq(unsigned int irq, struct
  * Controller mappings for all interrupt sources:
  */
 int nr_irqs = NR_IRQS;
+
+#ifdef CONFIG_HAVE_DYN_ARRAY
+static struct irq_desc irq_desc_init = {
+	.status = IRQ_DISABLED,
+	.chip = &no_irq_chip,
+	.handle_irq = handle_bad_irq,
+	.depth = 1,
+	.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
+#ifdef CONFIG_SMP
+	.affinity = CPU_MASK_ALL
+#endif
+};
+
+static void __init init_work(void *data)
+{
+	struct dyn_array *da = data;
+	int i;
+	struct  irq_desc *desc;
+
+	desc = *da->name;
+
+	for (i = 0; i < *da->nr; i++)
+		memcpy(&desc[i], &irq_desc_init, sizeof(struct irq_desc));
+}
+
+struct irq_desc *irq_desc;
+DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
+
+#else
+
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
@@ -60,6 +90,7 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 #endif
 	}
 };
+#endif
 
 /*
  * What should we do if we get a hw irq event on an illegal vector?
