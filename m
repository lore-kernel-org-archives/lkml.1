Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZBJB2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZBJB2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZBJB2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:28:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:41217 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbZBJB2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:28:31 -0500
Message-ID: <4990D817.7010906@kernel.org>
Date: Tue, 10 Feb 2009 10:27:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH 10/11] x86: make lazy %gs optional on x86_32
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-11-git-send-email-tj@kernel.org> <49907203.4010009@goop.org>
In-Reply-To: <49907203.4010009@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Feb 2009 01:28:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jeremy Fitzhardinge wrote:
>> * Save and restore %gs along with other registers in entry_32.S unless
>>   LAZY_GS.  Note that this unfortunately adds "pushl $0" on SAVE_ALL
>>   even when LAZY_GS.  However, it adds no overhead to common exit path
>>   and simplifies entry path with error code.
>>   
> 
> I don't think it will make a measurable difference.  "subl $4, %esp"
> might be worth using too, or "lea -4(%esp), %esp" to avoid touching the
> flags.

You mean for PUSH_GS?  It's only used as a part of SAVE_ALL so I don't
think we need to worry about eflags.  The reason why I chose push $0
was because it was the shortest.

 push $0		: 6a 00
 sub $4, %esp		: 83 ec 04
 lea -4(%esp), %esp	: 8d 64 24 fc

>> +.macro POP_GS pop=0
>> +98:    popl %gs
>> +    CFI_ADJUST_CFA_OFFSET -4
>> +    /*CFI_RESTORE gs*/
>> +  .if \pop <> 0
>> +    add $\pop, %esp
>> +    CFI_ADJUST_CFA_OFFSET -\pop
>> +  .endif
>> +.endm
>> +.macro POP_GS_EX
>> +.pushsection .fixup, "ax"
>> +99:    movl $0, (%esp)
>> +    jmp 98b
>> +.section __ex_table, "a"
>> +    .align 4
>> +    .long 98b, 99b
>> +.popsection
>>   
> 
> Why not just fold the exception block into the POP_GS macro?  I don't
> think they need to be separated (ditto other exception handlers).

I originally did that but in ia32_sysenter_target(), it seems that the
exception stuff should be after CFI_ENDPROC, so I split them.  Don't
know much about debugging info so I tried to stick with what's already
there.  Is it okay to move exception block inside CFI_ENDPROC?

>> --- a/arch/x86/xen/enlighten.c
>> +++ b/arch/x86/xen/enlighten.c
>> @@ -323,13 +323,14 @@ static void load_TLS_descriptor(struct
>> thread_struct *t,
>>  static void xen_load_tls(struct thread_struct *t, unsigned int cpu)
>>  {
>>      /*
>> -     * XXX sleazy hack: If we're being called in a lazy-cpu zone,
>> -     * it means we're in a context switch, and %gs has just been
>> -     * saved.  This means we can zero it out to prevent faults on
>> -     * exit from the hypervisor if the next process has no %gs.
>> -     * Either way, it has been saved, and the new value will get
>> -     * loaded properly.  This will go away as soon as Xen has been
>> -     * modified to not save/restore %gs for normal hypercalls.
>> +     * XXX sleazy hack: If we're being called in a lazy-cpu zone
>> +     * and lazy gs handling is enabled, it means we're in a
>> +     * context switch, and %gs has just been saved.  This means we
>> +     * can zero it out to prevent faults on exit from the
>> +     * hypervisor if the next process has no %gs.  Either way, it
>> +     * has been saved, and the new value will get loaded properly.
>> +     * This will go away as soon as Xen has been modified to not
>> +     * save/restore %gs for normal hypercalls.
>>   
> 
> No, this change isn't quite right; the "and lazy gs handling is enabled"
> qualifier is wrong, because the condition the comment describes is
> independent of whether we're doing lazy gs handling.  This would be better:
> 
>    XXX sleazy hack: If we're being called in a lazy-cpu zone, it means
>    we're in a context switch, and %gs has definitely been saved (just
>    saved if we're doing lazy gs handling, and saved on entry if not).
>    This means we can zero it out to prevent faults on exit from the
>    hypervisor if the next process has no %gs. Either way, it has been
>    saved, and the new value will get loaded properly. This will go away
>    as soon as Xen has been modified to not save/restore %gs for normal
>    hypercalls.

Hmmm... I was (lazily) trying to add that %gs can only be cleared if
it's being managed lazily because otherwise it might be being used by
the kernel for other purposes.  :-)

Is my understanding correct?

Thanks.

-- 
tejun
