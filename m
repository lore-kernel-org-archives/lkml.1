Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbZBTBQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbZBTBQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbZBTBP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:15:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62321 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbZBTBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:15:22 -0500
Message-Id: <20090220011520.772293307@goodmis.org>
References: <20090220011316.379904625@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Feb 2009 20:13:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/6] ftrace: allow archs to preform pre and post process for code modification
Content-Disposition: inline; filename=0003-ftrace-allow-archs-to-preform-pre-and-post-process.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch creates the weak functions: ftrace_arch_modify_prepare
and ftrace_arch_modify_post_process that are called before and
after the stop machine is called to modify the kernel text.

If the arch needs to do pre or post processing, it only needs to define
these functions.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    3 +++
 kernel/trace/ftrace.c  |   28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9d224c4..644b9a9 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -106,6 +106,9 @@ struct ftrace_func_command {
 /* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
 #include <asm/ftrace.h>
 
+int ftrace_arch_modify_prepare(void);
+int ftrace_arch_modify_post_process(void);
+
 struct seq_file;
 
 struct ftrace_probe_ops {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 330a059..de3bd93 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -580,6 +580,24 @@ ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
 	return 1;
 }
 
+/*
+ * archs can override this function if they must do something
+ * before the modifying code is performed.
+ */
+int __weak ftrace_arch_modify_prepare(void)
+{
+	return 0;
+}
+
+/*
+ * archs can override this function if they must do something
+ * after the modifying code is performed.
+ */
+int __weak ftrace_arch_modify_post_process(void)
+{
+	return 0;
+}
+
 static int __ftrace_modify_code(void *data)
 {
 	int *command = data;
@@ -602,7 +620,17 @@ static int __ftrace_modify_code(void *data)
 
 static void ftrace_run_update_code(int command)
 {
+	int ret;
+
+	ret = ftrace_arch_modify_prepare();
+	FTRACE_WARN_ON(ret);
+	if (ret)
+		return;
+
 	stop_machine(__ftrace_modify_code, &command, NULL);
+
+	ret = ftrace_arch_modify_post_process();
+	FTRACE_WARN_ON(ret);
 }
 
 static ftrace_func_t saved_ftrace_func;
-- 
1.5.6.5

-- 
