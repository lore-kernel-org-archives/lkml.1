Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYHLBX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYHLBX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 21:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYHLBXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 21:23:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34562 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYHLBXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 21:23:00 -0400
Date: Mon, 11 Aug 2008 21:22:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Miller <davem@davemloft.net>
cc: a.p.zijlstra@chello.nl, jkacur@gmail.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] BUG: using smp_processor_id() in preemptible [00000000]
 code: caller is __qdisc_run
In-Reply-To: <20080811.142359.145735170.davem@davemloft.net>
Message-ID: <alpine.DEB.1.10.0808112121370.32393@gandalf.stny.rr.com>
References: <520f0cf10808110611y62f6a4e2v94a0d0cde1d5d79d@mail.gmail.com> <20080811.140014.94581847.davem@davemloft.net> <1218488979.15798.39.camel@lappy.programming.kicks-ass.net> <20080811.142359.145735170.davem@davemloft.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 11 Aug 2008, David Miller wrote:

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon, 11 Aug 2008 23:09:38 +0200
> 
> > On Mon, 2008-08-11 at 14:00 -0700, David Miller wrote:
> > > From: "John Kacur" <jkacur@gmail.com>
> > > Date: Mon, 11 Aug 2008 15:11:46 +0200
> > > 
> > > > __qdisc_run() calls qdisc_restart() which calls
> > > > handle_dev_cpu_collision(skb, dev, q); and then the problem shows up
> > > > here:
> > > > __get_cpu_var(netdev_rx_stat).cpu_collision++;
> > > > 
> > > > The solution is to disable interrupts around the above increment. Here
> > > > is an attached patch to do so. (Thank's to Peter Zijlstra for help in
> > > > the analysis and dropping the answer in my lap, so if I got it right
> > > > it is due to his help, but if I messed it up, then I did that part all
> > > > by myself.)
> > > 
> > > __qdisc_run() always runs in software interrupt context,
> > > so I guess this is some problem with the -rt stuff running
> > > software interrupts in threads?
> > 
> > Hmm, good point - and those threads should be cpu affine on -rt if I'm
> > not mistaken. Steven, do you happen to remember details?
> 
> The key issue is whether those threads run software interrupts
> in a compatible environment.  And such a proper environment allows
> plain smp_processor_id() without any special preparations.
> 

Yes, we have a softirq thread per CPU. We should have a test in the 
smp_processor_id for rt to not bug if it is called by known "per_cpu" 
threads.

-- Steve

