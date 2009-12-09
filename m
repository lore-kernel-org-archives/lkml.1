Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZLIJ6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZLIJ6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZLIJ6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:58:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:45780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbZLIJ5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:57:54 -0500
Date: Wed, 9 Dec 2009 09:57:13 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <1260263815-5167-1-git-send-regression-fweisbec@gmail.com>
References: <1260263815-5167-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing/kprobes: Fix field creation's bad error handling
Message-ID: <tip-822a6961112f0c9101d3359d8524604c3309ee6c@git.kernel.org>
Git-Commit-ID: 822a6961112f0c9101d3359d8524604c3309ee6c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  822a6961112f0c9101d3359d8524604c3309ee6c
Gitweb:     http://git.kernel.org/tip/822a6961112f0c9101d3359d8524604c3309ee6c
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 8 Dec 2009 10:00:04 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:32:21 +0100

tracing/kprobes: Fix field creation's bad error handling

When we define the common event fields in kprobe, we invert the error
handling and return immediately in case of success. Then we omit
to define specific kprobes fields (ip and nargs), and specific
kretprobes fields (func, ret_ip, nargs). And we only define them
when we fail to create common fields.

The most visible consequence is that we can't create filter for
k(ret)probes specific fields.

This patch re-invert the success/error handling to fix it.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <1260263815-5167-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_kprobe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index bf05fb4..b52d397 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1133,7 +1133,7 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
 	ret = trace_define_common_fields(event_call);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
@@ -1151,7 +1151,7 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
 	ret = trace_define_common_fields(event_call);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
