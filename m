Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbZA0MfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbZA0MfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 07:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZA0MfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 07:35:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:38818 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZA0MfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 07:35:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bgbrlHivXisRbaNJt9LKMWk02Y5Yu15BcgeHadc5DxtL1zXcAs4PRRA1BmKeDxREyf
         PIJ8cVL/wKSByuKrCIh63NWnEB7GeheHUTe8yw3Jl8u5HJYROiCGHqxGPKK5tvpL/qxg
         zu4sdnDiV3bEmKG4eCyHv32xJSaB2HGu9q7cM=
MIME-Version: 1.0
In-Reply-To: <497EB698.30509@goop.org>
References: <497E5F76.10301@goop.org>
	 <73c1f2160901262157g3d281e62nb3ebafe01ab1dfe4@mail.gmail.com>
	 <497EB698.30509@goop.org>
Date: Tue, 27 Jan 2009 07:35:02 -0500
Message-ID: <73c1f2160901270435t5623b0d8tbf832b1f8a575b2e@mail.gmail.com>
Subject: Re: unified percpu stuff
From: Brian Gerst <brgerst@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 2:24 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Brian Gerst wrote:
>>
>> On Mon, Jan 26, 2009 at 8:12 PM, Jeremy Fitzhardinge <jeremy@goop.org>
>> wrote:
>>
>>>
>>> I'm really pleased to see the unified percpu stuff in the kernel, but
>>> unfortunately its breaking Xen at the moment.
>>> It looks like this is just a matter of initializing %gs properly in
>>> xen_start_kernel.  Is there any problem with me doing a load_gs_base(0)
>>> somewhere early in xen_start_kernel (arch/x86/xen/enlighten.c)?
>>>
>>
>> Some of the changes I did made the assumption that the percpu state is
>> set up early in head_xx.S, which apparently is skipped for xen.  Is
>> there documentation anywhere for the xen bootstrap process?
>>
>
> Not really.  Its quite different from native because the guest kernel starts
> up in protected/long mode with paging enabled, using a Xen-provided
> pagetable.  It means that most of the normal head.S stuff is redundant; the
> kernel starts executing more or less exactly at xen_start_kernel (there's a
> 2 instruction asm part which stashes away the Xen info pointer from %[re]si,
> then jumps to xen_start_kernel).
>
>> Try this patch (untested):
>>
>> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>> index bef941f..b90d061 100644
>> --- a/arch/x86/xen/enlighten.c
>> +++ b/arch/x86/xen/enlighten.c
>> @@ -1647,6 +1647,8 @@ asmlinkage void __init xen_start_kernel(void)
>>        have_vcpu_info_placement = 0;
>>  #endif
>>
>> +       switch_to_new_gdt();
>> +
>>        xen_smp_init();
>>
>>        /* Get mfn list */
>> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
>> index 7735e3d..00d9265 100644
>> --- a/arch/x86/xen/smp.c
>> +++ b/arch/x86/xen/smp.c
>> @@ -235,6 +235,8 @@ cpu_initialize_context(unsigned int cpu, struct
>> task_struct *idle)
>>        ctxt->user_regs.ss = __KERNEL_DS;
>>  #ifdef CONFIG_X86_32
>>        ctxt->user_regs.fs = __KERNEL_PERCPU;
>> +#else
>> +       ctxt->gs_base_kernel = per_cpu_offset(cpu);
>>  #endif
>>        ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
>>        ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
>>
>
> Thanks, I'll try this out.
>
> BTW, does the initial cpu0 percpu area get reallocated and moved during
> boot, or does cpu0 keep using the same memory forever?

It is reallocated in setup_per_cpu_areas().

--
Brian Gerst
