Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbYDDSu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbYDDSu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbYDDSun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:50:43 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:28304 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568AbYDDSum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:50:42 -0400
Date: Fri, 4 Apr 2008 20:49:30 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] x86: finalize bitops unification
Message-ID: <20080404184930.GA8978@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Fri, 04 Apr 2008 20:50:28 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.81; VDF: 7.0.3.121; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: finalize bitops unification

include/asm-x86/bitops_32.h and include/asm-x86/bitops_64.h are now
almost identical. The 64-bit version sets ARCH_HAS_FAST_MULTIPLIER
and has an extra inline function set_bit_string. The define currently
has no influence on the generated code, but it can be argued that
setting it on i386 is the right thing to do anyhow. The addition
of the extra inline function on i386 does not hurt either.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hi Ingo,

This patch finishes the bitops unification.

Greetings,
	Alexander

 include/asm-x86/bitops.h    |   38 +++++++++++++++++++++++++++++++++-----
 include/asm-x86/bitops_32.h |   30 ------------------------------
 include/asm-x86/bitops_64.h |   42 ------------------------------------------
 3 files changed, 33 insertions(+), 77 deletions(-)

diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index a66143a..b81a4d4 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -401,10 +401,38 @@ static inline int fls(int x)
 #undef BIT_ADDR
 #undef ADDR
 
-#ifdef CONFIG_X86_32
-# include "bitops_32.h"
-#else
-# include "bitops_64.h"
-#endif
+static inline void set_bit_string(unsigned long *bitmap,
+		unsigned long i, int len)
+{
+	unsigned long end = i + len;
+	while (i < end) {
+		__set_bit(i, bitmap);
+		i++;
+	}
+}
+
+#ifdef __KERNEL__
+
+#include <asm-generic/bitops/sched.h>
+
+#define ARCH_HAS_FAST_MULTIPLIER 1
+
+#include <asm-generic/bitops/hweight.h>
 
+#endif /* __KERNEL__ */
+
+#include <asm-generic/bitops/fls64.h>
+
+#ifdef __KERNEL__
+
+#include <asm-generic/bitops/ext2-non-atomic.h>
+
+#define ext2_set_bit_atomic(lock, nr, addr)			\
+	test_and_set_bit((nr), (unsigned long *)(addr))
+#define ext2_clear_bit_atomic(lock, nr, addr)			\
+	test_and_clear_bit((nr), (unsigned long *)(addr))
+
+#include <asm-generic/bitops/minix.h>
+
+#endif /* __KERNEL__ */
 #endif	/* _ASM_X86_BITOPS_H */
diff --git a/include/asm-x86/bitops_32.h b/include/asm-x86/bitops_32.h
deleted file mode 100644
index 2e86302..0000000
--- a/include/asm-x86/bitops_32.h
+++ /dev/null
@@ -1,30 +0,0 @@
-#ifndef _I386_BITOPS_H
-#define _I386_BITOPS_H
-
-/*
- * Copyright 1992, Linus Torvalds.
- */
-#ifdef __KERNEL__
-
-#include <asm-generic/bitops/sched.h>
-
-#include <asm-generic/bitops/hweight.h>
-
-#endif /* __KERNEL__ */
-
-#include <asm-generic/bitops/fls64.h>
-
-#ifdef __KERNEL__
-
-#include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock, nr, addr)			\
-	test_and_set_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)			\
-	test_and_clear_bit((nr), (unsigned long *)(addr))
-
-#include <asm-generic/bitops/minix.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* _I386_BITOPS_H */
diff --git a/include/asm-x86/bitops_64.h b/include/asm-x86/bitops_64.h
deleted file mode 100644
index cb23122..0000000
--- a/include/asm-x86/bitops_64.h
+++ /dev/null
@@ -1,42 +0,0 @@
-#ifndef _X86_64_BITOPS_H
-#define _X86_64_BITOPS_H
-
-/*
- * Copyright 1992, Linus Torvalds.
- */
-static inline void set_bit_string(unsigned long *bitmap, unsigned long i,
-				  int len)
-{
-	unsigned long end = i + len;
-	while (i < end) {
-		__set_bit(i, bitmap);
-		i++;
-	}
-}
-
-#ifdef __KERNEL__
-
-#include <asm-generic/bitops/sched.h>
-
-#define ARCH_HAS_FAST_MULTIPLIER 1
-
-#include <asm-generic/bitops/hweight.h>
-
-#endif /* __KERNEL__ */
-
-#include <asm-generic/bitops/fls64.h>
-
-#ifdef __KERNEL__
-
-#include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock, nr, addr)			\
-	test_and_set_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)			\
-	test_and_clear_bit((nr), (unsigned long *)(addr))
-
-#include <asm-generic/bitops/minix.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* _X86_64_BITOPS_H */
