Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbYIANWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbYIANWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYIANV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:21:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:41088 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYIANV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:21:57 -0400
Subject: [RFC] Unify asm/statfs.h
From: David Woodhouse <dwmw2@infradead.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 01 Sep 2008 14:21:54 +0100
Message-Id: <1220275314.2982.83.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment, all 64-bit platforms except Alpha are redefining
everything in <asm/statfs.h>, because their definitions are different.

At the cost of an #ifdef defining a local type, we can make it useful
for just about all architectures, as is done at {git://,http://}
git.infradead.org/users/dwmw2/statfs-2.6.git

The exceptions are MIPS, which has its fields in a different order, and
S390, which mixes types of different sizes in its struct statfs --
although we could probably cope with the latter, if we really want to.

 arch/sparc/include/asm/statfs_32.h  |    6 ---
 arch/sparc/include/asm/statfs_64.h  |   54 -----------------------------
 b/arch/alpha/include/asm/statfs.h   |    4 ++
 b/arch/arm/include/asm/statfs.h     |   34 +-----------------
 b/arch/ia64/include/asm/statfs.h    |   52 ++--------------------------
 b/arch/powerpc/include/asm/statfs.h |   54 -----------------------------
 b/arch/s390/include/asm/statfs.h    |   11 ++----
 b/arch/sparc/include/asm/statfs.h   |    8 +---
 b/include/asm-generic/statfs.h      |   65 ++++++++++++++++++++++++++----------
 b/include/asm-parisc/statfs.h       |   55 +-----------------------------
 b/include/asm-x86/statfs.h          |   61 ++-------------------------------
 11 files changed, 73 insertions(+), 331 deletions(-)

diff --git a/include/asm-generic/statfs.h b/include/asm-generic/statfs.h
index 1d01043..68b6d69 100644
--- a/include/asm-generic/statfs.h
+++ b/include/asm-generic/statfs.h
@@ -6,33 +6,64 @@
 typedef __kernel_fsid_t	fsid_t;
 #endif
 
+/*
+ * Most 64-bit platforms use 'long', while most 32-bit platforms use '__u32'.
+ * Yes, they differ in signedness as well as size.
+ * Special cases can override it for themselves -- except for S390x, which
+ * is just a little too special for us. And MIPS, which I'm not touching
+ * with a 10' pole.
+ */
+#ifndef __statfs_word
+#if BITS_PER_LONG == 64
+#define __statfs_word long
+#else
+typedef __statfs_word __u32
+#endif
+#endif
+
 struct statfs {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u32 f_blocks;
-	__u32 f_bfree;
-	__u32 f_bavail;
-	__u32 f_files;
-	__u32 f_ffree;
+	__statfs_word f_type;
+	__statfs_word f_bsize;
+	__statfs_word f_blocks;
+	__statfs_word f_bfree;
+	__statfs_word f_bavail;
+	__statfs_word f_files;
+	__statfs_word f_ffree;
 	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
+	__statfs_word f_namelen;
+	__statfs_word f_frsize;
+	__statfs_word f_spare[5];
 };
 
+/*
+ * ARM needs to avoid the 32-bit padding at the end, for consistency
+ * between EABI and OABI 
+ */
+#ifndef ARCH_PACK_STATFS64
+#define ARCH_PACK_STATFS64
+#endif
+
 struct statfs64 {
-	__u32 f_type;
-	__u32 f_bsize;
+	__statfs_word f_type;
+	__statfs_word f_bsize;
 	__u64 f_blocks;
 	__u64 f_bfree;
 	__u64 f_bavail;
 	__u64 f_files;
 	__u64 f_ffree;
 	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-};
+	__statfs_word f_namelen;
+	__statfs_word f_frsize;
+	__statfs_word f_spare[5];
+} ARCH_PACK_STATFS64;
+
+/* 
+ * IA64 and x86_64 need to avoid the 32-bit padding at the end,
+ * to be compatible with the i386 ABI
+ */
+#ifndef ARCH_PACK_COMPAT_STATFS64
+#define ARCH_PACK_COMPAT_STATFS64
+#endif
 
 struct compat_statfs64 {
 	__u32 f_type;
@@ -46,6 +77,6 @@ struct compat_statfs64 {
 	__u32 f_namelen;
 	__u32 f_frsize;
 	__u32 f_spare[5];
-};
+} ARCH_PACK_COMPAT_STATFS64;
 
 #endif
diff --git a/arch/alpha/include/asm/statfs.h b/arch/alpha/include/asm/statfs.h
index ad15830..de35cd4 100644
--- a/arch/alpha/include/asm/statfs.h
+++ b/arch/alpha/include/asm/statfs.h
@@ -1,6 +1,10 @@
 #ifndef _ALPHA_STATFS_H
 #define _ALPHA_STATFS_H
 
