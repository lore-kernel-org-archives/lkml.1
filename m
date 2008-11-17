Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYKQTLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYKQTLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbYKQTLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:11:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbYKQTLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:11:31 -0500
Message-Id: <20081117191059.222133155@goodmis.org>
References: <20081117190948.619751203@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 17 Nov 2008 14:09:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/4] ftrace,ppc: consolidate dyn ftrace ppc code between 32 and 64 bit
Content-Disposition: inline; filename=0001-ftrace-ppc-consolidate-dyn-ftrace-ppc-code-between.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code clean up between PPC 32 and 64 bit platforms

The modification of code for dynamic ftrace between 32 bit and 64 bit PPC
platforms is a bit different. But there is also several things that are
similar. This patch consolidates some of the code between the two
algorithms so that fixes to one make it to the other.

Paul Mackerras pointed out a few mistakes in the code. This patch does
not fix those mistakes. This patch only consolidates the 32bit and 64bit
with helper routines that the fixes can be made in one place.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |  150 +++++++++++++++++++-----------------------
 1 files changed, 69 insertions(+), 81 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 57fdda8..9360fd1 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -109,6 +109,9 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	return 0;
 }
 
+/*
+ * Helper functions that are the same for both PPC64 and PPC32.
+ */
 static int test_24bit_addr(unsigned long ip, unsigned long addr)
 {
 	unsigned long diff;
@@ -119,6 +122,34 @@ static int test_24bit_addr(unsigned long ip, unsigned long addr)
 	return !(diff & ((unsigned long)-1 << 24));
 }
 
