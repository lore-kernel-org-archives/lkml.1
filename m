Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZAFVez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZAFVez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZAFVcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:18 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbZAFVcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cqz04krV0G50ChWDAoPNSh4Uy4q1VGWFtV8gbtDN6NeHlxbmc53VQlYQRUm2Vtp2+e
         y6uqJib6pcYDE7O4Wo/ABzBOD7ou/s6rydzcLFjhjqB4WA0D06S9DNxwXZ9jBPPZDOm4
         oWqnHYqAyX/0pOYvdUvygHxhBQS7gxX1J9u+A=
Subject: [PATCH 09/23] sparc: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:50 -0800
Message-Id: <1231277450.964.266.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Dave, I would have rather moved the SWAB_64_THRU_32 bit to the
top of swab.h like all other arches, but I kept it a pure movement patch.

It seems to make sense for sparc the way it is however, just FYI.

 arch/sparc/include/asm/Kbuild      |    1 +
 arch/sparc/include/asm/byteorder.h |   46 +----------------------------------
 arch/sparc/include/asm/swab.h      |   45 +++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 44 deletions(-)

diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 58f9b3a..d012070 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -23,3 +23,4 @@ header-y += traps.h
 header-y += uctx.h
 header-y += utrap.h
 header-y += watchdog.h
+header-y += swab.h
diff --git a/arch/sparc/include/asm/byteorder.h b/arch/sparc/include/asm/byteorder.h
index 738414b..48a047c 100644
--- a/arch/sparc/include/asm/byteorder.h
+++ b/arch/sparc/include/asm/byteorder.h
@@ -1,49 +1,7 @@
 #ifndef _SPARC_BYTEORDER_H
 #define _SPARC_BYTEORDER_H
 
-#include <linux/types.h>
-#include <asm/asi.h>
-
-#define __BIG_ENDIAN
-
-#if defined(__sparc__) && defined(__arch64__)
-static inline __u16 __arch_swab16p(const __u16 *addr)
-{
-	__u16 ret;
-
-	__asm__ __volatile__ ("lduha [%1] %2, %0"
-			      : "=r" (ret)
-			      : "r" (addr), "i" (ASI_PL));
-	return ret;
-}
-#define __arch_swab16p __arch_swab16p
-
-static inline __u32 __arch_swab32p(const __u32 *addr)
-{
-	__u32 ret;
-
-	__asm__ __volatile__ ("lduwa [%1] %2, %0"
-			      : "=r" (ret)
-			      : "r" (addr), "i" (ASI_PL));
-	return ret;
-}
-#define __arch_swab32p __arch_swab32p
-
-static inline __u64 __arch_swab64p(const __u64 *addr)
-{
-	__u64 ret;
-
-	__asm__ __volatile__ ("ldxa [%1] %2, %0"
-			      : "=r" (ret)
-			      : "r" (addr), "i" (ASI_PL));
-	return ret;
-}
-#define __arch_swab64p __arch_swab64p
-
-#else
-#define __SWAB_64_THRU_32__
-#endif /* defined(__sparc__) && defined(__arch64__) */
-
-#include <linux/byteorder.h>
+#include <asm/swab.h>
+#include <linux/byteorder/big_endian.h>
 
 #endif /* _SPARC_BYTEORDER_H */
diff --git a/arch/sparc/include/asm/swab.h b/arch/sparc/include/asm/swab.h
new file mode 100644
index 0000000..a34ad07
--- /dev/null
+++ b/arch/sparc/include/asm/swab.h
@@ -0,0 +1,45 @@
+#ifndef _SPARC_SWAB_H
+#define _SPARC_SWAB_H
+
+#include <linux/types.h>
+#include <asm/asi.h>
+
+#if defined(__sparc__) && defined(__arch64__)
+static inline __u16 __arch_swab16p(const __u16 *addr)
+{
+	__u16 ret;
+
+	__asm__ __volatile__ ("lduha [%1] %2, %0"
+			      : "=r" (ret)
+			      : "r" (addr), "i" (ASI_PL));
+	return ret;
+}
+#define __arch_swab16p __arch_swab16p
+
+static inline __u32 __arch_swab32p(const __u32 *addr)
+{
+	__u32 ret;
+
+	__asm__ __volatile__ ("lduwa [%1] %2, %0"
+			      : "=r" (ret)
+			      : "r" (addr), "i" (ASI_PL));
+	return ret;
+}
+#define __arch_swab32p __arch_swab32p
+
+static inline __u64 __arch_swab64p(const __u64 *addr)
+{
+	__u64 ret;
+
+	__asm__ __volatile__ ("ldxa [%1] %2, %0"
+			      : "=r" (ret)
+			      : "r" (addr), "i" (ASI_PL));
+	return ret;
+}
+#define __arch_swab64p __arch_swab64p
+
+#else
+#define __SWAB_64_THRU_32__
+#endif /* defined(__sparc__) && defined(__arch64__) */
+
+#endif /* _SPARC_SWAB_H */
-- 
1.6.1.94.g9388


