Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZFGRZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZFGRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 13:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZFGRZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 13:25:18 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41302 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZFGRZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 13:25:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kinT1Xy5+HPMO/ZXspIzpUkfTOAUH7fcZcLWI8z8aQm7cES0Qcpu9MJkjGhcMMLo3n
         jHnKArGlvT3IsGHkn7sG7KyaOWQzIjWWaBQ9rvRAdscyudpneJioktixU5ScHs6hJCt+
         ME88UfuoPr7No5LV5Y91xNHpUOn9WYoNQpIFE=
MIME-Version: 1.0
In-Reply-To: <20090607164520.GA20672@elte.hu>
References: <1244392012-638-1-git-send-email-vegard.nossum@gmail.com>
	 <20090607164520.GA20672@elte.hu>
Date: Sun, 7 Jun 2009 19:25:13 +0200
Message-ID: <19f34abd0906071025g46529b30v41c70b0afc0be030@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: move hook before preempt_conditional_sti()
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/7 Ingo Molnar <mingo@elte.hu>:
>
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
>> There are actually two problems here:
>>
>> 1. We absolutely cannot enable IRQs in case the fault was caused by
>>    kmemcheck.
>>
>> 2. We cannot enable preemption and then return from the debug handler
>>    without disabling preemption afterwards.
>>
>> The problem seems to be a merge fallout between three commits:
>>
>> commit 3d2a71a596bd9c761c8487a2178e95f8a61da083
>> Author: Alexander van Heukelum <heukelum@fastmail.fm>
>> Date:   Tue Sep 30 18:41:37 2008 +0200
>>
>>     x86, traps: converge do_debug handlers
>>
>> commit 08d68323d1f0c34452e614263b212ca556dae47f
>> Author: K.Prasad <prasad@linux.vnet.ibm.com>
>> Date:   Mon Jun 1 23:44:08 2009 +0530
>>
>>     hw-breakpoints: modifying generic debug exception to use thread-specific deb
>>
>> commit 787ecfaa503dc63ff1831ddc74b15dad49bace1d
>> Author: Vegard Nossum <vegard.nossum@gmail.com>
>> Date:   Fri Apr 4 00:53:23 2008 +0200
>>
>>     x86: add hooks for kmemcheck
>>
>> I encourage the kprobe developers to check whether their code is correct
>> as it stands in current tip/master. Also, comments on this particular
>> change is welcome.
>>
>> Reported-by: Ingo Molnar <mingo@elte.hu>
>> Cc: Alexander van Heukelum <heukelum@fastmail.fm>
>> Cc: K.Prasad <prasad@linux.vnet.ibm.com>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
>> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
>> ---
>>  arch/x86/kernel/traps.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>
>>
>> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
>> index c8a7f87..a898c6b 100644
>> --- a/arch/x86/kernel/traps.c
>> +++ b/arch/x86/kernel/traps.c
>> @@ -550,6 +550,10 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>>                                                       SIGTRAP) == NOTIFY_STOP)
>>               return;
>>
>> +     /* Catch kmemcheck conditions first of all! */
>> +     if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
>> +             return;
>> +
>>       /* It's safe to allow irq's after DR6 has been saved */
>>       preempt_conditional_sti(regs);
>>
>> @@ -559,10 +563,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>>               return;
>>       }
>>
>> -     /* Catch kmemcheck conditions first of all! */
>> -     if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
>> -             return;
>> -
>>       /*
>>        * Single-stepping through system calls: ignore any exceptions in
>>        * kernel space, but re-enable TF when returning to user mode.
>
> Yeah - this could solve the crash i saw. Mind sending a pull request
> too?

It did solve it, I tested it :-D

This patch was against tip/master; tip/kmemcheck does not have the
problem. I think it might have been introduced in this merge:

commit 85b9b2801e46a147330b8a0f321bc40342ff5b4c
Merge: bf8d9b3... 7387400...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jun 4 13:56:43 2009 +0200

    Merge branch 'tracing/hw-breakpoints'

    Conflicts:
        arch/x86/Kconfig
        arch/x86/kernel/traps.c
        kernel/Makefile


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
