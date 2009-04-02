Return-Path: <linux-kernel-owner+w=401wt.eu-S1765503AbZDBQex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765503AbZDBQex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760775AbZDBQen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:34:43 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:55562 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150AbZDBQel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TVUo1quyJpm2Tj2I1zukBnhPptI6Co841K3gl0vQcyupnqHmc6WHEkBWcaxKVsYPAJ
         1llmx3hX96fYATrilUeavKN5qXszZgWsbh1tQGbgfHleUKPKbxkusskLjpc1zMaudzNB
         b50XtZPcEAWodZKbu59PHcU40SAlQpPESHG6g=
Date: Fri, 3 Apr 2009 01:31:52 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org
Subject: [PATCH] build fix for generic debug pagealloc
Message-ID: <20090402163145.GA28728@localhost.localdomain>
References: <a4423d670904020421k7395e11dwe70d4223cb817e0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <a4423d670904020421k7395e11dwe70d4223cb817e0a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> mm/debug-pagealloc.c: In function 'set_page_poison':
> mm/debug-pagealloc.c:8: error: 'struct page' has no member named 'debug_flags'
> mm/debug-pagealloc.c: In function 'clear_page_poison':
> mm/debug-pagealloc.c:13: error: 'struct page' has no member named 'debug_flags'
> mm/debug-pagealloc.c: In function 'page_poison':
> mm/debug-pagealloc.c:18: error: 'struct page' has no member named 'debug_flags'
> mm/debug-pagealloc.c: At top level:
> mm/debug-pagealloc.c:120: error: redefinition of 'kernel_map_pages'
> include/linux/mm.h:1278: error: previous definition of
> 'kernel_map_pages' was here
> mm/debug-pagealloc.c: In function 'kernel_map_pages':
> mm/debug-pagealloc.c:122: error: 'debug_pagealloc_enabled' undeclared
> (first use in this function)

This patch fixes build failure with generic debug pagealloc:

 - debug_flags should be in struct page
 - define DEBUG_PAGEALLOC config option for all architectures

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 arch/powerpc/Kconfig.debug |   10 ----------
 arch/s390/Kconfig.debug    |    9 ---------
 arch/sparc/Kconfig.debug   |    9 ---------
 arch/x86/Kconfig.debug     |    9 ---------
 include/linux/mm_types.h   |    6 +++---
 mm/Kconfig.debug           |    9 +++++++++
 6 files changed, 12 insertions(+), 40 deletions(-)

diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index 6aa0b5e..a1098e2 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -27,16 +27,6 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
-config DEBUG_PAGEALLOC
-        bool "Debug page memory allocations"
-        depends on DEBUG_KERNEL && !HIBERNATION
-	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
-        help
-          Unmap pages from the kernel linear mapping after free_pages().
-          This results in a large slowdown, but helps to find certain types
-          of memory corruptions.
-
-
 config HCALL_STATS
 	bool "Hypervisor call instrumentation"
 	depends on PPC_PSERIES && DEBUG_FS
diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
index 7e297a3..2283933 100644
--- a/arch/s390/Kconfig.debug
+++ b/arch/s390/Kconfig.debug
@@ -6,13 +6,4 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config DEBUG_PAGEALLOC
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL
-	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	help
-	  Unmap pages from the kernel linear mapping after free_pages().
-	  This results in a slowdown, but helps to find certain types of
-	  memory corruptions.
-
 endmenu
diff --git a/arch/sparc/Kconfig.debug b/arch/sparc/Kconfig.debug
index d001b42..90d5fe2 100644
--- a/arch/sparc/Kconfig.debug
+++ b/arch/sparc/Kconfig.debug
@@ -22,15 +22,6 @@ config DEBUG_DCFLUSH
 config STACK_DEBUG
 	bool "Stack Overflow Detection Support"
 
-config DEBUG_PAGEALLOC
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && !HIBERNATION
-	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	help
-	  Unmap pages from the kernel linear mapping after free_pages().
-	  This results in a large slowdown, but helps to find certain types
-	  of memory corruptions.
-
 config MCOUNT
 	bool
 	depends on SPARC64
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index a345cb5..d8359e7 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -72,15 +72,6 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
-config DEBUG_PAGEALLOC
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL
-	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	---help---
-	  Unmap pages from the kernel linear mapping after free_pages().
-	  This results in a large slowdown, but helps to find certain types
-	  of memory corruptions.
-
 config DEBUG_PER_CPU_MAPS
 	bool "Debug access to per_cpu maps"
 	depends on DEBUG_KERNEL
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ddadb4d..0e80e26 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -95,6 +95,9 @@ struct page {
 	void *virtual;			/* Kernel virtual address (NULL if
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
+#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
+	unsigned long debug_flags;	/* Use atomic bitops on this */
+#endif
 };
 
 /*
@@ -175,9 +178,6 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
 #endif
-#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
-	unsigned long debug_flags;	/* Use atomic bitops on this */
-#endif
 };
 
 struct core_thread {
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index c8d62d4..bb01e29 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -1,3 +1,12 @@
+config DEBUG_PAGEALLOC
+	bool "Debug page memory allocations"
+	depends on DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	depends on !HIBERNATION || !PPC && !SPARC
+	---help---
+	  Unmap pages from the kernel linear mapping after free_pages().
+	  This results in a large slowdown, but helps to find certain types
+	  of memory corruptions.
+
 config WANT_PAGE_DEBUG_FLAGS
 	bool
 
