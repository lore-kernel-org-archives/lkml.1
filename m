Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZJUOfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZJUOfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZJUOfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:35:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64251 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbZJUOfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:35:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f+u9j+rG8W/in3qIeV74JaH/8S0pv58xuL3yrWZpcOUDIt8nSKvXhk2F8SGWBAmcq5
         goJQnCBf6I0Lb+kI+A1CSqpsgKdH8yb61FvVoPH80XwjCn65SRfxHUxdOvrqQs6v5gqS
         66N0poDkrTCYPFzfyyrUBlm5Ks4Tldbl0wBPM=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH -v4 1/9] tracing: convert trace_clock_local() as weak function
Date: Wed, 21 Oct 2009 22:34:55 +0800
Message-Id: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1256135456.git.wuzhangjin@gmail.com>
References: <cover.1256135456.git.wuzhangjin@gmail.com>
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

The MIPS specific trace_clock_local() is coming in the next two patches.

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

