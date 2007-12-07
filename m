Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbXLGTIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbXLGTIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbXLGTH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:07:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbXLGTH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:07:27 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 3/3] [PATCH] remove arch specific segment headers
Date: Fri,  7 Dec 2007 14:22:42 -0200
Message-Id: <11970445893673-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1197044582338-git-send-email-gcosta@redhat.com>
References: <119704456265-git-send-email-gcosta@redhat.com> <11970445742522-git-send-email-gcosta@redhat.com> <1197044582338-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file puts the remainder of the arch specificic segment
headers in segment.h.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/segment.h    |  177 +++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/segment_32.h |  122 -----------------------------
 include/asm-x86/segment_64.h |   47 -----------
 3 files changed, 175 insertions(+), 171 deletions(-)

diff --git a/include/asm-x86/segment.h b/include/asm-x86/segment.h
index 3c9b306..c7509df 100644
--- a/include/asm-x86/segment.h
+++ b/include/asm-x86/segment.h
@@ -2,9 +2,182 @@
 #define _ASM_X86_SEGMENT_H_
 
 #ifdef CONFIG_X86_32
-# include "segment_32.h"
+/*
+ * The layout of the per-CPU GDT under Linux:
+ *
+ *   0 - null
+ *   1 - reserved
+ *   2 - reserved
+ *   3 - reserved
+ *
+ *   4 - unused			<==== new cacheline
+ *   5 - unused
+ *
+ *  ------- start of TLS (Thread-Local Storage) segments:
+ *
+ *   6 - TLS segment #1			[ glibc's TLS segment ]
+ *   7 - TLS segment #2			[ Wine's %fs Win32 segment ]
+ *   8 - TLS segment #3
+ *   9 - reserved
+ *  10 - reserved
+ *  11 - reserved
+ *
+ *  ------- start of kernel segments:
+ *
+ *  12 - kernel code segment		<==== new cacheline
+ *  13 - kernel data segment
+ *  14 - default user CS
+ *  15 - default user DS
+ *  16 - TSS
+ *  17 - LDT
+ *  18 - PNPBIOS support (16->32 gate)
+ *  19 - PNPBIOS support
+ *  20 - PNPBIOS support
+ *  21 - PNPBIOS support
+ *  22 - PNPBIOS support
+ *  23 - APM BIOS support
+ *  24 - APM BIOS support
+ *  25 - APM BIOS support
+ *
+ *  26 - ESPFIX small SS
+ *  27 - per-cpu			[ offset to per-cpu data area ]
+ *  28 - unused
+ *  29 - unused
+ *  30 - unused
+ *  31 - TSS for double fault handler
+ */
+#define GDT_ENTRY_TLS_MIN	6
+#define GDT_ENTRY_TLS_MAX 	(GDT_ENTRY_TLS_MIN + GDT_ENTRY_TLS_ENTRIES - 1)
+
+#define GDT_ENTRY_DEFAULT_USER_CS	14
+#define __USER_CS (GDT_ENTRY_DEFAULT_USER_CS * 8 + 3)
+
+#define GDT_ENTRY_DEFAULT_USER_DS	15
+#define __USER_DS (GDT_ENTRY_DEFAULT_USER_DS * 8 + 3)
+
+#define GDT_ENTRY_KERNEL_BASE	12
+
+#define GDT_ENTRY_KERNEL_CS		(GDT_ENTRY_KERNEL_BASE + 0)
+#define __KERNEL_CS (GDT_ENTRY_KERNEL_CS * 8)
+
+#define GDT_ENTRY_KERNEL_DS		(GDT_ENTRY_KERNEL_BASE + 1)
+#define __KERNEL_DS (GDT_ENTRY_KERNEL_DS * 8)
+
+#define GDT_ENTRY_TSS			(GDT_ENTRY_KERNEL_BASE + 4)
+#define GDT_ENTRY_LDT			(GDT_ENTRY_KERNEL_BASE + 5)
+
+#define GDT_ENTRY_PNPBIOS_BASE		(GDT_ENTRY_KERNEL_BASE + 6)
+#define GDT_ENTRY_APMBIOS_BASE		(GDT_ENTRY_KERNEL_BASE + 11)
+
+#define GDT_ENTRY_ESPFIX_SS		(GDT_ENTRY_KERNEL_BASE + 14)
+#define __ESPFIX_SS (GDT_ENTRY_ESPFIX_SS * 8)
+
+#define GDT_ENTRY_PERCPU			(GDT_ENTRY_KERNEL_BASE + 15)
+#ifdef CONFIG_SMP
+#define __KERNEL_PERCPU (GDT_ENTRY_PERCPU * 8)
+#else
+#define __KERNEL_PERCPU 0
+#endif
+
+#define GDT_ENTRY_DOUBLEFAULT_TSS	31
+
+/*
+ * The GDT has 32 entries
+ */
+#define GDT_ENTRIES 32
+
+/* Simple and small GDT entries for booting only */
+
+#define GDT_ENTRY_BOOT_CS		2
+#define __BOOT_CS	(GDT_ENTRY_BOOT_CS * 8)
+
+#define GDT_ENTRY_BOOT_DS		(GDT_ENTRY_BOOT_CS + 1)
+#define __BOOT_DS	(GDT_ENTRY_BOOT_DS * 8)
+
+/* The PnP BIOS entries in the GDT */
+#define GDT_ENTRY_PNPBIOS_CS32		(GDT_ENTRY_PNPBIOS_BASE + 0)
+#define GDT_ENTRY_PNPBIOS_CS16		(GDT_ENTRY_PNPBIOS_BASE + 1)
+#define GDT_ENTRY_PNPBIOS_DS		(GDT_ENTRY_PNPBIOS_BASE + 2)
+#define GDT_ENTRY_PNPBIOS_TS1		(GDT_ENTRY_PNPBIOS_BASE + 3)
+#define GDT_ENTRY_PNPBIOS_TS2		(GDT_ENTRY_PNPBIOS_BASE + 4)
+
+/* The PnP BIOS selectors */
+#define PNP_CS32   (GDT_ENTRY_PNPBIOS_CS32 * 8)	/* segment for calling fn */
+#define PNP_CS16   (GDT_ENTRY_PNPBIOS_CS16 * 8)	/* code segment for BIOS */
+#define PNP_DS     (GDT_ENTRY_PNPBIOS_DS * 8)	/* data segment for BIOS */
+#define PNP_TS1    (GDT_ENTRY_PNPBIOS_TS1 * 8)	/* transfer data segment */
+#define PNP_TS2    (GDT_ENTRY_PNPBIOS_TS2 * 8)	/* another data segment */
+
+/* Bottom two bits of selector give the ring privilege level */
+#define SEGMENT_RPL_MASK	0x3
+/* Bit 2 is table indicator (LDT/GDT) */
+#define SEGMENT_TI_MASK		0x4
+
+/* User mode is privilege level 3 */
+#define USER_RPL		0x3
+/* LDT segment has TI set, GDT has it cleared */
+#define SEGMENT_LDT		0x4
+#define SEGMENT_GDT		0x0
+
+/*
+ * Matching rules for certain types of segments.
+ */
+
+/* Matches only __KERNEL_CS, ignoring PnP / USER / APM segments */
+#define SEGMENT_IS_KERNEL_CODE(x) (((x) & 0xfc) == GDT_ENTRY_KERNEL_CS * 8)
+
+/* Matches __KERNEL_CS and __USER_CS (they must be 2 entries apart) */
+#define SEGMENT_IS_FLAT_CODE(x)  (((x) & 0xec) == GDT_ENTRY_KERNEL_CS * 8)
+
+/* Matches PNP_CS32 and PNP_CS16 (they must be consecutive) */
+#define SEGMENT_IS_PNP_CODE(x)   (((x) & 0xf4) == GDT_ENTRY_PNPBIOS_BASE * 8)
+
+
 #else
