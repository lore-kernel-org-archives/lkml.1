Return-Path: <linux-kernel-owner+w=401wt.eu-S933884AbXC1XhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbXC1XhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934004AbXC1XhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:37:07 -0400
Received: from mail.tmr.com ([64.65.253.246]:52001 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933884AbXC1XhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:37:05 -0400
Message-ID: <460AFC35.5070806@tmr.com>
Date: Wed, 28 Mar 2007 19:37:25 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: davids@webmaster.com
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: RSDL v0.31
References: <20070321075033.GA10368@elte.hu> <MDEHLPKNGKAHNMBLJOLKEEMNCGAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEMNCGAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
>> there were multiple attempts with renicing X under the vanilla
>> scheduler, and they were utter failures most of the time. _More_ people
>> complained about interactivity issues _after_ X has been reniced to -5
>> (or -10) than people complained about "nice 0" interactivity issues to
>> begin with.
> 
> Unfortunately, nicing X is not going to work. It causes X to pre-empt any
> local process that tries to batch requests to it, defeating the batching.
> What you really want is X to get scheduled after the client pauses in
> sending data to it or has sent more than a certain amount. It seems kind of
> crazy to put such login in a scheduler.
> 
> Perhaps when one process unblocks another, you put that other process at the
> head of the run queue but don't pre-empt the currently running process. That
> way, the process can continue to batch requests, but X's maximum latency
> delay will be the quantum of the client program.

In general I think that's the right idea. See below for more...
> 
>> The vanilla scheduler's auto-nice feature rewards _behavior_, so it gets
>> X right most of the time. The fundamental issue is that sometimes X is
>> very interactive - we boost it then, there's lots of scheduling but nice
>> low latencies. Sometimes it's a hog - we penalize it then and things
>> start to batch up more and we get out of the overload situation faster.
>> That's the case even if all you care about is desktop performance.
>>
>> no doubt it's hard to get the auto-nice thing right, but one thing is
>> clear: currently RSDL causes problems in areas that worked well in the
>> vanilla scheduler for a long time, so RSDL needs to improve. RSDL should
>> not lure itself into the false promise of 'just renice X statically'. It
>> wont work. (You might want to rewrite X's request scheduling - but if so
>> then i'd like to see that being done _first_, because i just dont trust
>> such 10-mile-distance problem analysis.)
> 
> I am hopeful that there exists a heuristic that both improves this problem
> and is also inherently fair. If that's true, then such a heuristic can be
> added to RSDL without damaging its properties and without requiring any
> special settings. Perhaps longer-term latency benefits to processes that
> have yielded in the past?
> 
> I think there are certain circumstances, however, where it is inherently
> reasonable to insist that 'nice' be used. If you want a CPU-starved task to
> get more than 1/X of the CPU, where X is the number of CPU-starved tasks,
> you should have to ask for that. If you want one CPU-starved task to get
> better latency than other CPU-starved tasks, you should have to ask for
> that.

I agree for giving a process more than a fair share, but I don't think 
"latency" is the best term for what you describe later. If you think of 
latency as the time between a process unblocking and the time when it 
gets CPU, that is a more traditional interpretation. I'm not really sure 
latency and CPU-starved are compatible.

I would like to see processes at the head of the queue (for latency) 
which were blocked for long term events, keyboard input, network input, 
mouse input, etc. Then processes blocked for short term events like 
disk, then processes which exhausted their time slice. This helps 
latency and responsiveness, while keeping all processes running.

A variation is to give those processes at the head of the queue short
> 
> Fundamentally, the scheduler cannot do it by itself. You can create cases
> where the load is precisely identical and one person wants X and another
> person wants Y. The scheduler cannot know what's important to you.
> 
> DS
> 
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
