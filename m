Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbZBYWQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbZBYWQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZBYWQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:16:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49629 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbZBYWQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:16:12 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] make CALLER_ADDRx overwriteable
Date: Wed, 25 Feb 2009 23:16:09 +0100
Message-Id: <1235600169-26912-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current definition of CALLER_ADDRx isn't suitable for all platforms.
E.g. for ARM __builtin_return_address(N) doesn't work for N > 0 and
AFAIK for powerpc there are no frame pointers needed to have a working
__builtin_return_address.  This patch allows defining the CALLER_ADDRx
macros in <asm/ftrace.h> and let these take precedence.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

[I resent because vger blocked my mail saying: "Wrong MIME labeling on
8-bit character texts."  Steven didn't get it either.  I don't know
what's wrong, so I put the patch back into git and format-patch'd it.  I
hope this one makes it through.  Sorry if you got it twice.]

I think I don't break any architecture with this patch:

	$ for arch in $(ls arch/); do if test ! -d arch/$arch; then continue; fi; test -f arch/$arch/include/asm/ftrace.h || test -f include/asm-$arch/ftrace.h || { echo -n "$arch: "; git grep FTRACE arch/$arch | wc -l; } done
	alpha: 0
	avr32: 0
	blackfin: 0
	cris: 0
	frv: 0
	h8300: 0
	m32r: 0
	m68k: 0
	m68knommu: 0
	mips: 0
	mn10300: 0
	parisc: 0
	um: 0
	xtensa: 0

So all archs that don't have <asm/ftrace.h> seem not to use FTRACE.

Best regards
Uwe

 include/linux/ftrace.h |   41 +++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 847bb3c..9d8d362 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -11,6 +11,8 @@
 #include <linux/bitops.h>
 #include <linux/sched.h>
 
+#include <asm/ftrace.h>
+
 #ifdef CONFIG_FUNCTION_TRACER
 
 extern int ftrace_enabled;
@@ -103,8 +105,6 @@ struct ftrace_func_command {
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-/* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
-#include <asm/ftrace.h>
 
 int ftrace_arch_code_modify_prepare(void);
 int ftrace_arch_code_modify_post_process(void);
@@ -282,24 +282,25 @@ static inline void __ftrace_enabled_restore(int enabled)
 #endif
 }
 
-#ifdef CONFIG_FRAME_POINTER
-/* TODO: need to fix this for ARM */
-# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-# define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
-# define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
-# define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
-# define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
-# define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
-# define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
-#else
-# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-# define CALLER_ADDR1 0UL
-# define CALLER_ADDR2 0UL
-# define CALLER_ADDR3 0UL
-# define CALLER_ADDR4 0UL
-# define CALLER_ADDR5 0UL
-# define CALLER_ADDR6 0UL
-#endif
+#ifndef CALLER_ADDR0
+# ifdef CONFIG_FRAME_POINTER
+#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#  define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
+#  define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
+#  define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
+#  define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
+#  define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
+#  define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
+# else
+#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#  define CALLER_ADDR1 0UL
+#  define CALLER_ADDR2 0UL
+#  define CALLER_ADDR3 0UL
+#  define CALLER_ADDR4 0UL
+#  define CALLER_ADDR5 0UL
+#  define CALLER_ADDR6 0UL
+# endif
+#endif /* ifndef CALLER_ADDR0 */
 
 #ifdef CONFIG_IRQSOFF_TRACER
   extern void time_hardirqs_on(unsigned long a0, unsigned long a1);
-- 
tg: (db50eec..) t/ftrace/make_CALLER_ADDRx_overwriteable (depends on: tip/master)
