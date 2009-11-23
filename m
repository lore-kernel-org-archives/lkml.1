Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZKWJJj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 23 Nov 2009 04:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZKWJIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:08:31 -0500
Received: from gw.wifiinternet.cz ([89.31.42.6]:49967 "EHLO monstr.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754721AbZKWJI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:08:28 -0500
X-Greylist: delayed 1579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 04:08:12 EST
From: y@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: michal.simek@petalogix.com, wuzhangjin@gmail.com, mingo@elte.hu,
        rostedt@goodmis.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 4/5] microblaze: ftrace: add function graph support
Date: Mon, 23 Nov 2009 09:41:22 +0100
Message-Id: <1258965683-21302-5-git-send-email-y>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1258965683-21302-4-git-send-email-y>
References: <y>
 <1258965683-21302-1-git-send-email-y>
 <1258965683-21302-2-git-send-email-y>
 <1258965683-21302-3-git-send-email-y>
 <1258965683-21302-4-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

For more information look at Documentation/trace folder.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig         |    1 +
 arch/microblaze/kernel/ftrace.c |   58 +++++++++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/mcount.S |   41 +++++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 102d73a..e297802 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -8,6 +8,7 @@ config MICROBLAZE
 	select HAVE_LMB
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select USB_ARCH_HAS_EHCI
diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
index c1889b1..0952a8b 100644
--- a/arch/microblaze/kernel/ftrace.c
+++ b/arch/microblaze/kernel/ftrace.c
@@ -14,6 +14,64 @@
 #include <asm/cacheflush.h>
 #include <linux/ftrace.h>
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+/*
+ * Hook the return address and push it in the stack of return addrs
+ * in current thread info.
+ */
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
+{
+	unsigned long old;
+	int faulted, err;
+	struct ftrace_graph_ent trace;
+	unsigned long return_hooker = (unsigned long)
+				&return_to_handler;
+
+	if (unlikely(atomic_read(&current->tracing_graph_pause)))
+		return;
+
+	/*
+	 * Protect against fault, even if it shouldn't
+	 * happen. This tool is too much intrusive to
+	 * ignore such a protection.
+	 */
+	asm volatile("	1:	lwi	%0, %2, 0;		\
+			2:	swi	%3, %2, 0;		\
+				addik	%1, r0, 0;		\
+			3:					\
+				.section .fixup, \"ax\";	\
+			4:	brid	3b;			\
+				addik	%1, r0, 1;		\
+				.previous;			\
+				.section __ex_table,\"a\";	\
+				.word	1b,4b;			\
+				.word	2b,4b;			\
+				.previous;"			\
+			: "=&r" (old), "=r" (faulted)
+			: "r" (parent), "r" (return_hooker)
+	);
+
+	if (unlikely(faulted)) {
+		ftrace_graph_stop();
+		WARN_ON(1);
+		return;
+	}
+
+	err = ftrace_push_return_trace(old, self_addr, &trace.depth, 0);
+	if (err == -EBUSY) {
+		*parent = old;
+		return;
+	}
+
+	trace.func = self_addr;
+	/* Only trace if the calling function expects to */
+	if (!ftrace_graph_entry(&trace)) {
+		current->curr_ret_stack--;
+		*parent = old;
+	}
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* save value to addr - it is save to do it in asm */
 static int ftrace_modify_code(unsigned long addr, unsigned int value)
diff --git a/arch/microblaze/kernel/mcount.S b/arch/microblaze/kernel/mcount.S
index 30aaf8f..84a1945 100644
--- a/arch/microblaze/kernel/mcount.S
+++ b/arch/microblaze/kernel/mcount.S
@@ -96,6 +96,27 @@ ENTRY(ftrace_caller)
 	bneid	r5, end;
 	nop;
 	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST end of checking */
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	lwi	r5, r0, ftrace_graph_return;
+	addik	r6, r0, ftrace_stub; /* asm implementation */
+	cmpu	r5, r5, r6; /* ftrace_graph_return != ftrace_stub */
+	beqid	r5, end_graph_tracer;
+	nop;
+
+	lwi	r6, r0, ftrace_graph_entry;
+	addik	r5, r0, ftrace_graph_entry_stub; /* implemented in C */
+	cmpu	r5, r5, r6; /* ftrace_graph_entry != ftrace_graph_entry_stub */
+	beqid	r5, end_graph_tracer;
+	nop;
+	addik	r5, r1, 120; /* MS: load parent addr */
+	addik	r6, r15, 0; /* MS: load current function addr */
+	bralid	r15, prepare_ftrace_return;
+	nop;
+	/* MS: graph was taken that's why - can jump over function trace */
+	brid	end;
+	nop;
+end_graph_tracer:
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 #ifndef CONFIG_DYNAMIC_FTRACE
 	/* MS: test function trace if is taken or not */
 	lwi	r20, r0, ftrace_trace_function;
@@ -121,3 +142,23 @@ end:
 
 	rtsd	r15, 8; /* MS: jump back */
 	nop;
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ENTRY(return_to_handler)
+	nop; /* MS: just barrier for rtsd r15, 8 */
+	nop;
+	SAVE_REGS
+	swi	r15, r1, 0;
+
+	/* MS: find out returning address */
+	bralid	r15, ftrace_return_to_handler;
+	nop;
+
+	/* MS: return value from ftrace_return_to_handler is my returning addr
+	 * must be before restore regs because I have to restore r3 content */
+	addik	r15, r3, 0;
+	RESTORE_REGS
+
+	rtsd	r15, 8; /* MS: jump back */
+	nop;
+#endif	/* CONFIG_FUNCTION_TRACER */
-- 
1.5.5.1

