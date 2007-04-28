Return-Path: <linux-kernel-owner+w=401wt.eu-S1030940AbXD1CYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030940AbXD1CYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030949AbXD1CYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:24:00 -0400
Received: from gw.goop.org ([64.81.55.164]:49743 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030940AbXD1CX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:23:59 -0400
Message-ID: <4632B040.1080008@goop.org>
Date: Fri, 27 Apr 2007 19:24:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, Keir Fraser <Keir.Fraser@cl.cam.ac.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add kvasprintf()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a kvasprintf() function to compliment kasprintf().

[ No in-tree users yet, but I have some coming up. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Keir Fraser <keir@xensource.com>

---
 include/linux/kernel.h |    1 +
 lib/vsprintf.c         |   28 ++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 8 deletions(-)

===================================================================
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -121,6 +121,7 @@ extern int vscnprintf(char *buf, size_t 
 	__attribute__ ((format (printf, 3, 0)));
 extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
+extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 
 extern int sscanf(const char *, const char *, ...)
 	__attribute__ ((format (scanf, 2, 3)));
===================================================================
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -851,22 +851,34 @@ EXPORT_SYMBOL(sscanf);
 
 
 /* Simplified asprintf. */
-char *kasprintf(gfp_t gfp, const char *fmt, ...)
-{
-	va_list ap;
+char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
+{
 	unsigned int len;
 	char *p;
-
-	va_start(ap, fmt);
-	len = vsnprintf(NULL, 0, fmt, ap);
-	va_end(ap);
+	va_list aq;
+
+	va_copy(aq, ap);
+	len = vsnprintf(NULL, 0, fmt, aq);
+	va_end(aq);
 
 	p = kmalloc(len+1, gfp);
 	if (!p)
 		return NULL;
+
+	vsnprintf(p, len+1, fmt, ap);
+
+	return p;
+}
+
+char *kasprintf(gfp_t gfp, const char *fmt, ...)
+{
+	va_list ap;
+	char *p;
+
 	va_start(ap, fmt);
-	vsnprintf(p, len+1, fmt, ap);
+	p = kvasprintf(gfp, fmt, ap);
 	va_end(ap);
+
 	return p;
 }
 


