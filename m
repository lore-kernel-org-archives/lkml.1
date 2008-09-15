Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbYIOIGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbYIOIGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYIOIFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 04:05:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:41684 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbYIOIFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 04:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=B18hr78TPk2KFxp+PdRnqdoXgcPEB/4y4L8FZp/cNxIsi/EDkM5aexv5+bLr+p7XRw
         EdF9ohxnMzrpfsTXzgiChWQPM4zVxkVDMkI+SS7Wa70VxxWTVcit5y26OdwV0G0/90Y6
         A3m4HIDg3VU5QxbkOD9pt1jknvQgXVIVzoDXw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] introduce boot_printk()
Date: Mon, 15 Sep 2008 01:05:16 -0700
Message-Id: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could be enabled via "boot=verbose" to get more debug info

will use it to convert some printk(KERN_DEBUG ...)

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 include/linux/kernel.h |   19 +++++++++++++++++++
 kernel/printk.c        |   21 +++++++++++++++++++++
 2 files changed, 40 insertions(+)

Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -344,6 +344,25 @@ static inline char *pack_hex_byte(char *
 #endif
 
 /*
+ * Debugging macros
+ */
+#define BOOT_QUIET   0
+#define BOOT_VERBOSE 1
+#define BOOT_SPEW    2
+
+extern int boot_verbosity;
+/*
+ * Define the default level of output to be very little
+ * This can be turned up by using boot=verbose for more
+ * information and boot=spew for _lots_ of information.
+ * boot_verbosity is defined in printk.c
+ */
+#define boot_printk(v, s, a...) do {        \
+		if ((v) <= boot_verbosity)  \
+			printk(s, ##a);    \
+	} while (0)
+
+/*
  *      Display an IP address in readable format.
  */
 
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -604,6 +604,27 @@ asmlinkage int printk(const char *fmt, .
 	return r;
 }
 
+int boot_verbosity;
+
+static int __init boot_set_verbosity(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (strcmp("spew", arg) == 0)
+		boot_verbosity = BOOT_SPEW;
+	else if (strcmp("verbose", arg) == 0)
+		boot_verbosity = BOOT_VERBOSE;
+	else {
+		printk(KERN_WARNING "boot Verbosity level %s not recognised"
+			" use boot=verbose or boot=spew\n", arg);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+early_param("boot", boot_set_verbosity);
+
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
 
