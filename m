Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbXCZGG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbXCZGG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 02:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933611AbXCZGG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 02:06:27 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:34346 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933603AbXCZGG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 02:06:26 -0400
Message-ID: <460762C2.9030902@in.ibm.com>
Date: Mon, 26 Mar 2007 11:35:54 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Herbert Poetzl <herbert@13thfloor.at>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Dave Hansen <hansendc@us.ibm.com>
Subject: Re: Linux-VServer example results for sharing vs. separate mappings
 ...
References: <20070323193000.GB17007@MAIL.13thfloor.at> <20070323214235.94a3e899.akpm@linux-foundation.org> <20070324183806.GA7312@MAIL.13thfloor.at> <20070324121906.aff91c93.akpm@linux-foundation.org> <460645EB.3030201@in.ibm.com> <20070325105109.b15c74ac.akpm@linux-foundation.org> <46073197.2020707@in.ibm.com> <20070325212648.e49adfe1.akpm@linux-foundation.org>
In-Reply-To: <20070325212648.e49adfe1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 26 Mar 2007 08:06:07 +0530 Balbir Singh <balbir@in.ibm.com> wrote:
> 
>> Andrew Morton wrote:
>>>> Don't we break the global LRU with this scheme?
>>> Sure, but that's deliberate!
>>>
>>> (And we don't have a global LRU - the LRUs are per-zone).
>>>
>> Yes, true. But if we use zones for containers and say we have 400
>> of them, with all of them under limit. When the system wants
>> to reclaim memory, we might not end up reclaiming the best pages.
>> Am I missing something?
> 
> If a zone is under its min_pages limit, it needs reclaim.  Who/when/why
> that reclaim is run doesn't really matter.
> 
> Yeah, we might run into some scaling problems with that many zones. 
> They're unlikely to be unfixable.
> 

ok.

> 
>>>>> b) Create a new memory abstraction, call it the "software zone", which
>>>>>    is mostly decoupled from the present "hardware zones".  Most of the MM
>>>>>    is reworked to use "software zones".  The "software zones" are
>>>>>    runtime-resizeable, and obtain their pages via some means from the
>>>>>    hardware zones.  A container uses a software zone.
>>>>>
>>>> I think the problem would be figuring out where to allocate memory from?
>>>> What happens if a software zone spans across many hardware zones?
>>> Yes, that would be the tricky part.  But we generally don't care what
>>> physical zone user pages come from, apart from NUMA optimisation.
>>>
>>>> The reclaim mechanism proposed *does not impact the non-container users*.
>>> Yup.  Let's keep plugging away with Pavel's approach, see where it gets us.
>>>
>> Yes, we have some changes that we've made to the reclaim logic, we hope
>> to integrate a page cache controller soon. We are also testing the
>> patches. Hopefully soon enough, they'll be in a good state and we can
>> request you to merge the containers and the rss limit (plus page cache)
>> controller soon.
> 
> Now I'm worried again.  This separation between "rss controller" and
> "pagecache" is largely alien to memory reclaim.  With physical containers
> these new concepts (and their implementations) don't need to exist - it is
> already all implemented.
> 
> Designing brand-new memory reclaim machinery in mid-2007 sounds like a very
> bad idea.   But let us see what it looks like.
> 

I did not mean to worry you again :-) We do not plan to implement brand
new memory reclaim, we intend to modify some bits and pieces for per
container reclaim. We believe at this point that all the necessary
infrastructure is largely present in container_isolate_pages(). Adding
a page cache controller should not require core-mm surgery, just the
accounting bits.

We basically agree that designing a brand new reclaim machinery is a bad
idea, non-container users will not be impacted. Only container driver
reclaim (caused by a container being at it's limit), will see some change
in reclaim behaviour and we shall try and restrict the changes to as
small as possible.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