-# include "segment_64.h"
+#include <asm/cache.h>
+
+/* Simple and small GDT entries for booting only */
+
+#define GDT_ENTRY_BOOT_CS		2
+#define __BOOT_CS	(GDT_ENTRY_BOOT_CS * 8)
+
+#define GDT_ENTRY_BOOT_DS		(GDT_ENTRY_BOOT_CS + 1)
+#define __BOOT_DS	(GDT_ENTRY_BOOT_DS * 8)
+
+#define __KERNEL_CS	0x10
+#define __KERNEL_DS	0x18
+
+#define __KERNEL32_CS   0x08
+
+/*
+ * we cannot use the same code segment descriptor for user and kernel
+ * -- not even in the long flat mode, because of different DPL /kkeil
+ * The segment offset needs to contain a RPL. Grr. -AK
+ * GDT layout to get 64bit syscall right (sysret hardcodes gdt offsets)
+ */
+
+#define __USER32_CS   0x23   /* 4*8+3 */
+#define __USER_DS     0x2b   /* 5*8+3 */
+#define __USER_CS     0x33   /* 6*8+3 */
+#define __USER32_DS	__USER_DS
+
+#define GDT_ENTRY_TSS 8	/* needs two entries */
+#define GDT_ENTRY_LDT 10 /* needs two entries */
+#define GDT_ENTRY_TLS_MIN 12
+#define GDT_ENTRY_TLS_MAX 14
+
+#define GDT_ENTRY_PER_CPU 15	/* Abused to load per CPU data from limit */
+#define __PER_CPU_SEG	(GDT_ENTRY_PER_CPU * 8 + 3)
+
+/* TLS indexes for 64bit - hardcoded in arch_prctl */
+#define FS_TLS 0
+#define GS_TLS 1
+
+#define GS_TLS_SEL ((GDT_ENTRY_TLS_MIN+GS_TLS)*8 + 3)
+#define FS_TLS_SEL ((GDT_ENTRY_TLS_MIN+FS_TLS)*8 + 3)
+
+#define GDT_ENTRIES 16
+
 #endif
 
 #ifndef CONFIG_PARAVIRT
