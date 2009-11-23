Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZKWJIc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 23 Nov 2009 04:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbZKWJI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:08:29 -0500
Received: from gw.wifiinternet.cz ([89.31.42.6]:49967 "EHLO monstr.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755378AbZKWJI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:08:26 -0500
X-Greylist: delayed 1579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 04:08:12 EST
From: y@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: michal.simek@petalogix.com, wuzhangjin@gmail.com, mingo@elte.hu,
        rostedt@goodmis.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 5/5] microblaze: ftrace: Add dynamic function graph tracer
Date: Mon, 23 Nov 2009 09:41:23 +0100
Message-Id: <1258965683-21302-6-git-send-email-y>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1258965683-21302-5-git-send-email-y>
References: <y>
 <1258965683-21302-1-git-send-email-y>
 <1258965683-21302-2-git-send-email-y>
 <1258965683-21302-3-git-send-email-y>
 <1258965683-21302-4-git-send-email-y>
 <1258965683-21302-5-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

This patch add support for dynamic function graph tracer.

There is one my expactation that I can do flush_icache after
all code modification. On microblaze is this safer than do
flush for every entry. For icache is used name flush but
correct should be invalidation - this will be fix in upcomming
new cache implementaion and WB support.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/ftrace.c |   28 ++++++++++++++++++++++++++++
 arch/microblaze/kernel/mcount.S |    6 ++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
index 0952a8b..388b31c 100644
--- a/arch/microblaze/kernel/ftrace.c
+++ b/arch/microblaze/kernel/ftrace.c
@@ -206,4 +206,32 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+unsigned int old_jump; /* saving place for jump instruction */
+
+int ftrace_enable_ftrace_graph_caller(void)
+{
+	unsigned int ret;
+	unsigned long ip = (unsigned long)(&ftrace_call_graph);
+
+	old_jump = *(unsigned int *)ip; /* save jump over instruction */
+	ret = ftrace_modify_code(ip, MICROBLAZE_NOP);
+	flush_icache();
+
+	pr_debug("%s: Replace instruction: 0x%x\n", __func__, old_jump);
+	return ret;
+}
+
+int ftrace_disable_ftrace_graph_caller(void)
+{
+	unsigned int ret;
+	unsigned long ip = (unsigned long)(&ftrace_call_graph);
+
+	ret = ftrace_modify_code(ip, old_jump);
+	flush_icache();
+
+	pr_debug("%s\n", __func__);
+	return ret;
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/microblaze/kernel/mcount.S b/arch/microblaze/kernel/mcount.S
index 84a1945..e7eaa7a 100644
--- a/arch/microblaze/kernel/mcount.S
+++ b/arch/microblaze/kernel/mcount.S
@@ -97,6 +97,7 @@ ENTRY(ftrace_caller)
 	nop;
 	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST end of checking */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
+#ifndef CONFIG_DYNAMIC_FTRACE
 	lwi	r5, r0, ftrace_graph_return;
 	addik	r6, r0, ftrace_stub; /* asm implementation */
 	cmpu	r5, r5, r6; /* ftrace_graph_return != ftrace_stub */
@@ -108,6 +109,11 @@ ENTRY(ftrace_caller)
 	cmpu	r5, r5, r6; /* ftrace_graph_entry != ftrace_graph_entry_stub */
 	beqid	r5, end_graph_tracer;
 	nop;
+#else /* CONFIG_DYNAMIC_FTRACE */
+NOALIGN_ENTRY(ftrace_call_graph)
+	/* MS: jump over graph function - replaced from C code */
+	bri	end_graph_tracer
+#endif /* CONFIG_DYNAMIC_FTRACE */
 	addik	r5, r1, 120; /* MS: load parent addr */
 	addik	r6, r15, 0; /* MS: load current function addr */
 	bralid	r15, prepare_ftrace_return;
-- 
1.5.5.1

