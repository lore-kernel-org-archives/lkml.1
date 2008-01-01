Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYAANsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYAANsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYAANsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:48:07 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53771 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbYAANsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:48:04 -0500
Date: Tue, 1 Jan 2008 15:47:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.25 patch] remove a.out interpreter for ELF executables
Message-ID: <20080101134749.GJ2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of the a.out interpreter 
support for ELF executables.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |   11 -
 fs/binfmt_elf.c                            |  142 +--------------------
 2 files changed, 13 insertions(+), 140 deletions(-)

aca21a4f123d9844fc03c69c3313c5a715a2fd36 
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index e754923..bca1eda 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -107,17 +107,6 @@ Who:	Eric Biederman <ebiederm@xmission.com>
 
 ---------------------------
 
-What:  a.out interpreter support for ELF executables
-When:  2.6.25
-Files: fs/binfmt_elf.c
-Why:   Using a.out interpreters for ELF executables was a feature for
-       transition from a.out to ELF. But now it is unlikely to be still
-       needed anymore and removing it would simplify the hairy ELF
-       loader code.
-Who:   Andi Kleen <ak@suse.de>
-
----------------------------
-
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index ba8de7c..30e1a75 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -133,7 +133,7 @@ static int padzero(unsigned long elf_bss)
 
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
-		int interp_aout, unsigned long load_addr,
+		unsigned long load_addr,
 		unsigned long interp_load_addr)
 {
 	unsigned long p = bprm->p;
@@ -223,11 +223,8 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	sp = STACK_ADD(p, ei_index);
 
 	items = (argc + 1) + (envc + 1);
-	if (interp_aout) {
-		items += 3; /* a.out interpreters require argv & envp too */
-	} else {
-		items += 1; /* ELF interpreters only put argc on the stack */
-	}
+	items += 1; /* ELF interpreters only put argc on the stack */
+
 	bprm->p = STACK_ROUND(sp, items);
 
 	/* Point sp at the lowest address on the stack */
@@ -250,16 +247,9 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	/* Now, let's put argc (and argv, envp if appropriate) on the stack */
 	if (__put_user(argc, sp++))
 		return -EFAULT;
-	if (interp_aout) {
-		argv = sp + 2;
-		envp = argv + argc + 1;
-		if (__put_user((elf_addr_t)(unsigned long)argv, sp++) ||
-		    __put_user((elf_addr_t)(unsigned long)envp, sp++))
-			return -EFAULT;
-	} else {
-		argv = sp;
-		envp = argv + argc + 1;
-	}
+
+	argv = sp;
+	envp = argv + argc + 1;
 
 	/* Populate argv and envp */
 	p = current->mm->arg_end = current->mm->arg_start;
@@ -464,61 +454,11 @@ out:
 	return error;
 }
 
-static unsigned long load_aout_interp(struct exec *interp_ex,
-		struct file *interpreter)
-{
-	unsigned long text_data, elf_entry = ~0UL;
-	char __user * addr;
-	loff_t offset;
-
-	current->mm->end_code = interp_ex->a_text;
-	text_data = interp_ex->a_text + interp_ex->a_data;
-	current->mm->end_data = text_data;
-	current->mm->brk = interp_ex->a_bss + text_data;
-
-	switch (N_MAGIC(*interp_ex)) {
-	case OMAGIC:
-		offset = 32;
-		addr = (char __user *)0;
-		break;
-	case ZMAGIC:
-	case QMAGIC:
-		offset = N_TXTOFF(*interp_ex);
-		addr = (char __user *)N_TXTADDR(*interp_ex);
-		break;
-	default:
-		goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);	
-	do_brk(0, text_data);
-	up_write(&current->mm->mmap_sem);
-	if (!interpreter->f_op || !interpreter->f_op->read)
-		goto out;
-	if (interpreter->f_op->read(interpreter, addr, text_data, &offset) < 0)
-		goto out;
-	flush_icache_range((unsigned long)addr,
-	                   (unsigned long)addr + text_data);
-
-	down_write(&current->mm->mmap_sem);	
-	do_brk(ELF_PAGESTART(text_data + ELF_MIN_ALIGN - 1),
-		interp_ex->a_bss);
-	up_write(&current->mm->mmap_sem);
-	elf_entry = interp_ex->a_entry;
-
-out:
-	return elf_entry;
-}
-
 /*
  * These are the functions used to load ELF style executables and shared
  * libraries.  There is no binary dependent code anywhere else.
  */
 
-#define INTERPRETER_NONE 0
-#define INTERPRETER_AOUT 1
-#define INTERPRETER_ELF 2
-
 #ifndef STACK_RND_MASK
 #define STACK_RND_MASK (0x7ff >> (PAGE_SHIFT - 12))	/* 8MB of VA */
 #endif
