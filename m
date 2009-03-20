Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbZCTKTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbZCTKTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZCTKTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:19:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:47978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbZCTKTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:19:05 -0400
Date: Fri, 20 Mar 2009 10:18:35 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <49C0B411.30003@cn.fujitsu.com>
References: <49C0B411.30003@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] ftrace: protect running nmi (V3)
Message-ID: <tip-e9d9df44736d116726f4596f7e2f9ce2764ffc0a@git.kernel.org>
Git-Commit-ID: e9d9df44736d116726f4596f7e2f9ce2764ffc0a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:18:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9d9df44736d116726f4596f7e2f9ce2764ffc0a
Gitweb:     http://git.kernel.org/tip/e9d9df44736d116726f4596f7e2f9ce2764ffc0a
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 18 Mar 2009 16:42:57 +0800
Committer:  Steven Rostedt <srostedt@redhat.com>
CommitDate: Wed, 18 Mar 2009 20:36:59 -0400

ftrace: protect running nmi (V3)

When I review the sensitive code ftrace_nmi_enter(), I found
the atomic variable nmi_running does protect NMI VS do_ftrace_mod_code(),
but it can not protects NMI(entered nmi) VS NMI(ftrace_nmi_enter()).

cpu#1                   | cpu#2                 | cpu#3
ftrace_nmi_enter()      | do_ftrace_mod_code()  |
  not modify            |                       |
------------------------|-----------------------|--
executing               | set mod_code_write = 1|
executing             --|-----------------------|--------------------
executing               |                       | ftrace_nmi_enter()
executing               |                       |    do modify
------------------------|-----------------------|-----------------
ftrace_nmi_exit()       |                       |

cpu#3 may be being modified the code which is still being executed on cpu#1,
it will have undefined results and possibly take a GPF, this patch
prevents it occurred.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <49C0B411.30003@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>


---
 arch/x86/kernel/ftrace.c |   63 +++++++++++++++++++++++++++++----------------
 1 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1d0d7f4..57b33ed 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -79,11 +79,11 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
  *
  * 1) Put the instruction pointer into the IP buffer
  *    and the new code into the "code" buffer.
- * 2) Set a flag that says we are modifying code
- * 3) Wait for any running NMIs to finish.
- * 4) Write the code
- * 5) clear the flag.
- * 6) Wait for any running NMIs to finish.
+ * 2) Wait for any running NMIs to finish and set a flag that says
+ *    we are modifying code, it is done in an atomic operation.
+ * 3) Write the code
+ * 4) clear the flag.
+ * 5) Wait for any running NMIs to finish.
  *
  * If an NMI is executed, the first thing it does is to call
  * "ftrace_nmi_enter". This will check if the flag is set to write
@@ -95,9 +95,9 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
  * are the same as what exists.
  */
 
+#define MOD_CODE_WRITE_FLAG (1 << 31)	/* set when NMI should do the write */
 static atomic_t nmi_running = ATOMIC_INIT(0);
 static int mod_code_status;		/* holds return value of text write */
-static int mod_code_write;		/* set when NMI should do the write */
 static void *mod_code_ip;		/* holds the IP to write to */
 static void *mod_code_newcode;		/* holds the text to write to the IP */
 
@@ -114,6 +114,20 @@ int ftrace_arch_read_dyn_info(char *buf, int size)
 	return r;
 }
 
+static void clear_mod_flag(void)
+{
+	int old = atomic_read(&nmi_running);
+
+	for (;;) {
+		int new = old & ~MOD_CODE_WRITE_FLAG;
+
+		if (old == new)
+			break;
+
+		old = atomic_cmpxchg(&nmi_running, old, new);
+	}
+}
+
 static void ftrace_mod_code(void)
 {
 	/*
@@ -127,27 +141,39 @@ static void ftrace_mod_code(void)
 
 	/* if we fail, then kill any new writers */
 	if (mod_code_status)
-		mod_code_write = 0;
+		clear_mod_flag();
 }
 
 void ftrace_nmi_enter(void)
 {
-	atomic_inc(&nmi_running);
-	/* Must have nmi_running seen before reading write flag */
-	smp_mb();
-	if (mod_code_write) {
+	if (atomic_inc_return(&nmi_running) & MOD_CODE_WRITE_FLAG) {
+		smp_rmb();
 		ftrace_mod_code();
 		atomic_inc(&nmi_update_count);
 	}
+	/* Must have previous changes seen before executions */
+	smp_mb();
 }
 
 void ftrace_nmi_exit(void)
 {
 	/* Finish all executions before clearing nmi_running */
-	smp_wmb();
+	smp_mb();
 	atomic_dec(&nmi_running);
 }
 
+static void wait_for_nmi_and_set_mod_flag(void)
+{
+	if (!atomic_cmpxchg(&nmi_running, 0, MOD_CODE_WRITE_FLAG))
+		return;
+
+	do {
+		cpu_relax();
+	} while (atomic_cmpxchg(&nmi_running, 0, MOD_CODE_WRITE_FLAG));
+
+	nmi_wait_count++;
+}
+
 static void wait_for_nmi(void)
 {
 	if (!atomic_read(&nmi_running))
@@ -167,14 +193,9 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 	mod_code_newcode = new_code;
 
 	/* The buffers need to be visible before we let NMIs write them */
-	smp_wmb();
-
-	mod_code_write = 1;
-
-	/* Make sure write bit is visible before we wait on NMIs */
 	smp_mb();
 
-	wait_for_nmi();
+	wait_for_nmi_and_set_mod_flag();
 
 	/* Make sure all running NMIs have finished before we write the code */
 	smp_mb();
@@ -182,13 +203,9 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 	ftrace_mod_code();
 
 	/* Make sure the write happens before clearing the bit */
-	smp_wmb();
-
-	mod_code_write = 0;
-
-	/* make sure NMIs see the cleared bit */
 	smp_mb();
 
+	clear_mod_flag();
 	wait_for_nmi();
 
 	return mod_code_status;
