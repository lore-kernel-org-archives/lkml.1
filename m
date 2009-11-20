Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZKTMfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZKTMfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 07:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZKTMe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 07:34:59 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:61320 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbZKTMe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FGlxraMlHQjG/dmw1Wq83X88V30QfUqXVkV4GP6NNVXKLya5D3cJiQdG9ruY81mxXM
         gnmZECJUrQm/1Xk0UBW3efv6jvlxOzsmuk8lUT/nQQgZAQQyQJ7hCY3lno0hRCbSFvWs
         HMURAXr9JR0ryZkl7YRFLzt+pi+M8dobcIDoM=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org
Cc: Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       Wu Zhangjin <wuzhangjin@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: [PATCH v9 02/10] tracing: enable HAVE_FUNCTION_TRACE_MCOUNT_TEST for MIPS
Date: Fri, 20 Nov 2009 20:34:30 +0800
Message-Id: <51e30436a435480f1f0dec146a82f2b250900690.1258719323.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <adf867c5a6864fa196c667d3f09a6a694f3903c5.1258719323.git.wuzhangjin@gmail.com>
References: <adf867c5a6864fa196c667d3f09a6a694f3903c5.1258719323.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258719323.git.wuzhangjin@gmail.com>
References: <cover.1258719323.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

There is an exisiting common ftrace_test_stop_func() in
kernel/trace/ftrace.c, which is used to check the global variable
ftrace_trace_stop to determine whether stop the function tracing.

This patch implepment the MIPS specific one to speedup the procedure.

Thanks goes to Zhang Le for Cleaning it up.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig         |    1 +
 arch/mips/kernel/mcount.S |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 6b33e88..a9bd992 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -5,6 +5,7 @@ config MIPS
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB
 	select HAVE_FUNCTION_TRACER
+	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB if !LEMOTE_FULOONG2E
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index cebcc3c..cbb45ed 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -59,6 +59,9 @@
 	.endm
 
 NESTED(_mcount, PT_SIZE, ra)
+	lw	t0, function_trace_stop
+	bnez	t0, ftrace_stub
+	 nop
 	PTR_LA	t0, ftrace_stub
 	PTR_L	t1, ftrace_trace_function /* Prepare t1 for (1) */
 	bne	t0, t1, static_trace
-- 
1.6.2.1

