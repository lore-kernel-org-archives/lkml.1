Return-Path: <linux-kernel-owner+w=401wt.eu-S933098AbZJ3XVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbZJ3XVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 19:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933045AbZJ3XVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 19:21:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1147 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079AbZJ3XVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 19:21:43 -0400
Subject: [PATCH] kernel.h: Add printk_ratelimited and pr_<level>_rl
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naohiro Ooiwa <nooiwa@miraclelinux.com>, Ingo Molnar <mingo@elte.hu>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
In-Reply-To: <1256939158.1917.43.camel@Joe-Laptop.home>
References: <4AEACFBF.4060108@miraclelinux.com>
	 <20091030143333.414ea29c.akpm@linux-foundation.org>
	 <1256939158.1917.43.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 16:21:47 -0700
Message-ID: <1256944907.1917.109.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a printk_ratelimited statement expression macro
that uses a per-call ratelimit_state so that multiple
subsystems output messages are not suppressed by a global
__ratelimit state.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f4e3184..555560c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -407,6 +407,50 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #endif
 
 /*
+ * ratelimited messages with local ratelimit_state,
+ * no local ratelimit_state used in the !PRINTK case
+ */
+#ifdef CONFIG_PRINTK
+#define printk_ratelimited(fmt, ...)  ({		\
+	static struct ratelimit_state _rs = {		\
+		.interval = DEFAULT_RATELIMIT_INTERVAL, \
+		.burst = DEFAULT_RATELIMIT_BURST,       \
+	};                                              \
+							\
+	if (!__ratelimit(&_rs))                         \
+		printk(fmt, ##__VA_ARGS__);		\
+})
+#else
+/* No effect, but we still get type checking even in the !PRINTK case: */
+#define printk_ratelimited printk
+#endif
+
+#define pr_emerg_rl(fmt, ...) \
+        printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_rl(fmt, ...) \
+        printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_rl(fmt, ...) \
+        printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_rl(fmt, ...) \
+        printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning_rl(fmt, ...) \
+        printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_rl(fmt, ...) \
+        printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_rl(fmt, ...) \
+        printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+/* no pr_cont_rl, don't do that... */
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug_rl(fmt, ...) \
+	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_debug_rl(fmt, ...) \
+	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
+				     ##__VA_ARGS__); 0; })
+#endif
+
+/*
  * General tracing related utility functions - trace_printk(),
  * tracing_on/tracing_off and tracing_start()/tracing_stop
  *


