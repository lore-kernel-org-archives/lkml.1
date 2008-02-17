Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbYBQMcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbYBQMcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758601AbYBQMYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:24:46 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48516 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758581AbYBQMYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:24:44 -0500
Date: Sun, 17 Feb 2008 06:24:38 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/6] mmu_notifier: Core code
Message-ID: <20080217122438.GB11391@sgi.com>
References: <20080215064859.384203497@sgi.com> <20080215064932.371510599@sgi.com> <20080215193719.262c03a1.akpm@linux-foundation.org> <Pine.LNX.4.64.0802161103101.25573@schroedinger.engr.sgi.com> <20080217030120.GO11732@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217030120.GO11732@v2.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 04:01:20AM +0100, Andrea Arcangeli wrote:
> On Sat, Feb 16, 2008 at 11:21:07AM -0800, Christoph Lameter wrote:
> > On Fri, 15 Feb 2008, Andrew Morton wrote:
> > 
> > > What is the status of getting infiniband to use this facility?
> > 
> > Well we are talking about this it seems.
> 
> It seems the IB folks think allowing RDMA over virtual memory is not
> interesting, their argument seem to be that RDMA is only interesting
> on RAM (and they seem not interested in allowing RDMA over a ram+swap
> backed _virtual_ memory allocation). They've just to decide if
> ram+swap allocation for RDMA is useful or not.

I don't think that is a completely fair characterization.  It would be
more fair to say that the changes required to their library/user api
would be too significant to allow an adaptation to any scheme which
allowed removal of physical memory below a virtual mapping.

I agree with the IB folks when they say it is impossible with their
current scheme.  The fact that any consumer of their endpoint identifier
can use any identifier without notifying the kernel prior to its use
certainly makes any implementation under any scheme impossible.

I guess we could possibly make things work for IB if we did some heavy
work.  Let's assume, instead of passing around the physical endpoint
identifiers, they passed around a handle.  In order for any IB endpoint
to commuicate, it would need to request the kernel translate a handle
into an endpoint identifier.  In order for the kernel to put a TLB
entry into the processes address space allowing the process access to
the _CARD_, it would need to ensure all the current endpoint identifiers
for this process were "active" meaning we have verified with the other
endpoint that all pages are faulted and TLB/PFN information is in the
owning card's TLB/PFN tables.  Once all of a processes endoints are
"active" we would drop in the PFN for the adapter into the pages tables.
Any time pages are being revoked from under an active handle, we would
shoot-down the IB adapter card TLB entries for all the remote users of
this handle and quiesce the cards state to ensure transfers are either
complete or terminated.  When their are no active transfers, we would
respond back to the owner and they could complete the source process
page table cleaning.  Any time all of the pages for a handle can not be
mapped from virtual to physical, the remote process would be SIGBUS'd
instead of having it IB adapter TLB installed.

This is essentially how XPMEM does it except we have the benefit of
working on individual pages.

Again, not knowing what I am talking about, but under the assumption that
MPI IB use is contained to a library, I would hope the changes could be
contained under the MPI-to-IB library interface and would not need any
changes at the MPI-user library interface.

We do keep track of the virtual address ranges within a handle that
are being used.  I assume the IB folks will find that helpful as well.
Otherwise, I think they could make things operate this way.  XPMEM has
the advantage of not needing to have virtual-to-physical at all times,
but otherwise it is essentially the same.

Thanks,
Robin
