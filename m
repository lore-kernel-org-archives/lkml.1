Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYHQKdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYHQKdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 06:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYHQKdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 06:33:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYHQKdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 06:33:00 -0400
Date: Sun, 17 Aug 2008 12:32:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linuxfoundation.org,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Message-ID: <20080817103241.GB21303@elte.hu>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <200808162055.45136.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808161305170.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0808161305170.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 16 Aug 2008, Rusty Russell wrote:
> > 
> > Interesting idea, but I've come to actually like the semantic explicitness of 
> > BUILD_BUG_ON.  There's a difference between "we should never get here" 
> > and "this should never exist".
> 
> Agreed. I think Alexey's patch is broken.
> 
> The thing is, BUILD_BUG_ON() is a different thing. It says "this is a 
> build error", while BUG_ON() says "this is an error if we reach it".
> 
> Very different.

agreed.

There's one aspect of BUILD_BUG_ON() that is quite dangerous though: it 
does not 'upgrade' into a runtime check if an expression is not 
constant. And it does not warn either. So BUILD_BUG_ON() can degrade 
into a no-op very silently, and that is inherently dangerous.

That aspect bit me once: i added a BUILD_BUG_ON() under the assumption 
that it would catch a mis-sized virtual memory sizing detail in 
arch/x86/, but it just remained silent.

To fix these problems i've added the two commits below to tip/core/debug 
[one to extend BUILD_BUG_ON, one to clean up its location] - any 
objections against that direction? I've started testing it through to 
make sure we dont have any stale non-constant BUILD_BUG_ON() instances 
around.

( Note, i have not changed BUILD_BUG_ON_ZERO() because that is used in 
  structure initializers so no comma expression can be used in them. 
  Such structure initializers wont allow non-constant expressions 
  anyway, so there's not much extra value in checking for that. )

( Note #2, BUILD_BUG_ON() had to remain a macro, so that
  __builtin_constant_expression_p() can do its work. )

	Ingo

>From f5b5d41dd51a31fe70e3a04fb80a3b90b84c6a4e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 17 Aug 2008 11:58:58 +0200
Subject: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

constant expressions get detected at build time via:

  kernel/sched.c: In function ‘test':
  kernel/sched.c:9187: error: size of array ‘type name' is negative
  make[1]: *** [kernel/sched.o] Error 1

but non-constant expressions (for example BUILD_BUG_ON(variable)) simply
get discarded by the compiler - turning BUILD_BUG_ON() into a dangerous
construct.

So add another layer at the link level to detect such mishaps:

  kernel/built-in.o: In function `test':
  : undefined reference to `__BUILD_BUG_ON_non_constant'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2651f80..36c841e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -467,8 +467,22 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
-/* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+/*
+ * Force a compilation error if condition is true [array index becomes
+ * negative], and a linker error if condition is not constant [non-defined
+ * variable is used as an array index]:
+ *
+ * ( The linker trick relies on gcc optimizing out a multiplication with
+ *   constant zero - which should be reasonable enough. )
+ */
+extern unsigned int __BUILD_BUG_ON_non_constant;
+
+#define BUILD_BUG_ON(condition)					\
+do {								\
+	(void)sizeof(char[1 - 2*!!(condition)]);		\
+	if (!__builtin_constant_p(condition))			\
+		__BUILD_BUG_ON_non_constant++;			\
+} while (0)
 
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used

>From 7c516ee411f38cffbd4ab09b089c210202f9bd0f Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 17 Aug 2008 12:18:01 +0200
Subject: [PATCH] debug, x86: move BUILD_BUG_ON() and __FUNCTION__

move BUILD_BUG_ON variants and the __FUNCTION__ definition from
kernel.h to compiler.h.

Besides being the correct location for such trivial wrappers around
compiler functionality, this also allows the removal of a duplicate
(and now slighly incompatible) definition of BUILD_BUG_ON from
arch/x86/boot/boot.h.

[ boot.h cannot just include kernel.h to pick up the new definition of
  BUILD_BUG_ON(), as it is also built into user-space utilities on the
  host system. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/boot/boot.h     |    3 ---
 include/linux/compiler.h |   30 ++++++++++++++++++++++++++++++
 include/linux/kernel.h   |   26 --------------------------
 3 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 616b804..f09b79a 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -27,9 +27,6 @@
 #include "bitops.h"
 #include <asm/cpufeature.h>
 
-/* Useful macros */
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
-
 extern struct setup_header hdr;
 extern struct boot_params boot_params;
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c8bd2da..727862f 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -194,4 +194,34 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+/*
+ * Force a compilation error if condition is true [array index becomes
+ * negative], and a linker error if condition is not constant [non-defined
+ * variable is used as an array index]:
+ *
+ * ( The linker trick relies on gcc optimizing out a multiplication with
+ *   constant zero - which should be reasonable enough. )
+ */
+#ifndef __ASSEMBLY__
+extern unsigned int __BUILD_BUG_ON_non_constant;
+#endif
+
+#define BUILD_BUG_ON(condition)					\
+do {								\
+	(void)sizeof(char[1 - 2*!!(condition)]);		\
+	if (!__builtin_constant_p(condition))			\
+		__BUILD_BUG_ON_non_constant++;			\
+} while (0)
+
+/*
+ * Force a compilation error if condition is true, but also produce a
+ * result (of value 0 and type size_t), so the expression can be used
+ * e.g. in a structure initializer (or where-ever else comma expressions
+ * aren't permitted):
+ */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+
+/* Trap pasters of __FUNCTION__ at compile-time */
+#define __FUNCTION__ (__func__)
+
 #endif /* __LINUX_COMPILER_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 36c841e..1ceafa4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -467,32 +467,6 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
-/*
- * Force a compilation error if condition is true [array index becomes
- * negative], and a linker error if condition is not constant [non-defined
- * variable is used as an array index]:
- *
- * ( The linker trick relies on gcc optimizing out a multiplication with
- *   constant zero - which should be reasonable enough. )
- */
-extern unsigned int __BUILD_BUG_ON_non_constant;
-
-#define BUILD_BUG_ON(condition)					\
-do {								\
-	(void)sizeof(char[1 - 2*!!(condition)]);		\
-	if (!__builtin_constant_p(condition))			\
-		__BUILD_BUG_ON_non_constant++;			\
-} while (0)
-
-/* Force a compilation error if condition is true, but also produce a
-   result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
-   aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
-
-/* Trap pasters of __FUNCTION__ at compile-time */
-#define __FUNCTION__ (__func__)
-
 /* This helps us to avoid #ifdef CONFIG_NUMA */
 #ifdef CONFIG_NUMA
 #define NUMA_BUILD 1
