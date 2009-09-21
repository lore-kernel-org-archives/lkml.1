Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZIUJB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZIUJB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZIUJB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:01:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:37740 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512AbZIUJBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:01:55 -0400
Message-ID: <4AB740A6.6010008@kernel.org>
Date: Mon, 21 Sep 2009 18:00:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Sachin Sant <sachinp@in.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie> <1253302451-27740-2-git-send-email-mel@csn.ul.ie> <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com> <4AB5FD4D.3070005@kernel.org> <4AB5FFF8.7000602@cs.helsinki.fi> <4AB6508C.4070602@kernel.org> <4AB739A6.5060807@in.ibm.com> <20090921084248.GC12726@csn.ul.ie>
In-Reply-To: <20090921084248.GC12726@csn.ul.ie>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 09:00:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mel Gorman wrote:
>>> Can you please post full dmesg showing the corruption? 
> 
> There isn't a useful dmesg available and my evidence that it's within the
> pcpu allocator is a bit weak.

I'd really like to see the memory layout, especially how far apart the
nodes are.

> Symptons are crashing within SLQB when a second CPU is brought up
> due to a bad data access with a declared per-cpu area. Sometimes
> it'll look like the value was NULL and other times it's a random.
> 
> The "per-cpu" area in this case is actually a per-node area. This implied that
> it was either racing (but the locking looked sound), a buffer overflow (but
> I couldn't find one) or the per-cpu areas were being written to by something
> else unrelated. I considered it possible that as the CPU and node numbers did
> not match up that the unused numbers were being freed up for use elsewhere. I
> haven't dug into the per-cpu implementation to see if this is a possibility.

I'm now working on ia64 percpu support and it had similar memory
corruption while initializing ipv4 snmp counters.  It turned out the
areas assigned to each cpu ended up too far away and the offsets
couldn't be honored in the vmalloc area.  This led to percpu alloc
failure.  ipv4 snmp doesn't verify allocation result and ends up
accessing NULL percpu pointers.  On ia64, this ends up accessing areas
right before cpu0 percpu area causing various interesting memory
corruptions.

>>> Also, if you apply the attached patch, does the added BUG_ON()
>>> trigger?
>>>   
>> I applied the three patches from Mel and one from Tejun.

Can you please apply only my patch?

> Thanks Sachin
> 
> Was there any useful result from Tejun's patch applied on its own?
> 
>> With these patches applied the machine boots past
>> the original reported SLQB problem, but then hangs
>> just after printing these messages.
>>
>> <6>ehea: eth0: Physical port up
>> <7>irq: irq 33539 on host null mapped to virtual irq 259
>> <6>ehea: External switch port is backup port
>> <7>irq: irq 33540 on host null mapped to virtual irq 260
>> <6>NET: Registered protocol family 10
>> ^^^^^^ Hangs at this point.
>>
>> Tejun, the above hang looks exactly the same as the one
>> i have reported here :
>>
>> http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-September/075791.html
>>
>> This particular hang was bisected to the following patch
>>
>> powerpc64: convert to dynamic percpu allocator
>>
>> This hang can be recreated without SLQB. So i think this is a different
>> problem. 
>>
> 
> Was that bug ever resolved?

Nope, not yet.  I'm thinking it could be something similar tho.
Especially because it's failing while initializing NET too.  Can
someone please post boot log from the machine?

Thanks.

-- 
tejun
