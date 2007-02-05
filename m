Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbXBESNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbXBESNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299AbXBESNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:13:06 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:58616 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932101AbXBESNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:13:05 -0500
Message-ID: <45C7740D.70509@sgi.com>
Date: Mon, 05 Feb 2007 10:14:37 -0800
From: Jay Lan <jlan@sgi.com>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Magnus Damm <magnus@valinux.co.jp>
CC: akpm@linux-foundation.org, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       nanhai.zou@intel.com, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, horms@verge.net.au, magnus.damm@gmail.com
Subject: Re: [PATCH] kexec: Fix CONFIG_SMP=n compilation V2 (ia64)
References: <20070205064342.21398.97736.sendpatchset@localhost>
In-Reply-To: <20070205064342.21398.97736.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> kexec: Fix CONFIG_SMP=n compilation V2 (ia64)
> 
> Kexec support for 2.6.20 on ia64 does not build properly using a config
> made up by CONFIG_SMP=n and CONFIG_HOTPLUG_CPU=n:
> 
>   CC      arch/ia64/kernel/machine_kexec.o
> arch/ia64/kernel/machine_kexec.c: In function `machine_shutdown':
> arch/ia64/kernel/machine_kexec.c:77: warning: implicit declaration of function `cpu_down'
>   AS      arch/ia64/kernel/relocate_kernel.o
>   CC      arch/ia64/kernel/crash.o
> arch/ia64/kernel/crash.c: In function `kdump_cpu_freeze':
> arch/ia64/kernel/crash.c:139: warning: implicit declaration of function `ia64_jump_to_sal'
> arch/ia64/kernel/crash.c:139: error: `sal_boot_rendez_state' undeclared (first use in this function)
> arch/ia64/kernel/crash.c:139: error: (Each undeclared identifier is reported only once
> arch/ia64/kernel/crash.c:139: error: for each function it appears in.)
> arch/ia64/kernel/crash.c: At top level:
> arch/ia64/kernel/crash.c:84: warning: 'kdump_wait_cpu_freeze' defined but not used
> make[1]: *** [arch/ia64/kernel/crash.o] Error 1
> make: *** [arch/ia64/kernel] Error 2
> 
> Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
> ---

Looks good to me also.

Acked-by: Jay Lan <jlan@sgi.com>

> machine_kexec.c
>  Applies on top of 2.6.20.
> 
>  arch/ia64/kernel/crash.c         |   11 +++++++----
>  arch/ia64/kernel/machine_kexec.c |    2 ++
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> --- 0002/arch/ia64/kernel/crash.c
> +++ work/arch/ia64/kernel/crash.c	2007-02-02 20:31:18.000000000 +0900
> @@ -79,6 +79,7 @@ crash_save_this_cpu()
>  	final_note(buf);
>  }
>  
> +#ifdef CONFIG_SMP
>  static int
>  kdump_wait_cpu_freeze(void)
>  {
> @@ -91,6 +92,7 @@ kdump_wait_cpu_freeze(void)
>  	}
>  	return 1;
>  }
> +#endif
>  
>  void
>  machine_crash_shutdown(struct pt_regs *pt)
> @@ -132,11 +134,12 @@ kdump_cpu_freeze(struct unw_frame_info *
>  	atomic_inc(&kdump_cpu_freezed);
>  	kdump_status[cpuid] = 1;
>  	mb();
> -	if (cpuid == 0) {
> -		for (;;)
> -			cpu_relax();
> -	} else
> +#ifdef CONFIG_HOTPLUG_CPU
> +	if (cpuid != 0)
>  		ia64_jump_to_sal(&sal_boot_rendez_state[cpuid]);
> +#endif
> +	for (;;)
> +		cpu_relax();
>  }
>  
>  static int
> --- 0002/arch/ia64/kernel/machine_kexec.c
> +++ work/arch/ia64/kernel/machine_kexec.c	2007-02-02 20:56:24.000000000 +0900
> @@ -70,12 +70,14 @@ void machine_kexec_cleanup(struct kimage
>  
>  void machine_shutdown(void)
>  {
> +#ifdef CONFIG_HOTPLUG_CPU
>  	int cpu;
>  
>  	for_each_online_cpu(cpu) {
>  		if (cpu != smp_processor_id())
>  			cpu_down(cpu);
>  	}
> +#endif
>  	kexec_disable_iosapic();
>  }
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

