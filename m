Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbYJLPvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbYJLPvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 11:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbYJLPva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 11:51:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:10583 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbYJLPva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 11:51:30 -0400
Message-ID: <48F21D58.3000404@colorfullife.com>
Date: Sun, 12 Oct 2008 17:52:56 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com>
In-Reply-To: <20081010160930.GA9777@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> +/*
> + * If the specified CPU is offline, tell the caller that it is in
> + * a quiescent state.  Otherwise, whack it with a reschedule IPI.
> + * Grace periods can end up waiting on an offline CPU when that
> + * CPU is in the process of coming online -- it will be added to the
> + * rcu_node bitmasks before it actually makes it online.  Because this
> + * race is quite rare, we check for it after detecting that the grace
> + * period has been delayed rather than checking each and every CPU
> + * each and every time we start a new grace period.
> + */
What about using CPU_DYING and CPU_STARTING?

Then this race wouldn't exist anymore.
> +static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
> +{
> + [snip]
> +       case RCU_FORCE_QS:
> +
> +               /* Check dyntick-idle state, send IPI to laggarts. */
> +               if (rcu_process_dyntick(rsp, 
> dyntick_recall_completed(rsp),
> +                                       rcu_implicit_dynticks_qs))
> +                       goto unlock_ret;
> +
> +               /* Leave state in case more forcing is required. */
> +
> +               break;
Hmm - your code must loop multiple times over the cpus.
I've use a different approach: More forcing is only required for a nohz 
cpu when it was hit within a long-running interrupt.
Thus I've added a '->kick_poller' flag, rcu_irq_exit() reports back when 
the long-running interrupt completes. Never more than one loop over the 
outstanding cpus is required.

--
    Manfred
