Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbYDXGhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbYDXGhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 02:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYDXGhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 02:37:05 -0400
Received: from rv-out-0708.google.com ([209.85.198.250]:6790 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056AbYDXGhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 02:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=bpMqPuy9R0ikI8umemWwlmKIS0nrrrbn2Yi73dmO/SMz0PSzVYL5BCLE3T1LZGL3+k0trCzOFV/XzHASrB0dty18tJ0MNwTs1hWCrbhchsxFSTP16E3nkkSJwjbb33aqNzIpSkSfc/ofl3w6qXYiJfmKlhRVWfFAGgGi4FP3JmY=
Date: Thu, 24 Apr 2008 14:36:25 +0800 (CST)
Message-Id: <20080424.143625.40747652.xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] arch/um/kernel/mem.c: remove arch_validate()
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove arch_validate(), because no one uses it.
Remove useless macro HAVE_ARCH_VALIDATE.
Make the variable 'empty_bad_page' static.

Compile testing passed.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
 arch/um/kernel/ksyms.c |    1 -
 arch/um/kernel/mem.c   |   33 +--------------------------------
 include/asm-um/page.h  |    3 ---
 3 files changed, 1 insertions(+), 36 deletions(-)

diff --git a/arch/um/kernel/ksyms.c b/arch/um/kernel/ksyms.c
index 66e2a30..cc1b5f1 100644
--- a/arch/um/kernel/ksyms.c
+++ b/arch/um/kernel/ksyms.c
@@ -18,7 +18,6 @@ EXPORT_SYMBOL(get_signals);
 EXPORT_SYMBOL(kernel_thread);
 EXPORT_SYMBOL(sys_waitpid);
 EXPORT_SYMBOL(flush_tlb_range);
-EXPORT_SYMBOL(arch_validate);
 
 EXPORT_SYMBOL(high_physmem);
 EXPORT_SYMBOL(empty_zero_page);
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 2eea1ff..88fc1c8 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -21,7 +21,7 @@
 /* allocated in paging_init, zeroed in mem_init, and unchanged thereafter */
 unsigned long *empty_zero_page = NULL;
 /* allocated in paging_init and unchanged thereafter */
-unsigned long *empty_bad_page = NULL;
+static unsigned long *empty_bad_page = NULL;
 
 /*
  * Initialized during boot, and readonly for initializing page tables
@@ -240,37 +240,6 @@ void __init paging_init(void)
 #endif
 }
 
-struct page *arch_validate(struct page *page, gfp_t mask, int order)
-{
-	unsigned long addr, zero = 0;
-	int i;
-
- again:
-	if (page == NULL)
-		return page;
-	if (PageHighMem(page))
-		return page;
-
-	addr = (unsigned long) page_address(page);
-	for (i = 0; i < (1 << order); i++) {
-		current->thread.fault_addr = (void *) addr;
-		if (__do_copy_to_user((void __user *) addr, &zero,
-				     sizeof(zero),
-				     &current->thread.fault_addr,
-				     &current->thread.fault_catcher)) {
-			if (!(mask & __GFP_WAIT))
-				return NULL;
-			else break;
-		}
-		addr += PAGE_SIZE;
-	}
-
-	if (i == (1 << order))
-		return page;
-	page = alloc_pages(mask, order);
-	goto again;
-}
-
 /*
  * This can't do anything because nothing in the kernel image can be freed
  * since it's not in kernel physical memory.
diff --git a/include/asm-um/page.h b/include/asm-um/page.h
index 381f96b..4b489e3 100644
--- a/include/asm-um/page.h
+++ b/include/asm-um/page.h
@@ -114,9 +114,6 @@ extern unsigned long uml_physmem;
 #define pfn_valid(pfn) ((pfn) < max_mapnr)
 #define virt_addr_valid(v) pfn_valid(phys_to_pfn(__pa(v)))
 
-extern struct page *arch_validate(struct page *page, gfp_t mask, int order);
-#define HAVE_ARCH_VALIDATE
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-- 
1.5.2.4

