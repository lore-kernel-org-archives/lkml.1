Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZHZXVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZHZXVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 19:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZHZXVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 19:21:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:55261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbZHZXVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 19:21:10 -0400
Message-ID: <4A95C32D.5040605@kernel.org>
Date: Wed, 26 Aug 2009 16:20:13 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] irq: make sure irq_desc for legacy irq get correct node setting
References: <20090826214323.GC25536@elte.hu>
In-Reply-To: <20090826214323.GC25536@elte.hu>
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
