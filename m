Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466Ab0AQSdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0AQSdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439Ab0AQSdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:33:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:34385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab0AQSdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:33:07 -0500
Date: Sun, 17 Jan 2010 18:31:20 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20100114051211.7814.29436.stgit@localhost6.localdomain6>
References: <20100114051211.7814.29436.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobe: Update kprobe tracing self test for new syntax
Message-ID: <tip-231e36f4d2e63dd770db80b9f5113310c2bcfcfd@git.kernel.org>
Git-Commit-ID: 231e36f4d2e63dd770db80b9f5113310c2bcfcfd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 17 Jan 2010 18:31:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  231e36f4d2e63dd770db80b9f5113310c2bcfcfd
Gitweb:     http://git.kernel.org/tip/231e36f4d2e63dd770db80b9f5113310c2bcfcfd
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 14 Jan 2010 00:12:12 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 17 Jan 2010 08:15:35 +0100

tracing/kprobe: Update kprobe tracing self test for new syntax

Update kprobe tracing self test for new syntax (it supports
deleting individual probes, and drops $argN support)
and behavior change (new probes are disabled in default).

This selftest includes the following checks:

 - Adding function-entry probe and return probe with arguments.
 - Enabling these probes.
 - Deleting it individually.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100114051211.7814.29436.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_kprobe.c |   55 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ac728d..d6266ca 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1507,28 +1507,67 @@ static int kprobe_trace_selftest_target(int a1, int a2, int a3,
 
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
 
