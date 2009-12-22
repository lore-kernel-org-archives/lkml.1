Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbZLVGQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbZLVGQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 01:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZLVGQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 01:16:16 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:50649 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZLVGQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 01:16:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nKLtj4SacHw1yR4cImCGGye2/sAZWkM8rOf8vfoL8vbQexieKRhuTcUmmJb9StLBSH
         kRYrvGqAml/VKUdnjXhJckLZEmnA0SLcAeQtWt7/48tCKFrDIrAuA5KQ6xHrITV0mQEN
         EirG7LjmIA2EHS/MGWa/B1fDHLVyG6Mv8ZFnA=
MIME-Version: 1.0
In-Reply-To: <4B305680.4090304@cn.fujitsu.com>
References: <4B2F1543.8020300@cn.fujitsu.com> <20091221064356.GA2378@elte.hu>
	 <4B2F2588.8070501@cn.fujitsu.com> <1261406427.4314.155.camel@laptop>
	 <1261410984.25193.8.camel@gandalf.stny.rr.com>
	 <4B305680.4090304@cn.fujitsu.com>
Date: Tue, 22 Dec 2009 14:16:14 +0800
Message-ID: <2674af740912212216mb75ef54l5143576b8173acff@mail.gmail.com>
Subject: Re: [PATCH] tracing: Fix lockdep warning in global_clock()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: rostedt@goodmis.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
>> The problem isn't with locks, it's with disabling interrupts. Lockdep
>> keeps track of every time interrupts are disabled. If something disables
>> interrupts with raw_* but then calls something that disables interrupts
>> the normal way, lockdep will detect that interrupts are being disabled
>> but they already are disabled. The internal irq disabled variable in
>> lockdep wont match reality, and this will blow up (well, disable
>> lockdep).
>>
>> So if cpu_clock disables interrupts with local_irq_* then so must
>> trace_clock_global.
>>
>
> Looking into sched_clock.c, seems the only place that can trigger lockdep
> is the local_irq_* in cpu_clock(), though I'm not sure for architecture-
> specific sched_clock().
>
> If so, I think we can use raw_local_irq_* in cpu_clock(). Actually I
> tried it and the warning is gone.
>

I think the reason is on local_irq_restore():

#define local_irq_restore(flags)			\
	do {						\
		typecheck(unsigned long, flags);	\
		if (raw_irqs_disabled_flags(flags)) {	\
			raw_local_irq_restore(flags);	\
			trace_hardirqs_off();		\                        <======
		} else {				\
			trace_hardirqs_on();		\
			raw_local_irq_restore(flags);	\
		}					\
	} while (0)

If we have a call trace like below:
raw_local_irq_save();
            ...
local_irq_save();
            ...
local_irq_restore();
            ...
raw_locla_irq_save();

Then when we leave from local_irq_restore(), current->hardirqs_enabled will
changed by trace_hardirqs_off() to 0, this will break the all consistent.

Thanks,
Yong
