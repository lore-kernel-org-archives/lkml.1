Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbZKIPc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbZKIPc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbZKIPc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:32:57 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39623 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbZKIPcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:32:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eqnVFsLYoF/BypcOla0z16C1DwO3Uzt7+CQKvATZTaLUncJYumVz8nYuXCpIDMxHB0
         3Nw4ono2C7UpevoAdh3Eea9lT2JDNt8M5hrNDTboZGMqozbM0Tbe1CJ5NpW8u4eNmNBa
         K0CJU2ggjnmNRu86oiYu1U9feKaIYK3Ly2gSI=
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
Subject: [PATCH v7 10/17] tracing: not trace the timecounter_read* in kernel/time/clocksource.c
Date: Mon,  9 Nov 2009 23:31:27 +0800
Message-Id: <3da916c1cb6e05445438826f98a91111f43ff6cd.1257779502.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <18e1d617ed824bb1c10f15216f2ed9ed3de78abd.1257779502.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
 <6199d7b3956b544fc65896af1062787a2e1283ce.1257779502.git.wuzhangjin@gmail.com>
 <58a7558730fbea6cd0417100c8fcd6f45668d1e3.1257779502.git.wuzhangjin@gmail.com>
 <3a9fc9ca02e8e6e9c3c28797a4c084c1f9d91f69.1257779502.git.wuzhangjin@gmail.com>
 <0cef783a71333ff96a78aaea8961e3b6b5392665.1257779502.git.wuzhangjin@gmail.com>
 <18e1d617ed824bb1c10f15216f2ed9ed3de78abd.1257779502.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1257779502.git.wuzhangjin@gmail.com>
References: <cover.1257779502.git.wuzhangjin@gmail.com>
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

