Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZALSXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZALSXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZALSWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:22:53 -0500
Received: from relay3.sgi.com ([192.48.171.31]:42467 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751387AbZALSWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:22:52 -0500
Message-ID: <496B8A79.4060309@sgi.com>
Date: Mon, 12 Jan 2009 10:22:49 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Ingo Molnar <mingo@elte.hu>, Christophe Saout <christophe@saout.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: xen: fix too early kmalloc call
References: <496A4C8F.8070005@sgi.com> <20090112085302.GB21976@elte.hu> <20090112144218.GA18859@cmpxchg.org>
In-Reply-To: <20090112144218.GA18859@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> On Mon, Jan 12, 2009 at 09:53:02AM +0100, Ingo Molnar wrote:
>> * Mike Travis <travis@sgi.com> wrote:
>>
>>> Subject: xen: fix too early kmalloc call
>>>
>>> From: Christophe Saout <christophe@saout.de> 
>>>
>>> Impact: fixes bootup of xen.
>>>
>>> Christophe reported the following problem:
>>>
>>>>  (basically it seems that SLAB is not yet up, with earlyprintk it is
>>>>  giving me an Oops in __kmalloc before)
>>> Replace call to kmalloc with alloc_bootmem.
>>>
>>> Also from Christophe:
>>>> (me)
>>>>> Or I could copy the text and submit it as a new patch?
>>>> Yes, I would prefer that.  Also, my commit message was not really
>>>> following Kernel standards and it's only a very simple change.
>>> Signed-off-by: Mike Travis <travis@sgi.com>
>> i've applied the fix to tip/cpus4096, in the form below.
>>
>> Please submit clean log messages. Your commit description was confused - 
>> the patch is From: Christophe, but the message talks about Christophe in 
>> the third person. Also, it included conversational bits that have no 
>> value for the Git history.
>>
>> 	Ingo
>>
>> -------------------->
>>> >From 28e08861b9afab4168b758fb7b95aa7a4da0f668 Mon Sep 17 00:00:00 2001
>> From: Christophe Saout <christophe@saout.de>
>> Date: Sun, 11 Jan 2009 11:46:23 -0800
>> Subject: [PATCH] xen: fix too early kmalloc call
>>
>> Impact: fix bootup crash on xen guests
>>
>> SLAB is not yet up, with earlyprintk it is giving me an Oops in __kmalloc.
>>
>> Replace call to kmalloc() with alloc_bootmem().
>>
>> Reported-by: Christophe Saout <christophe@saout.de>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  drivers/xen/events.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
>> index ed7527b..3141e14 100644
>> --- a/drivers/xen/events.c
>> +++ b/drivers/xen/events.c
>> @@ -26,6 +26,7 @@
>>  #include <linux/irq.h>
>>  #include <linux/module.h>
>>  #include <linux/string.h>
>> +#include <linux/bootmem.h>
>>  
>>  #include <asm/ptrace.h>
>>  #include <asm/irq.h>
>> @@ -831,8 +832,8 @@ void __init xen_init_IRQ(void)
>>  	int i;
>>  	size_t size = nr_cpu_ids * sizeof(struct cpu_evtchn_s);
>>  
>> -	cpu_evtchn_mask_p = kmalloc(size, GFP_KERNEL);
>> -	BUG_ON(cpu_evtchn_mask == NULL);
>> +	cpu_evtchn_mask_p = alloc_bootmem(size);
>> +	BUG_ON(cpu_evtchn_mask_p == NULL);
> 
> Impossible condition :-) alloc_bootmem() crashes before you could
> catch it here.
> 
> 	Hannes

Yes, that's picked up in a subsequent patch (I didn't catch it the
first time I reviewed it as well.)  There appears to be a queue of
patches for Xen coming, so this last "memory reduction patch" will
follow (or be included with) those.

Thanks,
Mike

