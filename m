Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab0BKXy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:54:27 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:36441 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab0BKXyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:54:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=T1mS4cXJM97/m7UOK3a4VveBVIMbqCF83+vzrEOZckQlNqHkKZeFtksxbqHisudypO
         y8pPusEttRWbeJ204rxOxXpGqDxjuaStwYdwC0A2VNSNK+ICIhFEM94Sp/W3GY+OB2XK
         s+7kQL778d2bz7DWQGtNsqZAyyXx/XhyVabaI=
MIME-Version: 1.0
In-Reply-To: <20100211204653.34BB3900@magilla.sf.frob.com>
References: <20100202185907.GE3630@lst.de> <1265881389-26925-2-git-send-email-vapier@gentoo.org> 
	<20100211204653.34BB3900@magilla.sf.frob.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 11 Feb 2010 18:54:04 -0500
Message-ID: <8bd0f97a1002111554ib69bd48rc3c5f4af65058281@mail.gmail.com>
Subject: Re: [PATCH 1/2] Blackfin: initial tracehook support
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, oleg@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 15:46, Roland McGrath wrote:
>>  config BLACKFIN
>>       def_bool y
>>       select HAVE_ARCH_KGDB
>> +     select HAVE_ARCH_TRACEHOOK
>
> Don't define this until you have all its constituents as listed in the
> arch/Kconfig comment.  I don't see user_regset support.

where is user_regset actually used ?  i only see it in fs/binfmt_elf.c
and core dumps, neither of which work on nommu systems (or at least on
Blackfin systems).

>> +static inline void
>> +syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
>> +                      unsigned int i, unsigned int n, unsigned long *args)
>> +{
>> +     /* wtf is "i" ? */
>> +     BUG_ON(i);
>
> i is the starting number.  args[0] gets the i'th argument,
> args[n - 1] gets the i+n-1'th argument.

i dont see anyone calling syscall_get_arguments() with i!=0, and a few
other arches are doing the BUG_ON(i) thing too.

but should be easy to implement this with memory walking code ...

>> +asmlinkage void syscall_trace_leave(struct pt_regs *regs)
>> +{
>> +     if (test_thread_flag(TIF_SYSCALL_TRACE))
>> +             tracehook_report_syscall_exit(regs, 0);
>>  }
>
> Is it in fact true that single-step reports still come normally after a
> syscall instruction?

this is unchanged from the previous Blackfin behavior, and it's how
most arches behaved in 2.6.32.  but looking in latest mainline, it
seems people are changing to:
if (test_thread_flag(TIF_SINGLESTEP) || test_thread_flag(TIF_SYSCALL_TRACE))
    tracehook_report_syscall_exit(regs, 0);

so changing Blackfin too should be straightforward i guess

>> @@ -213,7 +213,7 @@
>>        */
>>       if (regs->syscfg & TRACE_BITS) {
>>               regs->syscfg &= ~TRACE_BITS;
>> -             ptrace_notify(SIGTRAP);
>> +             tracehook_signal_handler(sig, info, ka, regs, 1);
>>       }
>
> This call should be made unconditionally, and it should be made after the
> signal mask changes have been made (i.e. at the end of handle_signal).  I
> think it's wrong to clear the single-step flag here.  Instead, pass
> (regs->syscfg & TRACE_BITS) as the last argument.
>
> With ptrace, it makes no difference one way or the other because it will
> always either explicitly clear or explicitly set single-step before it
> resumes.  But in future, it will matter.

sounds like this issue is unrelated to tracehook and how we've been
doing signal/ptrace stuff has always been a little broken ...

i'll move it to how most arches seem to do it -- in do_signal after a
successful call to handle_signal and after clearing
TIF_RESTORE_SIGMASK.

thanks for the review
-mike
