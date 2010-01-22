Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349Ab0AVBQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0AVBQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085Ab0AVBQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:16:30 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57482 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab0AVBQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=J2mIPWCz/d+nupHG5X+MVlbd2t62kGuy+AOLWM4TaA9RJ5p1g/1+QuoRK3g5QKlAt+
         rZaTaplePz4i3WpIyZRnGWzASJYgdBXkHvZ+cd/H+r1StxATETjzkbuzLIoa67FRLh7U
         i+X+wsjBoyZCfRdR+ADocxVjalk3D6UbwRYrU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled checks in tracing hot path
Date: Fri, 22 Jan 2010 02:16:15 +0100
Message-Id: <1264122982-1553-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time we enter the function profiler tracing callbacks, we first
check if the function profiling is enabled.

This check is useless because we register the function graph
callbacks only after the hashlist has been initialized.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 94117ec..f258f67 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -381,13 +381,10 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 	struct func_node *rec;
 	unsigned long flags;
 
-	if (!ftrace_profile_enabled)
-		return;
-
 	local_irq_save(flags);
 
 	hlist = &__get_cpu_var(func_hlist_cpu);
-	if (!hlist->hash || !ftrace_profile_enabled)
+	if (!hlist->hash)
 		goto out;
 
 	rec = function_find_hlist_node(hlist, ip);
@@ -418,7 +415,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 
 	local_irq_save(flags);
 	hlist = &__get_cpu_var(func_hlist_cpu);
-	if (!hlist->hash || !ftrace_profile_enabled)
+	if (!hlist->hash)
 		goto out;
 
 	calltime = trace->rettime - trace->calltime;
-- 
1.6.2.3

