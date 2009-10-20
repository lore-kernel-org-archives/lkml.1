Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZJTEbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZJTEbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZJTEbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:31:19 -0400
Received: from ozlabs.org ([203.10.76.45]:48290 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbZJTEbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:31:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH] BUILD_BUG_ON: make it handle more cases
Date: Tue, 20 Oct 2009 14:15:33 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Jan Beulich <JBeulich@novell.com>, sfr@canb.auug.org.au,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
References: <4AC1E15502000078000516B5@vpn.id2.novell.com> <200910201142.34006.rusty@rustcorp.com.au> <1256002193.6546.2.camel@slab>
In-Reply-To: <1256002193.6546.2.camel@slab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910201415.34361.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUILD_BUG_ON used to use the optimizer to do code elimination or fail
at link time; it was changed to first the size of a negative array (a
nicer compile time error), then (in
8c87df457cb58fe75b9b893007917cf8095660a0) to a bitfield.

bitfields: needs a literal constant at parse time, and can't be put under
	"if (__builtin_constant_p(x))" for example.
negative array: can handle anything, but if the compiler can't tell it's
	a constant, silently has no effect.
link time: breaks link if the compiler can't determine the value, but the
	linker output is not usually as informative as a compiler error.

If we use the negative-array-size method *and* the link time trick,
we get the ability to use BUILD_BUG_ON() under __builtin_constant_p()
branches, and maximal ability for the compiler to detect errors at
build time.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -683,12 +683,6 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
-/* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
-
-/* Force a compilation error if condition is constant and true */
-#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
-
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
@@ -696,6 +690,33 @@ struct sysinfo {
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
 #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 
+/**
+ * BUILD_BUG_ON - break compile if a condition is true.
+ * @cond: the condition which the compiler should know is false.
+ *
+ * If you have some code which relies on certain constants being equal, or
+ * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
+ * detect if someone changes it.
+ *
+ * The implementation uses gcc's reluctance to create a negative array, but
+ * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
+ * to inline functions).  So as a fallback we use the optimizer; if it can't
+ * prove the condition is false, it will cause a link error on the undefined
+ * "__build_bug_on_failed".  This error message can be harder to track down
+ * though, hence the two different methods.
+ */
+#ifndef __OPTIMIZE__
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#else
+extern int __build_bug_on_failed;
+#define BUILD_BUG_ON(condition)					\
+	do {							\
+		((void)sizeof(char[1 - 2*!!(condition)]));	\
+		if (condition) __build_bug_on_failed = 1;	\
+	} while(0)
+#endif
+#define MAYBE_BUILD_BUG_ON(condition) BUILD_BUG_ON(condition)
+
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
