Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbYGPAZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbYGPAZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbYGPAYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:24:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758839AbYGPAYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=scGY9c0sD2wF3eBChtACBnN0Msd+uPVc4tiHJL43Wn/wUH/gYdrMld/1TcbVum3onA
         qv62E4mW0nDhvADwB58A0cgpNpLghL2Gqi9+nDuA1obABxzL2A42i+CSz3pAfqJ1i3kG
         FFUXlzTIMnjEKwoaZJbyZjMMfAuVmC+wSvyCc=
Date: Wed, 16 Jul 2008 02:23:53 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/13] x86: add hooks for kmemcheck on x86_64
Message-ID: <20080716002353.GJ12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a01667599a005303eb3f54b45d31346964b47ebf Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Fri, 4 Apr 2008 11:16:06 +0300
Subject: [PATCH 09/13] x86: add hooks for kmemcheck on x86_64

This makes the necessary changes for kmemcheck to work on x86_64.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/traps_64.c   |    9 +++++++++
 include/asm-x86/pgtable_64.h |    6 ++++++
 include/asm-x86/string_64.h  |    1 +
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 552506c..97a8f52 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -53,6 +53,7 @@
 #include <asm/proto.h>
 #include <asm/nmi.h>
 #include <asm/stacktrace.h>
+#include <asm/kmemcheck.h>
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
@@ -911,6 +912,14 @@ asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 
 	get_debugreg(condition, 6);
 
+	/* Catch kmemcheck conditions first of all! */
+	if (condition & DR_STEP) {
+		if (kmemcheck_active(regs)) {
+			kmemcheck_hide(regs);
+			return;
+		}
+	}
+
 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.
 	 */
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 1cc50d2..7836ccc 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -169,6 +169,12 @@ static inline int pmd_bad(pmd_t pmd)
 #define pte_none(x)	(!pte_val((x)))
 #define pte_present(x)	(pte_val((x)) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
+#ifdef CONFIG_KMEMCHECK
+#define pte_hidden(x)	(pte_val((x)) & (_PAGE_HIDDEN))
+#else
+#define pte_hidden(x)	0
+#endif
+
 #define pages_to_mb(x)	((x) >> (20 - PAGE_SHIFT))   /* FIXME: is this right? */
 #define pte_page(x)	pfn_to_page(pte_pfn((x)))
 #define pte_pfn(x)	((pte_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
diff --git a/include/asm-x86/string_64.h b/include/asm-x86/string_64.h
index 52b5ab3..49874fd 100644
--- a/include/asm-x86/string_64.h
+++ b/include/asm-x86/string_64.h
@@ -45,6 +45,7 @@ extern void *__memcpy(void *to, const void *from, size_t len);
 
 #define __HAVE_ARCH_MEMSET
 void *memset(void *s, int c, size_t n);
+void *__memset(void *s, int c, size_t n);
 
 #define __HAVE_ARCH_MEMMOVE
 void *memmove(void *dest, const void *src, size_t count);
-- 
1.5.5.1

