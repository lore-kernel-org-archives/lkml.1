Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYKLRkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYKLRkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYKLRj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:39:59 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:63097 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYKLRj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:39:58 -0500
Subject: [RFC] Add PR_PREFIX to pr_xyz macros.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 12 Nov 2008 18:35:27 +0100
Message-Id: <1226511327.23498.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
there is one spin-off from the kernel message patches I would still
like to get upstream: replacing all the different printk macros in the
s390 device drivers with dev_xyz and pr_xyz.

One thing the s390 printk macros have been doing which I miss with the
pr_xyz macros is a way to automatically prefix the messages with the 
driver name. This is quite handy, saves some typing and shortens the
printk line. The pr_xyz macros could be taught about a prefix, would
something like the patch below be acceptable?
The idea is to add a '#define PR_PREFIX "driver"' to the start of the
source file and have the pr_xyz macros paste the prefix to each message.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

---
Subject: [PATCH] Add PR_PREFIX to pr_xyz macros.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

A common reason for device drivers to implement their own printk macros
is the lack of a printk prefix with the standard pr_xyz macros. The most
common use of the prefix would be to add the name of the device driver to
all printks in a source file.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/kernel.h |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -urpN linux-2.6/include/linux/kernel.h linux-2.6-patched/include/linux/kernel.h
--- linux-2.6/include/linux/kernel.h	2008-11-11 16:59:04.000000000 +0100
+++ linux-2.6-patched/include/linux/kernel.h	2008-11-11 17:19:04.000000000 +0100
@@ -318,32 +318,38 @@ static inline char *pack_hex_byte(char *
 	return buf;
 }
 
-#define pr_emerg(fmt, arg...) \
-	printk(KERN_EMERG fmt, ##arg)
-#define pr_alert(fmt, arg...) \
-	printk(KERN_ALERT fmt, ##arg)
-#define pr_crit(fmt, arg...) \
-	printk(KERN_CRIT fmt, ##arg)
-#define pr_err(fmt, arg...) \
-	printk(KERN_ERR fmt, ##arg)
-#define pr_warning(fmt, arg...) \
-	printk(KERN_WARNING fmt, ##arg)
-#define pr_notice(fmt, arg...) \
-	printk(KERN_NOTICE fmt, ##arg)
-#define pr_info(fmt, arg...) \
-	printk(KERN_INFO fmt, ##arg)
+#ifndef PR_PREFIX
+#define pr_fmt(format) format 
+#else
+#define pr_fmt(format) PR_PREFIX ": " format
+#endif
+
+#define pr_emerg(fmt, ...) \
+        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert(fmt, ...) \
+        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit(fmt, ...) \
+        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...) \
+        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...) \
+        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice(fmt, ...) \
+        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...) \
+        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
 #define pr_debug(fmt, ...) do { \
-	dynamic_pr_debug(fmt, ##__VA_ARGS__); \
+	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__); \
 	} while (0)
 #elif defined(DEBUG)
-#define pr_debug(fmt, arg...) \
-	printk(KERN_DEBUG fmt, ##arg)
+#define pr_debug(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
-#define pr_debug(fmt, arg...) \
-	({ if (0) printk(KERN_DEBUG fmt, ##arg); 0; })
+#define pr_debug(fmt, ...) \
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
 #endif
 
 /*


