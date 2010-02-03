Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab0BCJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:16:56 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38151 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab0BCJOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hjVuNs0PU+IF0cayAzYx0XzYZQ2OzIf+NV8GB+vq5NDq1wIcARvCRE416wrihhDMRn
         UZjXStS2MMQdoVuQKqhFlvfpth2Itza6WJyLW8ZmNAseGXhfCyX/HONWFvz+Lrjl7zkY
         pOUTHWE2Paw1uhU4CDuNRIdXxpuOlCnzGMFp8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 05/11] perf: New PERF_EVENT_IOC_INJECT ioctl
Date: Wed,  3 Feb 2010 10:14:29 +0100
Message-Id: <1265188475-23509-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PERF_EVENT_IOC_INJECT perf event ioctl can be used to inject
events, if the corresponding pmu and event supports it.

On trace events, it will call the inject callback, usually reserved
for events that need to catch up with the user.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/perf_event.h |    2 ++
 kernel/perf_event.c        |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 556b0f4..d2e83f0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -228,6 +228,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
+#define PERF_EVENT_IOC_INJECT		_IO ('$', 7)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -513,6 +514,7 @@ struct pmu {
 	void (*disable)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
+	void (*inject)			(struct perf_event *event);
 };
 
 /**
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 40f8b07..e4dfd12 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2151,6 +2151,26 @@ unlock:
 	return ret;
 }
 
+static void __perf_event_inject(void *info)
+{
+	struct perf_event *event = info;
+
+	event->pmu->inject(event);
+}
+
+static int perf_event_inject(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+	struct task_struct *task = ctx->task;
+
+	if (!event->pmu->inject || task)
+		return -EINVAL;
+
+	smp_call_function_single(event->cpu, __perf_event_inject, event, 1);
+
+	return 0;
+}
+
 static int perf_event_set_output(struct perf_event *event, int output_fd);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
 
@@ -2183,6 +2203,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_INJECT:
+		return perf_event_inject(event);
+
 	default:
 		return -ENOTTY;
 	}
-- 
1.6.2.3

