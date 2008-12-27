Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYL0VKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYL0VKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 16:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYL0VKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 16:10:04 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:12754 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYL0VKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 16:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WoiRbqLKH0mKsL9z4h/ySFmPnXpTanU8C3QCiy4wbRw06VT9qMn9M+5IyWuU/dmo7V
         YQSvxirkrvHwj/rYWfS7CXm4+A8mx/G6WcrZf3JhCJWl6fO4AbXlDR8QaqaEmCdIdoGq
         /lvGZd3LZSY1tkrcEconasMMUwJqJ8oANWM+w=
Message-ID: <86802c440812271310ua3dec61gf3aaec921023d2a4@mail.gmail.com>
Date: Sat, 27 Dec 2008 13:10:00 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333 smp_call_function_mask
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "David Howells" <dhowells@redhat.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
In-Reply-To: <20081227152918.GD4530@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081226170452.GC5100@linux.vnet.ibm.com>
	 <20081227071138.GA4530@linux.vnet.ibm.com>
	 <4955DBBC.4070508@kernel.org> <20081227083758.GA12138@elte.hu>
	 <20081227083936.GA12609@elte.hu>
	 <20081227112125.GB4530@linux.vnet.ibm.com>
	 <20081227112450.GA24150@elte.hu>
	 <20081227115712.GC4530@linux.vnet.ibm.com>
	 <20081227122632.GA18909@elte.hu>
	 <20081227152918.GD4530@linux.vnet.ibm.com>
X-Google-Sender-Auth: 14c68a93f6d3c5c6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 7:29 AM, Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:
> * Ingo Molnar <mingo@elte.hu> [2008-12-27 13:26:32]:
>
>>
>> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>
>> > > yes, indeed - updated patch below.
>> > >
>> > >   Ingo
>> > >
>> >
>> > Hi Ingo,
>> >
>> >     Sorry, for not mentioning that the previous kernel trace, was
>> > after adding the return statement to the arch_init_chip_data().
>>
>> ah, i missed that detail. There was a stupid typo in one of the conflict
>> resolutions i had to do - could you check the updated patch below?
>>
>> Thanks,
>>
>>       Ingo
>>
>
>
> Hi Ingo,
>
>        kernel still crashes, with the updated patch.
>
>
>> ----------->
>> From 13a0c3c269b223f60abfac8a9811d77111a8b4ba Mon Sep 17 00:00:00 2001
>> From: Yinghai Lu <yinghai@kernel.org>
>> Date: Fri, 26 Dec 2008 02:05:47 -0800
>> Subject: [PATCH] sparseirq: work around compiler optimizing away __weak functions
>>
>> Impact: fix panic on null pointer with sparseirq
>>
>> Some GCC versions seem to inline the weak global function,
>> when that function is empty.
>>
>> Work it around, by making the functions return a (dummy) integer.
>>
>> Signed-off-by: Yinghai <yinghai@kernel.org>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  arch/x86/kernel/io_apic.c |    8 ++++++--
>>  include/linux/irq.h       |    6 +++---
>>  init/main.c               |    7 ++++---
>>  kernel/irq/handle.c       |    7 ++++---
>>  4 files changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
>> index 2fe543f..9760393 100644
>> --- a/arch/x86/kernel/io_apic.c
>> +++ b/arch/x86/kernel/io_apic.c
>> @@ -170,7 +170,7 @@ static struct irq_cfg irq_cfgx[NR_IRQS] = {
>>       [15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
>>  };
>>
>> -void __init arch_early_irq_init(void)
>> +int __init arch_early_irq_init(void)
>>  {
>>       struct irq_cfg *cfg;
>>       struct irq_desc *desc;
>> @@ -184,6 +184,8 @@ void __init arch_early_irq_init(void)
>>               desc = irq_to_desc(i);
>>               desc->chip_data = &cfg[i];
>>       }
>> +
>> +     return 0;

can you try current tip/master?

current there are several blank __weak, and __weak + return 0..in the
whole tree.

it seems there three solution:
1. use printk?
2. not use __weak with blank function any more, and use #ifdef and
inline functions instead
3. blacklist that gcc 4.1.1 complier..

YH
