Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZH0Rn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZH0Rn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZH0Rn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:43:57 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51769 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZH0Rnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=b6fWYKpoIhBwoHJSfsOAli7HeUoXIOsfR24X9Rhz++v6FlG0zWO3nDb0sSIMj3bC1z
         FA61NUS7AgthWjbDiSpWi14NIkLNWZq3OTPziwxevd8R12zuFN4AymK1I9cjnHT0lVy7
         BuwzzwDueKWnAXz91gDOevsb/Nntxp2Gr0B1s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Josh Stone <jistone@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anwin" <hpa@zytor.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 6/7] tracing: Convert event tracing code to use NR_syscalls
Date: Thu, 27 Aug 2009 19:43:34 +0200
Message-Id: <1251395015-6329-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
References: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Convert the syscalls event tracing code to use NR_syscalls, instead of
FTRACE_SYSCALL_MAX. NR_syscalls is standard accross most arches, and
reduces code confusion/complexity.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Josh Stone <jistone@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anwin <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <9b4f1a84ecae57cc6599412772efa36f0d2b815b.1251146513.git.jbaron@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
index cb7f600..4f5fae6 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -11,8 +11,8 @@
 static DEFINE_MUTEX(syscall_trace_lock);
 static int sys_refcount_enter;
 static int sys_refcount_exit;
-static DECLARE_BITMAP(enabled_enter_syscalls, FTRACE_SYSCALL_MAX);
-static DECLARE_BITMAP(enabled_exit_syscalls, FTRACE_SYSCALL_MAX);
+static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
 enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags)
@@ -289,7 +289,7 @@ int reg_event_syscall_enter(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
@@ -312,7 +312,7 @@ void unreg_event_syscall_enter(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
@@ -330,7 +330,7 @@ int reg_event_syscall_exit(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
@@ -353,7 +353,7 @@ void unreg_event_syscall_exit(void *ptr)
 
 	name = (char *)ptr;
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
@@ -373,8 +373,8 @@ struct trace_event event_syscall_exit = {
 
 #ifdef CONFIG_EVENT_PROFILE
 
-static DECLARE_BITMAP(enabled_prof_enter_syscalls, FTRACE_SYSCALL_MAX);
-static DECLARE_BITMAP(enabled_prof_exit_syscalls, FTRACE_SYSCALL_MAX);
+static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_prof_exit_syscalls, NR_syscalls);
 static int sys_prof_refcount_enter;
 static int sys_prof_refcount_exit;
 
@@ -420,7 +420,7 @@ int reg_prof_syscall_enter(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 
 	mutex_lock(&syscall_trace_lock);
@@ -442,7 +442,7 @@ void unreg_prof_syscall_enter(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 
 	mutex_lock(&syscall_trace_lock);
@@ -481,7 +481,7 @@ int reg_prof_syscall_exit(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 
 	mutex_lock(&syscall_trace_lock);
@@ -503,7 +503,7 @@ void unreg_prof_syscall_exit(char *name)
 	int num;
 
 	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+	if (num < 0 || num >= NR_syscalls)
 		return;
 
 	mutex_lock(&syscall_trace_lock);
-- 
1.6.2.3

