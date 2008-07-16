Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYGPAZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYGPAZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759051AbYGPAYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:24:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759045AbYGPAYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=B3aPrej1rIo6g3KQc7RkQMkO4bCfGATL8cIWih6/29E15lVRVsZ8UDwWuac5fQ++qR
         ALDomw3kfQFiScipIUlzzwzqEI7Blu/3Rk6r9iZIVcpjqvyXHhzGF/+mPSjje9xTLctJ
         2+UeYutXiDeUlDpZJgXseOR3S3fdSZATDnvys=
Date: Wed, 16 Jul 2008 02:23:42 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/13] x86: add hooks for kmemcheck
Message-ID: <20080716002342.GI12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6cea44745d8c759e06c3c993e816377f7c270e62 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 4 Apr 2008 00:53:23 +0200
Subject: [PATCH 08/13] x86: add hooks for kmemcheck

The hooks that we modify are:
- Page fault handler (to handle kmemcheck faults)
- Debug exception handler (to hide pages after single-stepping
  the instruction that caused the page fault)

Also redefine memset() to use the optimized version if kmemcheck
is enabled.

(Thanks to Pekka Enberg for minimizing the impact on the page fault
 handler.)

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
 arch/x86/kernel/traps_32.c  |    9 +++++++++
 arch/x86/mm/fault.c         |   18 +++++++++++++++---
 include/asm-x86/string_32.h |    8 ++++++++
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index a4739a8..4ad88dd 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -57,6 +57,7 @@
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/io.h>
+#include <asm/kmemcheck.h>
 
 #include "mach_traps.h"
 
@@ -906,6 +907,14 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
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
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8bcb6f4..3717195 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 #include <asm/proto.h>
+#include <asm/kmemcheck.h>
 #include <asm-generic/sections.h>
 
 /*
@@ -604,6 +605,13 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	si_code = SEGV_MAPERR;
 
+	/*
+	 * Detect and handle instructions that would cause a page fault for
+	 * both a tracked kernel page and a userspace page.
+	 */
+	if(kmemcheck_active(regs))
+		kmemcheck_hide(regs);
+
 	if (notify_page_fault(regs))
 		return;
 
@@ -625,9 +633,13 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 #else
 	if (unlikely(address >= TASK_SIZE64)) {
 #endif
-		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
-		    vmalloc_fault(address) >= 0)
-			return;
+		if (!(error_code & (PF_RSVD | PF_USER | PF_PROT))) {
+			if (vmalloc_fault(address) >= 0)
+				return;
+
+			if (kmemcheck_fault(regs, address, error_code))
+				return;
+		}
 
 		/* Can handle a stale RO->RW TLB */
 		if (spurious_fault(address, error_code))
diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index b49369a..fade185 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -262,6 +262,14 @@ __asm__  __volatile__( \
  __constant_c_x_memset((s),(0x01010101UL*(unsigned char)(c)),(count)) : \
  __memset((s),(c),(count)))
 
+/* If kmemcheck is enabled, our best bet is a custom memset() that disables
+ * checking in order to save a whole lot of (unnecessary) page faults. */
+#ifdef CONFIG_KMEMCHECK
+void *kmemcheck_memset(void *s, int c, size_t n);
+#undef memset
+#define memset(s, c, n) kmemcheck_memset((s), (c), (n))
+#endif
+
 /*
  * find the first occurrence of byte 'c', or 1 past the area if none
  */
-- 
1.5.5.1

