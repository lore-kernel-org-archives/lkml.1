Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbYJKUOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbYJKUOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYJKUOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:14:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:8778 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbYJKUOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=E/8YC7bImmbHL/FK6jIRjI1ZZRTQ1I/3A+UyCltFK2ZJE5g5JKb7XmW+6OyaIWR+Fo
         c5O2bQc7YMfkG2QNJHQUob5N2x327EyYnYbQRN94k/JaqE4xj4wYpOGohMt2v6aNZyLH
         QcfSp3sLendFleEvftCLGtvRUcVMr4T5mntXs=
Message-ID: <48F10930.1080906@gmail.com>
Date: Sat, 11 Oct 2008 22:14:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] tracing/ftrace: Fix a bug when switch current tracer
 to sched tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug that made the sched_switch tracer unable to run
if set as the current_tracer after the boot tracer.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_boot.c         |    4 ++--
 kernel/trace/trace_sched_switch.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 6bbc879..bd5046c 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -37,9 +37,9 @@ void disable_boot_trace(void)
 		tracing_stop_cmdline_record();
 }
 
-void reset_boot_trace(struct trace_array *tr)
+static void reset_boot_trace(struct trace_array *tr)
 {
-	disable_boot_trace();
+	sched_switch_trace.reset(tr);
 }
 
 static void boot_trace_init(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 969953b..888944d 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -173,7 +173,7 @@ static void sched_switch_trace_init(struct trace_array *tr)
 
 static void sched_switch_trace_reset(struct trace_array *tr)
 {
-	if (tr->ctrl)
+	if (tr->ctrl && sched_ref)
 		stop_sched_trace(tr);
 }
 
