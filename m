Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbZHXVon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbZHXVon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZHXVnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:43:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbZHXVnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:43:52 -0400
Date: Mon, 24 Aug 2009 17:40:22 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: lethal@linux-sh.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, tglx@linutronix.de,
       hpa@zytor.com
Message-Id: <9b4f1a84ecae57cc6599412772efa36f0d2b815b.1251146513.git.jbaron@redhat.com>
In-Reply-To: <cover.1251146512.git.jbaron@redhat.com>
References: <cover.1251146512.git.jbaron@redhat.com>
Subject: [PATCH 3/4] Convert event tracing code to NR_syscalls
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the syscalls event tracing code to use NR_syscalls, instead of
FTRACE_SYSCALL_MAX. NR_syscalls is standard accross most arches, and
reduces code confustion/complexity.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 arch/x86/kernel/ftrace.c      |    8 ++++----
 kernel/trace/trace_syscalls.c |   24 ++++++++++++------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3cff121..9dbb527 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -494,7 +494,7 @@ static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
 
 struct syscall_metadata *syscall_nr_to_meta(int nr)
 {
-	if (!syscalls_metadata || nr >= FTRACE_SYSCALL_MAX || nr < 0)
+	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
 		return NULL;
 
 	return syscalls_metadata[nr];
@@ -507,7 +507,7 @@ int syscall_name_to_nr(char *name)
 	if (!syscalls_metadata)
 		return -1;
 
-	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
+	for (i = 0; i < NR_syscalls; i++) {
 		if (syscalls_metadata[i]) {
 			if (!strcmp(syscalls_metadata[i]->name, name))
 				return i;
@@ -533,13 +533,13 @@ static int __init arch_init_ftrace_syscalls(void)
 	unsigned long **psys_syscall_table = &sys_call_table;
 
 	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
-					FTRACE_SYSCALL_MAX, GFP_KERNEL);
+					NR_syscalls, GFP_KERNEL);
 	if (!syscalls_metadata) {
 		WARN_ON(1);
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
+	for (i = 0; i < NR_syscalls; i++) {
 		meta = find_syscall_meta(psys_syscall_table[i]);
 		syscalls_metadata[i] = meta;
 	}
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 46c1b97..f23cd7d 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -10,8 +10,8 @@
 static DEFINE_MUTEX(syscall_trace_lock);
 static int sys_refcount_enter;
 static int sys_refcount_exit;
-static DECLARE_BITMAP(enabled_enter_syscalls, FTRACE_SYSCALL_MAX);
-static DECLARE_BITMAP(enabled_exit_syscalls, FTRACE_SYSCALL_MAX);
+static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
 enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags)
@@ -282,7 +282,7 @@ int reg_event_syscall_enter(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
@@ -305,7 +305,7 @@ void unreg_event_syscall_enter(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
@@ -323,7 +323,7 @@ int reg_event_syscall_exit(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
@@ -346,7 +346,7 @@ void unreg_event_syscall_exit(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
@@ -366,8 +366,8 @@ struct trace_event event_syscall_exit = {
 
 #ifdef CONFIG_EVENT_PROFILE
 
-static DECLARE_BITMAP(enabled_prof_enter_syscalls, FTRACE_SYSCALL_MAX);
-static DECLARE_BITMAP(enabled_prof_exit_syscalls, FTRACE_SYSCALL_MAX);
+static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_prof_exit_syscalls, NR_syscalls);
 static int sys_prof_refcount_enter;
 static int sys_prof_refcount_exit;
 
@@ -413,7 +413,7 @@ int reg_prof_syscall_enter(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 
 	mutex_lock(&syscall_trace_lock);
@@ -435,7 +435,7 @@ void unreg_prof_syscall_enter(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 
 	mutex_lock(&syscall_trace_lock);
@@ -474,7 +474,7 @@ int reg_prof_syscall_exit(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 
 	mutex_lock(&syscall_trace_lock);
@@ -496,7 +496,7 @@ void unreg_prof_syscall_exit(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 
 	mutex_lock(&syscall_trace_lock);
-- 
1.6.2.5

