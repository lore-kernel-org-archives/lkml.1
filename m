Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbYJaMfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbYJaMfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 08:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYJaMev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 08:34:51 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:61283 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYJaMeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 08:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=H9mTEE9RfpdXdYdt00DOHxE4NFx+T9KS3Rr6I1JDW9cQ8hHjwz9of1o52xGPxmHux1
         gbFRojbrNg1x8jHCgSRjSDuHyTW2vBCm6UhTGGGBVhPY3UiYTEWJLizMYi7wxok/R9ZF
         9Y8fe7MPDP1+0FQqp5wOqk27XonHTQmMMpEFM=
Message-ID: <490AFB65.40102@gmail.com>
Date: Fri, 31 Oct 2008 13:34:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][RESEND] tracing/ftrace: Fix a bug when switch current tracer
 to sched tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(depends on tracing/ftrace: Types and naming corrections for sched tracer)
---

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
