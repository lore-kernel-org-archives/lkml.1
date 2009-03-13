Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbZCMQKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbZCMQKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZCMQKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:10:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:41482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbZCMQKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:10:16 -0400
Date: Fri, 13 Mar 2009 16:09:25 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236955332-10133-3-git-send-email-fweisbec@gmail.com>
References: <1236955332-10133-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/syscalls: support for syscalls tracing on x86
Message-ID: <tip-f58ba100678f421bdcb000a3c71793f432dfab93@git.kernel.org>
Git-Commit-ID: f58ba100678f421bdcb000a3c71793f432dfab93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 16:09:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f58ba100678f421bdcb000a3c71793f432dfab93
Gitweb:     http://git.kernel.org/tip/f58ba100678f421bdcb000a3c71793f432dfab93
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 13 Mar 2009 15:42:12 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 16:57:42 +0100

tracing/syscalls: support for syscalls tracing on x86

Extend x86 architecture syscall tracing support with syscall
metadata table details.

(The upcoming core syscall tracing modifications rely on this.)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1236955332-10133-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/ftrace.h |    7 ++++
 arch/x86/kernel/ftrace.c      |   63 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index db24c22..bd2c651 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -28,6 +28,13 @@
 
 #endif
 
+/* FIXME: I don't want to stay hardcoded */
+#ifdef CONFIG_X86_64
+# define FTRACE_SYSCALL_MAX     296
+#else
+# define FTRACE_SYSCALL_MAX     333
+#endif
+
 #ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index a85da17..1d0d7f4 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -453,3 +453,66 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+
+extern unsigned long __start_syscalls_metadata[];
+extern unsigned long __stop_syscalls_metadata[];
+extern unsigned long *sys_call_table;
+
+static struct syscall_metadata **syscalls_metadata;
+
+static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
+{
+	struct syscall_metadata *start;
+	struct syscall_metadata *stop;
+	char str[KSYM_SYMBOL_LEN];
+
+
+	start = (struct syscall_metadata *)__start_syscalls_metadata;
+	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
+	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
+
+	for ( ; start < stop; start++) {
+		if (start->name && !strcmp(start->name, str))
+			return start;
+	}
+	return NULL;
+}
+
+struct syscall_metadata *syscall_nr_to_meta(int nr)
+{
+	if (!syscalls_metadata || nr >= FTRACE_SYSCALL_MAX || nr < 0)
+		return NULL;
+
+	return syscalls_metadata[nr];
+}
+
+void arch_init_ftrace_syscalls(void)
+{
+	int i;
+	struct syscall_metadata *meta;
+	unsigned long **psys_syscall_table = &sys_call_table;
+	static atomic_t refs;
+
+	if (atomic_inc_return(&refs) != 1)
+		goto end;
+
+	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
+					FTRACE_SYSCALL_MAX, GFP_KERNEL);
+	if (!syscalls_metadata) {
+		WARN_ON(1);
+		return;
+	}
+
+	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
+		meta = find_syscall_meta(psys_syscall_table[i]);
+		syscalls_metadata[i] = meta;
+	}
+	return;
+
+	/* Paranoid: avoid overflow */
+end:
+	atomic_dec(&refs);
+}
+#endif
