Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbYK1QfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbYK1QfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 11:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYK1QfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 11:35:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:38954 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYK1QfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 11:35:06 -0500
Date: Fri, 28 Nov 2008 08:35:25 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [PATCH 1/2] warn: consolidate warn_slowpath and warn_on_slowpath
Message-ID: <20081128083525.092e9859@linux.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7aaa8478fe22e944adf185e465fa07799b87e573 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 28 Nov 2008 08:30:46 -0800
Subject: [PATCH] warn: consolidate warn_slowpath and warn_on_slowpath

warn_slowpath is a superset of warn_on_slowpath; just have
warn_on_slowpath call warn_slowpath with a NULL 3rd argument.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/panic.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index d1ac662..2b913aa 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -324,23 +324,6 @@ void oops_exit(void)
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
-void warn_on_slowpath(const char *file, int line)
-{
-	char function[KSYM_SYMBOL_LEN];
-	unsigned long caller = (unsigned long) __builtin_return_address(0);
-	sprint_symbol(function, caller);
-
-	printk(KERN_WARNING "------------[ cut here ]------------\n");
-	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
-		line, function);
-	print_modules();
-	dump_stack();
-	print_oops_end_marker();
-	add_taint(TAINT_WARN);
-}
-EXPORT_SYMBOL(warn_on_slowpath);
-
-
 void warn_slowpath(const char *file, int line, const char *fmt, ...)
 {
 	va_list args;
@@ -351,9 +334,12 @@ void warn_slowpath(const char *file, int line, const char *fmt, ...)
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
 		line, function);
-	va_start(args, fmt);
-	vprintk(fmt, args);
-	va_end(args);
+
+	if (fmt) {
+		va_start(args, fmt);
+		vprintk(fmt, args);
+		va_end(args);
+	}
 
 	print_modules();
 	dump_stack();
@@ -361,6 +347,12 @@ void warn_slowpath(const char *file, int line, const char *fmt, ...)
 	add_taint(TAINT_WARN);
 }
 EXPORT_SYMBOL(warn_slowpath);
+
+void warn_on_slowpath(const char *file, int line)
+{
+	warn_slowpath(file, line, NULL);
+}
+EXPORT_SYMBOL(warn_on_slowpath);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-- 
1.6.0.4



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
