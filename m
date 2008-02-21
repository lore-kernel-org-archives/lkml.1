Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbYBUK6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbYBUK6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 05:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYBUK6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 05:58:45 -0500
Received: from relay2.sgi.com ([192.48.171.30]:44881 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758024AbYBUK6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 05:58:43 -0500
Date: Thu, 21 Feb 2008 04:58:39 -0600
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
Message-ID: <20080221105838.GJ11391@sgi.com>
References: <20080215064859.384203497@sgi.com> <200802201451.46069.nickpiggin@yahoo.com.au> <20080220090035.GG11391@sgi.com> <200802211520.03529.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802211520.03529.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 03:20:02PM +1100, Nick Piggin wrote:
> > > So why can't you export a device from your xpmem driver, which
> > > can be mmap()ed to give out "anonymous" memory pages to be used
> > > for these communication buffers?
> >
> > Because we need to have heap and stack available as well.  MPT does
> > not control all the communication buffer areas.  I haven't checked, but
> > this is the same problem that IB will have.  I believe they are actually
> > allowing any memory region be accessible, but I am not sure of that.
> 
> Then you should create a driver that the user program can register
> and unregister regions of their memory with. The driver can do a
> get_user_pages to get the pages, and then you'd just need to set up
> some kind of mapping so that userspace can unmap pages / won't leak
> memory (and an exit_mm notifier I guess).

OK.  You need to explain this better to me.  How would this driver
supposedly work?  What we have is an MPI library.  It gets invoked at
process load time to establish its rank-to-rank communication regions.
It then turns control over to the processes main().  That is allowed to
run until it hits the
	MPI_Init(&argc, &argv);

The process is then totally under the users control until:
	MPI_Send(intmessage, m_size, MPI_INT, my_rank+half, tag, MPI_COMM_WORLD);
	MPI_Recv(intmessage, m_size, MPI_INT, my_rank+half,tag, MPI_COMM_WORLD, &status);

That is it.  That is all our allowed interaction with the users process.
Are you saying at the time of the MPI_Send, we should:

	down_write(&current->mm->mmap_sem);
	Find all the VMAs that describe this region and record their
vm_ops structure.
	Find all currently inserted page table information.
	Create new VMAs that describe the same regions as before.
	Insert our special fault handler which merely calls their old
fault handler and then exports the page then returns the page to the
kernel.
	Take an extra reference count on the page for each possible
remote rank we are exporting this to.


That doesn't seem too unreasonable, except when you compare it to how the
driver currently works.  Remember, this is done from a library which has
no insight into what the user has done to its own virtual address space.
As a result, each MPI_Send() would result in a system call (or we would
need to have a set of callouts for changes to a processes VMAs) which
would be a significant increase in communication overhead.

Maybe I am missing what you intend to do, but what we need is a means of
tracking one processes virtual address space changes so other processes
can do direct memory accesses without the need for a system call on each
communication event.

> Because you don't need to swap, you don't need coherency, and you
> are in control of the areas, then this seems like the best choice.
> It would allow you to use heap, stack, file-backed, anything.

You are missing one point here.  The MPI specifications that have
been out there for decades do not require the process use a library
for allocating the buffer.  I realize that is a horrible shortcoming,
but that is the world we live in.  Even if we could change that spec,
we would still need to support the existing specs.  As a result, the
user can change their virtual address space as they need and still expect
communications be cheap.

Thanks,
Robin
