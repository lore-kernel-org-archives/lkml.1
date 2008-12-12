Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYLLFM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYLLFM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYLLFMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:12:09 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:55003 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYLLFMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:12:06 -0500
Message-ID: <4941F26F.5030902@cosmosbay.com>
Date: Fri, 12 Dec 2008 06:11:11 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/7] fs: Use a percpu_counter to track nr_inodes
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <493100B0.6090104@cosmosbay.com> <4941968E.3020201@cosmosbay.com> <200707241130.56767.nickpiggin@yahoo.com.au>
In-Reply-To: <200707241130.56767.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 12 Dec 2008 06:11:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin a écrit :
> On Friday 12 December 2008 09:39, Eric Dumazet wrote:
>> Avoids cache line ping pongs between cpus and prepare next patch,
>> because updates of nr_inodes dont need inode_lock anymore.
>>
>> (socket8 bench result : no difference at this point)
> 
> Looks good.
> 
> But.... If we never actually need fast access to the approximate
> total, (which seems to apply to this and the previous patch) we
> could use something much simpler which does not have the spinlock
> or all this batching stuff that percpu counters have. I'd prefer
> that because it will be faster in a straight line...

Well, using a non batching mode could be real easy, just
call __percpu_counter_add(&counter, inc, 1<<30);

Or define a new percpu_counter_fastadd(&counter, inc);

percpu_counter are nice because handle the CPU hotplug problem,
if we want to use for_each_online_cpu() instead of
for_each_possible_cpu().

> 
> (BTW. percpu counters can't be used in interrupt context? That's
> nice.)
> 
> 

Not sure why you said this.

I would like to have a irqsafe percpu_counter, I was preparing such a
patch because we need it for net-next



