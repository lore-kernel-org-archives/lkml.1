Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbXLTLyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbXLTLyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbXLTLy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:54:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbXLTLyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:54:25 -0500
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
Subject: [PATCH -mm 02/43] elf core dump: notes reorg
Message-Id: <20071220115418.4302C26F98B@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:54:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pulls out the code for writing the notes segment of an ELF core dump
into separate functions.  This cleanly isolates into one cluster of
functions everything that deals with the note formats and the hooks into
arch code to fill them.  The top-level elf_core_dump function itself now
deals purely with the generic ELF format and the memory segments.

This only moves code around into functions that can be inlined away.
It should not change any behavior at all.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/binfmt_elf.c |  324 +++++++++++++++++++++++++++++++++----------------------
 1 files changed, 194 insertions(+), 130 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index efabb37..3500358 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1395,7 +1395,8 @@ static int writenote(struct memelfnote *men, struct file *file,
 	if (!dump_seek(file, (off))) \
 		goto end_coredump;
 
-static void fill_elf_header(struct elfhdr *elf, int segs)
+static void fill_elf_header(struct elfhdr *elf, int segs,
+			    u16 machine, u32 flags, u8 osabi)
 {
 	memcpy(elf->e_ident, ELFMAG, SELFMAG);
 	elf->e_ident[EI_CLASS] = ELF_CLASS;
@@ -1405,12 +1406,12 @@ static void fill_elf_header(struct elfhdr *elf, int segs)
 	memset(elf->e_ident+EI_PAD, 0, EI_NIDENT-EI_PAD);
 
 	elf->e_type = ET_CORE;
-	elf->e_machine = ELF_ARCH;
+	elf->e_machine = machine;
 	elf->e_version = EV_CURRENT;
 	elf->e_entry = 0;
 	elf->e_phoff = sizeof(struct elfhdr);
 	elf->e_shoff = 0;
-	elf->e_flags = ELF_CORE_EFLAGS;
+	elf->e_flags = flags;
 	elf->e_ehsize = sizeof(struct elfhdr);
 	elf->e_phentsize = sizeof(struct elf_phdr);
 	elf->e_phnum = segs;
@@ -1517,6 +1518,16 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	return 0;
 }
 
+static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
+{
+	elf_addr_t *auxv = (elf_addr_t *) mm->saved_auxv;
+	int i = 0;
+	do
+		i += 2;
+	while (auxv[i - 2] != AT_NULL);
+	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
+}
+
 /* Here is the structure in which status of each thread is captured. */
 struct elf_thread_status
 {
@@ -1569,6 +1580,174 @@ static int elf_dump_thread_status(long signr, struct elf_thread_status *t)
 	return sz;
 }
 
+struct elf_note_info {
+	struct memelfnote *notes;
+	struct elf_prstatus *prstatus;	/* NT_PRSTATUS */
+	struct elf_prpsinfo *psinfo;	/* NT_PRPSINFO */
+	struct list_head thread_list;
+	elf_fpregset_t *fpu;
+#ifdef ELF_CORE_COPY_XFPREGS
+	elf_fpxregset_t *xfpu;
+#endif
+	int thread_status_size;
+	int numnote;
+};
+
+static int fill_note_info(struct elfhdr *elf, int phdrs,
+			  struct elf_note_info *info,
+			  long signr, struct pt_regs *regs)
+{
+#define	NUM_NOTES	6
+	struct list_head *t;
+	struct task_struct *g, *p;
+
+	info->notes = NULL;
+	info->prstatus = NULL;
+	info->psinfo = NULL;
+	info->fpu = NULL;
+#ifdef ELF_CORE_COPY_XFPREGS
+	info->xfpu = NULL;
+#endif
+	INIT_LIST_HEAD(&info->thread_list);
+
+	info->notes = kmalloc(NUM_NOTES * sizeof(struct memelfnote),
+			      GFP_KERNEL);
+	if (!info->notes)
+		return 0;
+	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
+	if (!info->psinfo)
+		return 0;
+	info->prstatus = kmalloc(sizeof(*info->prstatus), GFP_KERNEL);
+	if (!info->prstatus)
+		return 0;
+	info->fpu = kmalloc(sizeof(*info->fpu), GFP_KERNEL);
+	if (!info->fpu)
+		return 0;
+#ifdef ELF_CORE_COPY_XFPREGS
+	info->xfpu = kmalloc(sizeof(*info->xfpu), GFP_KERNEL);
+	if (!info->xfpu)
+		return 0;
+#endif
+
+	info->thread_status_size = 0;
+	if (signr) {
+		struct elf_thread_status *tmp;
+		rcu_read_lock();
+		do_each_thread(g, p)
+			if (current->mm == p->mm && current != p) {
+				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
+				if (!tmp) {
+					rcu_read_unlock();
+					return 0;
+				}
+				tmp->thread = p;
+				list_add(&tmp->list, &info->thread_list);
+			}
+		while_each_thread(g, p);
+		rcu_read_unlock();
+		list_for_each(t, &info->thread_list) {
+			struct elf_thread_status *tmp;
+			int sz;
+
+			tmp = list_entry(t, struct elf_thread_status, list);
+			sz = elf_dump_thread_status(signr, tmp);
+			info->thread_status_size += sz;
+		}
+	}
+	/* now collect the dump for the current */
+	memset(info->prstatus, 0, sizeof(*info->prstatus));
+	fill_prstatus(info->prstatus, current, signr);
+	elf_core_copy_regs(&info->prstatus->pr_reg, regs);
+
+	/* Set up header */
+	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS, ELF_OSABI);
+
+	/*
+	 * Set up the notes in similar form to SVR4 core dumps made
+	 * with info from their /proc.
+	 */
+
+	fill_note(info->notes + 0, "CORE", NT_PRSTATUS,
+		  sizeof(*info->prstatus), info->prstatus);
+	fill_psinfo(info->psinfo, current->group_leader, current->mm);
+	fill_note(info->notes + 1, "CORE", NT_PRPSINFO,
+		  sizeof(*info->psinfo), info->psinfo);
+
+	info->numnote = 2;
+
+	fill_auxv_note(&info->notes[info->numnote++], current->mm);
+
+	/* Try to dump the FPU. */
+	info->prstatus->pr_fpvalid = elf_core_copy_task_fpregs(current, regs,
+							       info->fpu);
+	if (info->prstatus->pr_fpvalid)
+		fill_note(info->notes + info->numnote++,
+			  "CORE", NT_PRFPREG, sizeof(*info->fpu), info->fpu);
+#ifdef ELF_CORE_COPY_XFPREGS
+	if (elf_core_copy_task_xfpregs(current, info->xfpu))
+		fill_note(info->notes + info->numnote++,
+			  "LINUX", ELF_CORE_XFPREG_TYPE,
+			  sizeof(*info->xfpu), info->xfpu);
+#endif
+
+	return 1;
+
+#undef NUM_NOTES
+}
+
+static size_t get_note_info_size(struct elf_note_info *info)
+{
+	int sz = 0;
+	int i;
+
+	for (i = 0; i < info->numnote; i++)
+		sz += notesize(info->notes + i);
+
+	sz += info->thread_status_size;
+
+	return sz;
+}
+
+static int write_note_info(struct elf_note_info *info,
+			   struct file *file, loff_t *foffset)
+{
+	int i;
+	struct list_head *t;
+
+	for (i = 0; i < info->numnote; i++)
+		if (!writenote(info->notes + i, file, foffset))
+			return 0;
+
+	/* write out the thread status notes section */
+	list_for_each(t, &info->thread_list) {
+		struct elf_thread_status *tmp =
+				list_entry(t, struct elf_thread_status, list);
+
+		for (i = 0; i < tmp->num_notes; i++)
+			if (!writenote(&tmp->notes[i], file, foffset))
+				return 0;
+	}
+
+	return 1;
+}
+
+static void free_note_info(struct elf_note_info *info)
+{
+	while (!list_empty(&info->thread_list)) {
+		struct list_head *tmp = info->thread_list.next;
+		list_del(tmp);
+		kfree(list_entry(tmp, struct elf_thread_status, list));
+	}
+
+	kfree(info->prstatus);
+	kfree(info->psinfo);
+	kfree(info->notes);
+	kfree(info->fpu);
+#ifdef ELF_CORE_COPY_XFPREGS
+	kfree(info->xfpu);
+#endif
+}
+
 static struct vm_area_struct *first_vma(struct task_struct *tsk,
 					struct vm_area_struct *gate_vma)
 {
@@ -1604,29 +1783,15 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
  */
 static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
 {
-#define	NUM_NOTES	6
 	int has_dumped = 0;
 	mm_segment_t fs;
 	int segs;
 	size_t size = 0;
-	int i;
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
-	int numnote;
-	struct memelfnote *notes = NULL;
-	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
-	struct elf_prpsinfo *psinfo = NULL;	/* NT_PRPSINFO */
- 	struct task_struct *g, *p;
- 	LIST_HEAD(thread_list);
- 	struct list_head *t;
-	elf_fpregset_t *fpu = NULL;
-#ifdef ELF_CORE_COPY_XFPREGS
-	elf_fpxregset_t *xfpu = NULL;
-#endif
-	int thread_status_size = 0;
-	elf_addr_t *auxv;
 	unsigned long mm_flags;
+	struct elf_note_info info;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1644,52 +1809,6 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
 	if (!elf)
 		goto cleanup;
-	prstatus = kmalloc(sizeof(*prstatus), GFP_KERNEL);
-	if (!prstatus)
-		goto cleanup;
-	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
-	if (!psinfo)
-		goto cleanup;
-	notes = kmalloc(NUM_NOTES * sizeof(struct memelfnote), GFP_KERNEL);
-	if (!notes)
-		goto cleanup;
-	fpu = kmalloc(sizeof(*fpu), GFP_KERNEL);
-	if (!fpu)
-		goto cleanup;
-#ifdef ELF_CORE_COPY_XFPREGS
-	xfpu = kmalloc(sizeof(*xfpu), GFP_KERNEL);
-	if (!xfpu)
-		goto cleanup;
-#endif
-
-	if (signr) {
-		struct elf_thread_status *tmp;
-		rcu_read_lock();
-		do_each_thread(g,p)
-			if (current->mm == p->mm && current != p) {
-				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
-				if (!tmp) {
-					rcu_read_unlock();
-					goto cleanup;
-				}
-				tmp->thread = p;
-				list_add(&tmp->list, &thread_list);
-			}
-		while_each_thread(g,p);
-		rcu_read_unlock();
-		list_for_each(t, &thread_list) {
-			struct elf_thread_status *tmp;
-			int sz;
-
-			tmp = list_entry(t, struct elf_thread_status, list);
-			sz = elf_dump_thread_status(signr, tmp);
-			thread_status_size += sz;
-		}
-	}
-	/* now collect the dump for the current */
-	memset(prstatus, 0, sizeof(*prstatus));
-	fill_prstatus(prstatus, current, signr);
-	elf_core_copy_regs(&prstatus->pr_reg, regs);
 	
 	segs = current->mm->map_count;
 #ifdef ELF_CORE_EXTRA_PHDRS
@@ -1700,42 +1819,16 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	if (gate_vma != NULL)
 		segs++;
 
-	/* Set up header */
-	fill_elf_header(elf, segs + 1);	/* including notes section */
-
-	has_dumped = 1;
-	current->flags |= PF_DUMPCORE;
-
 	/*
-	 * Set up the notes in similar form to SVR4 core dumps made
-	 * with info from their /proc.
+	 * Collect all the non-memory information about the process for the
+	 * notes.  This also sets up the file header.
 	 */
+	if (!fill_note_info(elf, segs + 1, /* including notes section */
+			    &info, signr, regs))
+		goto cleanup;
 
-	fill_note(notes + 0, "CORE", NT_PRSTATUS, sizeof(*prstatus), prstatus);
-	fill_psinfo(psinfo, current->group_leader, current->mm);
-	fill_note(notes + 1, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
-	
-	numnote = 2;
-
-	auxv = (elf_addr_t *)current->mm->saved_auxv;
-
-	i = 0;
-	do
-		i += 2;
-	while (auxv[i - 2] != AT_NULL);
-	fill_note(&notes[numnote++], "CORE", NT_AUXV,
-		  i * sizeof(elf_addr_t), auxv);
-
-  	/* Try to dump the FPU. */
-	if ((prstatus->pr_fpvalid =
-	     elf_core_copy_task_fpregs(current, regs, fpu)))
-		fill_note(notes + numnote++,
-			  "CORE", NT_PRFPREG, sizeof(*fpu), fpu);
-#ifdef ELF_CORE_COPY_XFPREGS
-	if (elf_core_copy_task_xfpregs(current, xfpu))
-		fill_note(notes + numnote++,
-			  "LINUX", ELF_CORE_XFPREG_TYPE, sizeof(*xfpu), xfpu);
-#endif	
+	has_dumped = 1;
+	current->flags |= PF_DUMPCORE;
   
 	fs = get_fs();
 	set_fs(KERNEL_DS);
@@ -1748,12 +1841,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	/* Write notes phdr entry */
 	{
 		struct elf_phdr phdr;
-		int sz = 0;
-
-		for (i = 0; i < numnote; i++)
-			sz += notesize(notes + i);
-		
-		sz += thread_status_size;
+		size_t sz = get_note_info_size(&info);
 
 		sz += elf_coredump_extra_notes_size();
 
@@ -1798,23 +1886,12 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 #endif
 
  	/* write out the notes section */
-	for (i = 0; i < numnote; i++)
-		if (!writenote(notes + i, file, &foffset))
-			goto end_coredump;
+	if (!write_note_info(&info, file, &foffset))
+		goto end_coredump;
 
 	if (elf_coredump_extra_notes_write(file, &foffset))
 		goto end_coredump;
 
-	/* write out the thread status notes section */
-	list_for_each(t, &thread_list) {
-		struct elf_thread_status *tmp =
-				list_entry(t, struct elf_thread_status, list);
-
-		for (i = 0; i < tmp->num_notes; i++)
-			if (!writenote(&tmp->notes[i], file, &foffset))
-				goto end_coredump;
-	}
-
 	/* Align to page */
 	DUMP_SEEK(dataoff - foffset);
 
@@ -1865,22 +1942,9 @@ end_coredump:
 	set_fs(fs);
 
 cleanup:
-	while (!list_empty(&thread_list)) {
-		struct list_head *tmp = thread_list.next;
-		list_del(tmp);
-		kfree(list_entry(tmp, struct elf_thread_status, list));
-	}
-
 	kfree(elf);
-	kfree(prstatus);
-	kfree(psinfo);
-	kfree(notes);
-	kfree(fpu);
-#ifdef ELF_CORE_COPY_XFPREGS
-	kfree(xfpu);
-#endif
+	free_note_info(&info);
 	return has_dumped;
-#undef NUM_NOTES
 }
 
 #endif		/* USE_ELF_CORE_DUMP */
-- 
1.5.3.6

