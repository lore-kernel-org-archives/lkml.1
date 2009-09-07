Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZIGSYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZIGSYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZIGSYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:24:35 -0400
Received: from [65.98.92.6] ([65.98.92.6]:4173 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZIGSYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:24:35 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Mon, 7 Sep 2009 11:11:31 -0700
Subject: [PATCHv2] MIPS: Machine check exception in kmap_coherent()
Message-Id: <2c228c5e48509b7c8296a6c50af3ad73@localhost>
In-Reply-To: <20090907102613.GA25295@linux-mips.org>
References: <20090907102613.GA25295@linux-mips.org>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create an extra set of fixmap entries for use in interrupt handlers.
This prevents fixmap VA conflicts between copy_user_highpage() running
in user context, and local_r4k_flush_cache_page() invoked from an SMP
IPI.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/fixmap.h |    4 ++--
 arch/mips/mm/init.c            |    6 +++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/fixmap.h b/arch/mips/include/asm/fixmap.h
index 0f5caa1..dd924b9 100644
--- a/arch/mips/include/asm/fixmap.h
+++ b/arch/mips/include/asm/fixmap.h
@@ -48,9 +48,9 @@ enum fixed_addresses {
 #define FIX_N_COLOURS 8
 	FIX_CMAP_BEGIN,
 #ifdef CONFIG_MIPS_MT_SMTC
-	FIX_CMAP_END = FIX_CMAP_BEGIN + (FIX_N_COLOURS * NR_CPUS),
+	FIX_CMAP_END = FIX_CMAP_BEGIN + (FIX_N_COLOURS * NR_CPUS * 2),
 #else
-	FIX_CMAP_END = FIX_CMAP_BEGIN + FIX_N_COLOURS,
+	FIX_CMAP_END = FIX_CMAP_BEGIN + (FIX_N_COLOURS * 2),
 #endif
 #ifdef CONFIG_HIGHMEM
 	/* reserved pte's for temporary kernel mappings */
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 0e82050..43ebe65 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -27,6 +27,7 @@
 #include <linux/swap.h>
 #include <linux/proc_fs.h>
 #include <linux/pfn.h>
+#include <linux/hardirq.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/bootinfo.h>
@@ -132,7 +133,10 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 	inc_preempt_count();
 	idx = (addr >> PAGE_SHIFT) & (FIX_N_COLOURS - 1);
 #ifdef CONFIG_MIPS_MT_SMTC
-	idx += FIX_N_COLOURS * smp_processor_id();
+	idx += FIX_N_COLOURS * smp_processor_id() +
+		(in_interrupt() ? (FIX_N_COLOURS * NR_CPUS) : 0);
+#else
+	idx += in_interrupt() ? FIX_N_COLOURS : 0;
 #endif
 	vaddr = __fix_to_virt(FIX_CMAP_END - idx);
 	pte = mk_pte(page, PAGE_KERNEL);
-- 
1.6.3.1

