Return-Path: <linux-kernel-owner+w=401wt.eu-S932148AbXAWBbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbXAWBbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932164AbXAWBbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:31:45 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37167 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbXAWBbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:31:43 -0500
Message-ID: <45B56575.10807@in.ibm.com>
Date: Tue, 23 Jan 2007 07:01:33 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@suse.de>
CC: Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random>
In-Reply-To: <20070123003939.GY13798@opteron.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Tue, Jan 23, 2007 at 01:10:46AM +0100, Niki Hammler wrote:
>> Dear Linux Developers/Enthusiasts,
>>
>> For a course at my university I'm implementing parts of an operating
>> system where I get most ideas from the Linux Kernel (which I like very
>> much). One book I gain information from is [1].
>>
>> Linux uses for its Page Replacing Algorithm (based on LRU) *two* chained
>> lists - one active list and one active list.
>> I implemented my PRA this way too.
>>
>> No the big question is: WHY do I need *two* lists? Isn't it just
>> overhead/more work? Are there any reasons for that?
>>
>> In my opinion, it would be better to have just one just; pop frames to
>> be swapped out from the end of the list and push new frames in front of
>> it. Then just evaluate the frames and shift them around in the list.
>>
>> Is there any explanation why Linux uses two lists?
> 
> Back then I designed it with two lru lists because by splitting the
> active from the inactive cache allows to detect the cache pollution
> before it starts discarding the working set. The idea is that the
> pollution will enter and exit the inactive list without ever being
> elected to the active list because by definition it will never
> generate a cache hit. The working set will instead trigger cache hits
> during page faults or repeated reads, and it will be preserved better
> by electing it to enter the active list.
> 
> A page in the inactive list will be collected much more quickly than a
> page in the active list, so the pollution will be collected more
> quickly than the working set. Then the VM while freeing cache tries to
> keep a balance between the size of the two lists to avoid being too
> unfair, obviously at some point the active list have to be
> de-activated too. If your server "fits in ram" you'll find lots of
> cache to be active and so the I/O activity not part of the working set
> will be collected without affecting the working set much.

This makes me wonder if it makes sense to split up the LRU into page
cache LRU and mapped pages LRU. I see two benefits

1. Currently based on swappiness, we might walk an entire list
    searching for page cache pages or mapped pages. With these
    lists separated, it should get easier and faster to implement
    this scheme
2. There is another parallel thread on implementing page cache
    limits. If the lists split out, we need not scan the entire
    list to find page cache pages to evict them.

Of course I might be missing something (some piece of history)

-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
