Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbYKLUVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbYKLUVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYKLUVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:21:42 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:36163 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbYKLUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:21:41 -0500
Subject: Re: [RFC] Add PR_PREFIX to pr_xyz macros.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0811121144400.3468@nehalem.linux-foundation.org>
References: <1226511327.23498.3.camel@localhost>
	 <alpine.LFD.2.00.0811121144400.3468@nehalem.linux-foundation.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 12 Nov 2008 21:16:43 +0100
Message-Id: <1226521003.2222.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Add PR_PREFIX to pr_xyz macros.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

A common reason for device drivers to implement their own printk macros
is the lack of a printk prefix with the standard pr_xyz macros. Introduce
a pr_fmt macro that is applied for every pr_xyz macro to the format string.
The most common use of the pr_fmt macro would be to add the name of the
device driver to all pr_xyz messages in a source file.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/kernel.h |   42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff -urpN linux-2.6/include/linux/kernel.h linux-2.6-patched/include/linux/kernel.h
--- linux-2.6/include/linux/kernel.h	2008-11-03 09:40:45.000000000 +0100
+++ linux-2.6-patched/include/linux/kernel.h	2008-11-12 21:07:21.000000000 +0100
@@ -318,32 +318,36 @@ static inline char *pack_hex_byte(char *
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
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt 
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


