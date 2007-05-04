Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbXEDOug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbXEDOug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXEDOug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:50:36 -0400
Received: from nef2.ens.fr ([129.199.96.40]:3102 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbXEDOue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:50:34 -0400
X-Greylist: delayed 2468 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 10:50:34 EDT
Date: Fri, 4 May 2007 10:09:21 -0400
From: Quentin Godfroy <godfroy@clipper.ens.fr>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "David A. Madore" <David.Madore@ens.fr>
Subject: patch: VFS: fix passing of AT_PHDR value in auxv to ELF interpreter
Message-ID: <20070504140921.GA23122@goelette.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Fri, 04 May 2007 16:09:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a dynamic ELF executable, the current kernel loader gives to the
interpreter (in the AUXV vector) the AT_PHDR argument as :
offset_of_phdr_in_file + first address.

It can be wrong for an executable where the program headers are not located 
in the first loaded segment.

This patch corrects the behaviour.

Signed-off-by: Quentin Godfroy <godfroy@clipper.ens.fr>
---
 Here is an example of such an ELF executable which the current code
 fails on :
 ftp://quatramaran.ens.fr/pub/godfroy/addrpath/broken-sample

--- linux-2.6.21.1/fs/binfmt_elf.c	2007-05-04 03:20:00.000000000 -0400
+++ linux-2.6.21.1-patch/fs/binfmt_elf.c	2007-05-04 08:02:18.000000000 -0400
@@ -134,6 +134,7 @@ static int padzero(unsigned long elf_bss
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		int interp_aout, unsigned long load_addr,
+		unsigned long phdr_addr,
 		unsigned long interp_load_addr)
 {
 	unsigned long p = bprm->p;
@@ -190,7 +191,7 @@ create_elf_tables(struct linux_binprm *b
 	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
 	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
 	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
-	NEW_AUX_ENT(AT_PHDR, load_addr + exec->e_phoff);
+	NEW_AUX_ENT(AT_PHDR, phdr_addr);
 	NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
@@ -529,7 +530,7 @@ static unsigned long randomize_stack_top
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
- 	unsigned long load_addr = 0, load_bias = 0;
+ 	unsigned long load_addr = 0, load_bias = 0, phdr_addr = 0;
 	int load_addr_set = 0;
 	char * elf_interpreter = NULL;
 	unsigned int interpreter_type = INTERPRETER_NONE;
@@ -718,6 +719,16 @@ static int load_elf_binary(struct linux_
 			break;
 		}
 
+	elf_ppnt = elf_phdata;
+	for (i = 0; i< loc->elf_ex.e_phnum; i++, elf_ppnt++)
+		if (elf_ppnt->p_type == PT_PHDR) {
+			phdr_addr = elf_ppnt->p_vaddr;
+			break;
+		}
+	retval = -ENOEXEC;
+	if (!phdr_addr)
+		goto out_free_dentry;
+
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
@@ -987,7 +998,7 @@ static int load_elf_binary(struct linux_
 	current->flags &= ~PF_FORKNOEXEC;
 	create_elf_tables(bprm, &loc->elf_ex,
 			  (interpreter_type == INTERPRETER_AOUT),
-			  load_addr, interp_load_addr);
+			  load_addr, phdr_addr, interp_load_addr);
 	/* N.B. passed_fileno might not be initialized? */
 	if (interpreter_type == INTERPRETER_AOUT)
 		current->mm->arg_start += strlen(passed_fileno) + 1;
