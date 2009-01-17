Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbZAQUor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbZAQUor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758671AbZAQUoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:44:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54718 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbZAQUoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:44:38 -0500
Date: Sat, 17 Jan 2009 15:44:21 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org
Subject: Re: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3
	warnings
Message-ID: <20090117204421.GA1700@bombadil.infradead.org>
References: <200901171519.n0HFJZuf028704@harpo.it.uu.se> <20090117161817.GA10825@elte.hu> <49723912.6020108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49723912.6020108@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 12:01:22PM -0800, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> > 
> > hm, that's unfortunate. GCC seems totally on crack for not accepting a 
> > NULL format string.
> > 
> 
> Why should it?  I don't think a NULL pointer as the format to a
> printf-style function is well defined.
> 

How about something utterly evil? (Since you can't pass a zero-length
string to a printf attributed function either...)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 37b82cb..6c9f612 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -58,11 +58,12 @@ struct bug_entry {
  */
 #ifndef __WARN
 #ifndef __ASSEMBLY__
+extern const char * const warn_slowpath_nofmt;
 extern void warn_slowpath(const char *file, const int line,
 		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 #define WANT_WARN_ON_SLOWPATH
 #endif
-#define __WARN()		warn_slowpath(__FILE__, __LINE__, NULL)
+#define __WARN()		warn_slowpath(__FILE__, __LINE__, warn_slowpath_nofmt)
 #define __WARN_printf(arg...)	warn_slowpath(__FILE__, __LINE__, arg)
 #else
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
diff --git a/kernel/panic.c b/kernel/panic.c
index 2a2ff36..af749af 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -324,6 +324,8 @@ void oops_exit(void)
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
+
+const char * const warn_slowpath_nofmt = "";
 void warn_slowpath(const char *file, int line, const char *fmt, ...)
 {
 	va_list args;
@@ -340,7 +342,7 @@ void warn_slowpath(const char *file, int line, const char *fmt, ...)
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
 
-	if (fmt) {
+	if (fmt != warn_slowpath_nofmt) {
 		va_start(args, fmt);
 		vprintk(fmt, args);
 		va_end(args);
