Return-Path: <linux-kernel-owner+w=401wt.eu-S936892AbXHNW5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936892AbXHNW5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935950AbXHNWy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:54:27 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43204 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935928AbXHNWyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:54:21 -0400
Message-Id: <20070814224337.547449183@breakpoint.cc>
References: <20070814223845.518697567@breakpoint.cc>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 00:38:46 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@suse.de>
Subject: [patch 1/2] i386: use asm() like the other atomic operations already do.
Content-Disposition: inline; filename=atomic_i386.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As Segher pointed out, inline asm is better than the volatile casting all over
the place. From the PowerPC patch description:
 Also use inline functions instead of macros; this actually
 improves code generation (some code becomes a little smaller,
 probably because of improved alias information -- just a few
 hundred bytes total on a default kernel build, nothing shocking).

My config with march=pentium-m and gcc (GCC) 4.1.2 (Gentoo 4.1.2):
  text    data     bss     dec     hex filename
3434150  249176  176128 3859454  3ae3fe atomic_normal/vmlinux
3435308  249176  176128 3860612  3ae884 atomic_inlineasm/vmlinux
3436201  249176  176128 3861505  3aec01 atomic_inline_volatile/vmlinux
3436203  249176  176128 3861507  3aec03 atomic_volatile/vmlinux

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- a/include/asm-i386/atomic.h
+++ b/include/asm-i386/atomic.h
@@ -22,19 +22,34 @@ typedef struct { int counter; } atomic_t
 /**
  * atomic_read - read atomic variable
  * @v: pointer of type atomic_t
- * 
+ *
  * Atomically reads the value of @v.
- */ 
-#define atomic_read(v)		((v)->counter)
+ */
+static __inline__ int atomic_read(const atomic_t *v)
+{
+	int t;
+
+	__asm__ __volatile__(
+			"movl %1,%0"
+			: "=r"(t)
+			: "m"(v->counter));
+	return t;
+}
 
 /**
  * atomic_set - set atomic variable
  * @v: pointer of type atomic_t
  * @i: required value
- * 
+ *
  * Atomically sets the value of @v to @i.
- */ 
-#define atomic_set(v,i)		(((v)->counter) = (i))
+ */
+static __inline__ void atomic_set(atomic_t *v, int i)
+{
+	__asm__ __volatile__(
+			"movl %1,%0"
+			: "=m"(v->counter)
+			: "ir"(i));
+}
 
 /**
  * atomic_add - add integer to atomic variable

-- 

