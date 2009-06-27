Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZF0OJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZF0OJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 10:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZF0OIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 10:08:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64970 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbZF0OIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 10:08:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/6] score: cleanups: dead code, 0 as pointer, shadowed variables
Date: Sat, 27 Jun 2009 16:08:16 +0200
Message-Id: <c6067472252c1d6155c7c01c93e0d580342cdb29.1246111364.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/mQY+DHAtTi98EzJp+9T8dOoku0QkuVdWL3Aa
 pw6YXGFol5dK+QRAR/2zZq/PlR72YvxMRFqQZH5u4VdRuGaoIJ
 7pxDerRAtOwisUnJ+FWkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few smaller issues found by sparse, some code that was
never used, two instances of '0' instead of 'NULL' and
local variables shadowing another one.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/score/kernel/module.c    |   12 ++++++------
 arch/score/kernel/signal.c    |    2 +-
 arch/score/kernel/sys_score.c |   14 +-------------
 3 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/arch/score/kernel/module.c b/arch/score/kernel/module.c
index 1a62557..4de8d47 100644
--- a/arch/score/kernel/module.c
+++ b/arch/score/kernel/module.c
@@ -57,17 +57,17 @@ int apply_relocate(Elf_Shdr *sechdrs, const char *strtab,
 	for (i = 0; i < relsec->sh_size / sizeof(Elf32_Rel); i++, rel++) {
 		unsigned long loc;
 		Elf32_Sym *sym;
-		s32 offset;
+		s32 r_offset;
 
-		offset = ELF32_R_SYM(rel->r_info);
-		if ((offset < 0) ||
-		    (offset > (symsec->sh_size / sizeof(Elf32_Sym)))) {
+		r_offset = ELF32_R_SYM(rel->r_info);
+		if ((r_offset < 0) ||
+		    (r_offset > (symsec->sh_size / sizeof(Elf32_Sym)))) {
 			printk(KERN_ERR "%s: bad relocation, section %d reloc %d\n",
 				me->name, relindex, i);
 				return -ENOEXEC;
 		}
 
-		sym = ((Elf32_Sym *)symsec->sh_addr) + offset;
+		sym = ((Elf32_Sym *)symsec->sh_addr) + r_offset;
 
 		if ((rel->r_offset < 0) ||
 		    (rel->r_offset > dstsec->sh_size - sizeof(u32))) {
@@ -152,7 +152,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_dbetables(unsigned long addr)
 {
-	return 0;
+	return NULL;
 }
 
 /* Put in dbe list if necessary. */
diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
index afbfe33..950f87c 100644
--- a/arch/score/kernel/signal.c
+++ b/arch/score/kernel/signal.c
@@ -212,7 +212,7 @@ static int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
 
 	err |= copy_siginfo_to_user(&frame->rs_info, info);
 	err |= __put_user(0, &frame->rs_uc.uc_flags);
-	err |= __put_user(0, &frame->rs_uc.uc_link);
+	err |= __put_user(NULL, &frame->rs_uc.uc_link);
 	err |= __put_user((void __user *)current->sas_ss_sp,
 				&frame->rs_uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->regs[0]),
diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
index 5b3cc4e..61aff8a 100644
--- a/arch/score/kernel/sys_score.c
+++ b/arch/score/kernel/sys_score.c
@@ -31,10 +31,7 @@
 #include <linux/syscalls.h>
 #include <asm/syscalls.h>
 
-unsigned long shm_align_mask = PAGE_SIZE - 1;
-EXPORT_SYMBOL(shm_align_mask);
-
-asmlinkage unsigned
+asmlinkage long 
 sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
 	  unsigned long flags, unsigned long fd, unsigned long pgoff)
 {
@@ -107,15 +104,6 @@ score_execve(struct pt_regs *regs)
 }
 
 /*
- * If we ever come here the user sp is bad.  Zap the process right away.
- * Due to the bad stack signaling wouldn't work.
- */
-void bad_stack(void)
-{
-	do_exit(SIGSEGV);
-}
-
-/*
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-- 
1.6.3.1

