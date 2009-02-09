Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZBIIp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZBIIp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbZBIIpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:45:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:34435 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZBIIpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:45:20 -0500
Message-ID: <498FECD3.9030204@kernel.org>
Date: Mon, 09 Feb 2009 00:44:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: optimize init_kstat_irqs/init_copy_kstat_irqs
References: <498CB0B7.8030009@kernel.org> <20090206140005.44b4bb50.akpm@linux-foundation.org> <498CB4DC.2010108@kernel.org> <498D3D15.5090005@kernel.org> <20090207002610.73ff7e6d.akpm@linux-foundation.org> <86802c440902070101l5b0ef862ja92e3f31705d9608@mail.gmail.com> <20090207010619.daededa3.akpm@linux-foundation.org> <20090209081124.GB24420@elte.hu> <20090209001903.89548108.akpm@linux-foundation.org> <20090209083739.GB15517@elte.hu>
In-Reply-To: <20090209083739.GB15517@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Mon, 9 Feb 2009 09:11:24 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> * Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>>> On Sat, 7 Feb 2009 01:01:03 -0800 Yinghai Lu <yinghai@kernel.org> wrote:
>>>>
>>>>> add kzalloc_node_safe()?
>>>> I cannot find that function.
>>> His suggestion is to provide that allocator variant.
>>>
>> Oh.
>>
>> It isn't possible to write a kzalloc_node_safe(GFP_ATOMIC).  Or at
>> least, we've never worked out a way.
>>
>> Maybe I'm confused again.
> 
> Indeed - duh - more morning tea needed.
> 
> Yinghai, why are those allocations GFP_ATOMIC to begin with? These:
> 
> earth4:~/tip> grep GFP_ATOMIC kernel/irq/*.c
> kernel/irq/handle.c:	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
> kernel/irq/handle.c:	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
> kernel/irq/manage.c:	action = kmalloc(sizeof(struct irqaction), GFP_ATOMIC);
> 
> Should all be GFP_KERNEL. Wherever they are within a spinlocked section the code 
> should be restructured. All descriptor data structures should be preallocated at 
> __setup_irq() time. If we ever need to allocate dynamically later on, in the middle 
> of some difficult codepath that's a structure bug in the code.

ok.

> 
> and this one:
> 
> kernel/irq/numa_migrate.c:	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
> 
> should fail the migration silently if GFP_ATOMIC returns NULL.
it will reuse the old one.

YH
