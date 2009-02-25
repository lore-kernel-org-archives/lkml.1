Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZBYRNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZBYRNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZBYRMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:12:53 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42079 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZBYRMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:12:53 -0500
Date: Wed, 25 Feb 2009 09:12:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, stable@kernel.org, akpm@linux-foundation.org,
       penberg@cs.helsinki.fi
Subject: Re: [PATCH] v4 Teach RCU that idle task is not quiscent state at
	boot
Message-ID: <20090225171249.GD6797@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com> <20090225002937.GA23733@linux.vnet.ibm.com> <20090225141945.GA28455@linux.vnet.ibm.com> <20090225160024.GB12732@elte.hu> <20090225162645.GJ22785@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225162645.GJ22785@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 05:26:45PM +0100, Nick Piggin wrote:
> On Wed, Feb 25, 2009 at 05:00:24PM +0100, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > +/* Internal to kernel, but needed by rcupreempt.h. */
> > > +extern int rcu_idle_cpu_truthful;
> > 
> > The name sucks a bit ;-) 'truthful' is an emotionally laden 
> > statement and distracts from the technical purpose when reading 
> > it ;)
> > 
> > Same for:
> > 
> > > +extern void rcu_idle_now_means_idle(void);
> > 
> > Also, i'm wondering, is there really no way to avoid this quirk. 
> > We almost got away without it for a long time.
> 
> I wonder if you couldn't leave cpu_rq(cpu)->idle as NULL until right
> up to the point where it actually becomes the "idle" thread? This
> would make idle_cpu() more truthful for all other callers in early
> boot code too. And rcupdate shouldn't need any changes (except the
> num_online_cpus() == 1 shortcut probably remains as a nice opt).

It looked to me that the idle task initialization was moved early
to allow interrupt handlers to see a more normal environment, but I
could easily be confused here.

						Thanx, Paul

> > This one:
> > 
> > >  void rcu_check_callbacks(int cpu, int user)
> > >  {
> > >  	if (user ||
> > > -	    (idle_cpu(cpu) && !in_softirq() &&
> > > -				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> > > +	    (idle_cpu(cpu) && rcu_idle_cpu_truthful &&
> > > +	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> > 
> > Is a hotpath called very often ...
> > 
> > 	Ingo
