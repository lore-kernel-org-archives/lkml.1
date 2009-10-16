Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbZJPLjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbZJPLjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 07:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbZJPLjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 07:39:16 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:50379 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864AbZJPLjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 07:39:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BDT8mK4bOnvB+QbLgtuEnq8/qgU/J2zhRdblv7+6nPfefN9hRH4KImeOp/ucA26lFk
         iC96s/2xNAbatELeUQIN3r/Yjp12+lQb3C+mGRv7BhZK9+DzIlfPpVdmwM+8yn6rsrvZ
         uBQQ9Yt8NUSYsjgkshcuEYzl8i/DsmTV96s3I=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Manuel Lauss <manuel.lauss@googlemail.com>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH 1/2] tracing: convert trace_clock_local() as weak function
Date: Fri, 16 Oct 2009 19:38:24 +0800
Message-Id: <4205779ae74d7c4144ee6cbf4e3f15f833646356.1255692619.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

The MIPS specific trace_clock_local() is coming in the next patch.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 kernel/trace/trace_clock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 20c5f92..a04dc18 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -26,7 +26,7 @@
  * Useful for tracing that does not cross to other CPUs nor
  * does it go through idle events.
  */
-u64 notrace trace_clock_local(void)
+u64 __attribute__((weak)) notrace trace_clock_local(void)
 {
 	unsigned long flags;
 	u64 clock;
-- 
1.6.2.1

