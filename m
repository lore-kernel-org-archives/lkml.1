Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbZBMPCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbZBMPCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbZBMPBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:01:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56928 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbZBMPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:01:50 -0500
Message-Id: <20090213150147.180922180@goodmis.org>
References: <20090213150055.947823726@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Feb 2009 10:00:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] powerpc, ftrace: use create_branch lib function
Content-Disposition: inline; filename=0002-powerpc-ftrace-use-create_branch-lib-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up, remove duplicate code

When ftrace was first ported to PowerPC, there existed a
create_function_call that would create the instruction to make a call
to a given address. Unfortunately, this call expected to write to
the address it was given, and since it used the address to calculate
the offset, it could not be faked.

ftrace needed a way to create the instruction without actually writing
that instruction to the text section. So ftrace had to implement its
own code.

Now we have create_branch in the code patching library, which does
exactly what ftrace needs. This patch replaces ftrace's implementation
with the library function.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 610c852..4c75a1c 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -31,11 +31,6 @@
 #endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-static unsigned int ftrace_calc_offset(long ip, long addr)
-{
-	return (int)(addr - ip);
-}
-
 static unsigned int ftrace_nop_replace(void)
 {
 	return PPC_NOP_INSTR;
@@ -46,17 +41,10 @@ ftrace_call_replace(unsigned long ip, unsigned long addr, int link)
 {
 	unsigned int op;
 
-	/*
-	 * It would be nice to just use create_function_call, but that will
-	 * update the code itself. Here we need to just return the
-	 * instruction that is going to be modified, without modifying the
-	 * code.
-	 */
 	addr = GET_ADDR(addr);
 
 	/* if (link) set op to 'bl' else 'b' */
-	op = 0x48000000 | (link ? 1 : 0);
-	op |= (ftrace_calc_offset(ip, addr) & 0x03fffffc);
+	op = create_branch((unsigned int *)ip, addr, link ? 1 : 0);
 
 	return op;
 }
-- 
1.5.6.5

-- 
