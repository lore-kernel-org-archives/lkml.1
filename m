Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZBKOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZBKOeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZBKOeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:34:12 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:25301 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbZBKOeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:34:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gVKe3eU9uo5Vy0A/F+WCCwzy48tUPcpRfHBy3M1g1MjnVwX9vVpMxvevdXPDsFUuqk
         HeZUrn1kHB95XKH8OuKuOROMLTmtcf7UfLioY2k1mJVyw8EoYsvmBmvpHNXuAbyagGvA
         VRyDkZjCN/8e8OmysfVJiKhKU0jpWEK3OiaeU=
MIME-Version: 1.0
In-Reply-To: <499281B5.2070502@kernel.org>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
	 <1234277507-4987-2-git-send-email-brgerst@gmail.com>
	 <499281B5.2070502@kernel.org>
Date: Wed, 11 Feb 2009 09:34:09 -0500
Message-ID: <73c1f2160902110634m779e16f6he9620a7c6c021d12@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86: Use pt_regs pointer in do_device_not_available()
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 2:43 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Brian.
>
> Brian Gerst wrote:
>> The generic exception handler (error_code) passes in the pt_regs
>> pointer and the error code (unused in this case).  The commit
>> "x86: fix math_emu register frame access" changed this to pass by
>> value, which doesn't work correctly with stack protector enabled.
>> Change it back to use the pt_regs pointer.
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>> ---
>>  arch/x86/include/asm/traps.h |    2 +-
>>  arch/x86/kernel/traps.c      |    9 +++++----
>>  2 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
>> index cf3bb05..0d53425 100644
>> --- a/arch/x86/include/asm/traps.h
>> +++ b/arch/x86/include/asm/traps.h
>> @@ -41,7 +41,7 @@ dotraplinkage void do_int3(struct pt_regs *, long);
>>  dotraplinkage void do_overflow(struct pt_regs *, long);
>>  dotraplinkage void do_bounds(struct pt_regs *, long);
>>  dotraplinkage void do_invalid_op(struct pt_regs *, long);
>> -dotraplinkage void do_device_not_available(struct pt_regs);
>> +dotraplinkage void do_device_not_available(struct pt_regs *, long);
>>  dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
>>  dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
>>  dotraplinkage void do_segment_not_present(struct pt_regs *, long);
>> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
>> index 3b7b2e1..71a8f87 100644
>> --- a/arch/x86/kernel/traps.c
>> +++ b/arch/x86/kernel/traps.c
>> @@ -905,19 +905,20 @@ void math_emulate(struct math_emu_info *info)
>>  }
>>  #endif /* CONFIG_MATH_EMULATION */
>>
>> -dotraplinkage void __kprobes do_device_not_available(struct pt_regs regs)
>> +dotraplinkage void __kprobes
>> +do_device_not_available(struct pt_regs *regs, long error_code)
>
> What do you think about just taking pt_regs and accessing
> regs->orig_eax instead of having separate call convention for pt_regs
> ones and trap ones?  Too much work without enough benefit?

I don't quite follow what you are trying to say here.  Are you saying
use the same calling convention for the exception handlers (anything
called from error_code) and system calls?

--
Brian Gerst
