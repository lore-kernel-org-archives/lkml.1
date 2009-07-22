Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZGVIhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZGVIhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 04:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZGVIhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 04:37:52 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:23593 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751476AbZGVIhv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 04:37:51 -0400
Message-ID: <4A66CFDE.9090705@shipmail.org>
Date: Wed, 22 Jul 2009 10:37:50 +0200
From: =?UTF-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas@shipmail.org>
Organization: VMware
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Jerome Glisse <glisse@freedesktop.org>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: TTM page pool allocator
References: <1245931298.13359.8.camel@localhost.localdomain>	 <4A439D7D.9030401@shipmail.org>  <1248197676.2368.11.camel@localhost>	 <1248199231.2368.17.camel@localhost> <1248204128.2368.20.camel@localhost>
In-Reply-To: <1248204128.2368.20.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Glisse wrote:
> On Tue, 2009-07-21 at 20:00 +0200, Jerome Glisse wrote:
>   
>> On Tue, 2009-07-21 at 19:34 +0200, Jerome Glisse wrote:
>>     
>>> On Thu, 2009-06-25 at 17:53 +0200, Thomas Hellström wrote:
>>>       
>>>> 4) We could now skip the ttm_tt_populate() in ttm_tt_set_caching, since 
>>>> it will always allocate cached pages and then transition them.
>>>>
>>>>         
>>> Okay 4) is bad, what happens (my brain is a bit meltdown so i might be
>>> wrong) :
>>> 1 - bo get allocated tt->state = unpopulated
>>> 2 - bo is mapped few page are faulted tt->state = unpopulated
>>> 3 - bo is cache transitioned but tt->state == unpopulated but
>>>     they are page which have been touch by the cpu so we need
>>>     to clflush them and transition them, this never happen if
>>>     we don't call ttm_tt_populate and proceed with the remaining
>>>     of the cache transitioning functions
>>>
>>> As a workaround i will try to go through the pages tables and
>>> transition existing pages. Do you have any idea for a better
>>> plan ?
>>>
>>> Cheers,
>>> Jerome
>>>       
>> My workaround ruin the whole idea of pool allocation what happens
>> is that most bo get cache transition page per page. My thinking
>> is that we should do the following:
>> 	- is there is a least one page allocated then fully populate
>> 	the object and do cache transition on all the pages.
>> 	- otherwise update caching_state and leaves object unpopulated
>>
>> This needs that we some how reflect the fact that there is at least
>> one page allocated, i am thinking to adding a new state for that :
>> ttm_partialy_populated
>>
>> Thomas what do you think about that ?
>>
>> Cheers,
>> Jerome
>>     
>
> Attached updated patch it doesn't introduce ttm_partialy_populated
> but keep the populate call in cache transition. So far it seems to
> work properly on AGP platform and helps quite a lot with performances.
> I wonder if i should rather allocate some memory to store the pool
> structure in ttm_page_pool_init rather than having quite a lot of
> static variables ? Anyone has thought on that ?
>
>   
Jerome,

TTM has a device struct per device and an optional global struct that is 
common for all devices and intended to be per subsystem.

The only subsystem currently having a global structure is the memory 
accounting subsystem:
struct ttm_mem_global

You can either put the global stuff there or create and register a 
separate global struct for the page pool.

I'll probably also later add a global structure for the bo subsystem, 
since we need a common buffer object memory footprint shrinker for 
multiple cards.

/Thomas



> Cheers,
> Jerome
>   



