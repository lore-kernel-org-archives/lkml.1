Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYHKSSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYHKSSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYHKSSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:18:45 -0400
Received: from gw.goop.org ([64.81.55.164]:47260 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYHKSSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:18:44 -0400
Message-ID: <48A08270.7080303@goop.org>
Date: Mon, 11 Aug 2008 11:18:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       npiggin@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
Subject: Re: [PATCH] stack and rcu interaction bug in smp_call_function_mask()
References: <20080808193753.GA21964@linux-os.sc.intel.com>	<200808101624.15112.nickpiggin@yahoo.com.au>	<489FBF6A.40402@goop.org> <20080810213421.70f61034@infradead.org>
In-Reply-To: <20080810213421.70f61034@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 10 Aug 2008 21:26:18 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Nick Piggin wrote:
>>     
>>> Nice debugging work.
>>>
>>> I'd suggest something like the attached (untested) patch as the
>>> simple fix for now.
>>>
>>> I expect the benefits from the less synchronized,
>>> multiple-in-flight-data global queue will still outweigh the costs
>>> of dynamic allocations. But if worst comes to worst then we just go
>>> back to a globally synchronous one-at-a-time implementation, but
>>> that would be pretty sad! 
>>>       
>> What if we went the other way and strictly used queue-per-cpu?  It
>> means multicast would require multiple enqueueing operations, which
>> is a bit heavy, but it does make dequeuing and lifetime management
>> very simple...
>>     
>
> as long as send-to-all is still one apic operation.. otherwise it gets
> *really* expensive....
> (just think about waking all cpus up out of their C-states.. one by one
> getting the full exit latency sequentially)
>   

Well, send-to-all can be special cased (is already at the apic IPI 
level, but we could have a broadcast queue as well).

But I wonder how common an operation that is?  Most calls to 
smp_call_function_mask are sending to mm->cpu_vm_mask.  For a small 
number of cores, that could well be broadcast, but as the core count 
goes up, the likelihood that all cpus have been involved with a given mm 
will go down (very workload dependent, of course).

It could be that if we're sending to more than some proportion of the 
cpus, it would be more efficient to just broadcast, and let the cpus 
work out whether they need to do anything or not.  But that's more or 
less the scheme we have now...

    J
