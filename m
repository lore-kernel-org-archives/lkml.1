Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYCUMqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYCUMqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYCUMqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:46:09 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37609 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbYCUMqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:46:07 -0400
Message-ID: <47E3ADE3.4030304@bull.net>
Date: Fri, 21 Mar 2008 13:45:23 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Scalability requirements for sysv ipc (was: ipc: store ipcs into
 IDRs)
References: <47E382DB.70503@colorfullife.com>
In-Reply-To: <47E382DB.70503@colorfullife.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Hi all,
> 
> I noticed that sysv ipc now uses very special locking: first a global 
> rw-semaphore, then within that semaphore rcu:
>  > linux-2.6.25-rc3:/ipc/util.c:
> 
>> struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
>> {
>>         struct kern_ipc_perm *out;
>>         int lid = ipcid_to_idx(id);
>>
>>         down_read(&ids->rw_mutex);
>>
>>         rcu_read_lock();
>>         out = idr_find(&ids->ipcs_idr, lid);
> 
> ids->rw_mutex is a per-namespace (i.e.: usually global) semaphore. Thus 
> ipc_lock writes into a global cacheline. Everything else is based on 
> per-object locking, especially sysv sem doesn't contain a single global 
> lock/statistic counter/...
> That can't be the Right Thing (tm): Either there are cases where we need 
> the scalability (then using IDRs is impossible), or the scalability is 
> never needed (then the remaining parts from RCU should be removed).
> I don't have a suitable test setup, has anyone performed benchmarks 
> recently?
> Is sysv semaphore still important, or have all apps moved to posix 
> semaphores/futexes?
> Nadia: Do you have access to a suitable benchmark?
> 
> A microbenchmark on a single-cpu system doesn't help much (except that 
> 2.6.25 is around factor 2 slower for sysv msg ping-pong between two 
> tasks compared to the numbers I remember from older kernels....)
> 

If I remember well, at that time I had used ctxbench and I wrote some 
other small scripts.
And the results I had were around 2 or 3% slowdown, but I have to 
confirm that by checking in my archives.

I'll also have a look at the remaining RCU critical sections in the code.

Regards,
Nadia


