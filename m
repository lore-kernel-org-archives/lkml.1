Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZBQWjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZBQWjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZBQWjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:39:14 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60852 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbZBQWjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:39:12 -0500
Date: Tue, 17 Feb 2009 14:39:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
	single ipi fallback for smp_call_function_many())
Message-ID: <20090217223910.GM6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090216220214.GA10093@redhat.com> <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <20090217192810.GA4980@redhat.com> <20090217213256.GJ6761@linux.vnet.ibm.com> <20090217214518.GA13189@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217214518.GA13189@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:45:18PM +0100, Oleg Nesterov wrote:
> On 02/17, Paul E. McKenney wrote:
> >
> > On Tue, Feb 17, 2009 at 08:28:10PM +0100, Oleg Nesterov wrote:
> > >
> > > So the question is: is there any arch which surely needs this barrier?
> > >
> > > IOW,
> > > 	int COND;
> > >
> > > 	void smp_xxx_interrupt(regs)
> > > 	{
> > > 		BUG_ON(!COND);
> > > 	}
> > >
> > > 	COND = 1;
> > > 	mb();
> > > 	smp_send_xxx(cpu);
> > >
> > > can we really hit the BUG_ON() above on some arch?
> >
> > If all of the above is executed by the same task, tripping the BUG_ON()
> > means either a compiler or CPU bug.
> 
> I think you misunderstood...
> 
> smp_send_xxx() sends the ipi to another CPU, and smp_xxx_interrupt() is
> the handler.

You are right, I did miss that completely.  :-/

I have seen hardware in which the IPI could beat the cache invalidation
from the sending CPU to the interrupted CPU, and in which one or both of
the CPUs would have to execute special cache-flush/invalidation/whatever
instructions for the interrupted CPU to have a consistent view of the
data (in your example, "COND").

But we had a little chat with the hardware designers, and in subsequent
hardware, the IPI interacted with the cache-coherence protocol so as to
prevent the above bug from firing.  However, this was x86-based hardware,
which orders writes.  Weakly ordered systems would likely need a memory
barrier somewhere, whether as shown above or buried in the smp_send_xxx()
primitive.

							Thanx, Paul
