Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbXLKPDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbXLKPDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbXLKPDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:03:42 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:13663 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbXLKPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:03:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=n8WcKceof1y97piSt8PJSKdy9eEJOI8pAJIjUDLIqKwWeS3u9cyR/TaliJS8Z4yomgisYamsrmuvkd0LmWEh8ZwCDdPKts5Ec1TVtluomDruAC6LpNy96CEply82dX5WYTRrX14bFP7PchhVy63bfqTM025COaOXGzsgQ/GAQQM=
Message-ID: <475EA6C6.2010002@qumranet.com>
Date: Tue, 11 Dec 2007 17:03:34 +0200
Reply-To: dor.laor@qumranet.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Performance overhead of get_cycles_sync
References: <475E8C8B.7070308@qumranet.com> <20071211133738.GA8150@elte.hu> <475E9A92.4030001@qumranet.com> <20071211142717.GA15903@elte.hu>
In-Reply-To: <20071211142717.GA15903@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dor Laor <dor.laor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dor Laor <dor.laor@gmail.com> wrote:
>
>   
>> Here [include/asm-x86/tsc.h]:
>>
>> /* Like get_cycles, but make sure the CPU is synchronized. */
>> static __always_inline cycles_t get_cycles_sync(void)
>> {
>>    unsigned long long ret;
>>    unsigned eax, edx;
>>
>>    /*
>>       * Use RDTSCP if possible; it is guaranteed to be synchronous
>>      * and doesn't cause a VMEXIT on Hypervisors
>>     */
>>    alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
>>               ASM_OUTPUT2("=a" (eax), "=d" (edx)),
>>               "a" (0U), "d" (0U) : "ecx", "memory");
>>    ret = (((unsigned long long)edx) << 32) | ((unsigned long long)eax);
>>    if (ret)
>>        return ret;
>>
>>    /*
>>     * Don't do an additional sync on CPUs where we know
>>     * RDTSC is already synchronous:
>>     */
>> //    alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
>> //              "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
>>    rdtscll(ret);
>>     
>
> The patch below should resolve this - could you please test and Ack it? 
>   
It works, actually I already commented it out.

Acked-by: Dor Laor <dor.laor@qumranet.com>

But this CPUID was present in v2.6.23 too, so why did it only show up in
> 2.6.24-rc for you?
>
>   
I tried to figure out but all the code movements for i386 go in the way.
In the previous email I reported to Andi that Fedora kernel 2.6.23-8 did 
not suffer from it.
Thanks for the ultra fast reply :)
Dor
> 	Ingo
>
> -------------->
> Subject: x86: fix get_cycles_sync() overhead
> From: Ingo Molnar <mingo@elte.hu>
>
> get_cycles_sync() is causing massive overhead in KVM networking:
>
>    http://lkml.org/lkml/2007/12/11/54
>
> remove the explicit CPUID serialization - it causes VM exits and is
> pointless: we care about GTOD coherency but that goes to user-space
> via a syscall, and syscalls are serialization points anyway.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/asm-x86/tsc.h |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> Index: linux-x86.q/include/asm-x86/tsc.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/tsc.h
> +++ linux-x86.q/include/asm-x86/tsc.h
> @@ -39,8 +39,8 @@ static __always_inline cycles_t get_cycl
>  	unsigned eax, edx;
>  
>  	/*
> -  	 * Use RDTSCP if possible; it is guaranteed to be synchronous
> - 	 * and doesn't cause a VMEXIT on Hypervisors
> +	 * Use RDTSCP if possible; it is guaranteed to be synchronous
> +	 * and doesn't cause a VMEXIT on Hypervisors
>  	 */
>  	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
>  		       ASM_OUTPUT2("=a" (eax), "=d" (edx)),
> @@ -50,11 +50,11 @@ static __always_inline cycles_t get_cycl
>  		return ret;
>  
>  	/*
> -	 * Don't do an additional sync on CPUs where we know
> -	 * RDTSC is already synchronous:
> +	 * Use RDTSC on other CPUs. This might not be fully synchronous,
> +	 * but it's not a problem: the only coherency we care about is
> +	 * the GTOD output to user-space, and syscalls are synchronization
> +	 * points anyway:
>  	 */
> -	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
> -			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
>  	rdtscll(ret);
>  
>  	return ret;
>
>   

