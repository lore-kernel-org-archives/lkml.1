Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbZFBAfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbZFBAfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZFBAew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:34:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36913 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583AbZFBAeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:34:50 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v9 5/7] x86: add pt_regs register and stack access APIs
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, linux-arch@vger.kernel.org
Date: Mon, 01 Jun 2009 20:37:42 -0400
Message-ID: <20090602003742.29255.40546.stgit@localhost.localdomain>
In-Reply-To: <20090602003709.29255.48248.stgit@localhost.localdomain>
References: <20090602003709.29255.48248.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add following APIs for accessing registers and stack entries from pt_regs.

- regs_query_register_offset(const char *name)
   Query the offset of "name" register.

- regs_query_register_name(unsigned offset)
   Query the name of register by its offset.

- regs_get_register(struct pt_regs *regs, unsigned offset)
   Get the value of a register by its offset.

- regs_within_kernel_stack(struct pt_regs *regs, unsigned long addr)
   Check the address is in the kernel stack.

- regs_get_kernel_stack_nth(struct pt_regs *reg, unsigned nth)
   Get Nth entry of the kernel stack. (N >= 0)

- regs_get_argument_nth(struct pt_regs *reg, unsigned nth)
   Get Nth argument at function call. (N >= 0)

Changes from v8:
 - Add regs_ prefix to the APIs
 - Add kerneldoc comments.
 - Cleanup regs_get_argument_nth() code.
 - Remove REG_OFFSET macro.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: linux-arch@vger.kernel.org
---

 arch/x86/include/asm/ptrace.h |  122 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/ptrace.c      |   73 +++++++++++++++++++++++++
 2 files changed, 195 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 0f0d908..2fd3ea3 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -7,6 +7,7 @@
 
 #ifdef __KERNEL__
 #include <asm/segment.h>
+#include <asm/page_types.h>
 #endif
 
 #ifndef __ASSEMBLY__
@@ -216,6 +217,127 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 	return regs->sp;
 }
 
+/* Query offset/name of register from its name/offset */
+extern int regs_query_register_offset(const char *name);
+extern const char *regs_query_register_name(unsigned offset);
+#define MAX_REG_OFFSET (offsetof(struct pt_regs, ss))
+
+/**
+ * regs_get_regsiter() - get register value from its offset
+ * @regs:	pt_regs from which register value is gotten.
+ * @offset:	offset number of the register.
+ *
+ * regs_get_register returns the value of a register whose offset from @regs
+ * is @offset. The @offset is the offset of the register in struct pt_regs.
+ * If @offset is bigger than MAX_REG_OFFSET, this returns 0.
+ */
+static inline unsigned long regs_get_register(struct pt_regs *regs,
+					      unsigned offset)
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
+						      unsigned n)
+{
+	unsigned long *addr = (unsigned long *)kernel_stack_pointer(regs);
+	addr += n;
+	if (regs_within_kernel_stack(regs, (unsigned long)addr))
+		return *addr;
+	else
+		return 0;
+}
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
+#ifdef CONFIG_X86_32
+#define NR_REGPARMS 3
+static inline unsigned long regs_get_argument_nth(struct pt_regs *regs,
+						  unsigned n)
+{
+	if (n < NR_REGPARMS) {
+		switch (n) {
+		case 0:
+			return regs->ax;
+		case 1:
+			return regs->dx;
+		case 2:
+			return regs->cx;
+		}
+		return 0;
+	} else {
+		/*
+		 * The typical case: arg n is on the stack.
+		 * (Note: stack[0] = return address, so skip it)
+		 */
+		return regs_get_kernel_stack_nth(regs, 1 + n - NR_REGPARMS);
+	}
+}
+#else /* CONFIG_X86_64 */
+#define NR_REGPARMS 6
+static inline unsigned long regs_get_argument_nth(struct pt_regs *regs,
+						  unsigned n)
+{
+	if (n < NR_REGPARMS) {
+		switch (n) {
+		case 0:
+			return regs->di;
+		case 1:
+			return regs->si;
+		case 2:
+			return regs->dx;
+		case 3:
+			return regs->cx;
+		case 4:
+			return regs->r8;
+		case 5:
+			return regs->r9;
+		}
+		return 0;
+	} else {
+		/*
+		 * The typical case: arg n is on the stack.
+		 * (Note: stack[0] = return address, so skip it)
+		 */
+		return regs_get_kernel_stack_nth(regs, 1 + n - NR_REGPARMS);
+	}
+}
+#endif
+
 /*
  * These are defined as per linux/ptrace.h, which see.
  */
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 09ecbde..d668adb 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -48,6 +48,79 @@ enum x86_regset {
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
+const char *regs_query_register_name(unsigned offset)
+{
+	const struct pt_regs_offset *roff;
+	for (roff = regoffset_table; roff->name != NULL; roff++)
+		if (roff->offset == offset)
+			return roff->name;
+	return NULL;
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
