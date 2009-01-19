Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbZASCwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbZASCwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbZASCwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:52:07 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:3124 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbZASCwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:52:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UNRNs7IRnA1xpB1qIvghocPTxoxSOwVoigsOLZ4OptvgCMEI64lk2wxAPvpJ3Xfrhd
         mHJmW/NL/uVj/vvccJeCQX24eKf44IcrEvTTmx618ca5q5S/vgP6HTEQ0ZVMunQ07GGY
         3RfGWeU+vN8+pH2968cHRHqnTKukPbrk91tX0=
MIME-Version: 1.0
In-Reply-To: <4973E30D.3030102@kernel.org>
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
	 <1232326345-3534-1-git-send-email-brgerst@gmail.com>
	 <1232326345-3534-2-git-send-email-brgerst@gmail.com>
	 <1232326345-3534-3-git-send-email-brgerst@gmail.com>
	 <1232326345-3534-4-git-send-email-brgerst@gmail.com>
	 <4973E30D.3030102@kernel.org>
Date: Sun, 18 Jan 2009 21:52:05 -0500
Message-ID: <73c1f2160901181852q1c063011lf9d4588ce9a19dd1@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86-64: Remove the PDA
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 9:18 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Brian.
>
> Brian Gerst wrote:
> ...
>> @@ -881,13 +881,9 @@ __setup("clearcpuid=", setup_disablecpuid);
>>  #ifdef CONFIG_X86_64
>>  struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
>>
>> -DEFINE_PER_CPU_PAGE_ALIGNED(char[IRQ_STACK_SIZE], irq_stack);
>> -#ifdef CONFIG_SMP
>> -DEFINE_PER_CPU(char *, irq_stack_ptr);       /* will be set during per cpu init */
>> -#else
>> +DEFINE_PER_CPU_FIRST(union irq_stack_union, irq_stack_union) __aligned(PAGE_SIZE);
>>  DEFINE_PER_CPU(char *, irq_stack_ptr) =
>> -     per_cpu_var(irq_stack) + IRQ_STACK_SIZE - 64;
>> -#endif
>> +     per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
>>
>>  DEFINE_PER_CPU(unsigned long, kernel_stack) =
>>       (unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
>>
>> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
>> index 98ea26a..8c83de6 100644
>> --- a/arch/x86/kernel/head_64.S
>> +++ b/arch/x86/kernel/head_64.S
>> @@ -216,6 +216,7 @@ ENTRY(secondary_startup_64)
>>       cmpl    $0, per_cpu__cpu_number(%rax)
>>       jne     1f
>>       addq    %rax, early_gdt_descr_base(%rip)
>> +     addq    %rax, per_cpu__irq_stack_ptr(%rax)
>>  1:
>>  #endif
>>       /*
>
> As discussed before, the above chunks do drop one #ifdef CONFIG_SMP
> but it does add a obscure relocation and please note that it's
> different from early_gdt_descr.  early_gdt_descr is needed to bring up
> the cpu so there's no other way to do it but to relocate it in
> assembly.  If you absolutely have to relocate irq_stack_ptr early,
> please do it in C code in head64.c but then again irq_stack_ptr is not
> even necessary till traps_init() which is way after per cpu area
> setup.  So, the above two chunks are not necessary && even if they go
> in, they don't have much to do with this patch.

I'll give you that this particular variable doesn't need early
adjustment currently.  I'd prefer if you left the ifdef off the first
hunk, though.  A comment will suffice to document that the initial
value is going to be overwritten later on SMP.

--
Brian Gerst
