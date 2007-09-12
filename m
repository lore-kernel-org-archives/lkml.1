Return-Path: <linux-kernel-owner+w=401wt.eu-S1764619AbXILHsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764619AbXILHsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762387AbXILHnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:52 -0400
Received: from ozlabs.org ([203.10.76.45]:46539 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761024AbXILHnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:51 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <199ab0b360dec28c753a13fb0206978053893faf.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 12/15] Cleanup ELF coredump extra notes logic
Date: Wed, 12 Sep 2007 17:43:49 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To start with, arch_notes_size() etc. is a little too ambiguous a name for
my liking, so change the function names to be more explicit.

Calling through macros is ugly, especially with hidden parameters, so don't
do that, call the routines directly.

Use ARCH_HAVE_EXTRA_ELF_NOTES as the only flag, and based on it decide
whether we want the extern declarations or the empty versions.

Since we have empty routines, actually use them in the coredump code to
save a few #ifdefs.

We want to change the handling of foffset so that the write routine updates
foffset as it goes, instead of using file->f_pos (so that writing to a pipe
works). So pass foffset to the write routine, and for now just set it to
file->f_pos at the end of writing.

It should also be possible for the write routine to fail, so change it to
return int and treat a non-zero return as failure.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spu_syscalls.c |   12 +++++++++---
 fs/binfmt_elf.c                            |   14 +++-----------
 include/asm-powerpc/elf.h                  |    9 ++-------
 include/linux/elf.h                        |   14 ++++++++------
 4 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c b/arch/powerpc/platforms/cell/spu_syscalls.c
index cf00251..d9b2fd2 100644
--- a/arch/powerpc/platforms/cell/spu_syscalls.c
+++ b/arch/powerpc/platforms/cell/spu_syscalls.c
@@ -21,6 +21,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/mutex.h>
@@ -109,7 +110,7 @@ asmlinkage long sys_spu_run(int fd, __u32 __user *unpc, __u32 __user *ustatus)
 	return ret;
 }
 
-int arch_notes_size(void)
+int elf_coredump_extra_notes_size(void)
 {
 	struct spufs_calls *calls;
 	int ret;
@@ -125,17 +126,22 @@ int arch_notes_size(void)
 	return ret;
 }
 
-void arch_write_notes(struct file *file)
+int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset)
 {
 	struct spufs_calls *calls;
 
 	calls = spufs_calls_get();
 	if (!calls)
-		return;
+		return 0;
 
 	calls->coredump_extra_notes_write(file);
 
 	spufs_calls_put(calls);
+
+	/* Fudge foffset for now */
+	*foffset = file->f_pos;
+
+	return 0;
 }
 
 int register_spu_syscalls(struct spufs_calls *calls)
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 4482a06..b1013f3 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1514,9 +1514,6 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
 	unsigned long mm_flags;
-#ifdef ELF_CORE_WRITE_EXTRA_NOTES
-	int extra_notes_size;
-#endif
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1645,10 +1642,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 		
 		sz += thread_status_size;
 
-#ifdef ELF_CORE_WRITE_EXTRA_NOTES
-		extra_notes_size = ELF_CORE_EXTRA_NOTES_SIZE;
-		sz += extra_notes_size;
-#endif
+		sz += elf_coredump_extra_notes_size();
 
 		fill_elf_note_phdr(&phdr, sz, offset);
 		offset += sz;
@@ -1698,10 +1692,8 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 		if (!writenote(notes + i, file, &foffset))
 			goto end_coredump;
 
-#ifdef ELF_CORE_WRITE_EXTRA_NOTES
-	ELF_CORE_WRITE_EXTRA_NOTES;
-	foffset += extra_notes_size;
-#endif
+	if (elf_coredump_extra_notes_write(file, &foffset))
+		goto end_coredump;
 
 	/* write out the thread status notes section */
 	list_for_each(t, &thread_list) {
diff --git a/include/asm-powerpc/elf.h b/include/asm-powerpc/elf.h
index de50799..e42820d 100644
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -413,13 +413,8 @@ do {									\
 /* Notes used in ET_CORE. Note name is "SPU/<fd>/<filename>". */
 #define NT_SPU		1
 
-extern int arch_notes_size(void);
-extern void arch_write_notes(struct file *file);
-
-#define ELF_CORE_EXTRA_NOTES_SIZE arch_notes_size()
-#define ELF_CORE_WRITE_EXTRA_NOTES arch_write_notes(file)
-
 #define ARCH_HAVE_EXTRA_ELF_NOTES
-#endif /* CONFIG_PPC_CELL */
+
+#endif /* CONFIG_SPU_BASE */
 
 #endif /* _ASM_POWERPC_ELF_H */
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 8b17ffe..d2da84a 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -389,12 +389,14 @@ extern Elf64_Dyn _DYNAMIC [];
 
 #endif
 
+/* Optional callbacks to write extra ELF notes. */
 #ifndef ARCH_HAVE_EXTRA_ELF_NOTES
-static inline int arch_notes_size(void) { return 0; }
-static inline void arch_write_notes(struct file *file) { }
-
-#define ELF_CORE_EXTRA_NOTES_SIZE arch_notes_size()
-#define ELF_CORE_WRITE_EXTRA_NOTES arch_write_notes(file)
-#endif /* ARCH_HAVE_EXTRA_ELF_NOTES */
+static inline int elf_coredump_extra_notes_size(void) { return 0; }
+static inline int elf_coredump_extra_notes_write(struct file *file,
+			loff_t *foffset) { return 0; }
+#else
+extern int elf_coredump_extra_notes_size(void);
+extern int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset);
+#endif
 
 #endif /* _LINUX_ELF_H */
-- 
1.5.1.3.g7a33b

