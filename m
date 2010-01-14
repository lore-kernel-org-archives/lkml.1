Return-Path: <linux-kernel-owner+w=401wt.eu-S1751382Ab0ANFMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab0ANFMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973Ab0ANFMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:12:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0ANFMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:12:10 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip] tracing/kprobe: Update kprobe tracing self test for new
	syntax
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 14 Jan 2010 00:12:12 -0500
Message-ID: <20100114051211.7814.29436.stgit@localhost6.localdomain6>
In-Reply-To: <4B4DF7DD.9090908@redhat.com>
References: <4B4DF7DD.9090908@redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update kprobe tracing self test for new syntax (it supports
deleting individual probes, and drops $argN support)
and behavior change (new probes are disabled in default).

This selftest includes below checks.
- Adding function-entry probe and return probe with arguments.
- Enabling these probes.
- Deleting it individually.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 kernel/trace/trace_kprobe.c |   55 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 4fc7d44..aa19b6a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1491,28 +1491,67 @@ static int kprobe_trace_selftest_target(int a1, int a2, int a3,
 
 static __init int kprobe_trace_self_tests_init(void)
 {
-	int ret;
+	int ret, warn = 0;
 	int (*target)(int, int, int, int, int, int);
+	struct trace_probe *tp;
 
 	target = kprobe_trace_selftest_target;
 
 	pr_info("Testing kprobe tracing: ");
 
 	ret = command_trace_probe("p:testprobe kprobe_trace_selftest_target "
-				  "$arg1 $arg2 $arg3 $arg4 $stack $stack0");
-	if (WARN_ON_ONCE(ret))
-		pr_warning("error enabling function entry\n");
+				  "$stack $stack0 +0($stack)");
+	if (WARN_ON_ONCE(ret)) {
+		pr_warning("error on probing function entry.\n");
+		warn++;
+	} else {
+		/* Enable trace point */
+		tp = find_probe_event("testprobe", KPROBE_EVENT_SYSTEM);
+		if (WARN_ON_ONCE(tp == NULL)) {
+			pr_warning("error on getting new probe.\n");
+			warn++;
+		} else
+			probe_event_enable(&tp->call);
+	}
 
 	ret = command_trace_probe("r:testprobe2 kprobe_trace_selftest_target "
 				  "$retval");
-	if (WARN_ON_ONCE(ret))
-		pr_warning("error enabling function return\n");
+	if (WARN_ON_ONCE(ret)) {
+		pr_warning("error on probing function return.\n");
+		warn++;
+	} else {
+		/* Enable trace point */
+		tp = find_probe_event("testprobe2", KPROBE_EVENT_SYSTEM);
+		if (WARN_ON_ONCE(tp == NULL)) {
+			pr_warning("error on getting new probe.\n");
+			warn++;
+		} else
+			probe_event_enable(&tp->call);
+	}
+
+	if (warn)
+		goto end;
 
 	ret = target(1, 2, 3, 4, 5, 6);
 
-	cleanup_all_probes();
+	ret = command_trace_probe("-:testprobe");
+	if (WARN_ON_ONCE(ret)) {
+		pr_warning("error on deleting a probe.\n");
+		warn++;
+	}
+
+	ret = command_trace_probe("-:testprobe2");
+	if (WARN_ON_ONCE(ret)) {
+		pr_warning("error on deleting a probe.\n");
+		warn++;
+	}
 
-	pr_cont("OK\n");
+end:
+	cleanup_all_probes();
+	if (warn)
+		pr_cont("NG: Some tests are failed. Please check them.\n");
+	else
+		pr_cont("OK\n");
 	return 0;
 }
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
