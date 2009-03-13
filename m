Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZCMHeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZCMHeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZCMHel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:34:41 -0400
Received: from gw.goop.org ([64.81.55.164]:55953 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbZCMHek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:34:40 -0400
Message-ID: <49BA0C8C.4050302@goop.org>
Date: Fri, 13 Mar 2009 00:34:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
References: <1236684201.3301.11.camel@localhost.localdomain>	 <20090310122806.GE5794@elte.hu>	 <1236697752.3387.2.camel@localhost.localdomain>	 <20090310152029.GN3850@elte.hu>	 <1236701373.3387.4.camel@localhost.localdomain>	 <20090310174535.GA2963@elte.hu>	 <1236729310.7004.2.camel@localhost.localdomain>	 <20090311105333.GC2282@elte.hu> <1236770749.2836.10.camel@ht.satnam>
In-Reply-To: <1236770749.2836.10.camel@ht.satnam>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
>>> Complete diff:
>>> diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
>>> index 0bdf4da..08c365a 100755
>>> --- a/arch/x86/kernel/cpu/cpu_debug.c
>>> +++ b/arch/x86/kernel/cpu/cpu_debug.c
>>> @@ -464,19 +464,19 @@ static void print_dt(void *seq)
>>>  	unsigned long ldt;
>>>  
>>>  	/* IDT */
>>> -	store_idt((struct desc_ptr *)&dt);
>>> +	native_store_idt((struct desc_ptr *)&dt);
>>>       
>> hm, this wont work on Xen then.
>>
>>     
>
> Strange it should work for Xen, Are you getting any error.
>
> Xen also uses native_store_idt:
> arch/x86/xen/enlighten.c:	.store_idt = native_store_idt,
>   

store_idt (and the others) are not used very much, and never in any code 
path under Xen.  They're not really meaningful in Xen, and this code 
will probably oops if you ran it.

I guess we could do more meaningful implementations of these ops for 
Xen, now that there's a user.

>>>  	print_desc_ptr("IDT", seq, dt);
>>>  
>>>  	/* GDT */
>>> -	store_gdt((struct desc_ptr *)&dt);
>>> +	native_store_gdt((struct desc_ptr *)&dt);
>>>  	print_desc_ptr("GDT", seq, dt);
>>>  
>>>  	/* LDT */
>>> -	store_ldt(ldt);
>>> +	asm volatile("sldt %0" : "=m" (ldt));
>>>  	seq_printf(seq, " LDT\t: %016lx\n", ldt);
>>>  
>>>  	/* TR */
>>> -	store_tr(ldt);
>>> +	asm volatile("str %0" : "=r" (ldt));
>>>  	seq_printf(seq, " TR\t: %016lx\n", ldt);
>>>       
>> we do have a store_tr() primitive - why open code the assembly?
>>
>>     
>
> It is a single line code to avoid further conflicts, so i moved it here.
>   

Definitely a bad idea.

    J
