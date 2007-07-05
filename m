Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbXGEMQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbXGEMQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbXGEMQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:16:13 -0400
Received: from lucidpixels.com ([75.144.35.66]:56766 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbXGEMQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:16:12 -0400
Date: Thu, 5 Jul 2007 08:16:11 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Pavel Machek <pavel@ucw.cz>
cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <20070705121203.GB5167@ucw.cz>
Message-ID: <Pine.LNX.4.64.0707050815400.32548@p34.internal.lan>
References: <200706251434.43863.jesse.barnes@intel.com> <20070705121203.GB5167@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jul 2007, Pavel Machek wrote:

> Hi!
>
>> On some machines, buggy BIOSes don't properly setup WB MTRRs to
>> cover all available RAM, meaning the last few megs (or even gigs)
>> of memory will be marked uncached.  Since Linux tends to allocate
>> from high memory addresses first, this causes the machine to be
>> unusably slow as soon as the kernel starts really using memory
>> (i.e. right around init time).
>>
>> This patch works around the problem by scanning the MTRRs at
>> boot and figuring out whether the current end_pfn value (setup
>> by early e820 code) goes beyond the highest WB MTRR range, and
>> if so, trimming it to match.  A fairly obnoxious KERN_WARNING
>> is printed too, letting the user know that not all of their
>> memory is available due to a likely BIOS bug.
>>
>> Something similar could be done on i386 if needed, but the boot
>> ordering would be slightly different, since the MTRR code on i386
>> depends on the boot_cpu_data structure being setup.
>>
>> This patch fixes a bug in the last patch that caused the code to
>> run on non-Intel machines (AMD machines apparently don't need it
>> and it's untested on other non-Intel machines, so best keep it
>> off).
>>
>> akpm -- this one should replace all the mtrr patches currently
>> in your tree.
>>
>> Yinghai, maybe you can test this on one of your AMD machines to
>> make sure I got the CPU code right?
>
>> +	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
>> +		printk(KERN_WARNING "***************\n");
>> +		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
>> +		printk(KERN_WARNING "**** MTRRs don't cover all of "
>> +		       "memory, trimmed %ld pages\n", end_pfn -
>> +		       (highest_addr >> PAGE_SHIFT));
>> +		printk(KERN_WARNING "***************\n");
>> +		end_pfn = highest_addr >> PAGE_SHIFT;
>
> I'd say using that many stars for KERN_WARNING printk is sign of
> mental illness or something...
> 							Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

Will this patch make it into 2.6.23?

Been patching manually for a while with each -rc for 2.6.22..

Justin.
