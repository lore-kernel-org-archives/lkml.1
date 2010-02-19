Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab0BSAPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:15:20 -0500
Received: from mail.perches.com ([173.55.12.10]:1108 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab0BSAPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:15:18 -0500
Subject: [RFC PATCH] printk_ratelimited: Move definitions to ratelimit.h,
 use DEFINE_RATELIMIT_STATE
From: Joe Perches <joe@perches.com>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1266536955.3201.101.camel@localhost.localdomain>
References: <1266531013.3201.86.camel@localhost.localdomain>
	 <1266532567.3201.97.camel@localhost.localdomain>
	 <1266535419.8446.320.camel@Joe-Laptop.home>
	 <1266535987.3201.100.camel@localhost.localdomain>
	 <1266536955.3201.101.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 16:15:15 -0800
Message-ID: <1266538515.8446.386.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 15:49 -0800, john stultz wrote:
> On Thu, 2010-02-18 at 15:33 -0800, john stultz wrote:
> > On Thu, 2010-02-18 at 15:23 -0800, Joe Perches wrote:
> > > On Thu, 2010-02-18 at 14:36 -0800, john stultz wrote: 
> > > > > Am I missing something obvious, or did something get broken after this went in?
> > > > Ok. Solved it. I needed to #include <linux/ratelimit.h> in the file I
> > > > was adding the printk_ratelimited usage in, rather then where
> > > > printk_ratelimited is defined.
> > > > 
> > > > Maybe would it be better to move the printk_ratelimited definitions into
> > > > ratelimit.h so this would be more obvious?
> > > 
> > > That's one option.
> > > 
> > > Probably the only places I tried it had an
> > > #include <linux/net.h> somewhere which does an
> > > #include <linux/ratelimit.h>
> > > 
> > > Personally, I think it'd be better to put
> > > #include <linux/ratelimit.h> back in kernel.h
> > > Commit 3fff4c42bd0a89869a0eb1e7874cc06ffa4aa0f5 removed it.
> > 
> > Right, that's what I tried first, but it doesn't build. :)
> > 
> > If ratelimit.h has to be included for it to work (which is fine by me),
> > it seems ratelimit.h would be the ideal place to define it.
> > 
> > CC'ing Peter to see what his thoughts are.
> 
> Sorry, that should have been Ingo I cc'ed. Peter didn't make that
> change.

One possible problem with this is kernel.h needs to be
#included before ratelimit.h.

Maybe ratelimit.h needs to #include <linux/kernel.h>

------

Move the printk_ratelimited and pr_<level>_ratelimited
macro helpers to ratelimit.h

Use DEFINE_RATELIMIT_STATE

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h    |   44 --------------------------------------------
 include/linux/ratelimit.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 328bca6..db8e089 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -405,50 +405,6 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #endif
 
 /*
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
-
-/*
  * General tracing related utility functions - trace_printk(),
  * tracing_on/tracing_off and tracing_start()/tracing_stop
  *
diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 668cf1b..c892373 100644
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
+#define printk_ratelimited(fmt, ...)				\
+({								\
+	DEFINE_RATELIMIT_STATE(_rs,				\
+			       DEFAULT_RATELIMIT_INTERVAL,	\
+			       DEFAULT_RATELIMIT_BURST);	\
+								\
+	if (!__ratelimit(&_rs))					\
+		printk(fmt, ##__VA_ARGS__);			\
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


