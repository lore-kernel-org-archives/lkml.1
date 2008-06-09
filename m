Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYFIRvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYFIRvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYFIRv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:51:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:18147 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYFIRv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LCn3QJiHmL9THyy7oAWpl1w9qWxrVebmzui8dXcHBX4SJu8/YIYKcUV6bs32jNUzHe
         el2uv9ceUZrPjIebH3IpgAzhrnFdN22CGNXQavt4MYO07imw0FvZt254DFM9BsrkVrFV
         57w43d0AmOHRkvJJnxDKmVJr6u11u3wc6FFIs=
Message-ID: <86802c440806091051j30ac4480oe6be0a7b288f772c@mail.gmail.com>
Date: Mon, 9 Jun 2008 10:51:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: update mptable v7 - fix
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080609101318.GA23873@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200805251600.26325.yhlu.kernel@gmail.com>
	 <200806011317.38622.yhlu.kernel@gmail.com>
	 <200806081953.26877.yhlu.kernel@gmail.com>
	 <20080609101318.GA23873@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 3:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> [PATCH] x86: update mptable v7 - fix
>>
>> need to call early_reserve_e820 to prelocate mptable for 32bit
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> Index: linux-2.6/arch/x86/kernel/setup_32.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/setup_32.c
>> +++ linux-2.6/arch/x86/kernel/setup_32.c
>> @@ -761,6 +761,8 @@ void __init setup_arch(char **cmdline_p)
>>        */
>>       max_pfn = e820_end_of_ram();
>>
>> +     /* pre allocte 4k for mptable mpc */
>> +     early_reserve_e820_mpc_new();
>
> applied, thanks. It needed the small build fix below as well, for UP
> 32-bit.
>
>        Ingo
>
> --------------->
> commit 3c803fb3e1972566f7a1613f53f7e5a70fbde83f
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Sun May 25 21:16:06 2008 +0200
>
>    x86, mpparse: build fix
>
>    fix:
>
>      LD      .tmp_vmlinux1
>      arch/x86/kernel/built-in.o: In function `setup_arch':
>      : undefined reference to `early_reserve_e820_mpc_new'
>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> diff --git a/include/asm-x86/mpspec.h b/include/asm-x86/mpspec.h
> index 6e9c958..b8ba374 100644
> --- a/include/asm-x86/mpspec.h
> +++ b/include/asm-x86/mpspec.h
> @@ -46,7 +46,11 @@ extern unsigned long mp_lapic_addr;
>
>  extern void find_smp_config(void);
>  extern void get_smp_config(void);
> +#ifdef CONFIG_X86_MPPARSE
>  extern void early_reserve_e820_mpc_new(void);
> +#else
> +static inline void early_reserve_e820_mpc_new(void) { }
> +#endif
>
>  void __cpuinit generic_processor_info(int apicid, int version);
>  #ifdef CONFIG_ACPI

thanks. So X86_MPPARSE is not needed when SMP is not enabled?

YH
