Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZE0Aa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZE0Aa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZE0Aav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:30:51 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:50469 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbZE0Aau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IpA0Po91ueuGMAKtRR6d62jyLoFy2j11evbZG5OTJYvh5ojsjoX6TOHTKW/imThxgX
         eOOR37gOhZMu6Z0rZjJmwVGe91Vk8U21kvp+uTVzHW1Z+OabWUR+pu6h2tPeLGTeYEGA
         qGgT/fUsjHU9JK3k6pkuH30EwwsOm2NUaCz9o=
MIME-Version: 1.0
In-Reply-To: <1243346374.23657.9.camel@twins>
References: <20090526215442.2dbd888b@linux-lm> <1243346374.23657.9.camel@twins>
Date: Wed, 27 May 2009 08:30:51 +0800
Message-ID: <d82e647a0905261730k76c0fb32v3c38deb4f17736b2@mail.gmail.com>
Subject: Re: [RFC] kernel/lockdep: use BFS(breadth-first search) algorithm to 
	search target
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/26 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Tue, 2009-05-26 at 21:54 +0800, Ming Lei wrote:
>> Hi,All
>>
>> Currently lockdep uses recursion DFS(depth-first search) algorithm to
>> search target in checking lock circle(check_noncircular()),irq-safe
>> -> irq-unsafe(check_irq_usage()) and irq inversion when adding a new
>> lock dependency. I plan to replace the current DFS with BFS, based on
>> the following consideration:
>>
>>       1,no loss of efficiency, no matter DFS or BFS, the running time
>>       are O(V+E) (V is vertex count, and E is edge count of one
>>       graph);
>>
>>       2,BFS may be easily implemented by circular queue and consumes
>>       much less kernel stack space than DFS for DFS is implemented by
>>       recursion, we know kernel stack is very limited, eg. 4KB.
>>
>>       3, The shortest path can be obtained by BFS if the target is
>>       found, but can't be got by DFS. By the shortest path, we can
>>       shorten the lock dependency chain and help to troubleshoot lock
>>       problem easier than before.

Another case, there are several lock_list instances in one lock dependency graph
,which all points to one lock_class, BFS can find the one with
shortest distance,but
DFS can't.   The scenario should be common, right?

Thanks.

>>
>> Any suggestions, objections or viewpoint?
>
> Ah, replace the full cycle detection might be worth it, esp with that
> pre-allocated stack you used. Its all serialized on the graph lock
> anyway.
>
> I'm not sure about 3, though, since we search on adding a each new
> dependency we'll only ever have a choice between cycles when one new
> dependency generates two cycles at the same time. Something I think is
> rare.
>
> But yes, it wuold be nice to get rid of the current recursive algorithm
> there.
>
>



-- 
Lei Ming
