Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbZJAQ4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbZJAQ4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZJAQ4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:56:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:50077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbZJAQ4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:56:11 -0400
Message-ID: <4AC4DF07.2090202@kernel.org>
Date: Fri, 02 Oct 2009 01:55:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed	workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <20091001084040.GA15345@elte.hu> <4AC4725E.3070509@redhat.com>
In-Reply-To: <4AC4725E.3070509@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 16:55:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Avi Kivity wrote:
> On 10/01/2009 10:40 AM, Ingo Molnar wrote:
>> Ok, this looks fairly interesting - and the way you reused scheduler
>> classes to auto-regulate with no impact on regular performance is quite
>> an ingenious idea as well. (KVM's preempt notifiers should probably use
>> this trick too, instead of an ugly notifier in the scheduler hotpath)
>>
>> This mechanism could be used to implement threadlets/syslets too btw.,
>> and other forms of asynchronous IO.
>>    
> 
> In fact I've thought of implementing threadlets and concurrency-managed
> workqueues with preempt notifiers ;)

:-)

> Isn't a scheduling class overkill for two existing callbacks?  Note we
> can easily use a thread flag and __switch_to_xtra() to avoid the overhead.

The partial overriding only takes about seventy lines of code and is
conceptually trivial.  I don't think it's an overkill.

> For kvm, we don't want to force a specific scheduling class for vcpu
> threads, so we'd need infrastructure to create a new scheduling class
> out of an existing one to hook the two callbacks.  Seems like quite a
> lot of work, for something that is orthogonal to scheduling.
> 
> Tejun, would preempt notifiers work for your workqueues?  see bottom of
> include/linux/preempt.h.

I considered that but the thing is workqueue needs to know when a
thread wakes up not when it gets scheduled.  Of course we can add
another notifier op and call it from try_to_wake_up() but I really
didn't want to add yet another hook in a very hot path which will only
be useful for very small number of tasks but yet has to be called for
every operation and the sched_class mechanism means that we already
have hooks at all the interesting spots, so I think it's better to
make use of them instead of adding another set of callbacks.

Thanks.

-- 
tejun
