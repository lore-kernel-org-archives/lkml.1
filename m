Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbYJVVDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbYJVVDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYJVVC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:02:57 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34924 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbYJVVC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:02:56 -0400
Date: Wed, 22 Oct 2008 14:02:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
Message-ID: <20081022210254.GE6766@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <48F21D58.3000404@colorfullife.com> <20081012224629.GA7353@linux.vnet.ibm.com> <48F38D73.8040804@colorfullife.com> <20081015011143.GE6874@linux.vnet.ibm.com> <48F5A638.8020003@colorfullife.com> <20081015152637.GA6739@linux.vnet.ibm.com> <48FF73C7.90709@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF73C7.90709@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 08:41:11PM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>> Only once per such CPU every grace period -- seems in the noise to me.
>> But I should revisit, as I have changed things quite a bit since I
>> made that decision many weeks ago.  ;-)
>>
>>   
> Another small point:
> Does your implementation support rcu_check_callbacks() with cpu != 
> smp_processor_id()?
> I don't think my locking would support it properly.
> Thus:
> - cpu != smp_processor_id() doesn't work.
> - stack space for a useless parameter.
> - the explicit cpu parameter prevents the rcu code from using 
> get_cpu_var().
>
> What about modifying the rcu_check_callbacks() prototype? I'd propose to 
> remove the cpu parameter.

That would work fine for rcutree.c.  If I were to invoke
rcu_check_callbacks() remotely, I would use something like
smp_call_function() to make it happen.

Hmmm...  Looks like rcu_pending is also always called with its cpu
parameter set to the current CPU, and same for rcu_needs_cpu().
And given that all the external uses of rcu_check_callbacks() are
of the following form:

	if (rcu_pending(cpu))
		rcu_check_callbacks(cpu, whatever);


perhaps rcu_pending() should be an internal-to-RCU API invoked from
rcu_check_callbacks().

Thoughts?

							Thanx, Paul
