Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbYB0Xnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbYB0Xnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761684AbYB0Xnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:43:31 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:54670
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761683AbYB0Xna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:43:30 -0500
Date: Thu, 28 Feb 2008 00:43:17 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org, akpm@linux-foundation.org
Subject: Re: [kvm-devel] [PATCH] mmu notifiers #v7
Message-ID: <20080227234317.GM28483@v2.random>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de> <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <Pine.LNX.4.64.0802271503050.13186@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802271503050.13186@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 03:06:10PM -0800, Christoph Lameter wrote:
> Ok so it somehow works slowly with GRU and you are happy with it. What 

As far as GRU is concerned, performance is the same as with your patch
(Jack can confirm).

> about the RDMA folks etc etc?

If RDMA/IB folks needed to block in invalidate_range, I guess they
need to do so on top of tmpfs too, and that never worked with your
patch anyway.

> Would it not be better to have a solution that fits all instead of hacking 
> something in now and then having to modify it later?

The whole point is that your solution fits only GRU and KVM too.

XPMEM in your patch works in a hacked mode limited to anonymous memory
only, Robin already received incoming mail asking to allow xpmem to
work on more than anonymous memory, so your solution-that-fits-all
doesn't actually fit some of Robin's customer needs. So if it doesn't
even entirely satisfy xpmem users, imagine the other potential
blocking-users of this code.

> Hmmm.. There were earlier discussions of changing the anon vma lock to a 
> rw lock because of contention issues in large systems. Maybe we can just 
> generally switch the locks taken while walking rmaps to semaphores? That 
> would still require to put the invalidate outside of the pte lock.

anon_vma lock can remain a spinlock unless you also want to schedule
inside try_to_unmap.

If converting the i_mmap_lock to a mutex is a big trouble, another way
that might work to allow invalidate_range to block, would be to try to
boost the mm_users to prevent the mmu_notifier_release to run in
another cpu the moment after i_mmap_lock spinlock is unlocked. But
even if that works, it'll run slower and the mmu notifiers RCU locking
should be switched to a mutex, so it'd be nice to have it as a
separate option.