+/* Alpha is the only 64-bit platform with 32-bit statfs. And doesn't
+   even seem to implement statfs64 */
+#define __statfs_word __u32
+
 #include <asm-generic/statfs.h>
 
 #endif
diff --git a/arch/arm/include/asm/statfs.h b/arch/arm/include/asm/statfs.h
index a02e6a8..079447c 100644
--- a/arch/arm/include/asm/statfs.h
+++ b/arch/arm/include/asm/statfs.h
@@ -1,42 +1,12 @@
 #ifndef _ASMARM_STATFS_H
 #define _ASMARM_STATFS_H
 
-#ifndef __KERNEL_STRICT_NAMES
-# include <linux/types.h>
-typedef __kernel_fsid_t	fsid_t;
-#endif
-
-struct statfs {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u32 f_blocks;
-	__u32 f_bfree;
-	__u32 f_bavail;
-	__u32 f_files;
-	__u32 f_ffree;
-	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-};
-
 /*
  * With EABI there is 4 bytes of padding added to this structure.
  * Let's pack it so the padding goes away to simplify dual ABI support.
  * Note that user space does NOT have to pack this structure.
  */
-struct statfs64 {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u64 f_blocks;
-	__u64 f_bfree;
-	__u64 f_bavail;
-	__u64 f_files;
-	__u64 f_ffree;
-	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-} __attribute__ ((packed,aligned(4)));
+#define ARCH_PACK_STATFS64 __attribute__((packed,aligned(4)))
 
+#include <asm-generic/statfs.h>
 #endif
diff --git a/arch/ia64/include/asm/statfs.h b/arch/ia64/include/asm/statfs.h
index 8110979..1e58966 100644
--- a/arch/ia64/include/asm/statfs.h
+++ b/arch/ia64/include/asm/statfs.h
@@ -8,55 +8,13 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
  */
 
-#ifndef __KERNEL_STRICT_NAMES
-# include <linux/types.h>
-typedef __kernel_fsid_t	fsid_t;
-#endif
-
 /*
- * This is ugly --- we're already 64-bit, so just duplicate the definitions
+ * We need compat_statfs64 to be packed, because the i386 ABI won't
+ * add padding at the end to bring it to a multiple of 8 bytes, but
+ * the IA64 ABI will.
  */
