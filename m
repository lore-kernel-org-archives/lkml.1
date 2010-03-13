Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0CMGul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 01:50:41 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:64010 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0CMGuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 01:50:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=LPWcrerUp3WNUklQRr51zYJZEMCskrK1CbOsxLZeoLijEL85ontbzpweQOcdlMIpiq
         Fst4GRbhO22jb14onQ/snk+0chFI+n+G95+e+UcdEqfcFDBR7oSYSQ3zaNomcQyRcE60
         FSAd3OFs+OBb/Z6VhWqQD+CJiuG8mmRz4RQ2E=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 04/10] ARM: ftrace: allow building without frame pointers
Date: Sat, 13 Mar 2010 12:19:41 +0530
Message-Id: <1268462987-8271-5-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1268462987-8271-1-git-send-email-rabin@rab.in>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a new enough GCC, ARM function tracing can be supported without the
need for frame pointers.  This is essential for Thumb-2 support, since
frame pointers aren't available then.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
v2: #error if incompatible GCC.

 arch/arm/Kconfig.debug         |    5 +++++
 arch/arm/kernel/armksyms.c     |    2 ++
 arch/arm/kernel/entry-common.S |   14 ++++++++++++++
 kernel/trace/Kconfig           |    2 +-
 4 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 91344af..4dbce53 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -27,6 +27,11 @@ config ARM_UNWIND
 	  the performance is not affected. Currently, this feature
 	  only works with EABI compilers. If unsure say Y.
 
+config OLD_MCOUNT
+	bool
+	depends on FUNCTION_TRACER && FRAME_POINTER
+	default y
+
 config DEBUG_USER
 	bool "Verbose user fault messages"
 	help
diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 8214bfe..e5e1e53 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -165,6 +165,8 @@ EXPORT_SYMBOL(_find_next_bit_be);
 #endif
 
 #ifdef CONFIG_FUNCTION_TRACER
+#ifdef CONFIG_OLD_MCOUNT
 EXPORT_SYMBOL(mcount);
+#endif
 EXPORT_SYMBOL(__gnu_mcount_nc);
 #endif
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index f05a35a..6805a72 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -128,6 +128,13 @@ ENDPROC(ret_from_fork)
  * allows it to be clobbered in subroutines and doesn't use it to hold
  * parameters.)
  */
+
+#ifndef CONFIG_OLD_MCOUNT
+#if (__GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 4))
+#error Ftrace requires CONFIG_FRAME_POINTER=y with GCC older than 4.4.0.
+#endif
+#endif
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
 	stmdb	sp!, {r0-r3, lr}
@@ -173,6 +180,12 @@ gnu_trace:
 	ldmia	sp!, {r0-r3, ip, lr}
 	mov	pc, ip
 
+#ifdef CONFIG_OLD_MCOUNT
+/*
+ * This is under an ifdef in order to force link-time errors for people trying
+ * to build with !FRAME_POINTER with a GCC which doesn't use the new-style
+ * mcount.
+ */
 ENTRY(mcount)
 	stmdb	sp!, {r0-r3, lr}
 	ldr	r0, =ftrace_trace_function
@@ -191,6 +204,7 @@ trace:
 	mov	pc, r2
 	ldr	lr, [fp, #-4]			@ restore lr
 	ldmia	sp!, {r0-r3, pc}
+#endif
 
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 13e13d4..e10519f 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -124,7 +124,7 @@ if FTRACE
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER
+	select FRAME_POINTER if (!ARM_UNWIND)
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
-- 
1.7.0

