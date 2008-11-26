Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYKZWF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYKZWF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYKZWE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:04:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYKZWEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:04:25 -0500
Message-Id: <20081126220423.514020907@goodmis.org>
References: <20081126215821.263324391@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 16:58:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] powerpc: ftrace, use create_branch
Content-Disposition: inline; filename=0004-powerpc-ftrace-use-create_branch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Paul Mackerras pointed out that the code to determine if the branch
can reach the destination is incorrect. Michael Ellerman suggested
to pull out the code from create_branch and use that.

Simply using create_branch is probably the best.

Reported-by: Michael Ellerman <michael@ellerman.id.au>
Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |   54 +++++++++--------------------------------
 1 files changed, 12 insertions(+), 42 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index a4640e4..5355244 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -114,19 +114,9 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
  */
 static int test_24bit_addr(unsigned long ip, unsigned long addr)
 {
-	long diff;
 
-	/*
-	 * Can we get to addr from ip in 24 bits?
-	 *  (26 really, since we mulitply by 4 for 4 byte alignment)
-	 */
-	diff = addr - ip;
-
-	/*
-	 * Return true if diff is less than 1 << 25
-	 *  and greater than -1 << 26.
-	 */
-	return (diff < (1 << 25)) && (diff > (-1 << 26));
+	/* use the create_branch to verify that this offset can be branched */
+	return create_branch((unsigned int *)ip, addr, 0);
 }
 
 static int is_bl_op(unsigned int op)
@@ -134,11 +124,6 @@ static int is_bl_op(unsigned int op)
 	return (op & 0xfc000003) == 0x48000001;
 }
 
-static int test_offset(unsigned long offset)
-{
-	return (offset + 0x2000000 > 0x3ffffff) || ((offset & 3) != 0);
-}
-
 static unsigned long find_bl_target(unsigned long ip, unsigned int op)
 {
 	static int offset;
@@ -151,12 +136,6 @@ static unsigned long find_bl_target(unsigned long ip, unsigned int op)
 	return ip + (long)offset;
 }
 
-static unsigned int branch_offset(unsigned long offset)
-{
-	/* return "bl ip+offset" */
-	return 0x48000001 | (offset & 0x03fffffc);
-}
-
 #ifdef CONFIG_PPC64
 static int
 __ftrace_make_nop(struct module *mod,
@@ -402,7 +381,6 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned int op[2];
 	unsigned long ip = rec->ip;
-	unsigned long offset;
 
 	/* read where this goes */
 	if (probe_kernel_read(op, (void *)ip, MCOUNT_INSN_SIZE * 2))
@@ -424,17 +402,14 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		return -EINVAL;
 	}
 
-	/* now calculate a jump to the ftrace caller trampoline */
-	offset = rec->arch.mod->arch.tramp - ip;
-
-	if (test_offset(offset)) {
-		printk(KERN_ERR "REL24 %li out of range!\n",
-		       (long int)offset);
+	/* create the branch to the trampoline */
+	op[0] = create_branch((unsigned int *)ip,
+			      rec->arch.mod->arch.tramp, BRANCH_SET_LINK);
+	if (!op[0]) {
+		printk(KERN_ERR "REL24 out of range!\n");
 		return -EINVAL;
 	}
 
-	/* Set to "bl addr" */
-	op[0] = branch_offset(offset);
 	/* ld r2,40(r1) */
 	op[1] = 0xe8410028;
 
@@ -453,7 +428,6 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned int op;
 	unsigned long ip = rec->ip;
-	unsigned long offset;
 
 	/* read where this goes */
 	if (probe_kernel_read(&op, (void *)ip, MCOUNT_INSN_SIZE))
@@ -471,18 +445,14 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		return -EINVAL;
 	}
 
-	/* now calculate a jump to the ftrace caller trampoline */
-	offset = rec->arch.mod->arch.tramp - ip;
-
-	if (test_offset(offset)) {
-		printk(KERN_ERR "REL24 %li out of range!\n",
-		       (long int)offset);
+	/* create the branch to the trampoline */
+	op = create_branch((unsigned int *)ip,
+			   rec->arch.mod->arch.tramp, BRANCH_SET_LINK);
+	if (!op) {
+		printk(KERN_ERR "REL24 out of range!\n");
 		return -EINVAL;
 	}
 
-	/* Set to "bl addr" */
-	op = branch_offset(offset);
-
 	DEBUGP("write to %lx\n", rec->ip);
 
 	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
-- 
1.5.6.5

-- 
