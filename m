Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbXDKH2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbXDKH2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXDKH2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:28:47 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:21253 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750948AbXDKH2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:28:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=vmeHPqkhFi0RsbVauIyzR5/jexK7yGkm5w8LAmwG/W12nc+WIIFTShe4Ac78tDYNDE/mqlfyFFjJjd9+cFQl+IHZbnXcTgRUvKk8jl0RbGQUsDyMDPgkKLfrdt04PRsVfzIy3lbknT+hZM/e5Y8FV1kpyJE92hxu3lNvzxtZp14=  ;
X-YMail-OSG: _1jDduMVM1le8P9Yj__hr.CjYuUHquHMsw3WHP3N6mpNYhFQ9XoDQDwinBzYolRv4WP_hu1M0g--
Message-ID: <461C8E27.4080208@yahoo.com.au>
Date: Wed, 11 Apr 2007 17:28:39 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <Pine.LNX.4.64.0704061546590.6730@woody.linux-foundation.org> <4616D9C5.7020707@garzik.org>
In-Reply-To: <4616D9C5.7020707@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Linus Torvalds wrote:
> 
>>
>> On Fri, 6 Apr 2007, Jeff Garzik wrote:
>>
>>> I would rather change the implementation under the hood to start per-CPU
>>> threads on demand, similar to a thread-pool implementation.
>>>
>>> Boxes with $BigNum CPUs probably won't ever use half of those threads.
>>
>>
>> The counter-argument is that boxes with $BigNum CPU's really don't 
>> hurt from it either, and having per-process data structures is often 
>> simpler and more efficient than trying to have some thread pool.
> 
> 
> Two points here:
> 
> * A lot of the users in the current kernel tree don't rely on the 
> per-CPU qualities.  They just need multiple threads running.
> 
> * Even with per-CPU data structures and code, you don't necessarily have 
> to keep a thread alive and running for each CPU.  Reap the ones that 
> haven't been used in $TimeFrame, and add thread creation to the slow 
> path that already exists in the bowels of schedule_work().
> 
> Or if some kernel hacker is really motivated, all workqueue users in the 
> kernel would benefit from a "thread audit", looking at working 
> conditions to decide if the new kthread APIs are more appropriate.

spawn on demand would require heuristics and complexity though. And
I think there is barely any positive tradeoff to weigh it against.

>> IOW, once we get the processes off the global list, there just isn't 
>> any downside from them. Sure, they use some memory, but people who buy 
>> 1024-cpu machines won't care about a few kB per CPU..
>>
>> So the *only* downside is literally the process list, and one 
>> suggested patch already just removes kernel threads entirely from the 
>> parenthood lists.
>>
>> The other potential downside could be "ps is slow", but on the other 
>> hand, having the things stick around and have things like CPU-time 
>> accumulate is probably worth it - if there are some issues, they'd 
>> show up properly accounted for in a way that process pools would have 
>> a hard time doing.
> 
> 
> Regardless of how things are shuffled about internally, there will 
> always be annoying overhead /somewhere/ when you have a metric ton of 
> kernel threads.  I think that people should also be working on ways to 
> make the kernel threads a bit more manageable for the average human.

There are a few per CPU, but they should need no human management to
speak of.

Presumably if you have a 1024 CPU system, you'd generally want to be
running at least 1024 of your own processes there, so you already need
some tools to handle that magnitude of processes anyway.

>> So I really don't think this is worth changing things over, apart from 
>> literally removing them from process lists, which I think everybody 
>> agrees we should just do - it just never even came up before!
> 
> 
> I think there is a human downside.  For an admin you have to wade 
> through a ton of processes on your machine, if you are attempting to 
> evaluate the overall state of the machine.  Just google around for all 
> the admins complaining about the explosion of kernel threads on 
> production machines :)

User tools should be improved. It shouldn't be too hard to be able to
aggregate kernel thread stats into a single top entry, for example.

I'm not saying the number of threads couldn't be cut down, but there
is still be an order of magnitude problem there...

-- 
SUSE Labs, Novell Inc.
