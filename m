Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbXFYMlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbXFYMlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbXFYMl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:41:28 -0400
Received: from gw.goop.org ([64.81.55.164]:60905 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbXFYMl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:41:27 -0400
Message-ID: <467FB7C3.1080206@goop.org>
Date: Mon, 25 Jun 2007 08:40:35 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch, 2.6.22-rc6] fix nmi_watchdog=2 bootup hang
References: <20070605093349.GA24956@elte.hu> <20070605093958.GA26135@elte.hu> <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu> <20070625061819.GA21874@elte.hu> <20070625065956.GA31725@elte.hu> <20070625080521.GA24333@elte.hu>
In-Reply-To: <20070625080521.GA24333@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> hm, restoring nmi.c to the v2.6.21 state does not fix the 
>> nmi_watchdog=2 hang. I'll do a bisection run.
>>     
>
> and after spending an hour on 15 bisection steps:
>
>  git-bisect start
>  git-bisect good d1be341dba5521506d9e6dccfd66179080705bea
>  git-bisect bad a06381fec77bf88ec6c5eb6324457cb04e9ffd69
>  git-bisect bad 794543a236074f49a8af89ef08ef6a753e4777e5
>  git-bisect good 24a77daf3d80bddcece044e6dc3675e427eef3f3
>  git-bisect bad ea62ccd00fd0b6720b033adfc9984f31130ce195
>  git-bisect good 7e20ef030dde0e52dd5a57220ee82fa9facbea4e
>  git-bisect bad f19cccf366a07e05703c90038704a3a5ffcb0607
>  git-bisect good 0d08e0d3a97cce22ebf80b54785e00d9b94e1add
>  git-bisect bad 856f44ff4af6e57fdc39a8b2bec498c88438bd27
>  git-bisect bad f8822f42019eceed19cc6c0f985a489e17796ed8
>  git-bisect good 1c3d99c11c47c8a1a9ed6a46555dbf6520683c52
>  git-bisect good b239fb2501117bf3aeb4dd6926edd855be92333d
>  git-bisect good 98de032b681d8a7532d44dfc66aa5c0c1c755a9d
>  git-bisect good 42c24fa22e86365055fc931d833f26165e687c19
>
> the winner is ...
>
>  f8822f42019eceed19cc6c0f985a489e17796ed8 is first bad commit
>  commit f8822f42019eceed19cc6c0f985a489e17796ed8
>  Author: Jeremy Fitzhardinge <jeremy@goop.org>
>  Date:   Wed May 2 19:27:14 2007 +0200
>
>     [PATCH] i386: PARAVIRT: Consistently wrap paravirt ops callsites to make them patchable
>
> ... our wonderful paravirt subsystem, honed to eternal perfection by the 
> testing-machine x86_64 tree.
>
> reverting -git-curr's paravirt.c, paravirt.h, smp.c and tlbflush.h to 
> before the bad commit makes the NMI watchdog work again. Patch against 
> -rc6 is below.
>   

Er, wow.  I've been running with this stuff for months without a 
problem.   Do you have CONFIG_PARAVIRT enabled?  Do you still get the 
hang if you boot with "noreplace-paravirt" to disable the patching? 

Your revert patch seems to take out quite a lot of stuff, some unrelated 
to the paravirt_ops.  Where did that come from?

I presume there's one bad callsite in here which is used by the nmi path 
more or less exclusively.  Is the bug simply that it hangs if you boot 
with nmi_watchdog=2?  ie, no other details?

> @@ -222,10 +211,30 @@ void send_IPI_mask_sequence(cpumask_t ma
>  	 */ 
>  
>  	local_irq_save(flags);
> +
>  	for (query_cpu = 0; query_cpu < NR_CPUS; ++query_cpu) {
>  		if (cpu_isset(query_cpu, mask)) {
> -			__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu),
> -					      vector);
> +		
> +			/*
> +			 * Wait for idle.
> +			 */
> +			apic_wait_icr_idle();
> +		
> +			/*
> +			 * prepare target chip field
> +			 */
> +			cfg = __prepare_ICR2(cpu_to_logical_apicid(query_cpu));
> +			apic_write_around(APIC_ICR2, cfg);
> +		
> +			/*
> +			 * program the ICR 
> +			 */
> +			cfg = __prepare_ICR(0, vector);
> +			
> +			/*
> +			 * Send the IPI. The write to APIC_ICR fires this off.
> +			 */
> +			apic_write_around(APIC_ICR, cfg);
>  		}
>  	}
>  	local_irq_restore(flags);
>   

What's this?  This isn't paravirt_ops related, is it?

    J
