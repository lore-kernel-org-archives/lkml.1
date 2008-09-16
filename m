Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYIPSXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYIPSXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYIPSXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:23:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40158 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbYIPSXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:23:09 -0400
Date: Tue, 16 Sep 2008 11:22:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
Message-ID: <20080916182247.GE6717@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <48CFE466.8010200@colorfullife.com> <20080916173012.GC6717@linux.vnet.ibm.com> <48CFF150.8070400@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CFF150.8070400@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 07:48:00PM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>>   
>>> That means an O(NR_CPUS) loop with disabled local interrupts :-(
>>> Is that correct?
>>>     
>>
>> With the definition of "O()" being the worst-case execution time, yes.
>> But this worst case could only happen when the system was mostly idle,
>> in which case the added overhead should not be too horribly bad.
>
> No: "was mostly running cpu_idle()". A cpu_idle() cpu could execute lots of 
> irqs and softirqs.
> So the worst case would be a system with 1 cpu/node for reserved for irq 
> handling.
> The "idle" cpu would be always in no_hz mode, even though it might be 100% 
> busy handling irqs.
> The remaning cpus might be 100% busy handling user space.
>
> And every quiescent state will end up in that O(NR_CPUS) loop.

Good point!

Indeed, if you had a 1024-CPU box acting as (say) a router/hub using
the Linux-kernel protocol stacks with no user-mode processing, then
you could indeed have the system mostly busy with no user-space code
running, and thus no quiescent states.

However, last I checked, almost all 1024-CPU boxes run HPC workloads
mostly in user mode, so this scenario would not occur.  However, again,
if it does come up, I would add an additional level of state machine
to the force_quiescent_state() family of functions, so that the scan
would be done incrementally.  Perhaps arranging for CPU groups to be
scanned by CPUs within that group.

But again, I don't want to take that step until I see someone actually
needing it.  Maybe the Vyatta guys will be there sooner than I think,
but...

							Thanx, Paul
