Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbXLTLzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbXLTLzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbXLTLyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:54:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759436AbXLTLyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:54:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 01/43] user_regset header
Message-Id: <20071220115357.D1E1326F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:53:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new header <linux/regset.h> defines the types struct user_regset and
struct user_regset_view, with some associated declarations.  This new set
of interfaces will become the standard way for arch code to expose
user-mode machine-specific state.  A single set of entry points into arch
code can do all the low-level work in one place to fill the needs of core
dumps, ptrace, and any other user-mode debugging facilities that might come
along in the future.

For existing arch code to adapt to the user_regset interfaces, each arch
can work from the code it already has to support core files and ptrace.
The formats you want for user_regset are the core file formats.  The only
wrinkle in adapting old ptrace implementation code as user_regset get and
set functions is that these functions can be called on current as well as
on another task_struct that is stopped and switched out as for ptrace.
For some kinds of machine state, you may have to load it directly from CPU
registers or otherwise differently for current than for another thread.
(Your core dump support already handles this in elf_core_copy_regs for
current and elf_core_copy_task_regs for other tasks, so just check there.)
The set function should also be made to work on current in case that
entails some special cases, though this was never required before for
ptrace.  Adding this flexibility covers the arch needs to open the door to
more sophisticated new debugging facilities that don't always need to
context-switch to do every little thing.

The copyin/copyout helper functions (in a later patch) relieve the arch
code of most of the cumbersome details of the flexible get/set interfaces.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/regset.h |  206 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 206 insertions(+), 0 deletions(-)

