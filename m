Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbXJDEDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbXJDEDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbXJDEAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:00:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53771 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbXJDEAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:00:05 -0400
Message-Id: <20071004040004.936534357@sgi.com>
References: <20071004035935.042951211@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Oct 2007 20:59:49 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ak@suse.de,
       travis@sgi.com
Subject: [14/18] Configure stack size
Content-Disposition: inline; filename=vcompound_x86_64_config_stack_size
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the stack size configurable now that we can fallback to vmalloc if
necessary. SGI NUMA configurations may need more stack because cpumasks
and nodemasks are at times kept on the stack. With the coming 16k cpu
support this is going to be 2k just for the mask. This patch allows to
run with 16k or 32k kernel stacks on x86_74.

Cc: ak@suse.de
Cc: travis@sgi.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86_64/Kconfig              |    6 ++++++
 include/asm-x86_64/page.h        |    3 +--
 include/asm-x86_64/thread_info.h |    4 ++--
 3 files changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86_64/Kconfig	2007-10-03 18:11:20.000000000 -0700
+++ linux-2.6/arch/x86_64/Kconfig	2007-10-03 18:12:13.000000000 -0700
@@ -363,6 +363,12 @@ config NODES_SHIFT
 	default "6"
 	depends on NEED_MULTIPLE_NODES
 
+config THREAD_ORDER
+	int "Kernel stack size (in page order)"
+	default "1"
+	help
+	  Page order for the thread stack.
+
 # Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
 
 config X86_64_ACPI_NUMA
Index: linux-2.6/include/asm-x86_64/page.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/page.h	2007-10-03 18:11:20.000000000 -0700
+++ linux-2.6/include/asm-x86_64/page.h	2007-10-03 18:12:13.000000000 -0700
@@ -9,8 +9,7 @@
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 #define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE-1) & __PHYSICAL_MASK)
 
-#define THREAD_ORDER 1 
-#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
+#define THREAD_SIZE  (PAGE_SIZE << CONFIG_THREAD_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE-1))
 
 #define EXCEPTION_STACK_ORDER 0
Index: linux-2.6/include/asm-x86_64/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/thread_info.h	2007-10-03 18:12:13.000000000 -0700
+++ linux-2.6/include/asm-x86_64/thread_info.h	2007-10-03 18:12:13.000000000 -0700
@@ -80,9 +80,9 @@ static inline struct thread_info *stack_
 #endif
 
 #define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+	((struct thread_info *) __get_free_pages(THREAD_FLAGS, CONFIG_THREAD_ORDER))
 
-#define free_thread_info(ti) free_pages((unsigned long) (ti), THREAD_ORDER)
+#define free_thread_info(ti) free_pages((unsigned long) (ti), CONFIG_THREAD_ORDER)
 
 #else /* !__ASSEMBLY__ */
 

-- 
