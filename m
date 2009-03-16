Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbZCPMzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbZCPMzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZCPMzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:55:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55747 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757340AbZCPMzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:55:31 -0400
Message-ID: <49BE4BF7.6050407@cn.fujitsu.com>
Date: Mon, 16 Mar 2009 20:54:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: protect executing nmi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1d0d7f4..e016f5e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -87,7 +87,8 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
  *
  * If an NMI is executed, the first thing it does is to call
  * "ftrace_nmi_enter". This will check if the flag is set to write
- * and if it is, it will write what is in the IP and "code" buffers.
+ * and if it is, and there is no executing nmi, it will write
+ * what is in the IP and "code" buffers.
  *
  * The trick is, it does not matter if everyone is writing the same
  * content to the code location. Also, if a CPU is executing code
@@ -96,6 +97,7 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
  */
 
 static atomic_t nmi_running = ATOMIC_INIT(0);
+static atomic_t nmi_executing = ATOMIC_INIT(0);
 static int mod_code_status;		/* holds return value of text write */
 static int mod_code_write;		/* set when NMI should do the write */
 static void *mod_code_ip;		/* holds the IP to write to */
@@ -135,14 +137,18 @@ void ftrace_nmi_enter(void)
 	atomic_inc(&nmi_running);
 	/* Must have nmi_running seen before reading write flag */
 	smp_mb();
-	if (mod_code_write) {
+	if (!atomic_read(&nmi_executing) && mod_code_write) {
 		ftrace_mod_code();
 		atomic_inc(&nmi_update_count);
 	}
+	atomic_inc(&nmi_executing);
+	smp_mb();
 }
 
 void ftrace_nmi_exit(void)
 {
+	smp_mb();
+	atomic_dec(&nmi_executing);
 	/* Finish all executions before clearing nmi_running */
 	smp_wmb();
 	atomic_dec(&nmi_running);




