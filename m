Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZAGJTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZAGJTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZAGJTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:19:10 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55017 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbZAGJTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:19:09 -0500
Subject: Re: [ 286.547348] BUG: unable to handle kernel paging request at
	6b6b6b6b
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20090107091534.GA4633@osiris.boeblingen.de.ibm.com>
References: <4963F368.7080909@gmail.com>
	 <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com>
	 <84144f020901070030k6fb888f6n84255078e4885d28@mail.gmail.com>
	 <20090107091534.GA4633@osiris.boeblingen.de.ibm.com>
Date: Wed, 07 Jan 2009 11:19:06 +0200
Message-Id: <1231319946.14720.7.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 10:15 +0100, Heiko Carstens wrote:
> I missed to convert disable_nonboot_cpus to
> stop_machine_create/destroy.
> So it's a use before-even-allocated bug.
> 
> The patch below should hopefully fix it:
> 
> Subject: [PATCH] cpu hotplug: add stop_machine_create/destroy to disable_nonboot_cpus
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> disable_nonboot_cpus calls directly _cpu_down. _cpu_down however relies on
> the in advanced created stop_machine kernel threads which should be created
> by the caller (like cpu_down does).
> 
> So add the missing stop_machine_create/destroy calls to disable_nonboot_cpus
> as well.
> 
> Fixes this bug:
> 
> [  286.547348] BUG: unable to handle kernel paging request at 6b6b6b6b
> [  286.548940] IP: [<c0150ca4>] __stop_machine+0x88/0xe3
> [  286.550598] Oops: 0002 [#1] SMP
> [  286.560580] Pid: 3273, comm: halt Not tainted (2.6.28-06127-g238c6d5
> [  286.560580] EIP: is at __stop_machine+0x88/0xe3
> [  286.560580] Process halt (pid: 3273, ti=f1a28000 task=f4530f30
> [  286.560580] Call Trace:
> [  286.560580]  [<c03d04e4>] ? _cpu_down+0x10f/0x234
> [  286.560580]  [<c012a57e>] ? disable_nonboot_cpus+0x58/0xdc
> [  286.560580]  [<c01360c0>] ? kernel_poweroff+0x22/0x39
> [  286.560580]  [<c0136301>] ? sys_reboot+0xde/0x14c
> [  286.560580]  [<c01331b2>] ? complete_signal+0x179/0x191
> [  286.560580]  [<c0133396>] ? send_signal+0x1cc/0x1e1
> [  286.560580]  [<c03de418>] ? _spin_unlock_irqrestore+0x2d/0x3c
> [  286.560580]  [<c0133b65>] ? group_send_signal_info+0x58/0x61
> [  286.560580]  [<c0133b9e>] ? kill_pid_info+0x30/0x3a
> [  286.560580]  [<c0133d49>] ? sys_kill+0x75/0x13a
> [  286.560580]  [<c01a06cb>] ? mntput_no_expire+ox1f/0x101
> [  286.560580]  [<c019b3b3>] ? dput+0x1e/0x105
> [  286.560580]  [<c018ef87>] ?  __fput+0x150/0x158
> [  286.560580]  [<c0157abf>] ? audit_syscall_entry+0x137/0x159
> [  286.560580]  [<c010329f>] ? sysenter_do_call+0x12/0x34
> 
> Reported-by: "Justin P. Mattock" <justinmattock@gmail.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Looks good to me!

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  kernel/cpu.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/cpu.c
> ===================================================================
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -379,8 +379,11 @@ static cpumask_var_t frozen_cpus;
>  
>  int disable_nonboot_cpus(void)
>  {
> -	int cpu, first_cpu, error = 0;
> +	int cpu, first_cpu, error;
>  
> +	error = stop_machine_create();
> +	if (error)
> +		return error;
>  	cpu_maps_update_begin();
>  	first_cpu = cpumask_first(cpu_online_mask);
>  	/* We take down all of the non-boot CPUs in one shot to avoid races
> @@ -409,6 +412,7 @@ int disable_nonboot_cpus(void)
>  		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
>  	}
>  	cpu_maps_update_done();
> +	stop_machine_destroy();
>  	return error;
>  }
>  

