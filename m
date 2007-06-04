Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbXFDPSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbXFDPSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbXFDPSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:18:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:11367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbXFDPSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:18:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=dbDjHypITSeHOD/7C+5YHGB7Bl2sujkQE9v2v0JuWSR8c7K45N3umAhMoJYFftsie
	hyZYU06ra0P+vWlnITBWg==
Date: Mon, 4 Jun 2007 08:13:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 02/22] 2.6.22-rc3 perfmon2 : generic kernel
 modifications
In-Reply-To: <200705291348.l4TDmG1Y019632@frankl.hpl.hp.com>
Message-ID: <alpine.DEB.0.99.0706040810500.11881@chino.kir.corp.google.com>
References: <200705291348.l4TDmG1Y019632@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Stephane Eranian wrote:

> Only in linux-2.6.22/Documentation: perfmon2.txt

You need to send -N to diff(1) so this and perfmon.h, perfmon_dfl_smpl.h, 
perfmon_fmt.h, and perfmon_pmu.h will be included in the patch.  A 
patchset should compile and work correctly at any time when each patch is 
applied consecutively.  Providing perfmon.h, for example, in patch 13 
doesn't allow individual testing of all prior patches.

> diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/Makefile linux-2.6.22/Makefile
> --- linux-2.6.22.base/Makefile	2007-05-29 03:17:15.000000000 -0700
> +++ linux-2.6.22/Makefile	2007-05-29 03:24:14.000000000 -0700
> @@ -553,7 +553,7 @@ export mod_strip_cmd
>  
>  
>  ifeq ($(KBUILD_EXTMOD),)
> -core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
> +core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ perfmon/
>  
>  vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
>  		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
> diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/drivers/oprofile/oprofile_files.c linux-2.6.22/drivers/oprofile/oprofile_files.c
> --- linux-2.6.22.base/drivers/oprofile/oprofile_files.c	2007-05-29 03:17:41.000000000 -0700
> +++ linux-2.6.22/drivers/oprofile/oprofile_files.c	2007-05-29 03:24:14.000000000 -0700
> @@ -117,7 +117,17 @@ static ssize_t dump_write(struct file * 
>  static const struct file_operations dump_fops = {
>  	.write		= dump_write,
>  };
> - 
> +
> +static ssize_t implementation(struct file * file, char __user * buf, size_t count, loff_t * offset)
> +{
> +	return oprofilefs_str_to_user(oprofile_ops.implementation, buf, count, offset);
> +}
> +
> +
> +static struct file_operations implementation_fops = {
> +	.read		= implementation,
> +};
> +
>  void oprofile_create_files(struct super_block * sb, struct dentry * root)
>  {
>  	oprofilefs_create_file(sb, root, "enable", &enable_fops);
> @@ -127,6 +137,7 @@ void oprofile_create_files(struct super_
>  	oprofilefs_create_ulong(sb, root, "buffer_watershed", &fs_buffer_watershed);
>  	oprofilefs_create_ulong(sb, root, "cpu_buffer_size", &fs_cpu_buffer_size);
>  	oprofilefs_create_file(sb, root, "cpu_type", &cpu_type_fops); 
> +	oprofilefs_create_file(sb, root, "implementation", &implementation_fops);
>  	oprofilefs_create_file(sb, root, "backtrace_depth", &depth_fops);
>  	oprofilefs_create_file(sb, root, "pointer_size", &pointer_size_fops);
>  	oprofile_create_stats_files(sb, root);

The commentary for how to interpret this new file is lacking; it appears 
as though it will return "timer", "oprofile", or "nmi_timer" for existing 
i386 subsystems and "perfmon2" with this addition.  This should be 
documented.

It isn't set generically in oprofile_arch_init() for other architectures.

> diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/drivers/oprofile/timer_int.c linux-2.6.22/drivers/oprofile/timer_int.c
> --- linux-2.6.22.base/drivers/oprofile/timer_int.c	2007-05-29 03:17:41.000000000 -0700
> +++ linux-2.6.22/drivers/oprofile/timer_int.c	2007-05-29 03:24:14.000000000 -0700
> @@ -43,4 +43,5 @@ void __init oprofile_timer_init(struct o
>  	ops->start = timer_start;
>  	ops->stop = timer_stop;
>  	ops->cpu_type = "timer";
> +	ops->implementation = "timer";
>  }
> diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/include/linux/oprofile.h linux-2.6.22/include/linux/oprofile.h
> --- linux-2.6.22.base/include/linux/oprofile.h	2007-05-29 03:17:57.000000000 -0700
> +++ linux-2.6.22/include/linux/oprofile.h	2007-05-29 03:24:14.000000000 -0700
> @@ -39,6 +39,8 @@ struct oprofile_operations {
>  	void (*backtrace)(struct pt_regs * const regs, unsigned int depth);
>  	/* CPU identification string. */
>  	char * cpu_type;
> +	/* Identify method of  string. */
> +	char * implementation;
>  };
>  
>  /**
> Only in linux-2.6.22/include/linux: perfmon.h
> Only in linux-2.6.22/include/linux: perfmon_dfl_smpl.h
> Only in linux-2.6.22/include/linux: perfmon_fmt.h
> Only in linux-2.6.22/include/linux: perfmon_pmu.h
> diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/include/linux/sched.h linux-2.6.22/include/linux/sched.h
> --- linux-2.6.22.base/include/linux/sched.h	2007-05-29 03:17:57.000000000 -0700
> +++ linux-2.6.22/include/linux/sched.h	2007-05-29 03:24:14.000000000 -0700
> @@ -89,6 +89,7 @@ struct sched_param {
>  struct exec_domain;
>  struct futex_pi_state;
>  struct bio;
> +struct pfm_context;
>  
>  /*
>   * List of flags we want to share for kernel threads,
> @@ -1076,6 +1077,9 @@ struct task_struct {
>  #ifdef CONFIG_FAULT_INJECTION
>  	int make_it_fail;
>  #endif
> +#ifdef CONFIG_PERFMON
> +	struct pfm_context *pfm_context;
> +#endif
>  };
>  
>  static inline pid_t process_group(struct task_struct *tsk)
> diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/include/linux/syscalls.h linux-2.6.22/include/linux/syscalls.h
> --- linux-2.6.22.base/include/linux/syscalls.h	2007-05-29 03:17:57.000000000 -0700
> +++ linux-2.6.22/include/linux/syscalls.h	2007-05-29 03:24:14.000000000 -0700
> @@ -29,6 +29,13 @@ struct msqid_ds;
>  struct new_utsname;
>  struct nfsctl_arg;
>  struct __old_kernel_stat;
> +struct pfarg_ctx;
> +struct pfarg_pmc;
> +struct pfarg_pmd;
> +struct pfarg_start;
> +struct pfarg_load;
> +struct pfarg_setinfo;
> +struct pfarg_setdesc;
>  struct pollfd;
>  struct rlimit;
>  struct rusage;
> @@ -611,4 +618,27 @@ asmlinkage long sys_eventfd(unsigned int
>  
>  int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
>  
> +asmlinkage long sys_pfm_create_context(struct pfarg_ctx __user *ureq,
> +				       void __user *uarg, size_t smpl_size);
> +asmlinkage long sys_pfm_write_pmcs(int fd, struct pfarg_pmc __user *ureq,
> +				   int count);
> +asmlinkage long sys_pfm_write_pmds(int fd, struct pfarg_pmd __user *ureq,
> +				   int count);
> +asmlinkage long sys_pfm_read_pmds(int fd, struct pfarg_pmd __user *ureq,
> +				  int count);
> +asmlinkage long sys_pfm_restart(int fd);
> +asmlinkage long sys_pfm_stop(int fd);
> +asmlinkage long sys_pfm_start(int fd, struct pfarg_start __user *ureq);
> +asmlinkage long sys_pfm_load_context(int fd, struct pfarg_load __user *ureq);
> +asmlinkage long sys_pfm_unload_context(int fd);
> +asmlinkage long sys_pfm_delete_evtsets(int fd,
> +				       struct pfarg_setinfo __user *ureq,
> +				       int count);
> +asmlinkage long sys_pfm_create_evtsets(int fd,
> +				       struct pfarg_setdesc __user *ureq,
> +				       int count);
> +asmlinkage long sys_pfm_getinfo_evtsets(int fd,
> +					struct pfarg_setinfo __user *ureq,
> +					int count);
> +
>  #endif
> diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/kernel/sched.c linux-2.6.22/kernel/sched.c
> --- linux-2.6.22.base/kernel/sched.c	2007-05-29 03:17:57.000000000 -0700
> +++ linux-2.6.22/kernel/sched.c	2007-05-29 03:24:14.000000000 -0700
> @@ -53,6 +53,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/delayacct.h>
>  #include <linux/reciprocal_div.h>
> +#include <linux/perfmon.h>

perfmon.h isn't included in this patch so the inclusion of it here is a 
mystery but I suspect it's for pfm_ctxsw() later.

		David
