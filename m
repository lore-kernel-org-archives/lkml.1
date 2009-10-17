Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbZJQAH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbZJQAH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZJQAH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:07:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbZJQAHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:07:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 2/9] tracing/kprobes: Add failure
	messages for debugging
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 16 Oct 2009 20:07:28 -0400
Message-ID: <20091017000728.16556.16713.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add vorbose failure messages to kprobe-tracer for debugging.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
-
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
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
