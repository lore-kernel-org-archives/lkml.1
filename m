Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbZINUUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbZINUUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933502AbZINUUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:20:01 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54051 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933518AbZINUId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 25/72] Blackfin: push SRAM locks down into related ifdefs
Date: Mon, 14 Sep 2009 16:07:29 -0400
Message-Id: <1252958896-25150-26-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than defining the locks and initializing them all the time, only do
so when we actually need them (i.e. the SRAM regions exist).  This avoids
dead data and code bloat during runtime.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mm/sram-alloc.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
index 0bc3c4e..e095094 100644
--- a/arch/blackfin/mm/sram-alloc.c
+++ b/arch/blackfin/mm/sram-alloc.c
@@ -42,11 +42,6 @@
 #include <asm/mem_map.h>
 #include "blackfin_sram.h"
 
-static DEFINE_PER_CPU(spinlock_t, l1sram_lock) ____cacheline_aligned_in_smp;
-static DEFINE_PER_CPU(spinlock_t, l1_data_sram_lock) ____cacheline_aligned_in_smp;
-static DEFINE_PER_CPU(spinlock_t, l1_inst_sram_lock) ____cacheline_aligned_in_smp;
-static spinlock_t l2_sram_lock ____cacheline_aligned_in_smp;
-
 /* the data structure for L1 scratchpad and DATA SRAM */
 struct sram_piece {
 	void *paddr;
@@ -55,6 +50,7 @@ struct sram_piece {
 	struct sram_piece *next;
 };
 
+static DEFINE_PER_CPU(spinlock_t, l1sram_lock) ____cacheline_aligned_in_smp;
 static DEFINE_PER_CPU(struct sram_piece, free_l1_ssram_head);
 static DEFINE_PER_CPU(struct sram_piece, used_l1_ssram_head);
 
@@ -68,12 +64,18 @@ static DEFINE_PER_CPU(struct sram_piece, free_l1_data_B_sram_head);
 static DEFINE_PER_CPU(struct sram_piece, used_l1_data_B_sram_head);
 #endif
 
+#if L1_DATA_A_LENGTH || L1_DATA_B_LENGTH
+static DEFINE_PER_CPU(spinlock_t, l1_data_sram_lock) ____cacheline_aligned_in_smp;
+#endif
+
 #if L1_CODE_LENGTH != 0
+static DEFINE_PER_CPU(spinlock_t, l1_inst_sram_lock) ____cacheline_aligned_in_smp;
 static DEFINE_PER_CPU(struct sram_piece, free_l1_inst_sram_head);
 static DEFINE_PER_CPU(struct sram_piece, used_l1_inst_sram_head);
 #endif
 
 #if L2_LENGTH != 0
+static spinlock_t l2_sram_lock ____cacheline_aligned_in_smp;
 static struct sram_piece free_l2_sram_head, used_l2_sram_head;
 #endif
 
@@ -225,10 +227,10 @@ static void __init l2_sram_init(void)
 	printk(KERN_INFO "Blackfin L2 SRAM: %d KB (%d KB free)\n",
 		L2_LENGTH >> 10,
 		free_l2_sram_head.next->size >> 10);
-#endif
 
 	/* mutex initialize */
 	spin_lock_init(&l2_sram_lock);
+#endif
 }
 
 static int __init bfin_sram_init(void)
@@ -416,18 +418,17 @@ EXPORT_SYMBOL(sram_free);
 
 void *l1_data_A_sram_alloc(size_t size)
 {
+#if L1_DATA_A_LENGTH != 0
 	unsigned long flags;
-	void *addr = NULL;
+	void *addr;
 	unsigned int cpu;
 
 	cpu = get_cpu();
 	/* add mutex operation */
 	spin_lock_irqsave(&per_cpu(l1_data_sram_lock, cpu), flags);
 
-#if L1_DATA_A_LENGTH != 0
 	addr = _sram_alloc(size, &per_cpu(free_l1_data_A_sram_head, cpu),
 			&per_cpu(used_l1_data_A_sram_head, cpu));
-#endif
 
 	/* add mutex operation */
 	spin_unlock_irqrestore(&per_cpu(l1_data_sram_lock, cpu), flags);
@@ -437,11 +438,15 @@ void *l1_data_A_sram_alloc(size_t size)
 		 (long unsigned int)addr, size);
 
 	return addr;
+#else
+	return NULL;
+#endif
 }
 EXPORT_SYMBOL(l1_data_A_sram_alloc);
 
 int l1_data_A_sram_free(const void *addr)
 {
+#if L1_DATA_A_LENGTH != 0
 	unsigned long flags;
 	int ret;
 	unsigned int cpu;
@@ -450,18 +455,17 @@ int l1_data_A_sram_free(const void *addr)
 	/* add mutex operation */
 	spin_lock_irqsave(&per_cpu(l1_data_sram_lock, cpu), flags);
 
-#if L1_DATA_A_LENGTH != 0
 	ret = _sram_free(addr, &per_cpu(free_l1_data_A_sram_head, cpu),
 			&per_cpu(used_l1_data_A_sram_head, cpu));
-#else
-	ret = -1;
-#endif
 
 	/* add mutex operation */
 	spin_unlock_irqrestore(&per_cpu(l1_data_sram_lock, cpu), flags);
 	put_cpu();
 
 	return ret;
+#else
+	return -1;
+#endif
 }
 EXPORT_SYMBOL(l1_data_A_sram_free);
 
-- 
1.6.4.2

