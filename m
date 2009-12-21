Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZLUOTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZLUOTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZLUOT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:19:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:60056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbZLUOT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:19:28 -0500
Message-ID: <4B2F83F6.2040705@kernel.org>
Date: Mon, 21 Dec 2009 23:19:34 +0900
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
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box> <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk> <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org> <4B2F7DD2.2080902@linux.intel.com>
In-Reply-To: <4B2F7DD2.2080902@linux.intel.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arjan.

On 12/21/2009 10:53 PM, Arjan van de Ven wrote:
> I'm just wondering if even that is overkill; I suspect you can do
> entirely without the scheduler intrusion;
> just make a new thread for each work item, with some hesteresis:
>
> * threads should stay around for a bit before dying (you do that)
> * after some minimum nr of threads (say 4 per cpu), you wait, say, 0.1
> seconds before deciding it's time
>   to spawn more threads, to smooth out spikes of very short lived stuff.
> 
> wouldn't that be a lot simpler than "ask the scheduler to see if
> they are all blocked". If they are all very busy churning cpu (say
> doing raid6 work, or btrfs checksumming) you still would want more
> threads I suspect

Ah... okay, there are two aspects cmwq invovles the scheduler.

A. Concurrency management.  This is achieved by the scheduler
   callbacks which watches how many workers are working.

B. Deadlock avoidance.  This requires migrating rescuers to CPUs under
   allocation distress.  The problem here is that
   set_cpus_allowed_ptr() doesn't allow migrating tasks to CPUs which
   are online but !active (CPU_DOWN_PREPARE).

B would be necessary in whichever way you implement shared worker pool
unless you create all the workers which might possibly be necessary
for allocation.

For A, it's far more efficient and robust with scheduler callbacks.
It's conceptually pretty simple too.  If you look at the patch which
actually implements the dynamic pool, the amount of code necessary for
implementing this part isn't that big.  Most of complexity in the
series comes from trying to sharing workers not the dynamic pool
management.  Even if it switches to timer based one, there simply
won't be much reduction in complexity.  So, I don't think there's any
reason to choose rather fragile heuristics when it can be implemented
in a pretty mechanical way.

Thanks.

-- 
tejun
