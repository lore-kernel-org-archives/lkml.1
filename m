Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbZBRNw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbZBRNw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZBRNwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:52:18 -0500
Received: from ns2.suse.de ([195.135.220.15]:36757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZBRNwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:52:17 -0500
Date: Wed, 18 Feb 2009 14:52:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single ipi fallback for smp_call_function_many())
Message-ID: <20090218135212.GB23125@wotan.suse.de>
References: <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <20090217192810.GA4980@redhat.com> <20090217213256.GJ6761@linux.vnet.ibm.com> <20090217214518.GA13189@redhat.com> <20090217223910.GM6761@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217223910.GM6761@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 02:39:10PM -0800, Paul E. McKenney wrote:
> On Tue, Feb 17, 2009 at 10:45:18PM +0100, Oleg Nesterov wrote:
> > > If all of the above is executed by the same task, tripping the BUG_ON()
> > > means either a compiler or CPU bug.
> > 
> > I think you misunderstood...
> > 
> > smp_send_xxx() sends the ipi to another CPU, and smp_xxx_interrupt() is
> > the handler.
> 
> You are right, I did miss that completely.  :-/
> 
> I have seen hardware in which the IPI could beat the cache invalidation
> from the sending CPU to the interrupted CPU, and in which one or both of
> the CPUs would have to execute special cache-flush/invalidation/whatever
> instructions for the interrupted CPU to have a consistent view of the
> data (in your example, "COND").
> 
> But we had a little chat with the hardware designers, and in subsequent
> hardware, the IPI interacted with the cache-coherence protocol so as to
> prevent the above bug from firing.  However, this was x86-based hardware,
> which orders writes.  Weakly ordered systems would likely need a memory
> barrier somewhere, whether as shown above or buried in the smp_send_xxx()
> primitive.

I agree with you both that we *should* make arch interrupt code
do the ordering, but given the subtle lockups on some architectures
in this new code, I didn't want to make it significantly weaker...

Though perhaps it appears that I have, if I have removed an smp_mb
that x86 was relying on to emit an mfence to serialise the apic.
