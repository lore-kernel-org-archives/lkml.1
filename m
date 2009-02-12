Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbZBLIaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbZBLIaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 03:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZBLI3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 03:29:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbZBLI3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 03:29:54 -0500
Message-ID: <4993DD64.2090705@cn.fujitsu.com>
Date: Thu, 12 Feb 2009 16:27:16 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Paul Menage <menage@google.com>, Paul Jackson <pj@usa.net>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       Derek Fults <dfults@sgi.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the
 unallowed node when memory spread is set
References: <4976D77C.3020107@cn.fujitsu.com> <200902121154.02868.nickpiggin@yahoo.com.au> <6599ad830902111719n2750ac29u458face30bf3f7cb@mail.gmail.com> <200902121255.43047.nickpiggin@yahoo.com.au>
In-Reply-To: <200902121255.43047.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2009-2-12 9:55 Nick Piggin wrote:
> On Thursday 12 February 2009 12:19:11 Paul Menage wrote:
>> On Wed, Feb 11, 2009 at 4:54 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
> wrote:
>>> It would be possible, depending on timing, for the allocating thread to
>>> see either pre or post mems_allowed even if access was fully locked.
>> Right - seeing either the pre set or the post set is fine.
>>
>>> The only difference is that a partially changed mems_allowed could be
>>> seen. But what does this really mean? Some combination of the new and
>>> the old nodes. I don't think this is too much of a problem.
>> But if the old and new nodes are disjoint, that could lead to seeing no
>> nodes.
> 
> Well we could structure updates as setting all new allowed nodes,
> then clearing newly disallowed ones.

But it still has the other problem. such as: 
Task1							Task2
get_page_from_freelist()				while(1) {
{
	for_each_zone_zonelist_nodemask() {
								change Task1's mems_allowed
		if (!cpuset_zone_allowed_softwall())
			goto try_next_zone;
try_next_zone:
		...
	}
}							}

In the extreme case, Task1 will be completely unable to allocate memory
at worst. At least, it will lead to the delay of allocate pages. Though
the probability of this case is very low, we have to take into account.

Thanks!
Miao

> 
> 
>> Also, having the results of cpuset_zone_allowed() and
>> cpuset_current_mems_allowed change at random times over the course of
>> a call to alloc_pages() might cause interesting effects (e.g. we make
>> progress freeing pages from one set of nodes, and then call
>> get_page_from_freelist() on a different set of nodes).
> 
> But again, is this really a problem? We're talking about a tiny
> possibility in a very uncommon case anyway when the cpuset is
> changing.
> 
> If it can cause an outright error like OOM of course that's no
> good, but if it just requires us to go around the reclaim loop
> or allocate from another zone... I don't think that's so bad.
> 
> 
>>> This could work if we *really* need an atomic snapshot of mems_allowed.
>>> seqcount synchronisation would be an alternative too that could allow
>>> sleeping more easily than SRCU (OTOH if you don't need sleeping, then
>>> RCU should be faster than seqcount).
>>>
>>> But I'm not convinced we do need this to be atomic.
>> It's possible that I'm being overly-paranoid here. The decision to
>> make mems_allowed updates be purely pulled by the task itself predates
>> my involvement with cpusets code by a long time.
> 
> It's not such a bad model, but the problem with it is that it needs
> to be carefully spread over the VM, and in fastpaths too. Now if it
> were something really critical, fine, but I'm hoping we can do
> without.
> 
> 
> 
> 
> 


