Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbYHKLDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbYHKLDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYHKLDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:03:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60826 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYHKLDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:03:42 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
From: Andi Kleen <andi@firstfloor.org>
References: <1218202249.8625.106.camel@twins>
	<alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
	<1218215454.8625.133.camel@twins>
	<alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	<1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	<alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	<1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
	<20080808121428.646a8b3c.akpm@linux-foundation.org>
	<1218223269.29098.12.camel@lappy.programming.kicks-ass.net>
	<1218224829.29098.19.camel@lappy.programming.kicks-ass.net>
	<20080811104526.GA15186@elte.hu>
Date: Mon, 11 Aug 2008 13:03:39 +0200
In-Reply-To: <20080811104526.GA15186@elte.hu> (Ingo Molnar's message of "Mon, 11 Aug 2008 12:45:26 +0200")
Message-ID: <87zlnj24qc.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> On Fri, 2008-08-08 at 21:21 +0200, Peter Zijlstra wrote:
>> 
>> > The initial printk_tick() based implementation didn't suffer this
>> > problem, should we revert to that scheme?
>> 
>> Just in case people care..
>> 
>> ---
>> Subject: printk: robustify printk
>> 
>> Avoid deadlocks against rq->lock and xtime_lock by deferring the klogd 
>> wakeup by polling from the timer tick.
>
> i missed most of the discussion, but this seems like the simplest (and 
> hence ultimately the best) approach to me.

The problem is that it means any printk data output that is more
than DMESG-BUFFER-SIZE bytes during one clock tick is going to lose data.
It loses the natural adaption to higher printk rates that you
got previously.

Now we could say that for debugging etc. people should switch
to other mechanisms like relayfs, but I would still worry about
some corner cases where losing printk data that wasn't lost before
could be a severe regression (e.g. consider firewall log messages
or similar)

Essentially it makes printk (much?) less reliable than it was before
in the general case. Not sure that's a good thing. So the patch
title is definitely misleading.

As Linus pointed out earlier we've survived with this restriction
(not doing printk in the scheduler) for a long time, so is there
really a that pressing need to change that?

> Coupling printk with RCU, albeit elegant, does not seem like the right 
> choice to me in this specific case: printk as an essential debug 
> mechanism should be as decoupled as possible.

RCU coupling has actually the same problem.

-Andi