@@ -545,7 +485,6 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
  	unsigned long load_addr = 0, load_bias = 0;
 	int load_addr_set = 0;
 	char * elf_interpreter = NULL;
-	unsigned int interpreter_type = INTERPRETER_NONE;
 	unsigned char ibcs2_interpreter = 0;
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata;
@@ -556,14 +495,12 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	unsigned long elf_entry, interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc = 0;
-	char passed_fileno[6];
 	struct files_struct *files;
 	int executable_stack = EXSTACK_DEFAULT;
 	unsigned long def_flags = 0;
 	struct {
 		struct elfhdr elf_ex;
 		struct elfhdr interp_elf_ex;
-  		struct exec interp_ex;
 	} *loc;
 
 	loc = kmalloc(sizeof(*loc), GFP_KERNEL);
@@ -714,7 +651,6 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			}
 
 			/* Get the exec headers */
-			loc->interp_ex = *((struct exec *)bprm->buf);
 			loc->interp_elf_ex = *((struct elfhdr *)bprm->buf);
 			break;
 		}
@@ -733,59 +669,16 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
-		static int warn;
-		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
-
-		/* Now figure out which format our binary is */
-		if ((N_MAGIC(loc->interp_ex) != OMAGIC) &&
-		    (N_MAGIC(loc->interp_ex) != ZMAGIC) &&
-		    (N_MAGIC(loc->interp_ex) != QMAGIC))
-			interpreter_type = INTERPRETER_ELF;
-
-		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
-			interpreter_type &= ~INTERPRETER_ELF;
-
-		if (interpreter_type == INTERPRETER_AOUT && warn < 10) {
-			printk(KERN_WARNING "a.out ELF interpreter %s is "
-				"deprecated and will not be supported "
-				"after Linux 2.6.25\n", elf_interpreter);
-			warn++;
-		}
-
-		retval = -ELIBBAD;
-		if (!interpreter_type)
+		if ((memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0) ||
+		     !elf_check_arch(&loc->interp_elf_ex)) {
+			retval = -ELIBBAD;
 			goto out_free_dentry;
-
-		/* Make sure only one type was selected */
-		if ((interpreter_type & INTERPRETER_ELF) &&
-		     interpreter_type != INTERPRETER_ELF) {
-	     		// FIXME - ratelimit this before re-enabling
-			// printk(KERN_WARNING "ELF: Ambiguous type, using ELF\n");
-			interpreter_type = INTERPRETER_ELF;
 		}
-		/* Verify the interpreter has a valid arch */
-		if ((interpreter_type == INTERPRETER_ELF) &&
-		    !elf_check_arch(&loc->interp_elf_ex))
-			goto out_free_dentry;
 	} else {
 		/* Executables without an interpreter also need a personality  */
 		SET_PERSONALITY(loc->elf_ex, ibcs2_interpreter);
 	}
 
-	/* OK, we are done with that, now set up the arg stuff,
-	   and then start this sucker up */
-	if ((!bprm->sh_bang) && (interpreter_type == INTERPRETER_AOUT)) {
-		char *passed_p = passed_fileno;
-		sprintf(passed_fileno, "%d", elf_exec_fileno);
-
-		if (elf_interpreter) {
-			retval = copy_strings_kernel(1, &passed_p, bprm);
-			if (retval)
-				goto out_free_dentry; 
-			bprm->argc++;
-		}
-	}
-
 	/* Flush all traces of the currently running executable */
 	retval = flush_old_exec(bprm);
 	if (retval)
@@ -961,13 +854,9 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT)
-			elf_entry = load_aout_interp(&loc->interp_ex,
-						     interpreter);
-		else
-			elf_entry = load_elf_interp(&loc->interp_elf_ex,
-						    interpreter,
-						    &interp_load_addr);
+		elf_entry = load_elf_interp(&loc->interp_elf_ex,
+					    interpreter,
+					    &interp_load_addr);
 		if (BAD_ADDR(elf_entry)) {
 			force_sig(SIGSEGV, current);
 			retval = IS_ERR((void *)elf_entry) ?
@@ -990,8 +879,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	kfree(elf_phdata);
 
-	if (interpreter_type != INTERPRETER_AOUT)
-		sys_close(elf_exec_fileno);
+	sys_close(elf_exec_fileno);
 
 	set_binfmt(&elf_format);
 
@@ -1006,15 +894,11 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 	retval = create_elf_tables(bprm, &loc->elf_ex,
-			  (interpreter_type == INTERPRETER_AOUT),
 			  load_addr, interp_load_addr);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
 	}
-	/* N.B. passed_fileno might not be initialized? */
-	if (interpreter_type == INTERPRETER_AOUT)
-		current->mm->arg_start += strlen(passed_fileno) + 1;
 	current->mm->end_code = end_code;
 	current->mm->start_code = start_code;
 	current->mm->start_data = start_data;

