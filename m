Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZEULlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZEULlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZEULlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:41:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:47976 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZEULle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CXuMzo1+J5mL5pRPU4903JHbPnTXoWab6YpysxdvL7Y7w1qqwiJr6Xc+dx+bkHcPtO
         DVx0pJTkWQwcuCjwvEB5ZHb55BORaGHOr15DoN8DU3u9M6+LgDycIrPoCQgy9UFsLOXK
         QYu9XGhG/qv2JFzaP46BDdOxmTB8IHasKkTzI=
MIME-Version: 1.0
In-Reply-To: <4A0FC592.6030005@garzik.org>
References: <49EE37AF.4020507@zytor.com>
	 <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com>
	 <4A0B2B54.5090803@zytor.com> <4A0B4C1C.9000706@garzik.org>
	 <4A0B5A34.1080301@zytor.com> <4A0B6A96.2030008@garzik.org>
	 <20090514161903.4ba00c09.h.mitake@gmail.com>
	 <4A0DFE43.7050705@garzik.org>
	 <20090517161210.4274ddf9.h.mitake@gmail.com>
	 <4A0FC592.6030005@garzik.org>
Date: Thu, 21 May 2009 20:35:54 +0900
Message-ID: <a6b9f31a0905210435m8eea09k8a82215af16aa049@mail.gmail.com>
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org,
       mitake@dcl.info.waseda.ac.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 17:06, Jeff Garzik <jeff@garzik.org> wrote:
> Hitoshi Mitake wrote:
>>
>> On Fri, 15 May 2009 19:44:03 -0400
>> Jeff Garzik <jeff@garzik.org> wrote:
>>
>>> Hitoshi Mitake wrote:
>>>>
>>>> On Wed, 13 May 2009 20:49:26 -0400
>>>> Jeff Garzik <jeff@garzik.org> wrote:
>>>>
>>>>> H. Peter Anvin wrote:
>>>>>>
>>>>>> Jeff Garzik wrote:
>>>>>>>
>>>>>>> Judging from this thread and past, I think people will continue to
>>>>>>> complain and get confused, even with the above.
>>>>>>>
>>>>>> Do you really think so?  Seems unfortunate, since an API rename would
>>>>>> be
>>>>>> way more invasive.  This is the entirety of the header patch
>>>>>> (compile-tested using 32-bit allyesconfig).
>>>>>
>>>>> The header patch does not lessen the confusion, because you cannot look
>>>>> at the code and immediately tell what is going on...
>>>>>
>>>>> Having a single function's behavior change based on #include selection
>>>>> is /not/ intuitive at all, particularly for driver writers.  That is unlike
>>>>> almost every other Linux API, where functions' behavior stays constant
>>>>> across platforms, regardless of magic "under the hood."
>>>>>
>>>>> That sort of trick is reserved for arch maintainers who know what they
>>>>> are doing :)
>>>>>
>>>>>        Jeff
>>>>>
>>>>>
>>>>>
>>>> I found another way:
>>>> Making architecture with atomic readq/writeq provide
>>>> HAVE_READQ_ATOMIC/HAVE_WRITEQ_ATOMIC
>>>> and making architecture with non-atomic readq/writeq provide
>>>> HAVE_READQ/HAVE_WRITEQ.
>>>> (HAVE_READQ_ATOMIC/HAVE_WRITEQ_ATOMIC should double as
>>>> HAVE_READQ/HAVE_WRITEQ.)
>>>>
>>>> So driver programmers who need atomic readq/writeq can judge existence
>>>> of API they really need.
>>>> If platform doesn't provide atomic readq/writeq, drivers need these can
>>>> be disabled by Kconfig.
>>>> And bugs Roland and David talking about will be banished.
>>>> How about this? > Roland and David
>>>> I wrote a test patch. Request for comments.
>>>>
>>>> Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
>>>>
>>>> ---
>>>>  arch/x86/Kconfig |   16 ++++++++++++++--
>>>>  1 files changed, 14 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>> index df9e885..c94fc48 100644
>>>> --- a/arch/x86/Kconfig
>>>> +++ b/arch/x86/Kconfig
>>>> @@ -19,8 +19,6 @@ config X86_64
>>>>  config X86
>>>>        def_bool y
>>>>        select HAVE_AOUT if X86_32
>>>> -       select HAVE_READQ
>>>> -       select HAVE_WRITEQ
>>>>        select HAVE_UNSTABLE_SCHED_CLOCK
>>>>        select HAVE_IDE
>>>>        select HAVE_OPROFILE
>>>> @@ -2022,6 +2020,20 @@ config HAVE_ATOMIC_IOMAP
>>>>        def_bool y
>>>>        depends on X86_32
>>>>  +config HAVE_READQ
>>>> +       def_bool y
>>>> +
>>>> +config HAVE_WRITEQ
>>>> +       def_bool y
>>>> +
>>>> +config HAVE_READQ_ATOMIC
>>>> +       def_bool y
>>>> +       depends on X86_64
>>>> +
>>>> +config HAVE_WRITEQ_ATOMIC
>>>> +       def_bool y
>>>> +       depends on X86_64
>>>
>>> If you create HAVE_{READQ,WRITEQ}_ATOMIC, then you don't really need
>>> HAVE_READQ -- the other relevant 32-bit platforms simply need a definition
>>> of readq and writeq.  Probably easy enough to have a common definition in
>>> asm-generic.
>>>
>> That's good idea. I didn't noticed the way to use asm-generic. Thanks.
>>
>> How is this?
>>
>> Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
>>
>> ---
>>  arch/x86/Kconfig             |   10 ++++++++--
>>  arch/x86/include/asm/io.h    |   27 ++++++---------------------
>>  include/asm-generic/quadrw.h |   34 ++++++++++++++++++++++++++++++++++
>>  3 files changed, 48 insertions(+), 23 deletions(-)
>>  create mode 100644 include/asm-generic/quadrw.h
>
>
> Seems fine to me, no objections here...
>
>
>
>> +#ifndef CONFIG_HAVE_READQ_ATOMIC
>> +static inline __u64 readq(const volatile void __iomem *addr)
>> +{
>> +       const volatile u32 __iomem *p = addr;
>> +       u32 low, high;
>> +
>> +       low = readl(p);
>> +       high = readl(p + 1);
>> +
>> +       return low + ((u64)high << 32);
>> +}
>> +#endif /* CONFIG_HAVE_READQ_ATOMIC */
>
> Personally I would do
>
>        static inline __u64 readq(const volatile void __iomem *addr)
>        {
>                __u64 low, high;
>
>                low = readl(addr);
>                high = readl(addr + 4);
>
>                return (high << 32) | low;
>        }
>
> but maybe that's just me.
>
> It seems inconsistent that the generic readq and writeq internals, simple as
> they are, differ to such a degree in this implementation.
>
> But overall, as mentioned above, the approach seems sound to me.
>
> Cheers!
>
>        Jeff
>
>
>

Please discard this mail, this is only Ccing to my another email
address of university.
Because IMAP of Gmail is too slow to read LKML...
So I'll switch my email address from h.mitake@gmail.com to
mitake@dcl.info.waseda.ac.jp,
and reply from new one.
