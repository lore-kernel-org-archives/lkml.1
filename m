Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZAFVgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZAFVgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZAFVc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:26 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:9249 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZAFVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=fJThmUOPXAAKfziGO/FEPE+h4ZERDDIfP1NoD+hSwxp4AJLVyuELa4j2XOjjOPtOK3
         EOcRHbTT8ZZ/cAMtrdOpqLSq0NxpwNDIlZvUD7GjUh226vXGvg3VIPuIt+3PccYYbomO
         jwUehRg41rb9HlqjwajcETQ4XPI+7pPuuXlfA=
Subject: [PATCH 13/23] alpha: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "rth@twiddle.net" <rth@twiddle.net>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:52 -0800
Message-Id: <1231277452.964.270.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new-style arch overrides as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/alpha/include/asm/Kbuild      |    1 +
 arch/alpha/include/asm/byteorder.h |   42 +-----------------------------------
 arch/alpha/include/asm/swab.h      |   42 ++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index b7c8f18..4dad273 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -9,3 +9,4 @@ unifdef-y += console.h
 unifdef-y += fpu.h
 unifdef-y += sysinfo.h
 unifdef-y += compiler.h
+unifdef-y += swab.h
diff --git a/arch/alpha/include/asm/byteorder.h b/arch/alpha/include/asm/byteorder.h
index 58e958f..6772f31 100644
--- a/arch/alpha/include/asm/byteorder.h
+++ b/arch/alpha/include/asm/byteorder.h
@@ -1,47 +1,7 @@
 #ifndef _ALPHA_BYTEORDER_H
 #define _ALPHA_BYTEORDER_H
 
-#include <asm/types.h>
-#include <linux/compiler.h>
-#include <asm/compiler.h>
-
-#ifdef __GNUC__
-
-static inline __attribute_const__ __u32 __arch__swab32(__u32 x)
-{
-	/*
-	 * Unfortunately, we can't use the 6 instruction sequence
-	 * on ev6 since the latency of the UNPKBW is 3, which is
-	 * pretty hard to hide.  Just in case a future implementation
-	 * has a lower latency, here's the sequence (also by Mike Burrows)
-	 *
-	 * UNPKBW a0, v0       v0: 00AA00BB00CC00DD
-	 * SLL v0, 24, a0      a0: BB00CC00DD000000
-	 * BIS v0, a0, a0      a0: BBAACCBBDDCC00DD
-	 * EXTWL a0, 6, v0     v0: 000000000000BBAA
-	 * ZAP a0, 0xf3, a0    a0: 00000000DDCC0000
-	 * ADDL a0, v0, v0     v0: ssssssssDDCCBBAA
-	 */
-
-	__u64 t0, t1, t2, t3;
-
-	t0 = __kernel_inslh(x, 7);	/* t0 : 0000000000AABBCC */
-	t1 = __kernel_inswl(x, 3);	/* t1 : 000000CCDD000000 */
-	t1 |= t0;			/* t1 : 000000CCDDAABBCC */
-	t2 = t1 >> 16;			/* t2 : 0000000000CCDDAA */
-	t0 = t1 & 0xFF00FF00;		/* t0 : 00000000DD00BB00 */
-	t3 = t2 & 0x00FF00FF;		/* t3 : 0000000000CC00AA */
-	t1 = t0 + t3;			/* t1 : ssssssssDDCCBBAA */
-
-	return t1;
-}
-
-#define __arch__swab32 __arch__swab32
-
-#endif /* __GNUC__ */
-
-#define __BYTEORDER_HAS_U64__
-
+#include <asm/swab.h>
 #include <linux/byteorder/little_endian.h>
 
 #endif /* _ALPHA_BYTEORDER_H */
diff --git a/arch/alpha/include/asm/swab.h b/arch/alpha/include/asm/swab.h
new file mode 100644
index 0000000..68e7089
--- /dev/null
+++ b/arch/alpha/include/asm/swab.h
@@ -0,0 +1,42 @@
+#ifndef _ALPHA_SWAB_H
+#define _ALPHA_SWAB_H
+
+#include <asm/types.h>
+#include <linux/compiler.h>
+#include <asm/compiler.h>
+
+#ifdef __GNUC__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
+{
+	/*
+	 * Unfortunately, we can't use the 6 instruction sequence
+	 * on ev6 since the latency of the UNPKBW is 3, which is
+	 * pretty hard to hide.  Just in case a future implementation
+	 * has a lower latency, here's the sequence (also by Mike Burrows)
+	 *
+	 * UNPKBW a0, v0       v0: 00AA00BB00CC00DD
+	 * SLL v0, 24, a0      a0: BB00CC00DD000000
+	 * BIS v0, a0, a0      a0: BBAACCBBDDCC00DD
+	 * EXTWL a0, 6, v0     v0: 000000000000BBAA
+	 * ZAP a0, 0xf3, a0    a0: 00000000DDCC0000
+	 * ADDL a0, v0, v0     v0: ssssssssDDCCBBAA
+	 */
+
+	__u64 t0, t1, t2, t3;
+
+	t0 = __kernel_inslh(x, 7);	/* t0 : 0000000000AABBCC */
+	t1 = __kernel_inswl(x, 3);	/* t1 : 000000CCDD000000 */
+	t1 |= t0;			/* t1 : 000000CCDDAABBCC */
+	t2 = t1 >> 16;			/* t2 : 0000000000CCDDAA */
+	t0 = t1 & 0xFF00FF00;		/* t0 : 00000000DD00BB00 */
+	t3 = t2 & 0x00FF00FF;		/* t3 : 0000000000CC00AA */
+	t1 = t0 + t3;			/* t1 : ssssssssDDCCBBAA */
+
+	return t1;
+}
+#define __arch_swab32 __arch_swab32
+
+#endif /* __GNUC__ */
+
+#endif /* _ALPHA_SWAB_H */
-- 
1.6.1.94.g9388


