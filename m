Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZJATDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZJATDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZJATDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:03:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbZJATDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:03:04 -0400
Message-ID: <4AC4FC47.4010405@redhat.com>
Date: Thu, 01 Oct 2009 21:00:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 03/19] scheduler: implement workqueue scheduler class
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-4-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain> <20091001184824.GA21357@elte.hu>
In-Reply-To: <20091001184824.GA21357@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 08:48 PM, Ingo Molnar wrote:
> We could do what Avi suggested: not use scheduler classes at all for
> this (that brings in other limitations like lack of p->policy freedom),
> but use the existing preempt-notifications callbacks.
>
> They are per task - we would simply make preempt notifiers
> unconditional, i.e. remove CONFIG_PREEMPT_NOTIFIERS and make it all
> unconditional scheduler logic.
>
>    

Sure, but it would mean that we need a new notifier.  sched_out, 
sched_in, and wakeup (and, return to userspace, with the new notifier).

btw, I've been thinking we should extend concurrency managed workqueues 
to userspace.  Right now userspace can spawn a massive amount of 
threads, hoping to hide any waiting by making more work available to the 
scheduler.  That has the drawback of increasing latency due to 
involuntary preemption.  Or userspace can use one thread per cpu, hope 
it's the only application on the machine, and go all-aio.

But what if we added a way for userspace to tell the kernel to fork off 
threads when processing power and work to do are both available?  The 
scheduler knows when there is processing power, and an epoll fd can tell 
it when there is work to do.  So the scheduler will create threads to 
saturate the processors, if one of them waits for I/O the scheduler 
forks off another one until all queues are busy again.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

