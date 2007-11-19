Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbXKSWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbXKSWCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbXKSWCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:02:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbXKSWCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:02:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 02/18] x86 vDSO: use vdso-syms.lds
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Zippy-Says: HERE!!  Put THIS on!!  I'm in CHARGE!!
Message-Id: <20071119220206.4CE4D26F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:02:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch changes the kernel's references to addresses in the vDSO image
to be based on the symbols defined by vdso-syms.lds instead of the old
vdso-syms.o symbols.  This is all wrapped up in a macro defined by the new
asm-x86/vdso.h header; that's the only place in the kernel source that has
to know the details of the scheme for getting vDSO symbol values.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/Makefile     |    3 +--
 arch/x86/vdso/vdso-start.S |    2 --
 arch/x86/vdso/vma.c        |   18 +++++++-----------
 include/asm-x86/vdso.h     |   14 ++++++++++++++
 4 files changed, 22 insertions(+), 15 deletions(-)
 delete mode 100644 arch/x86/vdso/vdso-start.S
 create mode 100644 include/asm-x86/vdso.h

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index d8200ad..d2ec170 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -3,8 +3,7 @@
 #
 
 # files to link into the vdso
-# vdso-start.o has to be first
-vobjs-y := vdso-start.o vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
+vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
 
 # files to link into kernel
 obj-y := vma.o vdso.o vdso-syms.o
diff --git a/arch/x86/vdso/vdso-start.S b/arch/x86/vdso/vdso-start.S
deleted file mode 100644
index 2dc2cdb..0000000
--- a/arch/x86/vdso/vdso-start.S
+++ /dev/null
@@ -1,2 +0,0 @@
-	.globl vdso_kernel_start
-vdso_kernel_start:
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index ff9333e..3fdd514 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -11,23 +11,20 @@
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
-#include "voffset.h"
+#include <asm/vdso.h>
 
-int vdso_enabled = 1;
-
-#define VEXTERN(x) extern typeof(__ ## x) *vdso_ ## x;
-#include "vextern.h"
+#include "vextern.h"		/* Just for VMAGIC.  */
 #undef VEXTERN
 
-extern char vdso_kernel_start[], vdso_start[], vdso_end[];
+int vdso_enabled = 1;
+
+extern char vdso_start[], vdso_end[];
 extern unsigned short vdso_sync_cpuid;
 
 struct page **vdso_pages;
 
-static inline void *var_ref(void *vbase, char *var, char *name)
+static inline void *var_ref(void *p, char *name)
 {
-	unsigned offset = var - &vdso_kernel_start[0] + VDSO_TEXT_OFFSET;
-	void *p = vbase + offset;
 	if (*(void **)p != (void *)VMAGIC) {
 		printk("VDSO: variable %s broken\n", name);
 		vdso_enabled = 0;
@@ -62,9 +59,8 @@ static int __init init_vdso_vars(void)
 		vdso_enabled = 0;
 	}
 
-#define V(x) *(typeof(x) *) var_ref(vbase, (char *)RELOC_HIDE(&x, 0), #x)
 #define VEXTERN(x) \
-	V(vdso_ ## x) = &__ ## x;
+	*(typeof(__ ## x) **) var_ref(VDSO64_SYMBOL(vbase, x), #x) = &__ ## x;
 #include "vextern.h"
 #undef VEXTERN
 	return 0;
diff --git a/include/asm-x86/vdso.h b/include/asm-x86/vdso.h
new file mode 100644
index 0000000..9379ec0
--- /dev/null
+++ b/include/asm-x86/vdso.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_X86_VDSO_H
+#define _ASM_X86_VDSO_H	1
+
+extern const char VDSO64_PRELINK[];
+
+/*
+ * Given a pointer to the vDSO image, find the pointer to VDSO64_name
+ * as that symbol is defined in the vDSO sources or linker script.
+ */
+#define VDSO64_SYMBOL(base, name) ({		\
+	extern const char VDSO64_##name[];	\
+	(void *) (VDSO64_##name - VDSO64_PRELINK + (unsigned long) (base)); })
+
+#endif	/* asm-x86/vdso.h */
