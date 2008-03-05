Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbYCEQoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbYCEQoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYCEQoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:44:03 -0500
Received: from gw.goop.org ([64.81.55.164]:49069 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbYCEQoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:44:01 -0500
Message-ID: <47CECC8D.9090507@goop.org>
Date: Wed, 05 Mar 2008 08:38:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
 to 1MB
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <20080228132822.GA25278@mailshack.com> <1204233131.28798.12.camel@cthulhu.hellion.org.uk> <47C72432.3010606@zytor.com> <1204240609.28798.33.camel@cthulhu.hellion.org.uk> <20080305155930.GI20230@blackpad>
In-Reply-To: <20080305155930.GI20230@blackpad>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> On Thu, Feb 28, 2008 at 11:16:49PM +0000, Ian Campbell wrote:
>   
>> The patch below seems like the right thing to do. It certainly boots in
>> a domU without the DMI problem (without any of the other related patches
>> such as Alexander's).
>>
>> However ddcprobe hangs when run -- need to investigate some more, vm86
>> in general works ok (i.e. my vm86 test code passes).
>>
>> BTW Jeremy, the kernel doesn't use XENMEM_memory_map -- any reason other
>> than it not being useful at the time? These days the tools can push an
>> arbitrary e820 down for a guest which might be useful to support,
>> although nothing interesting is done with it today.
>>
>> Ian.
>>
>> x86/xen: Construct e820 map with a hole between 640K-1M.
>>
>> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> ---
>>  arch/x86/xen/setup.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
>> index 3bad477..2341492 100644
>> --- a/arch/x86/xen/setup.c
>> +++ b/arch/x86/xen/setup.c
>> @@ -38,7 +38,8 @@ char * __init xen_memory_setup(void)
>>  	unsigned long max_pfn = xen_start_info->nr_pages;
>>  
>>  	e820.nr_map = 0;
>> -	add_memory_region(0, PFN_PHYS(max_pfn), E820_RAM);
>> +	add_memory_region(0, LOWMEMSIZE(), E820_RAM);
>> +	add_memory_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY, E820_RAM);
>>     
>
> Won't this waste 300+ KB of Perfectly Good RAM? Or I understood it
> incorrectly?
>
> I am aware that it would take more work to tell all kernel code that it
> shouldn't look for BIOS data on this region when running as a domU guest,
> but it seems that it would be a better solution.

For the moment that's true, but we should be able to release those 
pages.  On the other hand, there's been talk of making Xen hand out 
memory in physically contigious 2M chunks, which means trying to unmap 
300k won't be possible or worthwhile.  I suspect real hardware will just 
waste this memory too (it won't remap that 320k of ram to somewhere 
else; it will just be shadowed) - which is nothing compared to chipsets 
which will just throw away 1G to make space for PCI...

    J
