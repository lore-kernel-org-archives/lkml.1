Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbXD2JZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbXD2JZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 05:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXD2JZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 05:25:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090AbXD2JZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 05:25:27 -0400
Date: Sun, 29 Apr 2007 02:24:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bbpetkov@yahoo.de
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized
 spinlock. was: Re: 2.6.21-rc7-mm2
Message-Id: <20070429022440.cb8fc8c4.akpm@linux-foundation.org>
In-Reply-To: <20070429065049.GB4446@gollum.tnic>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<20070426182519.GA4532@gollum.tnic>
	<20070427172230.94b82829.akpm@linux-foundation.org>
	<4633DD55.1020006@shadowen.org>
	<20070429065049.GB4446@gollum.tnic>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 08:50:49 +0200 Borislav Petkov <bbpetkov@yahoo.de> wrote:

> Introduce a macro for suppressing gcc from generating a warning about a probable
> unitialized state of a variable.

I ended up doing the below.

It's better to make this a per-compiler-version thing: later versions of
gcc might need different tricks, or might provide __attribute__((stfu)) or
whatever.

Plus I don't know if the x=x trick is needed on the intel compiler, nor if
it even works, so I left ICC alone.




From: Borislav Petkov <bbpetkov@yahoo.de>

Introduce a macro for suppressing gcc from generating a warning about a
probable uninitialized state of a variable.

Example:

-	spinlock_t *ptl;
+	spinlock_t *uninitialized_var(ptl);

Not a happy solution, but those warnings are obnoxious.

- Using the usual pointlessly-set-it-to-zero approach wastes several
  bytes of text.

- Using a macro means we can (hopefully) do something else if gcc changes
  cause the `x = x' hack to stop working

- Using a macro means that people who are worried about hiding true bugs
  can easily turn it off.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc3.h  |    6 ++++++
 include/linux/compiler-gcc4.h  |    6 ++++++
 include/linux/compiler-intel.h |    2 ++
 3 files changed, 14 insertions(+)

diff -puN include/linux/compiler-gcc3.h~add-unitialized_var-macro-for-suppressing-gcc-warnings include/linux/compiler-gcc3.h
--- a/include/linux/compiler-gcc3.h~add-unitialized_var-macro-for-suppressing-gcc-warnings
+++ a/include/linux/compiler-gcc3.h
@@ -13,4 +13,10 @@
 #define __must_check		__attribute__((warn_unused_result))
 #endif
 
+/*
+ * A trick to suppress uninitialized variable warning without generating any
+ * code
+ */
+#define uninitialized_var(x) x = x
+
 #define __always_inline		inline __attribute__((always_inline))
diff -puN include/linux/compiler-gcc4.h~add-unitialized_var-macro-for-suppressing-gcc-warnings include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~add-unitialized_var-macro-for-suppressing-gcc-warnings
+++ a/include/linux/compiler-gcc4.h
@@ -16,3 +16,9 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 #define __always_inline		inline __attribute__((always_inline))
+
+/*
+ * A trick to suppress uninitialized variable warning without generating any
+ * code
+ */
+#define uninitialized_var(x) x = x
diff -puN include/linux/compiler-intel.h~add-unitialized_var-macro-for-suppressing-gcc-warnings include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h~add-unitialized_var-macro-for-suppressing-gcc-warnings
+++ a/include/linux/compiler-intel.h
@@ -22,3 +22,5 @@
     (typeof(ptr)) (__ptr + (off)); })
 
 #endif
+
+#define uninitialized_var(x) x
_

