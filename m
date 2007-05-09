Return-Path: <linux-kernel-owner+w=401wt.eu-S969325AbXEIHDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969325AbXEIHDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 03:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967855AbXEIHCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:02:51 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbXEIHCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:02:49 -0400
Date: Wed, 9 May 2007 00:02:11 -0700
Message-Id: <200705090702.l4972B4f029875@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] i386: msr.h: be paranoid about types and parentheses
To: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When implementing things as macros, make sure we use typecasts and
parentheses where needed.  The macros as defined were vulnerable to
surreptitious promotion causing problems.

Avoid macros where practical; e.g. wrmsr() can be an inline instead.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---

This patch depends on the previous patch, "i386: remove unused rdtsc() macro".

 include/asm-i386/msr.h |   49 +++++++++++++++++++++--------------------------
 1 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/include/asm-i386/msr.h b/include/asm-i386/msr.h
index c70773e..df21ea0 100644
--- a/include/asm-i386/msr.h
+++ b/include/asm-i386/msr.h
@@ -86,55 +86,50 @@ static inline unsigned long long native_read_pmc(void)
 
 #define rdmsr(msr,val1,val2)						\
 	do {								\
-		unsigned long long __val = native_read_msr(msr);	\
-		val1 = __val;						\
-		val2 = __val >> 32;					\
+		u64 __val = native_read_msr(msr);			\
+		(val1) = (u32)__val;					\
+		(val2) = (u32)(__val >> 32);				\
 	} while(0)
 
-#define wrmsr(msr,val1,val2)						\
-	native_write_msr(msr, ((unsigned long long)val2 << 32) | val1)
-
-#define rdmsrl(msr,val)					\
-	do {						\
-		(val) = native_read_msr(msr);		\
-	} while(0)
-
-static inline void wrmsrl (unsigned long msr, unsigned long long val)
+static inline void wrmsr(u32 __msr, u32 __low, u32 __high)
 {
-	unsigned long lo, hi;
-	lo = (unsigned long) val;
-	hi = val >> 32;
-	wrmsr (msr, lo, hi);
+	native_write_msr(__msr, ((u64)__high << 32) | __low);
 }
 
+#define rdmsrl(msr,val)							\
+	((val) = native_read_msr(msr))
+
+#define wrmsrl(msr,val)	native_write_msr(msr, val)
+
 /* wrmsr with exception handling */
-#define wrmsr_safe(msr,val1,val2)						\
-	(native_write_msr_safe(msr, ((unsigned long long)val2 << 32) | val1))
+static inline int wrmsr_safe(u32 __msr, u32 __low, u32 __high)
+{
+	return native_write_msr_safe(__msr, ((u64)__high << 32) | __low);
+}
 
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr,p1,p2)						\
 	({								\
 		int __err;						\
-		unsigned long long __val = native_read_msr_safe(msr, &__err);\
-		(*p1) = __val;						\
-		(*p2) = __val >> 32;					\
+		u64 __val = native_read_msr_safe(msr, &__err);		\
+		(*p1) = (u32)__val;					\
+		(*p2) = (u32)(__val >> 32);				\
 		__err;							\
 	})
 
 #define rdtscl(low)						\
-	do {							\
-		(low) = native_read_tsc();			\
-	} while(0)
+	((low) = (u32)native_read_tsc())
 
-#define rdtscll(val) ((val) = native_read_tsc())
+#define rdtscll(val)						\
+	((val) = native_read_tsc())
 
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
 #define rdpmc(counter,low,high)					\
 	do {							\
 		u64 _l = native_read_pmc();			\
-		low = (u32)_l;					\
-		high = _l >> 32;				\
+		(low)  = (u32)_l;				\
+		(high) = (u32)(_l >> 32);			\
 	} while(0)
 #endif	/* !CONFIG_PARAVIRT */
 
-- 
1.5.1.3

