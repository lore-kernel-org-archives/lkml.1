Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbZJGU0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbZJGU0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760030AbZJGU0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:26:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760020AbZJGU0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:26:47 -0400
Date: Wed, 7 Oct 2009 22:15:36 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Sven-Thorsten Dietrich <sdietrich@suse.de>
Subject: Re: [PATCH] x86: Remove the bkl from msr_open()
In-Reply-To: <1254944602-7382-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.LFD.2.00.0910072214290.15183@localhost.localdomain>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain> <1254944602-7382-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Frederic Weisbecker wrote:

> Remove the big kernel lock from msr_open() as it doesn't protect
> anything there.
> 
> The only racy event that can happen here is a concurrent cpu shutdown.
> 
> So let's look at what could be racy during/after the above event:
> 
> - The cpu_online() check is racy, but the bkl doesn't help about
>   that anyway it disables preemption but we may be chcking another
>   cpu than the current one.
>   Also the cpu can still become offlined between open and read calls.
> 
> - The cpu_data(cpu) returns a safe pointer too. It won't be released on
>   cpu offlining. But some fields can be changed from
>   arch/x86/kernel/smpboot.c:remove_siblinginfo() :
> 
> 	- phys_proc_id
> 	- cpu_core_id
> 
>   Those are not read from msr_open(). What we are checking is the
>   x86_capability that is left untouched on offlining.
> 
> So this removal looks safe.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Sven-Thorsten Dietrich <sdietrich@suse.de>
> ---
>  arch/x86/kernel/msr.c |   16 ++++++----------
>  1 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
> index 6a3cefc..5534499 100644
> --- a/arch/x86/kernel/msr.c
> +++ b/arch/x86/kernel/msr.c
> @@ -174,21 +174,17 @@ static int msr_open(struct inode *inode, struct file *file)
>  {
>  	unsigned int cpu = iminor(file->f_path.dentry->d_inode);
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> -	int ret = 0;
>  
> -	lock_kernel();
>  	cpu = iminor(file->f_path.dentry->d_inode);
>  
> -	if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
> -		ret = -ENXIO;	/* No such CPU */
> -		goto out;
> -	}
> +	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
> +		return -ENXIO;	/* No such CPU */
> +
>  	c = &cpu_data(cpu);
>  	if (!cpu_has(c, X86_FEATURE_MSR))
> -		ret = -EIO;	/* MSR not supported */
> -out:
> -	unlock_kernel();
> -	return ret;
> +		return -EIO;	/* MSR not supported */
> +
> +	return 0;
>  }
>  
>  /*
> -- 
> 1.6.2.3
> 
> 

This case looks very similar to the cpuid_open one.
Reviewed-by: John Kacur <jkacur@redhat.com>
