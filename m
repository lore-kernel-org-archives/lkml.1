Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbXGXPj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbXGXPj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbXGXPjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:39:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55999 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbXGXPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:39:18 -0400
Date: Tue, 24 Jul 2007 16:39:16 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH][RFC] getting rid of stupid loop in BUG()
Message-ID: <20070724153916.GS21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	AFAICS, the patch below should do it for i386; instead of
using a dummy loop to tell gcc that this sucker never returns,
we do
static void __always_inline __noreturn __BUG(const char *file, int line);
containing the actual asm we want to insert and define BUG() as
__BUG(__FILE__, __LINE__).  It looks safe, but I don't claim enough
experience with gcc __asm__ potential nastiness, so...

Comments, objections?

diff --git a/include/asm-i386/bug.h b/include/asm-i386/bug.h
index b0fd78c..294bc55 100644
--- a/include/asm-i386/bug.h
+++ b/include/asm-i386/bug.h
@@ -7,31 +7,27 @@
  * The offending file and line are encoded encoded in the __bug_table section.
  */
 
-#ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
 
-#ifdef CONFIG_DEBUG_BUGVERBOSE
-#define BUG()								\
-	do {								\
-		asm volatile("1:\tud2\n"				\
-			     ".pushsection __bug_table,\"a\"\n"		\
-			     "2:\t.long 1b, %c0\n"			\
-			     "\t.word %c1, 0\n"				\
-			     "\t.org 2b+%c2\n"				\
-			     ".popsection"				\
-			     : : "i" (__FILE__), "i" (__LINE__),	\
-			     "i" (sizeof(struct bug_entry)));		\
-		for(;;) ;						\
-	} while(0)
+#define BUG() __BUG(__FILE__, __LINE__)
+
+#include <asm-generic/bug.h>
 
+#ifdef CONFIG_BUG
+static void __always_inline __noreturn __BUG(const char *file, int line)
+{
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+	asm volatile("1:\tud2\n"
+		     ".pushsection __bug_table,\"a\"\n"
+		     "2:\t.long 1b, %c0\n"
+		     "\t.word %c1, 0\n"
+		     "\t.org 2b+%c2\n"
+		     ".popsection"
+		     : : "i" (file), "i" (line),
+		     "i" (sizeof(struct bug_entry)));
 #else
-#define BUG()								\
-	do {								\
-		asm volatile("ud2");					\
-		for(;;) ;						\
-	} while(0)
+	asm volatile("ud2");
 #endif
+}
 #endif
-
-#include <asm-generic/bug.h>
 #endif
