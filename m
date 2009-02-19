Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbZBSNLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbZBSNLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZBSNLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:11:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:49607 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZBSNLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:11:10 -0500
Date: Thu, 19 Feb 2009 14:11:07 +0100
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single ipi fallback for smp_call_function_many())
Message-ID: <20090219131107.GD1747@wotan.suse.de>
References: <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <20090217192810.GA4980@redhat.com> <20090217213256.GJ6761@linux.vnet.ibm.com> <20090217214518.GA13189@redhat.com> <20090217223910.GM6761@linux.vnet.ibm.com> <20090218135212.GB23125@wotan.suse.de> <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain> <1235026040.8805.3.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235026040.8805.3.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 05:47:20PM +1100, Benjamin Herrenschmidt wrote:
> 
> > It might hide some architecture-specific implementation issue, of course, 
> > so random amounts of "smp_mb()"s sprinkled around might well make some 
> > architecture "work", but it's in no way guaranteed. A smp_mb() does not 
> > guarantee that some separate IPI network is ordered - that may well take 
> > some random machine-specific IO cycle.
> > 
> > That said, at least on x86, taking an interrupt should be a serializing 
> > event, so there should be no reason for anything on the receiving side. 
> > The _sending_ side might need to make sure that there is serialization 
> > when generating the IPI (so that the IPI cannot happen while the writes 
> > are still in some per-CPU write buffer and haven't become part of the 
> > cache coherency domain).
> > 
> > And at least on x86 it's actually pretty hard to generate out-of-order 
> > accesses to begin with (_regardless_ of any issues external to the CPU). 
> > You have to work at it, and use a WC memory area, and I'm pretty sure we 
> > use UC for the apic accesses.
> 
> On powerpc, I suspect an smp_mb() on the sender would be useful... it
> mostly depends how the IPI is generated but in most case it's going to
> be an MMIO write, ie non-cached write which isn't ordered vs. any
> previous cached store except using a full sync (which is what smp_mb()
> does).

So your arch_send_call_function_single_ipi etc need to ensure this,
right?  Generic code obviously has no idea about how to do it.

