Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZGXUDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZGXUDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZGXUDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:03:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55323 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbZGXUDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:03:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip -v13 05/11] x86: add pt_regs register and stack access
	APIs
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-arch@vger.kernel.org
Date: Fri, 24 Jul 2009 16:05:58 -0400
Message-ID: <20090724200558.25904.22641.stgit@localhost.localdomain>
In-Reply-To: <20090724200527.25904.2562.stgit@localhost.localdomain>
References: <20090724200527.25904.2562.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add following APIs for accessing registers and stack entries from pt_regs.
These APIs are required by kprobes-based event tracer on ftrace.
Some other debugging tools might be able to use it too.

- regs_query_register_offset(const char *name)
   Query the offset of "name" register.

- regs_query_register_name(unsigned int offset)
   Query the name of register by its offset.

- regs_get_register(struct pt_regs *regs, unsigned int offset)
   Get the value of a register by its offset.

- regs_within_kernel_stack(struct pt_regs *regs, unsigned long addr)
   Check the address is in the kernel stack.

- regs_get_kernel_stack_nth(struct pt_regs *reg, unsigned int nth)
   Get Nth entry of the kernel stack. (N >= 0)

- regs_get_argument_nth(struct pt_regs *reg, unsigned int nth)
   Get Nth argument at function call. (N >= 0)


Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-arch@vger.kernel.org
---

 arch/x86/include/asm/ptrace.h |   62 +++++++++++++++++++++++
 arch/x86/kernel/ptrace.c      |  112 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 174 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 0f0d908..a3d49dd 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -7,6 +7,7 @@
 
 #ifdef __KERNEL__
 #include <asm/segment.h>
+#include <asm/page_types.h>
 #endif
 
 #ifndef __ASSEMBLY__
@@ -216,6 +217,67 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 	return regs->sp;
 }
 
+/* Query offset/name of register from its name/offset */
+extern int regs_query_register_offset(const char *name);
+extern const char *regs_query_register_name(unsigned int offset);
+#define MAX_REG_OFFSET (offsetof(struct pt_regs, ss))
+
+/**
+ * regs_get_register() - get register value from its offset
+ * @regs:	pt_regs from which register value is gotten.
+ * @offset:	offset number of the register.
+ *
+ * regs_get_register returns the value of a register whose offset from @regs
+ * is @offset. The @offset is the offset of the register in struct pt_regs.
+ * If @offset is bigger than MAX_REG_OFFSET, this returns 0.
+ */
+static inline unsigned long regs_get_register(struct pt_regs *regs,
+					      unsigned int offset)
+{
+	if (unlikely(offset > MAX_REG_OFFSET))
+		return 0;
+	return *(unsigned long *)((unsigned long)regs + offset);
+}
+
+/**
+ * regs_within_kernel_stack() - check the address in the stack
+ * @regs:	pt_regs which contains kernel stack pointer.
+ * @addr:	address which is checked.
+ *
+ * regs_within_kenel_stack() checks @addr is within the kernel stack page(s).
+ * If @addr is within the kernel stack, it returns true. If not, returns false.
+ */
+static inline int regs_within_kernel_stack(struct pt_regs *regs,
+					   unsigned long addr)
+{
+	return ((addr & ~(THREAD_SIZE - 1))  ==
+		(kernel_stack_pointer(regs) & ~(THREAD_SIZE - 1)));
+}
+
+/**
+ * regs_get_kernel_stack_nth() - get Nth entry of the stack
+ * @regs:	pt_regs which contains kernel stack pointer.
+ * @n:		stack entry number.
+ *
+ * regs_get_kernel_stack_nth() returns @n th entry of the kernel stack which
+ * is specifined by @regs. If the @n th entry is NOT in the kernel stack,
+ * this returns 0.
+ */
+static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
+						      unsigned int n)
+{
+	unsigned long *addr = (unsigned long *)kernel_stack_pointer(regs);
+	addr += n;
+	if (regs_within_kernel_stack(regs, (unsigned long)addr))
+		return *addr;
+	else
+		return 0;
+}
+
+/* Get Nth argument at function call */
+extern unsigned long regs_get_argument_nth(struct pt_regs *regs,
+					   unsigned int n);
+
 /*
  * These are defined as per linux/ptrace.h, which see.
  */
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index cabdabc..32729ec 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -49,6 +49,118 @@ enum x86_regset {
 	REGSET_IOPERM32,
 };
 
