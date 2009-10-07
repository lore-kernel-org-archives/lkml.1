Return-Path: <linux-kernel-owner+w=401wt.eu-S934064AbZJGIlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbZJGIlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933981AbZJGIlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:41:04 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:49788 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938AbZJGIkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:40:55 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 1/7] printk: clean up return value
Date: Wed,  7 Oct 2009 09:39:41 +0100
Message-Id: <1254904787-11323-2-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5fd29d6 "printk: clean up handling of log-levels and newlines"
causes printk() to return the wrong number of characters.

It counts the first loglevel tag twice: once in the original message
string, and a second time when we actually print the loglevel.

We could fix this up, but it seems pointless.  Callers don't really care
about the extra characters added by printk().  Instead, let's return the
length of the original message as formatted (and possibly truncated)
by vscnprintf().

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 kernel/printk.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index f38b07f..9d3d594 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -669,7 +669,7 @@ static inline void printk_delay(void)
 
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
-	int printed_len = 0;
+	int message_len = 0;
 	int current_log_level = default_message_loglevel;
 	unsigned long flags;
 	int this_cpu;
@@ -708,11 +708,11 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	if (recursion_bug) {
 		recursion_bug = 0;
 		strcpy(printk_buf, recursion_bug_msg);
-		printed_len = strlen(recursion_bug_msg);
+		message_len = strlen(recursion_bug_msg);
 	}
 	/* Emit the output into the temporary buffer */
-	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf) - printed_len, fmt, args);
+	message_len = vscnprintf(printk_buf + message_len,
+				  sizeof(printk_buf) - message_len, fmt, args);
 
 
 	p = printk_buf;
@@ -796,7 +796,7 @@ out_restore_irqs:
 	raw_local_irq_restore(flags);
 
 	preempt_enable();
-	return printed_len;
+	return message_len;
 }
 EXPORT_SYMBOL(printk);
 EXPORT_SYMBOL(vprintk);
-- 
1.6.3.2

