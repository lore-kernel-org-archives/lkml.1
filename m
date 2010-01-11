Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387Ab0AKMZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0AKMZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373Ab0AKMZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:25:38 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50538 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0AKMZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:25:35 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jan 2010 17:55:29 +0530
Message-Id: <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
In-Reply-To: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
Subject: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User Space Breakpoint Assistance Layer (UBP)

User space breakpointing Infrastructure provides kernel subsystems
with architecture independent interface to establish breakpoints in
user applications. This patch provides core implementation of ubp and
also wrappers for architecture dependent methods.

UBP currently supports both single stepping inline and execution out
of line strategies. Two different probepoints in the same process can
have two different strategies.

You need to follow this up with the UBP patch for your architecture.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/Kconfig        |   12 +
 include/linux/ubp.h |  282 ++++++++++++++++++++++++++++++
 kernel/Makefile     |    1 
 kernel/ubp_core.c   |  479 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 774 insertions(+)

Index: new_uprobes.git/arch/Kconfig
===================================================================
--- new_uprobes.git.orig/arch/Kconfig
+++ new_uprobes.git/arch/Kconfig
@@ -57,6 +57,15 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config UBP
+	bool "User-space breakpoint assistance (EXPERIMENTAL)"
+	depends on MODULES
+	depends on HAVE_UBP
+	help
+	  Ubp enables kernel subsystems to establish breakpoints
+	  in user applications. This service is used by components
+	  such as uprobes. If in doubt, say "N".
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
@@ -90,6 +99,9 @@ config USER_RETURN_NOTIFIER
 	  Provide a kernel-internal notification when a cpu is about to
 	  switch to user mode.
 
+config HAVE_UBP
+	def_bool n
+
 config HAVE_IOREMAP_PROT
 	bool
 
