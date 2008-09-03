Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbYICJic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbYICJic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYICJh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:37:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:44239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYICJh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:37:57 -0400
Subject: [PATCH 1/8] Make <asm-generic/statfs.h> suitable for 64-bit
	platforms.
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1220275314.2982.83.camel@pmac.infradead.org>
References: <1220275314.2982.83.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 10:37:54 +0100
Message-Id: <1220434674.2985.61.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment, 64-bit platforms (other than Alpha) are all redefining
things for themselves instead of using <asm-generic/statfs.h>.

As is ARM, since it has special requirements w.r.t. padding.

Make <asm-generic/statfs.h> more generic, and they can use it directly.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/alpha/include/asm/statfs.h |    4 ++
 include/asm-generic/statfs.h    |   65 ++++++++++++++++++++++++++++----------
 2 files changed, 52 insertions(+), 17 deletions(-)

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
diff --git a/include/asm-generic/statfs.h b/include/asm-generic/statfs.h
index 1d01043..6129d68 100644
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
+#define __statfs_word __u32
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
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



