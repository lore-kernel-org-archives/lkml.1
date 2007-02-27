Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbXB0ERH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbXB0ERH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXB0ERH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:17:07 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:58290 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXB0ERF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:17:05 -0500
Date: Mon, 26 Feb 2007 23:16:48 -0500
From: Kyle McMartin <kyle@parisc-linux.org>
To: linux-kernel@vger.kernel.org
Subject: resource_size_t printk whinging
Message-ID: <20070227041648.GB13669@athena.road.mcmartin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I submitted this patch a while ago, but nobody commented on it.
All these casts of resource_size_t to (unsigned long long) seem horribly
wasteful to me...

Of course, to add a new format qualifier, we lose out on checking the format
string by gcc... Nowadays, this role can be done by sparse.

(Or perhaps gcc can be extended such that a string of allowable qualifiers
 can be passed along in kernel.h, that would just be super...)

This is mostly just to provoke a little bit of further discussion.

Signed-off-by-but-not-really-much-point: Kyle McMartin
	<kyle@parisc-linux.org>

---
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9ddf25c..a79985d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -107,25 +107,16 @@ extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
-extern int sprintf(char * buf, const char * fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int vsprintf(char *buf, const char *, va_list)
-	__attribute__ ((format (printf, 2, 0)));
-extern int snprintf(char * buf, size_t size, const char * fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 3, 0)));
-extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 3, 0)));
-extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-
-extern int sscanf(const char *, const char *, ...)
-	__attribute__ ((format (scanf, 2, 3)));
-extern int vsscanf(const char *, const char *, va_list)
-	__attribute__ ((format (scanf, 2, 0)));
+extern int sprintf(char * buf, const char * fmt, ...);
+extern int vsprintf(char *buf, const char *, va_list);
+extern int snprintf(char * buf, size_t size, const char * fmt, ...);
+extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
+extern int scnprintf(char * buf, size_t size, const char * fmt, ...);
+extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
+extern char *kasprintf(gfp_t gfp, const char *fmt, ...);
+
+extern int sscanf(const char *, const char *, ...);
+extern int vsscanf(const char *, const char *, va_list);
 
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
@@ -140,16 +131,12 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
 extern void dump_thread(struct pt_regs *regs, struct user *dump);
 
 #ifdef CONFIG_PRINTK
-asmlinkage int vprintk(const char *fmt, va_list args)
-	__attribute__ ((format (printf, 1, 0)));
-asmlinkage int printk(const char * fmt, ...)
-	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int vprintk(const char *fmt, va_list args);
+asmlinkage int printk(const char * fmt, ...);
 #else
-static inline int vprintk(const char *s, va_list args)
-	__attribute__ ((format (printf, 1, 0)));
+static inline int vprintk(const char *s, va_list args);
 static inline int vprintk(const char *s, va_list args) { return 0; }
-static inline int printk(const char *s, ...)
-	__attribute__ ((format (printf, 1, 2)));
+static inline int printk(const char *s, ...);
 static inline int printk(const char *s, ...) { return 0; }
 #endif
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b025864..7a0fd29 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -343,7 +343,8 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 		/* get the conversion qualifier */
 		qualifier = -1;
 		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
-		    *fmt =='Z' || *fmt == 'z' || *fmt == 't') {
+		    *fmt == 'Z' || *fmt == 'z' || *fmt == 't' ||
+		    *fmt == 'r' || *fmt == 'R') {
 			qualifier = *fmt;
 			++fmt;
 			if (qualifier == 'l' && *fmt == 'l') {
@@ -477,6 +478,8 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			num = (unsigned short) va_arg(args, int);
 			if (flags & SIGN)
 				num = (signed short) num;
+		} else if (qualifier == 'R' || qualifier == 'R') {
+			num = va_arg(args, resource_size_t);
 		} else {
 			num = va_arg(args, unsigned int);
 			if (flags & SIGN)
