Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZHNBo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZHNBo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 21:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZHNBo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 21:44:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:54810 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbZHNBo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 21:44:58 -0400
Message-ID: <4A84C13E.5050606@kernel.org>
Date: Thu, 13 Aug 2009 18:43:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] irq: make sure irq_desc for legacy irq get correct node setting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when there is no ram on node 0

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/handle.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -161,7 +161,7 @@ int __init early_irq_init(void)
 
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
- 	node = first_online_node;
+	node = first_online_node;
 
 	/* allocate irq_desc_ptrs array based on nr_irqs */
 	irq_desc_ptrs = kcalloc(nr_irqs, sizeof(void *), GFP_NOWAIT);
@@ -172,6 +172,9 @@ int __init early_irq_init(void)
 
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
+#ifdef CONFIG_SMP
+		desc[i].node = node;
+#endif
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		alloc_desc_masks(&desc[i], node, true);
