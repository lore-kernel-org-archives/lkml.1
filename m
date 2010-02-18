Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab0BRWgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:36:13 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51036 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734Ab0BRWgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:36:11 -0500
Subject: Re: printk_ratelimited() not compiling
From: john stultz <johnstul@us.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1266531013.3201.86.camel@localhost.localdomain>
References: <1266531013.3201.86.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 14:36:07 -0800
Message-ID: <1266532567.3201.97.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 14:10 -0800, john stultz wrote:
> Hey Joe, 
> 	So I thought printk_ratelimited would be perfect for an issue I'm
> having, but when I tried using it, replacing a printk I had, I got the
> following:
> 
> fs/namei.c:1075: error: variable ‘_rs’ has initializer but incomplete type
> fs/namei.c:1075: error: unknown field ‘interval’ specified in initializer
> fs/namei.c:1075: warning: excess elements in struct initializer
> fs/namei.c:1075: warning: (near initialization for ‘_rs’)
> fs/namei.c:1075: error: unknown field ‘burst’ specified in initializer
> fs/namei.c:1075: warning: excess elements in struct initializer
> fs/namei.c:1075: warning: (near initialization for ‘_rs’)
> fs/namei.c:1075: error: storage size of ‘_rs’ isn’t known
> fs/namei.c:1075: warning: unused variable ‘_rs’
> 
> 
> Thinking the issue was ratelimit.h wasn't included I tried that, but
> got:
> 
>  file included from include/linux/spinlock_types.h:18,
>                  from include/linux/ratelimit.h:5,
>                  from include/linux/kernel.h:21,
>                  from /home/jstultz/projects/linux/linux-2.6-git/arch/x86/include/asm/percpu.h:45,
>                  from /home/jstultz/projects/linux/linux-2.6-git/arch/x86/include/asm/current.h:5,
>                  from /home/jstultz/projects/linux/linux-2.6-git/arch/x86/include/asm/processor.h:15,
>                  from include/linux/prefetch.h:14,
>                  from include/linux/list.h:6,
>                  from include/linux/module.h:9,
>                  from include/linux/crypto.h:21,
>                  from arch/x86/kernel/asm-offsets_64.c:8,
>                  from arch/x86/kernel/asm-offsets.c:4:
> include/linux/lockdep.h:52: error: field ‘hash_entry’ has incomplete type
> include/linux/lockdep.h:57: error: field ‘lock_entry’ has incomplete type
> include/linux/lockdep.h:74: error: field ‘locks_after’ has incomplete type
> include/linux/lockdep.h:74: error: field ‘locks_before’ has incomplete type
> include/linux/lockdep.h:148: error: field ‘entry’ has incomplete type
> include/linux/lockdep.h:167: error: field ‘entry’ has incomplete type
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> 
> Yuck.
> 
> Am I missing something obvious, or did something get broken after this went in?

Ok. Solved it. I needed to #include <linux/ratelimit.h> in the file I
was adding the printk_ratelimited usage in, rather then where
printk_ratelimited is defined.

Maybe would it be better to move the printk_ratelimited definitions into
ratelimit.h so this would be more obvious?

Something like the following?

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 328bca6..9119b72 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -404,49 +405,6 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
 #endif
 
-/*
- * ratelimited messages with local ratelimit_state,
- * no local ratelimit_state used in the !PRINTK case
- */
-#ifdef CONFIG_PRINTK
-#define printk_ratelimited(fmt, ...)  ({		\
-	static struct ratelimit_state _rs = {		\
-		.interval = DEFAULT_RATELIMIT_INTERVAL, \
-		.burst = DEFAULT_RATELIMIT_BURST,       \
-	};                                              \
-							\
-	if (!__ratelimit(&_rs))                         \
-		printk(fmt, ##__VA_ARGS__);		\
-})
-#else
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_ratelimited printk
-#endif
-
-#define pr_emerg_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_notice_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-/* no pr_cont_ratelimited, don't do that... */
-/* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
-#define pr_debug_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-#else
-#define pr_debug_ratelimited(fmt, ...) \
-	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
-				     ##__VA_ARGS__); 0; })
-#endif
 
 /*
  * General tracing related utility functions - trace_printk(),
diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 668cf1b..39cc4df 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -28,4 +28,48 @@ struct ratelimit_state {
 extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define __ratelimit(state) ___ratelimit(state, __func__)
 
+/*
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
+#define pr_emerg_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+/* no pr_cont_ratelimited, don't do that... */
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_debug_ratelimited(fmt, ...) \
+	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
+				     ##__VA_ARGS__); 0; })
+#endif
+
 #endif /* _LINUX_RATELIMIT_H */




