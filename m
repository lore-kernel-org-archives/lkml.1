Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYAGXNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYAGXNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYAGXNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:13:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:54443 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbYAGXNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:13:35 -0500
Date: Tue, 8 Jan 2008 00:13:33 +0100
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 1 of 8] x86: page.h: unify constants
Message-ID: <20080107231333.GG2998@bingen.suse.de>
References: <patchbomb.1199391057@localhost> <ba0ec40a50a7aef1a315.1199391058@localhost> <20080107171712.GE2998@bingen.suse.de> <4782A420.30807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4782A420.30807@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 02:13:52PM -0800, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
>>> +
>>> +#define LARGE_PAGE_SIZE		(_AC(1,UL) << PMD_SHIFT)
>>> +#define LARGE_PAGE_MASK		(~(LARGE_PAGE_SIZE-1))
>>> +
>>> +#define HPAGE_SHIFT		PMD_SHIFT
>>> +#define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
>>> +#define HPAGE_MASK		(~(HPAGE_SIZE - 1))
>>> +#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
>>>     
>>
>> This will actually stop being the same soon with GB pages which
>> are only supported on 64bit.
>>   
>
> I was wondering about that.  Will you always use GB pages, or will there be 

When available and not disabled yes.

> two classes of huge pages, or will it be a runtime/compiletime config?

hugetlbfs will use different classes of huge pages depending on configuration
(I haven't posted those patches yet, only those for the direct mapping) 
That all is expressed by different macros.

All runtime; I expect no CONFIGs involved, except that 32bit won't have
it since the architecture doesn't support it there.



>
>>> +
>>> +#ifdef CONFIG_X86_64
>>> +#define THREAD_ORDER	1
>>> +#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
>>> +#define CURRENT_MASK (~(THREAD_SIZE-1))
>>> +
>>> +#define EXCEPTION_STACK_ORDER 0
>>> +#define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
>>> +
>>> +#define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
>>> +#define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)
>>> +
>>> +#define IRQSTACK_ORDER 2
>>> +#define IRQSTACKSIZE (PAGE_SIZE << IRQSTACK_ORDER)
>>>     
>>
>> This all seems hardly 64bit specific (except for THREAD_ORDER
>> but you can probably handle that in Kconfig or just get rid
>> of it for 32bit)
>>   
>
> They're only used by 64-bit at the moment, aren't they?  Or are you 

THREAD_ORDER should be used on 32bit too.

32bit also has the equivalent of irq stacks (quite similar) 
and exception stacks (somewhat different). Currently they use
other defines, but they could use the same. Also i386 has varying
irqstack orders disabling them with 8k stacks, but that is something
that would be best dropped and irqstacks always used imho.

>>> +#define __PHYSICAL_START	CONFIG_PHYSICAL_START
>>>     
>>
>> Also not 64bit specific
>>   
>
> It's use is 64-bit specific though, isn't it?

It might be, but it's not a 64bit specific concept.

>
>>> +#ifdef CONFIG_X86_PAE
>>> +#define __PHYSICAL_MASK_SHIFT	36
>>>     
>>
>> I originally added the PHYSICAL_MASK stuff to deal with masking off NX,
>> but I must admit it wasn't the best idea I ever had. It would be probably
>> better to just get rid of it and always mask off the high reserved flags 
>> bit
>> explicitely. If you make that 0 then there should be no special
>> case for PAE.
>>   
>
> Hm, OK.  I thought different 64-bit implementations might have different 
> sized physical address spaces or something.

Yes they do, but hardcoding that doesn't make sense because it varies.
We already got CPUs with 36, 38, 40 and 48 bits phys size.

The only size that could be hard coded would be 52 bit (theoretical max), but 
that also doesn't make sense if all we want to do is to mask off NX.

The only code that needs to know the real physical size is the MTRR
code, but that one gets it from CPUID as it should.

-Andi
