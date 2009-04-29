Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbZD2JFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbZD2JFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZD2JFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:05:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:60418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbZD2JFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:05:07 -0400
Date: Wed, 29 Apr 2009 09:03:42 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-2-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-2-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: unify header/footer
Message-ID: <tip-17ce265d6a1789eae5eb739a3bb7fcffdb3e87c5@git.kernel.org>
Git-Commit-ID: 17ce265d6a1789eae5eb739a3bb7fcffdb3e87c5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:03:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17ce265d6a1789eae5eb739a3bb7fcffdb3e87c5
Gitweb:     http://git.kernel.org/tip/17ce265d6a1789eae5eb739a3bb7fcffdb3e87c5
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Wed, 29 Apr 2009 09:47:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 10:20:29 +0200

x86, vmlinux.lds: unify header/footer

Merge everything except PHDRS and SECTIONS into
vmlinux.lds.S.

[ Impact: cleanup ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-2-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S    |   77 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |   37 ------------------
 arch/x86/kernel/vmlinux_64.lds.S |   42 --------------------
 3 files changed, 77 insertions(+), 79 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 849ee61..d113642 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -1,5 +1,82 @@
+/*
+ * ld script for the x86 kernel
+ *
+ * Historic 32-bit version written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
+ *
+ * Modernisation and unification done by Sam Ravnborg <sam@ravnborg.org>
+ *
+ *
+ * Don't define absolute symbols until and unless you know that symbol
+ * value is should remain constant even if kernel image is relocated
+ * at run time. Absolute symbols are not relocated. If symbol value should
+ * change if kernel is relocated, make the symbol section relative and
+ * put it inside the section definition.
+ */
+
+#ifdef CONFIG_X86_32
+#define LOAD_OFFSET __PAGE_OFFSET
+#else
+#define LOAD_OFFSET __START_KERNEL_map
+#endif
+
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+#include <asm/page_types.h>
+#include <asm/cache.h>
+#include <asm/boot.h>
+
+#undef i386     /* in case the preprocessor is a 32bit one */
+
+OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
+
+#ifdef CONFIG_X86_32
+OUTPUT_ARCH(i386)
+ENTRY(phys_startup_32)
+jiffies = jiffies_64;
+#else
+OUTPUT_ARCH(i386:x86-64)
+ENTRY(phys_startup_64)
+jiffies_64 = jiffies;
+#endif
+
+
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
 #else
 # include "vmlinux_64.lds.S"
 #endif
+
+
+#ifdef CONFIG_X86_32
+ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
+        "kernel image bigger than KERNEL_IMAGE_SIZE")
+#else
+/*
+ * Per-cpu symbols which need to be offset from __per_cpu_load
+ * for the boot processor.
+ */
+#define INIT_PER_CPU(x) init_per_cpu__##x = per_cpu__##x + __per_cpu_load
+INIT_PER_CPU(gdt_page);
+INIT_PER_CPU(irq_stack_union);
+
+/*
+ * Build-time check on the image size:
+ */
+ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
+	"kernel image bigger than KERNEL_IMAGE_SIZE")
+
+#ifdef CONFIG_SMP
+ASSERT((per_cpu__irq_stack_union == 0),
+        "irq_stack_union is not at start of per-cpu area");
+#endif
+
+#endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_KEXEC
+#include <asm/kexec.h>
+
+ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
+       "kexec control code size is too big")
+#endif
+
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index fffa45a..4c985fc 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,26 +1,3 @@
-/* ld script to make i386 Linux kernel
- * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>;
- *
- * Don't define absolute symbols until and unless you know that symbol
- * value is should remain constant even if kernel image is relocated
- * at run time. Absolute symbols are not relocated. If symbol value should
- * change if kernel is relocated, make the symbol section relative and
- * put it inside the section definition.
- */
-
-#define LOAD_OFFSET __PAGE_OFFSET
-
-#include <asm-generic/vmlinux.lds.h>
-#include <asm/thread_info.h>
-#include <asm/page_types.h>
-#include <asm/cache.h>
-#include <asm/boot.h>
-
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
-OUTPUT_ARCH(i386)
-ENTRY(phys_startup_32)
-jiffies = jiffies_64;
-
 PHDRS {
 	text PT_LOAD FLAGS(5);		/* R_E */
 	data PT_LOAD FLAGS(7);		/* RWE */
@@ -237,17 +214,3 @@ SECTIONS
 	STABS_DEBUG
 	DWARF_DEBUG
 }
-
-/*
- * Build-time check on the image size:
- */
-ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
-	"kernel image bigger than KERNEL_IMAGE_SIZE")
-
-#ifdef CONFIG_KEXEC
-/* Link time checks */
-#include <asm/kexec.h>
-
-ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
-       "kexec control code size is too big")
-#endif
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 6d5a5b0..7f1cc3d 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,19 +1,3 @@
-/* ld script to make x86-64 Linux kernel
- * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>;
- */
-
-#define LOAD_OFFSET __START_KERNEL_map
-
-#include <asm-generic/vmlinux.lds.h>
-#include <asm/asm-offsets.h>
-#include <asm/page_types.h>
-
-#undef i386	/* in case the preprocessor is a 32bit one */
-
-OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
-OUTPUT_ARCH(i386:x86-64)
-ENTRY(phys_startup_64)
-jiffies_64 = jiffies;
 PHDRS {
 	text PT_LOAD FLAGS(5);		/* R_E */
 	data PT_LOAD FLAGS(7);		/* RWE */
@@ -308,29 +292,3 @@ SECTIONS
 	STABS_DEBUG
 	DWARF_DEBUG
 }
-
-/*
- * Per-cpu symbols which need to be offset from __per_cpu_load
- * for the boot processor.
- */
-#define INIT_PER_CPU(x) init_per_cpu__##x = per_cpu__##x + __per_cpu_load
-INIT_PER_CPU(gdt_page);
-INIT_PER_CPU(irq_stack_union);
-
-/*
- * Build-time check on the image size:
- */
-ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
-	"kernel image bigger than KERNEL_IMAGE_SIZE")
-
-#ifdef CONFIG_SMP
-ASSERT((per_cpu__irq_stack_union == 0),
-        "irq_stack_union is not at start of per-cpu area");
-#endif
-
-#ifdef CONFIG_KEXEC
-#include <asm/kexec.h>
-
-ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
-       "kexec control code size is too big")
-#endif
