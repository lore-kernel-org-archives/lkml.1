Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZIVFyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZIVFyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZIVFyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:54:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61335 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbZIVFyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:54:08 -0400
Message-ID: <4AB86639.3000003@cn.fujitsu.com>
Date: Tue, 22 Sep 2009 13:52:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] tracing: fix failure path in ftrace_graph_write()
References: <4AB865FA.5080801@cn.fujitsu.com>
In-Reply-To: <4AB865FA.5080801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't call trace_parser_put() on uninitialized trace_parser.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.6.3

