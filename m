Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZKNGfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZKNGfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZKNGfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:35:33 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:36800 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbZKNGfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:35:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hCpIFz7WI4GvC49m3ouhmJxPRdcfd3j0oYlXn191x3CoTGtNB5uFAAEELGHJnzxkUE
         kH8EQEoKeDZ+VgkL7eRtCt4FRlwvKa7Ksm2CPFbpq5+ed9PJ2kfB4LMDhQIPil3apHBa
         dvjo5EfcVkl2WhZXlFvCiWTdoJFevSvMOn6xw=
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
Subject: [PATCH v8 10/16] tracing: not trace the timecounter_read* in kernel/time/clocksource.c
Date: Sat, 14 Nov 2009 14:33:25 +0800
Message-Id: <f3a54cef2de00885ee75a930b243083a716370bd.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <c1fe0d6822e98bc0ffd2dfee7a579fbbe21430e0.1258177321.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1258177321.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
 <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
 <7c7568247ad6cc109ec20387cfc3ca258d1d430f.1258177321.git.wuzhangjin@gmail.com>
 <3fcaffcfb3c8c8cd3015151ed5b7480ccaecde0f.1258177321.git.wuzhangjin@gmail.com>
 <48676d84140dbafd46e530611766121e18abc4ef.1258177321.git.wuzhangjin@gmail.com>
 <99ebd8fcb19e4cccd702fca966405ffc45f8540b.1258177321.git.wuzhangjin@gmail.com>
 <c1fe0d6822e98bc0ffd2dfee7a579fbbe21430e0.1258177321.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

Some platforms(i.e. MIPS) need these two functions to get the precise
timestamp, we use __time_notrace(added in the last patch) to annotate
it. By default, __time_notrace is empty, so, this patch have no
influence to the original functions, but if you really not need to trace
them, just add the following line into the arch specific ftrace.h:

	#define __time_notrace notrace

If you only need it for function graph tracer, wrap it:

	#ifdef CONFIG_FUNCTION_GRAPH_TRACER
	 #define __time_notrace notrace
	#endif

please get more information from include/linux/ftrace.h

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 kernel/time/clocksource.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5e18c6a..b00476a 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -30,6 +30,7 @@
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
 #include <linux/kthread.h>
+#include <linux/ftrace.h>
 
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
@@ -52,7 +53,7 @@ EXPORT_SYMBOL(timecounter_init);
  * The first call to this function for a new time counter initializes
  * the time tracking and returns an undefined result.
  */
-static u64 timecounter_read_delta(struct timecounter *tc)
+static u64 __time_notrace timecounter_read_delta(struct timecounter *tc)
 {
 	cycle_t cycle_now, cycle_delta;
 	u64 ns_offset;
@@ -72,7 +73,7 @@ static u64 timecounter_read_delta(struct timecounter *tc)
 	return ns_offset;
 }
 
-u64 timecounter_read(struct timecounter *tc)
+u64 __time_notrace timecounter_read(struct timecounter *tc)
 {
 	u64 nsec;
 
-- 
1.6.2.1

