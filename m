Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYLDWuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYLDWuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbYLDWtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:49:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:26517 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbYLDWtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:49:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=aUsV9LSp7liQTDzeAqjjHJF4H1IDLjAvmLQPLuJh2/jMQmewkiCPdGuUTQ1fRJp79g
         zjO2Xj9UAMSKDZOMrQB+fchEsn1axPaHuuiUe06p9MaF88tjOvBCcdCWZspirav6NuLI
         v7mCtgv/++rVc6oDyX4YNpIiCGVyH3Hh+L+fA=
Message-ID: <49385E8B.7070900@gmail.com>
Date: Thu, 04 Dec 2008 23:49:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/ftrace: fix the check of ftrace_trace_task
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix default empty traces on function-graph-tracer

The actual ftrace_trace_task() checks if ftrace_pid_trace is allocated
and return 1 if it is true.
If it is NULL, it will check the bit of pid tracing flag for the current
task (which are not set by default).
So by default, a task is not traced.
Actually all tasks should be traced by default and filter_by_pid when
ftrace_pid_trace is allocated.

The appropriate condition should be to return 1 if filter_by_pid is
set.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a71bbe0..5ac6970 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -551,7 +551,7 @@ extern struct pid *ftrace_pid_trace;
 
 static inline int ftrace_trace_task(struct task_struct *task)
 {
-	if (ftrace_pid_trace)
+	if (!ftrace_pid_trace)
 		return 1;
 
 	return test_tsk_trace_trace(task);
-- 
1.5.6.3

