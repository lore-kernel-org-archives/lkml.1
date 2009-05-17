Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZEQIIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZEQIIC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 04:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZEQIHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 04:07:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59279 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbZEQIHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 04:07:43 -0400
Message-ID: <4A0FC592.6030005@garzik.org>
Date: Sun, 17 May 2009 04:06:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Hitoshi Mitake <h.mitake@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	<20090421.173123.191021055.davem@davemloft.net>	<adak55438gp.fsf_-_@cisco.com>	<20090428.221228.217954247.davem@davemloft.net>	<20090429115654.GC11586@elte.hu>	<49F843BC.7020902@garzik.org>	<adahc071ie4.fsf@cisco.com>	<49F8B1A1.4010208@garzik.org>	<a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com>	<4A0B2B54.5090803@zytor.com>	<4A0B4C1C.9000706@garzik.org>	<4A0B5A34.1080301@zytor.com>	<4A0B6A96.2030008@garzik.org>	<20090514161903.4ba00c09.h.mitake@gmail.com>	<4A0DFE43.7050705@garzik.org> <20090517161210.4274ddf9.h.mitake@gmail.com>
In-Reply-To: <20090517161210.4274ddf9.h.mitake@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitoshi Mitake wrote:
> On Fri, 15 May 2009 19:44:03 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Hitoshi Mitake wrote:
>>> On Wed, 13 May 2009 20:49:26 -0400
>>> Jeff Garzik <jeff@garzik.org> wrote:
>>>
>>>> H. Peter Anvin wrote:
>>>>> Jeff Garzik wrote:
>>>>>> Judging from this thread and past, I think people will continue to 
>>>>>> complain and get confused, even with the above.
>>>>>>
>>>>> Do you really think so?  Seems unfortunate, since an API rename would be
>>>>> way more invasive.  This is the entirety of the header patch
>>>>> (compile-tested using 32-bit allyesconfig).
>>>> The header patch does not lessen the confusion, because you cannot look 
>>>> at the code and immediately tell what is going on...
>>>>
>>>> Having a single function's behavior change based on #include selection 
>>>> is /not/ intuitive at all, particularly for driver writers.  That is 
>>>> unlike almost every other Linux API, where functions' behavior stays 
>>>> constant across platforms, regardless of magic "under the hood."
>>>>
>>>> That sort of trick is reserved for arch maintainers who know what they 
>>>> are doing :)
>>>>
>>>> 	Jeff
>>>>
>>>>
>>>>
>>> I found another way:
>>> Making architecture with atomic readq/writeq provide HAVE_READQ_ATOMIC/HAVE_WRITEQ_ATOMIC
>>> and making architecture with non-atomic readq/writeq provide HAVE_READQ/HAVE_WRITEQ.
>>> (HAVE_READQ_ATOMIC/HAVE_WRITEQ_ATOMIC should double as HAVE_READQ/HAVE_WRITEQ.)
>>>
>>> So driver programmers who need atomic readq/writeq can judge existence of API they really need.
>>> If platform doesn't provide atomic readq/writeq, drivers need these can be disabled by Kconfig.
>>> And bugs Roland and David talking about will be banished.
>>> How about this? > Roland and David
>>> I wrote a test patch. Request for comments.
>>>
>>> Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
>>>
>>> ---
>>>  arch/x86/Kconfig |   16 ++++++++++++++--
>>>  1 files changed, 14 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index df9e885..c94fc48 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -19,8 +19,6 @@ config X86_64
>>>  config X86
>>>  	def_bool y
>>>  	select HAVE_AOUT if X86_32
>>> -	select HAVE_READQ
>>> -	select HAVE_WRITEQ
>>>  	select HAVE_UNSTABLE_SCHED_CLOCK
>>>  	select HAVE_IDE
>>>  	select HAVE_OPROFILE
>>> @@ -2022,6 +2020,20 @@ config HAVE_ATOMIC_IOMAP
>>>  	def_bool y
>>>  	depends on X86_32
>>>  
>>> +config HAVE_READQ
>>> +	def_bool y
>>> +
>>> +config HAVE_WRITEQ
>>> +	def_bool y
>>> +
>>> +config HAVE_READQ_ATOMIC
>>> +	def_bool y
>>> +	depends on X86_64
>>> +
>>> +config HAVE_WRITEQ_ATOMIC
>>> +	def_bool y
>>> +	depends on X86_64
>> If you create HAVE_{READQ,WRITEQ}_ATOMIC, then you don't really need 
>> HAVE_READQ -- the other relevant 32-bit platforms simply need a 
>> definition of readq and writeq.  Probably easy enough to have a common 
>> definition in asm-generic.
>>
> That's good idea. I didn't noticed the way to use asm-generic. Thanks.
> 
> How is this?
> 
> Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
> 
> ---
>  arch/x86/Kconfig             |   10 ++++++++--
>  arch/x86/include/asm/io.h    |   27 ++++++---------------------
>  include/asm-generic/quadrw.h |   34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 48 insertions(+), 23 deletions(-)
>  create mode 100644 include/asm-generic/quadrw.h


Seems fine to me, no objections here...



> +#ifndef CONFIG_HAVE_READQ_ATOMIC
> +static inline __u64 readq(const volatile void __iomem *addr)
> +{
> +	const volatile u32 __iomem *p = addr;
> +	u32 low, high;
> +
> +	low = readl(p);
> +	high = readl(p + 1);
> +
> +	return low + ((u64)high << 32);
> +}
> +#endif	/* CONFIG_HAVE_READQ_ATOMIC */

Personally I would do

	static inline __u64 readq(const volatile void __iomem *addr)
	{
		__u64 low, high;

		low = readl(addr);
		high = readl(addr + 4);

		return (high << 32) | low;
	}

but maybe that's just me.

It seems inconsistent that the generic readq and writeq internals, 
simple as they are, differ to such a degree in this implementation.

But overall, as mentioned above, the approach seems sound to me.

Cheers!

	Jeff


