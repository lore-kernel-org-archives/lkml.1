Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbXLTLyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbXLTLyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbXLTLyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:54:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759121AbXLTLyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:54:32 -0500
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
Subject: [PATCH -mm 03/43] elf core dump: notes user_regset
Message-Id: <20071220115427.A324926F98B@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:54:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies the ELF core dump code under #ifdef CORE_DUMP_USE_REGSET.
It changes nothing when this macro is not defined.  When it's #define'd
by some arch header (e.g. asm/elf.h), the arch must support the
user_regset (linux/regset.h) interface for reading thread state.

This provides an alternate version of note segment writing that is based
purely on the user_regset interfaces.  When CORE_DUMP_USE_REGSET is set,
the arch need not define macros such as ELF_CORE_COPY_REGS and ELF_ARCH.
All that information is taken from the user_regset data structures.
The core dumps come out exactly the same if arch's definitions for its
user_regset details are correct.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/binfmt_elf.c |  224 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 224 insertions(+), 0 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3500358..47fda1e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1528,6 +1528,228 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
 	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
 }
 
+#ifdef CORE_DUMP_USE_REGSET
+#include <linux/regset.h>
+
+struct elf_thread_core_info {
+	struct elf_thread_core_info *next;
+	struct task_struct *task;
+	struct elf_prstatus prstatus;
+	struct memelfnote notes[0];
+};
+
+struct elf_note_info {
+	struct elf_thread_core_info *thread;
+	struct memelfnote psinfo;
+	struct memelfnote auxv;
+	size_t size;
+	int thread_notes;
+};
+
+static int fill_thread_core_info(struct elf_thread_core_info *t,
+				 const struct user_regset_view *view,
+				 long signr, size_t *total)
+{
+	unsigned int i;
+
+	/*
+	 * NT_PRSTATUS is the one special case, because the regset data
+	 * goes into the pr_reg field inside the note contents, rather
+	 * than being the whole note contents.  We fill the reset in here.
+	 * We assume that regset 0 is NT_PRSTATUS.
+	 */
+	fill_prstatus(&t->prstatus, t->task, signr);
+	(void) view->regsets[0].get(t->task, &view->regsets[0],
+				    0, sizeof(t->prstatus.pr_reg),
+				    &t->prstatus.pr_reg, NULL);
+
+	fill_note(&t->notes[0], "CORE", NT_PRSTATUS,
+		  sizeof(t->prstatus), &t->prstatus);
+	*total += notesize(&t->notes[0]);
+
+	/*
+	 * Each other regset might generate a note too.  For each regset
+	 * that has no core_note_type or is inactive, we leave t->notes[i]
+	 * all zero and we'll know to skip writing it later.
+	 */
+	for (i = 1; i < view->n; ++i) {
+		const struct user_regset *regset = &view->regsets[i];
+		if (regset->core_note_type &&
+		    (!regset->active || regset->active(t->task, regset))) {
+			int ret;
+			size_t size = regset->n * regset->size;
+			void *data = kmalloc(size, GFP_KERNEL);
+			if (unlikely(!data))
+				return 0;
+			ret = regset->get(t->task, regset,
+					  0, size, data, NULL);
+			if (unlikely(ret))
+				kfree(data);
+			else {
+				if (regset->core_note_type != NT_PRFPREG)
+					fill_note(&t->notes[i], "LINUX",
+						  regset->core_note_type,
+						  size, data);
+				else {
+					t->prstatus.pr_fpvalid = 1;
+					fill_note(&t->notes[i], "CORE",
+						  NT_PRFPREG, size, data);
+				}
+				*total += notesize(&t->notes[i]);
+			}
+		}
+	}
+
+	return 1;
+}
+
+static int fill_note_info(struct elfhdr *elf, int phdrs,
+			  struct elf_note_info *info,
+			  long signr, struct pt_regs *regs)
+{
+	struct task_struct *dump_task = current;
+	const struct user_regset_view *view = task_user_regset_view(dump_task);
+	struct elf_thread_core_info *t;
+	struct elf_prpsinfo *psinfo;
+	struct task_struct *g, *p;
+	unsigned int i;
+
+	info->size = 0;
+	info->thread = NULL;
+
+	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
+	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
+
+	if (psinfo == NULL)
+		return 0;
+
+	/*
+	 * Figure out how many notes we're going to need for each thread.
+	 */
+	info->thread_notes = 0;
+	for (i = 0; i < view->n; ++i)
+		if (view->regsets[i].core_note_type != 0)
+			++info->thread_notes;
+
+	/*
+	 * Sanity check.  We rely on regset 0 being in NT_PRSTATUS,
+	 * since it is our one special case.
+	 */
+	if (unlikely(info->thread_notes == 0) ||
+	    unlikely(view->regsets[0].core_note_type != NT_PRSTATUS)) {
+		WARN_ON(1);
+		return 0;
+	}
+
+	/*
+	 * Initialize the ELF file header.
+	 */
+	fill_elf_header(elf, phdrs,
+			view->e_machine, view->e_flags, view->ei_osabi);
+
+	/*
+	 * Allocate a structure for each thread.
+	 */
+	rcu_read_lock();
+	do_each_thread(g, p)
+		if (p->mm == dump_task->mm) {
+			t = kzalloc(offsetof(struct elf_thread_core_info,
+					     notes[info->thread_notes]),
+				    GFP_ATOMIC);
+			if (unlikely(!t)) {
+				rcu_read_unlock();
+				return 0;
+			}
+			t->task = p;
+			if (p == dump_task || !info->thread) {
+				t->next = info->thread;
+				info->thread = t;
+			} else {
+				/*
+				 * Make sure to keep the original task at
+				 * the head of the list.
+				 */
+				t->next = info->thread->next;
+				info->thread->next = t;
+			}
+		}
+	while_each_thread(g, p);
+	rcu_read_unlock();
+
+	/*
+	 * Now fill in each thread's information.
+	 */
+	for (t = info->thread; t != NULL; t = t->next)
+		if (!fill_thread_core_info(t, view, signr, &info->size))
+			return 0;
+
+	/*
+	 * Fill in the two process-wide notes.
+	 */
+	fill_psinfo(psinfo, dump_task->group_leader, dump_task->mm);
+	info->size += notesize(&info->psinfo);
+
+	fill_auxv_note(&info->auxv, current->mm);
+	info->size += notesize(&info->auxv);
+
+	return 1;
+}
+
+static size_t get_note_info_size(struct elf_note_info *info)
+{
+	return info->size;
+}
+
+/*
+ * Write all the notes for each thread.  When writing the first thread, the
+ * process-wide notes are interleaved after the first thread-specific note.
+ */
+static int write_note_info(struct elf_note_info *info,
+			   struct file *file, loff_t *foffset)
+{
+	bool first = 1;
+	struct elf_thread_core_info *t = info->thread;
+
+	do {
+		int i;
+
+		if (!writenote(&t->notes[0], file, foffset))
+			return 0;
+
+		if (first && !writenote(&info->psinfo, file, foffset))
+			return 0;
+		if (first && !writenote(&info->auxv, file, foffset))
+			return 0;
+
+		for (i = 1; i < info->thread_notes; ++i)
+			if (t->notes[i].data &&
+			    !writenote(&t->notes[i], file, foffset))
+				return 0;
+
+		first = 0;
+		t = t->next;
+	} while (t);
+
+	return 1;
+}
+
+static void free_note_info(struct elf_note_info *info)
+{
+	struct elf_thread_core_info *threads = info->thread;
+	while (threads) {
+		unsigned int i;
+		struct elf_thread_core_info *t = threads;
+		threads = t->next;
+		WARN_ON(t->notes[0].data && t->notes[0].data != &t->prstatus);
+		for (i = 1; i < info->thread_notes; ++i)
+			kfree(t->notes[i].data);
+		kfree(t);
+	}
+	kfree(info->psinfo.data);
+}
+
+#else
+
 /* Here is the structure in which status of each thread is captured. */
 struct elf_thread_status
 {
@@ -1748,6 +1970,8 @@ static void free_note_info(struct elf_note_info *info)
 #endif
 }
 
+#endif
+
 static struct vm_area_struct *first_vma(struct task_struct *tsk,
 					struct vm_area_struct *gate_vma)
 {
-- 
1.5.3.6

