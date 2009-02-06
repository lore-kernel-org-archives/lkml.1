Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbZBFP22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbZBFP22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZBFP1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:27:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59045 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZBFP1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:27:22 -0500
Message-Id: <20090206152720.906225736@goodmis.org>
References: <20090206152151.962749733@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 10:21:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 3/7] ftrace, x86: rename in_nmi variable
Content-Disposition: inline; filename=0003-ftrace-x86-rename-in_nmi-variable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

The in_nmi variable in x86 arch ftrace.c is a misnomer.
Andrew Morton pointed out that the in_nmi variable is incremented
by all CPUS. It can be set when another CPU is running an NMI.

Since this is actually intentional, the fix is to rename it to
what it really is: "nmi_running"

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 4c68358..e3fad2e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -82,7 +82,7 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
  * are the same as what exists.
  */
 
-static atomic_t in_nmi = ATOMIC_INIT(0);
+static atomic_t nmi_running = ATOMIC_INIT(0);
 static int mod_code_status;		/* holds return value of text write */
 static int mod_code_write;		/* set when NMI should do the write */
 static void *mod_code_ip;		/* holds the IP to write to */
@@ -115,8 +115,8 @@ static void ftrace_mod_code(void)
 
 void arch_ftrace_nmi_enter(void)
 {
-	atomic_inc(&in_nmi);
-	/* Must have in_nmi seen before reading write flag */
+	atomic_inc(&nmi_running);
+	/* Must have nmi_running seen before reading write flag */
 	smp_mb();
 	if (mod_code_write) {
 		ftrace_mod_code();
@@ -126,19 +126,19 @@ void arch_ftrace_nmi_enter(void)
 
 void arch_ftrace_nmi_exit(void)
 {
-	/* Finish all executions before clearing in_nmi */
+	/* Finish all executions before clearing nmi_running */
 	smp_wmb();
-	atomic_dec(&in_nmi);
+	atomic_dec(&nmi_running);
 }
 
 static void wait_for_nmi(void)
 {
-	if (!atomic_read(&in_nmi))
+	if (!atomic_read(&nmi_running))
 		return;
 
 	do {
 		cpu_relax();
-	} while(atomic_read(&in_nmi));
+	} while (atomic_read(&nmi_running));
 
 	nmi_wait_count++;
 }
@@ -374,16 +374,16 @@ int ftrace_disable_ftrace_graph_caller(void)
  * this page for dynamic ftrace. They have been
  * simplified to ignore all traces in NMI context.
  */
-static atomic_t in_nmi;
+static atomic_t nmi_running;
 
 void arch_ftrace_nmi_enter(void)
 {
-	atomic_inc(&in_nmi);
+	atomic_inc(&nmi_running);
 }
 
 void arch_ftrace_nmi_exit(void)
 {
-	atomic_dec(&in_nmi);
+	atomic_dec(&nmi_running);
 }
 
 #endif /* !CONFIG_DYNAMIC_FTRACE */
@@ -475,7 +475,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 				&return_to_handler;
 
 	/* Nmi's are currently unsupported */
-	if (unlikely(atomic_read(&in_nmi)))
+	if (unlikely(atomic_read(&nmi_running)))
 		return;
 
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
-- 
1.5.6.5

-- 
