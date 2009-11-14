Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZKNGfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZKNGfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbZKNGfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:35:41 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:36800 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZKNGfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:35:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YIkwdED7ewVF/vfP1SLIUxCpvysNElpSfUx5CiZgkoE1MP8NOyoP4pvhr7N+Em7N5+
         zRzlqrr3xELCeyomrrgEzaUZuZRljzw8AmKi/12GQpFzFRVr3lYpvT3KFAUSQum0y+la
         c0GlVRG10vtky0jpljNzGR6R2h7oXASE5YdXg=
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
Subject: [PATCH v8 11/16] tracing: not trace mips_timecounter_read() for MIPS
Date: Sat, 14 Nov 2009 14:33:26 +0800
Message-Id: <b98ca1b2048aeab8aac82ec8723ac729c2cd4b54.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <f3a54cef2de00885ee75a930b243083a716370bd.1258177321.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1258177321.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
 <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
 <7c7568247ad6cc109ec20387cfc3ca258d1d430f.1258177321.git.wuzhangjin@gmail.com>
 <3fcaffcfb3c8c8cd3015151ed5b7480ccaecde0f.1258177321.git.wuzhangjin@gmail.com>
 <48676d84140dbafd46e530611766121e18abc4ef.1258177321.git.wuzhangjin@gmail.com>
 <99ebd8fcb19e4cccd702fca966405ffc45f8540b.1258177321.git.wuzhangjin@gmail.com>
 <c1fe0d6822e98bc0ffd2dfee7a579fbbe21430e0.1258177321.git.wuzhangjin@gmail.com>
 <f3a54cef2de00885ee75a930b243083a716370bd.1258177321.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
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

