Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbYDLQTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbYDLQTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYDLQTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:19:08 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:37257 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1753886AbYDLQTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:19:07 -0400
X-Spam-Check-By: mail.local.tull.net
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] printk: Remember the message level for multi-line output
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       joe@perches.com
Date: Sun, 13 Apr 2008 02:18:54 +1000
Message-ID: <20080412161733.24882.30930.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk: Remember the message level for multi-line output

    printk(KERN_ALERT "Danger Will Robinson!\nAlien Approaching!\n");

At present this will result in one message at ALERT level and one
at the current default message loglevel (e.g. WARNING). This is
non-intuitive.

Modify vprintk() to remember the message loglevel each time it
is specified and use it for subsequent lines of output which do
not specify one, within the same call to printk.

Restructure the logic so the processing of the leading 3 characters
of each input line is in one place, regardless whether printk_time
is enabled.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 kernel/printk.c |   61 ++++++++++++++++++++++++-------------------------------
 1 files changed, 27 insertions(+), 34 deletions(-)


diff --git a/kernel/printk.c b/kernel/printk.c
index 6bc98f9..371a00a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -656,11 +656,12 @@ static int printk_recursion_bug;
 
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
-	static int log_level_unknown = 1;
+	static int new_text_line = 1;
 	static char printk_buf[1024];
 
-	unsigned long flags;
 	int printed_len = 0;
+	int current_log_level = default_message_loglevel;
+	unsigned long flags;
 	int this_cpu;
 	char *p;
 
@@ -702,61 +703,53 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	printed_len += vscnprintf(printk_buf + printed_len,
 				  sizeof(printk_buf) - printed_len, fmt, args);
 
+
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
 	 * appropriate log level tags, we insert them here
 	 */
 	for (p = printk_buf; *p; p++) {
-		if (log_level_unknown) {
-                        /* log_level_unknown signals the start of a new line */
+		if (new_text_line) {
+			/* If a token, set current_log_level and skip over */
+			if (p[0] == '<' && p[1] >= '0' && p[1] <= '7' &&
+			    p[2] == '>') {
+				current_log_level = p[1] - '0';
+				p += 3;
+				printed_len -= 3;
+			}
+
+			/* Always output the token */
+			emit_log_char('<');
+			emit_log_char(current_log_level + '0');
+			emit_log_char('>');
+			printed_len += 3;
+			new_text_line = 0;
+
 			if (printk_time) {
-				int loglev_char;
+				/* Follow the token with the time */
 				char tbuf[50], *tp;
 				unsigned tlen;
 				unsigned long long t;
 				unsigned long nanosec_rem;
 
-				/*
-				 * force the log level token to be
-				 * before the time output.
-				 */
-				if (p[0] == '<' && p[1] >='0' &&
-				   p[1] <= '7' && p[2] == '>') {
-					loglev_char = p[1];
-					p += 3;
-					printed_len -= 3;
-				} else {
-					loglev_char = default_message_loglevel
-						+ '0';
-				}
 				t = cpu_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf,
-						"<%c>[%5lu.%06lu] ",
-						loglev_char,
-						(unsigned long)t,
-						nanosec_rem/1000);
+				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
+						(unsigned long) t,
+						nanosec_rem / 1000);
 
 				for (tp = tbuf; tp < tbuf + tlen; tp++)
 					emit_log_char(*tp);
 				printed_len += tlen;
-			} else {
-				if (p[0] != '<' || p[1] < '0' ||
-				   p[1] > '7' || p[2] != '>') {
-					emit_log_char('<');
-					emit_log_char(default_message_loglevel
-						+ '0');
-					emit_log_char('>');
-					printed_len += 3;
-				}
 			}
-			log_level_unknown = 0;
+
 			if (!*p)
 				break;
 		}
+
 		emit_log_char(*p);
 		if (*p == '\n')
-			log_level_unknown = 1;
+			new_text_line = 1;
 	}
 
 	/*

