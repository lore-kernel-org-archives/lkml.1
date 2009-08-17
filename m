Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZHQS3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZHQS3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZHQS3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:29:04 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42961 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbZHQS3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:29:03 -0400
Date: Mon, 17 Aug 2009 11:28:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org
Subject: Re: [PATCH -tip/core/rcu 2/6] Introduce cpu_notifier() to handle
	!HOTPLUG_CPU case
Message-ID: <20090817182857.GG6760@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090815165153.GA8886@linux.vnet.ibm.com> <1250529719.2709.11.camel@josh-work.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250529719.2709.11.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 10:21:59AM -0700, Josh Triplett wrote:
> On Sat, 2009-08-15 at 09:53 -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > This patch introduces a new cpu_notifier() API that is similar to
> > hotcpu_notifier(), but which also notifies of CPUs coming online during
> > boot in the !HOTPLUG_CPU case.
> [...]
> > --- a/include/linux/cpu.h
> > +++ b/include/linux/cpu.h
> > @@ -48,6 +48,15 @@ struct notifier_block;
> > 
> >  #ifdef CONFIG_SMP
> >  /* Need to know about CPUs going up/down? */
> > +#if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
> > +#define cpu_notifier(fn, pri) {					\
> > +	static struct notifier_block fn##_nb __cpuinitdata =	\
> > +		{ .notifier_call = fn, .priority = pri };	\
> > +	register_cpu_notifier(&fn##_nb);			\
> > +}
> > +#else /* #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
> > +#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
> > +#endif /* #else #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
> 
> These two definitions seem inconsistent.  I think the first one needs to
> change to use do { ... } while(0) as well, so it eats the subsequent
> semicolon.

Ha!  I just copied the old hotcpu_notifier style.  Will send a patch
fixing both.  Or feel free to send one, if you wish.

> Does this really want to live under defined(CONFIG_HOTPLUG_CPU)?  What
> happens when onlining CPUs during the !define(CONFIG_HOTPLUG_CPU) case?
> This seems somewhat inconsistent with the explanation in your commit
> message; can you clarify?

The !MODULE covers the !define(CONFIG_HOTPLUG_CPU) case, please see
below.

> Also, why !defined(MODULE)?

Here is how the cases lay out:

o	!CONFIG_SMP:  there is only one CPU, and so there can be no
	CPU-hotplug operations, even at boot.  Therefore, the
	cpu_notifier() need do nothing.

o	CONFIG_SMP && CPU_HOTPLUG_CPU:  CPUs can come and go at any
	time, so we need cpu_notifier() to actually register a
	notifier.

o	CONFIG_SMP && !CPU_HOTPLUG_CPU && MODULE:  CPUs cannot go
	offline, but they do come online at boot time.	But MODULE means
	that this code is in a module, and modules cannot be loaded
	until later, after all CPUs have come online.  So cpu_notifier()
	need do nothing in this case.

o	CONFIG_SMP && !CPU_HOTPLUG_CPU && !MODULE:  CPUs cannot go
	offline, but they do come online at boot time.  This code
	is not in a module, so might be running at boot time, and
	thus might need to deal with CPUs coming online.  Therefore,
	cpu_notifier() must actually register a notifier.

The difference between hotcpu_notifier() and cpu_notifier() is in this
last case.  You would use hotcpu_notifier() for non-module code that did
not run until all CPUs had come online, and thus would not need to deal
with CPU hotplug unless HOTPLUG_CPU was actually defined.

							Thanx, Paul
