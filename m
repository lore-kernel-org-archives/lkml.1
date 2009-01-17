Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbZAQU55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbZAQU55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758343AbZAQU5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:57:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758129AbZAQU5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:57:48 -0500
Date: Sat, 17 Jan 2009 15:57:36 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3
	warnings
Message-ID: <20090117205736.GB1700@bombadil.infradead.org>
References: <200901171519.n0HFJZuf028704@harpo.it.uu.se> <20090117161817.GA10825@elte.hu> <49723912.6020108@zytor.com> <20090117204421.GA1700@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117204421.GA1700@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 03:44:21PM -0500, Kyle McMartin wrote:
> How about something utterly evil? (Since you can't pass a zero-length
> string to a printf attributed function either...)
> 

Or more seriously... There really isn't a particularly nice way to solve
this, since you can't seem attach attributes to usage of the function, just
definitions. :/

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 37b82cb..02f4e9b 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -59,11 +59,32 @@ struct bug_entry {
 #ifndef __WARN
 #ifndef __ASSEMBLY__
 extern void warn_slowpath(const char *file, const int line,
-		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
+		const char *fmt, va_list args); 
+
+static __attribute__((format(printf, 3, 4))) inline void warn_slowpath_chk(const char *file, const int line,
+		const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	warn_slowpath(file, line, fmt, args);
+	va_end(args);
+}
+
+static inline void warn_slowpath_nochk(const char *file, const int line,
+		const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	warn_slowpath(file, line, fmt, args);
+	va_end(args);
+}
+
 #define WANT_WARN_ON_SLOWPATH
 #endif
-#define __WARN()		warn_slowpath(__FILE__, __LINE__, NULL)
-#define __WARN_printf(arg...)	warn_slowpath(__FILE__, __LINE__, arg)
+#define __WARN()		warn_slowpath_nochk(__FILE__, __LINE__, NULL)
+#define __WARN_printf(arg...)	warn_slowpath_chk(__FILE__, __LINE__, arg)
 #else
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
 #endif
diff --git a/kernel/panic.c b/kernel/panic.c
index 2a2ff36..201a50b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -324,9 +324,8 @@ void oops_exit(void)
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
-void warn_slowpath(const char *file, int line, const char *fmt, ...)
+void warn_slowpath(const char *file, int line, const char *fmt, va_list args)
 {
-	va_list args;
 	char function[KSYM_SYMBOL_LEN];
 	unsigned long caller = (unsigned long)__builtin_return_address(0);
 	const char *board;
@@ -340,11 +339,8 @@ void warn_slowpath(const char *file, int line, const char *fmt, ...)
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
 
-	if (fmt) {
-		va_start(args, fmt);
+	if (fmt)
 		vprintk(fmt, args);
-		va_end(args);
-	}
 
 	print_modules();
 	dump_stack();
