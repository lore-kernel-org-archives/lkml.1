Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbXEGRr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbXEGRr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbXEGRrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:47:55 -0400
Received: from nef2.ens.fr ([129.199.96.40]:4536 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbXEGRrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:47:53 -0400
Date: Mon, 7 May 2007 13:47:03 -0400
From: Quentin Godfroy <godfroy@clipper.ens.fr>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "David A. Madore" <David.Madore@ens.fr>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: patch: VFS: fix passing of AT_PHDR value in auxv to ELF interpreter
Message-ID: <20070507174702.GA14479@goelette.ens.fr>
References: <20070504140921.GA23122@goelette.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504140921.GA23122@goelette.ens.fr>
User-Agent: Mutt/1.4.2.2i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Mon, 07 May 2007 19:47:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 10:09:21AM -0400, Quentin Godfroy wrote:
> On a dynamic ELF executable, the current kernel loader gives to the
> interpreter (in the AUXV vector) the AT_PHDR argument as :
> offset_of_phdr_in_file + first address.
> 
> It can be wrong for an executable where the program headers are not located 
> in the first loaded segment.
> 
> This patch corrects the behaviour.
> 
> Signed-off-by: Quentin Godfroy <godfroy@clipper.ens.fr>
> ---
>  Here is an example of such an ELF executable which the current code
>  fails on :
>  ftp://quatramaran.ens.fr/pub/godfroy/addrpath/broken-sample
> 
> --- linux-2.6.21.1/fs/binfmt_elf.c	2007-05-04 03:20:00.000000000 -0400
> +++ linux-2.6.21.1-patch/fs/binfmt_elf.c	2007-05-04 08:02:18.000000000 -0400
> @@ -134,6 +134,7 @@ static int padzero(unsigned long elf_bss
>  static int
>  create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  		int interp_aout, unsigned long load_addr,
> +		unsigned long phdr_addr,
>  		unsigned long interp_load_addr)
>  {
>  	unsigned long p = bprm->p;
> @@ -190,7 +191,7 @@ create_elf_tables(struct linux_binprm *b
>  	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
>  	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
>  	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
> -	NEW_AUX_ENT(AT_PHDR, load_addr + exec->e_phoff);
> +	NEW_AUX_ENT(AT_PHDR, phdr_addr);
>  	NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
>  	NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
>  	NEW_AUX_ENT(AT_BASE, interp_load_addr);
> @@ -529,7 +530,7 @@ static unsigned long randomize_stack_top
>  static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>  {
>  	struct file *interpreter = NULL; /* to shut gcc up */
> - 	unsigned long load_addr = 0, load_bias = 0;
> + 	unsigned long load_addr = 0, load_bias = 0, phdr_addr = 0;
>  	int load_addr_set = 0;
>  	char * elf_interpreter = NULL;
>  	unsigned int interpreter_type = INTERPRETER_NONE;
> @@ -718,6 +719,16 @@ static int load_elf_binary(struct linux_
>  			break;
>  		}
>  
> +	elf_ppnt = elf_phdata;
> +	for (i = 0; i< loc->elf_ex.e_phnum; i++, elf_ppnt++)
> +		if (elf_ppnt->p_type == PT_PHDR) {
> +			phdr_addr = elf_ppnt->p_vaddr;
> +			break;
> +		}
> +	retval = -ENOEXEC;
> +	if (!phdr_addr)
> +		goto out_free_dentry;
> +
>  	/* Some simple consistency checks for the interpreter */
>  	if (elf_interpreter) {
>  		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
> @@ -987,7 +998,7 @@ static int load_elf_binary(struct linux_
>  	current->flags &= ~PF_FORKNOEXEC;
>  	create_elf_tables(bprm, &loc->elf_ex,
>  			  (interpreter_type == INTERPRETER_AOUT),
> -			  load_addr, interp_load_addr);
> +			  load_addr, phdr_addr, interp_load_addr);
>  	/* N.B. passed_fileno might not be initialized? */
>  	if (interpreter_type == INTERPRETER_AOUT)
>  		current->mm->arg_start += strlen(passed_fileno) + 1;

I have made another patch, which I hope should not break anything this
time. I tested it on an x86_64 kernel with 32 and 64 bits executables,
PIE and not PIE (well my only PIE are libc-2.5.so and ld-2.5.so). I
rejoined the loops as suggested, and the kernel falls back on load_addr +
exec->e_phoff if there was no PT_PHDR entry in the program headers.

Signed-off-by: Quentin Godfroy <godfroy@clipper.ens.fr>
---
--- linux-2.6.21.1/fs/binfmt_elf.c	2007-05-07 10:58:38.000000000 -0400
+++ linux-2.6.21.1-patch/fs/binfmt_elf.c	2007-05-07 13:14:33.000000000 -0400
@@ -134,6 +134,7 @@ static int padzero(unsigned long elf_bss
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		int interp_aout, unsigned long load_addr,
+		unsigned long phdr_addr,
 		unsigned long interp_load_addr)
 {
 	unsigned long p = bprm->p;
@@ -190,7 +191,10 @@ create_elf_tables(struct linux_binprm *b
 	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
 	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
 	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
-	NEW_AUX_ENT(AT_PHDR, load_addr + exec->e_phoff);
+	if(phdr_addr)
+		NEW_AUX_ENT(AT_PHDR, phdr_addr);
+	else
+		NEW_AUX_ENT(AT_PHDR, load_addr + exec->e_phoff);
 	NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
@@ -529,7 +533,7 @@ static unsigned long randomize_stack_top
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
- 	unsigned long load_addr = 0, load_bias = 0;
+ 	unsigned long load_addr = 0, load_bias = 0, phdr_addr = 0;
 	int load_addr_set = 0;
 	char * elf_interpreter = NULL;
 	unsigned int interpreter_type = INTERPRETER_NONE;
@@ -620,7 +624,12 @@ static int load_elf_binary(struct linux_
 	start_data = 0;
 	end_data = 0;
 
-	for (i = 0; i < loc->elf_ex.e_phnum; i++) {
+	for (i = 0; i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
+		if (elf_ppnt->p_type == PT_PHDR) {
+			phdr_addr = elf_ppnt->p_vaddr;
+			continue;
+		}
+
 		if (elf_ppnt->p_type == PT_INTERP) {
 			/* This is the program interpreter used for
 			 * shared libraries - for now assume that this
@@ -703,20 +712,17 @@ static int load_elf_binary(struct linux_
 			/* Get the exec headers */
 			loc->interp_ex = *((struct exec *)bprm->buf);
 			loc->interp_elf_ex = *((struct elfhdr *)bprm->buf);
-			break;
+			continue;
 		}
-		elf_ppnt++;
-	}
 
-	elf_ppnt = elf_phdata;
-	for (i = 0; i < loc->elf_ex.e_phnum; i++, elf_ppnt++)
 		if (elf_ppnt->p_type == PT_GNU_STACK) {
 			if (elf_ppnt->p_flags & PF_X)
 				executable_stack = EXSTACK_ENABLE_X;
 			else
 				executable_stack = EXSTACK_DISABLE_X;
-			break;
+			continue;
 		}
+	}
 
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
@@ -985,9 +991,12 @@ static int load_elf_binary(struct linux_
 
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
+	if (phdr_addr)
+		phdr_addr += load_bias;
+
 	create_elf_tables(bprm, &loc->elf_ex,
 			  (interpreter_type == INTERPRETER_AOUT),
-			  load_addr, interp_load_addr);
+			  load_addr, phdr_addr, interp_load_addr);
 	/* N.B. passed_fileno might not be initialized? */
 	if (interpreter_type == INTERPRETER_AOUT)
 		current->mm->arg_start += strlen(passed_fileno) + 1;
