Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbYAUX21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbYAUX21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763293AbYAUX2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:28:00 -0500
Received: from ozlabs.org ([203.10.76.45]:58973 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763043AbYAUX17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:27:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 0/6] RFC: Typesafe callbacks
Date: Tue, 22 Jan 2008 10:27:14 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
References: <200801202046.14746.rusty@rustcorp.com.au> <200801212233.04989.rusty@rustcorp.com.au> <47949257.1000102@gmail.com>
In-Reply-To: <47949257.1000102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801221027.15002.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008 23:38:47 Tejun Heo wrote:
> Rusty Russell wrote:
> > On Monday 21 January 2008 09:17:30 Rusty Russell wrote:
> >> But it would be cool to allow functions which take an unsigned long.
> >> I'll test this out and see what I can make...
> >
> > I think this comes under "too ugly", but here's an attempt.
>
> Maybe we should be content with pointer type checking.  It seems like
> it's going too far and after all the clutter it's not possible to use
> int as argument.  :-(

It is possible, but the function has to take an unsigned long.

But I share your dislike of this.  Here's my final version, but it's still
ugly.

Rusty.

===
Attempt to create callbacks which take unsigned long as well as
correct pointer types.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/compiler-gcc.h   |   61 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compiler-intel.h |    3 ++
 include/linux/kernel.h         |   21 ++++++++++++++
 3 files changed, 85 insertions(+)

diff -r 951ffe1c5238 include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h	Tue Jan 22 09:31:56 2008 +1100
+++ b/include/linux/compiler-gcc.h	Tue Jan 22 10:15:15 2008 +1100
@@ -53,3 +53,64 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
+
+/* This is not complete: I can't figure out a way to handle enums. */
+#define ulong_compatible(arg)						\
+	(__builtin_types_compatible_p(typeof(arg), char)		\
+	 || __builtin_types_compatible_p(typeof(arg), unsigned char)	\
+	 || __builtin_types_compatible_p(typeof(arg), signed char)	\
+	 || __builtin_types_compatible_p(typeof(arg), unsigned short)	\
+	 || __builtin_types_compatible_p(typeof(arg), short)		\
+	 || __builtin_types_compatible_p(typeof(arg), unsigned int)	\
+	 || __builtin_types_compatible_p(typeof(arg), int)		\
+	 || __builtin_types_compatible_p(typeof(arg), unsigned long)	\
+	 || __builtin_types_compatible_p(typeof(arg), long))
+
+/**
+ * typesafe_fn_and_arg - cast function type and arg if compatible
+ * @fn: the function or function pointer
+ * @arg: the function argument.
+ * @ulongtype: the function pointer type if arg is an integer
+ * @safetype: the function pointer type which matches typeof(arg)
+ * @voidtype: the function pointer type which takes a void * (to cast to)
+ *
+ * This macro evaluates to two comma separated values: the function pointer,
+ * then the argument.
+ *
+ * Callback functions are usually declared to take a "void *arg"
+ * argument, which stops the compiler from doing type checking.  We
+ * can freely cast to function pointer which takes "void *" in two
+ * cases: a function which takes a different pointer type or an
+ * unsigned long.
+ *
+ * Typechecking is done by the caller when they assign or pass these
+ * values.  This macro handles the cases where @fn takes an unsigned
+ * long and @arg is compatible with that, and also the case where @fn
+ * and @arg match types.  For other cases, @fn is not cast, so using
+ * the results of this macro should cause a warning unless @fn is
+ * already of if type @voidtype.
+ *
+ * Logic looks like this:
+ * if (typeof(@arg) compatible with unsigned long) {
+ *     if (typeof(@fn) == @ulongtype)
+ *         (@voidtype)@fn and (void *)(unsigned long)@arg; // OK!
+ *     else
+ *         @fn and @arg; // @fn will warn unless it's of @voidtype already.
+ * } else if (typeof(@fn) == @safetype)
+ *     (@voidtype)@fn and @arg; // OK: @arg will warn unless it's a pointer.
+ * else
+ *     @fn and @arg; // @fn will warn unless it's of @voidtype already.
+ */
+#define typesafe_fn_and_arg(fn, arg, ulongtype, safetype, voidtype)	\
+__builtin_choose_expr((ulong_compatible(arg)				\
+		       && __builtin_types_compatible_p(typeof(1?(fn):NULL), \
+						       ulongtype))	\
+		      || (!ulong_compatible(arg)			\
+			  && __builtin_types_compatible_p(typeof(1?(fn):NULL), \
+							  safetype)),	\
+		      ((voidtype)(fn)),					\
+		      (fn)),						\
+__builtin_choose_expr(__builtin_types_compatible_p(typeof(1?(fn):NULL), \
+						   ulongtype),		\
+		      ((void *)(long)(arg)), (arg))
+
diff -r 951ffe1c5238 include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h	Tue Jan 22 09:31:56 2008 +1100
+++ b/include/linux/compiler-intel.h	Tue Jan 22 10:15:15 2008 +1100
@@ -29,3 +29,6 @@
 #endif
 
 #define uninitialized_var(x) x
+
+#define typesafe_fn_and_arg(fn, arg, ulongtype, safetype, fntype) \
+	((fntype)(fn)), ((void *)arg)
diff -r 951ffe1c5238 include/linux/kernel.h
--- a/include/linux/kernel.h	Tue Jan 22 09:31:56 2008 +1100
+++ b/include/linux/kernel.h	Tue Jan 22 10:15:15 2008 +1100
@@ -379,6 +379,27 @@ static inline int __attribute__ ((format
 	(void)__tmp; \
 })
 
+/**
+ * callback_and_arg - simple one-argument typesafe callback with argument
+ * @fn: the function or function pointer
+ * @arg: the function argument.
+ * @rettype: the return type of fn
+ *
+ * This macro evaluates to two comma separated values: the function pointer,
+ * then the argument.  It will check that @fn and @arg are compatible with
+ * each other and with a void * callback.  One of
+ * - fn takes a void * and arg is a pointer
+ * - fn takes a typeof(arg) and arg is a pointer
+ * - fn takes an unsigned long and arg is an integer type.
+ *
+ * See typesafe_fn_and_arg() for the gory details.
+ */
+#define callback_and_arg(fn, arg, rettype)		\
+	typesafe_fn_and_arg((fn), (arg),		\
+			    rettype (*)(unsigned long),	\
+			    rettype (*)(typeof(arg)),	\
+			    rettype (*)(void *))
+
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
