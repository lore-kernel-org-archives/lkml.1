Return-Path: <linux-kernel-owner+w=401wt.eu-S1764779AbXG0NUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764779AbXG0NUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbXG0NTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:19:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41828 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbXG0NTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:19:53 -0400
Date: Fri, 27 Jul 2007 14:19:52 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [PATCH] more include order horrors
Message-ID: <20070727131952.GZ27237@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	... because somebody had added preempt.h -> list.h, resulting in
asm/system.h -> hardirq.h -> preempt.h -> list.h -> asm/system.h on m68k,
with smp_wmb() used in list.h and defined in asm/system.h below the include
of hardirq.h.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/include/asm-m68k/system.h b/include/asm-m68k/system.h
index 198878b..caa9b16 100644
--- a/include/asm-m68k/system.h
+++ b/include/asm-m68k/system.h
@@ -46,6 +46,22 @@ asmlinkage void resume(void);
 } while (0)
 
 
+/*
+ * Force strict CPU ordering.
+ * Not really required on m68k...
+ */
+#define nop()		do { asm volatile ("nop"); barrier(); } while (0)
+#define mb()		barrier()
+#define rmb()		barrier()
+#define wmb()		barrier()
+#define read_barrier_depends()	((void)0)
+#define set_mb(var, value)	({ (var) = (value); wmb(); })
+
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	((void)0)
+
 /* interrupt control.. */
 #if 0
 #define local_irq_enable() asm volatile ("andiw %0,%%sr": : "i" (ALLOWINT) : "memory")
@@ -70,23 +86,6 @@ static inline int irqs_disabled(void)
 /* For spinlocks etc */
 #define local_irq_save(x)	({ local_save_flags(x); local_irq_disable(); })
 
-/*
- * Force strict CPU ordering.
- * Not really required on m68k...
- */
-#define nop()		do { asm volatile ("nop"); barrier(); } while (0)
-#define mb()		barrier()
-#define rmb()		barrier()
-#define wmb()		barrier()
-#define read_barrier_depends()	((void)0)
-#define set_mb(var, value)	({ (var) = (value); wmb(); })
-
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	((void)0)
-
-
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
 struct __xchg_dummy { unsigned long a[100]; };
