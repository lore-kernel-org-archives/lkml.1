Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbZAFVej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbZAFVej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZAFVcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:16 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZAFVcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EjaBd7/b/1ydf8XJvtccVcLXwpDC9qFjJLUVyLJwZYwLWMDm4iWYAk2T6AkUuXOEgb
         JC2go9iUpoWXDHA6qX2jEpVU87tnsFyzeD+ik3uqQFo7RSDFYCHJRH5j6K10bYeVE/oD
         xf8tMqBYAGcWM37hwAuQLHTlYKP/GVPTmQAsY=
Subject: [PATCH 08/23] sh: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:49 -0800
Message-Id: <1231277449.964.265.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sh/include/asm/Kbuild      |    1 +
 arch/sh/include/asm/byteorder.h |   62 ++-------------------------------------
 arch/sh/include/asm/swab.h      |   60 +++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 59 deletions(-)

diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index 43910cd..f1a2a0d 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -6,3 +6,4 @@ unifdef-y += unistd_32.h
 unifdef-y += unistd_64.h
 unifdef-y += posix_types_32.h
 unifdef-y += posix_types_64.h
+unifdef-y += swab.h
diff --git a/arch/sh/include/asm/byteorder.h b/arch/sh/include/asm/byteorder.h
index f5fa065..e95c41a 100644
--- a/arch/sh/include/asm/byteorder.h
+++ b/arch/sh/include/asm/byteorder.h
@@ -1,68 +1,12 @@
 #ifndef __ASM_SH_BYTEORDER_H
 #define __ASM_SH_BYTEORDER_H
 
-/*
- * Copyright (C) 1999  Niibe Yutaka
- * Copyright (C) 2000, 2001  Paolo Alberelli
- */
-#include <linux/compiler.h>
-#include <linux/types.h>
+#include <asm/swab.h>
 
 #ifdef __LITTLE_ENDIAN__
-# define __LITTLE_ENDIAN
+#include <linux/byteorder/little_endian.h>
 #else
-# define __BIG_ENDIAN
+#include <linux/byteorder/big_endian.h>
 #endif
 
-#define __SWAB_64_THRU_32__
-
-static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
-{
-	__asm__(
-#ifdef __SH5__
-		"byterev	%0, %0\n\t"
-		"shari		%0, 32, %0"
-#else
-		"swap.b		%0, %0\n\t"
-		"swap.w		%0, %0\n\t"
-		"swap.b		%0, %0"
-#endif
-		: "=r" (x)
-		: "0" (x));
-
-	return x;
-}
-#define __arch_swab32 __arch_swab32
-
-static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
-{
-	__asm__(
-#ifdef __SH5__
-		"byterev	%0, %0\n\t"
-		"shari		%0, 32, %0"
-#else
-		"swap.b		%0, %0"
-#endif
-		: "=r" (x)
-		:  "0" (x));
-
-	return x;
-}
-#define __arch_swab16 __arch_swab16
-
-static inline __u64 __arch_swab64(__u64 val)
-{
-	union {
-		struct { __u32 a,b; } s;
-		__u64 u;
-	} v, w;
-	v.u = val;
-	w.s.b = __arch_swab32(v.s.a);
-	w.s.a = __arch_swab32(v.s.b);
-	return w.u;
-}
-#define __arch_swab64 __arch_swab64
-
-#include <linux/byteorder.h>
-
 #endif /* __ASM_SH_BYTEORDER_H */
diff --git a/arch/sh/include/asm/swab.h b/arch/sh/include/asm/swab.h
new file mode 100644
index 0000000..e693159
--- /dev/null
+++ b/arch/sh/include/asm/swab.h
@@ -0,0 +1,60 @@
+#ifndef __ASM_SH_SWAB_H
+#define __ASM_SH_SWAB_H
+
+/*
+ * Copyright (C) 1999  Niibe Yutaka
+ * Copyright (C) 2000, 2001  Paolo Alberelli
+ */
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
+{
+	__asm__(
+#ifdef __SH5__
+		"byterev	%0, %0\n\t"
+		"shari		%0, 32, %0"
+#else
+		"swap.b		%0, %0\n\t"
+		"swap.w		%0, %0\n\t"
+		"swap.b		%0, %0"
+#endif
+		: "=r" (x)
+		: "0" (x));
+
+	return x;
+}
+#define __arch_swab32 __arch_swab32
+
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
+{
+	__asm__(
+#ifdef __SH5__
+		"byterev	%0, %0\n\t"
+		"shari		%0, 32, %0"
+#else
+		"swap.b		%0, %0"
+#endif
+		: "=r" (x)
+		:  "0" (x));
+
+	return x;
+}
+#define __arch_swab16 __arch_swab16
+
+static inline __u64 __arch_swab64(__u64 val)
+{
+	union {
+		struct { __u32 a,b; } s;
+		__u64 u;
+	} v, w;
+	v.u = val;
+	w.s.b = __arch_swab32(v.s.a);
+	w.s.a = __arch_swab32(v.s.b);
+	return w.u;
+}
+#define __arch_swab64 __arch_swab64
+
+#endif /* __ASM_SH_SWAB_H */
-- 
1.6.1.94.g9388


