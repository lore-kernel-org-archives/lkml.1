Return-Path: <linux-kernel-owner+w=401wt.eu-S1767516AbXEDBXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767516AbXEDBXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 21:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767575AbXEDBXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 21:23:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:19801 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767516AbXEDBXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 21:23:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=SjlCBtGe0hEqmtTUxw25wI0EvedJStoPC6PUVHeF8igPpSSAbWXvMPA6ZjtFFiFl4
	C9KPnk8xz9DJEX9REjRYQ==
Date: Thu, 3 May 2007 18:21:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Adrian Bunk <bunk@stusta.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [patch] compiler: introduce __used and __maybe_unused
In-Reply-To: <20070504004636.GU3531@stusta.de>
Message-ID: <Pine.LNX.4.64.0705031821350.8234@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705031734520.21416@chino.kir.corp.google.com>
 <20070504004636.GU3531@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__used is defined to be __attribute__((unused)) for all pre-3.4 gcc
compilers to suppress warnings for unused functions because perhaps they
are referenced only in inline assembly.  It is defined to be 
__attribute__((used)) for gcc 3.4 and later so that the code is still
emitted for such functions.

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
 include/linux/compiler-gcc3.h |    6 ++++--
 include/linux/compiler-gcc4.h |    3 ++-
 include/linux/compiler.h      |   21 ++++++++++++++++++---
 4 files changed, 25 insertions(+), 6 deletions(-)

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
@@ -4,9 +4,11 @@
 #include <linux/compiler-gcc.h>
 
 #if __GNUC_MINOR__ >= 3
-# define __attribute_used__	__attribute__((__used__))
+# define __used			__attribute__((__used__))
+# define __attribute_used__	__used				/* deprecated */
 #else
-# define __attribute_used__	__attribute__((__unused__))
+# define __used			__attribute__((__unused__))
+# define __attribute_used__	__used				/* deprecated */
 #endif
 
 #if __GNUC_MINOR__ >= 4
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
@@ -108,15 +108,30 @@ extern void __chk_io_ptr(const void __iomem *);
  * Allow us to avoid 'defined but not used' warnings on functions and data,
  * as well as force them to be emitted to the assembly file.
  *
- * As of gcc 3.3, static functions that are not marked with attribute((used))
- * may be elided from the assembly file.  As of gcc 3.3, static data not so
+ * As of gcc 3.4, static functions that are not marked with attribute((used))
+ * may be elided from the assembly file.  As of gcc 3.4, static data not so
  * marked will not be elided, but this may change in a future gcc version.
  *
+ * NOTE: Because distributions shipped with a backported unit-at-a-time
+ * compiler in gcc 3.3, we must define __used to be __attribute__((used))
+ * for gcc >=3.3 instead of 3.4.
+ *
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