Index: new_uprobes.git/include/linux/ubp.h
===================================================================
--- /dev/null
+++ new_uprobes.git/include/linux/ubp.h
@@ -0,0 +1,282 @@
+#ifndef _LINUX_UBP_H
+#define _LINUX_UBP_H
+/*
+ * User-space BreakPoint support (ubp)
+ * include/linux/ubp.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2008, 2009
+ */
+
+#include <asm/ubp.h>
+struct task_struct;
+struct pt_regs;
+
+/**
+ * Strategy hints:
+ *
+ * %UBP_HNT_INLINE: Specifies that the instruction must
+ * be single-stepped inline.  Can be set by the caller of
+ * @arch->analyze_insn() -- e.g., if caller is out of XOL slots --
+ * or by @arch->analyze_insn() if there's no viable XOL strategy
+ * for that instruction.  Set in arch->strategies if the architecture
+ * doesn't implement XOL.
+ *
+ * %UBP_HNT_PERMSL: Specifies that the instruction slot whose
+ * address is @ubp->xol_vaddr is assigned to @ubp for the life of
+ * the process.  Can be used by @arch->analyze_insn() to simplify
+ * XOL in some cases.  Ignored in @arch->strategies.
+ *
+ * %UBP_HNT_TSKINFO: Set in @arch->strategies if the architecture's
+ * XOL handling requires the preservation of special
+ * task-specific info between the calls to @arch->pre_xol()
+ * and @arch->post_xol().  (E.g., XOL of x86_64 rip-relative
+ * instructions uses a scratch register, whose value is saved
+ * by pre_xol() and restored by post_xol().)  The caller
+ * of @arch->analyze_insn() should set %UBP_HNT_TSKINFO in
+ * @ubp->strategy if it's set in @arch->strategies and the caller
+ * can maintain a @ubp_task_arch_info object for each probed task.
+ * @arch->analyze_insn() should leave this flag set in @ubp->strategy
+ * if it needs to use the per-task @ubp_task_arch_info object.
+ */
+#define UBP_HNT_INLINE	0x1  /* Single-step this insn inline. */
+#define UBP_HNT_TSKINFO 0x2  /* XOL requires ubp_task_arch_info */
+#define UBP_HNT_PERMSL	0x4  /* XOL slot assignment is permanent */
+
+#define UBP_HNT_MASK	0x7
+
+/**
+ * struct ubp_bkpt - user-space breakpoint/probepoint
+ *
+ * @vaddr:	virtual address of probepoint
+ * @xol_vaddr:	virtual address of XOL slot assigned to this probepoint
+ * @opcode:	copy of opcode at @vaddr
+ * @insn:	typically a copy of the instruction at @vaddr.  More
+ *	precisely, this is the instruction (stream) that will be
+ *	executed in place of the original instruction.
+ * @strategy:	hints about how this instruction will be executed
+ * @fixups:	set of fixups to be executed by @arch->post_xol()
+ * @arch_info:	architecture-specific info about this probepoint
+ */
+struct ubp_bkpt {
+	unsigned long vaddr;
+	unsigned long xol_vaddr;
+	ubp_opcode_t opcode;
+	u8 insn[UBP_XOL_SLOT_BYTES];
+	u16 strategy;
+	u16 fixups;
+	struct ubp_bkpt_arch_info arch_info;
+};
+
+/* Post-execution fixups.  Some architectures may define others. */
+#define UPB_FIX_NONE	0x0  /* No fixup needed */
+#define UBP_FIX_IP	0x1  /* Adjust IP back to vicinity of actual insn */
+#define UBP_FIX_CALL	0x2  /* Adjust the return address of a call insn */
+
+#ifndef UPB_FIX_DEFAULT
+#define UPB_FIX_DEFAULT UBP_FIX_IP
+#endif
+
+#if defined(CONFIG_UBP)
+extern int ubp_init(u16 *strategies);
+extern int ubp_insert_bkpt(struct task_struct *tsk, struct ubp_bkpt *ubp);
+extern unsigned long ubp_get_bkpt_addr(struct pt_regs *regs);
+extern int ubp_pre_sstep(struct task_struct *tsk, struct ubp_bkpt *ubp,
+		struct ubp_task_arch_info *tskinfo, struct pt_regs *regs);
+extern int ubp_post_sstep(struct task_struct *tsk, struct ubp_bkpt *ubp,
+		struct ubp_task_arch_info *tskinfo, struct pt_regs *regs);
+extern int ubp_cancel_xol(struct task_struct *tsk, struct ubp_bkpt *ubp);
+extern int ubp_remove_bkpt(struct task_struct *tsk, struct ubp_bkpt *ubp);
+extern int ubp_validate_insn_addr(struct task_struct *tsk,
+						unsigned long vaddr);
+extern void ubp_set_ip(struct pt_regs *regs, unsigned long vaddr);
+#else	/* CONFIG_UBP */
+static inline int ubp_init(u16 *strategies)
+{
+	return -ENOSYS;
+}
+static inline int ubp_insert_bkpt(struct task_struct *tsk,
+						struct ubp_bkpt *ubp)
+{
+	return -ENOSYS;
+}
+static inline unsigned long ubp_get_bkpt_addr(struct pt_regs *regs)
+{
+	return -ENOSYS;
+}
+static inline int ubp_pre_sstep(struct task_struct *tsk,
+	struct ubp_bkpt *ubp, struct ubp_task_arch_info *tskinfo,
+	struct pt_regs *regs)
+{
+	return -ENOSYS;
+}
+static inline int ubp_post_sstep(struct task_struct *tsk,
+	struct ubp_bkpt *ubp, struct ubp_task_arch_info *tskinfo,
+	struct pt_regs *regs)
+{
+	return -ENOSYS;
+}
+static inline int ubp_cancel_xol(struct task_struct *tsk,
+	struct ubp_bkpt *ubp)
+{
+	return -ENOSYS;
+}
+static inline int ubp_remove_bkpt(struct task_struct *tsk,
+	struct ubp_bkpt *ubp)
+{
+	return -ENOSYS;
+}
+static inline int ubp_validate_insn_addr(struct task_struct *tsk,
+	unsigned long vaddr)
+{
+	return -ENOSYS;
+}
+static inline void ubp_set_ip(struct pt_regs *regs, unsigned long vaddr)
+{
+}
+#endif	/* CONFIG_UBP */
+
+#ifdef UBP_IMPLEMENTATION
+/**
+ * struct ubp_arch_info - architecture-specific parameters and functions
+ *
+ * Most architectures can use the default versions of @read_opcode(),
+ * @set_bkpt(), @set_orig_insn(), and @is_bkpt_insn(); ia64 is an
+ * exception.  All functions (including @validate_address()) can assume
+ * that the caller has verified that the probepoint's virtual address
+ * resides in an executable VM area.
+ *
+ * @bkpt_insn:
+ *	The architecture's breakpoint instruction.  This is used by
+ *	the default versions of @set_bkpt(), @set_orig_insn(), and
+ *	@is_bkpt_insn().
+ * @ip_advancement_by_bkpt_insn:
+ * 	The number of bytes the instruction pointer is advanced by
+ * 	this architecture's breakpoint instruction.  For example, after
+ * 	the powerpc trap instruction executes, the ip still points to the
+ * 	breakpoint instruction (ip_advancement_by_bkpt_insn = 0); but the
+ * 	x86 int3 instruction (1 byte) advances the ip past the int3
+ * 	(ip_advancement_by_bkpt_insn = 1).
+ * @max_insn_bytes:
+ *	The maximum length, in bytes, of an instruction in this
+ *	architecture.  This must be <= UBP_XOL_SLOT_BYTES;
+ * @strategies:
+ *	Bit-map of %UBP_HNT_* values recognized by this architecture.
+ *	Include %UBP_HNT_INLINE iff this architecture doesn't support
+ *	execution out of line.  Include %UBP_HNT_TSKINFO if
+ *	XOL of at least some instructions requires communication of
+ *	per-task state between @pre_xol() and @post_xol().
+ * @set_ip:
+ *	Set the instruction pointer in @regs to @vaddr.
+ * @validate_address:
+ *	Return 0 if @vaddr is a valid instruction address, or a negative
+ *	errno (typically -%EINVAL) otherwise.  If you don't provide
+ *	@validate_address(), any address will be accepted.  Caller
+ *	guarantees that @vaddr is in an executable VM area.  This
+ *	function typically just enforces arch-specific instruction
+ *	alignment.
+ * @read_opcode:
+ *	For task @tsk, read the opcode at @vaddr and store it in
+ *	@opcode.  Return 0 (success) or a negative errno.  Defaults to
+ *	@ubp_read_opcode().
+ * @set_bkpt:
+ *	For task @tsk, store @bkpt_insn at @ubp->vaddr.  Return 0
+ *	(success) or a negative errno. Defaults to @ubp_set_bkpt().
+ * @set_orig_insn:
+ *	For task @tsk, restore the original opcode (@ubp->opcode) at
+ *	@ubp->vaddr.  If @check is true, first verify that there's
+ *	actually a breakpoint instruction there.  Return 0 (success) or
+ *	a negative errno.  Defaults to @ubp_set_orig_insn().
+ * @is_bkpt_insn:
+ *	Return %true if @ubp->opcode is @bkpt_insn.  Defaults to
+ *	@ubp_is_bkpt_insn(), which just tests (ubp->opcode ==
+ *	arch->bkpt_insn).
+ * @analyze_insn:
+ *	Analyze @ubp->insn.  Return 0 if @ubp->insn is an instruction
+ *	you can probe, or a negative errno (typically -%EPERM)
+ *	otherwise.  The caller sets @ubp->strategy to %UBP_HNT_INLINE
+ *	to suppress XOL for this instruction (e.g., because we're
+ *	out of XOL slots).  If the instruction can be probed but
+ *	can't be executed out of line, set @ubp->strategy to
+ *	%UBP_HNT_INLINE.  Otherwise, determine what sort of XOL-related
+ *	fixups @post_xol() (and possibly @pre_xol()) will need
+ *	to do for this instruction, and annotate @ubp accordingly.
+ *	You may modify @ubp->insn (e.g., the x86_64 port does this
+ *	for rip-relative instructions), but if you do so, you should
+ *	retain a copy in @ubp->arch_info in case you have to revert
+ *	to single-stepping inline (see @cancel_xol()).
+ * @pre_xol:
+ *	Called just before executing the instruction associated
+ *	with @ubp out of line.  @ubp->xol_vaddr is the address in
+ *	@tsk's virtual address space where @ubp->insn has been copied.
+ *	@pre_xol() should at least set the instruction pointer in
+ *	@regs to @ubp->xol_vaddr -- which is what the default,
+ *	@ubp_pre_xol(), does.  If @ubp->strategy includes the
+ *	%UBP_HNT_TSKINFO flag, then @tskinfo points to a per-task
+ *	copy of struct ubp_task_arch_info.
+ * @post_xol:
+ *	Called after executing the instruction associated with
+ *	@ubp out of line.  @post_xol() should perform the fixups
+ *	specified in @ubp->fixups, which includes ensuring that the
+ *	instruction pointer in @regs points at the next instruction in
+ *	the probed instruction stream.  @tskinfo is as for @pre_xol().
+ *	You must provide this function.
+ * @cancel_xol:
+ *	The instruction associated with @ubp cannot be executed
+ *	out of line after all.  (This can happen when XOL slots
+ *	are lazily assigned, and we run out of slots before we
+ *	hit this breakpoint.  This function should never be called
+ *	if @analyze_insn() was previously called for @ubp with a
+ *	non-zero value of @ubp->xol_vaddr and with %UBP_HNT_PERMSL
+ *	set in @ubp->strategy.)  Adjust @ubp as needed so it can be
+ *	single-stepped inline.  Omit this function if you don't need it.
+ */
+
+struct ubp_arch_info {
+	ubp_opcode_t bkpt_insn;
+	u8 ip_advancement_by_bkpt_insn;
+	u8 max_insn_bytes;
+	u16 strategies;
+	void (*set_ip)(struct pt_regs *regs, unsigned long vaddr);
+	int (*validate_address)(struct task_struct *tsk, unsigned long vaddr);
+	int (*read_opcode)(struct task_struct *tsk, unsigned long vaddr,
+						ubp_opcode_t *opcode);
+	int (*set_bkpt)(struct task_struct *tsk, struct ubp_bkpt *ubp);
+	int (*set_orig_insn)(struct task_struct *tsk,
+				struct ubp_bkpt *ubp, bool check);
+	bool (*is_bkpt_insn)(struct ubp_bkpt *ubp);
+	int (*analyze_insn)(struct task_struct *tsk, struct ubp_bkpt *ubp);
+	int (*pre_xol)(struct task_struct *tsk, struct ubp_bkpt *ubp,
+				struct ubp_task_arch_info *tskinfo,
+				struct pt_regs *regs);
+	int (*post_xol)(struct task_struct *tsk, struct ubp_bkpt *ubp,
+				struct ubp_task_arch_info *tskinfo,
+				struct pt_regs *regs);
+	void (*cancel_xol)(struct task_struct *tsk, struct ubp_bkpt *ubp);
+};
+
+/* Unexported functions & macros for use by arch-specific code */
+#define ubp_opcode_sz ((unsigned int)(sizeof(ubp_opcode_t)))
+extern int ubp_read_vm(struct task_struct *tsk, unsigned long vaddr,
+						void *kbuf, int nbytes);
+extern int ubp_write_data(struct task_struct *tsk, unsigned long vaddr,
+					const void *kbuf, int nbytes);
+
+extern struct ubp_arch_info ubp_arch_info;
+
+#endif	/* UBP_IMPLEMENTATION */
+
+#endif	/* _LINUX_UBP_H */
Index: new_uprobes.git/kernel/Makefile
===================================================================
--- new_uprobes.git.orig/kernel/Makefile
+++ new_uprobes.git/kernel/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_SLOW_WORK_DEBUG) += slow-wo
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
+obj-$(CONFIG_UBP) += ubp_core.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: new_uprobes.git/kernel/ubp_core.c
===================================================================
--- /dev/null
+++ new_uprobes.git/kernel/ubp_core.c
@@ -0,0 +1,479 @@
+/*
+ * User-space BreakPoint support (ubp)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2008, 2009
+ */
+
+#define UBP_IMPLEMENTATION 1
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/ptrace.h>
+#include <linux/mm.h>
+#include <linux/ubp.h>
+#include <linux/uaccess.h>
+
+/*
+ * TODO: Resolve verbosity.  ubp_insert_bkpt() is the only function
+ * that reports failures via printk.
+ */
+
+static struct ubp_arch_info *arch = &ubp_arch_info;
+
+static bool ubp_uses_xol(u16 strategy)
+{
+	return !(strategy & UBP_HNT_INLINE);
+}
+
+static bool validate_strategy(u16 strategy, u16 valid_bits)
+{
+	return ((strategy & (~valid_bits)) == 0);
+}
+
+/**
+ * ubp_init - initialize the ubp data structures
+ * @strategies indicates which breakpoint-related strategies are
+ * supported by the client:
+ *   %UBP_HNT_INLINE: Client supports only single-stepping inline.
+ *	Otherwise client must provide an instruction slot
+ *	(UBP_XOL_SLOT_BYTES bytes) in the probed process's address
+ *	space for each instruction to be executed out of line.
+ *   %UBP_HNT_TSKINFO: Client can provide and maintain one
+ *	@ubp_task_arch_info object for each probed task.  (Failure to
+ *	support this will prevent XOL of rip-relative instructions on
+ *	x86_64, at least.)
+ * Upon return, @strategies is updated to reflect those strategies
+ * required by this particular architecture's implementation of ubp:
+ *   %UBP_HNT_INLINE: Architecture or client supports only
+ *	single-stepping inline.
+ *   %UBP_HNT_TSKINFO: Architecture uses @ubp_task_arch_info, and will
+ *	expect it to be passed to @ubp_pre_sstep() and @ubp_post_sstep()
+ *	as needed (see @ubp_insert_bkpt()).
+ * Possible errors:
+ * -%ENOSYS: ubp not supported for this architecture.
+ * -%EINVAL: unrecognized flags in @strategies
+ */
+int ubp_init(u16 *strategies)
+{
+	u16 inline_bit, tskinfo_bit;
+	u16 client_strategies = *strategies;
+
+	if (!validate_strategy(client_strategies,
+				UBP_HNT_INLINE | UBP_HNT_TSKINFO))
+		return -EINVAL;
+
+	inline_bit = (client_strategies | arch->strategies) & UBP_HNT_INLINE;
+	tskinfo_bit = (client_strategies & arch->strategies) & UBP_HNT_TSKINFO;
+	*strategies = (inline_bit | tskinfo_bit);
+	return 0;
+}
+
+/*
+ * Read @nbytes at @vaddr from @tsk into @kbuf.  Return number of bytes read.
+ * Not exported, but available for use by arch-specific ubp code.
+ */
+int ubp_read_vm(struct task_struct *tsk, unsigned long vaddr,
+						void *kbuf, int nbytes)
+{
+	if (tsk == current) {
+		int nleft = copy_from_user(kbuf, (void __user *) vaddr,
+				nbytes);
+		return nbytes - nleft;
+	} else
+		return access_process_vm(tsk, vaddr, kbuf, nbytes, 0);
+}
+
+/*
+ * Write @nbytes from @kbuf at @vaddr in @tsk.  Return number of bytes written.
+ * Can be used to write to stack or data VM areas, but not instructions.
+ * Not exported, but available for use by arch-specific ubp code.
+ */
+int ubp_write_data(struct task_struct *tsk, unsigned long vaddr,
+						const void *kbuf, int nbytes)
+{
+	int nleft;
+
+	if (tsk == current) {
+		nleft = copy_to_user((void __user *) vaddr, kbuf, nbytes);
+		return nbytes - nleft;
+	} else
+		return access_process_vm(tsk, vaddr, (void *) kbuf,
+				nbytes, 1);
+}
+
+static int ubp_write_opcode(struct task_struct *tsk, unsigned long vaddr,
+							ubp_opcode_t opcode)
+{
+	int result;
+
+	result = access_process_vm(tsk, vaddr, &opcode, ubp_opcode_sz, 1);
+	return (result == ubp_opcode_sz ? 0 : -EFAULT);
+}
+
+/* Default implementation of arch->read_opcode */
+static int ubp_read_opcode(struct task_struct *tsk, unsigned long vaddr,
+							ubp_opcode_t *opcode)
+{
+	int bytes_read;
+
+	bytes_read = ubp_read_vm(tsk, vaddr, opcode, ubp_opcode_sz);
+	return (bytes_read == ubp_opcode_sz ? 0 : -EFAULT);
+}
+
+/* Default implementation of arch->set_bkpt */
+static int ubp_set_bkpt(struct task_struct *tsk, struct ubp_bkpt *ubp)
+{
+	return ubp_write_opcode(tsk, ubp->vaddr, arch->bkpt_insn);
+}
+
+/* Default implementation of arch->set_orig_insn */
+static int ubp_set_orig_insn(struct task_struct *tsk, struct ubp_bkpt *ubp,
+								bool check)
+{
+	if (check) {
+		ubp_opcode_t opcode;
+		int result = arch->read_opcode(tsk, ubp->vaddr, &opcode);
+		if (result)
+			return result;
+		if (opcode != arch->bkpt_insn)
+			return -EINVAL;
+	}
+	return ubp_write_opcode(tsk, ubp->vaddr, ubp->opcode);
+}
+
+/* Return 0 if vaddr is in an executable VM area, or -EINVAL otherwise. */
+static inline int ubp_check_vma(struct task_struct *tsk, unsigned long vaddr)
+{
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+	int ret = -EINVAL;
+
+	mm = get_task_mm(tsk);
+	if (!mm)
+		return -EINVAL;
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, vaddr);
+	if (vma && vaddr >= vma->vm_start && (vma->vm_flags & VM_EXEC))
+		ret = 0;
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	return ret;
+}
+
+/**
+ * ubp_validate_insn_addr - Validate if the instruction is an
+ * executable vma.
+ * Returns 0 if the vaddr is a valid instruction address.
+ * @tsk: the probed task
+ * @vaddr: virtual address of the instruction to be verified.
+ *
+ * Possible errors:
+ * -%EINVAL: Instruction passed is not a valid instruction address.
+ */
+int ubp_validate_insn_addr(struct task_struct *tsk, unsigned long vaddr)
+{
+	int result;
+
+	result = ubp_check_vma(tsk, vaddr);
+	if (result != 0)
+		return result;
+	if (arch->validate_address)
+		result = arch->validate_address(tsk, vaddr);
+	return result;
+}
+
+static void ubp_bkpt_insertion_failed(struct task_struct *tsk,
+				struct ubp_bkpt *ubp, const char *why)
+{
+	printk(KERN_ERR "Can't place breakpoint at pid %d vaddr %#lx: %s\n",
+						tsk->pid, ubp->vaddr, why);
+}
+
+/**
+ * ubp_insert_bkpt - insert breakpoint
+ * Insert a breakpoint into the process that includes @tsk, at the
+ * virtual address @ubp->vaddr.
+ *
+ * @ubp->strategy affects how this breakpoint will be handled:
+ *   %UBP_HNT_INLINE: Probed instruction will be single-stepped inline.
+ *   %UBP_HNT_TSKINFO: As above.
+ *   %UBP_HNT_PERMSL: An XOL instruction slot in the probed process's
+ *	address space has been allocated to this probepoint, and will
+ *	remain so allocated as long as it's needed.  @ubp->xol_vaddr is
+ *	its address.  (This slot can be reallocated if
+ *	@ubp_insert_bkpt() fails.)  The client is NOT required to
+ *	allocate an instruction slot before calling @ubp_insert_bkpt().
+ * @ubp_insert_bkpt() updates @ubp->strategy as needed:
+ *   %UBP_HNT_INLINE: Architecture or client cannot do XOL for this
+ *	probepoint.
+ *   %UBP_HNT_TSKINFO: @ubp_task_arch_info will be used for this
+ *	probepoint.
+ *
+ * All threads of the probed process must be stopped while
+ * @ubp_insert_bkpt() runs.
+ *
+ * Possible errors:
+ * -%ENOSYS: ubp not supported for this architecture
+ * -%EINVAL: unrecognized/invalid strategy flags
+ * -%EINVAL: invalid instruction address
+ * -%EEXIST: breakpoint instruction already exists at that address
+ * -%EPERM: cannot probe this instruction
+ * -%EFAULT: failed to insert breakpoint instruction
+ * [TBD: Validate xol_vaddr?]
+ */
+int ubp_insert_bkpt(struct task_struct *tsk, struct ubp_bkpt *ubp)
+{
+	int result, len;
+
+	BUG_ON(!tsk || !ubp);
+	if (!validate_strategy(ubp->strategy, UBP_HNT_MASK))
+		return -EINVAL;
+
+	result = ubp_validate_insn_addr(tsk, ubp->vaddr);
+	if (result != 0)
+		return result;
+
+	/*
+	 * If ubp_read_vm() transfers fewer bytes than the maximum
+	 * instruction size, assume that the probed instruction is smaller
+	 * than the max and near the end of the last page of instructions.
+	 * But there must be room at least for a breakpoint-size instruction.
+	 */
+	len = ubp_read_vm(tsk, ubp->vaddr, ubp->insn, arch->max_insn_bytes);
+	if (len < ubp_opcode_sz) {
+		ubp_bkpt_insertion_failed(tsk, ubp,
+					"error reading original instruction");
+		return -EFAULT;
+	}
+	memcpy(&ubp->opcode, ubp->insn, ubp_opcode_sz);
+	if (arch->is_bkpt_insn(ubp)) {
+		ubp_bkpt_insertion_failed(tsk, ubp,
+					"bkpt already exists at that addr");
+		return -EEXIST;
+	}
+
+	result = arch->analyze_insn(tsk, ubp);
+	if (result < 0) {
+		ubp_bkpt_insertion_failed(tsk, ubp,
+					"instruction type cannot be probed");
+		return result;
+	}
+
+	result = arch->set_bkpt(tsk, ubp);
+	if (result < 0) {
+		ubp_bkpt_insertion_failed(tsk, ubp,
+					"failed to insert bkpt instruction");
+		return result;
+	}
+	return 0;
+}
+
+/**
+ * ubp_pre_sstep - prepare to single-step the probed instruction
+ * @tsk: the probed task
+ * @ubp: the probepoint information, as returned by @ubp_insert_bkpt().
+ *	Unless the %UBP_HNT_INLINE flag is set in @ubp->strategy,
+ *	@ubp->xol_vaddr must be the address of an XOL instruction slot
+ *	that is allocated to this probepoint at least until after the
+ *	completion of @ubp_post_sstep(), and populated with the contents
+ *	of @ubp->insn.  [Need to be more precise here to account for
+ *	untimely exit or UBP_HNT_BOOSTED.]
+ * @tskinfo: points to a @ubp_task_arch_info object for @tsk, if
+ *	the %UBP_HNT_TSKINFO flag is set in @ubp->strategy.
+ * @regs: reflects the saved user state of @tsk.  @ubp_pre_sstep()
+ *	adjusts this.  In particular, the instruction pointer is set
+ *	to the instruction to be single-stepped.
+ * Possible errors:
+ * -%EFAULT: Failed to read or write @tsk's address space as needed.
+ *
+ * The client must ensure that the contents of @ubp are not
+ * changed during the single-step operation -- i.e., between when
+ * @ubp_pre_sstep() is called and when @ubp_post_sstep() returns.
+ * Additionally, if single-stepping inline is used for this probepoint,
+ * the client must serialize the single-step operation (so multiple
+ * threads don't step on each other while the opcode replacement is
+ * taking place).
+ */
+int ubp_pre_sstep(struct task_struct *tsk, struct ubp_bkpt *ubp,
+		struct ubp_task_arch_info *tskinfo, struct pt_regs *regs)
+{
+	int result;
+
+	BUG_ON(!tsk || !ubp || !regs);
+	if (ubp_uses_xol(ubp->strategy)) {
+		BUG_ON(!ubp->xol_vaddr);
+		return arch->pre_xol(tsk, ubp, tskinfo, regs);
+	}
+
+	/*
+	 * Single-step this instruction inline.  Replace the breakpoint
+	 * with the original opcode.
+	 */
+	result = arch->set_orig_insn(tsk, ubp, false);
+	if (result == 0)
+		arch->set_ip(regs, ubp->vaddr);
+	return result;
+}
+
+/**
+ * ubp_post_sstep - prepare to resume execution after single-step
+ * @tsk: the probed task
+ * @ubp: the probepoint information, as with @ubp_pre_sstep()
+ * @tskinfo: the @ubp_task_arch_info object, if any, passed to
+ *	@ubp_pre_sstep()
+ * @regs: reflects the saved state of @tsk after the single-step
+ *	operation.  @ubp_post_sstep() adjusts @tsk's state as needed,
+ *	including pointing the instruction pointer at the instruction
+ *	following the probed instruction.
+ * Possible errors:
+ * -%EFAULT: Failed to read or write @tsk's address space as needed.
+ */
+int ubp_post_sstep(struct task_struct *tsk, struct ubp_bkpt *ubp,
+		struct ubp_task_arch_info *tskinfo, struct pt_regs *regs)
+{
+	BUG_ON(!tsk || !ubp || !regs);
+	if (ubp_uses_xol(ubp->strategy))
+		return arch->post_xol(tsk, ubp, tskinfo, regs);
+
+	/*
+	 * Single-stepped this instruction inline.  Put the breakpoint
+	 * instruction back.
+	 */
+	return arch->set_bkpt(tsk, ubp);
+}
+
+/**
+ * ubp_cancel_xol - cancel XOL for this probepoint
+ * @tsk: a task in the probed process
+ * @ubp: the probepoint information
+ * Switch @ubp's single-stepping strategy from out-of-line to inline.
+ * If the client employs lazy XOL-slot allocation, it can call
+ * this function if it determines that it can't provide an XOL
+ * slot for @ubp.  @ubp_cancel_xol() adjusts @ubp appropriately.
+ *
+ * @ubp_cancel_xol()'s behavior is undefined if @ubp_pre_sstep() has
+ * already been called for @ubp.
+ *
+ * Possible errors:
+ * Can't think of any yet.
+ */
+int ubp_cancel_xol(struct task_struct *tsk, struct ubp_bkpt *ubp)
+{
+	if (arch->cancel_xol)
+		arch->cancel_xol(tsk, ubp);
+	ubp->strategy |= UBP_HNT_INLINE;
+	return 0;
+}
+
+/**
+ * ubp_get_bkpt_addr - compute address of bkpt given post-bkpt regs
+ * @regs: Reflects the saved state of the task after it has hit a breakpoint
+ * instruction.  Return the address of the breakpoint instruction.
+ */
+unsigned long ubp_get_bkpt_addr(struct pt_regs *regs)
+{
+	return instruction_pointer(regs) - arch->ip_advancement_by_bkpt_insn;
+}
+
+/**
+ * ubp_remove_bkpt - remove breakpoint
+ * For the process that includes @tsk, remove the breakpoint specified
+ * by @ubp, restoring the original opcode.
+ *
+ * Possible errors:
+ * -%EINVAL: @ubp->vaddr is not a valid instruction address.
+ * -%ENOENT: There is no breakpoint instruction at @ubp->vaddr.
+ * -%EFAULT: Failed to read/write @tsk's address space as needed.
+ */
+int ubp_remove_bkpt(struct task_struct *tsk, struct ubp_bkpt *ubp)
+{
+	if (ubp_validate_insn_addr(tsk, ubp->vaddr) != 0)
+		return -EINVAL;
+	return arch->set_orig_insn(tsk, ubp, true);
+}
+
+void ubp_set_ip(struct pt_regs *regs, unsigned long vaddr)
+{
+	arch->set_ip(regs, vaddr);
+}
+
+/* Default implementation of arch->is_bkpt_insn */
+static bool ubp_is_bkpt_insn(struct ubp_bkpt *ubp)
+{
+	return (ubp->opcode == arch->bkpt_insn);
+}
+
+/* Default implementation of arch->pre_xol */
+static int ubp_pre_xol(struct task_struct *tsk, struct ubp_bkpt *ubp,
+		struct ubp_task_arch_info *tskinfo, struct pt_regs *regs)
+{
+	arch->set_ip(regs, ubp->xol_vaddr);
+	return 0;
+}
+
+/* Validate arch-specific info during ubp initialization. */
+
+static int ubp_bad_arch_param(const char *param_name, int value)
+{
+	printk(KERN_ERR "ubp: bad value %d/%#x for parameter %s"
+		" in ubp_arch_info\n", value, value, param_name);
+	return -ENOSYS;
+}
+
+static int ubp_missing_arch_func(const char *func_name)
+{
+	printk(KERN_ERR "ubp: ubp_arch_info lacks required function: %s\n",
+								func_name);
+	return -ENOSYS;
+}
+
+static int __init init_ubp(void)
+{
+	int result = 0;
+
+	/* Accept any value of bkpt_insn. */
+	if (arch->max_insn_bytes < 1)
+		result = ubp_bad_arch_param("max_insn_bytes",
+						arch->max_insn_bytes);
+	if (arch->ip_advancement_by_bkpt_insn > arch->max_insn_bytes)
+		result = ubp_bad_arch_param("ip_advancement_by_bkpt_insn",
+					arch->ip_advancement_by_bkpt_insn);
+	/* Accept any value of strategies. */
+	if (!arch->set_ip)
+		result = ubp_missing_arch_func("set_ip");
+	/* Null validate_address() is OK. */
+	if (!arch->read_opcode)
+		arch->read_opcode = ubp_read_opcode;
+	if (!arch->set_bkpt)
+		arch->set_bkpt = ubp_set_bkpt;
+	if (!arch->set_orig_insn)
+		arch->set_orig_insn = ubp_set_orig_insn;
+	if (!arch->is_bkpt_insn)
+		arch->is_bkpt_insn = ubp_is_bkpt_insn;
+	if (!arch->analyze_insn)
+		result = ubp_missing_arch_func("analyze_insn");
+	if (!arch->pre_xol)
+		arch->pre_xol = ubp_pre_xol;
+	if (ubp_uses_xol(arch->strategies) && !arch->post_xol)
+		result = ubp_missing_arch_func("post_xol");
+	/* Null cancel_xol() is OK. */
+	return result;
+}
+
+module_init(init_ubp);
