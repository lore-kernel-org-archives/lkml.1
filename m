Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbYKYWfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbYKYWfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 17:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYKYWfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 17:35:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56882 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbYKYWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 17:34:59 -0500
Message-Id: <20081125223457.162461633@goodmis.org>
References: <20081125223421.795046329@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 25 Nov 2008 17:34:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: use code patching for ftrace return tracer
Content-Disposition: inline; filename=0002-ftrace-use-code-patching-for-ftrace-return-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: more efficient code for ftrace return tracer

This patch uses the dynamic patching, when available, to patch
the function return code into the kernel.

This patch will ease the way for letting both function tracing
and function return tracing run together.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/entry_32.S |    5 ++++
 arch/x86/kernel/ftrace.c   |   46 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/ftrace.h     |    5 ++++
 kernel/trace/ftrace.c      |   34 ++++++++++++++------------------
 4 files changed, 70 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 7a934c0..d6f0333 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1185,6 +1185,11 @@ ftrace_call:
 	popl %edx
 	popl %ecx
 	popl %eax
+#ifdef CONFIG_FUNCTION_RET_TRACER
+.globl ftrace_return_call
+ftrace_return_call:
+	jmp ftrace_stub
+#endif
 
 .globl ftrace_stub
 ftrace_stub:
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index bb137f7..81f8581 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -111,7 +111,6 @@ static void ftrace_mod_code(void)
 	 */
 	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
 					     MCOUNT_INSN_SIZE);
-
 }
 
 void ftrace_nmi_enter(void)
@@ -258,6 +257,51 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
 
