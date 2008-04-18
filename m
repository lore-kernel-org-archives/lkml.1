Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbYDRHtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbYDRHtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758564AbYDRHtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:49:02 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:31471 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336AbYDRHtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:49:00 -0400
Date: Fri, 18 Apr 2008 03:48:59 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       tony.luck@intel.com
Subject: [PATCH 2/2] kallsyms: move get_func_addr to <asm/processor.h>
Message-ID: <20080418074859.GD16276@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging something on parisc a few weeks ago, I noticed
kallsyms was all busted because print_symbol was printing the
descriptor address. Since we don't use addr[0] for the function
address, and we don't want a mess of #ifdef ARCH1 #elseif ARCH2
garbage, move the definitions to <asm/processor.h>

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
---
 include/asm-ia64/processor.h    |    6 ++++++
 include/asm-parisc/processor.h  |    8 ++++++++
 include/asm-powerpc/processor.h |    8 ++++++++
 include/linux/kallsyms.h        |   13 ++++---------
 4 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/include/asm-ia64/processor.h b/include/asm-ia64/processor.h
index 741f7ec..9edbf0e 100644
--- a/include/asm-ia64/processor.h
+++ b/include/asm-ia64/processor.h
@@ -701,6 +701,12 @@ prefetchw (const void *x)
 
 extern unsigned long boot_option_idle_override;
 
+#define get_func_addr(x)	({	\
+					unsigned long *addr =	\
+						(unsigned long *)x;	\
+					addr[0];	\
+				})
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_IA64_PROCESSOR_H */
diff --git a/include/asm-parisc/processor.h b/include/asm-parisc/processor.h
index 3c9d348..a82c122 100644
--- a/include/asm-parisc/processor.h
+++ b/include/asm-parisc/processor.h
@@ -352,6 +352,14 @@ static inline int parisc_requires_coherency(void)
 #endif
 }
 
+#ifdef CONFIG_64BIT
+#define get_func_addr(x)	({	\
+					unsigned long *addr =	\
+						(unsigned long *)x;	\
+					addr[2];	\
+				})
+#endif /*CONFIG_64BIT*/
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __ASM_PARISC_PROCESSOR_H */
diff --git a/include/asm-powerpc/processor.h b/include/asm-powerpc/processor.h
index fd98ca9..604ad95 100644
--- a/include/asm-powerpc/processor.h
+++ b/include/asm-powerpc/processor.h
@@ -281,6 +281,14 @@ static inline void prefetchw(const void *x)
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 #endif
 
+#ifdef CONFIG_PPC64
+#define get_func_addr(x)	({	\
+					unsigned long *addr =	\
+						(unsigned long *)x;	\
+					addr[0];	\
+				})
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_PROCESSOR_H */
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 6734a3f..9259d1f 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -8,6 +8,8 @@
 #include <linux/errno.h>
 #include <linux/stddef.h>
 
+#include <asm/processor.h>
+
 #define KSYM_NAME_LEN 128
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
 			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
@@ -84,16 +86,9 @@ static inline void __check_printsym_format(const char *fmt, ...)
 {
 }
 
-/* ia64 and ppc64 use function descriptors, which contain the real address */
-#if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
-#define get_func_addr(x)	({				\
-					unsigned long *addr =	\
-						(unsigned long *)x;	\
-					addr[0];		\
-				})
-#else
+#ifndef get_func_addr
 #define get_func_addr(x)	x
-#endif
+#endif /*get_func_addr*/
 
 #define print_fn_descriptor_symbol(fmt, addr)	\
 		print_symbol(fmt, get_func_addr(addr))
-- 
1.5.4.5

