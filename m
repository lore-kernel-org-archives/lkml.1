Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZKNGee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZKNGee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZKNGec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:34:32 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42859 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZKNGea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IR5lzP7kI69ajxU2ypIleRS1njVvNe+dIXKubaJfS1tHCcrVHWWwPVLMUwUfkCNqkD
         XB2XyS6DJKS9zo2x8Byd3aziAwxK9nc4Re79p2mYW5+hStnY5rdLUTTOwLnWEqYRG5m4
         Ki3x39Jg00qVus84xKqFQv62FrjbIFZOhlVaY=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: [PATCH v8 05/16] tracing: enable HAVE_FUNCTION_TRACE_MCOUNT_TEST for MIPS
Date: Sat, 14 Nov 2009 14:33:20 +0800
Message-Id: <7c7568247ad6cc109ec20387cfc3ca258d1d430f.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1258177321.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
 <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
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

