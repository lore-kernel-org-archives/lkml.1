Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbZFEIV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbZFEIV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbZFEIGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37581 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbZFEIGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 45/62] Blackfin: fix handling of initial L1 reservation
Date: Fri,  5 Jun 2009 04:04:54 -0400
Message-Id: <1244189111-19639-46-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

This restores some L1 reservation logic that was lost during the Blackfin
SMP merge.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mm/sram-alloc.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
index 36376d8..fa54a4e 100644
--- a/arch/blackfin/mm/sram-alloc.c
+++ b/arch/blackfin/mm/sram-alloc.c
@@ -83,6 +83,14 @@ static struct kmem_cache *sram_piece_cache;
 static void __init l1sram_init(void)
 {
 	unsigned int cpu;
+	unsigned long reserve;
+
+#ifdef CONFIG_SMP
+	reserve = 0;
+#else
+	reserve = sizeof(struct l1_scratch_task_info);
+#endif
+
 	for (cpu = 0; cpu < num_possible_cpus(); ++cpu) {
 		per_cpu(free_l1_ssram_head, cpu).next =
 			kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
@@ -91,8 +99,8 @@ static void __init l1sram_init(void)
 			return;
 		}
 
-		per_cpu(free_l1_ssram_head, cpu).next->paddr = (void *)get_l1_scratch_start_cpu(cpu);
-		per_cpu(free_l1_ssram_head, cpu).next->size = L1_SCRATCH_LENGTH;
+		per_cpu(free_l1_ssram_head, cpu).next->paddr = (void *)get_l1_scratch_start_cpu(cpu) + reserve;
+		per_cpu(free_l1_ssram_head, cpu).next->size = L1_SCRATCH_LENGTH - reserve;
 		per_cpu(free_l1_ssram_head, cpu).next->pid = 0;
 		per_cpu(free_l1_ssram_head, cpu).next->next = NULL;
 
-- 
1.6.3.1