-struct statfs {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
-
-
-struct statfs64 {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
+#define ARCH_PACK_COMPAT_STATFS64 __attribute__((packed,aligned(4)))
 
-struct compat_statfs64 {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u64 f_blocks;
-	__u64 f_bfree;
-	__u64 f_bavail;
-	__u64 f_files;
-	__u64 f_ffree;
-	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-} __attribute__((packed));
+#include <asm-generic/statfs.h>
 
 #endif /* _ASM_IA64_STATFS_H */
diff --git a/arch/powerpc/include/asm/statfs.h b/arch/powerpc/include/asm/statfs.h
index 6702402..5244834 100644
--- a/arch/powerpc/include/asm/statfs.h
+++ b/arch/powerpc/include/asm/statfs.h
@@ -1,60 +1,6 @@
 #ifndef _ASM_POWERPC_STATFS_H
 #define _ASM_POWERPC_STATFS_H
 
-/* For ppc32 we just use the generic definitions, not so simple on ppc64 */
-
-#ifndef __powerpc64__
 #include <asm-generic/statfs.h>
-#else
-
-#ifndef __KERNEL_STRICT_NAMES
-#include <linux/types.h>
-typedef __kernel_fsid_t	fsid_t;
-#endif
-
-/*
- * We're already 64-bit, so duplicate the definition
- */
-struct statfs {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
-
-struct statfs64 {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
 
-struct compat_statfs64 {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u64 f_blocks;
-	__u64 f_bfree;
-	__u64 f_bavail;
-	__u64 f_files;
-	__u64 f_ffree;
-	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-};
-#endif /* ! __powerpc64__ */
 #endif
diff --git a/arch/s390/include/asm/statfs.h b/arch/s390/include/asm/statfs.h
index 099a455..06cc703 100644
--- a/arch/s390/include/asm/statfs.h
+++ b/arch/s390/include/asm/statfs.h
@@ -12,19 +12,16 @@
 #ifndef __s390x__
 #include <asm-generic/statfs.h>
 #else
+/*
+ * We can't use <asm-generic/statfs.h> because in 64-bit mode
+ * we mix ints of different sizes in our struct statfs.
+ */
 
 #ifndef __KERNEL_STRICT_NAMES
-
 #include <linux/types.h>
-
 typedef __kernel_fsid_t	fsid_t;
-
 #endif
 
-/*
- * This is ugly -- we're already 64-bit clean, so just duplicate the 
- * definitions.
- */
 struct statfs {
 	int  f_type;
 	int  f_bsize;
diff --git a/arch/sparc/include/asm/statfs.h b/arch/sparc/include/asm/statfs.h
index 5e937a7..55e607a 100644
--- a/arch/sparc/include/asm/statfs.h
+++ b/arch/sparc/include/asm/statfs.h
@@ -1,8 +1,6 @@
 #ifndef ___ASM_SPARC_STATFS_H
 #define ___ASM_SPARC_STATFS_H
-#if defined(__sparc__) && defined(__arch64__)
-#include <asm/statfs_64.h>
-#else
-#include <asm/statfs_32.h>
-#endif
+
+#include <asm-generic/statfs.h>
+
 #endif
diff --git a/arch/sparc/include/asm/statfs_32.h b/arch/sparc/include/asm/statfs_32.h
deleted file mode 100644
index 304520f..0000000
--- a/arch/sparc/include/asm/statfs_32.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _SPARC_STATFS_H
-#define _SPARC_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif
diff --git a/arch/sparc/include/asm/statfs_64.h b/arch/sparc/include/asm/statfs_64.h
deleted file mode 100644
index 79b3c89..0000000
--- a/arch/sparc/include/asm/statfs_64.h
+++ /dev/null
@@ -1,54 +0,0 @@
-#ifndef _SPARC64_STATFS_H
-#define _SPARC64_STATFS_H
-
-#ifndef __KERNEL_STRICT_NAMES
-
-#include <linux/types.h>
-
-typedef __kernel_fsid_t	fsid_t;
-
-#endif
-
-struct statfs {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
-
-struct statfs64 {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
-
-struct compat_statfs64 {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u64 f_blocks;
-	__u64 f_bfree;
-	__u64 f_bavail;
-	__u64 f_files;
-	__u64 f_ffree;
-	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-};
-
-#endif
diff --git a/include/asm-parisc/statfs.h b/include/asm-parisc/statfs.h
index 1d2b813..324bea9 100644
--- a/include/asm-parisc/statfs.h
+++ b/include/asm-parisc/statfs.h
@@ -1,58 +1,7 @@
 #ifndef _PARISC_STATFS_H
 #define _PARISC_STATFS_H
 
-#ifndef __KERNEL_STRICT_NAMES
-
-#include <linux/types.h>
-
-typedef __kernel_fsid_t	fsid_t;
-
-#endif
-
-/*
- * It appears that PARISC could be 64 _or_ 32 bit.
- * 64-bit fields must be explicitly 64-bit in statfs64.
- */
-struct statfs {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
-
-struct statfs64 {
-	long f_type;
-	long f_bsize;
-	__u64 f_blocks;
-	__u64 f_bfree;
-	__u64 f_bavail;
-	__u64 f_files;
-	__u64 f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
-
-struct compat_statfs64 {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u64 f_blocks;
-	__u64 f_bfree;
-	__u64 f_bavail;
-	__u64 f_files;
-	__u64 f_ffree;
-	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-};
+#define __statfs_word long
+#include <asm-generic/statfs.h>
 
 #endif
diff --git a/include/asm-x86/statfs.h b/include/asm-x86/statfs.h
index 7c651aa..4c935ca 100644
--- a/include/asm-x86/statfs.h
+++ b/include/asm-x86/statfs.h
@@ -1,63 +1,12 @@
 #ifndef _ASM_X86_STATFS_H
 #define _ASM_X86_STATFS_H
 
-#ifdef __i386__
-#include <asm-generic/statfs.h>
-#else
-
-#ifndef __KERNEL_STRICT_NAMES
-
-#include <linux/types.h>
-
-typedef __kernel_fsid_t	fsid_t;
-
-#endif
-
 /*
- * This is ugly -- we're already 64-bit clean, so just duplicate the
- * definitions.
+ * We need compat_statfs64 to be packed, because the i386 ABI won't
+ * add padding at the end to bring it to a multiple of 8 bytes, but
+ * the x86_64 ABI will.
  */
-struct statfs {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
-
-struct statfs64 {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
+#define ARCH_PACK_COMPAT_STATFS64 __attribute__((packed,aligned(4)))
 
-struct compat_statfs64 {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u64 f_blocks;
-	__u64 f_bfree;
-	__u64 f_bavail;
-	__u64 f_files;
-	__u64 f_ffree;
-	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-} __attribute__((packed));
-
-#endif /* !__i386__ */
+#include <asm-generic/statfs.h>
 #endif


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



