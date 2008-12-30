Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbYL3Guc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbYL3Guc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYL3GuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:50:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56069 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYL3GuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:50:23 -0500
Date: Tue, 30 Dec 2008 07:50:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
Message-ID: <20081230065008.GC30975@elte.hu>
References: <20081227155019.GA15493@elte.hu> <4959466F.5030205@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4959466F.5030205@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> Ingo Molnar wrote:
>
>> today i (belatedly ...) started looking into the status of the 
>> tip/x86/mce branch, and merged it into tip/master as a first step.
>>
>> firstly there's a small complication, it triggers this crash with the  
>> attached config:
>>
>
> I tested the config on a couple of different systems. Unfortunately I 
> wasn't able to reproduce the problem. It booted always fine even on 
> multiple tries.
>
> I had to adapt the configuration slightly to boot in my setup.
>
> The configuration also was not complete, i had to press return a few 
> times (are you sure you sent me the correct file?)
>
> One merging issue I noted is that you put the perfctrs and mce self on 
> the same vector. The attached patch fixes that.

hm, will re-test and see whether i can get more debug info out of the 
system.

> commit c736d118dcad93929dfc21cb72f33bc94c1b314a
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Sun Dec 28 14:16:43 2008 +0100
> 
>     Avoid conflict of apic error and local perfmon vector
>     
>     Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index 73957a2..0fcb682 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -88,7 +88,7 @@
>  /*
>   * Performance monitoring interrupt vector:
>   */
> -#define LOCAL_PERF_VECTOR	0xee
> +#define LOCAL_PERF_VECTOR	0xed

this reminds me, i dont particularly like the way you added a 
self-interrupt:

+       __send_IPI_shortcut(APIC_DEST_SELF, MCE_SELF_VECTOR, 0);

IPI self-sends are generally more fragile than task-flag based methods, 
and they also waste IRQ vector real-estate.

	Ingo
