Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZAFVeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZAFVeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZAFVcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:11 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbZAFVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=N2QsKT1b8x9vfxigYIR/4TAOZMqxFdd95VOBOxhNpgJfzYkObS+Rw5vBbXQ1rps4C2
         JmqZsVom//hFzTIPGnlXtWz9ZP/H0wA6Ve/wvVScJx+s6MKpc5JOD8eG2JfcjtPrjQjd
         NUaNUwXquD42bS+mPEd6Ks0/cqSrLph7ZefmY=
Subject: [PATCH 07/23] s390: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:48 -0800
Message-Id: <1231277448.964.264.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/s390/include/asm/Kbuild      |    1 +
 arch/s390/include/asm/byteorder.h |   92 +------------------------------------
 arch/s390/include/asm/swab.h      |   91 ++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 90 deletions(-)

diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 63a2341..f2af416 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -13,3 +13,4 @@ unifdef-y += cmb.h
 unifdef-y += debug.h
 unifdef-y += chpid.h
 unifdef-y += schid.h
+unifdef-y += swab.h
diff --git a/arch/s390/include/asm/byteorder.h b/arch/s390/include/asm/byteorder.h
index 8bcf277..b95a2b2 100644
--- a/arch/s390/include/asm/byteorder.h
+++ b/arch/s390/include/asm/byteorder.h
@@ -1,95 +1,7 @@
 #ifndef _S390_BYTEORDER_H
 #define _S390_BYTEORDER_H
 
-/*
- *  include/asm-s390/byteorder.h
- *
- *  S390 version
- *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
- *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com)
- */
-
-#include <asm/types.h>
-
-#define __BIG_ENDIAN
-
-#ifndef __s390x__
-# define __SWAB_64_THRU_32__
-#endif
-
-#ifdef __s390x__
-static inline __u64 __arch_swab64p(const __u64 *x)
-{
-	__u64 result;
-
-	asm volatile("lrvg %0,%1" : "=d" (result) : "m" (*x));
-	return result;
-}
-#define __arch_swab64p __arch_swab64p
-
-static inline __u64 __arch_swab64(__u64 x)
-{
-	__u64 result;
-
-	asm volatile("lrvgr %0,%1" : "=d" (result) : "d" (x));
-	return result;
-}
-#define __arch_swab64 __arch_swab64
-
-static inline void __arch_swab64s(__u64 *x)
-{
-	*x = __arch_swab64p(x);
-}
-#define __arch_swab64s __arch_swab64s
-#endif /* __s390x__ */
-
-static inline __u32 __arch_swab32p(const __u32 *x)
-{
-	__u32 result;
-	
-	asm volatile(
-#ifndef __s390x__
-		"	icm	%0,8,3(%1)\n"
-		"	icm	%0,4,2(%1)\n"
-		"	icm	%0,2,1(%1)\n"
-		"	ic	%0,0(%1)"
-		: "=&d" (result) : "a" (x), "m" (*x) : "cc");
-#else /* __s390x__ */
-		"	lrv	%0,%1"
-		: "=d" (result) : "m" (*x));
-#endif /* __s390x__ */
-	return result;
-}
-#define __arch_swab32p __arch_swab32p
-
-#ifdef __s390x__
-static inline __u32 __arch_swab32(__u32 x)
-{
-	__u32 result;
-	
-	asm volatile("lrvr  %0,%1" : "=d" (result) : "d" (x));
-	return result;
-}
-#define __arch_swab32 __arch_swab32
-#endif /* __s390x__ */
-
-static inline __u16 __arch_swab16p(const __u16 *x)
-{
-	__u16 result;
-	
-	asm volatile(
-#ifndef __s390x__
-		"	icm	%0,2,1(%1)\n"
-		"	ic	%0,0(%1)\n"
-		: "=&d" (result) : "a" (x), "m" (*x) : "cc");
-#else /* __s390x__ */
-		"	lrvh	%0,%1"
-		: "=d" (result) : "m" (*x));
-#endif /* __s390x__ */
-	return result;
-}
-#define __arch_swab16p __arch_swab16p
-
-#include <linux/byteorder.h>
+#include <asm/swab.h>
+#include <linux/byteorder/big_endian.h>
 
 #endif /* _S390_BYTEORDER_H */
diff --git a/arch/s390/include/asm/swab.h b/arch/s390/include/asm/swab.h
new file mode 100644
index 0000000..bd9321a
--- /dev/null
+++ b/arch/s390/include/asm/swab.h
@@ -0,0 +1,91 @@
+#ifndef _S390_SWAB_H
+#define _S390_SWAB_H
+
+/*
+ *  include/asm-s390/swab.h
+ *
+ *  S390 version
+ *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
+ *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com)
+ */
+
+#include <asm/types.h>
+
+#ifndef __s390x__
+# define __SWAB_64_THRU_32__
+#endif
+
+#ifdef __s390x__
+static inline __u64 __arch_swab64p(const __u64 *x)
+{
+	__u64 result;
+
+	asm volatile("lrvg %0,%1" : "=d" (result) : "m" (*x));
+	return result;
+}
+#define __arch_swab64p __arch_swab64p
+
+static inline __u64 __arch_swab64(__u64 x)
+{
+	__u64 result;
+
+	asm volatile("lrvgr %0,%1" : "=d" (result) : "d" (x));
+	return result;
+}
+#define __arch_swab64 __arch_swab64
+
+static inline void __arch_swab64s(__u64 *x)
+{
+	*x = __arch_swab64p(x);
+}
+#define __arch_swab64s __arch_swab64s
+#endif /* __s390x__ */
+
+static inline __u32 __arch_swab32p(const __u32 *x)
+{
+	__u32 result;
+	
+	asm volatile(
+#ifndef __s390x__
+		"	icm	%0,8,3(%1)\n"
+		"	icm	%0,4,2(%1)\n"
+		"	icm	%0,2,1(%1)\n"
+		"	ic	%0,0(%1)"
+		: "=&d" (result) : "a" (x), "m" (*x) : "cc");
+#else /* __s390x__ */
+		"	lrv	%0,%1"
+		: "=d" (result) : "m" (*x));
+#endif /* __s390x__ */
+	return result;
+}
+#define __arch_swab32p __arch_swab32p
+
+#ifdef __s390x__
+static inline __u32 __arch_swab32(__u32 x)
+{
+	__u32 result;
+	
+	asm volatile("lrvr  %0,%1" : "=d" (result) : "d" (x));
+	return result;
+}
+#define __arch_swab32 __arch_swab32
+#endif /* __s390x__ */
+
+static inline __u16 __arch_swab16p(const __u16 *x)
+{
+	__u16 result;
+	
+	asm volatile(
+#ifndef __s390x__
+		"	icm	%0,2,1(%1)\n"
+		"	ic	%0,0(%1)\n"
+		: "=&d" (result) : "a" (x), "m" (*x) : "cc");
+#else /* __s390x__ */
+		"	lrvh	%0,%1"
+		: "=d" (result) : "m" (*x));
+#endif /* __s390x__ */
+	return result;
+}
+#define __arch_swab16p __arch_swab16p
+
+#endif /* _S390_SWAB_H */
-- 
1.6.1.94.g9388


