Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbXG1UTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbXG1UTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXG1US7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:18:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53330 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115AbXG1US7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:18:59 -0400
Date: Sat, 28 Jul 2007 22:20:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] lib: move kasprintf to a separate file
Message-ID: <20070728202012.GB25619@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0706041419470.7370@math> <20070605231712.ff1df46f.akpm@linux-foundation.org> <Pine.SOC.4.64.0707281950340.20474@math.ut.ee> <20070728200450.GA25619@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070728200450.GA25619@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kasprintf pulls in kmalloc which proved to be fatal for at least
bootimage target on alpha.
Move it to a separate file so only users of kasprintf are exposed
to the dependency on kmalloc.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Meelis Roos <mroos@linux.ee>
---
 lib/Makefile    |    2 +-
 lib/kasprintf.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 lib/vsprintf.c  |   35 -----------------------------------
 3 files changed, 45 insertions(+), 36 deletions(-)
 create mode 100644 lib/kasprintf.c

diff --git a/lib/Makefile b/lib/Makefile
index 6149663..d9e5f1c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for some libs needed in the kernel.
 #
 
-lib-y := ctype.o string.o vsprintf.o cmdline.o \
+lib-y := ctype.o string.o vsprintf.o kasprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
diff --git a/lib/kasprintf.c b/lib/kasprintf.c
new file mode 100644
index 0000000..c5ff1fd
--- /dev/null
+++ b/lib/kasprintf.c
@@ -0,0 +1,44 @@
+/*
+ *  linux/lib/kasprintf.c
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ */
+
+#include <stdarg.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/string.h>
+
+/* Simplified asprintf. */
+char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
+{
+	unsigned int len;
+	char *p;
+	va_list aq;
+
+	va_copy(aq, ap);
+	len = vsnprintf(NULL, 0, fmt, aq);
+	va_end(aq);
+
+	p = kmalloc(len+1, gfp);
+	if (!p)
+		return NULL;
+
+	vsnprintf(p, len+1, fmt, ap);
+
+	return p;
+}
+EXPORT_SYMBOL(kvasprintf);
+
+char *kasprintf(gfp_t gfp, const char *fmt, ...)
+{
+	va_list ap;
+	char *p;
+
+	va_start(ap, fmt);
+	p = kvasprintf(gfp, fmt, ap);
+	va_end(ap);
+
+	return p;
+}
+EXPORT_SYMBOL(kasprintf);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 6b6734d..7b481ce 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -978,38 +978,3 @@ int sscanf(const char * buf, const char * fmt, ...)
 }
 
 EXPORT_SYMBOL(sscanf);
-
-
-/* Simplified asprintf. */
-char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
-{
-	unsigned int len;
-	char *p;
-	va_list aq;
-
-	va_copy(aq, ap);
-	len = vsnprintf(NULL, 0, fmt, aq);
-	va_end(aq);
-
-	p = kmalloc(len+1, gfp);
-	if (!p)
-		return NULL;
-
-	vsnprintf(p, len+1, fmt, ap);
-
-	return p;
-}
-EXPORT_SYMBOL(kvasprintf);
-
-char *kasprintf(gfp_t gfp, const char *fmt, ...)
-{
-	va_list ap;
-	char *p;
-
-	va_start(ap, fmt);
-	p = kvasprintf(gfp, fmt, ap);
-	va_end(ap);
-
-	return p;
-}
-EXPORT_SYMBOL(kasprintf);
-- 
1.5.1.rc3.g84b7-dirty

