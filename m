Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbZCOXc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbZCOXc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 19:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZCOXcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 19:32:47 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:35635 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZCOXcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 19:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nxwoq4z+fz2/Mx8b4ZgDnCBM0HyMQQU8PkDzJ0CXslHKMx/LLkgeV56cBNr5YKPMfQ
         wWMAnv2JTsHtXPdMFOjra+gI3ljxSqpv+W47Tp3bZwyDEu1Q6HyV4405VWVPnbzpct43
         BKjVpiYZfrB28Kn78TzHTnGUkJ67vi0OVhA30=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] tracing/ftrace: fix double calls to tracing_start()
Date: Mon, 16 Mar 2009 00:32:41 +0100
Message-Id: <1237159961-7447-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a warning during preemptirqsoff selftests

When the preemptirqsoff selftest fails, we see the following
warning:

[    6.050000] Testing tracer preemptirqsoff: .. no entries found ..
------------[ cut here ]------------
[    6.060000] WARNING: at kernel/trace/trace.c:688 tracing_start+0x67/0xd3()
[    6.060000] Modules linked in:
[    6.060000] Pid: 1, comm: swapper Tainted: G
[    6.060000] Call Trace:
[    6.060000]  [<ffffffff802460ff>] warn_slowpath+0xb1/0x100
[    6.060000]  [<ffffffff802a8f5b>] ? trace_preempt_on+0x35/0x4b
[    6.060000]  [<ffffffff802a37fb>] ? tracing_start+0x31/0xd3
[    6.060000]  [<ffffffff802a37fb>] ? tracing_start+0x31/0xd3
[    6.060000]  [<ffffffff80271e0b>] ? __lock_acquired+0xe6/0x1f2
[    6.060000]  [<ffffffff802a37fb>] ? tracing_start+0x31/0xd3
[    6.060000]  [<ffffffff802a3831>] tracing_start+0x67/0xd3
[    6.060000]  [<ffffffff802a8ace>] ? irqsoff_tracer_reset+0x2d/0x57
[    6.060000]  [<ffffffff802a4d1c>] trace_selftest_startup_preemptirqsoff+0x1c8/0x1f1
[    6.060000]  [<ffffffff802a4798>] register_tracer+0x12f/0x241
[    6.060000]  [<ffffffff810250d0>] ? init_irqsoff_tracer+0x0/0x53
[    6.060000]  [<ffffffff8102510b>] init_irqsoff_tracer+0x3b/0x53

This is because in fail case, the preemptirqsoff tracer selftest calls twice
the tracing_start() function:

int
trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *tr)
{
        if (!ret && !count) {
                printk(KERN_CONT ".. no entries found ..");
                ret = -1;
                tracing_start(); <-----
                goto out;
        }
        [...]
out:
        trace->reset(tr);
        tracing_start(); <------
        tracing_max_latency = save_max;

        return ret;
}

Since it is well handled in the out path, we don't need the conditional one.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_selftest.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index f907a2b..a2ca6f0 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -414,7 +414,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
-		goto out;
+		goto out_no_start;
 	}
 
 	/* reset the max latency */
@@ -432,21 +432,16 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	tracing_stop();
 	/* check both trace buffers */
 	ret = trace_test_buffer(tr, NULL);
-	if (ret) {
-		tracing_start();
+	if (ret)
 		goto out;
-	}
 
 	ret = trace_test_buffer(&max_tr, &count);
-	if (ret) {
-		tracing_start();
+	if (ret)
 		goto out;
-	}
 
 	if (!ret && !count) {
 		printk(KERN_CONT ".. no entries found ..");
 		ret = -1;
-		tracing_start();
 		goto out;
 	}
 
@@ -475,9 +470,10 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 		goto out;
 	}
 
- out:
-	trace->reset(tr);
+out:
 	tracing_start();
+out_no_start:
+	trace->reset(tr);
 	tracing_max_latency = save_max;
 
 	return ret;
-- 
1.6.1

