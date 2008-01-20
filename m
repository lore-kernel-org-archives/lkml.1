Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYATJwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYATJwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 04:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYATJwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 04:52:24 -0500
Received: from ozlabs.org ([203.10.76.45]:60774 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbYATJwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 04:52:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/6] typesafe: cast_if_type to allow macros functions which take more than one type.
Date: Sun, 20 Jan 2008 20:51:42 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
References: <200801202046.14746.rusty@rustcorp.com.au> <200801202048.34796.rusty@rustcorp.com.au> <200801202050.41495.rusty@rustcorp.com.au>
In-Reply-To: <200801202050.41495.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801202051.42958.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To create functions which can take two types, but still warn on any
other types, we need a way of casting one type and no others.

To make things more complex, it should correctly handle function args,
NULL, and be usable in initializers.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

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
