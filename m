Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZKIPdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZKIPdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbZKIPdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:33:07 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:56558 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbZKIPdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:33:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GDOyDp8sFTdN2whugqNNE0Fhp0HkvH23WGahGReJwHMHaA5x5SnPgPBA37tKIBG5TH
         qutibP1t4n2mz2cSviVeO4d2DnKEY5AdElHTxxQz/5dDMrpH6+r1x8hkHxUmRyRywvSp
         iQHYLdHoi6PdIJGTOL2f003DBjRtoiVVEjAUU=
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
Subject: [PATCH v7 11/17] tracing: not trace mips_timecounter_read() for MIPS
Date: Mon,  9 Nov 2009 23:31:28 +0800
Message-Id: <d4aa4cdb9b4c25e7a683c923bdeabed847bd8010.1257779502.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <3da916c1cb6e05445438826f98a91111f43ff6cd.1257779502.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
 <6199d7b3956b544fc65896af1062787a2e1283ce.1257779502.git.wuzhangjin@gmail.com>
 <58a7558730fbea6cd0417100c8fcd6f45668d1e3.1257779502.git.wuzhangjin@gmail.com>
 <3a9fc9ca02e8e6e9c3c28797a4c084c1f9d91f69.1257779502.git.wuzhangjin@gmail.com>
 <0cef783a71333ff96a78aaea8961e3b6b5392665.1257779502.git.wuzhangjin@gmail.com>
 <18e1d617ed824bb1c10f15216f2ed9ed3de78abd.1257779502.git.wuzhangjin@gmail.com>
 <3da916c1cb6e05445438826f98a91111f43ff6cd.1257779502.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1257779502.git.wuzhangjin@gmail.com>
References: <cover.1257779502.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

We use mips_timecounter_read() to get the timestamp in MIPS, so, it's
better to not trace it and it's subroutines, otherwise, it will goto
recursion(hang) when using function graph tracer. we use the
__notrace_funcgraph annotation to indicate them not to be traced.

And there are two common functions called by mips_timecounter_read(), we
define the __time_notrace macro to ensure they are not to be traced
either.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/include/asm/ftrace.h |    6 ++++++
 arch/mips/kernel/csrc-r4k.c    |    5 +++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
index 7094a40..aa7c80b 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -28,6 +28,12 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 struct dyn_arch_ftrace {
 };
 #endif /*  CONFIG_DYNAMIC_FTRACE */
+
+/* not trace the timecounter_read* in kernel/time/clocksource.c */
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ #define __time_notrace notrace
+#endif
+
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 #endif /* _ASM_MIPS_FTRACE_H */
diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
index 4e7705f..0c1bf80 100644
--- a/arch/mips/kernel/csrc-r4k.c
+++ b/arch/mips/kernel/csrc-r4k.c
@@ -8,6 +8,7 @@
 #include <linux/clocksource.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/ftrace.h>
 
 #include <asm/time.h>
 
@@ -42,7 +43,7 @@ static struct timecounter r4k_tc = {
 	.cc = NULL,
 };
 
-static cycle_t r4k_cc_read(const struct cyclecounter *cc)
+static cycle_t __notrace_funcgraph r4k_cc_read(const struct cyclecounter *cc)
 {
 	return read_c0_count();
 }
@@ -66,7 +67,7 @@ int __init init_r4k_timecounter(void)
 	return 0;
 }
 
-u64 r4k_timecounter_read(void)
+u64 __notrace_funcgraph r4k_timecounter_read(void)
 {
 	u64 clock;
 
-- 
1.6.2.1

