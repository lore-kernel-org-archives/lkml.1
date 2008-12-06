Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbYLFALp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbYLFALp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbYLFAL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:11:28 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49667 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756809AbYLFALV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:11:21 -0500
From: Jeff Arnold <jbarnold@MIT.EDU>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>, Nikanth Karthikesan <knikanth@suse.de>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: [PATCH 7/7] Ksplice: Support updating x86-32 and x86-64
Date: Fri,  5 Dec 2008 19:04:00 -0500
Message-Id: <1228521840-3886-8-git-send-email-jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <1228521840-3886-7-git-send-email-jbarnold@mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu>
 <1228521840-3886-2-git-send-email-jbarnold@mit.edu>
 <1228521840-3886-3-git-send-email-jbarnold@mit.edu>
 <1228521840-3886-4-git-send-email-jbarnold@mit.edu>
 <1228521840-3886-5-git-send-email-jbarnold@mit.edu>
 <1228521840-3886-6-git-send-email-jbarnold@mit.edu>
 <1228521840-3886-7-git-send-email-jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ksplice makes it possible to apply patches to the kernel without rebooting.

Signed-off-by: Jeff Arnold <jbarnold@mit.edu>
Signed-off-by: Anders Kaseorg <andersk@mit.edu>
Signed-off-by: Tim Abbott <tabbott@mit.edu>
Tested-by: Waseem Daher <wdaher@mit.edu>
---
 Documentation/ksplice.txt      |  282 +++++
 MAINTAINERS                    |   10 +
 arch/Kconfig                   |   14 +
 arch/x86/Kconfig               |    1 +
 arch/x86/kernel/ksplice-arch.c |  125 ++
 include/linux/kernel.h         |    1 +
 include/linux/ksplice.h        |  212 ++++
 kernel/Makefile                |    3 +
 kernel/ksplice.c               | 2715 ++++++++++++++++++++++++++++++++++++++++
 kernel/panic.c                 |    1 +
 10 files changed, 3364 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ksplice.txt
 create mode 100644 arch/x86/kernel/ksplice-arch.c
 create mode 100644 include/linux/ksplice.h
 create mode 100644 kernel/ksplice.c

diff --git a/Documentation/ksplice.txt b/Documentation/ksplice.txt
new file mode 100644
index 0000000..971f03a
--- /dev/null
+++ b/Documentation/ksplice.txt
@@ -0,0 +1,282 @@
+Ksplice
+-------
+
+CONTENTS:
+
+1. Concepts: updates, packs, helper modules, primary modules
+2. What changes can Ksplice handle?
+3. Dependency model
+4. Locking model
+5. altinstructions, smplocks, and parainstructions
+6. sysfs interface
+7. debugfs interface
+8. Hooks for running custom code during the update process
+
+0. Design Description
+---------------------
+
+For a description of the Ksplice design, please see the Ksplice technical
+overview document: <http://www.ksplice.com/doc/ksplice.pdf>.  For usage
+examples and the Ksplice man pages, please see <http://www.ksplice.com>.
+
+The document below assumes familiarity with the Ksplice design and describes
+notable implementation details and the interface between the Ksplice kernel
+component and the Ksplice user space component.
+
+1. Concepts: Updates, packs, helper modules, primary modules
+------------------------------------------------------------
+
+A Ksplice update (struct update) contains one or more Ksplice packs, one for
+each target kernel module that should be changed by the update.  Ksplice packs
+are grouped together into a Ksplice update in order to allow multiple
+compilation units to be changed atomically.
+
+The contents of a Ksplice pack are documented via kernel-doc in
+include/linux/ksplice.h.  To construct a new Ksplice update to be performed
+atomically, one needs to:
+  1. Populate the fields of one or more ksplice_pack structures.
+  2. Call the Ksplice function init_ksplice_pack() on each pack to register
+     the packs with the Ksplice kernel component.  When init_ksplice_pack()
+     is called on a pack, that pack will be associated with the other packs
+     that share the same Ksplice identifier (KID) field.
+  3. After all of the packs intended for a particular Ksplice update have
+     been loaded, that update can be applied via the sysfs interface
+     (described in Section 7 below).
+
+In order to save memory, each Ksplice pack has a "helper" module and a "primary"
+module associated with it.
+
+The pack's "helper" module contains materials needed only for preparing for the
+update.  Specifically, the helper module contains a copy of the pre-patch
+version of each of the compilation units changed by the Ksplice pack.  The
+helper module can be unloaded after the update has been applied.
+
+The pack's "primary" module contains the new sections to be inserted by the
+update; it needs to remain loaded for as long as the update is applied.
+
+Here's an example:
+
+Let's say that the Ksplice user space component wants to update the core kernel
+and the isdn module.  The user space component will select a KID for this update
+(let's say 123abc) and generate four modules:
+
+ksplice_123abc_vmlinux (the "primary" module for the vmlinux pack)
+ksplice_123abc_vmlinux_helper (the "helper" module for the vmlinux pack)
+ksplice_123abc_isdn (the "primary" module for the vmlinux pack)
+ksplice_123abc_isdn_helper (the "helper" module for the vmlinux pack)
+
+Once both of the vmlinux modules have been loaded, one of the modules calls
+init_ksplice_pack on a pack corresponding to the desired vmlinux changes.
+
+Similarly, once both of the isdn modules have been loaded, one of the modules
+calls init_ksplice_pack on a pack corresponding to the desired isdn changes.
+
+Once all modules are loaded (in this example, four modules), the update can be
+applied atomically using the Ksplice sysfs interface.  Once the update has been
+applied, the helper modules can be unloaded safely to save memory.
+
+2. What changes can Ksplice handle?
+-----------------------------------
+
+The Ksplice user space component takes a source code patch and uses it to
+construct appropriate Ksplice packs for an update.  Ksplice can handle source
+code patches that add new functions, modify the text or arguments of existing
+functions, delete functions, move functions between compilation units, change
+functions from local to global (or vice versa), add exported symbols, rename
+exported symbols, and delete exported symbols.  Ksplice can handle patches that
+modify either C code or assembly code.
+
+As described in the Ksplice technical overview document, a programmer needs to
+write some new code in order for Ksplice to apply a patch that makes semantic
+changes to kernel data structures.  Some other limitations also apply:
+
+Ksplice does not support changes to __init functions that been unloaded from
+kernel memory.  Ksplice also does not support changes to functions in
+.exit.text sections since Ksplice currently requires that all Ksplice updates
+affecting a module be reversed before that module can be unloaded.
+
+The Ksplice user space implementation does not currently support changes to
+weak symbols and changes to global read-only data structures (changes to
+read-only data structures that are local to a compilation unit are fine).
+
+Exported symbols:
+
+Ksplice can handle arbitrary changes to exported symbols in the source code
+patch.
+
+Ksplice deletes exported symbols by looking up the relevant struct kernel_symbol
+in the kernel's exported symbol table and replacing the name field with a
+pointer to a string that begins with DISABLED.
+
+Ksplice adds new exported symbols through the same mechanism; the relevant
+primary module will have a ksymtab entry containing a symbol with a name
+beginning with DISABLED, and Ksplice will replace that with the name of the
+symbol to be exported when the update is atomically applied.
+
+Because the struct kernel_symbol for a newly exported symbol is contained in the
+Ksplice primary module, if a module using one of the newly exported symbols is
+loaded, that module will correctly depend on the Ksplice primary module that
+exported the symbol.
+
+3. Dependency model
+-------------------
+
+Because Ksplice resolves symbols used in the post code using Ksplice
+relocations, Ksplice must enforce additional dependencies.  Ksplice uses the
+use_module function to directly add dependencies on all the modules that the
+post code references.
+
+4. Locking model
+----------------
+
+From a locking perspective, Ksplice treats applying or removing a Ksplice update
+as analogous to loading or unloading a new version of the kernel modules patched
+by the update.  Ksplice uses module_mutex to protect against a variety of race
+conditions related to modules being loaded or unloaded while Ksplice is applying
+or reversing an update; this approach also protects against race conditions
+involving multiple Ksplice updates being loaded or unloaded simultaneously as
+well.
+
+5. altinstructions, smplocks, and parainstructions
+--------------------------------------------------
+
+There are currently several mechanisms through which the Linux kernel will
+modify executable code at runtime.
+
+These mechanisms sometimes overwrite the storage unit of a relocation, which
+would cause problems if not handled properly by Ksplice.
+
+Ksplice solves this problem by writing "canary" bytes (e.g., 0x77777777) in the
+storage unit of the relocation in user space.  Ksplice then checks whether the
+canary has been overwritten before using a Ksplice relocation to detect symbol
+values or to write a value to the storage unit of a Ksplice relocation.
+
+6. sysfs interface
+------------------
+
+Ksplice exports four sysfs files per Ksplice update in order to communicate with
+user space.  For each update, these four files are located in a directory of the
+form /sys/kernel/ksplice/$kid, with $kid replaced by the KID of the Ksplice
+update.
+
+A.  /sys/kernel/ksplice/$kid/stage (mode 0600)
+
+This file contains one of three strings:
+preparing: Indicates that this update has not yet been applied
+applied:   Indicates that this update has been applied and has not been reversed
+reversed:  Indicates that this update has been reversed
+
+When the stage is "preparing", the superuser can write "applied" to the stage
+file in order to instruct Ksplice to apply the update.  When the stage is
+"applied", the superuser can write "reversed" to the stage file in order to
+instruct Ksplice to reverse the update.  Afterwards, the superuser can
+write "cleanup" to the stage file in order to instruct Ksplice to
+clean up the debugging information and sysfs directory associated with
+the reversed update.  Once an update is reversed, it cannot be re-applied without first
+cleaning up the update.
+
+B.  /sys/kernel/ksplice/$kid/debug (mode 0600)
+
+The file contains a single number: 1 if debugging is enabled for this Ksplice
+update and 0 otherwise.
+
+The superuser can write a new value to this file to enable or disable debugging.
+
+C.  /sys/kernel/ksplice/$kid/partial (mode 0600)
+
+The file contains a single number: 1 if the update should be applied even if
+some of the target modules are not loaded and 0 otherwise.
+
+D.  /sys/kernel/ksplice/$kid/abort_cause (mode 0400)
+
+This file contains a value indicating either 1) that Ksplice successfully
+completed the most recently requested stage transition or 2) why Ksplice aborted
+the most recently requested stage transition.
+
+Each abort_code string is described below, along with the stage transitions that
+might potentially trigger each possible abort code.  The stage transitions are
+abbreviated as follows: preparing->applied (P->A), applied->reversed (A->R).
+
+ok (P->A, A->R): The most recent stage transition succeeded.
+
+no_match (P->A): Ksplice aborted the update because Ksplice was unable to match
+the helper module's object code against the running kernel's object code.
+
+failed_to_find (P->A): Ksplice aborted the update because Ksplice was unable to
+resolve some of the symbols used in the update.
+
+missing_export (P->A): Ksplice aborted the update because the symbols exported
+by the kernel did not match Ksplice's expectations.
+
+already_reversed (P->A): Ksplice aborted the update because once an update has
+been reversed, it cannot be applied again (without first being cleaned up and
+reinitialized).
+
+module_busy (A->R): Ksplice aborted the undo operation because the target
+Ksplice update is in use by another kernel module; specifically, either the
+target Ksplice update exports a symbol that is in use by another module or
+another Ksplice update depends on this Ksplice update.
+
+out_of_memory (P->A, A->R): Ksplice aborted the operation because a call to
+kmalloc or vmalloc failed.
+
+code_busy (P->A, A->R): Ksplice aborted the operation because Ksplice was
+unable to find a moment when one or more of the to-be-patched functions was not
+a thread's kernel stack.
+
+target_not_loaded (P->A): Ksplice aborted the update because one of the target
+modules is not loaded and the partial option (/sys/kernel/ksplice/$kid/partial)
+is not enabled.
+
+call_failed (P->A, A->R): One of the calls included as part of this update
+returned nonzero exit status.
+
+unexpected_running_task (P->A, A->R): Ksplice aborted the operation because
+Ksplice observed a running task during the kernel stack check, at a time when
+Ksplice expected all tasks to be stopped by stop_machine.
+
+unexpected (P->A, A->R): Ksplice aborted the operation because it encountered
+an unspecified internal error.  This condition can only be caused by an invalid
+input to Ksplice or a bug in Ksplice.
+
+E.  /sys/kernel/ksplice/$kid/conflicts (mode 0400)
+
+This file is empty until Ksplice aborts an operation because of a code_busy
+condition (see "abort_code" above).  This conflicts file then contains
+information about the process(es) that caused the stack check failure.
+
+Specifically, each line of this file consists of three space-separated values,
+describing a single conflict:
+
+$program_name $program_pid $conflict_label
+
+$program_name is the name of the program with the conflict.
+$program_pid is the pid of the program with the conflict.
+$conflict_label is the Ksplice label of the function with the conflict.
+
+7. debugfs interface
+--------------------
+
+Ksplice exports a single file to debugfs for each Ksplice update.  The file has
+a name of the form ksplice_KID, where KID is the unique identifier of the
+Ksplice update.  It contains debugging information in a human-readable format.
+
+8. Hooks for running custom code during the update process
+----------------------------------------------------------
+
+Ksplice allows a programmer to write custom code to be called from within the
+kernel during the update process.  The kernel component allows custom code to
+be executed at the following times:
+
+pre_apply: Called before the update has been applied and before the machine has
+been stopped.  Allowed to fail.
+check_apply: Called before the update has been applied but after the machine
+has been stopped.  Allowed to fail.
+apply:  Called when the update is definitely going to be applied and when the
+machine is stopped.  Not allowed to fail.
+post_apply: Called when the update has been applied and the machine is no
+longer stopped.  Not allowed to fail.
+fail_apply: Called when the update failed to apply and the machine is no longer
+stopped.  Not allowed to fail.
+
+Ksplice also provides six analagous xxx_reverse hooks.
diff --git a/MAINTAINERS b/MAINTAINERS
index 618c1ef..40227d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2585,6 +2585,16 @@ W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
+KSPLICE:
+P:	Jeff Arnold
+M:	jbarnold@mit.edu
+P:	Anders Kaseorg
+M:	andersk@mit.edu
+P:	Tim Abbott
+M:	tabbott@mit.edu
+W:	http://www.ksplice.com
+S:	Maintained
+
 LAPB module
 L:	linux-x25@vger.kernel.org
 S:	Orphan
diff --git a/arch/Kconfig b/arch/Kconfig
index 471e72d..de4b6c8 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -41,6 +41,17 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config KSPLICE
+	tristate "Ksplice rebootless kernel updates"
+	depends on KALLSYMS_ALL && MODULE_UNLOAD && SYSFS && \
+		   FUNCTION_DATA_SECTIONS
+	depends on HAVE_KSPLICE
+	help
+          Say Y here if you want to be able to apply certain kinds of
+          patches to your running kernel, without rebooting.
+
+          If unsure, say N.
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
@@ -70,6 +81,9 @@ config HAVE_IOREMAP_PROT
 config HAVE_KPROBES
 	bool
 