+static int is_bl_op(unsigned int op)
+{
+	return (op & 0xff000000) == 0x48000000;
+}
+
+static int test_offset(unsigned long offset)
+{
+	return (offset + 0x2000000 > 0x3ffffff) || ((offset & 3) != 0);
+}
+
+static unsigned long find_bl_target(unsigned long ip, unsigned int op)
+{
+	static int offset;
+
+	offset = (op & 0x03fffffc);
+	/* make it signed */
+	if (offset & 0x02000000)
+		offset |= 0xfe000000;
+
+	return ip + (long)offset;
+}
+
+static unsigned int branch_offset(unsigned long offset)
+{
+	/* return "bl ip+offset" */
+	return 0x48000001 | (offset & 0x03fffffc);
+}
+
 #ifdef CONFIG_PPC64
 static int
 __ftrace_make_nop(struct module *mod,
@@ -132,43 +163,18 @@ __ftrace_make_nop(struct module *mod,
 	unsigned long tramp;
 	int offset;
 
-	/*
-	 * Out of range jumps are called from modules.
-	 * We should either already have a pointer to the module
-	 * or it has been passed in.
-	 */
-	if (!rec->arch.mod) {
-		if (!mod) {
-			printk(KERN_ERR "No module loaded addr=%lx\n",
-			       addr);
-			return -EFAULT;
-		}
-		rec->arch.mod = mod;
-	} else if (mod) {
-		printk(KERN_ERR
-		       "Record mod %p not equal to passed in mod %p\n",
-		       rec->arch.mod, mod);
-		return -EINVAL;
-	} else
-		mod = rec->arch.mod;
-
 	/* read where this goes */
 	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	/* Make sure that that this is still a 24bit jump */
-	if ((*op & 0xff000000) != 0x48000000) {
+	if (!is_bl_op(*op)) {
 		printk(KERN_ERR "Not expected bl: opcode is %x\n", *op);
 		return -EINVAL;
 	}
 
 	/* lets find where the pointer goes */
-	offset = (*op & 0x03fffffc);
-	/* make it signed */
-	if (offset & 0x02000000)
-		offset |= 0xfe000000;
-
-	tramp = ip + (long)offset;
+	tramp = find_bl_target(ip, *op);
 
 	/*
 	 * On PPC64 the trampoline looks like:
@@ -257,43 +263,17 @@ __ftrace_make_nop(struct module *mod,
 	unsigned long tramp;
 	int offset;
 
-	/*
-	 * Out of range jumps are called from modules.
-	 * We should either already have a pointer to the module
-	 * or it has been passed in.
-	 */
-	if (!rec->arch.mod) {
-		if (!mod) {
-			printk(KERN_ERR "No module loaded addr=%lx\n",
-			       addr);
-			return -EFAULT;
-		}
-		rec->arch.mod = mod;
-	} else if (mod) {
-		printk(KERN_ERR
-		       "Record mod %p not equal to passed in mod %p\n",
-		       rec->arch.mod, mod);
-		return -EINVAL;
-	} else
-		mod = rec->arch.mod;
-
-	/* read where this goes */
 	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	/* Make sure that that this is still a 24bit jump */
-	if ((*op & 0xff000000) != 0x48000000) {
+	if (!is_bl_op(*op)) {
 		printk(KERN_ERR "Not expected bl: opcode is %x\n", *op);
 		return -EINVAL;
 	}
 
 	/* lets find where the pointer goes */
-	offset = (*op & 0x03fffffc);
-	/* make it signed */
-	if (offset & 0x02000000)
-		offset |= 0xfe000000;
-
-	tramp = ip + (long)offset;
+	tramp = find_bl_target(ip, *op);
 
 	/*
 	 * On PPC32 the trampoline looks like:
@@ -354,6 +334,26 @@ int ftrace_make_nop(struct module *mod,
 		return ftrace_modify_code(ip, old, new);
 	}
 
+	/*
+	 * Out of range jumps are called from modules.
+	 * We should either already have a pointer to the module
+	 * or it has been passed in.
+	 */
+	if (!rec->arch.mod) {
+		if (!mod) {
+			printk(KERN_ERR "No module loaded addr=%lx\n",
+			       addr);
+			return -EFAULT;
+		}
+		rec->arch.mod = mod;
+	} else if (mod) {
+		printk(KERN_ERR
+		       "Record mod %p not equal to passed in mod %p\n",
+		       rec->arch.mod, mod);
+		return -EINVAL;
+	} else
+		mod = rec->arch.mod;
+
 	return __ftrace_make_nop(mod, rec, addr);
 
 }
@@ -367,16 +367,6 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned long ip = rec->ip;
 	unsigned long offset;
 
-	/*
-	 * Out of range jumps are called from modules.
-	 * Being that we are converting from nop, it had better
-	 * already have a module defined.
-	 */
-	if (!rec->arch.mod) {
-		printk(KERN_ERR "No module loaded\n");
-		return -EINVAL;
-	}
-
 	/* read where this goes */
 	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE * 2))
 		return -EFAULT;
@@ -397,15 +387,14 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	/* now calculate a jump to the ftrace caller trampoline */
 	offset = rec->arch.mod->arch.tramp - ip;
 
-	if (offset + 0x2000000 > 0x3ffffff || (offset & 3) != 0) {
+	if (test_offset(offset)) {
 		printk(KERN_ERR "REL24 %li out of range!\n",
 		       (long int)offset);
 		return -EINVAL;
 	}
 
-
 	/* Set to "bl addr" */
-	op[0] = 0x48000001 | (offset & 0x03fffffc);
+	op[0] = branch_offset(offset);
 	/* ld r2,40(r1) */
 	op[1] = 0xe8410028;
 
@@ -425,16 +414,6 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned long ip = rec->ip;
 	unsigned long offset;
 
-	/*
-	 * Out of range jumps are called from modules.
-	 * Being that we are converting from nop, it had better
-	 * already have a module defined.
-	 */
-	if (!rec->arch.mod) {
-		printk(KERN_ERR "No module loaded\n");
-		return -EINVAL;
-	}
-
 	/* read where this goes */
 	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
@@ -454,15 +433,14 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	/* now calculate a jump to the ftrace caller trampoline */
 	offset = rec->arch.mod->arch.tramp - ip;
 
-	if (offset + 0x2000000 > 0x3ffffff || (offset & 3) != 0) {
+	if (test_offset(offset)) {
 		printk(KERN_ERR "REL24 %li out of range!\n",
 		       (long int)offset);
 		return -EINVAL;
 	}
 
-
 	/* Set to "bl addr" */
-	op[0] = 0x48000001 | (offset & 0x03fffffc);
+	op[0] = branch_offset(offset);
 
 	DEBUGP("write to %lx\n", rec->ip);
 
@@ -490,6 +468,16 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		return ftrace_modify_code(ip, old, new);
 	}
 
+	/*
+	 * Out of range jumps are called from modules.
+	 * Being that we are converting from nop, it had better
+	 * already have a module defined.
+	 */
+	if (!rec->arch.mod) {
+		printk(KERN_ERR "No module loaded\n");
+		return -EINVAL;
+	}
+
 	return __ftrace_make_call(rec, addr);
 
 }
-- 
1.5.6.5

-- 
