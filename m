Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbYB0XGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbYB0XGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYB0XGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:06:13 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53445 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751779AbYB0XGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:06:11 -0500
Date: Wed, 27 Feb 2008 15:06:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Jack Steiner <steiner@sgi.com>, Nick Piggin <npiggin@suse.de>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v7
In-Reply-To: <20080227192610.GF28483@v2.random>
Message-ID: <Pine.LNX.4.64.0802271503050.13186@schroedinger.engr.sgi.com>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random>
 <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random>
 <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de>
 <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com>
 <20080227192610.GF28483@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Andrea Arcangeli wrote:

> I hope this will can be considered final for .25 and be merged. Risk
> is zero, the only discussion here is to make an API that will last
> forever, functionality-wise all these patches provides zero risk and
> zero overhead when MMU_NOTIFIER=n. This last patch covers KVM and GRU
> and hopefully all other non-blocking users optimally, and the below

Ok so it somehow works slowly with GRU and you are happy with it. What 
about the RDMA folks etc etc?

> API will hopefully last forever (but even if it lasts just for .25 and
> .26 is changed that's fine with us, it's a kernel _internal_ API
> anyway, there's absolutely nothing visible to userland).

Would it not be better to have a solution that fits all instead of hacking 
something in now and then having to modify it later?

 > What Christoph need to do when he's back from vacations to support
> sleepable mmu notifiers is to add a CONFIG_XPMEM config option that
> will switch the i_mmap_lock from a semaphore to a mutex (any other
> change to this patch will be minor compared to that) so XPMEM hardware
> will have kernels compiled that way. I don't see other sane ways to
> remove the "atomic" parameter from the API (apparently required by
> Andrew for merging something not restricted to the xpmem current usage
> with only anonymous memory) and I don't want to have such a
> locking-change intrusive dependency for all other non-blocking users
> that are fine without having to alter how the VM works (for example
> KVM and GRU). Very minor changes will be required to this patch to
> make it work after the VM locking will be altered (for example the
> CONFIG_XPMEM should also switch the mmu_register/unregister locking
> from RCU to mutex as well). XPMEM then will only compile if
> CONFIG_XPMEM=y and in turn the invalidate_range_* will support
> scheduling inside.

Hmmm.. There were earlier discussions of changing the anon vma lock to a 
rw lock because of contention issues in large systems. Maybe we can just 
generally switch the locks taken while walking rmaps to semaphores? That 
would still require to put the invalidate outside of the pte lock.