diff --git a/include/asm-x86/segment_32.h b/include/asm-x86/segment_32.h
index 3e133ad..8b13789 100644
--- a/include/asm-x86/segment_32.h
+++ b/include/asm-x86/segment_32.h
@@ -1,123 +1 @@
-#ifndef _ASM_SEGMENT_H
-#define _ASM_SEGMENT_H
 
-/*
- * The layout of the per-CPU GDT under Linux:
- *
- *   0 - null
- *   1 - reserved
- *   2 - reserved
- *   3 - reserved
- *
- *   4 - unused			<==== new cacheline
- *   5 - unused
- *
- *  ------- start of TLS (Thread-Local Storage) segments:
- *
- *   6 - TLS segment #1			[ glibc's TLS segment ]
- *   7 - TLS segment #2			[ Wine's %fs Win32 segment ]
- *   8 - TLS segment #3
- *   9 - reserved
- *  10 - reserved
- *  11 - reserved
- *
- *  ------- start of kernel segments:
- *
- *  12 - kernel code segment		<==== new cacheline
- *  13 - kernel data segment
- *  14 - default user CS
- *  15 - default user DS
- *  16 - TSS
- *  17 - LDT
- *  18 - PNPBIOS support (16->32 gate)
- *  19 - PNPBIOS support
- *  20 - PNPBIOS support
- *  21 - PNPBIOS support
- *  22 - PNPBIOS support
- *  23 - APM BIOS support
- *  24 - APM BIOS support
- *  25 - APM BIOS support 
- *
- *  26 - ESPFIX small SS
- *  27 - per-cpu			[ offset to per-cpu data area ]
- *  28 - unused
- *  29 - unused
- *  30 - unused
- *  31 - TSS for double fault handler
- */
-#define GDT_ENTRY_TLS_MIN	6
-#define GDT_ENTRY_TLS_MAX 	(GDT_ENTRY_TLS_MIN + GDT_ENTRY_TLS_ENTRIES - 1)
-
-#define GDT_ENTRY_DEFAULT_USER_CS	14
-#define __USER_CS (GDT_ENTRY_DEFAULT_USER_CS * 8 + 3)
-
-#define GDT_ENTRY_DEFAULT_USER_DS	15
-#define __USER_DS (GDT_ENTRY_DEFAULT_USER_DS * 8 + 3)
-
-#define GDT_ENTRY_KERNEL_BASE	12
-
-#define GDT_ENTRY_KERNEL_CS		(GDT_ENTRY_KERNEL_BASE + 0)
-#define __KERNEL_CS (GDT_ENTRY_KERNEL_CS * 8)
-
-#define GDT_ENTRY_KERNEL_DS		(GDT_ENTRY_KERNEL_BASE + 1)
-#define __KERNEL_DS (GDT_ENTRY_KERNEL_DS * 8)
-
-#define GDT_ENTRY_TSS			(GDT_ENTRY_KERNEL_BASE + 4)
-#define GDT_ENTRY_LDT			(GDT_ENTRY_KERNEL_BASE + 5)
-
-#define GDT_ENTRY_PNPBIOS_BASE		(GDT_ENTRY_KERNEL_BASE + 6)
-#define GDT_ENTRY_APMBIOS_BASE		(GDT_ENTRY_KERNEL_BASE + 11)
-
-#define GDT_ENTRY_ESPFIX_SS		(GDT_ENTRY_KERNEL_BASE + 14)
-#define __ESPFIX_SS (GDT_ENTRY_ESPFIX_SS * 8)
-
-#define GDT_ENTRY_PERCPU			(GDT_ENTRY_KERNEL_BASE + 15)
-#ifdef CONFIG_SMP
-#define __KERNEL_PERCPU (GDT_ENTRY_PERCPU * 8)
-#else
-#define __KERNEL_PERCPU 0
-#endif
-
-#define GDT_ENTRY_DOUBLEFAULT_TSS	31
-
-/*
- * The GDT has 32 entries
- */
-#define GDT_ENTRIES 32
-
-/* Simple and small GDT entries for booting only */
-
-#define GDT_ENTRY_BOOT_CS		2
-#define __BOOT_CS	(GDT_ENTRY_BOOT_CS * 8)
-
-#define GDT_ENTRY_BOOT_DS		(GDT_ENTRY_BOOT_CS + 1)
-#define __BOOT_DS	(GDT_ENTRY_BOOT_DS * 8)
-
-/* The PnP BIOS entries in the GDT */
-#define GDT_ENTRY_PNPBIOS_CS32		(GDT_ENTRY_PNPBIOS_BASE + 0)
-#define GDT_ENTRY_PNPBIOS_CS16		(GDT_ENTRY_PNPBIOS_BASE + 1)
-#define GDT_ENTRY_PNPBIOS_DS		(GDT_ENTRY_PNPBIOS_BASE + 2)
-#define GDT_ENTRY_PNPBIOS_TS1		(GDT_ENTRY_PNPBIOS_BASE + 3)
-#define GDT_ENTRY_PNPBIOS_TS2		(GDT_ENTRY_PNPBIOS_BASE + 4)
-
-/* The PnP BIOS selectors */
-#define PNP_CS32   (GDT_ENTRY_PNPBIOS_CS32 * 8)	/* segment for calling fn */
-#define PNP_CS16   (GDT_ENTRY_PNPBIOS_CS16 * 8)	/* code segment for BIOS */
-#define PNP_DS     (GDT_ENTRY_PNPBIOS_DS * 8)	/* data segment for BIOS */
-#define PNP_TS1    (GDT_ENTRY_PNPBIOS_TS1 * 8)	/* transfer data segment */
-#define PNP_TS2    (GDT_ENTRY_PNPBIOS_TS2 * 8)	/* another data segment */
-
-/*
- * Matching rules for certain types of segments.
- */
-
-/* Matches only __KERNEL_CS, ignoring PnP / USER / APM segments */
-#define SEGMENT_IS_KERNEL_CODE(x) (((x) & 0xfc) == GDT_ENTRY_KERNEL_CS * 8)
-
-/* Matches __KERNEL_CS and __USER_CS (they must be 2 entries apart) */
-#define SEGMENT_IS_FLAT_CODE(x)  (((x) & 0xec) == GDT_ENTRY_KERNEL_CS * 8)
-
-/* Matches PNP_CS32 and PNP_CS16 (they must be consecutive) */
-#define SEGMENT_IS_PNP_CODE(x)   (((x) & 0xf4) == GDT_ENTRY_PNPBIOS_BASE * 8)
-
-#endif
diff --git a/include/asm-x86/segment_64.h b/include/asm-x86/segment_64.h
deleted file mode 100644
index 5cc7deb..0000000
--- a/include/asm-x86/segment_64.h
+++ /dev/null
@@ -1,47 +0,0 @@
-#ifndef _ASM_SEGMENT_H
-#define _ASM_SEGMENT_H
-
-#include <asm/cache.h>
-
-/* Simple and small GDT entries for booting only */
-
-#define GDT_ENTRY_BOOT_CS		2
-#define __BOOT_CS	(GDT_ENTRY_BOOT_CS * 8)
-
-#define GDT_ENTRY_BOOT_DS		(GDT_ENTRY_BOOT_CS + 1)
-#define __BOOT_DS	(GDT_ENTRY_BOOT_DS * 8)
-
-#define __KERNEL_CS	0x10
-#define __KERNEL_DS	0x18
-
-#define __KERNEL32_CS   0x08
-
-/* 
- * we cannot use the same code segment descriptor for user and kernel
- * -- not even in the long flat mode, because of different DPL /kkeil 
- * The segment offset needs to contain a RPL. Grr. -AK
- * GDT layout to get 64bit syscall right (sysret hardcodes gdt offsets) 
- */
-
-#define __USER32_CS   0x23   /* 4*8+3 */ 
-#define __USER_DS     0x2b   /* 5*8+3 */ 
-#define __USER_CS     0x33   /* 6*8+3 */ 
-#define __USER32_DS	__USER_DS 
-
-#define GDT_ENTRY_TSS 8	/* needs two entries */
-#define GDT_ENTRY_LDT 10 /* needs two entries */
-#define GDT_ENTRY_TLS_MIN 12
-#define GDT_ENTRY_TLS_MAX 14
-
-#define GDT_ENTRY_PER_CPU 15	/* Abused to load per CPU data from limit */
-#define __PER_CPU_SEG	(GDT_ENTRY_PER_CPU * 8 + 3)
-
-/* TLS indexes for 64bit - hardcoded in arch_prctl */
-#define FS_TLS 0	
-#define GS_TLS 1	
-
-#define GS_TLS_SEL ((GDT_ENTRY_TLS_MIN+GS_TLS)*8 + 3)
-#define FS_TLS_SEL ((GDT_ENTRY_TLS_MIN+FS_TLS)*8 + 3)
-
-#define GDT_ENTRIES 16
-#endif
-- 
1.4.4.2

