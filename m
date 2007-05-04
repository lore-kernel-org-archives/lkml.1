Return-Path: <linux-kernel-owner+w=401wt.eu-S376160AbXEDXXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376160AbXEDXXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376164AbXEDXXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:23:02 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S376160AbXEDXW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:22:58 -0400
Date: Fri, 4 May 2007 16:22:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Quentin Godfroy <godfroy@clipper.ens.fr>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "David A. Madore" <David.Madore@ens.fr>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: patch: VFS: fix passing of AT_PHDR value in auxv to ELF
 interpreter
Message-Id: <20070504162208.6f4b38b0.akpm@linux-foundation.org>
In-Reply-To: <20070504140921.GA23122@goelette.ens.fr>
References: <20070504140921.GA23122@goelette.ens.fr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 10:09:21 -0400
Quentin Godfroy <godfroy@clipper.ens.fr> wrote:

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

This patch kills my FC6 machine (using a config which was derived from RH's
original):

Freeing unused kernel memory: 368k freed
Write protecting the kernel read-only data: 959k
request_module: runaway loop modprobe binfmt-464c
request_module: runaway loop modprobe binfmt-464c
request_module: runaway loop modprobe binfmt-464c
request_module: runaway loop modprobe binfmt-464c
request_module: runaway loop modprobe binfmt-464c


.config: http://userweb.kernel.org/~akpm/config-akpm2.txt
