Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbXHVVpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbXHVVpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763241AbXHVVp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:45:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763083AbXHVVpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:45:23 -0400
Date: Wed, 22 Aug 2007 14:41:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de
Subject: Re: [PATCH RFC] Priority boosting for preemptible RCU
Message-Id: <20070822144154.dd156a28.akpm@linux-foundation.org>
In-Reply-To: <20070822212216.GE8786@linux.vnet.ibm.com>
References: <20070822190254.GA1135@linux.vnet.ibm.com>
	<20070822124340.16a891f2.akpm@linux-foundation.org>
	<20070822212216.GE8786@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 14:22:16 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Aug 22, 2007 at 12:43:40PM -0700, Andrew Morton wrote:
> > On Wed, 22 Aug 2007 12:02:54 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Hello!
> > > 
> > > This patch is a forward-port of RCU priority boosting (described in
> > > http://lwn.net/Articles/220677/).  It applies to 2.6.22 on top of
> > > the patches sent in the http://lkml.org/lkml/2007/8/7/276 series and
> > > the hotplug patch (http://lkml.org/lkml/2007/8/17/262).  Passes several
> > > hours of rcutorture on x86_64 and POWER, so OK for experimentation but
> > > not ready for inclusion.
> > 
> > It'd be nice to have a brief summary of why we might want this code in Linux.
> 
> Good point -- will add something like the following in the next rev:
> 
> 	RCU priority boosting is needed when running a workload that might
> 	include CPU-bound user tasks running at realtime priorities with
> 	a CONFIG_PREEMPT build of the kernel.  In this situation, RCU
> 	priority boosting is needed to avoid OOM.
> 
> Does that cover it?

yup

> > > +config PREEMPT_RCU_BOOST_STATS_INTERVAL
> > 
> > Four new config options?  Sob.  Zero would be preferable.
> 
> Hmmm...  I should be able to fold this into PREEMPT_RCU_BOOST_STATS,
> now that you mention it.  Zero to disable, other number to specify
> interval.  And I should move this to the kernel-hacking group as
> well.  Would that help?

The fewer the better.

We want to avoid options which some people might want to enable in normal
production and which other people might want to disable in normal
production.  Because most people don't build custom kernels and the person
who builds their kernels for them needs to make a decision for them.  We
don't want to force the person who configures others' kernels to have to
make nasty compromises.

Config options which are clearly kernel-devleoper-only are fine: people can
just turn them off for production.

> > for_each_possible_cpu() can sometimes do a *lot* more work than
> > for_each_online_cpu().  And even for_each_present_cpu().
> 
> for_each_online_cpu() would not cut it here, but for_each_present_cpu()
> might -- as long as no platforms physically hotplug the CPUs.

Platforms do physically hotplug cpus.  All the hotplug notifier stuff is
there so that code such as yours can synchronise against that.

> 
> > Andy, can we have a checkpatch rule for SPIN_LOCK_UNLOCKED please?  It's
> > basically always wrong.
> 
> Even for static initializers for top-level variables?

Yes.  For those, use DEFINE_SPINLOCK().

> > > +	if (unlikely(idx < 0))
> > > +		return (NULL);
> > 
> > return-is-not-a-function
> 
> You lost me on this one...  You presumably aren't asking it to be converted
> to a macro.  You want it manually inlined where called?

Do `return foo;', not `return (foo);' ;)
	

