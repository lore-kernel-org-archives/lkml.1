Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699Ab0AVBSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0AVBSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577Ab0AVBSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:18:17 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53143 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab0AVBQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YDA50xwQq/55QbBkCdQJjsYug5BW+pwXWi/LbYL5j1/jn4lvowDddNEJGgNRIMK3uG
         bvNcQ2Vdcr4zymzbunxYzApC9kGZ1vc82GOFgziOfZAEN6LGXB6cpWrYCPc+57PRW/RF
         7sjnGYiWBu/XIn5E2X3/D2s5tQewygImn7fwQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 05/10] ftrace: Drop buffer check in function profiler callbacks
Date: Fri, 22 Jan 2010 02:16:17 +0100
Message-Id: <1264122982-1553-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the null check on hlist->hash. It is wasteful because
we don't register the tracer if the buffer allocation failed,
and the memory barrier in register_ftrace_graph() ensure it
is visible to the callbacks right away.

Also we know the tracing callbacks won't be called after
register_ftrace_graph(), so subsequent buffer resets are safe
too.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3cdb35e..dfd8f7c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -384,8 +384,6 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 	local_irq_save(flags);
 
 	hlist = &__get_cpu_var(func_hlist_cpu);
-	if (!hlist->hash)
-		goto out;
 
 	rec = function_find_hlist_node(hlist, ip);
 	if (!rec) {
@@ -415,8 +413,6 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 
 	local_irq_save(flags);
 	hlist = &__get_cpu_var(func_hlist_cpu);
-	if (!hlist->hash)
-		goto out;
 
 	calltime = trace->rettime - trace->calltime;
 
@@ -439,7 +435,6 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 	if (rec)
 		rec->time += calltime;
 
- out:
 	local_irq_restore(flags);
 }
 
-- 
1.6.2.3

