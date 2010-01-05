Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980Ab0AEG5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0AEG5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763Ab0AEG5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:57:10 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58819 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0AEG5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:57:09 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/9] SYSCTL: Use RCU strings for core_pattern sysctl
References: <20100105315.789846878@firstfloor.org>
	<20100105021529.205EFB17C2@basil.firstfloor.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 04 Jan 2010 22:56:59 -0800
In-Reply-To: <20100105021529.205EFB17C2@basil.firstfloor.org> (Andi Kleen's message of "Tue\,  5 Jan 2010 03\:15\:29 +0100 \(CET\)")
Message-ID: <m1zl4t82f8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Also saves ~220 bytes in the data segment for default kernels.
>
> As a bonus this removes one use of the BKL.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> ---
>  fs/exec.c       |   11 +++++------
>  kernel/sysctl.c |    6 +++---
>  2 files changed, 8 insertions(+), 9 deletions(-)
>
> Index: linux-2.6.33-rc2-ak/fs/exec.c
> ===================================================================
> --- linux-2.6.33-rc2-ak.orig/fs/exec.c
> +++ linux-2.6.33-rc2-ak/fs/exec.c
> @@ -62,7 +62,7 @@
>  #include "internal.h"
>  
>  int core_uses_pid;
> -char core_pattern[CORENAME_MAX_SIZE] = "core";
> +char *core_pattern = "core";
>  unsigned int core_pipe_limit;
>  int suid_dumpable = 0;
>  
> @@ -1421,7 +1421,7 @@ EXPORT_SYMBOL(set_binfmt);
>  static int format_corename(char *corename, long signr)
>  {
>  	const struct cred *cred = current_cred();
> -	const char *pat_ptr = core_pattern;
> +	const char *pat_ptr = rcu_dereference(core_pattern);

rcu_dereference should aways be between rcu_read_lock()
and rcu_read_unlock();

>  	int ispipe = (*pat_ptr == '|');
>  	char *out_ptr = corename;
>  	char *const out_end = corename + CORENAME_MAX_SIZE;
> @@ -1825,12 +1825,11 @@ void do_coredump(long signr, int exit_co
>  	clear_thread_flag(TIF_SIGPENDING);
>  
>  	/*
> -	 * lock_kernel() because format_corename() is controlled by sysctl, which
> -	 * uses lock_kernel()
> +	 * Protect corename by RCU vs proc_rcu_string()
>  	 */
> - 	lock_kernel();
> +	rcu_read_lock();
>  	ispipe = format_corename(corename, signr);
> -	unlock_kernel();
> +	rcu_read_unlock();
>  
>  	if ((!ispipe) && (cprm.limit < binfmt->min_coredump))
>  		goto fail_unlock;
> Index: linux-2.6.33-rc2-ak/kernel/sysctl.c
> ===================================================================
> --- linux-2.6.33-rc2-ak.orig/kernel/sysctl.c
> +++ linux-2.6.33-rc2-ak/kernel/sysctl.c
> @@ -75,7 +75,7 @@ extern int sysctl_oom_dump_tasks;
>  extern int max_threads;
>  extern int core_uses_pid;
>  extern int suid_dumpable;
> -extern char core_pattern[];
> +extern char *core_pattern;
>  extern unsigned int core_pipe_limit;
>  extern int pid_max;
>  extern int min_free_kbytes;
> @@ -399,10 +399,10 @@ static struct ctl_table kern_table[] = {
>  	},
>  	{
>  		.procname	= "core_pattern",
> -		.data		= core_pattern,
> +		.data		= &core_pattern,
>  		.maxlen		= CORENAME_MAX_SIZE,
>  		.mode		= 0644,
> -		.proc_handler	= proc_dostring,
> +		.proc_handler	= proc_rcu_string,
>  	},
>  	{
>  		.procname	= "core_pipe_limit",
