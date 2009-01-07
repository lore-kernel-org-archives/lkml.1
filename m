Return-Path: <linux-kernel-owner+w=401wt.eu-S1760674AbZAGTKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbZAGTKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZAGTKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:10:24 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:23032 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZAGTKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:10:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TyYP7IrvRl6n41v2UU9mHl5LQMPcr95QPbqXx4SJXtKUqskvPlLU8rL+d8oI/DaR8V
         xOa59ydzP6+mYcqSXdd7xEvtlZH6TsMp0LNVtZLF8IrgENZOgBTm1ph9Nw+KzOjRcv8b
         wO3bOZOXrs8ZaH9EK1rC573VROPVNWhGlDbw4=
Message-ID: <f19298770901071110vad914c1w364b5973b35c4c16@mail.gmail.com>
Date: Wed, 7 Jan 2009 22:10:18 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: linux-next: Tree for December 11
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20090107184721.GA16193@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211200459.14d18d7a.sfr@canb.auug.org.au>
	 <f19298770812110440s7e3781eex4a16b961ad6847b2@mail.gmail.com>
	 <f19298770812140634j434bf6a6gd883688f00dac45e@mail.gmail.com>
	 <f19298770901070830q71cc7604nf55e1d5b70a22f37@mail.gmail.com>
	 <alpine.LFD.2.00.0901070840240.3057@localhost.localdomain>
	 <20090107171730.GA21799@elte.hu>
	 <f19298770901070935u6396a367j86937c9394518877@mail.gmail.com>
	 <20090107184721.GA16193@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 21:47, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>
>> And last time I bisected, it pointed to:
>>
>> commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
>> Author: Nick Piggin <nickpiggin@yahoo.com.au>
>> Date:   Tue Sep 30 20:50:27 2008 +1000
>>
>>    sched: improve preempt debugging
>>
>>
>>    This patch helped me out with a problem I recently had....
>>
>>    Basically, when the kernel lock is held, then preempt_count
>> underflow does not
>>    get detected until it is released which may be a long time (and arbitrarily,
>>    eg at different points it may be rescheduled). If the bkl is released at
>>    schedule, the resulting output is actually fairly cryptic...
>>
>>    With any other lock that elevates preempt_count, it is illegal to schedule
>>    under it (which would get found pretty quickly). bkl allows scheduling with
>>    preempt_count elevated, which makes underflows hard to debug.
>>
>>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>> so at least a dumb bisection won't do here.
>
> ah, sorry for being a slow starter, i missed that bit - merge window
> attention span troubles ...
>
> I think the kernel_locked() check added here is plain buggy against IRQ
> contexts: we drop the BKL spinlock and reduce current->kernel_depth
> non-atomically.
>
> So kernel_locked() can become detached from the preempt_count().
>
> Nick, can you think of any better way of still saving this debug check, or
> should we revert it?
>
> Although it seems a bit weird how consistently you seem to be able to
> trigger it - as this seems to be a narrow race. Is there an IRQ storm
> there perhaps, or something widens things up for Qemu to inject an IRQ
> right there?

I'm not sure about the qemu case, but at least on my laptop it happens
somewhere along

arch/x86/kernel/cpu/bugs.c:
 92         printk(KERN_INFO "Checking 'hlt' instruction... ");
 93         if (!boot_cpu_data.hlt_works_ok) {
 94                 printk("disabled\n");
 95                 return;
 96         }
 97         halt();
 98         halt();
 99         halt();
100         halt();
101         printk("OK.\n");

where an interrupt has to come in order to get the cpu from hlt, so
there is no surprise that I'm seeing this on every single boot. ;)
