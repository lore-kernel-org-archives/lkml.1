Return-Path: <linux-kernel-owner+w=401wt.eu-S1763686AbYDBWJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763686AbYDBWJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763280AbYDBWJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:09:40 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:47821
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763113AbYDBWJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:09:39 -0400
Date: Thu, 3 Apr 2008 00:09:36 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/9] EMM Notifier: The notifier calls
Message-ID: <20080402220936.GW19189@duo.random>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com> <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com> <20080402215334.GT19189@duo.random> <Pine.LNX.4.64.0804021453350.31247@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021453350.31247@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 02:54:52PM -0700, Christoph Lameter wrote:
> On Wed, 2 Apr 2008, Andrea Arcangeli wrote:
> 
> > > Hmmm... Okay that is one solution that would just require a BUG_ON in the 
> > > registration methods.
> > 
> > Perhaps you didn't notice that this solution can't work if you call
> > range_begin/end not in the "current" context and try_to_unmap_cluster
> > does exactly that for both my patchset and yours. Missing an _end is
> > ok, missing a _begin is never ok.
> 
> If you look at the patch you will see a requirement of holding a 
> writelock on mmap_sem which will keep out get_user_pages().

I said try_to_unmap_cluster, not get_user_pages.

  CPU0					CPU1
  try_to_unmap_cluster:
  emm_invalidate_start in EMM (or mmu_notifier_invalidate_range_start in #v10)
  walking the list by hand in EMM (or with hlist cleaner in #v10)
  xpmem method invoked
  schedule for a long while inside invalidate_range_start while skbs are sent
					gru registers
					synchronize_rcu (sorry useless now)
					single threaded, so taking a page fault
  					secondary tlb instantiated
  xpm method returns
  end of the list (didn't notice that it has to restart to flush the gru)
  zap pte
  free the page
					gru corrupts memory

CPU 1 was single threaded, CPU0 doesn't hold any mmap_sem or any other
lock that could ever serialize against the GRU as far as I can tell.

In general my #v10 solution mixing seqlock + rcu looks more robust and
allows multithreaded attachment of mmu notifers as well. I could have
fixed it with the single threaded thanks to the fact the only place
outside the mm->mmap_sem is try_to_unmap_cluster for me but it wasn't
simple to convert, nor worth it, given nonlinear isn't worth
optimizing for (not even the core VM cares about try_to_unmap_cluster
which is infact the only place in the VM with a O(N) complexity for
each try_to_unmap call, where N is the size of the mapping divided by
page_size).
