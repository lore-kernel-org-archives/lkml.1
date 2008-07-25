Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYGYCP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYGYCP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYGYCOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:14:54 -0400
Received: from ozlabs.org ([203.10.76.45]:48212 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYGYCOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:14:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/4] typesafe: cast_if_type: allow macros functions which take more than one type.
Date: Fri, 25 Jul 2008 12:14:51 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Harvey Harrison <harvey.harrison@gmail.com>
References: <200807251213.17773.rusty@rustcorp.com.au>
In-Reply-To: <200807251213.17773.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251214.51807.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To create functions which can take two types, but still warn on any
other types, we need a way of casting one type and no others.

To make things more complex, it should correctly handle function args,
NULL, and be usable in initializers.  __builtin_choose_expr was
introduced in gcc 3.1 (kernel needs >= 3.2 anyway).

(includes Harvey Harrison <harvey.harrison@gmail.com>'s sparse fix)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/compiler-gcc.h   |   18 ++++++++++++++++++
 include/linux/compiler-intel.h |    2 ++
 2 files changed, 20 insertions(+)

diff -r ecbc022961d8 include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h	Mon Jul 14 12:30:35 2008 +1000
+++ b/include/linux/compiler-gcc.h	Mon Jul 14 20:46:23 2008 +1000
@@ -61,3 +61,21 @@
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
+#define cast_if_type(expr, oktype, desttype)	__builtin_choose_expr(	\
+	__builtin_types_compatible_p(typeof(1?(expr):(expr)), oktype),	\
+	(desttype)(expr), (expr))
diff -r ecbc022961d8 include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h	Mon Jul 14 12:30:35 2008 +1000
+++ b/include/linux/compiler-intel.h	Mon Jul 14 20:46:23 2008 +1000
@@ -29,3 +29,5 @@
 #endif
 
 #define uninitialized_var(x) x
+
+#define cast_if_type(expr, oktype, desttype) ((desttype)(expr))
