Return-Path: <linux-kernel-owner+w=401wt.eu-S932243AbYBMJL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbYBMJL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYBMJJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:09:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:22799 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbYBMJJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:09:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XlfraE13GBtGdJlQMB+rOyxwz40TBtPGxmrWD1QnUD3PPdNMKa36POSfZet4NZlWfySwrA9rtgNSQWj12G8o+xGA8fGX7zQFHGUGOjN2nniUfrqjnIrDovqeE/A6ONZPQ6TgHKCVOjoUwONKKTPZdjL5dxpAKmLwDJh1ZxsF1/c=
From: Tejun Heo <htejun@gmail.com>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/5] printk: implement [v]printk_header()
Date: Wed, 13 Feb 2008 18:09:30 +0900
Message-Id: <12028937732647-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12028937731333-git-send-email-htejun@gmail.com>
References: <12028937731333-git-send-email-htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement [v]printk_header() which takes @header argument and
automatically prints header in front of or indents multiline messages.
For example, if @header is "<7>ata1.00: " and the formatted message is
"<6>line0\nline1\n", the following gets written to the console.

<6>ata1.00: line0
<6>ata1.00  line1

As seen above if header ends with ':' followed by any number of
spaces, the colon is replaced with space from the second line.  This
helps to distinguish where a multiline message begins when messages of
similar pattern repeats, for example...

ata8.00: cmd 60/80:20:e1:71:02/00:00:00:00:00/40 tag 4 ncq 65536 in
ata8.00  res 40/00:34:de:71:02/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata8.00  status: { DRDY }
ata8.00: cmd 60/0e:28:d0:71:02/00:00:00:00:00/40 tag 5 ncq 7168 in
ata8.00  res 40/00:34:de:71:02/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata8.00  status: { DRDY }
ata8.00: cmd 60/7f:38:61:72:02/00:00:00:00:00/40 tag 7 ncq 65024 in
ata8.00  res 40/00:34:de:71:02/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata8.00  status: { DRDY }

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 include/linux/kernel.h |   12 ++++++
 kernel/printk.c        |   95 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2df44e7..d885208 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -177,6 +177,10 @@ struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
 #ifdef CONFIG_PRINTK
+asmlinkage int vprintk_header(const char *header, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+asmlinkage int printk_header(const char *header, const char * fmt, ...)
+	__attribute__ ((format (printf, 2, 3))) __cold;
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
@@ -192,6 +196,14 @@ extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 #else
+static inline int vprintk_header(const char *header, const char *s, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+static inline int vprintk_header(const char *header, const char *s, va_list args)
+{ return 0; }
+static inline int printk_header(const char *header, const char *s, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int __cold printk_header(const char *header, const char *s, ...)
+{ return 0; }
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 static inline int vprintk(const char *s, va_list args) { return 0; }
diff --git a/kernel/printk.c b/kernel/printk.c
index 2317ec8..2283a75 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -608,18 +608,75 @@ asmlinkage int printk(const char *fmt, ...)
 	int r;
 
 	va_start(args, fmt);
-	r = vprintk(fmt, args);
+	r = vprintk_header(NULL, fmt, args);
 	va_end(args);
 
 	return r;
 }
+EXPORT_SYMBOL(printk);
+
+asmlinkage int vprintk(const char *fmt, va_list args)
+{
+	return vprintk_header(NULL, fmt, args);
+}
+EXPORT_SYMBOL(vprintk);
+
+/**
+ * printk_header - print a kernel message with header
+ * @header: header string
+ * @fmt: format string
+ *
+ * This is printk() with a twist.  @header points to string which will
+ * be used as message header.  If @header is NULL, this function is
+ * identical to printk().
+ *
+ * @header may contain loglevel in front of it.  Each new line
+ * including the first one in the message formatted from @fmt can also
+ * have loglevel.  When both exist, the latter is used.  In multiline
+ * messages, log level is inherited from the previous line if not
+ * explicitly specified.
+ *
+ * @header is printed when a new line starts.  If @header ends with
+ * ':' followed by spaces, the colon is replaced with space from the
+ * second line.
+ *
+ * For example, if @header is "<7>ata1.00: " and the formatted message
+ * is "<6>line0\nline1\n<4>line2\nline3\n", the following gets written to
+ * the console.
+ *
+ * <6>ata1.00: line0
+ * <6>ata1.00  line1
+ * <4>ata1.00  line2
+ * <4>ata1.00  line3
+ */
+asmlinkage int printk_header(const char *header, const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = vprintk_header(header, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(printk_header);
 
 static int is_loglevel(const char *p)
 {
 	return p[0] == '<' && p[1] >= '0' && p[1] <= '7' && p[2] == '>';
 }
 
-asmlinkage int vprintk(const char *fmt, va_list args)
+/**
+ * vprintk_header - a variant of printk_header() which takes va_list argument
+ * @header: header string
+ * @fmt: format string
+ * @args: va_list to format @fmt
+ *
+ * This function is identical to printk_header() except that it takes
+ * va_list @args instead of variable argument list.
+ */
+asmlinkage int vprintk_header(const char *header, const char *fmt, va_list args)
 {
 	/* cpu currently holding logbuf_lock */
 	static volatile unsigned int printk_cpu = UINT_MAX;
@@ -632,7 +689,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 
 	int last_lv = default_message_loglevel;
 	unsigned long flags;
-	int printed_len = 0;
+	const char *header_colon = NULL;
+	int printed_len = 0, printed_header = 0;
 	int this_cpu;
 	const char *p;
 
@@ -670,6 +728,20 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		strcpy(printk_buf, printk_recursion_bug_msg);
 		printed_len = sizeof(printk_recursion_bug_msg);
 	}
+
+	/* Parse header log level */
+	if (header) {
+		size_t len = strlen(header);
+
+		if (is_loglevel(header)) {
+			last_lv = header[1] - '0';
+			header += 3;
+		}
+
+		if (len >= 2 && !strcmp(header + len - 2, ": "))
+			header_colon = header + len - 2;
+	}
+
 	/* Emit the output into the temporary buffer */
 	printed_len += vsnprintf(printk_buf + printed_len,
 				 PRINTK_BUF_LEN - printed_len, fmt, args);
@@ -718,6 +790,20 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				printed_len += tlen;
 			}
 
+			if (header) {
+				const char *h = header;
+
+				while (*h) {
+					if (!printed_header || h != header_colon)
+						emit_log_char(*h);
+					else
+						emit_log_char(' ');
+					h++;
+					printed_len++;
+				}
+				printed_header = 1;
+			}
+
 			last_lv = lv;
 			log_level_unknown = 0;
 			if (!*p)
@@ -769,8 +855,7 @@ out_restore_irqs:
 	preempt_enable();
 	return printed_len;
 }
-EXPORT_SYMBOL(printk);
-EXPORT_SYMBOL(vprintk);
+EXPORT_SYMBOL(vprintk_header);
 
 #else
 
-- 
1.5.2.4

