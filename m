Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZISFja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZISFja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 01:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZISFjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 01:39:24 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:48355 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZISFjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 01:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WjxW2tBWJkAyexhJWu7tT0rdtpCdJEhrSYQykIFi9Ft/aOtfkQDJSFNh6yOeFToorB
         TVkOU1UW3+21vJ1+1eMkKZi2YbmDl+27ipN5FrqyPv0OlO6APFspu1Ymtk97IUXTuU2n
         SsIIMtithwJn34JLc1ty92vjJum/0ep/jU8uo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/2] tracing: Move syscalls metadata handling from arch to core
Date: Sat, 19 Sep 2009 07:39:16 +0200
Message-Id: <1253338757-5918-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253338757-5918-1-git-send-email-fweisbec@gmail.com>
References: <1253338757-5918-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the syscalls metadata processing is done from arch.
But these operations are mostly generic accross archs. Especially now
that we have a common variable name that expresses the number of
syscalls supported by an arch: NR_syscalls, the only remaining bits
that need to reside in arch is the syscall nr to addr translation.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/s390/kernel/ftrace.c     |   67 +---------------------------------
 arch/x86/kernel/ftrace.c      |   76 +-------------------------------------
 include/trace/syscall.h       |    2 +-
 kernel/trace/trace_syscalls.c |   80 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 85 insertions(+), 140 deletions(-)

diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 57bdcb1..7c5752c 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -206,73 +206,10 @@ out:
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 
-extern unsigned long __start_syscalls_metadata[];
-extern unsigned long __stop_syscalls_metadata[];
 extern unsigned int sys_call_table[];
 
-static struct syscall_metadata **syscalls_metadata;
-
-struct syscall_metadata *syscall_nr_to_meta(int nr)
-{
-	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
-		return NULL;
-
-	return syscalls_metadata[nr];
-}
-
-int syscall_name_to_nr(char *name)
-{
-	int i;
-
-	if (!syscalls_metadata)
-		return -1;
-	for (i = 0; i < NR_syscalls; i++)
-		if (syscalls_metadata[i])
-			if (!strcmp(syscalls_metadata[i]->name, name))
-				return i;
-	return -1;
-}
-
-void set_syscall_enter_id(int num, int id)
-{
-	syscalls_metadata[num]->enter_id = id;
-}
-
-void set_syscall_exit_id(int num, int id)
+unsigned long __init arch_syscall_addr(int nr)
 {
-	syscalls_metadata[num]->exit_id = id;
-}
-
-static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
-{
-	struct syscall_metadata *start;
-	struct syscall_metadata *stop;
-	char str[KSYM_SYMBOL_LEN];
-
-	start = (struct syscall_metadata *)__start_syscalls_metadata;
-	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
-	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
-
-	for ( ; start < stop; start++) {
-		if (start->name && !strcmp(start->name + 3, str + 3))
-			return start;
-	}
-	return NULL;
-}
-
-static int __init arch_init_ftrace_syscalls(void)
-{
-	struct syscall_metadata *meta;
-	int i;
-	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) * NR_syscalls,
-				    GFP_KERNEL);
-	if (!syscalls_metadata)
-		return -ENOMEM;
-	for (i = 0; i < NR_syscalls; i++) {
-		meta = find_syscall_meta((unsigned long)sys_call_table[i]);
-		syscalls_metadata[i] = meta;
-	}
-	return 0;
+	return (unsigned long)sys_call_table[nr];
 }
-arch_initcall(arch_init_ftrace_syscalls);
 #endif
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 9dbb527..4adb867 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -468,82 +468,10 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 
-extern unsigned long __start_syscalls_metadata[];
-extern unsigned long __stop_syscalls_metadata[];
 extern unsigned long *sys_call_table;
 
