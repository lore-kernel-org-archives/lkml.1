Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYIQFDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYIQFDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 01:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYIQFD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 01:03:27 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:57532 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750817AbYIQFD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 01:03:27 -0400
Message-ID: <48D08F3F.2050501@linux.vnet.ibm.com>
Date: Wed, 17 Sep 2008 10:31:51 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       a.p.zijlstra@chello.nl, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/1]: timers: Timer Migration
References: <20080916091219.GA1068@linux.vnet.ibm.com> <20080916065345.76d052e1@infradead.org>
In-Reply-To: <20080916065345.76d052e1@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 16 Sep 2008 14:42:31 +0530
> Arun R Bharadwaj <arun@linux.vnet.ibm.com> wrote:
>
>   
>> Hi,
>>
>> An idle cpu on which device drivers have initialized timers, has to
>> be frequently woken up to service the timers. So, consolidation of
>> timers onto a fewer number of cpus is important. Migration of timers
>> from idle cpus onto lesser idle cpus is necessary. Currently, timers
>> are migrated during the cpu offline operation. However cpu-hotplug
>> for the sake of idle system power management is too heavy. So, this
>> patch implements a lightweight timer migration framework.
>>     
>
> while I absolutely like reducing power consumption... I'm not sure this
> helps or is the right approach.
>
> First of all, it's of course absolutely better to fix timers and apps
> that cause them (and with PowerTOP we fixed basically all the bad
> stuff).
>
> Second, in terms of power; a wake up is a wake up, it doesn't really
> matter where it happens. 
>   


This is a very valid point. The algorithm which decides which cpu to
migrate the timers to should be intelligent enough in the sense that it
migrates *only* when there is some benefit out of it. That is, the cpu
to which the timers are being migrated, is sufficiently busy and it is
not unnecessarily brought out of its idle state. Else, as you pointed
out, the penalty of wake up is same for either of the cpu.


> Now we could do some consolidation (which realistically needs the range
> timer feature that's aimed for 2.6.28), but I would much rather do that
> in a different way: rather than actively moving stuff, I would instead
> suggest sharing the timer queues between logical cpus that share the
> same cache. (Now its an admin choice if he wants this on a "shared L1",
> "shared L2" or "shared L3" basis). 
>   


While migrating range timers, I would migrate only if the time range of
the source and destination cpus match. Else, there is no point in
migrating. I would rather look at timer migration as an optimization
strategy to increase the cpu idle time and not as a pro-active method to
rid the cpu of timers, no matter what. I would like to migrate timers
only if the wake up penalty of the system as a whole decreases.


> Or if you want to forcefully migrate timers, don't move existing ones,
> just on queue/requeue put the on not-the-local-cpu. Sure they'll fire
> once on the "wrong" cpu, but that's a very short term problem!
>
>   

