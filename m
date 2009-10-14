Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbZJNJap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbZJNJap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbZJNJap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:30:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbZJNJao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:30:44 -0400
Message-ID: <4AD59AC3.9020807@redhat.com>
Date: Wed, 14 Oct 2009 17:32:51 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ben Woodard <bwoodard@llnl.gov>,
       David Howells <dhowells@redhat.com>,
       Brian Behlendorf <behlendorf1@llnl.gov>
Subject: Re: [Patch v4] rwsem: fix rwsem_is_locked() bugs
References: <20091008092632.7101.62229.sendpatchset@localhost.localdomain> <20091013133419.3c8f5f21.akpm@linux-foundation.org>
In-Reply-To: <20091013133419.3c8f5f21.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 8 Oct 2009 05:23:53 -0400
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>> --- a/include/linux/rwsem-spinlock.h
>> +++ b/include/linux/rwsem-spinlock.h
>> @@ -71,7 +71,13 @@ extern void __downgrade_write(struct rw_semaphore *sem);
>>  
>>  static inline int rwsem_is_locked(struct rw_semaphore *sem)
>>  {
>> -	return (sem->activity != 0);
>> +	int ret = 1;
>> +
>> +	if (spin_trylock_irq(&sem->wait_lock)) {
>> +		ret = (sem->activity != 0);
>> +		spin_unlock_irq(&sem->wait_lock);
>> +	}
>> +	return ret;
>>  }
> 
> a) probably to large to be inlined


Yeah, maybe, I forgot spin_trylock_irq() and spin_unlock_irq
are macros.

> 
> b) the function will now cause bugs if called under
>    local_irq_disable().  That wasn't the case before.  Fixable via
>    spin_lock_irqsave().
> 
> In the present kernel there don't appear to be any irqs-off callers. 
> There may of course be some out-of-tree ones which will get bitten by
> this semantic change.
> 
> If we decide to leave this new rule in place then we should add a
> WARN_ON(irqs_disabled()) to prevent hitting people with a nasty, subtle
> bug.
> 
> Methinks that _irqsave() is better.


My bad, I misunderstood spin_lock_irqsave(), thus used spin_lock_irq().
:( Will update the patch now.

Thanks!
