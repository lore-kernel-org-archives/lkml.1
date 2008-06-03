Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYFCJ1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYFCJ1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 05:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbYFCJ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 05:27:43 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1257 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYFCJ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 05:27:42 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, pavel@suse.cz,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       mingo@elte.hu
Subject: [PATCH] add a printk_init variant storing format strings in __initdata
References: <20080529162257.03426e48.akpm@linux-foundation.org>
InReply-To: <20080529162257.03426e48.akpm@linux-foundation.org>
Date: Tue, 3 Jun 2008 10:27:32 +0100
Message-Id: <1212485252.0@pinky>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[As gcc seems unable to help us out selecting the appropriate data segment
for the code, how about we did something like this?]

When using printk from __init functions it would be desirable to place
the printk format strings in __initdata.  Add a printk_init() variant
which does this.

This printk_init() is necessarily a #define so that we can declare the
format string in static scope and mark it __initdata.  We then call a
newly introduced __printk_init() variant which is identicle to printk() but
marked __init itself.  By ensuring that an __init variant of printk is used
we get proper section violation warnings when this is used incorrectly:

    WARNING: vmlinux.o(.text+0x3): Section mismatch in reference from the
	function something() to the variable .init.data:__printk_init_fmt.31426
    The function something() references
    the variable __initdata __printk_init_fmt.31426.
    This is often because something lacks a __initdata
    annotation or the annotation of __printk_init_fmt.31426 is wrong.

Note I have followed printk's pattern for __cold annotations.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 include/linux/kernel.h |   10 ++++++++++
 kernel/printk.c        |   12 ++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 792bf0a..7754196 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -180,6 +180,13 @@ struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
 #ifdef CONFIG_PRINTK
+#define printk_init(fmt, args...) \
+do { \
+        static char __printk_init_fmt[] __initdata = fmt; \
+        __printk_init(__printk_init_fmt, ##args); \
+} while (0)
+asmlinkage int __printk_init(const char * fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) __cold;
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
@@ -196,6 +203,9 @@ extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 #else
+asmlinkage int printk_init(const char * fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) __cold;
+static inline int __cold printk_init(const char *s, ...) { return 0; }
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 static inline int vprintk(const char *s, va_list args) { return 0; }
diff --git a/kernel/printk.c b/kernel/printk.c
index 8fb01c3..992a5c0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -616,6 +616,18 @@ asmlinkage int printk(const char *fmt, ...)
 	return r;
 }
 
+asmlinkage __init int __printk_init(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = vprintk(fmt, args);
+	va_end(args);
+
+	return r;
+}
+
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
 
