Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbZCHPxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbZCHPxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZCHPwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:52:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:34117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbZCHPwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:52:16 -0400
Date: Sun, 8 Mar 2009 15:51:50 GMT
From: Masami Hiramatsu <mhiramat@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <49B14352.2040705@redhat.com>
References: <49B14352.2040705@redhat.com>
Subject: [tip:tracing/core] x86: implement atomic text_poke() via fixmap
Message-ID: <tip-78ff7fae04554b49d29226ed12536268c2500d1f@git.kernel.org>
Git-Commit-ID: 78ff7fae04554b49d29226ed12536268c2500d1f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 15:51:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78ff7fae04554b49d29226ed12536268c2500d1f
Gitweb:     http://git.kernel.org/tip/78ff7fae04554b49d29226ed12536268c2500d1f
Author:     "Masami Hiramatsu" <mhiramat@redhat.com>
AuthorDate: Fri, 6 Mar 2009 10:37:54 -0500
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 16:49:01 +0100

x86: implement atomic text_poke() via fixmap

Use fixmaps instead of vmap/vunmap in text_poke() for avoiding
page allocation and delayed unmapping.

At the result of above change, text_poke() becomes atomic and can be called
from stop_machine() etc.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
LKML-Reference: <49B14352.2040705@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/fixmap.h |    2 ++
 arch/x86/kernel/alternative.c |   24 +++++++++++++++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 63a79c7..81937a5 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -111,6 +111,8 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
+	FIX_TEXT_POKE0,	/* reserve 2 pages for text_poke() */
+	FIX_TEXT_POKE1,
 	__end_of_permanent_fixed_addresses,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 092a7b8..2d903b7 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -13,7 +13,9 @@
 #include <asm/nmi.h>
 #include <asm/vsyscall.h>
 #include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
 #include <asm/io.h>
+#include <asm/fixmap.h>
 
 #define MAX_PATCH_LEN (255-1)
 
@@ -505,15 +507,16 @@ void *text_poke_early(void *addr, const void *opcode, size_t len)
  * It means the size must be writable atomically and the address must be aligned
  * in a way that permits an atomic write. It also makes sure we fit on a single
  * page.
+ *
+ * Note: Must be called under text_mutex.
  */
 void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
+	unsigned long flags;
 	char *vaddr;
-	int nr_pages = 2;
 	struct page *pages[2];
 	int i;
 
-	might_sleep();
 	if (!core_kernel_text((unsigned long)addr)) {
 		pages[0] = vmalloc_to_page(addr);
 		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
@@ -523,14 +526,17 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 		pages[1] = virt_to_page(addr + PAGE_SIZE);
 	}
 	BUG_ON(!pages[0]);
-	if (!pages[1])
-		nr_pages = 1;
-	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-	BUG_ON(!vaddr);
-	local_irq_disable();
+	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
+	if (pages[1])
+		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
+	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
+	local_irq_save(flags);
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-	local_irq_enable();
-	vunmap(vaddr);
+	local_irq_restore(flags);
+	clear_fixmap(FIX_TEXT_POKE0);
+	if (pages[1])
+		clear_fixmap(FIX_TEXT_POKE1);
+	local_flush_tlb();
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
