Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYIAHS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYIAHS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYIAHSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:18:20 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51897 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYIAHSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:18:20 -0400
Message-ID: <48BB9723.9040802@linux.vnet.ibm.com>
Date: Mon, 01 Sep 2008 12:47:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, Pavel Emelianov <xemul@openvz.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080831174756.GA25790@balbir.in.ibm.com> <20080901090102.46b75141.kamezawa.hiroyu@jp.fujitsu.com> <200809011656.45190.nickpiggin@yahoo.com.au>
In-Reply-To: <200809011656.45190.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Monday 01 September 2008 10:01, KAMEZAWA Hiroyuki wrote:
>> On Sun, 31 Aug 2008 23:17:56 +0530
>>
>> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>> This is a rewrite of a patch I had written long back to remove struct
>>> page (I shared the patches with Kamezawa, but never posted them anywhere
>>> else). I spent the weekend, cleaning them up for 2.6.27-rc5-mmotm (29 Aug
>>> 2008).
>> It's just because I think there is no strong requirements for 64bit
>> count/mapcount. There is no ZERO_PAGE() for ANON (by Nick Piggin. I add him
>> to CC.) (shmem still use it but impact is not big.)
> 
> I think it would be nice to reduce the impact when it is not configured
> anyway. Normally I would not mind so much, but this is something that
> many distros will want to enable but fewer users will make use of it.
> 
> I think it is always a very good idea to try to reduce struct page size.
> When looking at the performance impact though, just be careful with the
> alignment of struct page... I actually think it is going to be a
> performance win in many cases to make struct page 64 bytes.
> 

I agree with the last point, but then when I see
http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg41546.html
I am tempted to reduce the size. I did ask Andi about on which x86_64 machines
are we exceeding the cache size, but heard nothing back.

The questions to answer are

1. On 64 bit systems, would be OK making the size of struct page 64 bytes
2. Are we OK with this approach, even though we might penalize 32 bit systems

> 
>>> I've tested the patches on an x86_64 box, I've run a simple test running
>>> under the memory control group and the same test running concurrently
>>> under two different groups (and creating pressure within their groups).
>>> I've also compiled the patch with CGROUP_MEM_RES_CTLR turned off.
>>>
>>> Advantages of the patch
>>>
>>> 1. It removes the extra pointer in struct page
>>>
>>> Disadvantages
>>>
>>> 1. It adds an additional lock structure to struct page_cgroup
>>> 2. Radix tree lookup is not an O(1) operation, once the page is known
>>>    getting to the page_cgroup (pc) is a little more expensive now.
>>>
>>> This is an initial RFC for comments
>>>
>>> TODOs
>>>
>>> 1. Test the page migration changes
>>> 2. Test the performance impact of the patch/approach
>>>
>>> Comments/Reviews?
>> plz wait until lockless page cgroup....
>>
>> And If you don't support radix-tree-delete(), pre-allocating all at boot is
>> better.
> 
> If you do that, it might even be an idea to allocate flat arrays with
> bootmem. It would just be slightly more tricky more tricky to fit this
> in with the memory model. But that's not a requirement, just an idea
> for a small optimisation.

Yes, I thought about it, but dropped it for two reasons

1. We don't want a static overhead (irrespective of the memory used and user pages)
2. Like you said, it means fitting into every memory model to get it right.

-- 
	Balbir
