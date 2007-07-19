Return-Path: <linux-kernel-owner+w=401wt.eu-S965398AbXGSSLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398AbXGSSLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbXGSSLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:11:19 -0400
Received: from gw.goop.org ([64.81.55.164]:38333 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbXGSSLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:11:17 -0400
Message-ID: <469FA908.8090804@goop.org>
Date: Thu, 19 Jul 2007 11:10:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] sched: implement cpu_clock(cpu) high-speed time	source,
  take #2
References: <469F75AF.5080000@goop.org> <20070719143528.GA8278@elte.hu> <469F793E.6030006@goop.org> <20070719145058.GA11971@elte.hu> <469F7D7A.204@goop.org> <20070719150955.GA19373@elte.hu> <469F8179.2060802@goop.org> <20070719154254.GA24225@elte.hu> <20070719154449.GA28998@elte.hu> <469F8D28.1010304@goop.org> <20070719172403.GU11657@kernel.dk>
In-Reply-To: <20070719172403.GU11657@kernel.dk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Jul 19 2007, Jeremy Fitzhardinge wrote:
>   
>>> Index: linux/block/blktrace.c
>>> ===================================================================
>>> --- linux.orig/block/blktrace.c
>>> +++ linux/block/blktrace.c
>>> @@ -41,7 +41,7 @@ static void trace_note(struct blk_trace 
>>>  		const int cpu = smp_processor_id();
>>>  
>>>  		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
>>> -		t->time = sched_clock() - per_cpu(blk_trace_cpu_offset, cpu);
>>> +		t->time = cpu_clock(cpu) - per_cpu(blk_trace_cpu_offset, cpu);
>>>  		t->device = bt->dev;
>>>  		t->action = action;
>>>  		t->pid = pid;
>>> @@ -159,7 +159,7 @@ void __blk_add_trace(struct blk_trace *b
>>>  
>>>  		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
>>>  		t->sequence = ++(*sequence);
>>> -		t->time = sched_clock() - per_cpu(blk_trace_cpu_offset, cpu);
>>> +		t->time = cpu_clock(cpu) - per_cpu(blk_trace_cpu_offset, cpu);
>>>   
>>>       
>> What's this measuring here?  Time spend in IO?  Wouldn't it be better
>> off with a measurement of real monotonic time?
>>     
>
> It's not time spent in IO, it wants a nanosecond timestamp.
>   

What kind of nanoseconds?  Real?  Virtual?

sched_clock() (and now cpu_clock()) measure the number of nanoseconds
available for running CPU instructions (regardless of whether it chooses
to use them or not), and so in a virtual environment doesn't include
time stolen by the hypervisor for other VCPUs.

    J
