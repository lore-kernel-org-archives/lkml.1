Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbYEUXaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbYEUXaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbYEUXaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:30:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:35260 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbYEUXaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pSdpXTJAUuh+JyWCqPccOEKOZfN5jRrNf5YXkcu/bavTLSQ374CmSEePLkLDk/bRbSmMK59qRtK+WGHoWYxUbS/kFlzJSHSs5gtLA3RmQVhRmWwU+gfAJuxtDOnAcOxrSGUBss1BXppCoz3hMHkPkHf/we1BZxpefC5P8pMdSoY=
Message-ID: <86802c440805211623j459ff12o82e96ede85b745f8@mail.gmail.com>
Date: Wed, 21 May 2008 16:23:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: Suspected regression in "x86: extend e820 ealy_res support 32bit"
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Ingo Molnar" <mingo@elte.hu>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <87lk232qt3.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483467CD.90401@goop.org>
	 <86802c440805211335q27334ba1g32a43fb1c0498b9b@mail.gmail.com>
	 <87lk232qt3.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 4:14 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi,
>
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>> On Wed, May 21, 2008 at 11:19 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>> I'm seeing a crash in current x86.git tip/auto-latest when booting under
>>> Xen.  The crash is rather early, but it's in __alloc_bootmem_core() in the
>>> final memset clear.  Apparently the allocator is returning a bad page.
>>>
>>> This points to changes in the setup of the bootmem allocator, and the
>>> changes "x86: extend e820 ealy_res support 32bit" make to
>>> arch/x86/kernel/setup_32.c:setup_bootmem_allocator() looks like the most
>>> likely suspect.  Unfortunately its a rather large patch which is not easy to
>>> revert, so I haven't actually confirmed this yet.
>>
>>
>> thanks. please check the attached patch
>>
>> YH
>>
>> [PATCH] x86: bootmap size fix for 32 bit
>>
>> Jeremy Fitzhardinge found
>> x86: extend e820 ealy_res support 32bit
>> cause regression...
>>
>> in setup_bootmem_allocator
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
>> index f38d840..938c7b3 100644
>> --- a/arch/x86/kernel/setup_32.c
>> +++ b/arch/x86/kernel/setup_32.c
>> @@ -566,17 +566,22 @@ static void __init relocate_initrd(void)
>>
>>  void __init setup_bootmem_allocator(void)
>>  {
>> +     unsigned long bootmap_pages;
>>       unsigned long bootmap_size, bootmap;
>>       /*
>>        * Initialize the boot-time allocator (with low memory only):
>>        */
>> -     bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
>> +     bootmap_pages = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
>
> Forgot to remove the shift?
>
>>       bootmap = find_e820_area(min_low_pfn<<PAGE_SHIFT,
>> -                              max_low_pfn<<PAGE_SHIFT, bootmap_size,
>> +                              max_low_pfn<<PAGE_SHIFT,
>> +                              bootmap_pages<<PAGE_SHIFT,
>
> Because this value is hardly sane anymore.
>
>>                                PAGE_SIZE);
>>       if (bootmap == -1L)
>>               panic("Cannot find bootmem map of size %ld\n", bootmap_size);
>>       bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
>> +     printk(KERN_INFO "  bootmap [%016lx -  %016lx] pages %lx\n",
>> +              bootmap, bootmap + bootmap_size - 1,
>> +              bootmap_pages);
>>       register_bootmem_low_pages(max_low_pfn);
>>       early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
>>       reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
>
> Besides, what did you want to accomplish?

please drop this patch...

YH
