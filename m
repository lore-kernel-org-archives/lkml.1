Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbZBGJBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbZBGJBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 04:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZBGJBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 04:01:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:6542 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZBGJBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 04:01:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fwsSx0J3sdG8f0gTGBspQdaioOOZyrgsFwp42aM05+nKm8GZfKfuYsAZSgBQFBOIVH
         Pk7lKl9Tjh2Qn6tmbDqIHkoX3Ow184AVQwgKoToH8gv1W67+eBkaXdlvGxPKYVQ/HBzD
         8xxvCuhT5BqvM0KqzHoJZA6Pp1DE9cQ8qAl8s=
MIME-Version: 1.0
In-Reply-To: <20090207002610.73ff7e6d.akpm@linux-foundation.org>
References: <498CB0B7.8030009@kernel.org>
	 <20090206140005.44b4bb50.akpm@linux-foundation.org>
	 <498CB4DC.2010108@kernel.org> <498D3D15.5090005@kernel.org>
	 <20090207002610.73ff7e6d.akpm@linux-foundation.org>
Date: Sat, 7 Feb 2009 01:01:03 -0800
X-Google-Sender-Auth: 713feb133185db24
Message-ID: <86802c440902070101l5b0ef862ja92e3f31705d9608@mail.gmail.com>
Subject: Re: [PATCH] irq: optimize init_kstat_irqs/init_copy_kstat_irqs
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 7, 2009 at 12:26 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 06 Feb 2009 23:49:41 -0800 Yinghai Lu <yinghai@kernel.org> wrote:
>
>>
>> Impact: even later type of kstat_irqs is changed
>>
>> simplify and make init_kstat_irqs etc more type prof according to Andrew
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  kernel/irq/handle.c       |   20 +++++++++++---------
>>  kernel/irq/numa_migrate.c |   11 +++--------
>>  2 files changed, 14 insertions(+), 17 deletions(-)
>>
>> Index: linux-2.6/kernel/irq/handle.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/irq/handle.c
>> +++ linux-2.6/kernel/irq/handle.c
>> @@ -82,19 +82,21 @@ static struct irq_desc irq_desc_init = {
>>
>>  void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
>>  {
>> -     unsigned long bytes;
>> -     char *ptr;
>>       int node;
>> -
>> -     /* Compute how many bytes we need per irq and allocate them */
>> -     bytes = nr * sizeof(unsigned int);
>> +     void *ptr;
>>
>>       node = cpu_to_node(cpu);
>> -     ptr = kzalloc_node(bytes, GFP_ATOMIC, node);
>> -     printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n", cpu, node);
>> +     ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
>>
>> -     if (ptr)
>> -             desc->kstat_irqs = (unsigned int *)ptr;
>> +     /*
>> +      * don't overwite if can not get new one
>> +      * init_copy_kstat_irqs() could still use old one
>> +      */
>> +     if (ptr) {
>> +             printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n",
>> +                      cpu, node);
>> +             desc->kstat_irqs = ptr;
>> +     }
>
>        else
>                init_one_irq_desc() goes BUG.
>
>>  }
>
> Sorry, but it's just not acceptable for irq_to_desc_alloc_cpu() and
> init_one_irq_desc() to go BUG if a GFP_ATOMIC allocation attempt
> failed.
>
> If this code is only called on kernel boot then OK, that's acceptable.
> But if that is the case then all this code should be marked
> __init/__initdata.  And ack_apic_edge() sure doesn't look like a
> boot-time-only function.

add kzalloc_node_safe()?

>
> This is basic stuff which even a cursory review should have picked up.
>
> Also, please go through all this code and convert WARN_ON(1) into
> WARN(), and convert BUG_ON(1) into BUG().

sure, will do it.

YH
