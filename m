Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbZLUX6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbZLUX6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZLUX6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:58:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:48602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZLUX6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:58:44 -0500
Message-ID: <4B300C01.8080904@kernel.org>
Date: Tue, 22 Dec 2009 09:00:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box> <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk> <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org> <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org> <4B2F9212.3000407@linux.intel.com>
In-Reply-To: <4B2F9212.3000407@linux.intel.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/22/2009 12:19 AM, Arjan van de Ven wrote:
> On 12/21/2009 15:19, Tejun Heo wrote:
>>
>> Ah... okay, there are two aspects cmwq invovles the scheduler.
>>
>> A. Concurrency management.  This is achieved by the scheduler
>>     callbacks which watches how many workers are working.
>>
>> B. Deadlock avoidance.  This requires migrating rescuers to CPUs under
>>     allocation distress.  The problem here is that
>>     set_cpus_allowed_ptr() doesn't allow migrating tasks to CPUs which
>>     are online but !active (CPU_DOWN_PREPARE).
> 
> why would you get involved in what-runs-where at all? Wouldn't the
> scheduler load balancer be a useful thing ? ;-)

That's the way workqueues have been designed and used because its
primary purpose is to supply sleepable context and for that crossing
cpu boundaries is unnecessary overhead, so many of its users wouldn't
benefit from load balancing and some of them assume strong CPU
affinity.  cmwq's goal is to improve workqueues.  If you want to
implement something which would take advantage of processing
parallelism, it would need to be a separate mechanism (which may share
the API via out-of-range CPU affinty or something but still a separate
mechanism).

>> For A, it's far more efficient and robust with scheduler callbacks.
>> It's conceptually pretty simple too.
> 
> Assuming you don't get tasks that do lots of cpu intense work and
> that need to get preempted etc...like raid5/6 sync but also the
> btrfs checksumming etc etc.  That to me is the weak spot of the
> scheduler callback thing. We already have a whole thing that knows
> how to load balance and preempt tasks... it's called "scheduler".
> Let the scheduler do its job and just give it insight in the work
> (by having a runnable thread)

Yeah, sure, it's not suited for offloading CPU intensive workloads
(checksumming and encryption basically).  Workqueue interface was
never meant to be used by them - it has strong cpu affinity.  We need
something which is more parallelism aware for those.

Thanks.

-- 
tejun
