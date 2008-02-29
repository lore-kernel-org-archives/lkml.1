Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbYB2VXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbYB2VXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYB2VXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:23:36 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:56641
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbYB2VXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:23:36 -0500
Date: Fri, 29 Feb 2008 22:23:27 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080229212327.GC8091@v2.random>
References: <20080228005249.GF8091@v2.random> <Pine.LNX.4.64.0802271702490.16510@schroedinger.engr.sgi.com> <20080228011020.GG8091@v2.random> <Pine.LNX.4.64.0802281043430.29191@schroedinger.engr.sgi.com> <20080229005530.GO8091@v2.random> <Pine.LNX.4.64.0802281658560.1954@schroedinger.engr.sgi.com> <20080229131302.GT8091@v2.random> <Pine.LNX.4.64.0802291149290.11292@schroedinger.engr.sgi.com> <20080229201744.GB8091@v2.random> <Pine.LNX.4.64.0802291301530.11889@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802291301530.11889@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 01:03:16PM -0800, Christoph Lameter wrote:
> That means we need both the anon_vma locks and the i_mmap_lock to become 
> semaphores. I think semaphores are better than mutexes. Rik and Lee saw 
> some performance improvements because list can be traversed in parallel 
> when the anon_vma lock is switched to be a rw lock.

The improvement was with a rw spinlock IIRC, so I don't see how it's
related to this.

Perhaps the rwlock spinlock can be changed to a rw semaphore without
measurable overscheduling in the fast path. However theoretically
speaking the rw_lock spinlock is more efficient than a rw semaphore in
case of a little contention during the page fault fast path because
the critical section is just a list_add so it'd be overkill to
schedule while waiting. That's why currently it's a spinlock (or rw
spinlock).

> Sounds like we get to a conceptually clean version here?

I don't have a strong opinion if it should become a semaphore
unconditionally or only with a CONFIG_XPMEM=y. But keep in mind
preempt-rt runs quite a bit slower, or we could rip spinlocks out of
the kernel in the first place ;)
