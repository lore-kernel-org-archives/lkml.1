Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZHNDQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZHNDQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 23:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZHNDQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 23:16:42 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:29624 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbZHNDQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 23:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tek4e61o8Pu2E9TnFSdewLq4mUeqc3P0EBEM7QCpEf+u7BT/9joSEIO2fHiC1xf76U
         MXyJ5GK/YuOhkoYZgZ1MsB+LGIAKvYZLMjAnKm85KSfHdYIECBqXpTPVeM5JoTyiRJqg
         UnkZY/IWkx3+lfxGTIKFkP8qvxq/br9Znqp/M=
MIME-Version: 1.0
In-Reply-To: <20090813.124838.210334778.davem@davemloft.net>
References: <505766fa0908111853y7030399ewb07d4cec6829fd16@mail.gmail.com>
	 <20090813.124838.210334778.davem@davemloft.net>
Date: Fri, 14 Aug 2009 11:16:41 +0800
Message-ID: <505766fa0908132016v1e705525r92e42c142897bc82@mail.gmail.com>
Subject: Re: Sparc miss chance to fix recoverable fault in copy_from_user
From: hyl <heyongli@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/14 David Miller <davem@davemloft.net>:
> From: hyl <heyongli@gmail.com>
> Date: Wed, 12 Aug 2009 09:53:01 +0800
>
> Please post all Sparc patches and questions CC:'d to
> sparclinux@vger.kernel.org otherwise no Sparc experts are going to see
thank you.
> it.
>
>> --- a/arch/sparc/kernel/sun4v_tlb_miss.S
>> +++ b/arch/sparc/kernel/sun4v_tlb_miss.S
>> @@ -124,7 +124,7 @@ sun4v_dtlb_load:
>>       mov     %g3, %o2                ! PTE
>>       mov     HV_MMU_DMMU, %o3        ! flags
>>       ta      HV_MMU_MAP_ADDR_TRAP
>> -     brnz,pn %o0, sun4v_dtlb_error
>> +     brnz,pn %o0, sun4v_dtlb_prot
>>        mov    %g2, %o1                ! restore %o1
>>       mov     %g1, %o0                ! restore %o0
>>       mov     %g5, %o2                ! restore %o2
>>
>>
>>
>> am i miss understanding the merged sparc/spar64?
>>
>> this problem found on sparc64, via a simple module just access address 0
>> via copy_from_user. another simple test is kgdb, issue a cmd:
>> x 0
>
> That condition should never trigger, the problem is caused
> elsewhere.
>
> If the HV_MMU_MAP_ADDR_TRAP hypervisor call gives an error it means:
>
> 1) The PTE passed in is invalid
>
> 2) The PTE passed in translates to addresses outside of the
>   range accessible to the guest

the problem seem due to this reason. the test step and trigger flow is:

1. connect the kgdb  (or simple modules just copy_from_user with
address 0xffff fff0)
    kddb  "x 0xfffffff0" command processed by probe_kernel_read() ->
__copy_from_user_inatomic.
2. then a tlb miss triggered
3. then cpu go to entry: sun4v_dtlb_miss ( should be)
4.  --> sun4v_dtlb_load  (very sure, verified)
5.  --->halt in  sun4v_dtlb_error  (very sure, ) emit message in
console is: (access the address 0xffff fff0 )
    SUN4V-DTLB: Error at TPC[5f2cc8], tl 1
    SUN4V-DTLB: TPC<memcpy_user_stub+0x8/0x40>
    SUN4V-DTLB: O7[4af23c]
    SUN4V-DTLB: O7<probe_kernel_read+0x3c/0xa0>
    SUN4V-DTLB: vaddr[ffffffffffffe000] ctx[0] pte[800007ffffffe743] error[2]


the problem is :
this DTLB fault can be fixed by search extable, by fall to the
do_sparc64_fault, my draft proposal can verify this:  with this patch, this kind
of fault is recovery, so enable copy_from_user  return error instead of halt.

in addition, it is triggered in kernel space, search the extable is mandatory .

fix me
Pauli He

>
> 3) The virtual address is invalid
>
> And the kernel should never have such an illegal address or
> PTE mapping here.
>
> You need to figure out how the bad mapping gets into the kernel page
> tables and/or translations in the first place.
>