-static struct syscall_metadata **syscalls_metadata;
-
-static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
-{
-	struct syscall_metadata *start;
-	struct syscall_metadata *stop;
-	char str[KSYM_SYMBOL_LEN];
-
-
-	start = (struct syscall_metadata *)__start_syscalls_metadata;
-	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
-	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
-
-	for ( ; start < stop; start++) {
-		if (start->name && !strcmp(start->name, str))
-			return start;
-	}
-	return NULL;
-}
-
-struct syscall_metadata *syscall_nr_to_meta(int nr)
-{
-	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
-		return NULL;
-
-	return syscalls_metadata[nr];
-}
-
-int syscall_name_to_nr(char *name)
-{
-	int i;
-
-	if (!syscalls_metadata)
-		return -1;
-
-	for (i = 0; i < NR_syscalls; i++) {
-		if (syscalls_metadata[i]) {
-			if (!strcmp(syscalls_metadata[i]->name, name))
-				return i;
-		}
-	}
-	return -1;
-}
-
-void set_syscall_enter_id(int num, int id)
-{
-	syscalls_metadata[num]->enter_id = id;
-}
-
-void set_syscall_exit_id(int num, int id)
+unsigned long __init arch_syscall_addr(int nr)
 {
-	syscalls_metadata[num]->exit_id = id;
-}
-
-static int __init arch_init_ftrace_syscalls(void)
-{
-	int i;
-	struct syscall_metadata *meta;
-	unsigned long **psys_syscall_table = &sys_call_table;
-
-	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
-					NR_syscalls, GFP_KERNEL);
-	if (!syscalls_metadata) {
-		WARN_ON(1);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < NR_syscalls; i++) {
-		meta = find_syscall_meta(psys_syscall_table[i]);
-		syscalls_metadata[i] = meta;
-	}
-	return 0;
+	return (unsigned long)(&sys_call_table)[nr];
 }
-arch_initcall(arch_init_ftrace_syscalls);
 #endif
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 5dc283b..e972f0a 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -33,7 +33,7 @@ struct syscall_metadata {
 };
 
 #ifdef CONFIG_FTRACE_SYSCALLS
-extern struct syscall_metadata *syscall_nr_to_meta(int nr);
+extern unsigned long arch_syscall_addr(int nr);
 extern int syscall_name_to_nr(char *name);
 void set_syscall_enter_id(int num, int id);
 void set_syscall_exit_id(int num, int id);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8712ce3..e281fd7 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -14,6 +14,63 @@ static int sys_refcount_exit;
 static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
 static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
+extern unsigned long __start_syscalls_metadata[];
+extern unsigned long __stop_syscalls_metadata[];
+
+static struct syscall_metadata **syscalls_metadata;
+
+static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
+{
+	struct syscall_metadata *start;
+	struct syscall_metadata *stop;
+	char str[KSYM_SYMBOL_LEN];
+
+
+	start = (struct syscall_metadata *)__start_syscalls_metadata;
+	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
+	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
+
+	for ( ; start < stop; start++) {
+		if (start->name && !strcmp(start->name, str))
+			return start;
+	}
+	return NULL;
+}
+
+static struct syscall_metadata *syscall_nr_to_meta(int nr)
+{
+	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
+		return NULL;
+
+	return syscalls_metadata[nr];
+}
+
+int syscall_name_to_nr(char *name)
+{
+	int i;
+
+	if (!syscalls_metadata)
+		return -1;
+
+	for (i = 0; i < NR_syscalls; i++) {
+		if (syscalls_metadata[i]) {
+			if (!strcmp(syscalls_metadata[i]->name, name))
+				return i;
+		}
+	}
+	return -1;
+}
+
+void set_syscall_enter_id(int num, int id)
+{
+	syscalls_metadata[num]->enter_id = id;
+}
+
+void set_syscall_exit_id(int num, int id)
+{
+	syscalls_metadata[num]->exit_id = id;
+}
+
 enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags)
 {
@@ -375,6 +432,29 @@ struct trace_event event_syscall_exit = {
 	.trace			= print_syscall_exit,
 };
 
+int __init init_ftrace_syscalls(void)
+{
+	struct syscall_metadata *meta;
+	unsigned long addr;
+	int i;
+
+	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
+					NR_syscalls, GFP_KERNEL);
+	if (!syscalls_metadata) {
+		WARN_ON(1);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < NR_syscalls; i++) {
+		addr = arch_syscall_addr(i);
+		meta = find_syscall_meta(addr);
+		syscalls_metadata[i] = meta;
+	}
+
+	return 0;
+}
+core_initcall(init_ftrace_syscalls);
+
 #ifdef CONFIG_EVENT_PROFILE
 
 static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
-- 
1.6.2.3

