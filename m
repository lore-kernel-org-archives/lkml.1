Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZH0Dex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZH0Dex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZH0Dew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:34:52 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:43918 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZH0Deu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nN2tHEqK/bqeDpUKZ6KNHb8mrH9ep0FBJYpcUxnXOfhxBsfms/EXOKRoJkVAnARMK2
         /LRzjLBddJqrrcX09USBF5umF3GQtIn4G+HhNGbzHLQ9lvzNx0ESWxbI9DlSA+9kXlWb
         HlCrZ8MwvzVZ67D2ipAySp3KaSZVcCZ2bo+0U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 19/18] tracing: Restore the const qualifier for field names and types definition
Date: Thu, 27 Aug 2009 05:34:46 +0200
Message-Id: <1251344087-28719-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore the const qualifier in field's name and type parameters of
trace_define_field that was lost while solving a conflict.

Fields names and types are defined as builtin constant strings in
static TRACE_EVENTs. But kprobes allocates these dynamically.

That said, we still want to always pass these strings as const char *
in trace_define_fields() to avoid any further accidental writes on
the pointed strings.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h  |    6 +++---
 kernel/trace/trace_events.c   |    4 ++--
 kernel/trace/trace_syscalls.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 1ab3089..73edf5a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -148,9 +148,9 @@ enum {
 };
 
 extern int trace_define_common_fields(struct ftrace_event_call *call);
-extern int trace_define_field(struct ftrace_event_call *call, char *type,
-			      char *name, int offset, int size, int is_signed,
-			      int filter_type);
+extern int trace_define_field(struct ftrace_event_call *call, const char *type,
+			      const char *name, int offset, int size,
+			      int is_signed, int filter_type);
 extern int trace_add_event_call(struct ftrace_event_call *call);
 extern void trace_remove_event_call(struct ftrace_event_call *call);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 8079bb5..197cdaa 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -27,8 +27,8 @@ DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
 
-int trace_define_field(struct ftrace_event_call *call, char *type,
-		       char *name, int offset, int size, int is_signed,
+int trace_define_field(struct ftrace_event_call *call, const char *type,
+		       const char *name, int offset, int size, int is_signed,
 		       int filter_type)
 {
 	struct ftrace_event_field *field;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5931933..a928dd0 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -193,8 +193,8 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
 		return ret;
 
 	for (i = 0; i < meta->nb_args; i++) {
-		ret = trace_define_field(call, (char *)meta->types[i],
-					 (char *)meta->args[i], offset,
+		ret = trace_define_field(call, meta->types[i],
+					 meta->args[i], offset,
 					 sizeof(unsigned long), 0,
 					 FILTER_OTHER);
 		offset += sizeof(unsigned long);
-- 
1.6.2.3

