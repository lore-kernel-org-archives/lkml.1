Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZCMHiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZCMHiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZCMHiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:38:01 -0400
Received: from gw.goop.org ([64.81.55.164]:49759 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbZCMHiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:38:00 -0400
Message-ID: <49BA0D55.5050606@goop.org>
Date: Fri, 13 Mar 2009 00:37:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
References: <1236684201.3301.11.camel@localhost.localdomain>	 <20090310122806.GE5794@elte.hu>	 <1236697752.3387.2.camel@localhost.localdomain>	 <20090310152029.GN3850@elte.hu>	 <1236701373.3387.4.camel@localhost.localdomain>	 <20090310174535.GA2963@elte.hu> <1236772478.2836.12.camel@ht.satnam>	 <1236775518.2836.14.camel@ht.satnam> <20090311125049.GA1074@elte.hu>	 <20090311131321.GC1074@elte.hu> <1236779029.2836.33.camel@ht.satnam>
In-Reply-To: <1236779029.2836.33.camel@ht.satnam>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Wed, 2009-03-11 at 14:13 +0100, Ingo Molnar wrote:
>   
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>     
>>> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
>>>
>>>       
>>>> @@ -472,7 +473,7 @@ static void print_dt(void *seq)
>>>>  	print_desc_ptr("GDT", seq, dt);
>>>>  
>>>>  	/* LDT */
>>>> -	store_ldt(ldt);
>>>> +	asm volatile("sldt %0" : "=m" (ldt));
>>>>         
>>> this is still wrong.
>>>       
>> As i pointed it out before, we should not open-code an assembly 
>> primitive - especially since store_ldt() is available in 
>> arch/x86/include/asm/desc.h.
>>
>> True, that primitive is not available on CONFIG_PARAVIRT, but 
>> that is a bug: the fix is to move the store_ldt() definition 
>> outside the CONFIG_PARAVIRT section in desc.h, not to hack 
>> around the problem by open-coding assembly code.
>>
>> I.e. dont let an uncleanliness and incomplete primitive spread 
>> to other code. Fix the primitive and remove the uncleanliness 
>> that way.
>>
>>     
>
> The following changes since commit 259ef6fcea4046fe24495b1e3631c1b905c531c1:
>   Jaswinder Singh Rajput (1):
>         x86: cpu architecture debug code
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
>
> Jaswinder Singh Rajput (2):
>       x86: cpu_debug.c cleanup
>       x86: move store_ldt outside the CONFIG_PARAVIRT section
>
>  arch/x86/include/asm/desc.h     |    3 ++-
>  arch/x86/kernel/cpu/cpu_debug.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> Complete diff:
> diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
> index dc27705..ceb17cc 100644
> --- a/arch/x86/include/asm/desc.h
> +++ b/arch/x86/include/asm/desc.h
> @@ -91,7 +91,6 @@ static inline int desc_empty(const void *ptr)
>  #define store_gdt(dtr) native_store_gdt(dtr)
>  #define store_idt(dtr) native_store_idt(dtr)
>  #define store_tr(tr) (tr = native_store_tr())
> -#define store_ldt(ldt) asm("sldt %0":"=m" (ldt))
>  
>  #define load_TLS(t, cpu) native_load_tls(t, cpu)
>  #define set_ldt native_set_ldt
> @@ -112,6 +111,8 @@ static inline void paravirt_free_ldt(struct desc_struct *ldt, unsigned entries)
>  }
>  #endif	/* CONFIG_PARAVIRT */
>  
> +#define store_ldt(ldt) asm("sldt %0":"=m" (ldt))
> +
>  static inline void native_write_idt_entry(gate_desc *idt, int entry,
>  					  const gate_desc *gate)
>  {
> diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
> index 0bdf4da..9abbcbd 100755
> --- a/arch/x86/kernel/cpu/cpu_debug.c
> +++ b/arch/x86/kernel/cpu/cpu_debug.c
> @@ -23,6 +23,7 @@
>  #include <linux/smp.h>
>  
>  #include <asm/cpu_debug.h>
> +#include <asm/paravirt.h>
>   
This shouldn't be necessary.  asm/desc.h should pull it in if it needs it.

    J
