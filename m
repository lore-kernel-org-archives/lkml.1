Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbYIMFT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbYIMFT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 01:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYIMFR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 01:17:59 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40806 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651AbYIMFR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 01:17:57 -0400
From: Jeffrey Brian Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC v2 PATCH 6/9] Ksplice: Documentation
Date: Sat, 13 Sep 2008 01:14:42 -0400
Message-Id: <6ba306125ffc8fbcf9ceb2960645827523247689.1221282535.git.jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <a827aed330aec871b73c468cf61c27048b26574d.1221282535.git.jbarnold@mit.edu>
References: <1221282885-1150-1-git-send-email-jbarnold@mit.edu>
 <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
 <8cfda1c8f6c46e2f0fa9e9279aa2b2a213fba7a4.1221282535.git.jbarnold@mit.edu>
 <bdf8d7b52e2cb9ff3bbed52cedd28294086c9f56.1221282535.git.jbarnold@mit.edu>
 <401afda17296e380049b129c92a9ae27e8e47fc3.1221282535.git.jbarnold@mit.edu>
 <a827aed330aec871b73c468cf61c27048b26574d.1221282535.git.jbarnold@mit.edu>
In-Reply-To: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
References: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This document assumes familiarity with the Ksplice design and
describes notable implementation details and the interface between the
Ksplice kernel component and the Ksplice user space component.

Signed-off-by: Jeffrey Brian Arnold <jbarnold@mit.edu>
Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 Documentation/ksplice.txt |  247 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 247 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ksplice.txt

diff --git a/Documentation/ksplice.txt b/Documentation/ksplice.txt
new file mode 100644
index 0000000..a8fb0ba
--- /dev/null
+++ b/Documentation/ksplice.txt
@@ -0,0 +1,247 @@
+Ksplice
+-------
+
+CONTENTS:
+
+1. Concepts: Updates, packs, helper modules, primary modules
+2. What changes can Ksplice handle?
+3. Dependency model
+4. Locking model
+5. altinstructions, smplocks, and parainstructions
+6. sysfs interface
+7. debugfs interface
+
+0. Design Description
+---------------------
+
+For a description of the Ksplice design, please see the Ksplice technical
+overview document: <http://web.mit.edu/ksplice/doc/ksplice.pdf>.  For usage
+examples and the Ksplice man pages, please see <http://web.mit.edu/ksplice/>.
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
+functions, delete functions, change functions from local to global (or vice
+versa), add exported symbols, rename exported symbols, and delete exported
+symbols.  Ksplice can handle patches that modify either C code or assembly code.
+
+As described in the Ksplice technical overview document, Ksplice cannot handle
+semantic changes to kernel data structures.  Some other limitations also apply:
+
+Ksplice does not support changes to __init functions that been unloaded from
+kernel memory.  Ksplice also does not support changes to functions in .exit.text
+sections since Ksplice currently requires that all Ksplice updates affecting a
+module be reversed before that module can be unloaded.
+
+The Ksplice user space implementation does not currently support moving
+functions between compilation units, changes to weak symbols, and changes to
+global read-only data structures (changes to read-only data structures that are
+local to a compilation unit are fine).
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
+instruct Ksplice to reverse the update.  After an update has been reversed, its
+stage cannot change again (although the update can be removed from the kernel
+entirely, in which case its $kid directory will be removed).
+
+B.  /sys/kernel/ksplice/$kid/debug (mode 0600)
+
+The file contains a single number: 1 if debugging is enabled for this Ksplice
+update and 0 otherwise.
+
+The superuser can write a new value to this file to enable or disable debugging.
+
+C.  /sys/kernel/ksplice/$kid/abort_cause (mode 0400)
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
+by the kernel did not match Ksplice's expectations based on the ksplice_export
+structures provided to Ksplice.
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
+unexpected_running_task (P->A, A->R): Ksplice aborted the operation because
+Ksplice observed a running task during the kernel stack check, at a time when
+Ksplice expected all tasks to be stopped by stop_machine.
+
+unexpected (P->A, A->R): Ksplice aborted the operation because it encountered
+an unspecified internal error.  This condition can only be caused by an invalid
+input to Ksplice or a bug in Ksplice.
+
+D.  /sys/kernel/ksplice/$kid/conflicts (mode 0400)
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
-- 
1.5.4.3

