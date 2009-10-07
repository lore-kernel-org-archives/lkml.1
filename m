Return-Path: <linux-kernel-owner+w=401wt.eu-S934209AbZJGIm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbZJGIm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934121AbZJGIlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:41:47 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:50064 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934096AbZJGIlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:41:46 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 3/7] printk: move the printing of the loglevel tag into a separate function
Date: Wed,  7 Oct 2009 09:39:43 +0100
Message-Id: <1254904787-11323-4-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation only; it does not change any behaviour.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 kernel/printk.c |   48 ++++++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 9d3d594..69f717a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -667,6 +667,30 @@ static inline void printk_delay(void)
 	}
 }
 
+static void printk_token(int log_level)
+{
+	emit_log_char('<');
+	emit_log_char(log_level + '0');
+	emit_log_char('>');
+
+	if (printk_time) {
+		/* Follow the token with the time */
+		char tbuf[50], *tp;
+		unsigned tlen;
+		unsigned long long t;
+		unsigned long nanosec_rem;
+
+		t = cpu_clock(printk_cpu);
+		nanosec_rem = do_div(t, 1000000000);
+		tlen = sprintf(tbuf, "[%5lu.%06lu] ",
+					(unsigned long) t,
+					nanosec_rem / 1000);
+
+		for (tp = tbuf; tp < tbuf + tlen; tp++)
+			emit_log_char(*tp);
+	}
+}
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
 	int message_len = 0;
@@ -744,30 +768,10 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	 */
 	for ( ; *p; p++) {
 		if (new_text_line) {
-			/* Always output the token */
-			emit_log_char('<');
-			emit_log_char(current_log_level + '0');
-			emit_log_char('>');
-			printed_len += 3;
 			new_text_line = 0;
 
-			if (printk_time) {
-				/* Follow the token with the time */
-				char tbuf[50], *tp;
-				unsigned tlen;
-				unsigned long long t;
-				unsigned long nanosec_rem;
-
-				t = cpu_clock(printk_cpu);
-				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
-						(unsigned long) t,
-						nanosec_rem / 1000);
-
-				for (tp = tbuf; tp < tbuf + tlen; tp++)
-					emit_log_char(*tp);
-				printed_len += tlen;
-			}
+			/* Always output the token */
+			printk_token(current_log_level);
 
 			if (!*p)
 				break;
-- 
1.6.3.2

