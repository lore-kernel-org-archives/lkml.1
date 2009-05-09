Return-Path: <linux-kernel-owner+w=401wt.eu-S1765064AbZEIArT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765064AbZEIArT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 20:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764632AbZEIAqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 20:46:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55698 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764611AbZEIAqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 20:46:17 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v5 6/7] x86: add pt_regs register and stack access APIs
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>
Date: Fri, 08 May 2009 20:49:10 -0400
Message-ID: <20090509004910.5505.23345.stgit@localhost.localdomain>
In-Reply-To: <20090509004829.5505.38720.stgit@localhost.localdomain>
References: <20090509004829.5505.38720.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add following APIs for accessing registers and stack entries from pt_regs.

- query_register_offset(const char *name)
   Query the offset of "name" register.

- query_register_name(unsigned offset)
   Query the name of register by its offset.

- get_register(struct pt_regs *regs, unsigned offset)
   Get the value of a register by its offset.

- valid_stack_address(struct pt_regs *regs, unsigned long addr)
   Check the address is in the stack.

- get_stack_nth(struct pt_regs *reg, unsigned nth)
   Get Nth entry of the stack. (N >= 0)

- get_argument_nth(struct pt_regs *reg, unsigned nth)
   Get Nth argument at function call. (N >= 0)


Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
---

 arch/x86/include/asm/ptrace.h |   66 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/ptrace.c      |   60 +++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 90b76b3..c316b85 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -7,6 +7,7 @@
 
 #ifdef __KERNEL__
 #include <asm/segment.h>
+#include <asm/page_types.h>
 #endif
 
 #ifndef __ASSEMBLY__
@@ -215,6 +216,71 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 	return regs->sp;
 }
 
+/* Query offset/name of register from its name/offset */
+extern int query_register_offset(const char *name);
+extern const char *query_register_name(unsigned offset);
+#define MAX_REG_OFFSET (offsetof(struct pt_regs, ss))
+
+/* Get register value from its offset */
+static inline unsigned long get_register(struct pt_regs *regs, unsigned offset)
+{
+	if (unlikely(offset > MAX_REG_OFFSET))
+		return 0;
+	return *(unsigned long *)((unsigned long)regs + offset);
+}
+
+/* Check the address in the stack */
+static inline int valid_stack_address(struct pt_regs *regs, unsigned long addr)
+{
+	return ((addr & ~(THREAD_SIZE - 1))  ==
+		(kernel_trap_sp(regs) & ~(THREAD_SIZE - 1)));
+}
+
+/* Get Nth entry of the stack */
+static inline unsigned long get_stack_nth(struct pt_regs *regs, unsigned n)
+{
+	unsigned long *addr = (unsigned long *)kernel_trap_sp(regs);
+	addr += n;
+	if (valid_stack_address(regs, (unsigned long)addr))
+		return *addr;
+	else
+		return 0;
+}
+
+/* Get Nth argument at function call */
+static inline unsigned long get_argument_nth(struct pt_regs *regs, unsigned n)
+{
+#ifdef CONFIG_X86_32
+#define NR_REGPARMS 3
+	if (n < NR_REGPARMS) {
+		switch (n) {
+		case 0: return regs->ax;
+		case 1: return regs->dx;
+		case 2: return regs->cx;
+		}
+		return 0;
+#else /* CONFIG_X86_64 */
+#define NR_REGPARMS 6
+	if (n < NR_REGPARMS) {
+		switch (n) {
+		case 0: return regs->di;
+		case 1: return regs->si;
+		case 2: return regs->dx;
+		case 3: return regs->cx;
+		case 4: return regs->r8;
+		case 5: return regs->r9;
+		}
+		return 0;
+#endif
+	} else {
+		/*
+		 * The typical case: arg n is on the stack.
+		 * (Note: stack[0] = return address, so skip it)
+		 */
+		return get_stack_nth(regs, 1 + n - NR_REGPARMS);
+	}
+}
+
 /*
  * These are defined as per linux/ptrace.h, which see.
  */
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 09ecbde..00eb9d7 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -48,6 +48,66 @@ enum x86_regset {
 	REGSET_IOPERM32,
 };
 
+struct pt_regs_offset {
+	const char *name;
+	int offset;
+};
+
+#define REG_OFFSET(r) offsetof(struct pt_regs, r)
+#define REG_OFFSET_NAME(r) {.name = #r, .offset = REG_OFFSET(r)}
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
+int query_register_offset(const char *name)
+{
+	const struct pt_regs_offset *roff;
+	for (roff = regoffset_table; roff->name != NULL; roff++)
+		if (!strcmp(roff->name, name))
+			return roff->offset;
+	return -EINVAL;
+}
+
+const char *query_register_name(unsigned offset)
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
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
