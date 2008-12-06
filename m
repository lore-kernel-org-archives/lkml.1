Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbYLFG74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbYLFG74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 01:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbYLFG7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 01:59:47 -0500
Received: from vps1.tull.net ([66.180.172.116]:52697 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751905AbYLFG7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 01:59:46 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [RFC PATCH v1 1/3] Split the vsnprintf function into two parts
Cc: <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 06 Dec 2008 17:59:43 +1100
Message-ID: <20081206065943.29149.15870.stgit@marcab.local.tull.net>
In-Reply-To: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the vsnprintf function into two parts

Two functions are required for recursion because we want the
recursive part to be able to run (and calcalate the output
size) even beyond its buffer size.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 lib/vsprintf.c |  100 ++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 65 insertions(+), 35 deletions(-)


diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a013bbc..1e2dcaf 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -616,10 +616,15 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
 	return number(buf, end, (unsigned long) ptr, 16, field_width, precision, flags);
 }
 
-/**
- * vsnprintf - Format a string and place it in a buffer
- * @buf: The buffer to place the result into
- * @size: The size of the buffer, including the trailing null space
+/*
+ * __vsnprintfr: Recursive implementation of vsnprintf.
+ *
+ * See the description for vsnprintf, which calls __vsnprintfr.
+ * __vsnprintfr can call itself recursively.
+ *
+ * @buf: The start address of the output buffer
+ * @str: The current write position (may extend beyond the buffer)
+ * @end: One address past the end of the buffer
  * @fmt: The format string to use
  * @args: Arguments for the format string
  *
@@ -628,22 +633,14 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
  * %pF output the name of a function pointer
  * %pR output the address range in a struct resource
  *
- * The return value is the number of characters which would
- * be generated for the given input, excluding the trailing
- * '\0', as per ISO C99. If you want to have the exact
- * number of characters written into @buf as return value
- * (not including the trailing '\0'), use vscnprintf(). If the
- * return is greater than or equal to @size, the resulting
- * string is truncated.
- *
- * Call this function if you are already dealing with a va_list.
- * You probably want snprintf() instead.
  */
-int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+
+static char *__vsnprintfr(char *buf, char *str, char *end,
+			const char *fmt, va_list args)
 {
 	unsigned long long num;
 	int base;
-	char *str, *end, c;
+	char c;
 
 	int flags;		/* flags to number() */
 
@@ -655,25 +652,6 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 				/* 'z' changed to 'Z' --davidm 1/25/99 */
 				/* 't' added for ptrdiff_t */
 
-	/* Reject out-of-range values early.  Large positive sizes are
-	   used for unknown buffer sizes. */
-	if (unlikely((int) size < 0)) {
-		/* There can be only one.. */
-		static char warn = 1;
-		WARN_ON(warn);
-		warn = 0;
-		return 0;
-	}
-
-	str = buf;
-	end = buf + size;
-
-	/* Make sure end is always >= buf */
-	if (end < buf) {
-		end = ((void *)-1);
-		size = end - buf;
-	}
-
 	for (; *fmt ; ++fmt) {
 		if (*fmt != '%') {
 			if (str < end)
@@ -844,12 +822,64 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 		str = number(str, end, num, base,
 				field_width, precision, flags);
 	}
+
+	return str;
+}
+
+/**
+ * vsnprintf - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @args: Arguments for the format string
+ *
+ * Also see __vsnprintfr above.
+ *
+ * The return value is the number of characters which would
+ * be generated for the given input, excluding the trailing
+ * '\0', as per ISO C99. If you want to have the exact
+ * number of characters written into @buf as return value
+ * (not including the trailing '\0'), use vscnprintf(). If the
+ * return is greater than or equal to @size, the resulting
+ * string is truncated.
+ *
+ * Call this function if you are already dealing with a va_list.
+ * You probably want snprintf() instead.
+ */
+
+int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+{
+	char *str, *end;
+
+	/* Reject out-of-range values early.  Large positive sizes are
+	 * used for unknown buffer sizes.
+	 */
+	if (unlikely((int) size < 0)) {
+		/* There can be only one.. */
+		static char warn = 1;
+		WARN_ON(warn);
+		warn = 0;
+		return 0;
+	}
+
+	end = buf + size;
+
+	/* Make sure end is always >= buf */
+	if (end < buf) {
+		end = ((void *)-1);
+		size = end - buf;
+	}
+
+	/* format the args, writing them between 'buf' and 'end' */
+	str = __vsnprintfr(buf, buf, end, fmt, args);
+
 	if (size > 0) {
 		if (str < end)
 			*str = '\0';
 		else
 			end[-1] = '\0';
 	}
+
 	/* the trailing null byte doesn't count towards the total */
 	return str-buf;
 }

