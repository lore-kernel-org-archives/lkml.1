Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZLAQn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZLAQn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZLAQn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:43:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:42276 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbZLAQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:43:27 -0500
Date: Tue, 1 Dec 2009 16:42:35 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4B14D278.4090209@cn.fujitsu.com>
References: <4B14D278.4090209@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace_syscalls: Remove unused event_syscall_enter and event_syscall_exit
Message-ID: <tip-bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34@git.kernel.org>
Git-Commit-ID: bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34
Gitweb:     http://git.kernel.org/tip/bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 1 Dec 2009 16:23:20 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 17:33:28 +0100

trace_syscalls: Remove unused event_syscall_enter and event_syscall_exit

fix event_enter_##sname->event
fix event_exit_##sname->event

remove unused event_syscall_enter and event_syscall_exit

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B14D278.4090209@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/syscalls.h      |    4 ++--
 include/trace/syscall.h       |    2 --
 kernel/trace/trace_syscalls.c |    8 --------
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b50974a..2f7c539 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -178,7 +178,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
 		.system                 = "syscalls",			\
-		.event                  = &event_syscall_enter,		\
+		.event                  = &enter_syscall_print_##sname,	\
 		.raw_init		= init_enter_##sname,		\
 		.show_format		= syscall_enter_format,		\
 		.define_fields		= syscall_enter_define_fields,	\
@@ -214,7 +214,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
 		.system                 = "syscalls",			\
-		.event                  = &event_syscall_exit,		\
+		.event                  = &exit_syscall_print_##sname,	\
 		.raw_init		= init_exit_##sname,		\
 		.show_format		= syscall_exit_format,		\
 		.define_fields		= syscall_exit_define_fields,	\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 51ee17d..5f8827c 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -37,8 +37,6 @@ extern unsigned long arch_syscall_addr(int nr);
 extern int syscall_name_to_nr(char *name);
 void set_syscall_enter_id(int num, int id);
 void set_syscall_exit_id(int num, int id);
-extern struct trace_event event_syscall_enter;
-extern struct trace_event event_syscall_exit;
 
 extern int syscall_enter_format(struct ftrace_event_call *call,
 				struct trace_seq *s);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 63aa807..00d6e17 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -444,14 +444,6 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	mutex_unlock(&syscall_trace_lock);
 }
 
-struct trace_event event_syscall_enter = {
-	.trace			= print_syscall_enter,
-};
-
-struct trace_event event_syscall_exit = {
-	.trace			= print_syscall_exit,
-};
-
 int __init init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
