Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYAPBA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYAPBA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbYAPBAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:00:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:4564 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYAPBAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:00:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pKQxh8uChsUE5O0bPLFVN0Oy1nu+U5A6a+7BVxORBFp4MYdfCvP7wT1a6uoB1dTbQkj5hIxDvBmZNfgQbpz7U5syh0WHVsgnx5c6jmUF3uDivv+N1/90nz9az6WqqgCccwBJOmc7IZ6BSEa+aheaC/6jzdlMSJI8f/ILUR/K0HE=
From: Tejun Heo <htejun@gmail.com>
To: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       randy.dunlap@oracle.com, jeff@garzik.org, linux-ide@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/4] printk: implement [v]printk_header()
Date: Wed, 16 Jan 2008 10:00:08 +0900
Message-Id: <12004452112039-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1200445210549-git-send-email-htejun@gmail.com>
References: <1200445210549-git-send-email-htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement [v]printk_header() which takes @header argument and
automatically prints header in front of or indents multiline messages.
For example, if @header is "<7>ata1.00: " and the formatted message is
"<6>line0\nline1\n", the following gets written to the console.

<6>ata1.00: line0
<6>         line1

Header is printed only on the first lines and when log level changes
in the middle in case messages of different log level are sent to
different destinations.  Other lines are indented the same amount as
the length of the header.  This helps to distinguish where a multiline
message begins when messages of similar pattern repeats, for
example...

ata8.00: cmd 60/80:20:e1:71:02/00:00:00:00:00/40 tag 4 ncq 65536 in
         res 40/00:34:de:71:02/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata8.00: cmd 60/0e:28:d0:71:02/00:00:00:00:00/40 tag 5 ncq 7168 in
         res 40/00:34:de:71:02/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
ata8.00: cmd 60/7f:38:61:72:02/00:00:00:00:00/40 tag 7 ncq 65024 in
         res 40/00:34:de:71:02/00:00:00:00:00/40 Emask 0x10 (ATA bus error)

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 include/linux/kernel.h |   12 ++++++
 kernel/printk.c        |   94 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 100 insertions(+), 6 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 94bc996..ade3ac9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -175,6 +175,10 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
 extern void dump_thread(struct pt_regs *regs, struct user *dump);
 
 #ifdef CONFIG_PRINTK
+asmlinkage int vprintk_header(const char *header, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+asmlinkage int printk_header(const char *header, const char * fmt, ...)
+	__attribute__ ((format (printf, 2, 3))) __cold;
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
@@ -183,6 +187,14 @@ extern int log_buf_get_len(void);
 extern int log_buf_read(int idx);
 extern int log_buf_copy(char *dest, int idx, int len);
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
index 6df1872..1cde1d6 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -619,23 +619,86 @@ asmlinkage int printk(const char *fmt, ...)
 	int r;
 
 	va_start(args, fmt);
-	r = vprintk(fmt, args);
+	r = vprintk_header(NULL, fmt, args);
 	va_end(args);
 
 	return r;
 }
+EXPORT_SYMBOL(printk);
 
-/* cpu currently holding logbuf_lock */
-static volatile unsigned int printk_cpu = UINT_MAX;
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
+ * @header is printed when new line starts if @header hasn't been
+ * printed yet for the current log level.  That means, in a multiline
+ * message where all the lines are of the same log level, @header is
+ * printed only once before the first line.
+ *
+ * Lines which don't have @header printed in front of them are
+ * indented by the same number of characters in @header - they are
+ * aligned with lines which have @header in front of them.
+ *
+ * For example, if @header is "<7>ata1.00: " and the formatted message
+ * is "<6>line0\nline1\n<4>line2\nline3\n", the following gets written to
+ * the console.
+ *
+ * <6>ata1.00: line0
+ * <6>         line1
+ * <4>ata1.00: line2
+ * <4>         line3
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
+/* cpu currently holding logbuf_lock */
+static volatile unsigned int printk_cpu = UINT_MAX;
+
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
 	int last_lv = default_message_loglevel;
+	unsigned int printed_header = 0;
 	unsigned long flags;
 	int printed_len;
 	const char *p;
@@ -656,6 +719,12 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	spin_lock(&logbuf_lock);
 	printk_cpu = smp_processor_id();
 
+	/* Parse header log level */
+	if (header && is_loglevel(header)) {
+		last_lv = header[1] - '0';
+		header += 3;
+	}
+
 	/* Emit the output into the temporary buffer */
 	printed_len = vscnprintf(printk_buf, sizeof(printk_buf), fmt, args);
 
@@ -697,6 +766,20 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				printed_len += tlen;
 			}
 
+			if (header) {
+				const char *h = header;
+
+				while (*h) {
+					if (!(printed_header & (1 << lv)))
+						emit_log_char(*h);
+					else
+						emit_log_char(' ');
+					h++;
+					printed_len++;
+				}
+				printed_header |= 1 << lv;
+			}
+
 			last_lv = lv;
 			log_level_unknown = 0;
 			if (!*p)
@@ -747,8 +830,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	preempt_enable();
 	return printed_len;
 }
-EXPORT_SYMBOL(printk);
-EXPORT_SYMBOL(vprintk);
+EXPORT_SYMBOL(vprintk_header);
 
 #else
 
-- 
1.5.2.4

