Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZESBy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZESBy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 21:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZESByu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 21:54:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49154 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZESByt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 21:54:49 -0400
Message-ID: <4A1210B6.80605@cn.fujitsu.com>
Date: Tue, 19 May 2009 09:51:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jiri Slaby <jirislaby@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use strlcpy instead of strncpy
References: <4A11480F.3030000@cn.fujitsu.com> <4A11CB5C.8070800@gmail.com>
In-Reply-To: <4A11CB5C.8070800@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strlcpy() will add '\0' for the copied string.

[Impact] cleanup

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 05b4747..9359e85 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -434,8 +434,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (!buts->buf_size || !buts->buf_nr)
 		return -EINVAL;
 
-	strncpy(buts->name, name, BLKTRACE_BDEV_SIZE);
-	buts->name[BLKTRACE_BDEV_SIZE - 1] = '\0';
+	strlcpy(buts->name, name, BLKTRACE_BDEV_SIZE);
 
 	/*
 	 * some device names have larger paths - convert the slashes
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 665a915..2484555 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -133,7 +133,7 @@ static char *default_bootup_tracer;
 
 static int __init set_ftrace(char *str)
 {
-	strncpy(bootup_tracer_buf, str, BOOTUP_TRACER_SIZE);
+	strlcpy(bootup_tracer_buf, str, BOOTUP_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
 	ring_buffer_expanded = 1;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6e735d4..e08c952 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -155,8 +155,8 @@ struct trace_boot_ret {
 struct trace_branch {
 	struct trace_entry	ent;
 	unsigned	        line;
-	char			func[TRACE_FUNC_SIZE+1];
-	char			file[TRACE_FILE_SIZE+1];
+	char			func[TRACE_FUNC_SIZE];
+	char			file[TRACE_FILE_SIZE];
 	char			correct;
 };
 
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 7a7a9fd..a84e036 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -67,10 +67,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 		p--;
 	p++;
 
-	strncpy(entry->func, f->func, TRACE_FUNC_SIZE);
-	strncpy(entry->file, p, TRACE_FILE_SIZE);
-	entry->func[TRACE_FUNC_SIZE] = 0;
-	entry->file[TRACE_FILE_SIZE] = 0;
+	strlcpy(entry->func, f->func, TRACE_FUNC_SIZE);
+	strlcpy(entry->file, p, TRACE_FILE_SIZE);
 	entry->line = f->line;
 	entry->correct = val == expect;
 
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 5e32e37..2ae6679 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -122,10 +122,10 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned int, line, line)
-		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func,
-				    TRACE_FUNC_SIZE+1, func)
-		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file,
-				    TRACE_FUNC_SIZE+1, file)
+		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE], func,
+				    TRACE_FUNC_SIZE, func)
+		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE], file,
+				    TRACE_FUNC_SIZE, file)
 		TRACE_FIELD(char, correct, correct)
 	),
 	TP_RAW_FMT("%u:%s:%s (%u)")

