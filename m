Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZK0FuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZK0FuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbZK0FuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:50:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:57904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbZK0FuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:50:06 -0500
Date: Fri, 27 Nov 2009 05:49:46 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <4B0CEB95.2060107@cn.fujitsu.com>
References: <4B0CEB95.2060107@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace_kprobes: Fix memory leak
Message-ID: <tip-abab9d37d2a826fcf588c5f30152dbe05c40111c@git.kernel.org>
Git-Commit-ID: abab9d37d2a826fcf588c5f30152dbe05c40111c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abab9d37d2a826fcf588c5f30152dbe05c40111c
Gitweb:     http://git.kernel.org/tip/abab9d37d2a826fcf588c5f30152dbe05c40111c
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 25 Nov 2009 16:32:21 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Nov 2009 06:43:04 +0100

trace_kprobes: Fix memory leak

tp->nr_args is not set before we "goto error",
it causes memory leak for free_trace_probe() use tp->nr_args
to free memory of args.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0CEB95.2060107@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_kprobe.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 79ce6a2..82e8583 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -704,10 +704,12 @@ static int create_trace_probe(int argc, char **argv)
 		ret = parse_probe_arg(arg, &tp->args[i].fetch, is_return);
 		if (ret) {
 			pr_info("Parse error at argument%d. (%d)\n", i, ret);
+			kfree(tp->args[i].name);
 			goto error;
 		}
+
+		tp->nr_args++;
 	}
-	tp->nr_args = i;
 
 	ret = register_trace_probe(tp);
 	if (ret)
