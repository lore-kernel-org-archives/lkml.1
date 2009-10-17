Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbZJQKF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbZJQKF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZJQKFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:05:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:33081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbZJQKFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:05:48 -0400
Date: Sat, 17 Oct 2009 10:05:14 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091017000728.16556.16713.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000728.16556.16713.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Add failure messages for debugging
Message-ID: <tip-e63cc2397ecc0f2b604f22fb9cdbb05911c1e5d4@git.kernel.org>
Git-Commit-ID: e63cc2397ecc0f2b604f22fb9cdbb05911c1e5d4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:05:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e63cc2397ecc0f2b604f22fb9cdbb05911c1e5d4
Gitweb:     http://git.kernel.org/tip/e63cc2397ecc0f2b604f22fb9cdbb05911c1e5d4
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 16 Oct 2009 20:07:28 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Oct 2009 09:53:58 +0200

tracing/kprobes: Add failure messages for debugging

Add verbose failure messages to kprobe-tracer for debugging.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091017000728.16556.16713.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_kprobe.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index cdacdab..b8ef707 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -597,15 +597,19 @@ static int create_trace_probe(int argc, char **argv)
 	void *addr = NULL;
 	char buf[MAX_EVENT_NAME_LEN];
 
-	if (argc < 2)
+	if (argc < 2) {
+		pr_info("Probe point is not specified.\n");
 		return -EINVAL;
+	}
 
 	if (argv[0][0] == 'p')
 		is_return = 0;
 	else if (argv[0][0] == 'r')
 		is_return = 1;
-	else
+	else {
+		pr_info("Probe definition must be started with 'p' or 'r'.\n");
 		return -EINVAL;
+	}
 
 	if (argv[0][1] == ':') {
 		event = &argv[0][2];
@@ -625,21 +629,29 @@ static int create_trace_probe(int argc, char **argv)
 	}
 
 	if (isdigit(argv[1][0])) {
-		if (is_return)
+		if (is_return) {
+			pr_info("Return probe point must be a symbol.\n");
 			return -EINVAL;
+		}
 		/* an address specified */
 		ret = strict_strtoul(&argv[0][2], 0, (unsigned long *)&addr);
-		if (ret)
+		if (ret) {
+			pr_info("Failed to parse address.\n");
 			return ret;
+		}
 	} else {
 		/* a symbol specified */
 		symbol = argv[1];
 		/* TODO: support .init module functions */
 		ret = split_symbol_offset(symbol, &offset);
-		if (ret)
+		if (ret) {
+			pr_info("Failed to parse symbol.\n");
 			return ret;
-		if (offset && is_return)
+		}
+		if (offset && is_return) {
+			pr_info("Return probe must be used without offset.\n");
 			return -EINVAL;
+		}
 	}
 	argc -= 2; argv += 2;
 
@@ -658,8 +670,11 @@ static int create_trace_probe(int argc, char **argv)
 	}
 	tp = alloc_trace_probe(group, event, addr, symbol, offset, argc,
 			       is_return);
-	if (IS_ERR(tp))
+	if (IS_ERR(tp)) {
+		pr_info("Failed to allocate trace_probe.(%d)\n",
+			(int)PTR_ERR(tp));
 		return PTR_ERR(tp);
+	}
 
 	/* parse arguments */
 	ret = 0;
@@ -672,6 +687,8 @@ static int create_trace_probe(int argc, char **argv)
 			arg = argv[i];
 
 		if (conflict_field_name(argv[i], tp->args, i)) {
+			pr_info("Argument%d name '%s' conflicts with "
+				"another field.\n", i, argv[i]);
 			ret = -EINVAL;
 			goto error;
 		}
@@ -685,8 +702,10 @@ static int create_trace_probe(int argc, char **argv)
 			goto error;
 		}
 		ret = parse_probe_arg(arg, &tp->args[i].fetch, is_return);
-		if (ret)
+		if (ret) {
+			pr_info("Parse error at argument%d. (%d)\n", i, ret);
 			goto error;
+		}
 	}
 	tp->nr_args = i;
 
