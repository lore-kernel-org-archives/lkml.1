Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYK1WsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYK1WsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 17:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYK1Wr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 17:47:57 -0500
Received: from smtp-out.google.com ([216.239.45.13]:60664 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYK1Wr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 17:47:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=YPHIIWqJqijuQVfHHb3o1Ezh9HNxTP4OT7pcykJ1mj5K0R8OkyWCMnOdJAlc5eJin
	be3sMjvC0Y7utS8Bw7Wog==
Message-ID: <493074D8.3080002@google.com>
Date: Fri, 28 Nov 2008 14:46:48 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ying Han <yinghan@google.com>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rohit Seth <rohitseth@google.com>,
       Hugh Dickins <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       edwintorok@gmail.com
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com> <20081123091843.GK30453@elte.hu> <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com> <20081126123246.GB23649@wotan.suse.de> <492DAA24.8040100@google.com> <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com> <1227780007.4454.1344.camel@twins> <20081127101436.GI28285@wotan.suse.de> <492EF391.1040408@google.com> <20081128094127.GC1818@wotan.suse.de>
In-Reply-To: <20081128094127.GC1818@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.19
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thu, Nov 27, 2008 at 11:22:57AM -0800, Mike Waychison wrote:
>> Nick Piggin wrote:
>>> On Thu, Nov 27, 2008 at 11:00:07AM +0100, Peter Zijlstra wrote:
>>> pagemap_read looks like it can use get_user_pages_fast. The smaps and
>>> clear_refs stuff might have been nicer if they could work on ranges
>>> like pagemap. Then they could avoid mmap_sem as well (although maps
>>> would need to be sampled and take mmap_sem I guess).
>>>
>>> One problem with dropping mmap_sem is that it hurts priority/fairness.
>>> And it opens a bit of a (maybe theoretical but not something to completely
>>> ignore) forward progress hole AFAIKS. If mmap_sem is very heavily
>>> contended, then the refault is going to take a while to get through,
>>> and then the page might get reclaimed etc).
>> Right, this can be an issue.  The way around it should be to minimize 
>> the length of time any single lock holder can sit on it.  Compared to 
>> what we have today with:
>>
>>   - sleep in major fault with read lock held,
>>   - enqueue writer behind it,
>>   - and make all other faults wait on the rwsem
>>
>> The retry logic seems to be a lot better for forward progress.
> 
> The whole reason why you have the latency is because it is
> guaranteeing forward progress for everyone. The retry logic
> may work out better in that situation, but it does actually
> open a starvation hole.
> 

Right.  In practice though, we haven't seen this cause a problem (and is 
why we'll only allow the path to retry once).

Do you have any suggestions on how we could plug this hole?   Perhaps we 
could pin a reference to the page in the vm_fault structure across the 
retry?