+#ifdef CONFIG_FUNCTION_RET_TRACER
+extern void ftrace_return_call(void);
+
+static int ftrace_mod_jmp(unsigned long ip,
+			  int old_offset, int new_offset)
+{
+	unsigned char code[MCOUNT_INSN_SIZE];
+
+	if (probe_kernel_read(code, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	if (code[0] != 0xe9 || old_offset != *(int *)(&code[1]))
+		return -EINVAL;
+
+	*(int *)(&code[1]) = new_offset;
+
+	if (do_ftrace_mod_code(ip, &code))
+		return -EPERM;
+
+	return 0;
+}
+
+int ftrace_enable_ftrace_return_caller(void)
+{
+	unsigned long ip = (unsigned long)(&ftrace_return_call);
+	int old_offset, new_offset;
+
+	old_offset = (unsigned long)(&ftrace_stub) - (ip + MCOUNT_INSN_SIZE);
+	new_offset = (unsigned long)(&ftrace_return_caller) - (ip + MCOUNT_INSN_SIZE);
+
+	return ftrace_mod_jmp(ip, old_offset, new_offset);
+}
+
+int ftrace_disable_ftrace_return_caller(void)
+{
+	unsigned long ip = (unsigned long)(&ftrace_return_call);
+	int old_offset, new_offset;
+
+	old_offset = (unsigned long)(&ftrace_return_caller) - (ip + MCOUNT_INSN_SIZE);
+	new_offset = (unsigned long)(&ftrace_stub) - (ip + MCOUNT_INSN_SIZE);
+
+	return ftrace_mod_jmp(ip, old_offset, new_offset);
+}
+#endif /* CONFIG_FUNCTION_RET_TRACER */
+
 int __init ftrace_dyn_arch_init(void *data)
 {
 	extern const unsigned char ftrace_test_p6nop[];
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 7854d87..73147eb 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -117,6 +117,11 @@ extern void ftrace_call(void);
 extern void mcount_call(void);
 #ifdef CONFIG_FUNCTION_RET_TRACER
 extern void ftrace_return_caller(void);
+extern int ftrace_enable_ftrace_return_caller(void);
+extern int ftrace_disable_ftrace_return_caller(void);
+#else
+static inline int ftrace_enable_ftrace_return_caller(void) { }
+static inline int ftrace_disable_ftrace_return_caller(void) { }
 #endif
 
 /**
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e8cf629..03223b5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -281,6 +281,8 @@ enum {
 	FTRACE_UPDATE_TRACE_FUNC	= (1 << 2),
 	FTRACE_ENABLE_MCOUNT		= (1 << 3),
 	FTRACE_DISABLE_MCOUNT		= (1 << 4),
+	FTRACE_START_FUNC_RET		= (1 << 5),
+	FTRACE_STOP_FUNC_RET		= (1 << 6),
 };
 
 static int ftrace_filtered;
@@ -465,14 +467,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	unsigned long ip, fl;
 	unsigned long ftrace_addr;
 
-#ifdef CONFIG_FUNCTION_RET_TRACER
-	if (ftrace_tracing_type == FTRACE_TYPE_ENTER)
-		ftrace_addr = (unsigned long)ftrace_caller;
-	else
-		ftrace_addr = (unsigned long)ftrace_return_caller;
-#else
 	ftrace_addr = (unsigned long)ftrace_caller;
-#endif
 
 	ip = rec->ip;
 
@@ -605,6 +600,11 @@ static int __ftrace_modify_code(void *data)
 	if (*command & FTRACE_UPDATE_TRACE_FUNC)
 		ftrace_update_ftrace_func(ftrace_trace_function);
 
+	if (*command & FTRACE_START_FUNC_RET)
+		ftrace_enable_ftrace_return_caller();
+	else if (*command & FTRACE_STOP_FUNC_RET)
+		ftrace_disable_ftrace_return_caller();
+
 	return 0;
 }
 
@@ -629,10 +629,8 @@ static void ftrace_startup_enable(int command)
 	ftrace_run_update_code(command);
 }
 
-static void ftrace_startup(void)
+static void ftrace_startup(int command)
 {
-	int command = 0;
-
 	if (unlikely(ftrace_disabled))
 		return;
 
@@ -645,10 +643,8 @@ static void ftrace_startup(void)
 	mutex_unlock(&ftrace_start_lock);
 }
 
-static void ftrace_shutdown(void)
+static void ftrace_shutdown(int command)
 {
-	int command = 0;
-
 	if (unlikely(ftrace_disabled))
 		return;
 
@@ -1453,8 +1449,8 @@ device_initcall(ftrace_nodyn_init);
 
 static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
-# define ftrace_startup()		do { } while (0)
-# define ftrace_shutdown()		do { } while (0)
+static inline void ftrace_startup(int command) { }
+static inline void ftrace_shutdown(int command) { }
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
 #endif /* CONFIG_DYNAMIC_FTRACE */
@@ -1585,7 +1581,7 @@ int register_ftrace_function(struct ftrace_ops *ops)
 	}
 
 	ret = __register_ftrace_function(ops);
-	ftrace_startup();
+	ftrace_startup(0);
 
 out:
 	mutex_unlock(&ftrace_sysctl_lock);
@@ -1604,7 +1600,7 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 
 	mutex_lock(&ftrace_sysctl_lock);
 	ret = __unregister_ftrace_function(ops);
-	ftrace_shutdown();
+	ftrace_shutdown(0);
 	mutex_unlock(&ftrace_sysctl_lock);
 
 	return ret;
@@ -1747,8 +1743,8 @@ int register_ftrace_return(trace_function_return_t func)
 		goto out;
 	}
 	ftrace_tracing_type = FTRACE_TYPE_RETURN;
+	ftrace_startup(FTRACE_START_FUNC_RET);
 	ftrace_function_return = func;
-	ftrace_startup();
 
 out:
 	mutex_unlock(&ftrace_sysctl_lock);
@@ -1761,7 +1757,7 @@ void unregister_ftrace_return(void)
 
 	atomic_dec(&ftrace_retfunc_active);
 	ftrace_function_return = (trace_function_return_t)ftrace_stub;
-	ftrace_shutdown();
+	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
 	/* Restore normal tracing type */
 	ftrace_tracing_type = FTRACE_TYPE_ENTER;
 
-- 
1.5.6.5

-- 
