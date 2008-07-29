Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYG2Bt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYG2Bt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYG2BtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:49:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:49194 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277AbYG2BtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:49:03 -0400
Message-ID: <488E76A2.9050804@kernel.org>
Date: Tue, 29 Jul 2008 10:47:14 +0900
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
References: <487AEAC6.60307@kernel.org> <1216188469.5232.0.camel@twins>	 <487D98AC.3020005@kernel.org> <1217258001.18049.7.camel@twins>
In-Reply-To: <1217258001.18049.7.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 29 Jul 2008 01:47:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>>> If you need preempt off you need it for other reasons than RCU, so
>>> mixing it in the interface doesn't make sense to me.
>> Hmmm... the point of the interface is avoiding doing double preemption
>> operations as on common configurations rcu_read_lock() disables
>> preemption.
> 
> Should be really cheap then, because the cacheline is already hot.

Yeah, it is, so it is eventually a peripheral issue.

>>   Yes, it's for different purposes but we have two partially
>> overlapping ops and implementing combined / collapsed ops for such cases
>> is acceptable, I think.
> 
> They only overlap for !PREEMPT_RCU || !PREEMPT_RT

That part is pretty large tho.

>> Using get_cpu() or separate preempt_disable() wouldn't incur noticeable
>> performance difference as preemption is really cheap to manipulate but
>> both per-cpu and RCU are for performance optimization and I think having
>> combined ops is a good idea.
> 
> I don't as its a nightmare to sort out on -rt, where get_cpu() can be
> converted to get_cpu_locked(), and rcu_read_lock() never disables
> preemption.
> 
> If you convert it to use get_cpu() the conversion is easy, if you
> introduce this collapsed primitive we're up shit creek because it
> doesn't map.

I don't get it.  So, rcu_read_lock(); preempt_disable(); doesn't map for RT?

> Nor does it tell us why you need preempt disabled. Making it just as bad
> as open-coded preempt_disable()s.

Heh.. the code probably would have used preempt_disable() if it were not
for the combined ops, so the objection is about using preempt_disable()?

-- 
tejun
