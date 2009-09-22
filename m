Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZIVIkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZIVIkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbZIVIkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:40:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:42226 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496AbZIVIka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:40:30 -0400
Date: Tue, 22 Sep 2009 08:40:04 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, jolsa@redhat.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, jolsa@redhat.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AB86639.3000003@cn.fujitsu.com>
References: <4AB86639.3000003@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix failure path in ftrace_graph_write()
Message-ID: <tip-1eb90f138b3fb4cc15f3acec94aa788e846269f7@git.kernel.org>
Git-Commit-ID: 1eb90f138b3fb4cc15f3acec94aa788e846269f7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 08:40:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1eb90f138b3fb4cc15f3acec94aa788e846269f7
Gitweb:     http://git.kernel.org/tip/1eb90f138b3fb4cc15f3acec94aa788e846269f7
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 22 Sep 2009 13:52:57 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 10:28:56 +0200

tracing: Fix failure path in ftrace_graph_write()

Don't call trace_parser_put() on uninitialized trace_parser.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4AB86639.3000003@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a8fe478..5c5cb9b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2561,12 +2561,12 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 
 	if (ftrace_graph_count >= FTRACE_GRAPH_MAX_FUNCS) {
 		ret = -EBUSY;
-		goto out;
+		goto out_unlock;
 	}
 
 	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_unlock;
 	}
 
 	read = trace_get_user(&parser, ubuf, cnt, ppos);
@@ -2578,12 +2578,14 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
 					parser.buffer);
 		if (ret)
-			goto out;
+			goto out_free;
 	}
 
 	ret = read;
- out:
+
+out_free:
 	trace_parser_put(&parser);
+out_unlock:
 	mutex_unlock(&graph_lock);
 
 	return ret;
