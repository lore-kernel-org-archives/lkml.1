Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbZKNGdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbZKNGdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZKNGdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:33:53 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:51313 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbZKNGdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:33:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FKe7LvinNdlpNKFznX2g0IIITpB7ih6jyNbT63AoZFMlqPNKmavSsVlAggy4kN1lcZ
         3BJHZ3ya3/e8XTRxlhi22SbjVMEQiiCG031qvB7moMoPzA0zMhoCdjj6XH/bteKHlZxl
         plx4hjdOZuIGR3piYj2yS8yrpgnFkcqHDG3/w=
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
Subject: [PATCH v8 01/16] tracing: convert trace_clock_local() as weak function
Date: Sat, 14 Nov 2009 14:33:16 +0800
Message-Id: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

trace_clock_local() is based on the arch-specific sched_clock(), in X86,
it is tsc(64bit) based, which can give very high precision(about 1ns
with 1GHz). but in MIPS, the sched_clock() is jiffies based, which can
give only 10ms precison with 1000 HZ. which is not enough for tracing,
especially for Real Time system.

so, we need to implement a MIPS specific sched_clock() to get higher
precision. There is a tsc like clock counter register in MIPS, whose
frequency is half of the processor, so, if the cpu frequency is 800MHz,
the time precision reaches 2.5ns, which is very good for tracing, even
for Real Time system.

but 'Cause it is only 32bit long, which will rollover quickly, so, such
a sched_clock() will bring with extra load, which is not good for the
whole system. so, we only need to implement a arch-specific
trace_clock_local() for tracing. as a preparation, we convert it as a
weak function.

The MIPS specific trace_clock_local() is coming in the next two patches.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 kernel/trace/trace_clock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 20c5f92..06b8cd2 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -26,7 +26,7 @@
  * Useful for tracing that does not cross to other CPUs nor
  * does it go through idle events.
  */
-u64 notrace trace_clock_local(void)
+u64 __weak notrace trace_clock_local(void)
 {
 	unsigned long flags;
 	u64 clock;
-- 
1.6.2.1

