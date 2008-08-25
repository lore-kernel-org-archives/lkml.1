Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbYHYGkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbYHYGkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 02:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYHYGkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 02:40:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:25301 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYHYGke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 02:40:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gmXmF5lclsHh07j7ku/ZKDWagMp+g3vC0tSM5c2Gl0jWbFIGAp8dd4icwkoZFy2Ost
         aNTGGPBFzc+9JI4vWCKDhJ62Y3Hhd3S//YYpU27/8lCo4zh7OWLXH0KBSSdIQVdClXmN
         9xT4Pyei+MK2mO/P1ACjj8oI8AILLNEaw21RU=
Message-ID: <86802c440808242340v7aa8bdf2jfb18f4120dec460d@mail.gmail.com>
Date: Sun, 24 Aug 2008 23:40:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080825062746.GA26445@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <914225.91320.qm@web82104.mail.mud.yahoo.com>
	 <86802c440808242141j716b5875s709dc56c1163a7d5@mail.gmail.com>
	 <20080825062746.GA26445@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 11:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> [PATCH] x86: check hpet with BAR v2
>>
>> insert some resources to resource tree forcily, so could avoid kernel update the
>> resources in pci device.
>>
>> should check in device too.
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  arch/x86/pci/i386.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 43 insertions(+)
>>
>> Index: linux-2.6/arch/x86/pci/i386.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/pci/i386.c
>> +++ linux-2.6/arch/x86/pci/i386.c
>> @@ -33,6 +33,7 @@
>>  #include <linux/bootmem.h>
>>
>>  #include <asm/pat.h>
>> +#include <asm/hpet.h>
>>
>>  #include "pci.h"
>>
>> @@ -77,6 +78,30 @@ pcibios_align_resource(void *data, struc
>>  }
>>  EXPORT_SYMBOL(pcibios_align_resource);
>>
>> +static int check_res_with_valid(struct pci_dev *dev, struct resource *res)
>> +{
>> +     unsigned long base;
>> +     unsigned long size;
>> +
>> +     base = res->start;
>> +     size = (res->start == 0 && res->end == res->start) ? 0 :
>> +              (res->end - res->start + 1);
>> +
>> +     if (!base || !size)
>> +             return 0;
>> +
>> +#ifdef CONFIG_HPET_TIMER
>> +     /* for hpet */
>> +     if (base == hpet_address && (res->flags & IORESOURCE_MEM)) {
>> +             dev_info(&dev->dev, "BAR has HPET at %08lx-%08lx\n",
>> +                              base, base + size - 1);
>> +             return 1;
>> +     }
>> +#endif
>
> i think the warning should be more prominent and should also generate a
> stack trace for the kerneloops client to pick up. A WARN() printout
> would be perfect here.

dev_warn or WARN_ON?

>
> Also, we should do subsequent commits as well enumerating all the other
> 'magic' non-PCI-enumerated bus memory resources that matter on a PC
> platform: lapic address and io-apic address(es). Perhaps even the ACPI
> NVS and ACPI data areas that are enumerated in e820.
>
> (the lapic address will likely never be present in a PCI device - but
> maybe the IO-APIC address can be present in theory - so lets protect
> it.)

yes. other than default io_apic addr.
mmconf ?

>
> Another suggestion: perhaps this all should be done as a new, "sticky"
> resource type flag [defined in include/linux/ioport.h and implemented in
> kernel/resource.c], which would be inserted by the hpet driver, and
> which would be listened to by pcibios_allocate_resources()
> automatically. If the resource manager later on finds a generic-looking,
> unclaimed PCI device whose BAR matches on it, then the new semantics
> would mean that the device's BAR will not be touched.

pcibios_allocate_resources() consult resource_manager before
request_resource(pr, r)...

YH
