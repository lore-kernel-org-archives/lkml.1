Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbYBGVUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbYBGVUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932448AbYBGVK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:10:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933470AbYBGVKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:10:25 -0500
Date: Thu, 7 Feb 2008 16:09:33 -0500
From: Jason Baron <jbaron@redhat.com>
To: mathieu.desnoyers@polymtl.ca
Cc: akpm@linux-foundation.org, mingo@elte.hu, fche@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [patch 1/4] make pr_debug() dynamic
Message-ID: <20080207210929.GC14732@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-make pr_debug() dynamic so it can be switched on/off. The off state
 is implemented on top of the immediate infrastructure, so as to promote
 more dynamic printing and debugging. depends on CONFIG_HAVE_IMMEDIATE 
 and CONFIG_PRINTK
 

Signed-off-by: Jason Baron <jbaron@redhat.com>
---

 include/linux/kernel.h |   10 ++++++++++
 init/Kconfig           |    5 +++++
 kernel/printk.c        |   17 +++++++++++++++++
 3 files changed, 32 insertions(+), 0 deletions(-)


diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index ff356b2..d69430a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/bitops.h>
 #include <linux/log2.h>
+#include <linux/immediate.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -276,6 +277,14 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #define pr_info(fmt, arg...) \
 	printk(KERN_INFO fmt, ##arg)
 
+#ifdef CONFIG_PR_DEBUG_DYNAMIC
+DECLARE_IMV(char, pr_debug_on);
+#define pr_debug(fmt, ...)						\
+     do {								\
+	if (unlikely(imv_read(pr_debug_on)))				\
+		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
+     } while (0)
+#else
 #ifdef DEBUG
 /* If you are writing a driver, please use dev_dbg instead */
 #define pr_debug(fmt, arg...) \
@@ -286,6 +295,7 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
 	return 0;
 }
 #endif
+#endif
 
 /*
  *      Display an IP address in readable format.
diff --git a/init/Kconfig b/init/Kconfig
index 3918c2d..0bed605 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -539,6 +539,11 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config PR_DEBUG_DYNAMIC
+	bool
+	depends on PRINTK && HAVE_IMMEDIATE
+	default y
+
 config BUG
 	bool "BUG() support" if EMBEDDED
 	default y
diff --git a/kernel/printk.c b/kernel/printk.c
index 29ae1e9..1bc4fdb 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
+#include <linux/immediate.h>
 
 #include <asm/uaccess.h>
 
@@ -1334,3 +1335,19 @@ bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 	return false;
 }
 EXPORT_SYMBOL(printk_timed_ratelimit);
+
+#ifdef CONFIG_PR_DEBUG_DYNAMIC
+
+DEFINE_IMV(char, pr_debug_on) = 0;
+EXPORT_IMV_SYMBOL_GPL(pr_debug_on);
+
+static int __init pr_debug_setup(char *str)
+{
+	if (str)
+		return -ENOENT;
+	imv_set(pr_debug_on, 1);
+	return 0;
+}
+early_param("pr_debug", pr_debug_setup);
+
+#endif
