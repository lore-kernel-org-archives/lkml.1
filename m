Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZK2PKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZK2PKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 10:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZK2PKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 10:10:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZK2PK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:10:29 -0500
Message-ID: <4B128ECF.9020906@redhat.com>
Date: Sun, 29 Nov 2009 10:10:07 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
CC: Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
       hidehiro.kawai.ez@hitachi.com, lethal@linux-sh.org, roland@redhat.com,
       vapier@gentoo.org, Takahiro Yasui <tyasui@redhat.com>
Subject: [PATCH][RFC] tracepoint: signal coredump (Re: [PATCH v2] mm: Introduce
 coredump parameter structure)
References: <200911202212.nAKMCF2v012068@imap1.linux-foundation.org> <20091126174835.5A73.A69D9226@jp.fujitsu.com> <4B0EA3AA.5070003@redhat.com> <20091126165108.GA13231@redhat.com> <4B11FB6F.4040403@redhat.com>
In-Reply-To: <4B11FB6F.4040403@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------000704040900030905030506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000704040900030905030506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ingo and Andrew,

By the way, I'd like to push signal_coredump tracepoint (which I attached)
on these patches, and it also depends on signal-tracepoint patch series
which already picked up to -tip tree.

So, in this case, is it possible to pick these patches (coredump parameter
and mm->flags consistency fix (http://patchwork.kernel.org/patch/60917/))
to -tip tree too?

Thank you,

Masami Hiramatsu wrote:
> Introduce coredump parameter data structure (struct coredump_params)
> for simplifying binfmt->core_dump() arguments.
>
> Changes in v2:
>     - Don't remove DUMP_WRITE() macro.
>
> Signed-off-by: Masami Hiramatsu<mhiramat@redhat.com>
> Suggested-by: Ingo Molnar<mingo@elte.hu>
> Cc: Hidehiro Kawai<hidehiro.kawai.ez@hitachi.com>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Cc: Oleg Nesterov<oleg@redhat.com>
> Cc: Roland McGrath<roland@redhat.com>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> ---
>
> Andrew, please replace the previous buggy patch with this version.
>
> Thank you,
>
>      fs/binfmt_aout.c        |   13 +++++++------
>      fs/binfmt_elf.c         |   24 +++++++++++++-----------
>      fs/binfmt_elf_fdpic.c   |   29 +++++++++++++++--------------
>      fs/binfmt_flat.c        |    6 +++---
>      fs/binfmt_som.c         |    2 +-
>      fs/exec.c               |   38 +++++++++++++++++++++-----------------
>      include/linux/binfmts.h |   10 +++++++++-
>      7 files changed, 69 insertions(+), 53 deletions(-)
>
>
> diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
> index b639dcf..346b694 100644
> --- a/fs/binfmt_aout.c
> +++ b/fs/binfmt_aout.c
> @@ -32,7 +32,7 @@
>
>      static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
>      static int load_aout_library(struct file*);
> -static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
> +static int aout_core_dump(struct coredump_params *cprm);
>
>      static struct linux_binfmt aout_format = {
>      	.module		= THIS_MODULE,
> @@ -89,8 +89,9 @@ if (file->f_op->llseek) { \
>       * dumping of the process results in another error..
>       */
>
> -static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
> +static int aout_core_dump(struct coredump_params *cprm)
>      {
> +	struct file *file = cprm->file;
>      	mm_segment_t fs;
>      	int has_dumped = 0;
>      	unsigned long dump_start, dump_size;
> @@ -108,16 +109,16 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
>      	current->flags |= PF_DUMPCORE;
>             	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
>      	dump.u_ar0 = offsetof(struct user, regs);
> -	dump.signal = signr;
> -	aout_dump_thread(regs,&dump);
> +	dump.signal = cprm->signr;
> +	aout_dump_thread(cprm->regs,&dump);
>
>      /* If the size of the dump file exceeds the rlimit, then see what would happen
>         if we wrote the stack, but not the data area.  */
> -	if ((dump.u_dsize + dump.u_ssize+1) * PAGE_SIZE>  limit)
> +	if ((dump.u_dsize + dump.u_ssize+1) * PAGE_SIZE>  cprm->limit)
>      		dump.u_dsize = 0;
>
>      /* Make sure we have enough room to write the stack and data areas. */
> -	if ((dump.u_ssize + 1) * PAGE_SIZE>  limit)
> +	if ((dump.u_ssize + 1) * PAGE_SIZE>  cprm->limit)
>      		dump.u_ssize = 0;
>
>      /* make sure we actually have a data and stack area to dump */
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index b9b3bb5..4ee5bb2 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -45,7 +45,7 @@ static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
>       * don't even try.
>       */
>      #if defined(USE_ELF_CORE_DUMP)&&  defined(CONFIG_ELF_CORE)
> -static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
> +static int elf_core_dump(struct coredump_params *cprm);
>      #else
>      #define elf_core_dump	NULL
>      #endif
> @@ -1277,8 +1277,9 @@ static int writenote(struct memelfnote *men, struct file *file,
>      }
>      #undef DUMP_WRITE
>
> -#define DUMP_WRITE(addr, nr)	\
> -	if ((size += (nr))>  limit || !dump_write(file, (addr), (nr))) \
> +#define DUMP_WRITE(addr, nr)				\
> +	if ((size += (nr))>  cprm->limit ||		\
> +	    !dump_write(cprm->file, (addr), (nr)))	\
>      		goto end_coredump;
>
>      static void fill_elf_header(struct elfhdr *elf, int segs,
> @@ -1906,7 +1907,7 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
>       * and then they are actually written out.  If we run out of core limit
>       * we just truncate.
>       */
> -static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
> +static int elf_core_dump(struct coredump_params *cprm)
>      {
>      	int has_dumped = 0;
>      	mm_segment_t fs;
> @@ -1952,7 +1953,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
>      	 * notes.  This also sets up the file header.
>      	 */
>      	if (!fill_note_info(elf, segs + 1, /* including notes section */
> -			&info, signr, regs))
> +			&info, cprm->signr, cprm->regs))
>      		goto cleanup;
>
>      	has_dumped = 1;
> @@ -2014,14 +2015,14 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
>      #endif
>
>       	/* write out the notes section */
> -	if (!write_note_info(&info, file,&foffset))
> +	if (!write_note_info(&info, cprm->file,&foffset))
>      		goto end_coredump;
>
> -	if (elf_coredump_extra_notes_write(file,&foffset))
> +	if (elf_coredump_extra_notes_write(cprm->file,&foffset))
>      		goto end_coredump;
>
>      	/* Align to page */
> -	if (!dump_seek(file, dataoff - foffset))
> +	if (!dump_seek(cprm->file, dataoff - foffset))
>      		goto end_coredump;
>
>      	for (vma = first_vma(current, gate_vma); vma != NULL;
> @@ -2038,12 +2039,13 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
>      			page = get_dump_page(addr);
>      			if (page) {
>      				void *kaddr = kmap(page);
> -				stop = ((size += PAGE_SIZE)>  limit) ||
> -					!dump_write(file, kaddr, PAGE_SIZE);
> +				stop = ((size += PAGE_SIZE)>  cprm->limit) ||
> +					!dump_write(cprm->file, kaddr,
> +						    PAGE_SIZE);
>      				kunmap(page);
>      				page_cache_release(page);
>      			} else
> -				stop = !dump_seek(file, PAGE_SIZE);
> +				stop = !dump_seek(cprm->file, PAGE_SIZE);
>      			if (stop)
>      				goto end_coredump;
>      		}
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 38502c6..917e1b4 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -76,7 +76,7 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *,
>      					     struct file *, struct mm_struct *);
>
>      #if defined(USE_ELF_CORE_DUMP)&&  defined(CONFIG_ELF_CORE)
> -static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *, unsigned long limit);
> +static int elf_fdpic_core_dump(struct coredump_params *cprm);
>      #endif
>
>      static struct linux_binfmt elf_fdpic_format = {
> @@ -1325,8 +1325,9 @@ static int writenote(struct memelfnote *men, struct file *file)
>      #undef DUMP_WRITE
>      #undef DUMP_SEEK
>
> -#define DUMP_WRITE(addr, nr)	\
> -	if ((size += (nr))>  limit || !dump_write(file, (addr), (nr))) \
> +#define DUMP_WRITE(addr, nr)				\
> +	if ((size += (nr))>  cprm->limit ||		\
> +	    !dump_write(cprm->file, (addr), (nr)))	\
>      		goto end_coredump;
>
>      static inline void fill_elf_fdpic_header(struct elfhdr *elf, int segs)
> @@ -1581,8 +1582,7 @@ static int elf_fdpic_dump_segments(struct file *file, size_t *size,
>       * and then they are actually written out.  If we run out of core limit
>       * we just truncate.
>       */
> -static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
> -			       struct file *file, unsigned long limit)
> +static int elf_fdpic_core_dump(struct coredump_params *cprm)
>      {
>      #define	NUM_NOTES	6
>      	int has_dumped = 0;
> @@ -1641,7 +1641,7 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
>      		goto cleanup;
>      #endif
>
> -	if (signr) {
> +	if (cprm->signr) {
>      		struct core_thread *ct;
>      		struct elf_thread_status *tmp;
>
> @@ -1660,14 +1660,14 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
>      			int sz;
>
>      			tmp = list_entry(t, struct elf_thread_status, list);
> -			sz = elf_dump_thread_status(signr, tmp);
> +			sz = elf_dump_thread_status(cprm->signr, tmp);
>      			thread_status_size += sz;
>      		}
>      	}
>
>      	/* now collect the dump for the current */
> -	fill_prstatus(prstatus, current, signr);
> -	elf_core_copy_regs(&prstatus->pr_reg, regs);
> +	fill_prstatus(prstatus, current, cprm->signr);
> +	elf_core_copy_regs(&prstatus->pr_reg, cprm->regs);
>
>      	segs = current->mm->map_count;
>      #ifdef ELF_CORE_EXTRA_PHDRS
> @@ -1702,7 +1702,7 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
>
>        	/* Try to dump the FPU. */
>      	if ((prstatus->pr_fpvalid =
> -	     elf_core_copy_task_fpregs(current, regs, fpu)))
> +	     elf_core_copy_task_fpregs(current, cprm->regs, fpu)))
>      		fill_note(notes + numnote++,
>      			  "CORE", NT_PRFPREG, sizeof(*fpu), fpu);
>      #ifdef ELF_CORE_COPY_XFPREGS
> @@ -1773,7 +1773,7 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
>
>       	/* write out the notes section */
>      	for (i = 0; i<  numnote; i++)
> -		if (!writenote(notes + i, file))
> +		if (!writenote(notes + i, cprm->file))
>      			goto end_coredump;
>
>      	/* write out the thread status notes section */
> @@ -1782,14 +1782,15 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
>      				list_entry(t, struct elf_thread_status, list);
>
>      		for (i = 0; i<  tmp->num_notes; i++)
> -			if (!writenote(&tmp->notes[i], file))
> +			if (!writenote(&tmp->notes[i], cprm->file))
>      				goto end_coredump;
>      	}
>
> -	if (!dump_seek(file, dataoff))
> +	if (!dump_seek(cprm->file, dataoff))
>      		goto end_coredump;
>
> -	if (elf_fdpic_dump_segments(file,&size,&limit, mm_flags)<  0)
> +	if (elf_fdpic_dump_segments(cprm->file,&size,&cprm->limit,
> +				    mm_flags)<  0)
>      		goto end_coredump;
>
>      #ifdef ELF_CORE_WRITE_EXTRA_DATA
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index a279665..d4a00ea 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -87,7 +87,7 @@ static int load_flat_shared_library(int id, struct lib_info *p);
>      #endif
>
>      static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
> -static int flat_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
> +static int flat_core_dump(struct coredump_params *cprm);
>
>      static struct linux_binfmt flat_format = {
>      	.module		= THIS_MODULE,
> @@ -102,10 +102,10 @@ static struct linux_binfmt flat_format = {
>       * Currently only a stub-function.
>       */
>
> -static int flat_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
> +static int flat_core_dump(struct coredump_params *cprm)
>      {
>      	printk("Process %s:%d received signr %d and should have core dumped\n",
> -			current->comm, current->pid, (int) signr);
> +			current->comm, current->pid, (int) cprm->signr);
>      	return(1);
>      }
>
> diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
> index eff74b9..2a9b533 100644
> --- a/fs/binfmt_som.c
> +++ b/fs/binfmt_som.c
> @@ -43,7 +43,7 @@ static int load_som_library(struct file *);
>       * don't even try.
>       */
>      #if 0
> -static int som_core_dump(long signr, struct pt_regs *regs, unsigned long limit);
> +static int som_core_dump(struct coredump_params *cprm);
>      #else
>      #define som_core_dump	NULL
>      #endif
> diff --git a/fs/exec.c b/fs/exec.c
> index ba112bd..5daf7d5 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1756,17 +1756,20 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>      	struct mm_struct *mm = current->mm;
>      	struct linux_binfmt * binfmt;
>      	struct inode * inode;
> -	struct file * file;
>      	const struct cred *old_cred;
>      	struct cred *cred;
>      	int retval = 0;
>      	int flag = 0;
>      	int ispipe = 0;
> -	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
>      	char **helper_argv = NULL;
>      	int helper_argc = 0;
>      	int dump_count = 0;
>      	static atomic_t core_dump_count = ATOMIC_INIT(0);
> +	struct coredump_params cprm = {
> +		.signr = signr,
> +		.regs = regs,
> +		.limit = current->signal->rlim[RLIMIT_CORE].rlim_cur,
> +	};
>
>      	audit_core_dumps(signr);
>
> @@ -1822,15 +1825,15 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>      	ispipe = format_corename(corename, signr);
>      	unlock_kernel();
>
> -	if ((!ispipe)&&  (core_limit<  binfmt->min_coredump))
> +	if ((!ispipe)&&  (cprm.limit<  binfmt->min_coredump))
>      		goto fail_unlock;
>
>       	if (ispipe) {
> -		if (core_limit == 0) {
> +		if (cprm.limit == 0) {
>      			/*
>      			 * Normally core limits are irrelevant to pipes, since
>      			 * we're not writing to the file system, but we use
> -			 * core_limit of 0 here as a speacial value. Any
> +			 * cprm.limit of 0 here as a speacial value. Any
>      			 * non-zero limit gets set to RLIM_INFINITY below, but
>      			 * a limit of 0 skips the dump.  This is a consistent
>      			 * way to catch recursive crashes.  We can still crash
> @@ -1863,25 +1866,25 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>      			goto fail_dropcount;
>      		}
>
> -		core_limit = RLIM_INFINITY;
> +		cprm.limit = RLIM_INFINITY;
>
>      		/* SIGPIPE can happen, but it's just never processed */
>      		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
> -				&file)) {
> +				&cprm.file)) {
>       			printk(KERN_INFO "Core dump to %s pipe failed\n",
>      			       corename);
>      			goto fail_dropcount;
>       		}
>       	} else
> - 		file = filp_open(corename,
> +		cprm.file = filp_open(corename,
>      				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
>      				 0600);
> -	if (IS_ERR(file))
> +	if (IS_ERR(cprm.file))
>      		goto fail_dropcount;
> -	inode = file->f_path.dentry->d_inode;
> +	inode = cprm.file->f_path.dentry->d_inode;
>      	if (inode->i_nlink>  1)
>      		goto close_fail;	/* multiple links - don't dump */
> -	if (!ispipe&&  d_unhashed(file->f_path.dentry))
> +	if (!ispipe&&  d_unhashed(cprm.file->f_path.dentry))
>      		goto close_fail;
>
>      	/* AK: actually i see no reason to not allow this for named pipes etc.,
> @@ -1894,21 +1897,22 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>      	 */
>      	if (inode->i_uid != current_fsuid())
>      		goto close_fail;
> -	if (!file->f_op)
> +	if (!cprm.file->f_op)
>      		goto close_fail;
> -	if (!file->f_op->write)
> +	if (!cprm.file->f_op->write)
>      		goto close_fail;
> -	if (!ispipe&&  do_truncate(file->f_path.dentry, 0, 0, file) != 0)
> +	if (!ispipe&&
> +	    do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file) != 0)
>      		goto close_fail;
>
> -	retval = binfmt->core_dump(signr, regs, file, core_limit);
> +	retval = binfmt->core_dump(&cprm);
>
>      	if (retval)
>      		current->signal->group_exit_code |= 0x80;
>      close_fail:
>      	if (ispipe&&  core_pipe_limit)
> -		wait_for_dump_helpers(file);
> -	filp_close(file, NULL);
> +		wait_for_dump_helpers(cprm.file);
> +	filp_close(cprm.file, NULL);
>      fail_dropcount:
>      	if (dump_count)
>      		atomic_dec(&core_dump_count);
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index aece486..cd4349b 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -68,6 +68,14 @@ struct linux_binprm{
>
>      #define BINPRM_MAX_RECURSION 4
>
> +/* Function parameter for binfmt->coredump */
> +struct coredump_params {
> +	long signr;
> +	struct pt_regs *regs;
> +	struct file *file;
> +	unsigned long limit;
> +};
> +
>      /*
>       * This structure defines the functions that are used to load the binary formats that
>       * linux accepts.
> @@ -77,7 +85,7 @@ struct linux_binfmt {
>      	struct module *module;
>      	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
>      	int (*load_shlib)(struct file *);
> -	int (*core_dump)(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
> +	int (*core_dump)(struct coredump_params *cprm);
>      	unsigned long min_coredump;	/* minimal dump size */
>      	int hasvdso;
>      };

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


--------------000704040900030905030506
Content-Type: text/plain;
 name="tp-signal-coredump.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tp-signal-coredump.patch"

tracepoint: Add signal coredump tracepoint

From: Masami Hiramatsu <mhiramat@redhat.com>

Add signal coredump tracepoint which shows signal number,
mm->flags, limits, pointer to file structure and core
file name.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 fs/exec.c                     |   22 +++++++++++----------
 include/trace/events/signal.h |   43 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 10 deletions(-)


diff --git a/fs/exec.c b/fs/exec.c
index 2ec6973..56f512a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -56,6 +56,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
 #include <linux/pipe_fs_i.h>
+#include <trace/events/signal.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1772,6 +1773,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.signr = signr,
+		.file = NULL,
 		.regs = regs,
 		.limit = current->signal->rlim[RLIMIT_CORE].rlim_cur,
 		/*
@@ -1837,9 +1839,6 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	ispipe = format_corename(corename, signr);
 	unlock_kernel();
 
-	if ((!ispipe) && (cprm.limit < binfmt->min_coredump))
-		goto fail_unlock;
-
  	if (ispipe) {
 		if (cprm.limit == 0) {
 			/*
@@ -1860,7 +1859,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 				"Process %d(%s) has RLIMIT_CORE set to 0\n",
 				task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Aborting core\n");
-			goto fail_unlock;
+			goto end_open;
 		}
 
 		dump_count = atomic_inc_return(&core_dump_count);
@@ -1868,14 +1867,14 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
 			       task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Skipping core dump\n");
-			goto fail_dropcount;
+			goto end_open;
 		}
 
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
-			goto fail_dropcount;
+			goto end_open;
 		}
 
 		cprm.limit = RLIM_INFINITY;
@@ -1885,13 +1884,17 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 				&cprm.file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
-			goto fail_dropcount;
+			goto end_open;
  		}
- 	} else
+	} else if (cprm.limit >= binfmt->min_coredump)
 		cprm.file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
-	if (IS_ERR(cprm.file))
+
+end_open:
+	trace_signal_coredump(&cprm, corename);
+
+	if (!cprm.file || IS_ERR(cprm.file))
 		goto fail_dropcount;
 	inode = cprm.file->f_path.dentry->d_inode;
 	if (inode->i_nlink > 1)
@@ -1928,7 +1931,6 @@ close_fail:
 fail_dropcount:
 	if (dump_count)
 		atomic_dec(&core_dump_count);
-fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
 
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index a510b75..7feba6e 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -6,6 +6,7 @@
 
 #include <linux/signal.h>
 #include <linux/sched.h>
+#include <linux/binfmts.h>
 #include <linux/tracepoint.h>
 
 #define TP_STORE_SIGINFO(__entry, info)				\
@@ -167,6 +168,48 @@ TRACE_EVENT(signal_lose_info,
 	TP_printk("sig=%d group=%d errno=%d code=%d",
 		  __entry->sig, __entry->group, __entry->errno, __entry->code)
 );
+
+/**
+ * signal_coredump - called when dumping core by signal
+ * @cprm: pointer to struct coredump_params
+ * @core_name: core-name string
+ *
+ * Current process dumps core file to 'core_name' file, because 'cprm->signr'
+ * signal is delivered.
+ * 'cprm->file' is a pointer to file structure of core file, if it is NULL
+ * or an error number(IS_ERR(cprm->file)), coredump should be failed.
+ */
+TRACE_EVENT(signal_coredump,
+
+	TP_PROTO(struct coredump_params *cprm, const char *core_name),
+
+	TP_ARGS(cprm, core_name),
+
+	TP_STRUCT__entry(
+		__field(	int,		sig		)
+		__field(	unsigned long,	limit		)
+		__field(	unsigned long,	flags		)
+		__field(	unsigned long,	file		)
+		__string(	name,		core_name	)
+	),
+
+
+	TP_fast_assign(
+		__entry->sig	= (int)cprm->signr;
+		__entry->limit	= cprm->limit;
+		__entry->flags	= cprm->mm_flags;
+		__entry->file	= (unsigned long)cprm->file;
+		__assign_str(name,	core_name);
+	),
+
+	TP_printk("sig=%d limit=%lu dumpable=%lx dump_filter=%lx "
+		  "file=%lx corename=%s",
+		  __entry->sig, __entry->limit,
+		  __entry->flags & MMF_DUMPABLE_MASK,
+		  (__entry->flags & MMF_DUMP_FILTER_MASK) >>
+		  MMF_DUMP_FILTER_SHIFT,
+		  __entry->file, __get_str(name))
+);
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */

--------------000704040900030905030506--
