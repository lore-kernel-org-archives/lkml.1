Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbZALRWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbZALRWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZALRWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:22:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44776 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbZALRWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:22:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29-rc1 does not boot and fails to resume
Date: Mon, 12 Jan 2009 18:22:08 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Dieter Ries <clip2@gmx.de>,
       travis@sgi.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <496A085E.8020604@gmx.de> <8db1092f0901120322x5e453fd0x61a78cc1a55982aa@mail.gmail.com> <20090112112608.GB19388@elte.hu>
In-Reply-To: <20090112112608.GB19388@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121822.09492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009, Ingo Molnar wrote:
> 
> * Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> 
> > 2009/1/11 Dieter Ries <clip2@gmx.de>:
> > > Hi,
> > >
> > > Ingo Molnar schrieb:
> > >>>> * Dieter Ries <clip2@gmx.de> wrote:
> > >>>>
> > >>>>> Hi,
> > >>>>>
> > >>>>> I just pulled 2.6.29-rc1, ran oldconfig with defaults and built it.
> > >>>>> When I try to boot it, that kind of works until init should start. Then
> > >>>>> nothing happens. I tried with init=/bin/bash, which sometimes works, and
> > >>>>> sometimes gets me a bash without the prompt flashing.
> > >>>>>
> > 
> > Simmilar issue, described:
> > http://lkml.indiana.edu/hypermail/linux/kernel/0901.1/01701.html
> > 
> > [...]
> > ####################################################################
> > > 7503bfbae89eba07b46441a5d1594647f6b8ab7d is first bad commit
> > > commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
> > > Author: Mike Travis <travis@sgi.com>
> > > Date:   Sun Jan 4 05:18:09 2009 -0800
> > >
> > > cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
> > >
> > > Impact: use new cpumask API to reduce stack usage
> > >
> > > Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr()
> > > with a work_on_cpu function for drv_read() and drv_write().
> > >
> > > Basically converts do_drv_{read,write} into "work_on_cpu" functions that
> > > are now called by drv_read and drv_write.
> > >
> > > Signed-off-by: Mike Travis <travis@sgi.com>
> > > Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > Revert this commit also solves problem on my laptoop.
> 
> yes - the revert patch can be found below.

Just for the record, apart from the boot problems the commit the patch below
reverts is also causing a suspend-resume regression for people.

Thanks,
Rafael


> ------------------->
> From e0b7a3bea054249b27ca3c843bf6eefcb509d1c2 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 12 Jan 2009 10:49:53 +0100
> Subject: [PATCH] Revert "cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write"
> 
> This reverts commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d.
> 
> Dieter Ries reported bootup soft-hangs and bisected it back to
> this commit, and reverting this commit gave him a working system.
> 
> The commit introduces work_on_cpu() use into the cpufreq code,
> but that is subtly problematic from a lock hierarchy POV: the
> hotplug-cpu lock is an highlevel lock that is taken before
> lowlevel locks, and in this codepath we are called with the
> policy lock taken.
> 
> Dieter did not have lockdep enabled so we dont have a nice stack
> trace proof for this, but using work_on_cpu() in such a lowlevel
> place certainly looks wrong, so we revert the patch.
> 
> work_on_cpu() needs to be reworked to be more generally usable.
> 
> Reported-by: Dieter Ries <clip2@gmx.de>
> Tested-by: Dieter Ries <clip2@gmx.de>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   25 ++++++++++++-------------
>  1 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 06fcd8f..6f11e02 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -150,9 +150,8 @@ struct drv_cmd {
>  	u32 val;
>  };
>  
> -static long do_drv_read(void *_cmd)
> +static void do_drv_read(struct drv_cmd *cmd)
>  {
> -	struct drv_cmd *cmd = _cmd;
>  	u32 h;
>  
>  	switch (cmd->type) {
> @@ -167,12 +166,10 @@ static long do_drv_read(void *_cmd)
>  	default:
>  		break;
>  	}
> -	return 0;
>  }
>  
> -static long do_drv_write(void *_cmd)
> +static void do_drv_write(struct drv_cmd *cmd)
>  {
> -	struct drv_cmd *cmd = _cmd;
>  	u32 lo, hi;
>  
>  	switch (cmd->type) {
> @@ -189,23 +186,30 @@ static long do_drv_write(void *_cmd)
>  	default:
>  		break;
>  	}
> -	return 0;
>  }
>  
>  static void drv_read(struct drv_cmd *cmd)
>  {
> +	cpumask_t saved_mask = current->cpus_allowed;
>  	cmd->val = 0;
>  
> -	work_on_cpu(cpumask_any(cmd->mask), do_drv_read, cmd);
> +	set_cpus_allowed_ptr(current, cmd->mask);
> +	do_drv_read(cmd);
> +	set_cpus_allowed_ptr(current, &saved_mask);
>  }
>  
>  static void drv_write(struct drv_cmd *cmd)
>  {
> +	cpumask_t saved_mask = current->cpus_allowed;
>  	unsigned int i;
>  
>  	for_each_cpu(i, cmd->mask) {
> -		work_on_cpu(i, do_drv_write, cmd);
> +		set_cpus_allowed_ptr(current, cpumask_of(i));
> +		do_drv_write(cmd);
>  	}
> +
> +	set_cpus_allowed_ptr(current, &saved_mask);
> +	return;
>  }
>  
>  static u32 get_cur_val(const struct cpumask *mask)
> @@ -231,15 +235,10 @@ static u32 get_cur_val(const struct cpumask *mask)
>  		return 0;
>  	}
>  
> -	if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
> -		return 0;
> -
>  	cpumask_copy(cmd.mask, mask);
>  
>  	drv_read(&cmd);
>  
> -	free_cpumask_var(cmd.mask);
> -
>  	dprintk("get_cur_val = %u\n", cmd.val);
>  
>  	return cmd.val;
> --
