Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbZKYPxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbZKYPxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZKYPxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:53:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52974 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZKYPxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:53:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PdaIfxJo7JI9fGh/gE3PJv2iZRQxcYJzEKZUb0+uzOeEQnprdInUrc92mHtd2egHu2
         /djw6p6UZN9O1MMp6rID0ASdlyOelOQZiXVNbq6lOyVyIV196zme6BIFzM608SxCMpf8
         H3iFh1oeIU92NhYWnOnlDhw+uS1WTkIYfTqaI=
MIME-Version: 1.0
In-Reply-To: <4B0CF2D0.90600@klingt.org>
References: <4B0BBB93.3080307@klingt.org>
	 <tip-a3a1de0c34de6f5f8332cd6151c46af7813c0fcb@git.kernel.org>
	 <73c1f2160911240928j69cbf65dx4a2747a06c7ca43d@mail.gmail.com>
	 <4B0CF2D0.90600@klingt.org>
Date: Wed, 25 Nov 2009 10:53:56 -0500
Message-ID: <73c1f2160911250753q6c64791exabd79e994b315076@mail.gmail.com>
Subject: Re: [tip:sched/core] sched, x86: Optimize branch hint in 
	__switch_to()
From: Brian Gerst <brgerst@gmail.com>
To: Tim Blechmann <tim@klingt.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 4:03 AM, Tim Blechmann <tim@klingt.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 11/24/2009 06:28 PM, Brian Gerst wrote:
>> On Tue, Nov 24, 2009 at 11:57 AM, tip-bot for Tim Blechmann
>> <tim@klingt.org> wrote:
>>> Commit-ID:  a3a1de0c34de6f5f8332cd6151c46af7813c0fcb
>>> Gitweb:     http://git.kernel.org/tip/a3a1de0c34de6f5f8332cd6151c46af7813c0fcb
>>> Author:     Tim Blechmann <tim@klingt.org>
>>> AuthorDate: Tue, 24 Nov 2009 11:55:15 +0100
>>> Committer:  Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Tue, 24 Nov 2009 12:20:04 +0100
>>>
>>> sched, x86: Optimize branch hint in __switch_to()
>>>
>>> Branch hint profiling on my nehalem machine showed 96%
>>> incorrect branch hints:
>>>
>>>  6548732 174664120  96 __switch_to                    process_64.c
>>>    406
>>>  6548745 174565593  96 __switch_to                    process_64.c
>>>    410
>>>
>>> Signed-off-by: Tim Blechmann <tim@klingt.org>
>>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> Cc: Mike Galbraith <efault@gmx.de>
>>> Cc: Paul Mackerras <paulus@samba.org>
>>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>> LKML-Reference: <4B0BBB93.3080307@klingt.org>
>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>> ---
>>>  arch/x86/kernel/process_64.c |    5 ++---
>>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
>>> index ad535b6..d9db104 100644
>>> --- a/arch/x86/kernel/process_64.c
>>> +++ b/arch/x86/kernel/process_64.c
>>> @@ -406,11 +406,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
>>>         * This won't pick up thread selector changes, but I guess that is ok.
>>>         */
>>>        savesegment(es, prev->es);
>>> -       if (unlikely(next->es | prev->es))
>>> +       if (next->es | prev->es)
>>>                loadsegment(es, next->es);
>>> -
>>>        savesegment(ds, prev->ds);
>>> -       if (unlikely(next->ds | prev->ds))
>>> +       if (next->ds | prev->ds)
>>>                loadsegment(ds, next->ds);
>>>
>>>
>>
>> 64-bit tasks should have %ds and %es set to null selectors.  The only
>> time they should be different is for 32-bit tasks.
>
> this doesn't seem to be the case on my machine for 96% of the calls ...
> i am just running 64bit binaries on this machine, no 32bit programs
> (that i know of (ubuntu karmic amd64))
>
> tim

Some early kernel threads inherited KERNEL_DS from the boot process.
Patch coming soon.

--
Brian Gerst
