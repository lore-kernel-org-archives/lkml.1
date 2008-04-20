Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYDTXA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYDTXA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 19:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYDTXAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 19:00:19 -0400
Received: from ozlabs.org ([203.10.76.45]:56536 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbYDTXAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 19:00:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] cast_if_type: allow macros functions which take more than one type.
Date: Mon, 21 Apr 2008 09:00:16 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200804210859.00080.rusty@rustcorp.com.au>
In-Reply-To: <200804210859.00080.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210900.16242.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To create functions which can take two types, but still warn on any
other types, we need a way of casting one type and no others.

To make things more complex, it should correctly handle function args,
NULL, and be usable in initializers.  __builtin_choose_expr was
introduced in gcc 3.1 (kernel needs >= 3.2 anyway).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/compiler-gcc.h   |   19 +++++++++++++++++++
 include/linux/compiler-intel.h |    2 ++
 2 files changed, 21 insertions(+)

diff -r bde8a949d956 include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h	Mon Apr 07 15:27:30 2008 +1000
+++ b/include/linux/compiler-gcc.h	Mon Apr 07 16:19:49 2008 +1000
@@ -53,3 +53,22 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
+
+/**
+ * cast_if_type - allow an alternate type
+ * @expr: the expression to optionally cast
+ * @oktype: the type to allow.
+ * @desttype: the type to cast to.
+ *
+ * This is used to accept a particular alternate type for an expression:
+ * because any other types will not be cast, they will cause a warning as
+ * normal.
+ *
+ * Note that the unnecessary trinary forces functions to devolve into
+ * function pointers as users expect, but means @expr must be a pointer or
+ * integer.
+ */
+#define cast_if_type(expr, oktype, desttype)				\
+  __builtin_choose_expr(__builtin_types_compatible_p(typeof(1?(expr):0),\
+						     oktype),		\
+			(desttype)(expr), (expr))
diff -r bde8a949d956 include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h	Mon Apr 07 15:27:30 2008 +1000
+++ b/include/linux/compiler-intel.h	Mon Apr 07 16:19:49 2008 +1000
@@ -29,3 +29,5 @@
 #endif
 
 #define uninitialized_var(x) x
+
+#define cast_if_type(expr, oktype, desttype) ((desttype)(expr))
