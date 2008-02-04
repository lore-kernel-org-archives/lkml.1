Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYBDMOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYBDMOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYBDMOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:14:35 -0500
Received: from ozlabs.org ([203.10.76.45]:45901 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYBDMOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:14:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/5] cast_if_type: allow macros functions which take more than one type.
Date: Mon, 4 Feb 2008 23:14:18 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200802042311.18762.rusty@rustcorp.com.au>
In-Reply-To: <200802042311.18762.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802042314.18738.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To create functions which can take two types, but still warn on any
other types, we need a way of casting one type and no others.

To make things more complex, it should correctly handle function args,
NULL, and be usable in initializers.  __builtin_choose_expr was introduced
in gcc 3.1 (we need >= 3.2 anyway).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/compiler-gcc.h   |   17 +++++++++++++++++
 include/linux/compiler-intel.h |    2 ++
 2 files changed, 19 insertions(+)

diff -r e6626cc7bdc2 include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h	Sun Jan 20 18:51:51 2008 +1100
+++ b/include/linux/compiler-gcc.h	Sun Jan 20 18:57:14 2008 +1100
@@ -53,3 +53,20 @@
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
+ * function pointers as users expect. */
+#define cast_if_type(expr, oktype, desttype)				\
+  __builtin_choose_expr(__builtin_types_compatible_p(typeof(1?(expr):NULL), \
+						     oktype),		\
+			(desttype)(expr), (expr))
diff -r e6626cc7bdc2 include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h	Sun Jan 20 18:51:51 2008 +1100
+++ b/include/linux/compiler-intel.h	Sun Jan 20 18:57:14 2008 +1100
@@ -29,3 +29,5 @@
 #endif
 
 #define uninitialized_var(x) x
+
+#define cast_if_type(expr, oktype, desttype) ((desttype)(expr))
