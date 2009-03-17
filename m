Return-Path: <linux-kernel-owner+w=401wt.eu-S1763484AbZCQM4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763484AbZCQM4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbZCQM4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:56:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60162 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756319AbZCQM4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:56:32 -0400
Message-ID: <49BF9D8A.4070200@cn.fujitsu.com>
Date: Tue, 17 Mar 2009 20:54:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ftrace: protect running nmi
References: <49BE4BF7.6050407@cn.fujitsu.com> <1237225372.3624.15.camel@localhost.localdomain>
In-Reply-To: <1237225372.3624.15.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
>>  	atomic_inc(&nmi_running);
>>  	/* Must have nmi_running seen before reading write flag */
>>  	smp_mb();
>> -	if (mod_code_write) {
>> +	if (!atomic_read(&nmi_executing) && mod_code_write) {
>>  		ftrace_mod_code();
>>  		atomic_inc(&nmi_update_count);
>>  	}
> 
> Here we have another race window. If cpu#1 has that NMI and right here
> we get a SMI (something to make the race window bigger). cpu#2 could
> have set the mod_code_write and cpu#3 could have another NMI that sees
> it but does not see the nmi_executing flag. Now we are in the same
> scenario as you nicely described up above.

I missed this window.

> void ftrace_nmi_enter(void)
> {	
> 	if (atomic_inc_return(&mod_code_write) > 10000) {
> 		ftrace_mod_code();
> 		atomic_inc(&nmi_update_count);
> 	}
> 	smp_mb();
> }
> 
> void ftrace_nmi_exit(void)
> {
> 	smp_mb();
> 	atomic_dec(&mod_code_write);
> }
> 
> Then in do_ftrace_mod_code ...
> 
> 
> 	while (atomic_cmpxchg(&mod_code_write, 0, 10001) != 0)
> 		;
> 
> 	[...]
> 
> 
> 	while (atomic_cmpxchg(&mode_code_write, 10001, 0) != 10001)
> 		;
> 
> 
> Does this look like it would solve the issue?
> 

It's very nice. The write-flag and the counter are put into an atomic
together. The write-flag is changed only when there is no running NMI.
So any NMI sees this flag, all other running NMIs also see this flag
when them were entering.


Subject: [PATCH 1/2] ftrace: protect running nmi (V2)

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
index 1d0d7f4..699a1c0 100644
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
+ * 4) clear the flag and wait for any running NMIs to finish,
+ *    it is also done in an atomic operation.
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
 
@@ -124,40 +124,36 @@ static void ftrace_mod_code(void)
 	 */
 	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
 					     MCOUNT_INSN_SIZE);
-
-	/* if we fail, then kill any new writers */
-	if (mod_code_status)
-		mod_code_write = 0;
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
 
-static void wait_for_nmi(void)
+static void wait_and_set(int wait_val, int set_val)
 {
-	if (!atomic_read(&nmi_running))
-		return;
+	int wait = 0;
 
-	do {
+	while (atomic_cmpxchg(&nmi_running, wait_val, set_val) != wait_val) {
+		wait = 1;
 		cpu_relax();
-	} while (atomic_read(&nmi_running));
+	}
 
-	nmi_wait_count++;
+	nmi_wait_count += wait;
 }
 
 static int
@@ -166,15 +162,13 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 	mod_code_ip = (void *)ip;
 	mod_code_newcode = new_code;
 
-	/* The buffers need to be visible before we let NMIs write them */
-	smp_wmb();
-
-	mod_code_write = 1;
-
-	/* Make sure write bit is visible before we wait on NMIs */
+	/*
+	 * The previous variables need to be visible before NMIs sees
+	 * the MOD_CODE_WRITE_FLAG.
+	 */
 	smp_mb();
 
-	wait_for_nmi();
+	wait_and_set(0, MOD_CODE_WRITE_FLAG);
 
 	/* Make sure all running NMIs have finished before we write the code */
 	smp_mb();
@@ -182,14 +176,9 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 	ftrace_mod_code();
 
 	/* Make sure the write happens before clearing the bit */
-	smp_wmb();
-
-	mod_code_write = 0;
-
-	/* make sure NMIs see the cleared bit */
 	smp_mb();
 
-	wait_for_nmi();
+	wait_and_set(MOD_CODE_WRITE_FLAG, 0);
 
 	return mod_code_status;
 }





