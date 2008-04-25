Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbYDYJLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbYDYJLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758505AbYDYJLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:11:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:41990 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267AbYDYJLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=rb7tu2MI9M71y2BKRPqDJspXB4nK+AKA7NfaSlewn6/5w5u5vzszESN+z+YZj7+bJ12HyXrmVyh/o1Sp1jzFMsFwhQs5DyphKbbePwEA460EDEtkBcNs/6Yd3Ok+wx0ee0dz0ZbM6p3wsPzUMoJNn0NmzIaAJ0IizOsHuvyNggI=
Message-ID: <4811A03A.7010109@googlemail.com>
Date: Fri, 25 Apr 2008 11:11:22 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Priit Laes <plaes@plaes.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [REGRESSION] x86: support for new UV apic
References: <1209098600.3707.13.camel@localhost> <20080425064405.GA23043@elte.hu>
In-Reply-To: <20080425064405.GA23043@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Priit Laes <plaes@plaes.org> wrote:
> 
>> Hey,
>>
>> I am getting two following warnings (probable one per each CPU core) 
>> using the latest Linus's git:
>>
>> WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x30/0x62()
>> Modules linked in:
>> Pid: 1, comm: swapper Not tainted 2.6.25-03563-gf7288b1 #20
> 
> thanks - could you check the patch below, does it fix the warnings?

Hi Ingo ,

I got the same warning on my Core2Quad Q9300 box , your patch fixes the warning for me.


> 
> 	Ingo
> 
> --------------->
> Subject: x86: disable preemption in native_smp_prepare_cpus
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri Apr 18 11:07:10 CEST 2008
> 
> Priit Laes reported the following warning:
> 
> Call Trace:
>  [<ffffffff8022f1e1>] warn_on_slowpath+0x51/0x63
>  [<ffffffff80282e48>] sys_ioctl+0x2d/0x5d
>  [<ffffffff805185ff>] _spin_lock+0xe/0x24
>  [<ffffffff80227459>] task_rq_lock+0x3d/0x73
>  [<ffffffff805133c3>] set_cpu_sibling_map+0x336/0x350
>  [<ffffffff8021c1b8>] read_apic_id+0x30/0x62
>  [<ffffffff806d921d>] verify_local_APIC+0x90/0x138
>  [<ffffffff806d84b5>] native_smp_prepare_cpus+0x1f9/0x305
>  [<ffffffff806ce7b1>] kernel_init+0x59/0x2d9
>  [<ffffffff80518a26>] _spin_unlock_irq+0x11/0x2b
>  [<ffffffff8020bf48>] child_rip+0xa/0x12
>  [<ffffffff806ce758>] kernel_init+0x0/0x2d9
>  [<ffffffff8020bf3e>] child_rip+0x0/0x12
> 
> fix this by generally disabling preemption in native_smp_prepare_cpus().
> 
> Reported-and-bisected-by: Priit Laes <plaes@plaes.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/kernel/smpboot.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-x86.q/arch/x86/kernel/smpboot.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/smpboot.c
> +++ linux-x86.q/arch/x86/kernel/smpboot.c
> @@ -1181,6 +1181,7 @@ static void __init smp_cpu_index_default
>   */
>  void __init native_smp_prepare_cpus(unsigned int max_cpus)
>  {
> +	preempt_disable();
>  	nmi_watchdog_default();
>  	smp_cpu_index_default();
>  	current_cpu_data = boot_cpu_data;
> @@ -1197,7 +1198,7 @@ void __init native_smp_prepare_cpus(unsi
>  	if (smp_sanity_check(max_cpus) < 0) {
>  		printk(KERN_INFO "SMP disabled\n");
>  		disable_smp();
> -		return;
> +		goto out;
>  	}
>  
>  	preempt_disable();
> @@ -1237,6 +1238,8 @@ void __init native_smp_prepare_cpus(unsi
>  	printk(KERN_INFO "CPU%d: ", 0);
>  	print_cpu_info(&cpu_data(0));
>  	setup_boot_clock();
> +out:
> +	preempt_enable();
>  }
>  /*
>   * Early setup to make printk work.


Regards,

Gabriel
