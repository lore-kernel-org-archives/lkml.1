Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbYHKLWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbYHKLWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYHKLWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:22:12 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:35106 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203AbYHKLWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:22:11 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH] printk: robustify printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
In-Reply-To: <87zlnj24qc.fsf@basil.nowhere.org>
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
	 <20080811104526.GA15186@elte.hu>  <87zlnj24qc.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 13:22:06 +0200
Message-Id: <1218453726.10800.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 13:03 +0200, Andi Kleen wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> >> On Fri, 2008-08-08 at 21:21 +0200, Peter Zijlstra wrote:
> >> 
> >> > The initial printk_tick() based implementation didn't suffer this
> >> > problem, should we revert to that scheme?
> >> 
> >> Just in case people care..
> >> 
> >> ---
> >> Subject: printk: robustify printk
> >> 
> >> Avoid deadlocks against rq->lock and xtime_lock by deferring the klogd 
> >> wakeup by polling from the timer tick.
> >
> > i missed most of the discussion, but this seems like the simplest (and 
> > hence ultimately the best) approach to me.
> 
> The problem is that it means any printk data output that is more
> than DMESG-BUFFER-SIZE bytes during one clock tick is going to lose data.
> It loses the natural adaption to higher printk rates that you
> got previously.
> 
> Now we could say that for debugging etc. people should switch
> to other mechanisms like relayfs, but I would still worry about
> some corner cases where losing printk data that wasn't lost before
> could be a severe regression (e.g. consider firewall log messages
> or similar)

You only loose the msgs with klogd, console still gets everything. If
firewalls are generating that much data, perhaps its time to think about
alternative ways to channel that.

> Essentially it makes printk (much?) less reliable than it was before
> in the general case. Not sure that's a good thing. So the patch
> title is definitely misleading.

Depends, I don't give a rats arse about klogd - I get everything through
serial onto another machine. 

> As Linus pointed out earlier we've survived with this restriction
> (not doing printk in the scheduler) for a long time, so is there
> really a that pressing need to change that?

Why not fix it if its acceptable - the deadlock is just ugly.

