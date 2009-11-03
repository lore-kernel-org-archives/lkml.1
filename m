Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZKCSjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZKCSjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZKCSjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:39:41 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:52445 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZKCSjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:39:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SJNae5UeMR/nRiBoV1mCfTUS5+7Rq9cVytZThejGXH/INMaNUi4XRbK2VpLXdi34JD
         1DKSXS9Yd15hw8dlPRhpM3IPjvf3uP9znwtJgpBhBvtDylD4blThyVIxYFOHht5MN46T
         4VTaDrhLWGG+Mr/nx2HChsan560ic8OdgNbGA=
MIME-Version: 1.0
In-Reply-To: <20091103181014.GA19715@elte.hu>
References: <1257270936-5496-1-git-send-email-brgerst@gmail.com>
	 <20091103181014.GA19715@elte.hu>
Date: Tue, 3 Nov 2009 13:39:43 -0500
Message-ID: <73c1f2160911031039r418735fdkdde97c8351b1c61a@mail.gmail.com>
Subject: Re: [PATCH] x86, 64-bit: Move K8 B step iret fixup to fault entry asm 
	(v2)
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 1:10 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Brian Gerst <brgerst@gmail.com> wrote:
>
>> Move the handling of truncated %rip from an iret fault to the fault
>> entry path.
>>
>> This allows x86-64 to use the standard search_extable() function.
>>
>> v2: Fixed jump to error_swapgs to be unconditional.
>
> v1 is already in the tip:x86/asm topic tree. Mind sending a delta fix
> against:

Will do.

>  http://people.redhat.com/mingo/tip.git/README
>
> ?
>
> Also, i'm having second thoughts about the change:
>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>> ---
>>  arch/x86/include/asm/uaccess.h |    1 -
>>  arch/x86/kernel/entry_64.S     |   11 ++++++++---
>>  arch/x86/mm/extable.c          |   31 -------------------------------
>>  3 files changed, 8 insertions(+), 35 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
>> index d2c6c93..abd3e0e 100644
>> --- a/arch/x86/include/asm/uaccess.h
>> +++ b/arch/x86/include/asm/uaccess.h
>> @@ -570,7 +570,6 @@ extern struct movsl_mask {
>>  #ifdef CONFIG_X86_32
>>  # include "uaccess_32.h"
>>  #else
>> -# define ARCH_HAS_SEARCH_EXTABLE
>>  # include "uaccess_64.h"
>>  #endif
>>
>> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> index b5c061f..1579a6c 100644
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -1491,12 +1491,17 @@ error_kernelspace:
>>       leaq irq_return(%rip),%rcx
>>       cmpq %rcx,RIP+8(%rsp)
>>       je error_swapgs
>> -     movl %ecx,%ecx  /* zero extend */
>> -     cmpq %rcx,RIP+8(%rsp)
>> -     je error_swapgs
>> +     movl %ecx,%eax  /* zero extend */
>> +     cmpq %rax,RIP+8(%rsp)
>> +     je bstep_iret
>>       cmpq $gs_change,RIP+8(%rsp)
>>       je error_swapgs
>>       jmp error_sti
>> +
>> +bstep_iret:
>> +     /* Fix truncated RIP */
>> +     movq %rcx,RIP+8(%rsp)
>> +     jmp error_swapgs
>>  END(error_entry)
>>
>>
>> diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
>> index 61b41ca..d0474ad 100644
>> --- a/arch/x86/mm/extable.c
>> +++ b/arch/x86/mm/extable.c
>> @@ -35,34 +35,3 @@ int fixup_exception(struct pt_regs *regs)
>>
>>       return 0;
>>  }
>> -
>> -#ifdef CONFIG_X86_64
>> -/*
>> - * Need to defined our own search_extable on X86_64 to work around
>> - * a B stepping K8 bug.
>> - */
>> -const struct exception_table_entry *
>> -search_extable(const struct exception_table_entry *first,
>> -            const struct exception_table_entry *last,
>> -            unsigned long value)
>> -{
>> -     /* B stepping K8 bug */
>> -     if ((value >> 32) == 0)
>> -             value |= 0xffffffffUL << 32;
>> -
>> -     while (first <= last) {
>> -             const struct exception_table_entry *mid;
>> -             long diff;
>> -
>> -             mid = (last - first) / 2 + first;
>> -             diff = mid->insn - value;
>> -             if (diff == 0)
>> -                     return mid;
>> -             else if (diff < 0)
>> -                     first = mid+1;
>> -             else
>> -                     last = mid-1;
>> -     }
>> -     return NULL;
>> -}
>> -#endif
>
> is this the only way how we can end up having a truncated 64-bit RIP
> passed in to search_exception_tables()/search_extable()? Before your
> commit we basically had a last-ditch safety net in 64-bit kernels that
> zero-extended truncated RIPs - no matter how they got there (via known
> or unknown erratums).

That kind of erratum would logically only happen on a transition to
32-bit mode (or even 16-bit mode?), and the only other place this
could happen is the sysret or sysexit paths, neither of which have
exception handlers.  If it were happening in those places, you would
see the truncated RIP in oops reports, since the original (truncated)
RIP in pt_regs doesn't get changed by the current code.

--
Brian Gerst
