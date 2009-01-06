Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZAFVff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZAFVff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZAFVcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:23 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZAFVcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=S6pkNmukuiuPRjHzpdHkMZtJsHdw2Y6NyWiG0jpXzenObWepcwSHyATYAXw/Oj5yjc
         ZfdzF5l07/bwEcMVdRV2u4ZSpX120HjcgoTBJR9nKwZQnNPYJlxnYIx2ZBV4mbPZ4w2f
         8CYclUfHkblHMQ42iI3+WSjlbNq3W6Rzm9lJQ=
Subject: [PATCH 10/23] x86: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:50 -0800
Message-Id: <1231277450.964.267.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/include/asm/Kbuild      |    1 +
 arch/x86/include/asm/byteorder.h |   62 +------------------------------------
 arch/x86/include/asm/swab.h      |   61 +++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 60 deletions(-)

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 4a8e80c..a9f8a81 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -22,3 +22,4 @@ unifdef-y += unistd_32.h
 unifdef-y += unistd_64.h
 unifdef-y += vm86.h
 unifdef-y += vsyscall.h
+unifdef-y += swab.h
diff --git a/arch/x86/include/asm/byteorder.h b/arch/x86/include/asm/byteorder.h
index f110ad4..7c49917 100644
--- a/arch/x86/include/asm/byteorder.h
+++ b/arch/x86/include/asm/byteorder.h
@@ -1,65 +1,7 @@
 #ifndef _ASM_X86_BYTEORDER_H
 #define _ASM_X86_BYTEORDER_H
 
-#include <asm/types.h>
-#include <linux/compiler.h>
-
-#define __LITTLE_ENDIAN
-
-static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
-{
-#ifdef __i386__
-# ifdef CONFIG_X86_BSWAP
-	asm("bswap %0" : "=r" (val) : "0" (val));
-# else
-	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
-	    "rorl $16,%0\n\t"	/* swap words		*/
-	    "xchgb %b0,%h0"	/* swap higher bytes	*/
-	    : "=q" (val)
-	    : "0" (val));
-# endif
-
-#else /* __i386__ */
-	asm("bswapl %0"
-	    : "=r" (val)
-	    : "0" (val));
-#endif
-	return val;
-}
-#define __arch_swab32 __arch_swab32
-
-static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
-{
-#ifdef __i386__
-	union {
-		struct {
-			__u32 a;
-			__u32 b;
-		} s;
-		__u64 u;
-	} v;
-	v.u = val;
-# ifdef CONFIG_X86_BSWAP
-	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
-	    : "=r" (v.s.a), "=r" (v.s.b)
-	    : "0" (v.s.a), "1" (v.s.b));
-# else
-	v.s.a = __arch_swab32(v.s.a);
-	v.s.b = __arch_swab32(v.s.b);
-	asm("xchgl %0,%1"
-	    : "=r" (v.s.a), "=r" (v.s.b)
-	    : "0" (v.s.a), "1" (v.s.b));
-# endif
-	return v.u;
-#else /* __i386__ */
-	asm("bswapq %0"
-	    : "=r" (val)
-	    : "0" (val));
-	return val;
-#endif
-}
-#define __arch_swab64 __arch_swab64
-
-#include <linux/byteorder.h>
+#include <asm/swab.h>
+#include <linux/byteorder/little_endian.h>
 
 #endif /* _ASM_X86_BYTEORDER_H */
diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
new file mode 100644
index 0000000..306d417
--- /dev/null
+++ b/arch/x86/include/asm/swab.h
@@ -0,0 +1,61 @@
+#ifndef _ASM_X86_SWAB_H
+#define _ASM_X86_SWAB_H
+
+#include <asm/types.h>
+#include <linux/compiler.h>
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
+{
+#ifdef __i386__
+# ifdef CONFIG_X86_BSWAP
+	asm("bswap %0" : "=r" (val) : "0" (val));
+# else
+	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
+	    "rorl $16,%0\n\t"	/* swap words		*/
+	    "xchgb %b0,%h0"	/* swap higher bytes	*/
+	    : "=q" (val)
+	    : "0" (val));
+# endif
+
+#else /* __i386__ */
+	asm("bswapl %0"
+	    : "=r" (val)
+	    : "0" (val));
+#endif
+	return val;
+}
+#define __arch_swab32 __arch_swab32
+
+static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
+{
+#ifdef __i386__
+	union {
+		struct {
+			__u32 a;
+			__u32 b;
+		} s;
+		__u64 u;
+	} v;
+	v.u = val;
+# ifdef CONFIG_X86_BSWAP
+	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
+	    : "=r" (v.s.a), "=r" (v.s.b)
+	    : "0" (v.s.a), "1" (v.s.b));
+# else
+	v.s.a = __arch_swab32(v.s.a);
+	v.s.b = __arch_swab32(v.s.b);
+	asm("xchgl %0,%1"
+	    : "=r" (v.s.a), "=r" (v.s.b)
+	    : "0" (v.s.a), "1" (v.s.b));
+# endif
+	return v.u;
+#else /* __i386__ */
+	asm("bswapq %0"
+	    : "=r" (val)
+	    : "0" (val));
+	return val;
+#endif
+}
+#define __arch_swab64 __arch_swab64
+
+#endif /* _ASM_X86_SWAB_H */
-- 
1.6.1.94.g9388


