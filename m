Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbXCMPad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbXCMPad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXCMPac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:30:32 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:30934 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbXCMPac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:30:32 -0400
Message-ID: <45F6C6BF.5000002@sw.ru>
Date: Tue, 13 Mar 2007 18:43:59 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: devel@openvz.org
CC: Kirill Korotaev <dev@openvz.org>, containers@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>	<20070306140036.4e85bd2f.akpm@linux-foundation.org>	<45F3F581.9030503@sw.ru>	<20070311045111.62d3e9f9.akpm@linux-foundation.org>	<m1wt1nvajx.fsf@ebiederm.dsl.xmission.com>	<45F51C08.2020108@openvz.org> <m17itltrxe.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m17itltrxe.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

>>>And misses every resource sharing opportunity in sight.
>>
>>that was my point too.
>>
>>
>>>Except for
>>>filtering the which pages are eligible for reclaim an RSS limit should
>>>not need to change the existing reclaim logic, and with things like the
>>>memory zones we have had that kind of restriction in the reclaim logic
>>>for a long time.  So filtering out ineligible pages isn't anything new.
>>
>>exactly this is implemented in the current patches from Pavel.
>>the only difference is that filtering is not done in general LRU list,
>>which is not effective, but via per-container LRU list.
>>So the pointer on the page structure does 2 things:
>>- fast reclamation
> 
>     Better than the rmap list?
> 
>>- correct uncharging of page from where it was charged
>>  (e.g. shared pages can be mapped first in one container, but the last unmap
>>   done from another one).
> 
>     We should charge/uncharge all of them, not just one.
> 
> 
>>>>We need to work out what the requirements are before we can settle on an
>>>>implementation.
>>>
>>>
>>>If you are talking about RSS limits the term is well defined.  The
>>>number of pages you can have mapped into your set of address space at
>>>any given time.
>>>
>>>Unless I'm totally blind that isn't what the patchset implements.
>>
>>Ouch, what makes you think so?
>>The fact that a page mapped into 2 different processes is charged only once?
>>Imho it is much more correct then sum of process' RSS within container, due to:
>>1. it is clear how much container uses physical pages, not abstract items
>>2. shared pages are charged only once, so the sum of containers RSS is still
>>   about physical RAM.
> 
> 
> No the fact that a page mapped into 2 separate mm_structs in two
> separate accounting domains is counted only once.  This is very likely
> to happen with things like glibc if you have a read-only shared copy
> of your distro.  There appears to be no technical reason for such a
> restriction.
> 
> A page should not be owned.  

I would be happy to propose OVZ approach then, where a page is tracked
with page_beancounter data structure, which ties together
a page with beancounters which use it like this:

page -> page_beancounter -> list of beanocunters which has the page mapped

This gives a number of advantages:
- the page is accounted to all the VEs which actually use it.
- allows almost accurate tracking of page fractions used by VEs
  depending on how many VEs mapped the page.
- allows to track dirty pages, i.e. which VE dirtied the page
  and implement correct disk I/O accounting and CFQ write scheduling
  based on VE priorities.

> Going further unless the limits are draconian I don't expect users to
> hit the rss limits often or frequently.  So in 99% of all cases page
> reclaim should continue to be global.  Which makes me question messing
> with the general page reclaim lists.

It is not that rare when containers hit their limits, believe me :/
In trusted environments - probably you are right, in hosting - no.

Thanks,
Kirill

