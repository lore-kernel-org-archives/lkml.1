Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbYBZM3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbYBZM3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYBZM3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:29:14 -0500
Received: from relay2.sgi.com ([192.48.171.30]:57753 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752958AbYBZM3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:29:09 -0500
Date: Tue, 26 Feb 2008 06:29:08 -0600
From: Robin Holt <holt@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Robin Holt <holt@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org, Andrea Arcangeli <andrea@qumranet.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 5/6] mmu_notifier: Support for drivers with revers maps
	(f.e. for XPmem)
Message-ID: <20080226122908.GQ11391@sgi.com>
References: <20080215064859.384203497@sgi.com> <200802211520.03529.nickpiggin@yahoo.com.au> <20080221105838.GJ11391@sgi.com> <200802261711.33213.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802261711.33213.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That is it.  That is all our allowed interaction with the users process.
> 
> OK, when you said something along the lines of "the MPT library has
> control of the comm buffer", then I assumed it was an area of virtual
> memory which is set up as part of initialization, rather than during
> runtime. I guess I jumped to conclusions.

There are six regions the MPT library typically makes.  The most basic
one is a fixed size.  It describes the MPT internal buffers, the stack,
the heap, the application text, and finally the entire address space.
That last region is seldom used.  MPT only has control over the first
two.

> > That doesn't seem too unreasonable, except when you compare it to how the
> > driver currently works.  Remember, this is done from a library which has
> > no insight into what the user has done to its own virtual address space.
> > As a result, each MPI_Send() would result in a system call (or we would
> > need to have a set of callouts for changes to a processes VMAs) which
> > would be a significant increase in communication overhead.
> >
> > Maybe I am missing what you intend to do, but what we need is a means of
> > tracking one processes virtual address space changes so other processes
> > can do direct memory accesses without the need for a system call on each
> > communication event.
> 
> Yeah it's tricky. BTW. what is the performance difference between
> having a system call or no?

The system call takes many microseconds and still requires the same
latency of the communication.  Without it, our latency is
usually below two microseconds.

> > > Because you don't need to swap, you don't need coherency, and you
> > > are in control of the areas, then this seems like the best choice.
> > > It would allow you to use heap, stack, file-backed, anything.
> >
> > You are missing one point here.  The MPI specifications that have
> > been out there for decades do not require the process use a library
> > for allocating the buffer.  I realize that is a horrible shortcoming,
> > but that is the world we live in.  Even if we could change that spec,
> 
> Can you change the spec? Are you working on it?

Even if we changed the spec, the old specs will continue to be
supported.  I personally am not involved.  Not sure if anybody else is
working this issue.

> > we would still need to support the existing specs.  As a result, the
> > user can change their virtual address space as they need and still expect
> > communications be cheap.
> 
> That's true. How has it been supported up to now? Are you using
> these kind of notifiers in patched kernels?

At fault time, we check to see if it is an anon or mspec vma.  We pin
the page an insert them.  The remote OS then losses synchronicity with
the owning processes page tables.  If an unmap, madvise, etc occurs the
page tables are updated without regard to our references.  Fork or exit
(fork is caught using an LD_PRELOAD library) cause the user pages to be
recalled from the remote side and put_page returns them to the kernel.
We have documented that this loss of synchronicity is due to their
action and not supported.  Essentially, we rely upon the application
being well behaved.  To this point, that has remainded true.

Thanks,
Robin