diff --git a/include/linux/regset.h b/include/linux/regset.h
new file mode 100644
index 0000000..85d0fb0
--- /dev/null
+++ b/include/linux/regset.h
@@ -0,0 +1,206 @@
+/*
+ * User-mode machine state access
+ *
+ * Copyright (C) 2007 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * Red Hat Author: Roland McGrath.
+ */
+
+#ifndef _LINUX_REGSET_H
+#define _LINUX_REGSET_H	1
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+struct task_struct;
+struct user_regset;
+
+
+/**
+ * user_regset_active_fn - type of @active function in &struct user_regset
+ * @target:	thread being examined
+ * @regset:	regset being examined
+ *
+ * Return -%ENODEV if not available on the hardware found.
+ * Return %0 if no interesting state in this thread.
+ * Return >%0 number of @size units of interesting state.
+ * Any get call fetching state beyond that number will
+ * see the default initialization state for this data,
+ * so a caller that knows what the default state is need
+ * not copy it all out.
+ * This call is optional; the pointer is %NULL if there
+ * is no inexpensive check to yield a value < @n.
+ */
+typedef int user_regset_active_fn(struct task_struct *target,
+				  const struct user_regset *regset);
+
+/**
+ * user_regset_get_fn - type of @get function in &struct user_regset
+ * @target:	thread being examined
+ * @regset:	regset being examined
+ * @pos:	offset into the regset data to access, in bytes
+ * @count:	amount of data to copy, in bytes
+ * @kbuf:	if not %NULL, a kernel-space pointer to copy into
+ * @ubuf:	if @kbuf is %NULL, a user-space pointer to copy into
+ *
+ * Fetch register values.  Return %0 on success; -%EIO or -%ENODEV
+ * are usual failure returns.  The @pos and @count values are in
+ * bytes, but must be properly aligned.  If @kbuf is non-null, that
+ * buffer is used and @ubuf is ignored.  If @kbuf is %NULL, then
+ * ubuf gives a userland pointer to access directly, and an -%EFAULT
+ * return value is possible.
+ */
+typedef int user_regset_get_fn(struct task_struct *target,
+			       const struct user_regset *regset,
+			       unsigned int pos, unsigned int count,
+			       void *kbuf, void __user *ubuf);
+
+/**
+ * user_regset_set_fn - type of @set function in &struct user_regset
+ * @target:	thread being examined
+ * @regset:	regset being examined
+ * @pos:	offset into the regset data to access, in bytes
+ * @count:	amount of data to copy, in bytes
+ * @kbuf:	if not %NULL, a kernel-space pointer to copy from
+ * @ubuf:	if @kbuf is %NULL, a user-space pointer to copy from
+ *
+ * Store register values.  Return %0 on success; -%EIO or -%ENODEV
+ * are usual failure returns.  The @pos and @count values are in
+ * bytes, but must be properly aligned.  If @kbuf is non-null, that
+ * buffer is used and @ubuf is ignored.  If @kbuf is %NULL, then
+ * ubuf gives a userland pointer to access directly, and an -%EFAULT
+ * return value is possible.
+ */
+typedef int user_regset_set_fn(struct task_struct *target,
+			       const struct user_regset *regset,
+			       unsigned int pos, unsigned int count,
+			       const void *kbuf, const void __user *ubuf);
+
+/**
+ * user_regset_writeback_fn - type of @writeback function in &struct user_regset
+ * @target:	thread being examined
+ * @regset:	regset being examined
+ * @immediate:	zero if writeback at completion of next context switch is OK
+ *
+ * This call is optional; usually the pointer is %NULL.  When
+ * provided, there is some user memory associated with this regset's
+ * hardware, such as memory backing cached register data on register
+ * window machines; the regset's data controls what user memory is
+ * used (e.g. via the stack pointer value).
+ *
+ * Write register data back to user memory.  If the @immediate flag
+ * is nonzero, it must be written to the user memory so uaccess or
+ * access_process_vm() can see it when this call returns; if zero,
+ * then it must be written back by the time the task completes a
+ * context switch (as synchronized with wait_task_inactive()).
+ * Return %0 on success or if there was nothing to do, -%EFAULT for
+ * a memory problem (bad stack pointer or whatever), or -%EIO for a
+ * hardware problem.
+ */
+typedef int user_regset_writeback_fn(struct task_struct *target,
+				     const struct user_regset *regset,
+				     int immediate);
+
+/**
+ * struct user_regset - accessible thread CPU state
+ * @n:			Number of slots (registers).
+ * @size:		Size in bytes of a slot (register).
+ * @align:		Required alignment, in bytes.
+ * @bias:		Bias from natural indexing.
+ * @core_note_type:	ELF note @n_type value used in core dumps.
+ * @get:		Function to fetch values.
+ * @set:		Function to store values.
+ * @active:		Function to report if regset is active, or %NULL.
+ * @writeback:		Function to write data back to user memory, or %NULL.
+ *
+ * This data structure describes a machine resource we call a register set.
+ * This is part of the state of an individual thread, not necessarily
+ * actual CPU registers per se.  A register set consists of a number of
+ * similar slots, given by @n.  Each slot is @size bytes, and aligned to
+ * @align bytes (which is at least @size).
+ *
+ * These functions must be called only on the current thread or on a
+ * thread that is in %TASK_STOPPED or %TASK_TRACED state, that we are
+ * guaranteed will not be woken up and return to user mode, and that we
+ * have called wait_task_inactive() on.  (The target thread always might
+ * wake up for SIGKILL while these functions are working, in which case
+ * that thread's user_regset state might be scrambled.)
+ *
+ * The @pos argument must be aligned according to @align; the @count
+ * argument must be a multiple of @size.  These functions are not
+ * responsible for checking for invalid arguments.
+ *
+ * When there is a natural value to use as an index, @bias gives the
+ * difference between the natural index and the slot index for the
+ * register set.  For example, x86 GDT segment descriptors form a regset;
+ * the segment selector produces a natural index, but only a subset of
+ * that index space is available as a regset (the TLS slots); subtracting
+ * @bias from a segment selector index value computes the regset slot.
+ *
+ * If nonzero, @core_note_type gives the n_type field (NT_* value)
+ * of the core file note in which this regset's data appears.
+ * NT_PRSTATUS is a special case in that the regset data starts at
+ * offsetof(struct elf_prstatus, pr_reg) into the note data; that is
+ * part of the per-machine ELF formats userland knows about.  In
+ * other cases, the core file note contains exactly the whole regset
+ * (@n * @size) and nothing else.  The core file note is normally
+ * omitted when there is an @active function and it returns zero.
+ */
+struct user_regset {
+	user_regset_get_fn		*get;
+	user_regset_set_fn		*set;
+	user_regset_active_fn		*active;
+	user_regset_writeback_fn	*writeback;
+	unsigned int			n;
+	unsigned int 			size;
+	unsigned int 			align;
+	unsigned int 			bias;
+	unsigned int 			core_note_type;
+};
+
+/**
+ * struct user_regset_view - available regsets
+ * @name:	Identifier, e.g. UTS_MACHINE string.
+ * @regsets:	Array of @n regsets available in this view.
+ * @n:		Number of elements in @regsets.
+ * @e_machine:	ELF header @e_machine %EM_* value written in core dumps.
+ * @e_flags:	ELF header @e_flags value written in core dumps.
+ * @ei_osabi:	ELF header @e_ident[%EI_OSABI] value written in core dumps.
+ *
+ * A regset view is a collection of regsets (&struct user_regset,
+ * above).  This describes all the state of a thread that can be seen
+ * from a given architecture/ABI environment.  More than one view might
+ * refer to the same &struct user_regset, or more than one regset
+ * might refer to the same machine-specific state in the thread.  For
+ * example, a 32-bit thread's state could be examined from the 32-bit
+ * view or from the 64-bit view.  Either method reaches the same thread
+ * register state, doing appropriate widening or truncation.
+ */
+struct user_regset_view {
+	const char *name;
+	const struct user_regset *regsets;
+	unsigned int n;
+	u32 e_flags;
+	u16 e_machine;
+	u8 ei_osabi;
+};
+
+/*
+ * This is documented here rather than at the definition sites because its
+ * implementation is machine-dependent but its interface is universal.
+ */
+/**
+ * task_user_regset_view - Return the process's native regset view.
+ * @tsk: a thread of the process in question
+ *
+ * Return the &struct user_regset_view that is native for the given process.
+ * For example, what it would access when it called ptrace().
+ * Throughout the life of the process, this only changes at exec.
+ */
+const struct user_regset_view *task_user_regset_view(struct task_struct *tsk);
+
+
+#endif	/* <linux/regset.h> */
-- 
1.5.3.6

