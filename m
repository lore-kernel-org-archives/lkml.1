Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZEVBo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZEVBo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 21:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZEVBoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 21:44:19 -0400
Received: from densangw.densan.co.jp ([218.222.200.50]:3027 "EHLO
	densangw.densan.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZEVBoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 21:44:19 -0400
X-Greylist: delayed 2774 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 May 2009 21:44:18 EDT
Date: Fri, 22 May 2009 09:57:20 +0900 (JST)
Message-Id: <20090522.095720.68565257.saito@densan.co.jp>
To: linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, hsaito.ppc@gmail.com
Subject: Re: can't flush tlb on e500
From: Hideo Saito <hsaito.ppc@gmail.com>
In-Reply-To: <d50492d40905200312r729608a3nf244b153892ac257@mail.gmail.com>
References: <d50492d40905200312r729608a3nf244b153892ac257@mail.gmail.com>
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.0 (HANANOEN)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about following changes because all TLB entries are flushed repeatedly if processes overflow at the table mapping the context. I think that the table should be initialized again because _tlbil_pid() flushes all TLB entries and tlbilx instruction isn't supported on E500(MPC8548).

--- arch/powerpc/mm/mmu_context_nohash.c.orig	2009-03-24 08:12:14.000000000 +0900
+++ arch/powerpc/mm/mmu_context_nohash.c	2009-05-21 16:35:09.000000000 +0900
@@ -107,39 +107,69 @@ static unsigned int steal_context_smp(un
 	 */
 	spin_unlock(&context_lock);
 	cpu_relax();
 	spin_lock(&context_lock);
 	goto again;
 }
 #endif  /* CONFIG_SMP */
 
+/*
+ * We're flushed using the all context
+ */
+static void flush_all_context(int cpu)
+{
+	struct mm_struct *mm;
+	int n;
+
+	for (n = first_context; n <= last_context; n++) {
+
+		mm = context_mm[n];
+		if (mm == NULL || mm->context.id == MMU_NO_CONTEXT)
+			continue;
+
+		WARN_ON(mm->context.active != 0);
+
+		mm->context.id = MMU_NO_CONTEXT;
+	}
+	memset(stale_map[cpu], 0, CTX_MAP_SIZE);
+	memset(context_map, 0, CTX_MAP_SIZE);
+	context_map[0] = (1 << first_context) - 1;
+	nr_free_contexts = last_context - first_context + 1;
+}
+
 /* Note that this will also be called on SMP if all other CPUs are
  * offlined, which means that it may be called for cpu != 0. For
  * this to work, we somewhat assume that CPUs that are onlined
  * come up with a fully clean TLB (or are cleaned when offlined)
  */
 static unsigned int steal_context_up(unsigned int id)
 {
 	struct mm_struct *mm;
 	int cpu = smp_processor_id();
 
 	/* Pick up the victim mm */
 	mm = context_mm[id];
 
 	pr_debug("[%d] steal context %d from mm @%p\n", cpu, id, mm);
 
-	/* Mark this mm has having no context anymore */
-	mm->context.id = MMU_NO_CONTEXT;
-
 	/* Flush the TLB for that context */
 	local_flush_tlb_mm(mm);
 
+#ifdef CONFIG_FSL_BOOKE
+	flush_all_context(cpu);
+	__set_bit(id, context_map);
+	nr_free_contexts--;
+#else
+	/* Mark this mm has having no context anymore */
+	mm->context.id = MMU_NO_CONTEXT;
+
 	/* XXX This clear should ultimately be part of local_flush_tlb_mm */
 	__clear_bit(id, stale_map[cpu]);
+#endif
 
 	return id;
 }
 
 #ifdef DEBUG_MAP_CONSISTENCY
 static void context_check_map(void)
 {
 	unsigned int id, nrf, nact;
