Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZIIAeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZIIAeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZIIAd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:33:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33242 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZIIAd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:33:59 -0400
Message-ID: <4AA6F777.2080103@zytor.com>
Date: Tue, 08 Sep 2009 17:31:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Richard Kettlewell <rjk@terraraq.org.uk>
Subject: Re: [PATCH] x86: Fix code patching for paravirt-alternatives on 486
References: <1252452228.3423.121.camel@localhost>
In-Reply-To: <1252452228.3423.121.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 04:23 PM, Ben Hutchings wrote:
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index c776826..74ddfce 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -708,6 +708,12 @@ static inline void sync_core(void)
>  {
>  	int tmp;
>  
> +#if defined(CONFIG_M386) || defined(CONFIG_M486)
> +	/* This is unnecessary on 386- and 486-class processors, most of
> +	   which don't even implement CPUID. */
> +	if (boot_cpu_data.x86 < 5)
> +		return;
> +#endif
>  	asm volatile("cpuid" : "=a" (tmp) : "0" (1)
>  		     : "ebx", "ecx", "edx", "memory");
>  }
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 4869351..330ab89 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -498,6 +498,9 @@ static void *__init_or_module text_poke_early(void *addr, const void *opcode,
>  	unsigned long flags;
>  	local_irq_save(flags);
>  	memcpy(addr, opcode, len);
> +	/* Force 486-class processors to flush prefetched instructions,
> +	   since we may have just patched local_irq_restore(). */
> +	asm volatile("jmp 1f\n1:\n" ::: "memory");
>  	local_irq_restore(flags);
>  	sync_core();
>  	/* Could also do a CLFLUSH here to speed up CPU recovery; but

I'm wondering if it wouldn't be cleaner to fold the jump into
sync_core() and moving the sync_core() up before local_irq_restore().

	-hpa
