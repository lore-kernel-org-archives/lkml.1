Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYLPU7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYLPU7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYLPU7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:59:04 -0500
Received: from gw.goop.org ([64.81.55.164]:35965 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbYLPU7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:59:02 -0500
Message-ID: <49481694.9070707@goop.org>
Date: Tue, 16 Dec 2008 12:59:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: make sure we really have an hpet mapping before
 using it
References: <49481057.2030307@goop.org> <20081216204829.GD14787@elte.hu>
In-Reply-To: <20081216204829.GD14787@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> When booting in Xen dom0, the hpet isn't really accessible, so make
>> sure the mapping is non-NULL before use.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>> arch/x86/kernel/hpet.c |    5 +++--
>> 1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> ===================================================================
>> --- a/arch/x86/kernel/hpet.c
>> +++ b/arch/x86/kernel/hpet.c
>> @@ -818,9 +818,10 @@
>>
>> 		hpet_address = force_hpet_address;
>> 		hpet_enable();
>> -		if (!hpet_virt_address)
>> -			return -ENODEV;
>> 	}
>> +
>> +	if (!hpet_virt_address)
>> +		return -ENODEV;
>>     
>
> hm, how can hpet_virt_address become non-NULL if hpet_address is zero?
>   

The mapping is normally created in (paravirt_ops.)time_init -> 
hpet_time_init -> hpet_enable -> hpet_set_mapping.  However, under Xen, 
time_init points to the Xen time init function, and so hpet_time_init is 
never called.

hpet_time_late_init is always called because its an initfunc.  In domU 
it doesn't matter because hpet_address is NULL and so it does nothing.  
In dom0, however, all the ACPI table parsing gets done as normal, so the 
hpet is discovered and its address found.  But it is not available for 
the dom0 kernel's use, and it is never mapped.

    J
