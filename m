Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbZDWPG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbZDWPG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbZDWPGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:06:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46708 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbZDWPGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:06:49 -0400
Date: Thu, 23 Apr 2009 17:10:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, torvalds@osdl.org, akpm@osdl.org
Subject: Re: [PATCH] Eliminate thousands of warnings in WARN_ON with gcc 3.2 build
Message-ID: <20090423151024.GO13896@one.firstfloor.org>
References: <20090422221134.GA1753@basil.nowhere.org> <20090423120219.GA23479@cmpxchg.org> <20090423122327.GN13896@one.firstfloor.org> <20090423143859.GA20453@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423143859.GA20453@cmpxchg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:38:59PM +0200, Johannes Weiner wrote:
> > +void warn_slowpath_null(const char *file, int line)
> > +{
> > +	warn_slowpath_fmt(file, line, (const char *) { 0 });
> > +}
> > +EXPORT_SYMBOL(warn_slowpath_null);
> 
> I would WTF here without knowing the warning.  Can you add a comment?
> 
> Otherwise, Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Ok version with comment.

-Andi

---


Eliminate thousands of warnings with gcc 3.2 build v3

When building with gcc 3.2 I get thousands of warnings about passing
a NULL format string to warn_on_slowpath(). Split this case out
into a separate call. This also shrinks the kernel slightly:

          text    data     bss     dec     hex filename
       4802274  707668  712704 6222646  5ef336 vmlinux
          text    data     bss     dec     hex filename
       4799027  703572  712704 6215303  5ed687 vmlinux

v2: Avoid warning in warn_slowpath_null on newer gccs too (J.Weiner)
v3: add comment, size numbers

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/asm-generic/bug.h |    7 ++++---
 kernel/panic.c            |   13 ++++++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6.30-rc2-ak/include/asm-generic/bug.h
===================================================================
--- linux-2.6.30-rc2-ak.orig/include/asm-generic/bug.h	2009-01-11 20:20:40.000000000 +0100
+++ linux-2.6.30-rc2-ak/include/asm-generic/bug.h	2009-04-22 23:52:48.000000000 +0200
@@ -58,12 +58,13 @@
  */
 #ifndef __WARN
 #ifndef __ASSEMBLY__
-extern void warn_slowpath(const char *file, const int line,
+extern void warn_slowpath_fmt(const char *file, const int line,
 		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
+extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #endif
-#define __WARN()		warn_slowpath(__FILE__, __LINE__, NULL)
-#define __WARN_printf(arg...)	warn_slowpath(__FILE__, __LINE__, arg)
+#define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
+#define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
 #else
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
 #endif
Index: linux-2.6.30-rc2-ak/kernel/panic.c
===================================================================
--- linux-2.6.30-rc2-ak.orig/kernel/panic.c	2009-04-19 19:29:07.000000000 +0200
+++ linux-2.6.30-rc2-ak/kernel/panic.c	2009-04-23 17:05:01.000000000 +0200
@@ -342,7 +342,7 @@
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
-void warn_slowpath(const char *file, int line, const char *fmt, ...)
+void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
 {
 	va_list args;
 	char function[KSYM_SYMBOL_LEN];
@@ -358,7 +358,7 @@
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
 
-	if (fmt) {
+	if (*fmt) {
 		va_start(args, fmt);
 		vprintk(fmt, args);
 		va_end(args);
@@ -369,7 +369,14 @@
 	print_oops_end_marker();
 	add_taint(TAINT_WARN);
 }
-EXPORT_SYMBOL(warn_slowpath);
+EXPORT_SYMBOL(warn_slowpath_fmt);
+
+void warn_slowpath_null(const char *file, int line)
+{
+	/* The { 0 } avoids a gcc format warning */
+	warn_slowpath_fmt(file, line, (const char *) { 0 });
+}
+EXPORT_SYMBOL(warn_slowpath_null);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR

-- 
ak@linux.intel.com -- Speaking for myself only.
