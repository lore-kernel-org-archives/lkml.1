Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZD2E7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZD2E7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZD2E7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:59:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZD2E7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:59:07 -0400
Message-Id: <20090429045904.381487770@goodmis.org>
References: <20090429044814.138790038@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Apr 2009 00:48:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] tracing: convert ftrace_dump spinlocks to raw
Content-Disposition: inline; filename=0001-tracing-convert-ftrace_dump-spinlocks-to-raw.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

ftrace_dump is used for printing out the contents of the ftrace ring buffer
to the console on failure. Currently it uses a spinlock to synchronize
the output from multiple failures on different CPUs. This spin lock
currently is a normal spinlock and can cause issues with lockdep and
lock tracing.

This patch converts it to raw since it is for error handling only.
The lock is local to the ftrace_dump and is not used by any other
infrastructure.

[ Impact: prevent ftrace_dump from locking up by internal tracing ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b6183bc..5d704a4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4114,7 +4114,8 @@ trace_printk_seq(struct trace_seq *s)
 
 static void __ftrace_dump(bool disable_tracing)
 {
-	static DEFINE_SPINLOCK(ftrace_dump_lock);
+	static raw_spinlock_t ftrace_dump_lock =
+		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
 	unsigned int old_userobj;
@@ -4123,7 +4124,8 @@ static void __ftrace_dump(bool disable_tracing)
 	int cnt = 0, cpu;
 
 	/* only one dump */
-	spin_lock_irqsave(&ftrace_dump_lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&ftrace_dump_lock);
 	if (dump_ran)
 		goto out;
 
@@ -4195,7 +4197,8 @@ static void __ftrace_dump(bool disable_tracing)
 	}
 
  out:
-	spin_unlock_irqrestore(&ftrace_dump_lock, flags);
+	__raw_spin_unlock(&ftrace_dump_lock);
+	local_irq_restore(flags);
 }
 
 /* By default: disable tracing after the dump */
-- 
1.6.2.1

-- 
