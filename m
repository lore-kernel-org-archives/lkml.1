Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbZBMPCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbZBMPCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759627AbZBMPBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:01:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZBMPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:01:50 -0500
Message-Id: <20090213150146.923705437@goodmis.org>
References: <20090213150055.947823726@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Feb 2009 10:00:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] powerpc, ftrace: use unsigned int for instruction manipulation
Content-Disposition: inline; filename=0001-powerpc-ftrace-use-unsigned-int-for-instruction-ma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The original port of ftrace to PowerPC kept a lot of the code used
by x86. Some of this code was to handle x86's 5 byte instruction.
This was handled by using character arrays to manipulate the
code.

PowerPC has a consistent 4 byte instruction. Using unsigned ints
makes the code more efficient as well as more readable.
By converting to use unsigned ints to represent instructions,
I was able to remove the side effects that were needed for
manipulating character strings.

  i.e. memcpy and memcmp

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |   45 ++++++++++++++++-------------------------
 1 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index dddd99b..610c852 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -31,22 +31,20 @@
 #endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-static unsigned int ftrace_nop = PPC_NOP_INSTR;
-
 static unsigned int ftrace_calc_offset(long ip, long addr)
 {
 	return (int)(addr - ip);
 }
 
-static unsigned char *ftrace_nop_replace(void)
+static unsigned int ftrace_nop_replace(void)
 {
-	return (char *)&ftrace_nop;
+	return PPC_NOP_INSTR;
 }
 
-static unsigned char *
+static unsigned int
 ftrace_call_replace(unsigned long ip, unsigned long addr, int link)
 {
-	static unsigned int op;
+	unsigned int op;
 
 	/*
 	 * It would be nice to just use create_function_call, but that will
@@ -60,11 +58,7 @@ ftrace_call_replace(unsigned long ip, unsigned long addr, int link)
 	op = 0x48000000 | (link ? 1 : 0);
 	op |= (ftrace_calc_offset(ip, addr) & 0x03fffffc);
 
-	/*
-	 * No locking needed, this must be called via kstop_machine
-	 * which in essence is like running on a uniprocessor machine.
-	 */
-	return (unsigned char *)&op;
+	return op;
 }
 
 #ifdef CONFIG_PPC64
@@ -76,10 +70,9 @@ ftrace_call_replace(unsigned long ip, unsigned long addr, int link)
 #endif
 
 static int
-ftrace_modify_code(unsigned long ip, unsigned char *old_code,
-		   unsigned char *new_code)
+ftrace_modify_code(unsigned long ip, unsigned int old, unsigned int new)
 {
-	unsigned char replaced[MCOUNT_INSN_SIZE];
+	unsigned int replaced;
 
 	/*
 	 * Note: Due to modules and __init, code can
@@ -92,15 +85,15 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	 */
 
 	/* read the text we want to modify */
-	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+	if (probe_kernel_read(&replaced, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	/* Make sure it is what we expect it to be */
-	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
+	if (replaced != old)
 		return -EINVAL;
 
 	/* replace the text with the new text */
-	if (probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE))
+	if (probe_kernel_write((void *)ip, &new, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	flush_icache_range(ip, ip + 8);
@@ -336,8 +329,8 @@ __ftrace_make_nop(struct module *mod,
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
-	unsigned char *old, *new;
 	unsigned long ip = rec->ip;
+	unsigned int old, new;
 
 	/*
 	 * If the calling address is more that 24 bits away,
@@ -475,8 +468,8 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
-	unsigned char *old, *new;
 	unsigned long ip = rec->ip;
+	unsigned int old, new;
 
 	/*
 	 * If the calling address is more that 24 bits away,
@@ -511,10 +504,10 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
-	unsigned char old[MCOUNT_INSN_SIZE], *new;
+	unsigned int old, new;
 	int ret;
 
-	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
+	old = *(unsigned int *)&ftrace_call;
 	new = ftrace_call_replace(ip, (unsigned long)func, 1);
 	ret = ftrace_modify_code(ip, old, new);
 
@@ -543,10 +536,9 @@ int ftrace_enable_ftrace_graph_caller(void)
 	unsigned long ip = (unsigned long)(&ftrace_graph_call);
 	unsigned long addr = (unsigned long)(&ftrace_graph_caller);
 	unsigned long stub = (unsigned long)(&ftrace_graph_stub);
-	unsigned char old[MCOUNT_INSN_SIZE], *new;
+	unsigned int old, new;
 
-	new = ftrace_call_replace(ip, stub, 0);
-	memcpy(old, new, MCOUNT_INSN_SIZE);
+	old = ftrace_call_replace(ip, stub, 0);
 	new = ftrace_call_replace(ip, addr, 0);
 
 	return ftrace_modify_code(ip, old, new);
@@ -557,10 +549,9 @@ int ftrace_disable_ftrace_graph_caller(void)
 	unsigned long ip = (unsigned long)(&ftrace_graph_call);
 	unsigned long addr = (unsigned long)(&ftrace_graph_caller);
 	unsigned long stub = (unsigned long)(&ftrace_graph_stub);
-	unsigned char old[MCOUNT_INSN_SIZE], *new;
+	unsigned int old, new;
 
-	new = ftrace_call_replace(ip, addr, 0);
-	memcpy(old, new, MCOUNT_INSN_SIZE);
+	old = ftrace_call_replace(ip, addr, 0);
 	new = ftrace_call_replace(ip, stub, 0);
 
 	return ftrace_modify_code(ip, old, new);
-- 
1.5.6.5

-- 
