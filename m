Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZLWERN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZLWERN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZLWERH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:17:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:39457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZLWERF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:17:05 -0500
Message-ID: <4B319A20.9010305@kernel.org>
Date: Wed, 23 Dec 2009 13:18:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org>	 <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org>	 <1261387377.4314.37.camel@laptop>  <4B2F7879.2080901@kernel.org>	 <1261405604.4314.154.camel@laptop>  <4B3009DC.7020407@kernel.org> <1261480001.4937.21.camel@laptop>
In-Reply-To: <1261480001.4937.21.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/22/2009 08:06 PM, Peter Zijlstra wrote:
> On Tue, 2009-12-22 at 08:50 +0900, Tejun Heo wrote:
>>
>>>  3) gets fragile at memory-pressure/reclaim
>>
>> Shared dynamic pool is going to be affected by memory pressure no
>> matter how you implement it.  cmwq tries to maintain stable level of
>> workers and has forward progress guarantee.  If you're gonna do shared
>> pool, it can't get much better. 
> 
> And here I'm questioning the very need for shared stuff, I don't see
> any. That is, I'm not seeing it being worth the hassle.

Then you see the situation pretty different from the way I do.  Maybe
it's caused by the different things we work on.  Whenever I want to
create something which would need async context, I'm always faced with
these tradeoffs that I think is silly to worry about at that layer.
It ends up scattering partial solutions all over the place.

libata has two workqueues just because one may depend on the other.
The workqueue used for polling is MT to increase parallelism in case
there are multiple devices which would require polling but it's both
wasteful and not enough - they won't be used most of the time but they
aren't enough when there are multiple pollers on the same CPU.  libata
just had to make a rather mediocre in-the-middle tradeoff between
having one poller for each device and sharing single poller for all
devices.

The same goes for EH threads.  How often they are used heavily depends
on the system configuration.  For example, libata handles ATAPI CHECK
CONDITION as an exception and acquire sense data from the exception
handler and it happens pretty frequently.  So, I want to have
per-device EHs and have ideas on how to escalate from device level EH
to host level EH.  The problem here again is how to maintain the
concurrency because having a single kthread for each block device
won't be acceptable from scalability POV.

Another similar but less severe problem is in-kernel media presence
pollers.  Here, I think I can have a single poller for each device
without having too many scalability issues but it just isn't efficient
because most of the time one poller would be enough.  It's only when
you get to the corner cases or error conditions when you would need
more than one.  So, again, I can implement a special poller pool for
this one.

And there are slow work and async both of which are there just to
provide process context to tasks which may take quite some time to
complete waiting for IOs and quite a few ST workqueues which got
separated out because they somehow got involved in some obscure
deadlock condition and the only reason they're ST is because MT would
create too many threads.  CPU affinity would work better for them but
they have to make these tradeoffs.

So, if we can have a mehanism which can solve these issues, it's an
obvious plus.  Shifting complexity out of peripheral code to better
crafted and managed core code is the right thing to do and it will
shift a lot of complexity out of peripheral codes.

Thanks.

-- 
tejun
