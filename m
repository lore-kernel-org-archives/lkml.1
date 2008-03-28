Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYC1CN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYC1CN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbYC1CNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:13:40 -0400
Received: from gw.goop.org ([64.81.55.164]:46638 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbYC1CNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:13:39 -0400
Message-ID: <47EC5440.5020107@goop.org>
Date: Thu, 27 Mar 2008 19:13:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned memory
 is bad
References: <e0b16cc8349b38a5f3f9.1206664118@localhost>	<20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>	<20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com> <20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 28 Mar 2008 10:34:51 +0900
> Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>   
>>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>>> --- a/mm/memory_hotplug.c
>>>> +++ b/mm/memory_hotplug.c
>>>> @@ -300,6 +300,11 @@
>>>>  	int ret;
>>>>  	u64 start = res->start;
>>>>  	u64 size = res->end - res->start + 1;
>>>> +
>>>> +	/* Adding non-section-aligned memory will give unexpected
>>>> +	   and unintuitive results. */
>>>> +	WARN_ON((start & SECTION_SIZE_MASK) != 0);
>>>> +	WARN_ON((size & SECTION_SIZE_MASK) != 0);
>>>>  
>>>>         
>>> Why just WARNING ? not BUG_ON?
>>>       
>> Both Nack.
>>
>> Because, firmware may occupy some area in the section.
>> Firmware must exclude those area to notify kernel. So, E820, EFI,
>> or _CRS of ACPI may return not aligned address and size.
>> register_memory_resource() and walk_memory_resource() are to skip
>> them silently. This is intended.
>>
>>     
> Ah, ok. sorry.
>
> Jeremy, I think you can check whether you have 'struct page' or not by
> pfn_valid(). 
>
> If pfn_valid() == false, you should call add_memory() and create
> a section/mem_map. If pfn_valid() == true, you should just remove
> PG_reserved bit in mem_map by online_page().

OK.  Would that ever be necessary if I explicitly align my start and size?

    J

