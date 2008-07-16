Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYGSKXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYGSKXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYGSKWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:22:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:51437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbYGSKW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:22:28 -0400
Message-ID: <487D98AC.3020005@kernel.org>
Date: Wed, 16 Jul 2008 15:43:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] RCU: implement rcu_read_[un]lock_preempt()
References: <487AEAC6.60307@kernel.org> <1216188469.5232.0.camel@twins>
In-Reply-To: <1216188469.5232.0.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Jul 2008 10:21:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-07-14 at 14:57 +0900, Tejun Heo wrote:
>> With the introduction of preemptible RCU, RCU doesn't gurantee that
>> its critical section runs on the CPU it started to run.  As there are
>> cases where non-preemptible RCU critical section makes sense, create
>> new RCU read lock variants which turns of preemption -
>> rcu_read_[un]lock_preempt() which are identical to rcu_read_[un]lock()
>> for classic implementation and have enclosing preempt disable/enable
>> for preemptible RCU.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Sorry, NAK.
> 
> If you need preempt off you need it for other reasons than RCU, so
> mixing it in the interface doesn't make sense to me.

Hmmm... the point of the interface is avoiding doing double preemption
operations as on common configurations rcu_read_lock() disables
preemption.  Yes, it's for different purposes but we have two partially
overlapping ops and implementing combined / collapsed ops for such cases
is acceptable, I think.

Using get_cpu() or separate preempt_disable() wouldn't incur noticeable
performance difference as preemption is really cheap to manipulate but
both per-cpu and RCU are for performance optimization and I think having
combined ops is a good idea.

I wonder what other people think.  If it's agreed that having combined
ops is a bad idea, I'll convert it to get_cpu().

Thanks.

-- 
tejun
