Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbZLHJQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbZLHJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZLHJQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:16:57 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:60959 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZLHJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:16:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w6Gtl28sI6SRCWYM6Yut2Dmz5fL11ie2S8NaXQK75+lSrEa/XfKiiGfKW+vw7XkJgU
         1WL0nhBwVpaLnWPxnkw6E984VfDnQZH1z/6NzNuqoFcZKjME/WQMqtxILpgUCSLlkNUP
         /go+iHkdLwJkTIJUPcJuPg/H3QbX6NgBQc0/8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] tracing/kprobes: Fix field creation's bad error handling
Date: Tue,  8 Dec 2009 10:16:54 +0100
Message-Id: <1260263815-5167-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/fixes branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/fixes

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      tracing/kprobes: Fix field creation's bad error handling


 kernel/trace/trace_kprobe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

---
>From 12e22dfaaee46f70762beb1982a7b86a68317b11 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 8 Dec 2009 10:00:04 +0100
Subject: [PATCH] tracing/kprobes: Fix field creation's bad error handling
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>

When we define the common event fields in kprobe, we invert the error
handling and return immediately in case of success. Then we omit
to define specific kprobes fields (ip and nargs), and specific
kretprobes fields (func, ret_ip, nargs). And we only define them
when we fail to create common fields.

The most visible consequence is that we can't create filter for
k(ret)probes specific fields.

This patch re-invert the success/error handling to fix it.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_kprobe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index aff5f80..ca04523 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1114,7 +1114,7 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
 	ret = trace_define_common_fields(event_call);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
@@ -1132,7 +1132,7 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
 	ret = trace_define_common_fields(event_call);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
-- 
1.6.2.3


