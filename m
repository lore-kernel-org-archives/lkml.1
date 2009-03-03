Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZCCD66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZCCD66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 22:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZCCD6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 22:58:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:52663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbZCCD6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 22:58:49 -0500
Message-ID: <49ACAAAF.90300@kernel.org>
Date: Mon, 02 Mar 2009 19:57:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix e820 end address with EFI
References: <49A965AD.10701@redhat.com>	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>	 <49AAEC79.3000808@redhat.com>	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>	 <49AB38E7.60305@redhat.com>	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>	 <49AB4171.7000508@kernel.org>	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>	 <49AB4521.8010909@kernel.org>	 <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>	 <86802c440903011851t17e240eu9dc25116a40ca85e@mail.gmail.com>	 <1235979959.6204.212.camel@yhuang-dev.sh.intel.com>	 <49AC51D7.1080203@kernel.org>	 <1236042459.6204.226.camel@yhuang-dev.sh.intel.com>	 <49AC87AE.60001@kernel.org>	 <1236046936.6204.243.camel@yhuang-dev.sh.intel.com>	 <49AC9B99.5020000@kernel.org> <1236049574.6204.253.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1236049574.6204.253.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Tue, 2009-03-03 at 10:53 +0800, Yinghai Lu wrote:
>> Huang Ying wrote:
>>> On Tue, 2009-03-03 at 09:28 +0800, Yinghai Lu wrote:
>>>> Huang Ying wrote:
>>>>> On Tue, 2009-03-03 at 05:38 +0800, Yinghai Lu wrote:
>>>>>> Huang Ying wrote:
>>>>>>> On Mon, 2009-03-02 at 10:51 +0800, Yinghai Lu wrote:
>>>>>>>> On Sun, Mar 1, 2009 at 6:37 PM, Huang Ying <ying.huang@intel.com> wrote:
>>>>>>>>>> so 64bit could use ioremap_cache() too?
>>>>>>>>>> we may keep 32bit and 64bit a bit consistent.
>>>>>>>>> If we use ioremap_cache(), kexec runtime service will not work in kexec
>>>>>>>>> situation, which needs EFI runtime memory area to be mapped at exact
>>>>>>>>> same location across kexec. I think we should support kexec if possible.
>>>>>>>> sure.
>>>>>>>>
>>>>>>>> please don't touch max_low_pfn_mapped, because some range may not
>>>>>>>> directly mapped under those efi run-time code
>>>>>>> Find an issue to use init_memory_mapping() here.
>>>>>>>
>>>>>>> If the memory range to be mapped is less than 2M, the last mapped
>>>>>>> address may be next 2M aligned position, this may lead mapping
>>>>>>> overlapping between memory range. Such as:
>>>>>>>
>>>>>>> 0x3f388000 - 0x3f488000: real mapped	0x3f388000 - 0x3f600000
>>>>>>> 0x3f590000 - 0x3f5bb000: real mapped	0x3f590000 - 0x3f600000
>>>>>>>
>>>>>>> The problem is that the memory range 0x3f400000 - 0x3f590000 is left not
>>>>>>> mapped!
>>>>>> what is max_low_pfn_mapped before that?
>>>>> I don't know exactly what you mean. Can you elaborate a little?
>>>>>
>>>>> 0 ~ max_low_pfn_mapped ~ max_pfn_mapped can be mapped with
>>>>> init_memory_mapping() properly.
>>>>>
>>>>> The issue of above example is that 0x3f400000 ~ 0x3f488000 is a
>>>>> sub-range of 0x3f388000 ~ 0x3f488000, which should be mapped but is left
>>>>> not mapped.
>>>> what is max_low_pfn_mapped?
>>>>
>>>> what is init_memory_mapping() printout?
>>> This does not comes from a real test case. To test the changes I made, I
>>> make efi_ioremap() being used even if the corresponding memory range is
>>> below max_low_pfn_mapped. The dmesg of test is attached with the mail.
>>>
>>> The printout of init_memory_mapping shows:
>>>
>>> init_memory_mapping: 000000003f488000-000000003f4bb000                          
>>> last_map_addr: 3f600000 end: 3f4bb000
>>> init_memory_mapping: 000000003f590000-000000003f5bb000                          
>>> last_map_addr: 3f600000 end: 3f5bb000
>> init_memory_mapping: 0000000000000000-000000003f700000                          
>>
>> last_map_addr: 3f700000 end: 3f700000                                           
>>
>> (6 early reservations) ==> bootmem [0000000000 - 003f700000]
>>
>> so max_low_pfn_mapped is (3f700000>>12)
>> and you try to init_memory_mapping again before it
> 
> Yes. Just for testing, I want to use efi_ioremap() on more memory range
> to test.
> 
>>> init_memory_mapping: 00000000fffb0000-00000000fffba000                          
>>> last_map_addr: 100000000 end: fffba000
>> this one is interesting... got over mapped...
>>> So I think it is possible to have the issue I mentioned above.
>> looks like.
> 
> So, If you have no time, I can try to fix that. Do you think
> init_memory_mapping should stop at specified end page?

you may boot with debug, so could figure out how init_memory_mapping want to map the range.

it should stop at specified end page at least with 64bit.

YH
