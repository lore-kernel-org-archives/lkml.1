Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYDTXBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYDTXBa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 19:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYDTXBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 19:01:22 -0400
Received: from ozlabs.org ([203.10.76.45]:56591 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbYDTXBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 19:01:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] typesafe_cb: wrappers for typesafe callbacks.
Date: Mon, 21 Apr 2008 09:01:19 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200804210859.00080.rusty@rustcorp.com.au> <200804210900.16242.rusty@rustcorp.com.au>
In-Reply-To: <200804210900.16242.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210901.20229.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cast_if_type is clever but annoying to use, so we make some slightly
less annoying wrappers for callback registration.

These allow const pointer-taking functions as well as the normal
non-const ones (volatile variant omitted for simplicity).  We also
have a typesafe_cb_preargs() for callbacks which don't just take one
argument.

Here's an example of use:

BEFORE:
	void foo_set_callback(int (*callback)(void *), void *arg);

AFTER:
	#define foo_set_callback(cb, arg) \
		__foo_set_callback(typesafe_cb(int, (cb), (arg)), (arg))
	void __foo_set_callback(int (*callback)(void *), void *arg);

o If cb is of form "int cb(typeof(arg))" or "int cb(const typeof(arg))" it
  will be cast to form "int cb(void *)".
o Otherwise, if cb is not already of form "int cb(void *)" it will cause a
  warning when passed to __foo_set_callback().
o If arg is not a pointer, then handing it to __foo_set_callback() will cause
  a warning.

Note: there are at least two possible additions we don't yet need.  We
don't cover callbacks which take a volatile pointer, even though that
would be fine, and we don't have a typesafe_cb_postargs().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/kernel.h |   63 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff -r 907c55be656f include/linux/kernel.h
--- a/include/linux/kernel.h	Mon Apr 21 06:58:00 2008 +1000
+++ b/include/linux/kernel.h	Mon Apr 21 07:04:02 2008 +1000
@@ -436,4 +436,39 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+/* If fn is of type ok1 or ok2, cast to desttype */
+#define __typesafe_cb(desttype, fn, ok1, ok2) \
+	cast_if_type(cast_if_type((fn), ok1, desttype), ok2, desttype)
+
+/**
+ * typesafe_cb - cast a callback function if it matches the arg
+ * @rettype: the return type of the callback function
+ * @fn: the callback function to cast
+ * @arg: the (pointer) argument to hand to the callback function.
+ *
+ * If a callback function takes a single argument, this macro does
+ * appropriate casts to a function which takes a single void * argument if the
+ * callback provided matches the @arg (or a const or volatile version).
+ *
+ * It is assumed that @arg is of pointer type: usually @arg is passed
+ * or assigned to a void * elsewhere anyway.
+ */
+#define typesafe_cb(rettype, fn, arg)					\
+	__typesafe_cb(rettype (*)(void *), (fn),			\
+		      rettype (*)(const typeof(arg)),			\
+		      rettype (*)(typeof(arg)))
+
+/**
+ * typesafe_cb_preargs - cast a callback function if it matches the arg
+ * @rettype: the return type of the callback function
+ * @fn: the callback function to cast
+ * @arg: the (pointer) argument to hand to the callback function.
+ *
+ * This is a version of typesafe_cb() for callbacks that take other arguments
+ * before the @arg.
+ */
+#define typesafe_cb_preargs(rettype, fn, arg, ...)			\
+	__typesafe_cb(rettype (*)(__VA_ARGS__, void *), (fn),		\
+		      rettype (*)(__VA_ARGS__, const typeof(arg)),	\
+		      rettype (*)(__VA_ARGS__, typeof(arg)))
 #endif