+config HAVE_KSPLICE
+	def_bool n
+
 config HAVE_KRETPROBES
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..0e2c276 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -24,6 +24,7 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
+	select HAVE_KSPLICE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/x86/kernel/ksplice-arch.c b/arch/x86/kernel/ksplice-arch.c
new file mode 100644
index 0000000..b04ae17
--- /dev/null
+++ b/arch/x86/kernel/ksplice-arch.c
@@ -0,0 +1,125 @@
+/*  Copyright (C) 2007-2008  Jeff Arnold <jbarnold@mit.edu>
+ *  Copyright (C) 2008  Anders Kaseorg <andersk@mit.edu>,
+ *                      Tim Abbott <tabbott@mit.edu>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License, version 2.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ */
+
+#define KSPLICE_IP(x) ((x)->thread.ip)
+#define KSPLICE_SP(x) ((x)->thread.sp)
+
+static struct ksplice_symbol trampoline_symbol = {
+	.name = NULL,
+	.label = "<trampoline>",
+};
+
+static const struct ksplice_reloc_howto trampoline_howto = {
+	.type = KSPLICE_HOWTO_RELOC,
+	.pcrel = 1,
+	.size = 4,
+	.dst_mask = 0xffffffffL,
+	.rightshift = 0,
+	.signed_addend = 1,
+};
+
+static const struct ksplice_reloc trampoline_reloc = {
+	.symbol = &trampoline_symbol,
+	.insn_addend = -4,
+	.target_addend = 0,
+	.howto = &trampoline_howto,
+};
+
+static abort_t trampoline_target(struct ksplice_pack *pack, unsigned long addr,
+				 unsigned long *new_addr)
+{
+	abort_t ret;
+	unsigned char byte;
+
+	if (probe_kernel_read(&byte, (void *)addr, sizeof(byte)) == -EFAULT)
+		return NO_MATCH;
+
+	if (byte != 0xe9)
+		return NO_MATCH;
+
+	ret = read_reloc_value(pack, &trampoline_reloc, addr + 1, new_addr);
+	if (ret != OK)
+		return ret;
+
+	*new_addr += addr + 1;
+	return OK;
+}
+
+static abort_t prepare_trampoline(struct ksplice_pack *pack,
+				  struct ksplice_patch *p)
+{
+	p->size = 5;
+	((unsigned char *)p->contents)[0] = 0xe9;
+	return write_reloc_value(pack, &trampoline_reloc,
+				 (unsigned long)p->contents + 1,
+				 p->repladdr - (p->oldaddr + 1));
+}
+
+static abort_t handle_bug(struct ksplice_pack *pack,
+			  const struct ksplice_reloc *r, unsigned long run_addr)
+{
+	const struct bug_entry *run_bug = find_bug(run_addr);
+	struct ksplice_section *bug_sect = symbol_section(pack, r->symbol);
+	if (run_bug == NULL)
+		return NO_MATCH;
+	if (bug_sect == NULL)
+		return UNEXPECTED;
+	return create_labelval(pack, bug_sect->symbol, (unsigned long)run_bug,
+			       TEMP);
+}
+
+static abort_t handle_extable(struct ksplice_pack *pack,
+			      const struct ksplice_reloc *r,
+			      unsigned long run_addr)
+{
+	const struct exception_table_entry *run_ent =
+	    search_exception_tables(run_addr);
+	struct ksplice_section *ex_sect = symbol_section(pack, r->symbol);
+	if (run_ent == NULL)
+		return NO_MATCH;
+	if (ex_sect == NULL)
+		return UNEXPECTED;
+	return create_labelval(pack, ex_sect->symbol, (unsigned long)run_ent,
+			       TEMP);
+}
+
+static abort_t handle_paravirt(struct ksplice_pack *pack,
+			       unsigned long pre_addr, unsigned long run_addr,
+			       int *matched)
+{
+	unsigned char run[5], pre[5];
+	*matched = 0;
+
+	if (probe_kernel_read(&run, (void *)run_addr, sizeof(run)) == -EFAULT ||
+	    probe_kernel_read(&pre, (void *)pre_addr, sizeof(pre)) == -EFAULT)
+		return OK;
+
+	if ((run[0] == 0xe8 && pre[0] == 0xe8) ||
+	    (run[0] == 0xe9 && pre[0] == 0xe9))
+		if (run_addr + 1 + *(int32_t *)&run[1] ==
+		    pre_addr + 1 + *(int32_t *)&pre[1])
+			*matched = 5;
+	return OK;
+}
+
+static bool valid_stack_ptr(const struct thread_info *tinfo, const void *p)
+{
+	return p > (const void *)tinfo
+	    && p <= (const void *)tinfo + THREAD_SIZE - sizeof(long);
+}
+
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index dc7e0d0..15643a5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -290,6 +290,7 @@ extern enum system_states {
 #define TAINT_OVERRIDDEN_ACPI_TABLE	8
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
+#define TAINT_KSPLICE			11
 
 extern void dump_stack(void) __cold;
 
diff --git a/include/linux/ksplice.h b/include/linux/ksplice.h
new file mode 100644
index 0000000..5f59cc5
--- /dev/null
+++ b/include/linux/ksplice.h
@@ -0,0 +1,212 @@
+#include <linux/types.h>
+
+/**
+ * struct ksplice_symbol - Ksplice's analogue of an ELF symbol
+ * @name:	The ELF name of the symbol
+ * @label:	A unique Ksplice name for the symbol
+ * @vals:	A linked list of possible values for the symbol, or NULL
+ * @value:	The value of the symbol (valid when vals is NULL)
+ **/
+struct ksplice_symbol {
+	const char *name;
+	const char *label;
+/* private: */
+	struct list_head *vals;
+	unsigned long value;
+};
+
+/**
+ * struct ksplice_reloc - Ksplice's analogue of an ELF relocation
+ * @blank_addr:		The address of the relocation's storage unit
+ * @symbol:		The ksplice_symbol associated with this relocation
+ * @howto:		The information regarding the relocation type
+ * @addend:		The ELF addend of the relocation
+ **/
+struct ksplice_reloc {
+	unsigned long blank_addr;
+	struct ksplice_symbol *symbol;
+	const struct ksplice_reloc_howto *howto;
+	long insn_addend;
+	long target_addend;
+};
+
+enum ksplice_reloc_howto_type {
+	KSPLICE_HOWTO_RELOC,
+	KSPLICE_HOWTO_RELOC_PATCH,
+	KSPLICE_HOWTO_DATE,
+	KSPLICE_HOWTO_TIME,
+	KSPLICE_HOWTO_BUG,
+	KSPLICE_HOWTO_EXTABLE,
+};
+
+/**
+ * struct ksplice_reloc_howto - Ksplice's relocation type information
+ * @type:		The type of the relocation
+ * @pcrel:		Is the relocation PC relative?
+ * @size:		The size, in bytes, of the item to be relocated
+ * @dst_mask:		Bitmask for which parts of the instruction or data are
+ * 			replaced with the relocated value
+ * 			(based on dst_mask from GNU BFD's reloc_howto_struct)
+ * @rightshift:		The value the final relocation is shifted right by;
+ * 			used to drop unwanted data from the relocation
+ * 			(based on rightshift from GNU BFD's reloc_howto_struct)
+ * @signed_addend:	Should the addend be interpreted as a signed value?
+ **/
+struct ksplice_reloc_howto {
+	enum ksplice_reloc_howto_type type;
+	int pcrel;
+	int size;
+	long dst_mask;
+	unsigned int rightshift;
+	int signed_addend;
+};
+
+#if BITS_PER_LONG == 32
+#define KSPLICE_CANARY 0x77777777UL
+#elif BITS_PER_LONG == 64
+#define KSPLICE_CANARY 0x7777777777777777UL
+#endif /* BITS_PER_LONG */
+
+/**
+ * struct ksplice_section - Ksplice's analogue of an ELF section
+ * @symbol:		The ksplice_symbol associated with this section
+ * @size:		The length, in bytes, of this section
+ * @address:		The address of the section
+ * @flags:		Flags indicating the type of the section, whether or
+ *			not it has been matched, etc.
+ **/
+struct ksplice_section {
+	struct ksplice_symbol *symbol;
+	unsigned long address;
+	unsigned long size;
+	unsigned int flags;
+	const unsigned char **match_map;
+};
+#define KSPLICE_SECTION_TEXT 0x00000001
+#define KSPLICE_SECTION_RODATA 0x00000002
+#define KSPLICE_SECTION_DATA 0x00000004
+#define KSPLICE_SECTION_STRING 0x00000008
+#define KSPLICE_SECTION_MATCHED 0x10000000
+
+#define MAX_TRAMPOLINE_SIZE 5
+
+enum ksplice_patch_type {
+	KSPLICE_PATCH_TEXT,
+	KSPLICE_PATCH_BUGLINE,
+	KSPLICE_PATCH_DATA,
+	KSPLICE_PATCH_EXPORT,
+};
+
+/**
+ * struct ksplice_patch - A replacement that Ksplice should perform
+ * @oldaddr:		The address of the obsolete function or structure
+ * @repladdr:		The address of the replacement function
+ * @type:		The type of the ksplice patch
+ * @size:		The size of the patch
+ * @contents:		The bytes to be installed at oldaddr
+ * @vaddr		The address of the page mapping used to write at oldaddr
+ * @saved:		The bytes originally at oldaddr which were
+ * 			overwritten by the patch
+ **/
+struct ksplice_patch {
+	unsigned long oldaddr;
+	unsigned long repladdr;
+	enum ksplice_patch_type type;
+	unsigned int size;
+	void *contents;
+/* private: */
+	void *vaddr;
+	void *saved;
+};
+
+#ifdef __KERNEL__
+#include <linux/module.h>
+#include <linux/stringify.h>
+
+#define _PASTE(x, y) x##y
+#define PASTE(x, y) _PASTE(x, y)
+#define KSPLICE_UNIQ(s) PASTE(s##_, KSPLICE_MID)
+#define KSPLICE_KID_UNIQ(s) PASTE(s##_, KSPLICE_KID)
+
+/**
+ * struct ksplice_module_list_entry - A record of a Ksplice pack's target
+ * @target:	A module that is patched
+ * @primary:	A Ksplice module that patches target
+ **/
+struct ksplice_module_list_entry {
+	struct module *target;
+	struct module *primary;
+/* private: */
+	struct list_head list;
+};
+
+/* List of all ksplice modules and the module they patch */
+extern struct list_head ksplice_module_list;
+
+/**
+ * struct ksplice_pack - Data for one module modified by a Ksplice update
+ * @name:			The name of the primary module for the pack
+ * @kid:			The Ksplice unique identifier for the pack
+ * @target_name:		The name of the module modified by the pack
+ * @primary:			The primary module associated with the pack
+ * @primary_relocs:		The relocations for the primary module
+ * @primary_relocs_end:		The end pointer for primary_relocs
+ * @primary_sections:		The sections in the primary module
+ * @primary_sections_end:	The end pointer for primary_sections array
+ * @helper_relocs:		The relocations for the helper module
+ * @helper_relocs_end:		The end pointer for helper_relocs array
+ * @helper_sections:		The sections in the helper module
+ * @helper_sections_end:	The end pointer for helper_sections array
+ * @patches:			The function replacements in the pack
+ * @patches_end:		The end pointer for patches array
+ * @update:			The atomic update the pack is part of
+ * @target:			The module modified by the pack
+ * @safety_records:		The ranges of addresses that must not be on a
+ *				kernel stack for the patch to apply safely
+ **/
+struct ksplice_pack {
+	const char *name;
+	const char *kid;
+	const char *target_name;
+	struct module *primary;
+	struct ksplice_reloc *primary_relocs, *primary_relocs_end;
+	const struct ksplice_section *primary_sections, *primary_sections_end;
+	struct ksplice_symbol *primary_symbols, *primary_symbols_end;
+	struct ksplice_reloc *helper_relocs, *helper_relocs_end;
+	struct ksplice_section *helper_sections, *helper_sections_end;
+	struct ksplice_symbol *helper_symbols, *helper_symbols_end;
+	struct ksplice_patch *patches, *patches_end;
+	const typeof(int (*)(void)) *pre_apply, *pre_apply_end, *check_apply,
+	    *check_apply_end;
+	const typeof(void (*)(void)) *apply, *apply_end, *post_apply,
+	    *post_apply_end, *fail_apply, *fail_apply_end;
+	const typeof(int (*)(void)) *pre_reverse, *pre_reverse_end,
+	    *check_reverse, *check_reverse_end;
+	const typeof(void (*)(void)) *reverse, *reverse_end, *post_reverse,
+	    *post_reverse_end, *fail_reverse, *fail_reverse_end;
+/* private: */
+	struct ksplice_module_list_entry module_list_entry;
+	struct update *update;
+	struct module *target;
+	struct list_head temp_labelvals;
+	struct list_head safety_records;
+	struct list_head list;
+};
+
+
+/**
+ * init_ksplice_pack() - Initializes a pack
+ * @pack:	The pack to be initialized.  All of the public fields of the
+ * 		pack and its associated data structures should be populated
+ * 		before this function is called.  The values of the private
+ * 		fields will be ignored.
+ **/
+int init_ksplice_pack(struct ksplice_pack *pack);
+
+/**
+ * cleanup_ksplice_pack() - Cleans up a pack
+ * @pack:	The pack to be cleaned up
+ */
+void cleanup_ksplice_pack(struct ksplice_pack *pack);
+
+#endif /* __KERNEL__ */
diff --git a/kernel/Makefile b/kernel/Makefile
index 19fad00..e8ecb64 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,6 +11,8 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
+CFLAGS_ksplice.o += -Iarch/$(SRCARCH)/kernel
+
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -68,6 +70,7 @@ obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
+obj-$(CONFIG_KSPLICE) += ksplice.o
 obj-$(CONFIG_KGDB) += kgdb.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
diff --git a/kernel/ksplice.c b/kernel/ksplice.c
new file mode 100644
index 0000000..d12a6db
--- /dev/null
+++ b/kernel/ksplice.c
@@ -0,0 +1,2715 @@
+/*  Copyright (C) 2007-2008  Jeff Arnold <jbarnold@mit.edu>
+ *  Copyright (C) 2008  Anders Kaseorg <andersk@mit.edu>,
+ *                      Tim Abbott <tabbott@mit.edu>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License, version 2.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/bug.h>
+#include <linux/ctype.h>
+#include <linux/debugfs.h>
+#include <linux/errno.h>
+#include <linux/kallsyms.h>
+#include <linux/kobject.h>
+#include <linux/kthread.h>
+#include <linux/pagemap.h>
+#include <linux/sched.h>
+#include <linux/sort.h>
+#include <linux/stop_machine.h>
+#include <linux/sysfs.h>
+#include <linux/time.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/ksplice.h>
+
+enum stage {
+	STAGE_PREPARING, STAGE_APPLIED, STAGE_REVERSED
+};
+
+enum run_pre_mode {
+	RUN_PRE_INITIAL, RUN_PRE_DEBUG, RUN_PRE_FINAL, RUN_PRE_SILENT
+};
+
+enum { NOVAL, TEMP, VAL };
+
+typedef int __bitwise__ abort_t;
+
+#define OK ((__force abort_t) 0)
+#define NO_MATCH ((__force abort_t) 1)
+#define CODE_BUSY ((__force abort_t) 2)
+#define MODULE_BUSY ((__force abort_t) 3)
+#define OUT_OF_MEMORY ((__force abort_t) 4)
+#define FAILED_TO_FIND ((__force abort_t) 5)
+#define ALREADY_REVERSED ((__force abort_t) 6)
+#define MISSING_EXPORT ((__force abort_t) 7)
+#define UNEXPECTED_RUNNING_TASK ((__force abort_t) 8)
+#define UNEXPECTED ((__force abort_t) 9)
+#define TARGET_NOT_LOADED ((__force abort_t) 10)
+#define CALL_FAILED ((__force abort_t) 11)
+
+struct update {
+	const char *kid;
+	const char *name;
+	struct kobject kobj;
+	enum stage stage;
+	abort_t abort_cause;
+	int debug;
+#ifdef CONFIG_DEBUG_FS
+	struct debugfs_blob_wrapper debug_blob;
+	struct dentry *debugfs_dentry;
+#else /* !CONFIG_DEBUG_FS */
+	bool debug_continue_line;
+#endif /* CONFIG_DEBUG_FS */
+	bool partial;
+	struct list_head packs;
+	struct list_head unused_packs;
+	struct list_head conflicts;
+	struct list_head list;
+};
+
+struct conflict {
+	const char *process_name;
+	pid_t pid;
+	struct list_head stack;
+	struct list_head list;
+};
+
+struct conflict_addr {
+	unsigned long addr;
+	bool has_conflict;
+	const char *label;
+	struct list_head list;
+};
+
+struct labelval {
+	struct list_head list;
+	struct ksplice_symbol *symbol;
+	struct list_head *saved_vals;
+};
+
+struct safety_record {
+	struct list_head list;
+	const char *label;
+	unsigned long addr;
+	unsigned long size;
+};
+
+struct candidate_val {
+	struct list_head list;
+	unsigned long val;
+};
+
+struct accumulate_struct {
+	struct ksplice_pack *pack;
+	const char *desired_name;
+	struct list_head *vals;
+};
+
+struct ksplice_lookup {
+/* input */
+	struct ksplice_pack *pack;
+	struct ksplice_symbol **arr;
+	size_t size;
+/* output */
+	abort_t ret;
+};
+
+static LIST_HEAD(updates);
+LIST_HEAD(ksplice_module_list);
+EXPORT_SYMBOL_GPL(ksplice_module_list);
+static struct kobject *ksplice_kobj;
+
+static struct kobj_type ksplice_ktype;
+
+static struct update *init_ksplice_update(const char *kid);
+static void cleanup_ksplice_update(struct update *update);
+static void maybe_cleanup_ksplice_update(struct update *update);
+static void add_to_update(struct ksplice_pack *pack, struct update *update);
+static int ksplice_sysfs_init(struct update *update);
+
+/* Preparing the relocations and patches for application */
+static abort_t apply_update(struct update *update);
+static abort_t prepare_pack(struct ksplice_pack *pack);
+static abort_t finalize_pack(struct ksplice_pack *pack);
+static abort_t finalize_patches(struct ksplice_pack *pack);
+static abort_t add_dependency_on_address(struct ksplice_pack *pack,
+					 unsigned long addr);
+static abort_t map_trampoline_pages(struct update *update);
+static void unmap_trampoline_pages(struct update *update);
+static void *map_writable(void *addr, size_t len);
+static abort_t apply_relocs(struct ksplice_pack *pack,
+			    const struct ksplice_reloc *relocs,
+			    const struct ksplice_reloc *relocs_end);
+static abort_t apply_reloc(struct ksplice_pack *pack,
+			   const struct ksplice_reloc *r);
+static abort_t apply_howto_reloc(struct ksplice_pack *pack,
+				 const struct ksplice_reloc *r);
+static abort_t apply_howto_date(struct ksplice_pack *pack,
+				const struct ksplice_reloc *r);
+static abort_t read_reloc_value(struct ksplice_pack *pack,
+				const struct ksplice_reloc *r,
+				unsigned long addr, unsigned long *valp);
+static abort_t write_reloc_value(struct ksplice_pack *pack,
+				 const struct ksplice_reloc *r,
+				 unsigned long addr, unsigned long sym_addr);
+static void __attribute__((noreturn)) ksplice_deleted(void);
+
+/* run-pre matching */
+static abort_t match_pack_sections(struct ksplice_pack *pack,
+				   bool consider_data_sections);
+static abort_t find_section(struct ksplice_pack *pack,
+			    struct ksplice_section *sect);
+static abort_t try_addr(struct ksplice_pack *pack,
+			struct ksplice_section *sect,
+			unsigned long run_addr,
+			struct list_head *safety_records,
+			enum run_pre_mode mode);
+static abort_t run_pre_cmp(struct ksplice_pack *pack,
+			   const struct ksplice_section *sect,
+			   unsigned long run_addr,
+			   struct list_head *safety_records,
+			   enum run_pre_mode mode);
+static void print_bytes(struct ksplice_pack *pack,
+			const unsigned char *run, int runc,
+			const unsigned char *pre, int prec);
+static const struct ksplice_reloc *
+init_reloc_search(struct ksplice_pack *pack,
+		  const struct ksplice_section *sect);
+static const struct ksplice_reloc *find_reloc(const struct ksplice_reloc *start,
+					      const struct ksplice_reloc *end,
+					      unsigned long address,
+					      unsigned long size);
+static abort_t lookup_reloc(struct ksplice_pack *pack,
+			    const struct ksplice_reloc **fingerp,
+			    unsigned long addr,
+			    const struct ksplice_reloc **relocp);
+static abort_t handle_reloc(struct ksplice_pack *pack,
+			    const struct ksplice_section *sect,
+			    const struct ksplice_reloc *r,
+			    unsigned long run_addr, enum run_pre_mode mode);
+static abort_t handle_howto_date(struct ksplice_pack *pack,
+				 const struct ksplice_section *sect,
+				 const struct ksplice_reloc *r,
+				 unsigned long run_addr,
+				 enum run_pre_mode mode);
+static abort_t handle_howto_reloc(struct ksplice_pack *pack,
+				  const struct ksplice_section *sect,
+				  const struct ksplice_reloc *r,
+				  unsigned long run_addr,
+				  enum run_pre_mode mode);
+static struct ksplice_section *symbol_section(struct ksplice_pack *pack,
+					      const struct ksplice_symbol *sym);
+static int compare_section_labels(const void *va, const void *vb);
+static int symbol_section_bsearch_compare(const void *a, const void *b);
+static const struct ksplice_reloc *patch_reloc(struct ksplice_pack *pack,
+					       const struct ksplice_patch *p);
+
+/* Computing possible addresses for symbols */
+static abort_t lookup_symbol(struct ksplice_pack *pack,
+			     const struct ksplice_symbol *ksym,
+			     struct list_head *vals);
+static void cleanup_symbol_arrays(struct ksplice_pack *pack);
+static abort_t init_symbol_arrays(struct ksplice_pack *pack);
+static abort_t init_symbol_array(struct ksplice_pack *pack,
+				 struct ksplice_symbol *start,
+				 struct ksplice_symbol *end);
+static abort_t uniquify_symbols(struct ksplice_pack *pack);
+static abort_t add_matching_values(struct ksplice_lookup *lookup,
+				   const char *sym_name, unsigned long sym_val);
+static bool add_export_values(const struct symsearch *syms,
+			      struct module *owner,
+			      unsigned int symnum, void *data);
+static int symbolp_bsearch_compare(const void *key, const void *elt);
+static int compare_symbolp_names(const void *a, const void *b);
+static int compare_symbolp_labels(const void *a, const void *b);
+static int add_kallsyms_values(void *data, const char *name,
+			       struct module *owner, unsigned long val);
+static abort_t new_export_lookup(struct ksplice_pack *ipack, const char *name,
+				 struct list_head *vals);
+
+/* Atomic update insertion and removal */
+static abort_t apply_patches(struct update *update);
+static abort_t reverse_patches(struct update *update);
+static int __apply_patches(void *update);
+static int __reverse_patches(void *update);
+static abort_t check_each_task(struct update *update);
+static abort_t check_task(struct update *update,
+			  const struct task_struct *t, bool rerun);
+static abort_t check_stack(struct update *update, struct conflict *conf,
+			   const struct thread_info *tinfo,
+			   const unsigned long *stack);
+static abort_t check_address(struct update *update,
+			     struct conflict *conf, unsigned long addr);
+static abort_t check_record(struct conflict_addr *ca,
+			    const struct safety_record *rec,
+			    unsigned long addr);
+static bool is_stop_machine(const struct task_struct *t);
+static void cleanup_conflicts(struct update *update);
+static void print_conflicts(struct update *update);
+static void insert_trampoline(struct ksplice_patch *p);
+static abort_t verify_trampoline(struct ksplice_pack *pack,
+				 const struct ksplice_patch *p);
+static void remove_trampoline(const struct ksplice_patch *p);
+
+static abort_t create_labelval(struct ksplice_pack *pack,
+			       struct ksplice_symbol *ksym,
+			       unsigned long val, int status);
+static abort_t create_safety_record(struct ksplice_pack *pack,
+				    const struct ksplice_section *sect,
+				    struct list_head *record_list,
+				    unsigned long run_addr,
+				    unsigned long run_size);
+static abort_t add_candidate_val(struct ksplice_pack *pack,
+				 struct list_head *vals, unsigned long val);
+static void release_vals(struct list_head *vals);
+static void set_temp_labelvals(struct ksplice_pack *pack, int status_val);
+
+static int contains_canary(struct ksplice_pack *pack, unsigned long blank_addr,
+			   const struct ksplice_reloc_howto *howto);
+static unsigned long follow_trampolines(struct ksplice_pack *pack,
+					unsigned long addr);
+static bool patches_module(const struct module *a, const struct module *b);
+static bool starts_with(const char *str, const char *prefix);
+static bool singular(struct list_head *list);
+static void *bsearch(const void *key, const void *base, size_t n,
+		     size_t size, int (*cmp)(const void *key, const void *elt));
+static int compare_relocs(const void *a, const void *b);
+static int reloc_bsearch_compare(const void *key, const void *elt);
+
+/* Debugging */
+static abort_t init_debug_buf(struct update *update);
+static void clear_debug_buf(struct update *update);
+static int __attribute__((format(printf, 2, 3)))
+_ksdebug(struct update *update, const char *fmt, ...);
+#define ksdebug(pack, fmt, ...) \
+	_ksdebug(pack->update, fmt, ## __VA_ARGS__)
+
+/* Architecture-specific functions defined in arch/ARCH/kernel/ksplice-arch.c */
+static abort_t prepare_trampoline(struct ksplice_pack *pack,
+				  struct ksplice_patch *p);
+static abort_t trampoline_target(struct ksplice_pack *pack, unsigned long addr,
+				 unsigned long *new_addr);
+static abort_t handle_paravirt(struct ksplice_pack *pack, unsigned long pre,
+			       unsigned long run, int *matched);
+static abort_t handle_bug(struct ksplice_pack *pack,
+			  const struct ksplice_reloc *r,
+			  unsigned long run_addr);
+static abort_t handle_extable(struct ksplice_pack *pack,
+			      const struct ksplice_reloc *r,
+			      unsigned long run_addr);
+static bool valid_stack_ptr(const struct thread_info *tinfo, const void *p);
+
+#include "ksplice-arch.c"
+
+#define clear_list(head, type, member)				\
+	do {							\
+		struct list_head *_pos, *_n;			\
+		list_for_each_safe(_pos, _n, head) {		\
+			list_del(_pos);				\
+			kfree(list_entry(_pos, type, member));	\
+		}						\
+	} while (0)
+
+int init_ksplice_pack(struct ksplice_pack *pack)
+{
+	struct update *update;
+	struct ksplice_patch *p;
+	struct ksplice_section *s;
+	int ret = 0;
+
+	INIT_LIST_HEAD(&pack->temp_labelvals);
+	INIT_LIST_HEAD(&pack->safety_records);
+
+	sort(pack->helper_relocs,
+	     pack->helper_relocs_end - pack->helper_relocs,
+	     sizeof(*pack->helper_relocs), compare_relocs, NULL);
+	sort(pack->primary_relocs,
+	     pack->primary_relocs_end - pack->primary_relocs,
+	     sizeof(*pack->primary_relocs), compare_relocs, NULL);
+	sort(pack->helper_sections,
+	     pack->helper_sections_end - pack->helper_sections,
+	     sizeof(*pack->helper_sections), compare_section_labels, NULL);
+
+	mutex_lock(&module_mutex);
+	for (p = pack->patches; p < pack->patches_end; p++)
+		p->vaddr = NULL;
+	for (s = pack->helper_sections; s < pack->helper_sections_end; s++)
+		s->match_map = NULL;
+	for (p = pack->patches; p < pack->patches_end; p++) {
+		const struct ksplice_reloc *r = patch_reloc(pack, p);
+		if (r == NULL) {
+			ret = -ENOENT;
+			goto out;
+		}
+		if (p->type == KSPLICE_PATCH_DATA) {
+			s = symbol_section(pack, r->symbol);
+			if (s == NULL) {
+				ret = -ENOENT;
+				goto out;
+			}
+			if (s->flags & KSPLICE_SECTION_DATA)
+				s->flags = (s->flags & ~KSPLICE_SECTION_DATA) |
+				    KSPLICE_SECTION_RODATA;
+		}
+	}
+
+	list_for_each_entry(update, &updates, list) {
+		if (strcmp(pack->kid, update->kid) == 0) {
+			if (update->stage != STAGE_PREPARING) {
+				ret = -EPERM;
+				goto out;
+			}
+			add_to_update(pack, update);
+			ret = 0;
+			goto out;
+		}
+	}
+	update = init_ksplice_update(pack->kid);
+	if (update == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ret = ksplice_sysfs_init(update);
+	if (ret != 0) {
+		cleanup_ksplice_update(update);
+		goto out;
+	}
+	add_to_update(pack, update);
+out:
+	mutex_unlock(&module_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(init_ksplice_pack);
+
+void cleanup_ksplice_pack(struct ksplice_pack *pack)
+{
+	if (pack->update == NULL)
+		return;
+	if (pack->update->stage == STAGE_APPLIED) {
+		/* If the pack wasn't actually applied (because we
+		   only applied this update to loaded modules and this
+		   target wasn't loaded), then unregister the pack
+		   from the list of unused packs */
+		struct ksplice_pack *p;
+		bool found = false;
+
+		mutex_lock(&module_mutex);
+		list_for_each_entry(p, &pack->update->unused_packs, list) {
+			if (p == pack)
+				found = true;
+		}
+		if (found)
+			list_del(&pack->list);
+		mutex_unlock(&module_mutex);
+		return;
+	}
+	mutex_lock(&module_mutex);
+	list_del(&pack->list);
+	mutex_unlock(&module_mutex);
+	if (pack->update->stage == STAGE_PREPARING)
+		maybe_cleanup_ksplice_update(pack->update);
+	pack->update = NULL;
+}
+EXPORT_SYMBOL_GPL(cleanup_ksplice_pack);
+
+static struct update *init_ksplice_update(const char *kid)
+{
+	struct update *update;
+	update = kcalloc(1, sizeof(struct update), GFP_KERNEL);
+	if (update == NULL)
+		return NULL;
+	update->name = kasprintf(GFP_KERNEL, "ksplice_%s", kid);
+	if (update->name == NULL) {
+		kfree(update);
+		return NULL;
+	}
+	update->kid = kstrdup(kid, GFP_KERNEL);
+	if (update->kid == NULL) {
+		kfree(update->name);
+		kfree(update);
+		return NULL;
+	}
+	if (try_module_get(THIS_MODULE) != 1) {
+		kfree(update->kid);
+		kfree(update->name);
+		kfree(update);
+		return NULL;
+	}
+	INIT_LIST_HEAD(&update->packs);
+	INIT_LIST_HEAD(&update->unused_packs);
+	if (init_debug_buf(update) != OK) {
+		module_put(THIS_MODULE);
+		kfree(update->kid);
+		kfree(update->name);
+		kfree(update);
+		return NULL;
+	}
+	list_add(&update->list, &updates);
+	update->stage = STAGE_PREPARING;
+	update->abort_cause = OK;
+	update->partial = 0;
+	INIT_LIST_HEAD(&update->conflicts);
+	return update;
+}
+
+static void cleanup_ksplice_update(struct update *update)
+{
+	mutex_lock(&module_mutex);
+	list_del(&update->list);
+	mutex_unlock(&module_mutex);
+	cleanup_conflicts(update);
+	clear_debug_buf(update);
+	kfree(update->kid);
+	kfree(update->name);
+	kfree(update);
+	module_put(THIS_MODULE);
+}
+
+static void maybe_cleanup_ksplice_update(struct update *update)
+{
+	if (list_empty(&update->packs) && list_empty(&update->unused_packs))
+		kobject_put(&update->kobj);
+}
+
+static void add_to_update(struct ksplice_pack *pack, struct update *update)
+{
+	pack->update = update;
+	list_add(&pack->list, &update->unused_packs);
+	pack->module_list_entry.primary = pack->primary;
+}
+
+static int ksplice_sysfs_init(struct update *update)
+{
+	int ret = 0;
+	memset(&update->kobj, 0, sizeof(update->kobj));
+	ret = kobject_init_and_add(&update->kobj, &ksplice_ktype,
+				   ksplice_kobj, "%s", update->kid);
+	if (ret != 0)
+		return ret;
+	kobject_uevent(&update->kobj, KOBJ_ADD);
+	return 0;
+}
+
+static abort_t apply_update(struct update *update)
+{
+	struct ksplice_pack *pack, *n;
+	abort_t ret;
+	int retval;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry_safe(pack, n, &update->unused_packs, list) {
+		if (strcmp(pack->target_name, "vmlinux") == 0) {
+			pack->target = NULL;
+		} else if (pack->target == NULL) {
+			pack->target = find_module(pack->target_name);
+			if (pack->target == NULL ||
+			    !module_is_live(pack->target)) {
+				if (update->partial) {
+					continue;
+				} else {
+					ret = TARGET_NOT_LOADED;
+					goto out;
+				}
+			}
+			retval = use_module(pack->primary, pack->target);
+			if (retval != 1) {
+				ret = UNEXPECTED;
+				goto out;
+			}
+		}
+		list_del(&pack->list);
+		list_add_tail(&pack->list, &update->packs);
+		pack->module_list_entry.target = pack->target;
+
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		const struct ksplice_section *sect;
+		for (sect = pack->primary_sections;
+		     sect < pack->primary_sections_end; sect++) {
+			struct safety_record *rec = kmalloc(sizeof(*rec),
+							    GFP_KERNEL);
+			if (rec == NULL) {
+				ret = OUT_OF_MEMORY;
+				goto out;
+			}
+			rec->addr = sect->address;
+			rec->size = sect->size;
+			rec->label = sect->symbol->label;
+			list_add(&rec->list, &pack->safety_records);
+		}
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		ret = init_symbol_arrays(pack);
+		if (ret != OK) {
+			cleanup_symbol_arrays(pack);
+			goto out;
+		}
+		ret = prepare_pack(pack);
+		cleanup_symbol_arrays(pack);
+		if (ret != OK)
+			goto out;
+	}
+	ret = apply_patches(update);
+out:
+	list_for_each_entry(pack, &update->packs, list) {
+		struct ksplice_section *s;
+		if (update->stage == STAGE_PREPARING)
+			clear_list(&pack->safety_records, struct safety_record,
+				   list);
+		for (s = pack->helper_sections; s < pack->helper_sections_end;
+		     s++) {
+			if (s->match_map != NULL) {
+				vfree(s->match_map);
+				s->match_map = NULL;
+			}
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return ret;
+}
+
+static int compare_symbolp_names(const void *a, const void *b)
+{
+	const struct ksplice_symbol *const *sympa = a, *const *sympb = b;
+	if ((*sympa)->name == NULL && (*sympb)->name == NULL)
+		return 0;
+	if ((*sympa)->name == NULL)
+		return -1;
+	if ((*sympb)->name == NULL)
+		return 1;
+	return strcmp((*sympa)->name, (*sympb)->name);
+}
+
+static int compare_symbolp_labels(const void *a, const void *b)
+{
+	const struct ksplice_symbol *const *sympa = a, *const *sympb = b;
+	return strcmp((*sympa)->label, (*sympb)->label);
+}
+
+static int symbolp_bsearch_compare(const void *key, const void *elt)
+{
+	const char *name = key;
+	const struct ksplice_symbol *const *symp = elt;
+	const struct ksplice_symbol *sym = *symp;
+	if (sym->name == NULL)
+		return 1;
+	return strcmp(name, sym->name);
+}
+
+static abort_t add_matching_values(struct ksplice_lookup *lookup,
+				   const char *sym_name, unsigned long sym_val)
+{
+	struct ksplice_symbol **symp;
+	abort_t ret;
+
+	symp = bsearch(sym_name, lookup->arr, lookup->size,
+		       sizeof(*lookup->arr), symbolp_bsearch_compare);
+	if (symp == NULL)
+		return OK;
+
+	while (symp > lookup->arr &&
+	       symbolp_bsearch_compare(sym_name, symp - 1) == 0)
+		symp--;
+
+	for (; symp < lookup->arr + lookup->size; symp++) {
+		struct ksplice_symbol *sym = *symp;
+		if (sym->name == NULL || strcmp(sym_name, sym->name) != 0)
+			break;
+		ret = add_candidate_val(lookup->pack, sym->vals, sym_val);
+		if (ret != OK)
+			return ret;
+	}
+	return OK;
+}
+
+static int add_kallsyms_values(void *data, const char *name,
+			       struct module *owner, unsigned long val)
+{
+	struct ksplice_lookup *lookup = data;
+	if (owner == lookup->pack->primary ||
+	    !patches_module(owner, lookup->pack->target))
+		return (__force int)OK;
+	return (__force int)add_matching_values(lookup, name, val);
+}
+
+static bool add_export_values(const struct symsearch *syms,
+			      struct module *owner,
+			      unsigned int symnum, void *data)
+{
+	struct ksplice_lookup *lookup = data;
+	abort_t ret;
+
+	ret = add_matching_values(lookup, syms->start[symnum].name,
+				  syms->start[symnum].value);
+	if (ret != OK) {
+		lookup->ret = ret;
+		return true;
+	}
+	return false;
+}
+
+static void cleanup_symbol_arrays(struct ksplice_pack *pack)
+{
+	struct ksplice_symbol *sym;
+	for (sym = pack->primary_symbols; sym < pack->primary_symbols_end;
+	     sym++) {
+		if (sym->vals != NULL) {
+			clear_list(sym->vals, struct candidate_val, list);
+			kfree(sym->vals);
+			sym->vals = NULL;
+		}
+	}
+	for (sym = pack->helper_symbols; sym < pack->helper_symbols_end; sym++) {
+		if (sym->vals != NULL) {
+			clear_list(sym->vals, struct candidate_val, list);
+			kfree(sym->vals);
+			sym->vals = NULL;
+		}
+	}
+}
+
+static abort_t uniquify_symbols(struct ksplice_pack *pack)
+{
+	struct ksplice_reloc *r;
+	struct ksplice_section *s;
+	struct ksplice_symbol *sym, **sym_arr, **symp;
+	size_t size = pack->primary_symbols_end - pack->primary_symbols;
+
+	if (size == 0)
+		return OK;
+
+	sym_arr = vmalloc(sizeof(*sym_arr) * size);
+	if (sym_arr == NULL)
+		return OUT_OF_MEMORY;
+
+	for (symp = sym_arr, sym = pack->primary_symbols;
+	     symp < sym_arr + size && sym < pack->primary_symbols_end;
+	     sym++, symp++)
+		*symp = sym;
+
+	sort(sym_arr, size, sizeof(*sym_arr), compare_symbolp_labels, NULL);
+
+	for (r = pack->helper_relocs; r < pack->helper_relocs_end; r++) {
+		symp = bsearch(&r->symbol, sym_arr, size, sizeof(*sym_arr),
+			       compare_symbolp_labels);
+		if (symp != NULL) {
+			if ((*symp)->name == NULL)
+				(*symp)->name = r->symbol->name;
+			r->symbol = *symp;
+		}
+	}
+
+	for (s = pack->helper_sections; s < pack->helper_sections_end; s++) {
+		symp = bsearch(&s->symbol, sym_arr, size, sizeof(*sym_arr),
+			       compare_symbolp_labels);
+		if (symp != NULL) {
+			if ((*symp)->name == NULL)
+				(*symp)->name = s->symbol->name;
+			s->symbol = *symp;
+		}
+	}
+
+	vfree(sym_arr);
+	return OK;
+}
+
+static abort_t init_symbol_array(struct ksplice_pack *pack,
+				 struct ksplice_symbol *start,
+				 struct ksplice_symbol *end)
+{
+	struct ksplice_symbol *sym, **sym_arr, **symp;
+	struct ksplice_lookup lookup;
+	size_t size = end - start;
+	abort_t ret;
+
+	if (size == 0)
+		return OK;
+
+	for (sym = start; sym < end; sym++) {
+		if (starts_with(sym->label, "__ksymtab")) {
+			const struct kernel_symbol *ksym;
+			const char *colon = strchr(sym->label, ':');
+			const char *name = colon + 1;
+			if (colon == NULL)
+				continue;
+			ksym = find_symbol(name, NULL, NULL, true, false);
+			if (ksym == NULL) {
+				ksdebug(pack, "Could not find kernel_symbol "
+					"structure for %s\n", name);
+				continue;
+			}
+			sym->value = (unsigned long)ksym;
+			sym->vals = NULL;
+			continue;
+		}
+
+		sym->vals = kmalloc(sizeof(*sym->vals), GFP_KERNEL);
+		if (sym->vals == NULL)
+			return OUT_OF_MEMORY;
+		INIT_LIST_HEAD(sym->vals);
+		sym->value = 0;
+	}
+
+	sym_arr = vmalloc(sizeof(*sym_arr) * size);
+	if (sym_arr == NULL)
+		return OUT_OF_MEMORY;
+
+	for (symp = sym_arr, sym = start; symp < sym_arr + size && sym < end;
+	     sym++, symp++)
+		*symp = sym;
+
+	sort(sym_arr, size, sizeof(*sym_arr), compare_symbolp_names, NULL);
+
+	lookup.pack = pack;
+	lookup.arr = sym_arr;
+	lookup.size = size;
+	lookup.ret = OK;
+
+	each_symbol(add_export_values, &lookup);
+	ret = lookup.ret;
+	if (ret == OK)
+		ret = (__force abort_t)
+		    kallsyms_on_each_symbol(add_kallsyms_values, &lookup);
+	vfree(sym_arr);
+	return ret;
+}
+
+static abort_t init_symbol_arrays(struct ksplice_pack *pack)
+{
+	abort_t ret;
+
+	ret = uniquify_symbols(pack);
+	if (ret != OK)
+		return ret;
+
+	ret = init_symbol_array(pack, pack->helper_symbols,
+				pack->helper_symbols_end);
+	if (ret != OK)
+		return ret;
+
+	ret = init_symbol_array(pack, pack->primary_symbols,
+				pack->primary_symbols_end);
+	if (ret != OK)
+		return ret;
+
+	return OK;
+}
+
+static abort_t prepare_pack(struct ksplice_pack *pack)
+{
+	abort_t ret;
+
+	ksdebug(pack, "Preparing and checking %s\n", pack->name);
+	ret = match_pack_sections(pack, false);
+	if (ret == NO_MATCH) {
+		/* It is possible that by using relocations from .data sections
+		   we can successfully run-pre match the rest of the sections.
+		   To avoid using any symbols obtained from .data sections
+		   (which may be unreliable) in the post code, we first prepare
+		   the post code and then try to run-pre match the remaining
+		   sections with the help of .data sections.
+		 */
+		ksdebug(pack, "Continuing without some sections; we might "
+			"find them later.\n");
+		ret = finalize_pack(pack);
+		if (ret != OK) {
+			ksdebug(pack, "Aborted.  Unable to continue without "
+				"the unmatched sections.\n");
+			return ret;
+		}
+
+		ksdebug(pack, "run-pre: Considering .data sections to find the "
+			"unmatched sections\n");
+		ret = match_pack_sections(pack, true);
+		if (ret != OK)
+			return ret;
+
+		ksdebug(pack, "run-pre: Found all previously unmatched "
+			"sections\n");
+		return OK;
+	} else if (ret != OK) {
+		return ret;
+	}
+
+	return finalize_pack(pack);
+}
+
+static abort_t finalize_pack(struct ksplice_pack *pack)
+{
+	abort_t ret;
+	ret = apply_relocs(pack, pack->primary_relocs,
+			   pack->primary_relocs_end);
+	if (ret != OK)
+		return ret;
+
+	ret = finalize_patches(pack);
+	if (ret != OK)
+		return ret;
+
+	return OK;
+}
+
+static abort_t finalize_patches(struct ksplice_pack *pack)
+{
+	struct ksplice_patch *p;
+	struct safety_record *rec;
+	abort_t ret;
+
+	for (p = pack->patches; p < pack->patches_end; p++) {
+		bool found = false;
+		list_for_each_entry(rec, &pack->safety_records, list) {
+			if (rec->addr <= p->oldaddr &&
+			    p->oldaddr < rec->addr + rec->size) {
+				found = true;
+				break;
+			}
+		}
+		if (!found && p->type != KSPLICE_PATCH_EXPORT) {
+			const struct ksplice_reloc *r = patch_reloc(pack, p);
+			if (r == NULL) {
+				ksdebug(pack, "A patch with no ksplice_reloc at"
+					" its oldaddr has no safety record\n");
+				return NO_MATCH;
+			}
+			ksdebug(pack, "No safety record for patch with oldaddr "
+				"%s+%lx\n", r->symbol->label, r->target_addend);
+			return NO_MATCH;
+		}
+
+		if (p->type == KSPLICE_PATCH_TEXT) {
+			ret = prepare_trampoline(pack, p);
+			if (ret != OK)
+				return ret;
+		}
+
+		if (found && rec->addr + rec->size < p->oldaddr + p->size) {
+			ksdebug(pack, "Safety record %s is too short for "
+				"patch\n", rec->label);
+			return UNEXPECTED;
+		}
+
+		if (p->type == KSPLICE_PATCH_TEXT) {
+			if (p->repladdr == 0)
+				p->repladdr = (unsigned long)ksplice_deleted;
+		}
+
+		ret = add_dependency_on_address(pack, p->oldaddr);
+		if (ret != OK)
+			return ret;
+	}
+	return OK;
+}
+
+static abort_t map_trampoline_pages(struct update *update)
+{
+	struct ksplice_pack *pack;
+	list_for_each_entry(pack, &update->packs, list) {
+		struct ksplice_patch *p;
+		for (p = pack->patches; p < pack->patches_end; p++) {
+			p->vaddr = map_writable((void *)p->oldaddr, p->size);
+			if (p->vaddr == NULL) {
+				ksdebug(pack, "Unable to map oldaddr read/write"
+					"\n");
+				unmap_trampoline_pages(update);
+				return UNEXPECTED;
+			}
+		}
+	}
+	return OK;
+}
+
+static void unmap_trampoline_pages(struct update *update)
+{
+	struct ksplice_pack *pack;
+	list_for_each_entry(pack, &update->packs, list) {
+		struct ksplice_patch *p;
+		for (p = pack->patches; p < pack->patches_end; p++) {
+			vunmap((void *)((unsigned long)p->vaddr & PAGE_MASK));
+			p->vaddr = NULL;
+		}
+	}
+}
+
+/* Based off of linux's text_poke.  */
+static void *map_writable(void *addr, size_t len)
+{
+	void *vaddr;
+	int nr_pages = 2;
+	struct page *pages[2];
+
+	if (__module_text_address((unsigned long)addr) == NULL &&
+	    __module_data_address((unsigned long)addr) == NULL) {
+		pages[0] = virt_to_page(addr);
+		WARN_ON(!PageReserved(pages[0]));
+		pages[1] = virt_to_page(addr + PAGE_SIZE);
+	} else {
+		pages[0] = vmalloc_to_page(addr);
+		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
+	}
+	if (!pages[0])
+		return NULL;
+	if (!pages[1])
+		nr_pages = 1;
+	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (vaddr == NULL)
+		return NULL;
+	return vaddr + offset_in_page(addr);
+}
+
+static abort_t add_dependency_on_address(struct ksplice_pack *pack,
+					 unsigned long addr)
+{
+	struct ksplice_pack *p;
+	struct module *m =
+	    __module_text_address(follow_trampolines(pack, addr));
+	if (m == NULL)
+		return OK;
+	list_for_each_entry(p, &pack->update->packs, list) {
+		if (m == p->primary)
+			return OK;
+	}
+	if (use_module(pack->primary, m) != 1)
+		return MODULE_BUSY;
+	return OK;
+}
+
+static abort_t apply_relocs(struct ksplice_pack *pack,
+			    const struct ksplice_reloc *relocs,
+			    const struct ksplice_reloc *relocs_end)
+{
+	const struct ksplice_reloc *r;
+	for (r = relocs; r < relocs_end; r++) {
+		abort_t ret = apply_reloc(pack, r);
+		if (ret != OK)
+			return ret;
+	}
+	return OK;
+}
+
+static abort_t apply_reloc(struct ksplice_pack *pack,
+			   const struct ksplice_reloc *r)
+{
+	switch (r->howto->type) {
+	case KSPLICE_HOWTO_RELOC:
+	case KSPLICE_HOWTO_RELOC_PATCH:
+		return apply_howto_reloc(pack, r);
+	case KSPLICE_HOWTO_DATE:
+	case KSPLICE_HOWTO_TIME:
+		return apply_howto_date(pack, r);
+	default:
+		ksdebug(pack, "Unexpected howto type %d\n", r->howto->type);
+		return UNEXPECTED;
+	}
+}
+
+static abort_t apply_howto_reloc(struct ksplice_pack *pack,
+				 const struct ksplice_reloc *r)
+{
+	abort_t ret;
+	int canary_ret;
+	unsigned long sym_addr;
+	LIST_HEAD(vals);
+
+	canary_ret = contains_canary(pack, r->blank_addr, r->howto);
+	if (canary_ret < 0)
+		return UNEXPECTED;
+	if (canary_ret == 0) {
+		ksdebug(pack, "reloc: skipped %lx to %s+%lx (altinstr)\n",
+			r->blank_addr, r->symbol->label, r->target_addend);
+		return OK;
+	}
+
+	ret = lookup_symbol(pack, r->symbol, &vals);
+	if (ret != OK) {
+		release_vals(&vals);
+		return ret;
+	}
+	if (!singular(&vals) || (r->symbol->vals != NULL &&
+				 r->howto->type == KSPLICE_HOWTO_RELOC_PATCH)) {
+		release_vals(&vals);
+		ksdebug(pack, "Failed to find %s for reloc\n",
+			r->symbol->label);
+		return FAILED_TO_FIND;
+	}
+	sym_addr = list_entry(vals.next, struct candidate_val, list)->val;
+	release_vals(&vals);
+
+	ret = write_reloc_value(pack, r, r->blank_addr,
+				r->howto->pcrel ? sym_addr - r->blank_addr :
+				sym_addr);
+	if (ret != OK)
+		return ret;
+
+	ksdebug(pack, "reloc: %lx to %s+%lx (S=%lx ", r->blank_addr,
+		r->symbol->label, r->target_addend, sym_addr);
+	switch (r->howto->size) {
+	case 1:
+		ksdebug(pack, "aft=%02x)\n", *(uint8_t *)r->blank_addr);
+		break;
+	case 2:
+		ksdebug(pack, "aft=%04x)\n", *(uint16_t *)r->blank_addr);
+		break;
+	case 4:
+		ksdebug(pack, "aft=%08x)\n", *(uint32_t *)r->blank_addr);
+		break;
+#if BITS_PER_LONG >= 64
+	case 8:
+		ksdebug(pack, "aft=%016llx)\n", *(uint64_t *)r->blank_addr);
+		break;
+#endif /* BITS_PER_LONG */
+	default:
+		ksdebug(pack, "Aborted.  Invalid relocation size.\n");
+		return UNEXPECTED;
+	}
+
+	/* Create labelvals so that we can verify our choices in the second
+	   round of run-pre matching that considers data sections. */
+	ret = create_labelval(pack, r->symbol, sym_addr, VAL);
+	if (ret != OK)
+		return ret;
+
+	return add_dependency_on_address(pack, sym_addr);
+}
+
+static abort_t apply_howto_date(struct ksplice_pack *pack,
+				const struct ksplice_reloc *r)
+{
+	if (r->symbol->vals != NULL) {
+		ksdebug(pack, "Failed to find %s for date\n", r->symbol->label);
+		return FAILED_TO_FIND;
+	}
+	memcpy((unsigned char *)r->blank_addr,
+	       (const unsigned char *)r->symbol->value, r->howto->size);
+	return OK;
+}
+
+static abort_t read_reloc_value(struct ksplice_pack *pack,
+				const struct ksplice_reloc *r,
+				unsigned long addr, unsigned long *valp)
+{
+	unsigned char bytes[sizeof(long)];
+	unsigned long val;
+	const struct ksplice_reloc_howto *howto = r->howto;
+
+	if (howto->size <= 0 || howto->size > sizeof(long)) {
+		ksdebug(pack, "Aborted.  Invalid relocation size.\n");
+		return UNEXPECTED;
+	}
+
+	if (probe_kernel_read(bytes, (void *)addr, howto->size) == -EFAULT)
+		return NO_MATCH;
+
+	switch (howto->size) {
+	case 1:
+		val = *(uint8_t *)bytes;
+		break;
+	case 2:
+		val = *(uint16_t *)bytes;
+		break;
+	case 4:
+		val = *(uint32_t *)bytes;
+		break;
+#if BITS_PER_LONG >= 64
+	case 8:
+		val = *(uint64_t *)bytes;
+		break;
+#endif /* BITS_PER_LONG */
+	default:
+		ksdebug(pack, "Aborted.  Invalid relocation size.\n");
+		return UNEXPECTED;
+	}
+
+	val &= howto->dst_mask;
+	if (howto->signed_addend)
+		val |= -(val & (howto->dst_mask & ~(howto->dst_mask >> 1)));
+	val <<= howto->rightshift;
+	val -= r->insn_addend + r->target_addend;
+	*valp = val;
+	return OK;
+}
+
+static abort_t write_reloc_value(struct ksplice_pack *pack,
+				 const struct ksplice_reloc *r,
+				 unsigned long addr, unsigned long sym_addr)
+{
+	unsigned long val = sym_addr + r->target_addend + r->insn_addend;
+	const struct ksplice_reloc_howto *howto = r->howto;
+	val >>= howto->rightshift;
+	switch (howto->size) {
+	case 1:
+		*(uint8_t *)addr = (*(uint8_t *)addr & ~howto->dst_mask) |
+		    (val & howto->dst_mask);
+		break;
+	case 2:
+		*(uint16_t *)addr = (*(uint16_t *)addr & ~howto->dst_mask) |
+		    (val & howto->dst_mask);
+		break;
+	case 4:
+		*(uint32_t *)addr = (*(uint32_t *)addr & ~howto->dst_mask) |
+		    (val & howto->dst_mask);
+		break;
+#if BITS_PER_LONG >= 64
+	case 8:
+		*(uint64_t *)addr = (*(uint64_t *)addr & ~howto->dst_mask) |
+		    (val & howto->dst_mask);
+		break;
+#endif /* BITS_PER_LONG */
+	default:
+		ksdebug(pack, "Aborted.  Invalid relocation size.\n");
+		return UNEXPECTED;
+	}
+
+	if (read_reloc_value(pack, r, addr, &val) != OK || val != sym_addr) {
+		ksdebug(pack, "Aborted.  Relocation overflow.\n");
+		return UNEXPECTED;
+	}
+
+	return OK;
+}
+
+static void __attribute__((noreturn)) ksplice_deleted(void)
+{
+	printk(KERN_CRIT "Called a kernel function deleted by Ksplice!\n");
+	BUG();
+}
+
+static abort_t match_pack_sections(struct ksplice_pack *pack,
+				   bool consider_data_sections)
+{
+	struct ksplice_section *sect;
+	abort_t ret;
+	int remaining = 0;
+	bool progress;
+
+	for (sect = pack->helper_sections; sect < pack->helper_sections_end;
+	     sect++) {
+		if ((sect->flags & KSPLICE_SECTION_DATA) == 0 &&
+		    (sect->flags & KSPLICE_SECTION_STRING) == 0 &&
+		    (sect->flags & KSPLICE_SECTION_MATCHED) == 0)
+			remaining++;
+	}
+
+	while (remaining > 0) {
+		progress = false;
+		for (sect = pack->helper_sections;
+		     sect < pack->helper_sections_end; sect++) {
+			if ((sect->flags & KSPLICE_SECTION_MATCHED) != 0)
+				continue;
+			if ((!consider_data_sections &&
+			     (sect->flags & KSPLICE_SECTION_DATA) != 0) ||
+			    (sect->flags & KSPLICE_SECTION_STRING) != 0)
+				continue;
+			ret = find_section(pack, sect);
+			if (ret == OK) {
+				sect->flags |= KSPLICE_SECTION_MATCHED;
+				if ((sect->flags & KSPLICE_SECTION_DATA) == 0)
+					remaining--;
+				progress = true;
+			} else if (ret != NO_MATCH) {
+				return ret;
+			}
+		}
+
+		if (progress)
+			continue;
+
+		for (sect = pack->helper_sections;
+		     sect < pack->helper_sections_end; sect++) {
+			if ((sect->flags & KSPLICE_SECTION_MATCHED) != 0 ||
+			    (sect->flags & KSPLICE_SECTION_STRING) != 0)
+				continue;
+			ksdebug(pack, "run-pre: could not match %s "
+				"section %s\n",
+				(sect->flags & KSPLICE_SECTION_DATA) != 0 ?
+				"data" :
+				(sect->flags & KSPLICE_SECTION_RODATA) != 0 ?
+				"rodata" : "text", sect->symbol->label);
+		}
+		ksdebug(pack, "Aborted.  run-pre: could not match some "
+			"sections.\n");
+		return NO_MATCH;
+	}
+	return OK;
+}
+
+static abort_t find_section(struct ksplice_pack *pack,
+			    struct ksplice_section *sect)
+{
+	int i;
+	abort_t ret;
+	unsigned long run_addr;
+	LIST_HEAD(vals);
+	struct candidate_val *v, *n;
+
+	ret = lookup_symbol(pack, sect->symbol, &vals);
+	if (ret != OK) {
+		release_vals(&vals);
+		return ret;
+	}
+
+	ksdebug(pack, "run-pre: starting sect search for %s\n",
+		sect->symbol->label);
+
+	list_for_each_entry_safe(v, n, &vals, list) {
+		run_addr = v->val;
+
+		yield();
+		ret = try_addr(pack, sect, run_addr, NULL, RUN_PRE_INITIAL);
+		if (ret == NO_MATCH) {
+			list_del(&v->list);
+			kfree(v);
+		} else if (ret != OK) {
+			release_vals(&vals);
+			return ret;
+		}
+	}
+
+	if (singular(&vals)) {
+		LIST_HEAD(safety_records);
+		run_addr = list_entry(vals.next, struct candidate_val,
+				      list)->val;
+		ret = try_addr(pack, sect, run_addr, &safety_records,
+			       RUN_PRE_FINAL);
+		release_vals(&vals);
+		if (ret != OK) {
+			clear_list(&safety_records, struct safety_record, list);
+			ksdebug(pack, "run-pre: Final run failed for sect "
+				"%s:\n", sect->symbol->label);
+		} else {
+			list_splice(&safety_records, &pack->safety_records);
+		}
+		return ret;
+	} else if (!list_empty(&vals)) {
+		struct candidate_val *val;
+		ksdebug(pack, "run-pre: multiple candidates for sect %s:\n",
+			sect->symbol->label);
+		i = 0;
+		list_for_each_entry(val, &vals, list) {
+			i++;
+			ksdebug(pack, "%lx\n", val->val);
+			if (i > 5) {
+				ksdebug(pack, "...\n");
+				break;
+			}
+		}
+		release_vals(&vals);
+		return NO_MATCH;
+	}
+	release_vals(&vals);
+	return NO_MATCH;
+}
+
+static abort_t try_addr(struct ksplice_pack *pack,
+			struct ksplice_section *sect,
+			unsigned long run_addr,
+			struct list_head *safety_records,
+			enum run_pre_mode mode)
+{
+	abort_t ret;
+	const struct module *run_module;
+
+	if ((sect->flags & KSPLICE_SECTION_RODATA) != 0 ||
+	    (sect->flags & KSPLICE_SECTION_DATA) != 0)
+		run_module = __module_data_address(run_addr);
+	else
+		run_module = __module_text_address(run_addr);
+	if (run_module == pack->primary) {
+		ksdebug(pack, "run-pre: unexpected address %lx in primary "
+			"module %s for sect %s\n", run_addr, run_module->name,
+			sect->symbol->label);
+		return UNEXPECTED;
+	}
+	if (!patches_module(run_module, pack->target)) {
+		ksdebug(pack, "run-pre: ignoring address %lx in other module "
+			"%s for sect %s\n", run_addr, run_module == NULL ?
+			"vmlinux" : run_module->name, sect->symbol->label);
+		return NO_MATCH;
+	}
+
+	ret = create_labelval(pack, sect->symbol, run_addr, TEMP);
+	if (ret != OK)
+		return ret;
+
+	ret = run_pre_cmp(pack, sect, run_addr, safety_records, mode);
+	if (ret == NO_MATCH && mode != RUN_PRE_FINAL) {
+		set_temp_labelvals(pack, NOVAL);
+		ksdebug(pack, "run-pre: %s sect %s does not match (r_a=%lx "
+			"p_a=%lx s=%lx)\n",
+			(sect->flags & KSPLICE_SECTION_RODATA) != 0 ? "rodata" :
+			(sect->flags & KSPLICE_SECTION_DATA) != 0 ? "data" :
+			"text", sect->symbol->label, run_addr, sect->address,
+			sect->size);
+		ksdebug(pack, "run-pre: ");
+		if (pack->update->debug >= 1) {
+			ret = run_pre_cmp(pack, sect, run_addr, safety_records,
+					  RUN_PRE_DEBUG);
+			set_temp_labelvals(pack, NOVAL);
+		}
+		ksdebug(pack, "\n");
+		return ret;
+	} else if (ret != OK) {
+		set_temp_labelvals(pack, NOVAL);
+		return ret;
+	}
+
+	if (mode != RUN_PRE_FINAL) {
+		set_temp_labelvals(pack, NOVAL);
+		ksdebug(pack, "run-pre: candidate for sect %s=%lx\n",
+			sect->symbol->label, run_addr);
+		return OK;
+	}
+
+	set_temp_labelvals(pack, VAL);
+	ksdebug(pack, "run-pre: found sect %s=%lx\n", sect->symbol->label,
+		run_addr);
+	return OK;
+}
+
+static abort_t run_pre_cmp(struct ksplice_pack *pack,
+			   const struct ksplice_section *sect,
+			   unsigned long run_addr,
+			   struct list_head *safety_records,
+			   enum run_pre_mode mode)
+{
+	int matched = 0;
+	abort_t ret;
+	const struct ksplice_reloc *r, *finger;
+	const unsigned char *pre, *run, *pre_start, *run_start;
+	unsigned char runval;
+
+	pre_start = (const unsigned char *)sect->address;
+	run_start = (const unsigned char *)run_addr;
+
+	finger = init_reloc_search(pack, sect);
+
+	pre = pre_start;
+	run = run_start;
+	while (pre < pre_start + sect->size) {
+		unsigned long offset = pre - pre_start;
+		ret = lookup_reloc(pack, &finger, (unsigned long)pre, &r);
+		if (ret == OK) {
+			ret = handle_reloc(pack, sect, r, (unsigned long)run,
+					   mode);
+			if (ret != OK) {
+				if (mode == RUN_PRE_INITIAL)
+					ksdebug(pack, "reloc in sect does not "
+						"match after %lx/%lx bytes\n",
+						offset, sect->size);
+				return ret;
+			}
+			if (mode == RUN_PRE_DEBUG)
+				print_bytes(pack, run, r->howto->size, pre,
+					    r->howto->size);
+			pre += r->howto->size;
+			run += r->howto->size;
+			finger++;
+			continue;
+		} else if (ret != NO_MATCH) {
+			return ret;
+		}
+
+		if ((sect->flags & KSPLICE_SECTION_TEXT) != 0) {
+			ret = handle_paravirt(pack, (unsigned long)pre,
+					      (unsigned long)run, &matched);
+			if (ret != OK)
+				return ret;
+			if (matched != 0) {
+				if (mode == RUN_PRE_DEBUG)
+					print_bytes(pack, run, matched, pre,
+						    matched);
+				pre += matched;
+				run += matched;
+				continue;
+			}
+		}
+
+		if (probe_kernel_read(&runval, (void *)run, 1) == -EFAULT) {
+			if (mode == RUN_PRE_INITIAL)
+				ksdebug(pack, "sect unmapped after %lx/%lx "
+					"bytes\n", offset, sect->size);
+			return NO_MATCH;
+		}
+
+		if (runval != *pre &&
+		    (sect->flags & KSPLICE_SECTION_DATA) == 0) {
+			if (mode == RUN_PRE_INITIAL)
+				ksdebug(pack, "sect does not match after "
+					"%lx/%lx bytes\n", offset, sect->size);
+			if (mode == RUN_PRE_DEBUG) {
+				print_bytes(pack, run, 1, pre, 1);
+				ksdebug(pack, "[p_o=%lx] ! ", offset);
+				print_bytes(pack, run + 1, 2, pre + 1, 2);
+			}
+			return NO_MATCH;
+		}
+		if (mode == RUN_PRE_DEBUG)
+			print_bytes(pack, run, 1, pre, 1);
+		pre++;
+		run++;
+	}
+	return create_safety_record(pack, sect, safety_records, run_addr,
+				    run - run_start);
+}
+
+static void print_bytes(struct ksplice_pack *pack,
+			const unsigned char *run, int runc,
+			const unsigned char *pre, int prec)
+{
+	int o;
+	int matched = min(runc, prec);
+	for (o = 0; o < matched; o++) {
+		if (run[o] == pre[o])
+			ksdebug(pack, "%02x ", run[o]);
+		else
+			ksdebug(pack, "%02x/%02x ", run[o], pre[o]);
+	}
+	for (o = matched; o < runc; o++)
+		ksdebug(pack, "%02x/ ", run[o]);
+	for (o = matched; o < prec; o++)
+		ksdebug(pack, "/%02x ", pre[o]);
+}
+
+struct range {
+	unsigned long address;
+	unsigned long size;
+};
+
+static int reloc_bsearch_compare(const void *key, const void *elt)
+{
+	const struct range *range = key;
+	const struct ksplice_reloc *r = elt;
+	if (range->address + range->size <= r->blank_addr)
+		return -1;
+	if (range->address > r->blank_addr)
+		return 1;
+	return 0;
+}
+
+static const struct ksplice_reloc *find_reloc(const struct ksplice_reloc *start,
+					      const struct ksplice_reloc *end,
+					      unsigned long address,
+					      unsigned long size)
+{
+	const struct ksplice_reloc *r;
+	struct range range = { address, size };
+	r = bsearch((void *)&range, start, end - start, sizeof(*r),
+		    reloc_bsearch_compare);
+	if (r == NULL)
+		return NULL;
+	while (r > start && (r - 1)->blank_addr >= address)
+		r--;
+	return r;
+}
+
+static const struct ksplice_reloc *
+init_reloc_search(struct ksplice_pack *pack, const struct ksplice_section *sect)
+{
+	const struct ksplice_reloc *r;
+	r = find_reloc(pack->helper_relocs, pack->helper_relocs_end,
+		       sect->address, sect->size);
+	if (r == NULL)
+		return pack->helper_relocs_end;
+	return r;
+}
+
+static abort_t lookup_reloc(struct ksplice_pack *pack,
+			    const struct ksplice_reloc **fingerp,
+			    unsigned long addr,
+			    const struct ksplice_reloc **relocp)
+{
+	const struct ksplice_reloc *r = *fingerp;
+	int canary_ret;
+
+	while (r < pack->helper_relocs_end &&
+	       addr >= r->blank_addr + r->howto->size &&
+	       !(addr == r->blank_addr && r->howto->size == 0))
+		r++;
+	*fingerp = r;
+	if (r == pack->helper_relocs_end)
+		return NO_MATCH;
+	if (addr < r->blank_addr)
+		return NO_MATCH;
+	*relocp = r;
+	if (r->howto->type != KSPLICE_HOWTO_RELOC)
+		return OK;
+
+	canary_ret = contains_canary(pack, r->blank_addr, r->howto);
+	if (canary_ret < 0)
+		return UNEXPECTED;
+	if (canary_ret == 0) {
+		ksdebug(pack, "run-pre: reloc skipped at p_a=%lx to %s+%lx "
+			"(altinstr)\n", r->blank_addr, r->symbol->label,
+			r->target_addend);
+		return NO_MATCH;
+	}
+	if (addr != r->blank_addr) {
+		ksdebug(pack, "Invalid nonzero relocation offset\n");
+		return UNEXPECTED;
+	}
+	return OK;
+}
+
+static abort_t handle_reloc(struct ksplice_pack *pack,
+			    const struct ksplice_section *sect,
+			    const struct ksplice_reloc *r,
+			    unsigned long run_addr, enum run_pre_mode mode)
+{
+	switch (r->howto->type) {
+	case KSPLICE_HOWTO_RELOC:
+		return handle_howto_reloc(pack, sect, r, run_addr, mode);
+	case KSPLICE_HOWTO_DATE:
+	case KSPLICE_HOWTO_TIME:
+		return handle_howto_date(pack, sect, r, run_addr, mode);
+	case KSPLICE_HOWTO_BUG:
+		return handle_bug(pack, r, run_addr);
+	case KSPLICE_HOWTO_EXTABLE:
+		return handle_extable(pack, r, run_addr);
+	default:
+		ksdebug(pack, "Unexpected howto type %d\n", r->howto->type);
+		return UNEXPECTED;
+	}
+}
+
+static abort_t handle_howto_date(struct ksplice_pack *pack,
+				 const struct ksplice_section *sect,
+				 const struct ksplice_reloc *r,
+				 unsigned long run_addr, enum run_pre_mode mode)
+{
+	abort_t ret;
+	char *buf = kmalloc(r->howto->size, GFP_KERNEL);
+
+	if (buf == NULL)
+		return OUT_OF_MEMORY;
+	if (probe_kernel_read(buf, (void *)run_addr, r->howto->size) == -EFAULT) {
+		ret = NO_MATCH;
+		goto out;
+	}
+
+	switch (r->howto->type) {
+	case KSPLICE_HOWTO_TIME:
+		if (isdigit(buf[0]) && isdigit(buf[1]) && buf[2] == ':' &&
+		    isdigit(buf[3]) && isdigit(buf[4]) && buf[5] == ':' &&
+		    isdigit(buf[6]) && isdigit(buf[7]))
+			ret = OK;
+		else
+			ret = NO_MATCH;
+		break;
+	case KSPLICE_HOWTO_DATE:
+		if (isalpha(buf[0]) && isalpha(buf[1]) && isalpha(buf[2]) &&
+		    buf[3] == ' ' && (buf[4] == ' ' || isdigit(buf[4])) &&
+		    isdigit(buf[5]) && buf[6] == ' ' && isdigit(buf[7]) &&
+		    isdigit(buf[8]) && isdigit(buf[9]) && isdigit(buf[10]))
+			ret = OK;
+		else
+			ret = NO_MATCH;
+		break;
+	default:
+		ret = UNEXPECTED;
+	}
+	if (ret == NO_MATCH && mode == RUN_PRE_INITIAL)
+		ksdebug(pack, "%s string: \"%.*s\" does not match format\n",
+			r->howto->type == KSPLICE_HOWTO_DATE ? "date" : "time",
+			r->howto->size, buf);
+
+	if (ret != OK)
+		goto out;
+	ret = create_labelval(pack, r->symbol, run_addr, TEMP);
+out:
+	kfree(buf);
+	return ret;
+}
+
+static abort_t handle_howto_reloc(struct ksplice_pack *pack,
+				  const struct ksplice_section *sect,
+				  const struct ksplice_reloc *r,
+				  unsigned long run_addr,
+				  enum run_pre_mode mode)
+{
+	struct ksplice_section *sym_sect = symbol_section(pack, r->symbol);
+	unsigned long offset = r->target_addend;
+	unsigned long val;
+	abort_t ret;
+
+	ret = read_reloc_value(pack, r, run_addr, &val);
+	if (ret != OK)
+		return ret;
+	if (r->howto->pcrel)
+		val += run_addr;
+
+	if (mode == RUN_PRE_INITIAL)
+		ksdebug(pack, "run-pre: reloc at r_a=%lx p_a=%lx to %s+%lx: "
+			"found %s = %lx\n", run_addr, r->blank_addr,
+			r->symbol->label, offset, r->symbol->label, val);
+
+	if (contains_canary(pack, run_addr, r->howto) != 0) {
+		ksdebug(pack, "Aborted.  Unexpected canary in run code at %lx"
+			"\n", run_addr);
+		return UNEXPECTED;
+	}
+
+	if ((sect->flags & KSPLICE_SECTION_DATA) != 0 &&
+	    sect->symbol == r->symbol)
+		return OK;
+	ret = create_labelval(pack, r->symbol, val, TEMP);
+	if (ret == NO_MATCH && mode == RUN_PRE_INITIAL)
+		ksdebug(pack, "run-pre: reloc at r_a=%lx p_a=%lx: labelval %s "
+			"= %lx does not match expected %lx\n", run_addr,
+			r->blank_addr, r->symbol->label, r->symbol->value, val);
+
+	if (ret != OK)
+		return ret;
+	if (sym_sect != NULL && (sym_sect->flags & KSPLICE_SECTION_MATCHED) == 0
+	    && (sym_sect->flags & KSPLICE_SECTION_STRING) != 0) {
+		if (mode == RUN_PRE_INITIAL)
+			ksdebug(pack, "Recursively comparing string section "
+				"%s\n", sym_sect->symbol->label);
+		else if (mode == RUN_PRE_DEBUG)
+			ksdebug(pack, "[str start] ");
+		ret = run_pre_cmp(pack, sym_sect, val, NULL, mode);
+		if (mode == RUN_PRE_DEBUG)
+			ksdebug(pack, "[str end] ");
+		if (ret == OK && mode == RUN_PRE_INITIAL)
+			ksdebug(pack, "Successfully matched string section %s"
+				"\n", sym_sect->symbol->label);
+		else if (mode == RUN_PRE_INITIAL)
+			ksdebug(pack, "Failed to match string section %s\n",
+				sym_sect->symbol->label);
+	}
+	return ret;
+}
+
+static int symbol_section_bsearch_compare(const void *a, const void *b)
+{
+	const struct ksplice_symbol *sym = a;
+	const struct ksplice_section *sect = b;
+	return strcmp(sym->label, sect->symbol->label);
+}
+
+static int compare_section_labels(const void *va, const void *vb)
+{
+	const struct ksplice_section *a = va, *b = vb;
+	return strcmp(a->symbol->label, b->symbol->label);
+}
+
+static struct ksplice_section *symbol_section(struct ksplice_pack *pack,
+					      const struct ksplice_symbol *sym)
+{
+	return bsearch(sym, pack->helper_sections, pack->helper_sections_end -
+		       pack->helper_sections, sizeof(struct ksplice_section),
+		       symbol_section_bsearch_compare);
+}
+
+static const struct ksplice_reloc *patch_reloc(struct ksplice_pack *pack,
+					       const struct ksplice_patch *p)
+{
+	unsigned long addr = (unsigned long)&p->oldaddr;
+	const struct ksplice_reloc *r =
+	    find_reloc(pack->primary_relocs, pack->primary_relocs_end, addr,
+		       sizeof(addr));
+	if (r == NULL || r->blank_addr < addr ||
+	    r->blank_addr >= addr + sizeof(addr))
+		return NULL;
+	return r;
+}
+
+static abort_t lookup_symbol(struct ksplice_pack *pack,
+			     const struct ksplice_symbol *ksym,
+			     struct list_head *vals)
+{
+	abort_t ret;
+
+	if (ksym->vals == NULL) {
+		release_vals(vals);
+		ksdebug(pack, "using detected sym %s=%lx\n", ksym->label,
+			ksym->value);
+		return add_candidate_val(pack, vals, ksym->value);
+	}
+
+	if (strcmp(ksym->label, "cleanup_module") == 0 && pack->target != NULL
+	    && pack->target->exit != NULL) {
+		ret = add_candidate_val(pack, vals,
+					(unsigned long)pack->target->exit);
+		if (ret != OK)
+			return ret;
+	}
+
+	if (ksym->name != NULL) {
+		struct candidate_val *val;
+		list_for_each_entry(val, ksym->vals, list) {
+			ret = add_candidate_val(pack, vals, val->val);
+			if (ret != OK)
+				return ret;
+		}
+
+		ret = new_export_lookup(pack, ksym->name, vals);
+		if (ret != OK)
+			return ret;
+	}
+
+	return OK;
+}
+
+static abort_t new_export_lookup(struct ksplice_pack *ipack, const char *name,
+				 struct list_head *vals)
+{
+	struct ksplice_pack *pack;
+	struct ksplice_patch *p;
+	list_for_each_entry(pack, &ipack->update->packs, list) {
+		for (p = pack->patches; p < pack->patches_end; p++) {
+			const struct kernel_symbol *sym;
+			const struct ksplice_reloc *r;
+			if (p->type != KSPLICE_PATCH_EXPORT ||
+			    strcmp(name, *(const char **)p->contents) != 0)
+				continue;
+
+			/* Check that the p->oldaddr reloc has been resolved */
+			r = patch_reloc(pack, p);
+			if (r == NULL ||
+			    contains_canary(pack, r->blank_addr, r->howto) != 0)
+				continue;
+			sym = (const struct kernel_symbol *)r->symbol->value;
+
+			/* Check that the sym->value reloc has been resolved,
+			   if there is a ksplice relocation there */
+			r = find_reloc(pack->primary_relocs,
+				       pack->primary_relocs_end,
+				       (unsigned long)&sym->value,
+				       sizeof(&sym->value));
+			if (r != NULL &&
+			    r->blank_addr == (unsigned long)&sym->value &&
+			    contains_canary(pack, r->blank_addr, r->howto) != 0)
+				continue;
+			return add_candidate_val(ipack, vals, sym->value);
+		}
+	}
+	return OK;
+}
+
+static abort_t apply_patches(struct update *update)
+{
+	int i;
+	abort_t ret;
+	struct ksplice_pack *pack;
+
+	ret = map_trampoline_pages(update);
+	if (ret != OK)
+		return ret;
+
+	list_for_each_entry(pack, &update->packs, list) {
+		const typeof(int (*)(void)) *f;
+		for (f = pack->pre_apply; f < pack->pre_apply_end; f++) {
+			if ((*f)() != 0) {
+				ret = CALL_FAILED;
+				goto out;
+			}
+		}
+	}
+
+	for (i = 0; i < 5; i++) {
+		cleanup_conflicts(update);
+		ret = (__force abort_t)stop_machine(__apply_patches, update,
+						    NULL);
+		if (ret != CODE_BUSY)
+			break;
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(1000));
+	}
+out:
+	unmap_trampoline_pages(update);
+
+	if (ret == CODE_BUSY) {
+		print_conflicts(update);
+		_ksdebug(update, "Aborted %s.  stack check: to-be-replaced "
+			 "code is busy.\n", update->kid);
+	} else if (ret == ALREADY_REVERSED) {
+		_ksdebug(update, "Aborted %s.  Ksplice update %s is already "
+			 "reversed.\n", update->kid, update->kid);
+	}
+
+	if (ret != OK) {
+		list_for_each_entry(pack, &update->packs, list) {
+			const typeof(void (*)(void)) *f;
+			for (f = pack->fail_apply; f < pack->fail_apply_end;
+			     f++)
+				(*f)();
+		}
+
+		return ret;
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		const typeof(void (*)(void)) *f;
+		for (f = pack->post_apply; f < pack->post_apply_end; f++)
+			(*f)();
+	}
+
+	_ksdebug(update, "Atomic patch insertion for %s complete\n",
+		 update->kid);
+	return OK;
+}
+
+static abort_t reverse_patches(struct update *update)
+{
+	int i;
+	abort_t ret;
+	struct ksplice_pack *pack;
+
+	clear_debug_buf(update);
+	ret = init_debug_buf(update);
+	if (ret != OK)
+		return ret;
+
+	_ksdebug(update, "Preparing to reverse %s\n", update->kid);
+
+	ret = map_trampoline_pages(update);
+	if (ret != OK)
+		return ret;
+
+	list_for_each_entry(pack, &update->packs, list) {
+		const typeof(int (*)(void)) *f;
+		for (f = pack->pre_reverse; f < pack->pre_reverse_end; f++) {
+			if ((*f)() != 0) {
+				ret = CALL_FAILED;
+				goto out;
+			}
+		}
+	}
+
+	for (i = 0; i < 5; i++) {
+		cleanup_conflicts(update);
+		clear_list(&update->conflicts, struct conflict, list);
+		ret = (__force abort_t)stop_machine(__reverse_patches, update,
+						    NULL);
+		if (ret != CODE_BUSY)
+			break;
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(1000));
+	}
+out:
+	unmap_trampoline_pages(update);
+
+	if (ret == CODE_BUSY) {
+		print_conflicts(update);
+		_ksdebug(update, "Aborted %s.  stack check: to-be-reversed "
+			 "code is busy.\n", update->kid);
+	} else if (ret == MODULE_BUSY) {
+		_ksdebug(update, "Update %s is in use by another module\n",
+			 update->kid);
+	}
+
+	if (ret != OK) {
+		list_for_each_entry(pack, &update->packs, list) {
+			const typeof(void (*)(void)) *f;
+			for (f = pack->fail_reverse; f < pack->fail_reverse_end;
+			     f++)
+				(*f)();
+		}
+
+		return ret;
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		const typeof(void (*)(void)) *f;
+		for (f = pack->post_reverse; f < pack->post_reverse_end; f++)
+			(*f)();
+	}
+
+	list_for_each_entry(pack, &update->packs, list)
+		clear_list(&pack->safety_records, struct safety_record, list);
+
+	_ksdebug(update, "Atomic patch removal for %s complete\n", update->kid);
+	return OK;
+}
+
+static int __apply_patches(void *updateptr)
+{
+	struct update *update = updateptr;
+	struct ksplice_pack *pack;
+	struct ksplice_patch *p;
+	abort_t ret;
+
+	if (update->stage == STAGE_APPLIED)
+		return (__force int)OK;
+
+	if (update->stage != STAGE_PREPARING)
+		return (__force int)UNEXPECTED;
+
+	ret = check_each_task(update);
+	if (ret != OK)
+		return (__force int)ret;
+
+	list_for_each_entry(pack, &update->packs, list) {
+		if (try_module_get(pack->primary) != 1) {
+			struct ksplice_pack *pack1;
+			list_for_each_entry(pack1, &update->packs, list) {
+				if (pack1 == pack)
+					break;
+				module_put(pack1->primary);
+			}
+			module_put(THIS_MODULE);
+			return (__force int)UNEXPECTED;
+		}
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		const typeof(int (*)(void)) *f;
+		for (f = pack->check_apply; f < pack->check_apply_end; f++)
+			if ((*f)() != 0)
+				return (__force int)CALL_FAILED;
+	}
+
+	update->stage = STAGE_APPLIED;
+	add_taint(TAINT_KSPLICE);
+
+	list_for_each_entry(pack, &update->packs, list)
+		list_add(&pack->module_list_entry.list, &ksplice_module_list);
+
+	list_for_each_entry(pack, &update->packs, list) {
+		for (p = pack->patches; p < pack->patches_end; p++)
+			insert_trampoline(p);
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		const typeof(void (*)(void)) *f;
+		for (f = pack->apply; f < pack->apply_end; f++)
+			(*f)();
+	}
+
+	return (__force int)OK;
+}
+
+static int __reverse_patches(void *updateptr)
+{
+	struct update *update = updateptr;
+	struct ksplice_pack *pack;
+	const struct ksplice_patch *p;
+	abort_t ret;
+
+	if (update->stage != STAGE_APPLIED)
+		return (__force int)OK;
+
+	list_for_each_entry(pack, &update->packs, list) {
+		if (module_refcount(pack->primary) != 1)
+			return (__force int)MODULE_BUSY;
+	}
+
+	ret = check_each_task(update);
+	if (ret != OK)
+		return (__force int)ret;
+
+	list_for_each_entry(pack, &update->packs, list) {
+		for (p = pack->patches; p < pack->patches_end; p++) {
+			ret = verify_trampoline(pack, p);
+			if (ret != OK)
+				return (__force int)ret;
+		}
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		const typeof(int (*)(void)) *f;
+		for (f = pack->check_reverse; f < pack->check_reverse_end; f++)
+			if ((*f)() != 0)
+				return (__force int)CALL_FAILED;
+	}
+
+	update->stage = STAGE_REVERSED;
+
+	list_for_each_entry(pack, &update->packs, list)
+		module_put(pack->primary);
+
+	list_for_each_entry(pack, &update->packs, list)
+		list_del(&pack->module_list_entry.list);
+
+	list_for_each_entry(pack, &update->packs, list) {
+		const typeof(void (*)(void)) *f;
+		for (f = pack->reverse; f < pack->reverse_end; f++)
+			(*f)();
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		for (p = pack->patches; p < pack->patches_end; p++)
+			remove_trampoline(p);
+	}
+
+	return (__force int)OK;
+}
+
+static abort_t check_each_task(struct update *update)
+{
+	const struct task_struct *g, *p;
+	abort_t status = OK, ret;
+	do_each_thread(g, p) {
+		/* do_each_thread is a double loop! */
+		ret = check_task(update, p, false);
+		if (ret != OK) {
+			check_task(update, p, true);
+			status = ret;
+		}
+		if (ret != OK && ret != CODE_BUSY)
+			return ret;
+	} while_each_thread(g, p);
+	return status;
+}
+
+static abort_t check_task(struct update *update,
+			  const struct task_struct *t, bool rerun)
+{
+	abort_t status, ret;
+	struct conflict *conf = NULL;
+
+	if (rerun) {
+		conf = kmalloc(sizeof(*conf), GFP_ATOMIC);
+		if (conf == NULL)
+			return OUT_OF_MEMORY;
+		conf->process_name = kstrdup(t->comm, GFP_ATOMIC);
+		if (conf->process_name == NULL) {
+			kfree(conf);
+			return OUT_OF_MEMORY;
+		}
+		conf->pid = t->pid;
+		INIT_LIST_HEAD(&conf->stack);
+		list_add(&conf->list, &update->conflicts);
+	}
+
+	status = check_address(update, conf, KSPLICE_IP(t));
+	if (t == current) {
+		ret = check_stack(update, conf, task_thread_info(t),
+				  (unsigned long *)__builtin_frame_address(0));
+		if (status == OK)
+			status = ret;
+	} else if (!task_curr(t)) {
+		ret = check_stack(update, conf, task_thread_info(t),
+				  (unsigned long *)KSPLICE_SP(t));
+		if (status == OK)
+			status = ret;
+	} else if (!is_stop_machine(t)) {
+		status = UNEXPECTED_RUNNING_TASK;
+	}
+	return status;
+}
+
+static abort_t check_stack(struct update *update, struct conflict *conf,
+			   const struct thread_info *tinfo,
+			   const unsigned long *stack)
+{
+	abort_t status = OK, ret;
+	unsigned long addr;
+
+	while (valid_stack_ptr(tinfo, stack)) {
+		addr = *stack++;
+		ret = check_address(update, conf, addr);
+		if (ret != OK)
+			status = ret;
+	}
+	return status;
+}
+
+static abort_t check_address(struct update *update,
+			     struct conflict *conf, unsigned long addr)
+{
+	abort_t status = OK, ret;
+	const struct safety_record *rec;
+	struct ksplice_pack *pack;
+	struct conflict_addr *ca = NULL;
+
+	if (conf != NULL) {
+		ca = kmalloc(sizeof(*ca), GFP_ATOMIC);
+		if (ca == NULL)
+			return OUT_OF_MEMORY;
+		ca->addr = addr;
+		ca->has_conflict = false;
+		ca->label = NULL;
+		list_add(&ca->list, &conf->stack);
+	}
+
+	list_for_each_entry(pack, &update->packs, list) {
+		unsigned long tramp_addr = follow_trampolines(pack, addr);
+		list_for_each_entry(rec, &pack->safety_records, list) {
+			ret = check_record(ca, rec, tramp_addr);
+			if (ret != OK)
+				status = ret;
+		}
+	}
+	return status;
+}
+
+static abort_t check_record(struct conflict_addr *ca,
+			    const struct safety_record *rec, unsigned long addr)
+{
+	if (addr >= rec->addr && addr < rec->addr + rec->size) {
+		if (ca != NULL) {
+			ca->label = rec->label;
+			ca->has_conflict = true;
+		}
+		return CODE_BUSY;
+	}
+	return OK;
+}
+
+static bool is_stop_machine(const struct task_struct *t)
+{
+	const char *kstop_prefix = "kstop/";
+	const char *num;
+	if (!starts_with(t->comm, kstop_prefix))
+		return false;
+	num = t->comm + strlen(kstop_prefix);
+	return num[strspn(num, "0123456789")] == '\0';
+}
+
+static void cleanup_conflicts(struct update *update)
+{
+	struct conflict *conf;
+	list_for_each_entry(conf, &update->conflicts, list) {
+		clear_list(&conf->stack, struct conflict_addr, list);
+		kfree(conf->process_name);
+	}
+	clear_list(&update->conflicts, struct conflict, list);
+}
+
+static void print_conflicts(struct update *update)
+{
+	const struct conflict *conf;
+	const struct conflict_addr *ca;
+	list_for_each_entry(conf, &update->conflicts, list) {
+		_ksdebug(update, "stack check: pid %d (%s):", conf->pid,
+			 conf->process_name);
+		list_for_each_entry(ca, &conf->stack, list) {
+			_ksdebug(update, " %lx", ca->addr);
+			if (ca->has_conflict)
+				_ksdebug(update, " [<-CONFLICT]");
+		}
+		_ksdebug(update, "\n");
+	}
+}
+
+static void insert_trampoline(struct ksplice_patch *p)
+{
+	mm_segment_t old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	memcpy(p->saved, p->vaddr, p->size);
+	memcpy(p->vaddr, p->contents, p->size);
+	flush_icache_range(p->oldaddr, p->oldaddr + p->size);
+	set_fs(old_fs);
+}
+
+static abort_t verify_trampoline(struct ksplice_pack *pack,
+				 const struct ksplice_patch *p)
+{
+	if (memcmp(p->vaddr, p->contents, p->size) != 0) {
+		ksdebug(pack, "Aborted.  Trampoline at %lx has been "
+			"overwritten.\n", p->oldaddr);
+		return CODE_BUSY;
+	}
+	return OK;
+}
+
+static void remove_trampoline(const struct ksplice_patch *p)
+{
+	mm_segment_t old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	memcpy(p->vaddr, p->saved, p->size);
+	flush_icache_range(p->oldaddr, p->oldaddr + p->size);
+	set_fs(old_fs);
+}
+
+static abort_t create_labelval(struct ksplice_pack *pack,
+			       struct ksplice_symbol *ksym,
+			       unsigned long val, int status)
+{
+	val = follow_trampolines(pack, val);
+	if (ksym->vals == NULL)
+		return ksym->value == val ? OK : NO_MATCH;
+
+	ksym->value = val;
+	if (status == TEMP) {
+		struct labelval *lv = kmalloc(sizeof(*lv), GFP_KERNEL);
+		if (lv == NULL)
+			return OUT_OF_MEMORY;
+		lv->symbol = ksym;
+		lv->saved_vals = ksym->vals;
+		list_add(&lv->list, &pack->temp_labelvals);
+	}
+	ksym->vals = NULL;
+	return OK;
+}
+
+static abort_t create_safety_record(struct ksplice_pack *pack,
+				    const struct ksplice_section *sect,
+				    struct list_head *record_list,
+				    unsigned long run_addr,
+				    unsigned long run_size)
+{
+	struct safety_record *rec;
+	struct ksplice_patch *p;
+
+	if (record_list == NULL)
+		return OK;
+
+	for (p = pack->patches; p < pack->patches_end; p++) {
+		const struct ksplice_reloc *r = patch_reloc(pack, p);
+		if (strcmp(sect->symbol->label, r->symbol->label) == 0)
+			break;
+	}
+	if (p >= pack->patches_end)
+		return OK;
+
+	rec = kmalloc(sizeof(*rec), GFP_KERNEL);
+	if (rec == NULL)
+		return OUT_OF_MEMORY;
+	rec->label = kstrdup(sect->symbol->label, GFP_KERNEL);
+	if (rec->label == NULL) {
+		kfree(rec);
+		return OUT_OF_MEMORY;
+	}
+	rec->addr = run_addr;
+	rec->size = run_size;
+
+	list_add(&rec->list, record_list);
+	return OK;
+}
+
+static abort_t add_candidate_val(struct ksplice_pack *pack,
+				 struct list_head *vals, unsigned long val)
+{
+	struct candidate_val *tmp, *new;
+	val = follow_trampolines(pack, val);
+
+	list_for_each_entry(tmp, vals, list) {
+		if (tmp->val == val)
+			return OK;
+	}
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (new == NULL)
+		return OUT_OF_MEMORY;
+	new->val = val;
+	list_add(&new->list, vals);
+	return OK;
+}
+
+static void release_vals(struct list_head *vals)
+{
+	clear_list(vals, struct candidate_val, list);
+}
+
+static void set_temp_labelvals(struct ksplice_pack *pack, int status)
+{
+	struct labelval *lv, *n;
+	list_for_each_entry_safe(lv, n, &pack->temp_labelvals, list) {
+		if (status == NOVAL) {
+			lv->symbol->vals = lv->saved_vals;
+		} else {
+			release_vals(lv->saved_vals);
+			kfree(lv->saved_vals);
+		}
+		list_del(&lv->list);
+		kfree(lv);
+	}
+}
+
+static int contains_canary(struct ksplice_pack *pack, unsigned long blank_addr,
+			   const struct ksplice_reloc_howto *howto)
+{
+	switch (howto->size) {
+	case 1:
+		return (*(uint8_t *)blank_addr & howto->dst_mask) ==
+		    (KSPLICE_CANARY & howto->dst_mask);
+	case 2:
+		return (*(uint16_t *)blank_addr & howto->dst_mask) ==
+		    (KSPLICE_CANARY & howto->dst_mask);
+	case 4:
+		return (*(uint32_t *)blank_addr & howto->dst_mask) ==
+		    (KSPLICE_CANARY & howto->dst_mask);
+#if BITS_PER_LONG >= 64
+	case 8:
+		return (*(uint64_t *)blank_addr & howto->dst_mask) ==
+		    (KSPLICE_CANARY & howto->dst_mask);
+#endif /* BITS_PER_LONG */
+	default:
+		ksdebug(pack, "Aborted.  Invalid relocation size.\n");
+		return -1;
+	}
+}
+
+static unsigned long follow_trampolines(struct ksplice_pack *pack,
+					unsigned long addr)
+{
+	unsigned long new_addr;
+	struct module *m;
+
+	while (1) {
+		if (!__kernel_text_address(addr) ||
+		    trampoline_target(pack, addr, &new_addr) != OK)
+			return addr;
+		m = __module_text_address(new_addr);
+		if (m == NULL || m == pack->target ||
+		    !starts_with(m->name, "ksplice"))
+			return addr;
+		addr = new_addr;
+	}
+}
+
+/* Does module a patch module b? */
+static bool patches_module(const struct module *a, const struct module *b)
+{
+	struct ksplice_module_list_entry *entry;
+	if (a == b)
+		return true;
+	list_for_each_entry(entry, &ksplice_module_list, list) {
+		if (entry->target == b && entry->primary == a)
+			return true;
+	}
+	return false;
+}
+
+static bool starts_with(const char *str, const char *prefix)
+{
+	return strncmp(str, prefix, strlen(prefix)) == 0;
+}
+
+static bool singular(struct list_head *list)
+{
+	return !list_empty(list) && list->next->next == list;
+}
+
+static void *bsearch(const void *key, const void *base, size_t n,
+		     size_t size, int (*cmp)(const void *key, const void *elt))
+{
+	int start = 0, end = n - 1, mid, result;
+	if (n == 0)
+		return NULL;
+	while (start <= end) {
+		mid = (start + end) / 2;
+		result = cmp(key, base + mid * size);
+		if (result < 0)
+			end = mid - 1;
+		else if (result > 0)
+			start = mid + 1;
+		else
+			return (void *)base + mid * size;
+	}
+	return NULL;
+}
+
+static int compare_relocs(const void *a, const void *b)
+{
+	const struct ksplice_reloc *ra = a, *rb = b;
+	if (ra->blank_addr > rb->blank_addr)
+		return 1;
+	else if (ra->blank_addr < rb->blank_addr)
+		return -1;
+	else
+		return ra->howto->size - rb->howto->size;
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+static abort_t init_debug_buf(struct update *update)
+{
+	update->debug_blob.size = 0;
+	update->debug_blob.data = NULL;
+	update->debugfs_dentry =
+	    debugfs_create_blob(update->name, S_IFREG | S_IRUSR, NULL,
+				&update->debug_blob);
+	if (update->debugfs_dentry == NULL)
+		return OUT_OF_MEMORY;
+	return OK;
+}
+
+static void clear_debug_buf(struct update *update)
+{
+	if (update->debugfs_dentry == NULL)
+		return;
+	debugfs_remove(update->debugfs_dentry);
+	update->debugfs_dentry = NULL;
+	update->debug_blob.size = 0;
+	vfree(update->debug_blob.data);
+	update->debug_blob.data = NULL;
+}
+
+static int _ksdebug(struct update *update, const char *fmt, ...)
+{
+	va_list args;
+	unsigned long size, old_size, new_size;
+
+	if (update->debug == 0)
+		return 0;
+
+	/* size includes the trailing '\0' */
+	va_start(args, fmt);
+	size = 1 + vsnprintf(update->debug_blob.data, 0, fmt, args);
+	va_end(args);
+	old_size = update->debug_blob.size == 0 ? 0 :
+	    max(PAGE_SIZE, roundup_pow_of_two(update->debug_blob.size));
+	new_size = update->debug_blob.size + size == 0 ? 0 :
+	    max(PAGE_SIZE, roundup_pow_of_two(update->debug_blob.size + size));
+	if (new_size > old_size) {
+		char *buf = vmalloc(new_size);
+		if (buf == NULL)
+			return -ENOMEM;
+		memcpy(buf, update->debug_blob.data, update->debug_blob.size);
+		vfree(update->debug_blob.data);
+		update->debug_blob.data = buf;
+	}
+	va_start(args, fmt);
+	update->debug_blob.size += vsnprintf(update->debug_blob.data +
+					     update->debug_blob.size,
+					     size, fmt, args);
+	va_end(args);
+	return 0;
+}
+#else /* CONFIG_DEBUG_FS */
+static abort_t init_debug_buf(struct update *update)
+{
+	return OK;
+}
+
+static void clear_debug_buf(struct update *update)
+{
+	return;
+}
+
+static int _ksdebug(struct update *update, const char *fmt, ...)
+{
+	va_list args;
+
+	if (update->debug == 0)
+		return 0;
+
+	if (!update->debug_continue_line)
+		printk(KERN_DEBUG "ksplice: ");
+
+	va_start(args, fmt);
+	vprintk(fmt, args);
+	va_end(args);
+
+	update->debug_continue_line =
+	    fmt[0] == '\0' || fmt[strlen(fmt) - 1] != '\n';
+	return 0;
+}
+#endif /* CONFIG_DEBUG_FS */
+
+struct ksplice_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct update *update, char *buf);
+	ssize_t (*store)(struct update *update, const char *buf, size_t len);
+};
+
+static ssize_t ksplice_attr_show(struct kobject *kobj, struct attribute *attr,
+				 char *buf)
+{
+	struct ksplice_attribute *attribute =
+	    container_of(attr, struct ksplice_attribute, attr);
+	struct update *update = container_of(kobj, struct update, kobj);
+	if (attribute->show == NULL)
+		return -EIO;
+	return attribute->show(update, buf);
+}
+
+static ssize_t ksplice_attr_store(struct kobject *kobj, struct attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct ksplice_attribute *attribute =
+	    container_of(attr, struct ksplice_attribute, attr);
+	struct update *update = container_of(kobj, struct update, kobj);
+	if (attribute->store == NULL)
+		return -EIO;
+	return attribute->store(update, buf, len);
+}
+
+static struct sysfs_ops ksplice_sysfs_ops = {
+	.show = ksplice_attr_show,
+	.store = ksplice_attr_store,
+};
+
+static void ksplice_release(struct kobject *kobj)
+{
+	struct update *update;
+	update = container_of(kobj, struct update, kobj);
+	cleanup_ksplice_update(update);
+}
+
+static ssize_t stage_show(struct update *update, char *buf)
+{
+	switch (update->stage) {
+	case STAGE_PREPARING:
+		return snprintf(buf, PAGE_SIZE, "preparing\n");
+	case STAGE_APPLIED:
+		return snprintf(buf, PAGE_SIZE, "applied\n");
+	case STAGE_REVERSED:
+		return snprintf(buf, PAGE_SIZE, "reversed\n");
+	}
+	return 0;
+}
+
+static ssize_t abort_cause_show(struct update *update, char *buf)
+{
+	switch (update->abort_cause) {
+	case OK:
+		return snprintf(buf, PAGE_SIZE, "ok\n");
+	case NO_MATCH:
+		return snprintf(buf, PAGE_SIZE, "no_match\n");
+	case CODE_BUSY:
+		return snprintf(buf, PAGE_SIZE, "code_busy\n");
+	case MODULE_BUSY:
+		return snprintf(buf, PAGE_SIZE, "module_busy\n");
+	case OUT_OF_MEMORY:
+		return snprintf(buf, PAGE_SIZE, "out_of_memory\n");
+	case FAILED_TO_FIND:
+		return snprintf(buf, PAGE_SIZE, "failed_to_find\n");
+	case ALREADY_REVERSED:
+		return snprintf(buf, PAGE_SIZE, "already_reversed\n");
+	case MISSING_EXPORT:
+		return snprintf(buf, PAGE_SIZE, "missing_export\n");
+	case UNEXPECTED_RUNNING_TASK:
+		return snprintf(buf, PAGE_SIZE, "unexpected_running_task\n");
+	case TARGET_NOT_LOADED:
+		return snprintf(buf, PAGE_SIZE, "target_not_loaded\n");
+	case CALL_FAILED:
+		return snprintf(buf, PAGE_SIZE, "call_failed\n");
+	case UNEXPECTED:
+		return snprintf(buf, PAGE_SIZE, "unexpected\n");
+	default:
+		return snprintf(buf, PAGE_SIZE, "unknown\n");
+	}
+	return 0;
+}
+
+static ssize_t conflict_show(struct update *update, char *buf)
+{
+	const struct conflict *conf;
+	const struct conflict_addr *ca;
+	int used = 0;
+	list_for_each_entry(conf, &update->conflicts, list) {
+		used += snprintf(buf + used, PAGE_SIZE - used, "%s %d",
+				 conf->process_name, conf->pid);
+		list_for_each_entry(ca, &conf->stack, list) {
+			if (!ca->has_conflict)
+				continue;
+			used += snprintf(buf + used, PAGE_SIZE - used, " %s",
+					 ca->label);
+		}
+		used += snprintf(buf + used, PAGE_SIZE - used, "\n");
+	}
+	return used;
+}
+
+static int maybe_cleanup_ksplice_update_wrapper(void *updateptr)
+{
+	struct update *update = updateptr;
+	maybe_cleanup_ksplice_update(update);
+	return 0;
+}
+
+static ssize_t stage_store(struct update *update, const char *buf, size_t len)
+{
+	enum stage old_stage = update->stage;
+	if ((strncmp(buf, "applied", len) == 0 ||
+	     strncmp(buf, "applied\n", len) == 0) &&
+	    update->stage == STAGE_PREPARING)
+		update->abort_cause = apply_update(update);
+	else if ((strncmp(buf, "reversed", len) == 0 ||
+		  strncmp(buf, "reversed\n", len) == 0) &&
+		 update->stage == STAGE_APPLIED)
+		update->abort_cause = reverse_patches(update);
+	else if ((strncmp(buf, "cleanup", len) == 0 ||
+		  strncmp(buf, "cleanup\n", len) == 0) &&
+		 update->stage == STAGE_REVERSED)
+		kthread_run(maybe_cleanup_ksplice_update_wrapper, update,
+			    "ksplice_cleanup_%s", update->kid);
+
+	if (old_stage != STAGE_REVERSED && update->abort_cause == OK)
+		printk(KERN_INFO "ksplice: Update %s %s successfully\n",
+		       update->kid,
+		       update->stage == STAGE_APPLIED ? "applied" : "reversed");
+	return len;
+}
+
+static ssize_t debug_show(struct update *update, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", update->debug);
+}
+
+static ssize_t debug_store(struct update *update, const char *buf, size_t len)
+{
+	unsigned long l;
+	int ret = strict_strtoul(buf, 10, &l);
+	if (ret != 0)
+		return ret;
+	update->debug = l;
+	return len;
+}
+
+static ssize_t partial_show(struct update *update, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", update->partial);
+}
+
+static ssize_t partial_store(struct update *update, const char *buf, size_t len)
+{
+	unsigned long l;
+	int ret = strict_strtoul(buf, 10, &l);
+	if (ret != 0)
+		return ret;
+	update->partial = l;
+	return len;
+}
+
+static struct ksplice_attribute stage_attribute =
+	__ATTR(stage, 0600, stage_show, stage_store);
+static struct ksplice_attribute abort_cause_attribute =
+	__ATTR(abort_cause, 0400, abort_cause_show, NULL);
+static struct ksplice_attribute debug_attribute =
+	__ATTR(debug, 0600, debug_show, debug_store);
+static struct ksplice_attribute partial_attribute =
+	__ATTR(partial, 0600, partial_show, partial_store);
+static struct ksplice_attribute conflict_attribute =
+	__ATTR(conflicts, 0400, conflict_show, NULL);
+
+static struct attribute *ksplice_attrs[] = {
+	&stage_attribute.attr,
+	&abort_cause_attribute.attr,
+	&debug_attribute.attr,
+	&partial_attribute.attr,
+	&conflict_attribute.attr,
+	NULL
+};
+
+static struct kobj_type ksplice_ktype = {
+	.sysfs_ops = &ksplice_sysfs_ops,
+	.release = ksplice_release,
+	.default_attrs = ksplice_attrs,
+};
+
+static int init_ksplice(void)
+{
+	ksplice_kobj = kobject_create_and_add("ksplice", kernel_kobj);
+	if (ksplice_kobj == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void cleanup_ksplice(void)
+{
+	kobject_put(ksplice_kobj);
+}
+
+module_init(init_ksplice);
+module_exit(cleanup_ksplice);
+
+MODULE_AUTHOR("Jeff Arnold <jbarnold@mit.edu>");
+MODULE_DESCRIPTION("Ksplice rebootless update system");
+MODULE_LICENSE("GPL v2");
diff --git a/kernel/panic.c b/kernel/panic.c
index 4d50883..f2ca7bf 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -155,6 +155,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_OVERRIDDEN_ACPI_TABLE, 'A', ' ' },
 	{ TAINT_WARN, 'W', ' ' },
 	{ TAINT_CRAP, 'C', ' ' },
+	{ TAINT_KSPLICE, 'K', ' ' },
 };
 
 /**
-- 
1.5.6.3

