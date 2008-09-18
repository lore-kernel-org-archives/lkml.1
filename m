Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYIRRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYIRRqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbYIRRqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:46:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34667 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbYIRRqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:46:32 -0400
Date: Thu, 18 Sep 2008 10:46:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] rcu: introduce kfree_rcu()
Message-ID: <20080918174619.GA28186@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48D1D694.9010802@cn.fujitsu.com> <20080918064406.GC6397@linux.vnet.ibm.com> <48D2882B.9060806@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D2882B.9060806@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 06:56:11PM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>> On Thu, Sep 18, 2008 at 12:18:28PM +0800, Lai Jiangshan wrote:
>>   
>>> sometimes a rcu callback is just calling kfree() to free a struct's 
>>> memory
>>> (we say this callback is a trivial callback.).
>>> this patch introduce kfree_rcu() to do these things directly, easily.
>>>     
>>
>> Interesting!  Please see questions and comments below.
>>
>>   
>>> There are 4 reasons that we need kfree_rcu():
>>>
>>> 1) unloadable modules:
>>>    a module(rcu callback is defined in this module) using rcu must
>>>    call rcu_barrier() when unload. rcu_barrier() will increase
>>>    the system's overhead(the more cpus the worse) and
>>>    rcu_barrier() is very time-consuming. if all rcu callback defined
>>>    in this module are trivial callback, we can just call kfree_rcu()
>>>    instead, save a rcu_barrier() when unload.
>>>     
> Hmm: why is rcu_barrier() sufficient to prevent races?
> Offlining a cpu reorders rcu callbacks - rcu_barrier() can return before 
> all previous call_rcu() callbacks were called.

The rcu_barrier() family of functions registers a callback on each CPU,
and waits until all these callbacks have been invoked.  The CPU offlining
process preserves the order of the callbacks that were registered on a
given CPU.  Thus, when rcu_barrier() returns, all RCU callbacks previously
registered are guaranteed to have already been invoked, regardless of
what CPUs might have been offlined and onlined in the meantime.

							Thanx, Paul
