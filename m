Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbYI1E6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbYI1E6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 00:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYI1E6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 00:58:41 -0400
Received: from gw.goop.org ([64.81.55.164]:41823 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYI1E6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 00:58:41 -0400
Message-ID: <48DF0EFA.1010904@goop.org>
Date: Sat, 27 Sep 2008 21:58:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: Should irq_chip->mask disable percpu interrupts to all cpus,
 or just to this cpu?
References: <48D94B64.3070004@goop.org> <20080924084558.GD5576@elte.hu> <m18wthna2f.fsf@frodo.ebiederm.org> <48DA8806.4060405@goop.org> <m1d4itl4ni.fsf@frodo.ebiederm.org> <20080927194424.GG18619@elte.hu>
In-Reply-To: <20080927194424.GG18619@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>   
>> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>>
>>     
>>> I found handle_percpu_irq() which addresses my concerns.  It doesn't
>>> attempt to mask the interrupt, takes no locks, and doesn't set or test
>>> IRQ_INPROGRESS in desc->status, so it will scale perfectly across
>>> multiple cpus.  It makes no changes to the desc structure, so there
>>> isn't even any cacheline bouncing.
>>>       
>> kstat_irqs.  Is arguably part of the irq structure.
>> And kstat_irqs is a major pain in my book.
>>
>> And for a rare event you have a cacheline read.
>> I don't think we are quite there yet but we really want to allocate
>> irq_desc on the right NUMA node in a multi socket system, to reduce
>> the cache miss times.
>>     
>
> note that we already do _almost_ that in tip/irq/sparseirq. dyn_array[] 
> will extend itself in a NUMA-aware fashion. (normal device irq_desc 
> entries will be allocated via kmalloc)
>
> what would be needed is to deallocate/reallocate irq_desc when the IRQ 
> affinity is changed? (i.e. when a device is migrated to a specific NUMA 
> node)
>
>   
>> Is it a big deal?  Probably not.  But I think it would be a bad idea 
>> to increasingly use infrastructure that will make it hard to optimize 
>> the code.
>>
>> Especially since the common case in high performance drivers is going 
>> to be, individually routable irq sources.  Having one queue per cpu 
>> and one irq per queue.  Which sounds like the same case you have.
>>     
>
> agreed - the kstat_irqs cacheline bounce would show up in Xen benchmarks 
> i'm sure.
>   

I've put that approach aside anyway, since I couldn't get it to work
after a day of fiddling and I didn't want to waste too much time on it. 
I've just restricted myself to avoiding the normal interrupt delivery
path, and going direct from event channel to irq to desc->handler.

    J
