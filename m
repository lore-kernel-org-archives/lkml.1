Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZBRN77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZBRN77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZBRN7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:59:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZBRN7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:59:48 -0500
Date: Wed, 18 Feb 2009 14:59:45 +0100
From: Nick Piggin <npiggin@suse.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Oleg Nesterov <oleg@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single ipi fallback for smp_call_function_many())
Message-ID: <20090218135945.GC23125@wotan.suse.de>
References: <20090216213205.GA9098@redhat.com> <1234820704.30178.396.camel@laptop> <20090216220214.GA10093@redhat.com> <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <1234923702.29823.7.camel@vayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234923702.29823.7.camel@vayu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 06:21:42PM -0800, Suresh B wrote:
> On Tue, 2009-02-17 at 03:26 -0800, Nick Piggin wrote:
> > --
> > Simplify the barriers in generic remote function call interrupt code.
> > 
> > Firstly, just unconditionally take the lock and check the list in the
> > generic_call_function_single_interrupt IPI handler. As we've just taken
> > an IPI here, the chances are fairly high that there will be work on the
> > list for us, so do the locking unconditionally. This removes the tricky
> > lockless list_empty check and dubious barriers. The change looks bigger
> > than it is because it is just removing an outer loop.
> > 
> > Secondly, clarify architecture specific IPI locking rules. Generic code
> > has no tools to impose any sane ordering on IPIs if they go outside
> > normal cache coherency, ergo the arch code must make them appear to
> > obey cache coherency as a "memory operation" to initiate an IPI, and
> > a "memory operation" to receive one. This way at least they can be
> > reasoned about in generic code, and smp_mb used to provide ordering. 
> > 
> > The combination of these two changes means that explict barriers can
> > be taken out of queue handling for the single case -- shared data is
> > explicitly locked, and ipi ordering must conform to that, so no
> > barriers needed. An extra barrier is needed in the many handler, so
> > as to ensure we load the list element after the IPI is received.
> > 
> > Does any architecture actually needs barriers? For the initiator I
> > could see it, but for the handler I would be surprised. The other
> > thing we could do for simplicity is just to require that a full
> > barrier is required before generating an IPI, and after receiving an
> > IPI. We can't just do that in generic code without auditing
> > architectures. There have been subtle hangs here on some archs in
> > the past.
> 
> x2apic register reads/writes don't have serializing semantics, as
> opposed to uncached xapic accesses, which are inherently serializing.
> 
> With this patch, we need to fix the corresponding x2apic IPI operations.
> I will take a look at it.

You're saying the problem is in generic_exec_single because I've
removed the smp_mb that inadvertently also serialises memory with
the x2apic on x86?

Indeed that could cause problems on some architectures which I
had hoped to avoid. So the patch is probably better off to first
add the smp_mb() to arch_send_call_function_xxx arch code, unless
it is immediately obvious or confirmed by arch maintainer that
such barrier is not required.

