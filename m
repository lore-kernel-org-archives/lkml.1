Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbZCPIUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbZCPIUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbZCPITz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:19:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:44671 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789AbZCPITv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:19:51 -0400
Date: Mon, 16 Mar 2009 08:19:25 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237159961-7447-1-git-send-email-fweisbec@gmail.com>
References: <1237159961-7447-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/ftrace: fix double calls to tracing_start()
Message-ID: <tip-ac1d52d0b85854958c7e78c8006e39aadb6ce4b8@git.kernel.org>
Git-Commit-ID: ac1d52d0b85854958c7e78c8006e39aadb6ce4b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 08:19:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac1d52d0b85854958c7e78c8006e39aadb6ce4b8
Gitweb:     http://git.kernel.org/tip/ac1d52d0b85854958c7e78c8006e39aadb6ce4b8
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 16 Mar 2009 00:32:41 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Mar 2009 09:13:18 +0100

tracing/ftrace: fix double calls to tracing_start()

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
LKML-Reference: <1237159961-7447-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
