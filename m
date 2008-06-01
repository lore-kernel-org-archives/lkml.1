Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYFAQSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYFAQSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbYFAQSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:18:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:37528 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbYFAQSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=oxFxwDmhQGp0T+lnZcgDqrmV56ZmzcmV7y4LTn1ypxYDT08sU/N+SJK7pncs8TVhOd6u+THACzfd7JWvppwdRKvK27Xfzhe//p4WkPto/iRRBBaBffvnL7N04JTYDoJNl5MQ2S78bl+IkChjOPQz/c2hC4pLnyQ84dnyWwqtsuM=
Message-ID: <4842CBA6.6040208@gmail.com>
Date: Sun, 01 Jun 2008 21:47:42 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: davem@davemloft.net, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] ftrace: remove ftrace_ip_converted
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the unneeded function ftrace_ip_converted().

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index f4cb4cc..22f3d6e 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -22,16 +22,6 @@
 static unsigned long bl_insn;
 static const unsigned long NOP = 0xe1a00000; /* mov r0, r0 */
 
-/* return true if mcount call site is already patched/no-op'ed */
-int ftrace_ip_converted(unsigned long pc)
-{
-	unsigned long save;
-
-	pc -= INSN_SIZE;
-	save = *(unsigned long *)pc;
-	return save == NOP;
-}
-
 unsigned char *ftrace_nop_replace(void)
 {
 	return (char *)&NOP;
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 69ed412..e12c593 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -27,16 +27,6 @@ static unsigned int ftrace_nop = 0x60000000;
 # define GET_ADDR(addr) *(unsigned long *)addr
 #endif
 
-notrace int ftrace_ip_converted(unsigned long ip)
-{
-	unsigned int save;
-
-	ip -= CALL_BACK;
-	save = *(unsigned int *)ip;
-
-	return save == ftrace_nop;
-}
-
 static unsigned int notrace ftrace_calc_offset(long ip, long addr)
 {
 	return (int)((addr + CALL_BACK) - ip);
diff --git a/arch/sparc64/kernel/ftrace.c b/arch/sparc64/kernel/ftrace.c
index f449e6d..c173731 100644
--- a/arch/sparc64/kernel/ftrace.c
+++ b/arch/sparc64/kernel/ftrace.c
@@ -7,13 +7,6 @@
 
 static const u32 ftrace_nop = 0x01000000;
 
-notrace int ftrace_ip_converted(unsigned long ip)
-{
-	u32 insn = *(u32 *) ip;
-
-	return (insn == ftrace_nop);
-}
-
 notrace unsigned char *ftrace_nop_replace(void)
 {
 	return (char *)&ftrace_nop;
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 498608c..bc5cf8d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -31,16 +31,6 @@ union ftrace_code_union {
 	} __attribute__((packed));
 };
 
-notrace int ftrace_ip_converted(unsigned long ip)
-{
-	unsigned long save;
-
-	ip -= CALL_BACK;
-	save = *(long *)ip;
-
-	return save == *ftrace_nop;
-}
-
 static int notrace ftrace_calc_offset(long ip, long addr)
 {
 	return (int)(addr - ip);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 33cee36..2b287ea 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -307,13 +307,6 @@ ftrace_record_ip(unsigned long ip)
 	if (ftrace_ip_in_hash(ip, key))
 		goto out_unlock;
 
-	/*
-	 * There's a slight race that the ftraced will update the
-	 * hash and reset here. If it is already converted, skip it.
-	 */
-	if (ftrace_ip_converted(ip))
-		goto out_unlock;
-
 	node = ftrace_alloc_dyn_node(ip);
 	if (!node)
 		goto out_unlock;