+struct pt_regs_offset {
+	const char *name;
+	int offset;
+};
+
+#define REG_OFFSET_NAME(r) {.name = #r, .offset = offsetof(struct pt_regs, r)}
+#define REG_OFFSET_END {.name = NULL, .offset = 0}
+
+static const struct pt_regs_offset regoffset_table[] = {
+#ifdef CONFIG_X86_64
+	REG_OFFSET_NAME(r15),
+	REG_OFFSET_NAME(r14),
+	REG_OFFSET_NAME(r13),
+	REG_OFFSET_NAME(r12),
+	REG_OFFSET_NAME(r11),
+	REG_OFFSET_NAME(r10),
+	REG_OFFSET_NAME(r9),
+	REG_OFFSET_NAME(r8),
+#endif
+	REG_OFFSET_NAME(bx),
+	REG_OFFSET_NAME(cx),
+	REG_OFFSET_NAME(dx),
+	REG_OFFSET_NAME(si),
+	REG_OFFSET_NAME(di),
+	REG_OFFSET_NAME(bp),
+	REG_OFFSET_NAME(ax),
+#ifdef CONFIG_X86_32
+	REG_OFFSET_NAME(ds),
+	REG_OFFSET_NAME(es),
+	REG_OFFSET_NAME(fs),
+	REG_OFFSET_NAME(gs),
+#endif
+	REG_OFFSET_NAME(orig_ax),
+	REG_OFFSET_NAME(ip),
+	REG_OFFSET_NAME(cs),
+	REG_OFFSET_NAME(flags),
+	REG_OFFSET_NAME(sp),
+	REG_OFFSET_NAME(ss),
+	REG_OFFSET_END,
+};
+
+/**
+ * regs_query_register_offset() - query register offset from its name
+ * @name:	the name of a register
+ *
+ * regs_query_register_offset() returns the offset of a register in struct
+ * pt_regs from its name. If the name is invalid, this returns -EINVAL;
+ */
+int regs_query_register_offset(const char *name)
+{
+	const struct pt_regs_offset *roff;
+	for (roff = regoffset_table; roff->name != NULL; roff++)
+		if (!strcmp(roff->name, name))
+			return roff->offset;
+	return -EINVAL;
+}
+
+/**
+ * regs_query_register_name() - query register name from its offset
+ * @offset:	the offset of a register in struct pt_regs.
+ *
+ * regs_query_register_name() returns the name of a register from its
+ * offset in struct pt_regs. If the @offset is invalid, this returns NULL;
+ */
+const char *regs_query_register_name(unsigned int offset)
+{
+	const struct pt_regs_offset *roff;
+	for (roff = regoffset_table; roff->name != NULL; roff++)
+		if (roff->offset == offset)
+			return roff->name;
+	return NULL;
+}
+
+static const int arg_offs_table[] = {
+#ifdef CONFIG_X86_32
+	[0] = offsetof(struct pt_regs, ax),
+	[1] = offsetof(struct pt_regs, dx),
+	[2] = offsetof(struct pt_regs, cx)
+#else /* CONFIG_X86_64 */
+	[0] = offsetof(struct pt_regs, di),
+	[1] = offsetof(struct pt_regs, si),
+	[2] = offsetof(struct pt_regs, dx),
+	[3] = offsetof(struct pt_regs, cx),
+	[4] = offsetof(struct pt_regs, r8),
+	[5] = offsetof(struct pt_regs, r9)
+#endif
+};
+
+/**
+ * regs_get_argument_nth() - get Nth argument at function call
+ * @regs:	pt_regs which contains registers at function entry.
+ * @n:		argument number.
+ *
+ * regs_get_argument_nth() returns @n th argument of a function call.
+ * Since usually the kernel stack will be changed right after function entry,
+ * you must use this at function entry. If the @n th entry is NOT in the
+ * kernel stack or pt_regs, this returns 0.
+ */
+unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n)
+{
+	if (n < ARRAY_SIZE(arg_offs_table))
+		return *((unsigned long *)regs + arg_offs_table[n]);
+	else {
+		/*
+		 * The typical case: arg n is on the stack.
+		 * (Note: stack[0] = return address, so skip it)
+		 */
+		n -= ARRAY_SIZE(arg_offs_table);
+		return regs_get_kernel_stack_nth(regs, 1 + n);
+	}
+}
+
 /*
  * does not yet catch signals sent when the child dies.
  * in exit.c or in signal.c.


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
