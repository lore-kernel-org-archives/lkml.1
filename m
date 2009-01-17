Return-Path: <linux-kernel-owner+w=401wt.eu-S1765127AbZAQQcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765127AbZAQQcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762729AbZAQQcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:32:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:59687 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762726AbZAQQcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:32:02 -0500
Subject: [GIT PULL -tip] x86: fix 22 make headers_check warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 22:00:56 +0530
Message-Id: <1232209856.3388.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

The following changes since commit 206e00df0967f6e91d792df7f1d4ff352eb42f8f:
  Ingo Molnar (1):
        Merge branch 'x86/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master

Jaswinder Singh Rajput (8):
      x86: boot.h fix make headers_check
      x86: e820.h fix make headers_check
      x86: kvm.h fix make headers_check
      x86: mce.h fix make headers_check
      x86: mtrr.h fix make headers_check
      x86: ptrace-abi.h fix make headers_check
      x86: sigcontext.h fix make headers_check
      x86: swab.h fix make headers_check

 arch/x86/include/asm/boot.h       |    2 ++
 arch/x86/include/asm/e820.h       |   11 ++++++++---
 arch/x86/include/asm/kvm.h        |    2 +-
 arch/x86/include/asm/mce.h        |    5 +----
 arch/x86/include/asm/mtrr.h       |    1 +
 arch/x86/include/asm/ptrace-abi.h |    5 ++++-
 arch/x86/include/asm/sigcontext.h |    2 +-
 arch/x86/include/asm/swab.h       |   21 +++++++++++++++++++--
 8 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index dd61616..036b108 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -10,6 +10,7 @@
 #define EXTENDED_VGA	0xfffe		/* 80x50 mode */
 #define ASK_VGA		0xfffd		/* ask for it at bootup */
 
+#ifdef __KERNEL__
 /* Physical address where kernel should be loaded. */
 #define LOAD_PHYSICAL_ADDR ((CONFIG_PHYSICAL_START \
 				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
@@ -22,5 +23,6 @@
 #define BOOT_HEAP_SIZE	0x4000
 #define BOOT_STACK_SIZE	0x1000
 #endif
+#endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_BOOT_H */
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 3d8cedd..c026014 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -5,8 +5,12 @@
 
 /*
  * Legacy E820 BIOS limits us to 128 (E820MAX) nodes due to the
- * constrained space in the zeropage.  If we have more nodes than
- * that, and if we've booted off EFI firmware, then the EFI tables
+ * constrained space in the zeropage.
+ */
+
+#ifdef __KERNEL__
+/* If we have more nodes than that, and if we have
+ * booted off EFI firmware, then the EFI tables
  * passed us from the EFI firmware can list more nodes.  Size our
  * internal memory map tables to have room for these additional
  * nodes, based on up to three entries per node for which the
@@ -26,7 +30,6 @@
  * to collapse the next two #ifdef lines to a single line:
  *	#if defined(__KERNEL__) && defined(CONFIG_EFI)
  */
-#ifdef __KERNEL__
 #ifdef CONFIG_EFI
 #include <linux/numa.h>
 #define E820_X_MAX (E820MAX + 3 * MAX_NUMNODES)
@@ -49,6 +52,8 @@
 #define E820_RESERVED_KERN        128
 
 #ifndef __ASSEMBLY__
+#include <linux/types.h>
+
 struct e820entry {
 	__u64 addr;	/* start of memory segment */
 	__u64 size;	/* size of memory segment */
diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index b95162a..d2e3bf3 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -6,7 +6,7 @@
  *
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/ioctl.h>
 
 /* Architectural interrupt line count. */
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 1d6e17c..32c6e17 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -3,8 +3,8 @@
 
 #ifdef __x86_64__
 
+#include <linux/types.h>
 #include <asm/ioctls.h>
-#include <asm/types.h>
 
 /*
  * Machine Check support for x86
@@ -115,8 +115,6 @@ extern int mce_notify_user(void);
 
 #endif /* !CONFIG_X86_32 */
 
-
-
 #ifdef CONFIG_X86_MCE
 extern void mcheck_init(struct cpuinfo_x86 *c);
 #else
@@ -126,5 +124,4 @@ extern void stop_mce(void);
 extern void restart_mce(void);
 
 #endif /* __KERNEL__ */
-
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 14080d2..a51ada8 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -23,6 +23,7 @@
 #ifndef _ASM_X86_MTRR_H
 #define _ASM_X86_MTRR_H
 
+#include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/errno.h>
 
diff --git a/arch/x86/include/asm/ptrace-abi.h b/arch/x86/include/asm/ptrace-abi.h
index 25f1bb8..ea32e40 100644
--- a/arch/x86/include/asm/ptrace-abi.h
+++ b/arch/x86/include/asm/ptrace-abi.h
@@ -80,10 +80,12 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
+#ifdef __KERNEL__
+
 #ifdef CONFIG_X86_PTRACE_BTS
 
 #ifndef __ASSEMBLY__
-#include <asm/types.h>
+#include <linux/types.h>
 
 /* configuration/status structure used in PTRACE_BTS_CONFIG and
    PTRACE_BTS_STATUS commands.
@@ -141,5 +143,6 @@ struct ptrace_bts_config {
    Returns number of BTS records drained.
 */
 #endif /* CONFIG_X86_PTRACE_BTS */
+#endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_PTRACE_ABI_H */
diff --git a/arch/x86/include/asm/sigcontext.h b/arch/x86/include/asm/sigcontext.h
index 0afcb5e..ec66649 100644
--- a/arch/x86/include/asm/sigcontext.h
+++ b/arch/x86/include/asm/sigcontext.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_SIGCONTEXT_H
 
 #include <linux/compiler.h>
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define FP_XSTATE_MAGIC1	0x46505853U
 #define FP_XSTATE_MAGIC2	0x46505845U
diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
index 306d417..613be68 100644
--- a/arch/x86/include/asm/swab.h
+++ b/arch/x86/include/asm/swab.h
@@ -1,12 +1,15 @@
 #ifndef _ASM_X86_SWAB_H
 #define _ASM_X86_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
+#ifdef __KERNEL__
 #include <linux/compiler.h>
+#endif /* __KERNEL__ */
 
 static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 #ifdef __i386__
+#ifdef __KERNEL__
 # ifdef CONFIG_X86_BSWAP
 	asm("bswap %0" : "=r" (val) : "0" (val));
 # else
@@ -16,7 +19,13 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 	    : "=q" (val)
 	    : "0" (val));
 # endif
-
+#else /* __KERNEL__ */
+	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
+	    "rorl $16,%0\n\t"	/* swap words		*/
+	    "xchgb %b0,%h0"	/* swap higher bytes	*/
+	    : "=q" (val)
+	    : "0" (val));
+#endif /* __KERNEL__ */
 #else /* __i386__ */
 	asm("bswapl %0"
 	    : "=r" (val)
@@ -37,6 +46,7 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 		__u64 u;
 	} v;
 	v.u = val;
+#ifdef __KERNEL__
 # ifdef CONFIG_X86_BSWAP
 	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
@@ -48,6 +58,13 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
 # endif
+#else /* __KERNEL__ */
+	v.s.a = __arch_swab32(v.s.a);
+	v.s.b = __arch_swab32(v.s.b);
+	asm("xchgl %0,%1"
+	    : "=r" (v.s.a), "=r" (v.s.b)
+	    : "0" (v.s.a), "1" (v.s.b));
+#endif /* __KERNEL__ */
 	return v.u;
 #else /* __i386__ */
 	asm("bswapq %0"


