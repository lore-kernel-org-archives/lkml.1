Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYHYPrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYHYPrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYHYPrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:47:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbYHYPrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:47:47 -0400
Message-ID: <48B2D3BE.40101@linux-foundation.org>
Date: Mon, 25 Aug 2008 10:46:06 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: paulmck@linux.vnet.ibm.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather	than
 rcu
References: <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com>	 <48AEC6B2.1080701@linux-foundation.org>	 <20080822151156.GA6744@linux.vnet.ibm.com>	 <48AEF3FD.70906@linux-foundation.org>	 <20080822182915.GG6744@linux.vnet.ibm.com>	 <48AF0735.60402@linux-foundation.org>	 <20080822195226.GJ6744@linux.vnet.ibm.com>	 <48AF1B81.3050806@linux-foundation.org>	 <20080822205339.GK6744@linux.vnet.ibm.com> <1219660291.8515.20.camel@twins>	 <20080825151220.GA6745@linux.vnet.ibm.com> <1219677736.8515.69.camel@twins>
In-Reply-To: <1219677736.8515.69.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>
> If we combine these two cases, and flip the counter as soon as we've
> enqueued one callback, unless we're already waiting for a grace period
> to end - which gives us a longer window to collect callbacks.
> 
> And then the rcu_read_unlock() can do:
> 
>   if (dec_and_zero(my_counter) && my_index == dying)
>     raise_softirq(RCU)
> 
> to fire off the callback stuff.
> 
> /me ponders - there must be something wrong with that...
> 
> Aaah, yes, the dec_and_zero is non trivial due to the fact that its a
> distributed counter. Bugger..

Then lets make it per cpu. If we get the cpu ops in then dec_and_zero would be
very cheap.


