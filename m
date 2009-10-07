Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbZJGImB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbZJGImB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934110AbZJGIl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:41:59 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:50068 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934138AbZJGIls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:41:48 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 5/7] printk: fix printk(KERN_EMERG) followed by printk("emergency message\n")
Date: Wed,  7 Oct 2009 09:39:45 +0100
Message-Id: <1254904787-11323-6-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5fd29d6 "printk: clean up handling of log-levels and newlines"
causes printk(KERN_EMERG) to be ignored. Any "emergency message" which
follows will be printed as KERN_DEFAULT.

This affects arch/x86/dumpstack.c, causing critical crash information to
be logged as KERN_DEFAULT.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 kernel/printk.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 1714435..c7a1a85 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -763,14 +763,17 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	}
 
 	/*
-	 * Copy the output into log_buf.  If the caller didn't provide
-	 * appropriate log level tags, we insert them here
+	 * Now copy the output into log_buf.
+	 * We add a log level tag at the start of each new line.
 	 */
+	if (new_text_line) {
+		new_text_line = 0;
+		printk_token(current_log_level);
+	}
+
 	for ( ; *p; p++) {
 		if (new_text_line) {
 			new_text_line = 0;
-
-			/* Always output the token */
 			printk_token(current_log_level);
 		}
 
-- 
1.6.3.2

