Return-Path: <linux-kernel-owner+w=401wt.eu-S965042AbXCBR7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042AbXCBR7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965445AbXCBR7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:59:34 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:34698 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965042AbXCBR7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:59:33 -0500
Date: Fri, 2 Mar 2007 17:59:30 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Christoph Lameter <clameter@engr.sgi.com>
Cc: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       npiggin@suse.de, mingo@elte.hu, Joel Schopp <jschopp@austin.ibm.com>,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       kamezawa.hiroyu@jp.fujitsu.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <Pine.LNX.4.64.0703020942550.17017@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0703021750490.16858@skynet.skynet.ie>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org>
 <20070302163206.GA1555@skynet.ie> <Pine.LNX.4.64.0703020916330.16719@schroedinger.engr.sgi.com>
 <20070302172818.GA15730@skynet.ie> <Pine.LNX.4.64.0703020942550.17017@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Christoph Lameter wrote:

> On Fri, 2 Mar 2007, Mel Gorman wrote:
>
>>> I still think that the list based approach is sufficient for memory
>>> hotplug if one restricts  the location of the unmovable MAX_ORDER chunks
>>> to not overlap the memory area where we would like to be able to remove
>>> memory.
>>
>> Yes, true. In the part where I bias placements of unmovable pages at
>> lower PFNs, additional steps would need to be taken. Specifically, the
>> lowest block MAX_ORDER_NR_PAGES used for movable pages would need to be
>> reclaimed for unmovable allocations.
>
> I think sparsemem can provide some memory maps that show where there are
> section of memory that are hot pluggable. So the MAX_ORDER blocks need
> to be categorized as to whether they are in such a section or not.

That makes the problem slightly easier. If sparsemem sections are aware of 
whether they are hotpluggable or not, __rmqueue_fallback() (from the 
list-based anti-frag patches) can be taught to never use those sections 
for unmovable allocations.

> If you
> need another MAX_ORDER block for an unmovable type of allocation then make
> sure that it is not marked as hotpluggable by sparsemem. If we are in an
> emergency situation were we must use a MAX_ORDER block that is currently
> hotpluggable for unmovable allocations then we need to trigger something
> in sparsmem that disabled hotplug for that memory section.
>

Which should be doable.

>> It's simply more complex. I believe it's doable. The main plus going for
>> the zone is that it is a clearly understood concept and it gives hard
>> guarantees.
>
> And it gives the sysadmin headaches and increases management VM management
> overhead because we now have more bits in the page struct that tell us
> about the zone that the page belongs to. Another distinction to worry
> about in the VM. If the limit is set too high then we have memory that is
> actually movable but since its on the wrong side of the limit we cannot
> use it. If the limit is set too low then the systewm will crash.
>

I'm aware of this. It believe it could all be done in the context of 
list-based - just that it requires more code. Zones are easier to 
understand for most people and their behavior is better understood. If a 
workload is discovered that list-based doesn't handle, the zone can be 
used until the problem is solved.

This is why the anti-fragmentation and zone-based approaches are no longer 
mutually exclusive as they were in earlier versions.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
