Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYKDWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYKDWcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYKDWc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:32:27 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:47398 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbYKDWc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:32:26 -0500
Message-ID: <4910CD65.1010301@cosmosbay.com>
Date: Tue, 04 Nov 2008 23:32:05 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
References: <4909F690.9090208@cosmosbay.com> <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com> <20081104181855.GK9785@erda.amd.com> <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 04 Nov 2008 23:32:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg a écrit :
> Hi Robert,
> 
> On Tue, 4 Nov 2008, Robert Richter wrote:
>> your patchset breaks oprofile on Intel Core 2 cpus. I could bisect the
>> bug for c493756..5951290. Please take a look at this and send me a fix.
> 
> Unfortunately I don't have my machine with me right now so I can't test 
> this, but don't we want something like this? Andi?

Thanks a lot Pekka, this patch restores oprofile on my HP BL460c G1

Tested-by: Eric Dumazet <dada1@cosmosbay.com>

> 
> 		Pekka
> 
>>From 37d362c0262006be6a5d6a72b5993834afa776d7 Mon Sep 17 00:00:00 2001
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> Date: Tue, 4 Nov 2008 21:17:47 +0200
> Subject: [PATCH] oprofile: make perfmon nethalem only
> 
> Commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8 ("oprofile: Implement Intel
> architectural perfmon support") added perfmon support to newer Intel CPUs
> (Core1+). The problem there is that it requires a patched oprofile userland to
> work properly.
> 
> Fix that up by making oprofile perfmon support nethalem only.
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  arch/x86/oprofile/nmi_int.c       |    7 +++++++
>  arch/x86/oprofile/op_model_ppro.c |    4 +++-
>  2 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index 022cd41..1f4448e 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -426,8 +426,15 @@ static int __init ppro_init(char **cpu_type)
>  
>  static int __init arch_perfmon_init(char **cpu_type)
>  {
> +	__u8 cpu_model = boot_cpu_data.x86_model;
> +
>  	if (!cpu_has_arch_perfmon)
>  		return 0;
> +
> +	/* Nethalem only */
> +	if (cpu_model != 26)
> +		return 0;
> +
>  	*cpu_type = "i386/arch_perfmon";
>  	model = &op_arch_perfmon_spec;
>  	arch_perfmon_setup_counters();
> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> index 0620d6d..1c91ba2 100644
> --- a/arch/x86/oprofile/op_model_ppro.c
> +++ b/arch/x86/oprofile/op_model_ppro.c
> @@ -66,6 +66,7 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
>  
>  static void ppro_setup_ctrs(struct op_msrs const * const msrs)
>  {
> +	__u8 cpu_model = boot_cpu_data.x86_model;
>  	unsigned int low, high;
>  	int i;
>  
> @@ -76,7 +77,8 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
>  			return;
>  	}
>  
> -	if (cpu_has_arch_perfmon) {
> +	/* Nethalem only */
> +	if (cpu_has_arch_perfmon && cpu_model == 26) {
>  		union cpuid10_eax eax;
>  		eax.full = cpuid_eax(0xa);
>  		if (counter_width < eax.split.bit_width)


