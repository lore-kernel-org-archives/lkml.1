Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbZCQNAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbZCQNAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbZCQNAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:00:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63340 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbZCQNAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:00:07 -0400
Message-ID: <49BF9E69.80908@cn.fujitsu.com>
Date: Tue, 17 Mar 2009 20:58:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ftrace: fast path for do_ftrace_mod_code()
References: <49BE4BF7.6050407@cn.fujitsu.com> <1237225372.3624.15.camel@localhost.localdomain> <49BF9D8A.4070200@cn.fujitsu.com>
In-Reply-To: <49BF9D8A.4070200@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> 
> Subject: [PATCH 1/2] ftrace: protect running nmi (V2)
> 


Subject: [PATCH 2/2] ftrace: fast path for do_ftrace_mod_code()

commit 90c7ac49aa819feb9433b5310089fca6399881c0
adds a fast path to prevent NMI lockup.

But the previous patch "protect executing nmi" changes
do_ftrace_mod_code()'s implementation, we still need fix to
prevent NMI lockup by adding a fast path.

A difference between this fix and 90c7ac49aa819feb9433b5310089fca6399881c0
is that: We kill any new writers in spite of probe_kernel_write()
success or fail, not only when probe_kernel_write() fail.
(When probe_kernel_write() success, new writers do not need to do
it again.)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 699a1c0..61cb520 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -98,6 +98,7 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 #define MOD_CODE_WRITE_FLAG (1 << 31)	/* set when NMI should do the write */
 static atomic_t nmi_running = ATOMIC_INIT(0);
 static int mod_code_status;		/* holds return value of text write */
+static int mod_code_no_write = 1;	/* set when NMI not need do the write */
 static void *mod_code_ip;		/* holds the IP to write to */
 static void *mod_code_newcode;		/* holds the text to write to the IP */
 
@@ -124,14 +125,19 @@ static void ftrace_mod_code(void)
 	 */
 	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
 					     MCOUNT_INSN_SIZE);
+
+	smb_wmb();
+	mod_code_no_write = 1;
 }
 
 void ftrace_nmi_enter(void)
 {
 	if (atomic_inc_return(&nmi_running) & MOD_CODE_WRITE_FLAG) {
 		smp_rmb();
-		ftrace_mod_code();
-		atomic_inc(&nmi_update_count);
+		if (!mod_code_no_write) {
+			ftrace_mod_code();
+			atomic_inc(&nmi_update_count);
+		}
 	}
 	/* Must have previous changes seen before executions */
 	smp_mb();
@@ -161,6 +167,7 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 {
 	mod_code_ip = (void *)ip;
 	mod_code_newcode = new_code;
+	mod_code_no_write = 0;
 
 	/*
 	 * The previous variables need to be visible before NMIs sees
@@ -173,7 +180,8 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 	/* Make sure all running NMIs have finished before we write the code */
 	smp_mb();
 
-	ftrace_mod_code();
+	if (!mod_code_no_write)
+		ftrace_mod_code();
 
 	/* Make sure the write happens before clearing the bit */
 	smp_mb();



