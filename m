Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZKIPcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZKIPcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZKIPcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:32:18 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39623 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbZKIPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:32:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CUJZTLEIyQU5WF7l0TjWC9QkNfVfXE9zurEN2ZLysz9r4iQT+6FLN4ObD8AxoRK9Ec
         OcW4Y/cTBpUbm40mdsP4GWkmbBAtyOByNId+duh8Tdb+WrIqoiWCokoi0TVy1UDCXua4
         NoNPhJuBjKJ+28Oag2ic3V83aa9ah6OOISlrs=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: zhangfx@lemote.com, zhouqg@gmail.com, Wu Zhangjin <wuzhangjin@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH v7 05/17] tracing: enable HAVE_FUNCTION_TRACE_MCOUNT_TEST for MIPS
Date: Mon,  9 Nov 2009 23:31:22 +0800
Message-Id: <6199d7b3956b544fc65896af1062787a2e1283ce.1257779502.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1257779502.git.wuzhangjin@gmail.com>
References: <cover.1257779502.git.wuzhangjin@gmail.com>
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

