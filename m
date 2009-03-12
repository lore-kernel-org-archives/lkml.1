Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZCLLb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZCLLb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbZCLLbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:31:17 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:34676 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbZCLLbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:31:16 -0400
Message-Id: <49B900BA.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 11:31:54 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Yinghai Lu" <yinghai@kernel.org>
Cc: <jeremy.fitzhardinge@citrix.com>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
References: <49B8F5C4.76E4.0078.0@novell.com>
 <20090312110244.GD30204@elte.hu>
In-Reply-To: <20090312110244.GD30204@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 12.03.09 12:02 >>>
>  
> +#ifdef CONFIG_X86_64
> +	if (start_addr >= MAX_GAP_END)
> +		last = end_addr ?: (1UL << boot_cpu_data.x86_phys_bits);
> +	else
> +#endif
>  	last = (end_addr && end_addr < MAX_GAP_END) ? end_addr : MAX_GAP_END;

>hm, this #ifdef block looks quite ugly and should be cleaned up. 
>x86_phys_bits could be filled in on 32-bit too - and on 32-bit 

I'm about to submit a patch to that effect. But I'm trying to keep patches
independent as much as possible.

>start_addr cannot be larger than 4GB anyway.

Correct, but I think the code would be less self-documenting if it relied
on that fact rather than making clear from the first glance that the
conditional is only being evaluated (and hence can only be true) on 64-bits.

>> @@ -585,11 +591,12 @@ __init void e820_setup_gap(void)
>>  
>>  #ifdef CONFIG_X86_64
>>  	if (!found) {
>> -		gapstart = (max_pfn << PAGE_SHIFT) + 1024*1024;
>>  		printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit "
>>  		       "address range\n"
>>  		       KERN_ERR "PCI: Unassigned devices with 32bit resource "
>>  		       "registers may break!\n");
>> +		found = e820_search_gap(&gapstart, &gapsize, MAX_GAP_END, 0);
>> +		BUG_ON(!found);
>
>that BUG_ON() will be hard to debug - please use a WARN_ON 
>instead.

Will do, but please clarify the above point before I re-submit.

Jan

