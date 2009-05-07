Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbZEGQXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbZEGQXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZEGQXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:23:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbZEGQXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:23:05 -0400
Message-Id: <20090507162302.335356407@goodmis.org>
References: <20090507162221.413243886@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 07 May 2009 12:22:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] tracing: append ":*" to internal setting of system events
Content-Disposition: inline; filename=0002-tracing-append-to-internal-setting-of-system-e.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The system enabling of events uses the same code as the set_event file.
It passes in the name of the system to the parser and that will enable
all the events that has that system as a name.

The problem is that it will also enable events with the same name as the
system.

If you have system name foo, and system name bar, but within the system
bar, there exists an event called foo. By setting the system name foo,
you will also be enabling the event foo in the system bar. This is not
an expected result.

The solution is to pass in "foo:*", which will only enable the system
foo and not events called foo.

[ Impact: prevent accidental enabling of events with same name as a system ]

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 87feb01..8d0fae3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -509,9 +509,11 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		return -EINVAL;
 	}
 
-	command = kstrdup(system, GFP_KERNEL);
+	/* +3 for the ":*\0" */
+	command = kmalloc(strlen(system)+3, GFP_KERNEL);
 	if (!command)
 		return -ENOMEM;
+	sprintf(command, "%s:*", system);
 
 	ret = ftrace_set_clr_event(command, val);
 	if (ret)
@@ -1179,7 +1181,7 @@ static __init int event_trace_init(void)
 			  &ftrace_show_header_fops);
 
 	trace_create_file("enable", 0644, d_events,
-			  "*:*", &ftrace_system_enable_fops);
+			  "*", &ftrace_system_enable_fops);
 
 	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
 		/* The linker may leave blanks */
-- 
1.6.2.4

-- 
