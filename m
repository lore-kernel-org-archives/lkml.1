Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZEVUsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZEVUsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZEVUsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:48:43 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4007 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZEVUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:48:42 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] kernel.h: Update printk_once and add pr_<level>_once variants
Date: Fri, 22 May 2009 13:48:41 -0700
Message-Id: <1243025321-16747-1-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed printk_once to use bool instead of int, with default set to false not 1.
This reduces data and produces slightly smaller object code.

Changed printk_once macro definitions to (fmt, ...) to match
other printk/pr_<level> definitions.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   57 ++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 883cd44..343e505 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -246,12 +246,12 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */
-#define printk_once(x...) ({			\
-	static int __print_once = 1;		\
+#define printk_once(fmt, ...) ({		\
+	static bool __print_once;		\
 						\
-	if (__print_once) {			\
-		__print_once = 0;		\
-		printk(x);			\
+	if (!__print_once) {			\
+		__print_once = true;		\
+		printk(fmt, ##__VA_ARGS__);	\
 	}					\
 })
 
@@ -269,7 +269,7 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 		{ return false; }
 
 /* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_once(x...) printk(x)
+#define printk_once(fmt, ...) printk(fmt, ##__VA_ARGS__)
 
 static inline void log_buf_kexec_setup(void)
 {
@@ -400,6 +400,51 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
 #endif
 
+/* pr_<level>_once variants */
+
+#define pr_emerg_once(fmt, ...) \
+	printk_once(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_once(fmt, ...) \
+	printk_once(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_once(fmt, ...) \
+	printk_once(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_once(fmt, ...) \
+	printk_once(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning_once(fmt, ...) \
+	printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_once(fmt, ...) \
+	printk_once(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_once(fmt, ...) \
+	printk_once(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+/* No pr_cont_once, use a local guard instead */
+
+/* pr_devel_once() should produce zero code unless DEBUG is defined */
+#ifdef DEBUG
+#define pr_devel_once(fmt, ...) \
+	printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel_once(fmt, ...) \
+	({ if (0) printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#endif
+
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug_once(fmt, ...) \
+	printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
+#define pr_debug_once(fmt, ...) ({			\
+	static bool __print_once;			\
+	if (!__print_once) {				\
+		__print_once = true;			\
+		dynamic_pr_debug(fmt, ##__VA_ARGS__);	\
+	}						\
+})
+#else
+#define pr_debug_once(fmt, ...) \
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#endif
+
 /*
  * General tracing related utility functions - trace_printk(),
  * tracing_on/tracing_off and tracing_start()/tracing_stop
-- 
1.6.3.1.10.g659a0.dirty

