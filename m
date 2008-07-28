Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbYG1ThA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbYG1ThA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYG1Tgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:36:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44211 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYG1Tgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:36:51 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5348"; a="5116496"
Message-ID: <488E1FD1.8060902@qualcomm.com>
Date: Mon, 28 Jul 2008 12:36:49 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Peter Oruba <peter.oruba@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 10/11] [PATCH 10/11] x86: Major refactoring.
References: <20080728164411.490752571@amd.com> <20080728164449.234580245@amd.com>
In-Reply-To: <20080728164449.234580245@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Oruba wrote:
> Refactored code by introducing a two-module solution. There is one
> general module in which vendor specific modules can hook into.
> However, that is exclusive, there is only one vendor specific module
> allowed at a time. A CPU vendor check makes sure only the corect
> module for the underlying system gets called. Functinally in terms
> of patch loading itself there are no changes. This refactoring
> provides a basis for future implementations of other vendors'
> patch loaders.
> 
> Signed-off-by: Peter Oruba <peter.oruba@amd.com>
<snip>

> diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
> index c1047d7..1e42e79 100644
> --- a/arch/x86/kernel/microcode.c
> +++ b/arch/x86/kernel/microcode.c
<snip>

> @@ -244,9 +243,9 @@ static void microcode_init_cpu(int cpu, int resume)
>  
>  	set_cpus_allowed_ptr(current, newmask);
>  	mutex_lock(&microcode_mutex);
> -	collect_cpu_info(cpu);
> +	microcode_ops->collect_cpu_info(cpu);
>  	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
> -		cpu_request_microcode(cpu);
> +		microcode_ops->cpu_request_microcode(cpu);
>  	mutex_unlock(&microcode_mutex);
>  	set_cpus_allowed_ptr(current, &old);
> @@ -274,7 +273,7 @@ static ssize_t reload_store(struct sys_device *dev,
>  
>  		mutex_lock(&microcode_mutex);
>  		if (uci->valid)
> -			err = cpu_request_microcode(cpu);
> +			err = microcode_ops->cpu_request_microcode(cpu);
>  		mutex_unlock(&microcode_mutex);
>  		put_online_cpus();
>  		set_cpus_allowed_ptr(current, &old);

Peter, question while we're at it. This came up in another thread and I 
asked the same question to Tigran but he is either on vacation or not 
paying attention :).

Microcode cpu hotplug handler is messing with the cps_allowed flags of a 
random process and can race with sched_setaffinity() (pointed by 
Dmitry). It also makes some assumptions on the overall cpu hotplug 
sequence which is bad.

It's easy to fix but the question is - does the microcode update need to 
happen synchronously ? I'm thinking that it does not but I wanted to 
verify that. If it does not need to be synchronous then we can simply 
schedule a work queue and do the update there. If it does we could do 
collect_cpu_info() and load_microcode() in the IPIs.

Max
