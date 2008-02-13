Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbYBMJDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbYBMJDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYBMJDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:03:25 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:38145 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYBMJDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:03:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=mg5FlCxxCKThJuTnHa+Ign+45yUYuNZ++I5YKB+HjyivSMwn3069LnoE5oOzq54XzEw4cOBslqjT/5pAy4RkvXnxsJghPAN7XJIQDiLcauWHmEPb6sgYQpdKRz5xPGmUmwUr2LN3owimMj2r0fP94hzgrRs/NSnNi8dykOUx/uo=
Message-ID: <47B2B250.8020209@gmail.com>
Date: Wed, 13 Feb 2008 18:03:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] printk: implement printk_buf overflow warning
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk silently truncates messages longer than 1024 - 1 bytes.
Implement overflow detection and append "$PRINTK_BUF_OVERFLOW$\n" to
truncated messages.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 kernel/printk.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 074a3ea..419cd47 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -42,6 +42,7 @@ void __attribute__((weak)) early_printk(const char *fmt, ...)
 {
 }
 
+#define PRINTK_BUF_LEN	1024
 #define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
 
 /* printk's without a loglevel use this.. */
@@ -619,9 +620,10 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	static volatile unsigned int printk_cpu = UINT_MAX;
 	static const char printk_recursion_bug_msg [] =
 		KERN_CRIT "BUG: recent printk recursion!\n";
+	static const char overflow_tag[] = "$PRINTK_BUF_OVERFLOW$\n";
 	static int printk_recursion_bug;
 	static int log_level_unknown = 1;
-	static char printk_buf[1024];
+	static char printk_buf[PRINTK_BUF_LEN + sizeof(overflow_tag) - 1];
 
 	unsigned long flags;
 	int printed_len = 0;
@@ -663,8 +665,15 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		printed_len = sizeof(printk_recursion_bug_msg);
 	}
 	/* Emit the output into the temporary buffer */
-	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf) - printed_len, fmt, args);
+	printed_len += vsnprintf(printk_buf + printed_len,
+				 PRINTK_BUF_LEN - printed_len, fmt, args);
+
+	/* Check for overflow and tag the message if overflowed */
+	if (printed_len >= PRINTK_BUF_LEN) {
+		memcpy(printk_buf + PRINTK_BUF_LEN - 1, overflow_tag,
+		       sizeof(overflow_tag));
+		printed_len = sizeof(printk_buf) - 1;
+	}
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
-- 
1.5.2.4

