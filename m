Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbZL1JC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbZL1JC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZL1JCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:02:22 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55493 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZL1JCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:02:18 -0500
Subject: [PATCH] x86,kmemcheck: Use KERN_WARNING for error reporting
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: vegard.nossum@gmail.com
Cc: akpm@linux-foundation.org, x86@kernel.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Date: Mon, 28 Dec 2009 11:02:15 +0200
Message-Id: <1261990935.4641.7.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As suggested by Vegard Nossum, use KERN_WARNING for error reporting to make
sure kmemcheck reports end up in syslog.

Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Vegard, how do you want to merge this? Andrew? Ingo? I can also pick it
up in my tree if you ACK it.

 arch/x86/mm/kmemcheck/error.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/kmemcheck/error.c b/arch/x86/mm/kmemcheck/error.c
index 4901d0d..af3b6c8 100644
--- a/arch/x86/mm/kmemcheck/error.c
+++ b/arch/x86/mm/kmemcheck/error.c
@@ -106,26 +106,25 @@ void kmemcheck_error_recall(void)
 
 	switch (e->type) {
 	case KMEMCHECK_ERROR_INVALID_ACCESS:
-		printk(KERN_ERR  "WARNING: kmemcheck: Caught %d-bit read "
-			"from %s memory (%p)\n",
+		printk(KERN_WARNING "WARNING: kmemcheck: Caught %d-bit read from %s memory (%p)\n",
 			8 * e->size, e->state < ARRAY_SIZE(desc) ?
 				desc[e->state] : "(invalid shadow state)",
 			(void *) e->address);
 
-		printk(KERN_INFO);
+		printk(KERN_WARNING);
 		for (i = 0; i < SHADOW_COPY_SIZE; ++i)
-			printk("%02x", e->memory_copy[i]);
-		printk("\n");
+			printk(KERN_CONT "%02x", e->memory_copy[i]);
+		printk(KERN_CONT "\n");
 
-		printk(KERN_INFO);
+		printk(KERN_WARNING);
 		for (i = 0; i < SHADOW_COPY_SIZE; ++i) {
 			if (e->shadow_copy[i] < ARRAY_SIZE(short_desc))
-				printk(" %c", short_desc[e->shadow_copy[i]]);
+				printk(KERN_CONT " %c", short_desc[e->shadow_copy[i]]);
 			else
-				printk(" ?");
+				printk(KERN_CONT " ?");
 		}
-		printk("\n");
-		printk(KERN_INFO "%*c\n", 2 + 2
+		printk(KERN_CONT "\n");
+		printk(KERN_WARNING "%*c\n", 2 + 2
 			* (int) (e->address & (SHADOW_COPY_SIZE - 1)), '^');
 		break;
 	case KMEMCHECK_ERROR_BUG:
-- 
1.6.0.4



