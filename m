Return-Path: <linux-kernel-owner+w=401wt.eu-S1767528AbXEDAgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767528AbXEDAgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767532AbXEDAgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:36:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10464 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767528AbXEDAgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:36:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=pTb47pDCad11WPaUeF9I9aR6t+hFykNWeMuyfWQIofieV2Huzn4mSkF4CVlh2Rn5Y
	oBLFqHLpcV+6yMFj+WgEg==
Date: Thu, 3 May 2007 17:35:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: [patch] compiler: introduce __used and __maybe_unused
Message-ID: <Pine.LNX.4.64.0705031734520.21416@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__used is defined to be __attribute__((unused)) for all pre-3.4 gcc
compilers to suppress warnings for unused functions because perhaps they
are referenced only in inline assembly.  It is defined to be 
__attribute__((used)) for gcc 3.4 and later so that the code is still
emitted for such functions.

There was a mistake in the current implementation of __attribute_used__
whereas it would be defined to be __attribute__((used)) incorrectly for
gcc 3.3 and later.  The unit-at-a-time compilation scheme was only
introduced in gcc 3.4 and later versions as specified in 
http://www.gnu.org/software/gcc/gcc-3.4/changes.html.

__maybe_unused is defined to be __attribute__((unused)) for both function
and variable use if it could possibly be unreferenced due to the
evaluation of preprocessor macros.  Function prototypes shall be marked
with __maybe_unused if the actual definition of the function is dependant
on preprocessor macros.

No update to compiler-intel.h is necessary because ICC supports both
__attribute__((used)) and __attribute__((unused)) as specified by the
gcc manual.

__attribute_used__ is deprecated and will be removed once all current
code is converted to using __used.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrian Bunk <bunk@stusta.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/compiler-gcc.h  |    1 +
 include/linux/compiler-gcc3.h |   13 ++++++-------
 include/linux/compiler-gcc4.h |    3 ++-
 include/linux/compiler.h      |   17 ++++++++++++++---
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -37,3 +37,4 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_pure__		__attribute__((pure))
 #define __attribute_const__		__attribute__((__const__))
+#define __maybe_unused			__attribute__((unused))
diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc3.h
--- a/include/linux/compiler-gcc3.h
+++ b/include/linux/compiler-gcc3.h
@@ -3,14 +3,13 @@
 /* These definitions are for GCC v3.x.  */
 #include <linux/compiler-gcc.h>
 
-#if __GNUC_MINOR__ >= 3
-# define __attribute_used__	__attribute__((__used__))
-#else
-# define __attribute_used__	__attribute__((__unused__))
-#endif
-
 #if __GNUC_MINOR__ >= 4
-#define __must_check		__attribute__((warn_unused_result))
+# define __used			__attribute__((__used__))
+# define __attribute_used__	__used				/* deprecated */
+# define __must_check		__attribute__((warn_unused_result))
+#else
+# define __used			__attribute__((__unused__))
+# define __attribute_used__	__used				/* deprecated */
 #endif
 
 #define __always_inline		inline __attribute__((always_inline))
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -12,7 +12,8 @@
 # define __inline		__inline	__attribute__((always_inline))
 #endif
 
-#define __attribute_used__	__attribute__((__used__))
+#define __used			__attribute__((__used__))
+#define __attribute_used__	__used			/* deprecated */
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 #define __always_inline		inline __attribute__((always_inline))
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -108,15 +108,26 @@ extern void __chk_io_ptr(const void __iomem *);
  * Allow us to avoid 'defined but not used' warnings on functions and data,
  * as well as force them to be emitted to the assembly file.
  *
- * As of gcc 3.3, static functions that are not marked with attribute((used))
- * may be elided from the assembly file.  As of gcc 3.3, static data not so
+ * As of gcc 3.4, static functions that are not marked with attribute((used))
+ * may be elided from the assembly file.  As of gcc 3.4, static data not so
  * marked will not be elided, but this may change in a future gcc version.
  *
  * In prior versions of gcc, such functions and data would be emitted, but
  * would be warned about except with attribute((unused)).
+ *
+ * Mark functions that are referenced only in inline assembly as __used so
+ * the code is emitted even though it appears to be unreferenced.
  */
 #ifndef __attribute_used__
-# define __attribute_used__	/* unimplemented */
+# define __attribute_used__	/* deprecated */
+#endif
+
+#ifndef __used
+# define __used			/* unimplemented */
+#endif
+
+#ifndef __maybe_unused
+# define __maybe_unused		/* unimplemented */
 #endif
 
 /*
