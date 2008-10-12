Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYJLWqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYJLWqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 18:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYJLWqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 18:46:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57513 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYJLWqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 18:46:35 -0400
Date: Sun, 12 Oct 2008 15:46:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
Message-ID: <20081012224629.GA7353@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <48F21D58.3000404@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F21D58.3000404@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 05:52:56PM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>> +/*
>> + * If the specified CPU is offline, tell the caller that it is in
>> + * a quiescent state.  Otherwise, whack it with a reschedule IPI.
>> + * Grace periods can end up waiting on an offline CPU when that
>> + * CPU is in the process of coming online -- it will be added to the
>> + * rcu_node bitmasks before it actually makes it online.  Because this
>> + * race is quite rare, we check for it after detecting that the grace
>> + * period has been delayed rather than checking each and every CPU
>> + * each and every time we start a new grace period.
>> + */
>
> What about using CPU_DYING and CPU_STARTING?
>
> Then this race wouldn't exist anymore.

Because I don't want to tie RCU too tightly to the details of the
online/offline implementation.  It is too easy for someone to make a
"simple" change and break things, especially given that the online/offline
code still seems to be adjusting a bit.

So I might well use CPU_DYING and CPU_STARTING, but I would still keep
the check offlined CPUs in the force_quiescent_state() processing.

>> +static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
>> +{
>> + [snip]
>> +       case RCU_FORCE_QS:
>> +
>> +               /* Check dyntick-idle state, send IPI to laggarts. */
>> +               if (rcu_process_dyntick(rsp, 
>> dyntick_recall_completed(rsp),
>> +                                       rcu_implicit_dynticks_qs))
>> +                       goto unlock_ret;
>> +
>> +               /* Leave state in case more forcing is required. */
>> +
>> +               break;
>
> Hmm - your code must loop multiple times over the cpus.
> I've use a different approach: More forcing is only required for a nohz cpu 
> when it was hit within a long-running interrupt.
> Thus I've added a '->kick_poller' flag, rcu_irq_exit() reports back when 
> the long-running interrupt completes. Never more than one loop over the 
> outstanding cpus is required.

Do you send a reschedule IPI to CPUs that are not in dyntick idle mode,
but who have failed to pass through a quiescent state?

In my case, more forcing is required only for a nohz CPU in a long-running
interrupt (as with your approach), for sending the aforementioned IPI,
and for checking for offlined CPUs as noted above.

							Thanx, Paul
