Return-Path: <linux-kernel-owner+w=401wt.eu-S1764132AbYHHWCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764132AbYHHWCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbYHHVy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:28 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:31700 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761870AbYHHVy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Xp1V2/8JIQY5qRXqKUmmj+5En2qb5qmm3/7vmRyHffvF5xc0UaRULc3d8jk1k1RimJ
         fcQqaOgELmSgi/+GD03CmUC1VX4/QU1iboO1wGmdeSDKO9h6RaQsHfs2u48VZOjftlG9
         4jwgtWkIZIzmhKqPNiQKHua5AfppYXX7Zg/XA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 21/42] make irq_desc to use dyn_array
Date: Fri,  8 Aug 2008 14:52:27 -0700
Message-Id: <1218232368-31228-22-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-21-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-18-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-19-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-20-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-21-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 include/linux/irq.h |    4 ++++
 kernel/irq/handle.c |   31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index bd69d90..c22e870 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
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
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index e9d022c..e94eeca 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -48,6 +48,36 @@ handle_bad_irq(unsigned int irq, struct irq_desc *desc)
  * Controller mappings for all interrupt sources:
  */
 int nr_irqs = NR_IRQS;
+
+#ifdef CONFIG_HAVE_DYN_ARRAY
+static struct irq_desc irq_desc_init __initdata = {
+	.status = IRQ_DISABLED,
+	.chip = &no_irq_chip,
+	.handle_irq = handle_bad_irq,
+	.depth = 1,
+	.lock = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
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
@@ -60,6 +90,7 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 #endif
 	}
 };
+#endif
 
 /*
  * What should we do if we get a hw irq event on an illegal vector?
-- 
1.5.4.5

