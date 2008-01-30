Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbYA3SZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbYA3SZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYA3SZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:25:10 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:34285
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYA3SZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:25:08 -0500
Date: Wed, 30 Jan 2008 19:25:06 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080130182506.GQ7233@v2.random>
References: <20080129162004.GL7233@v2.random> <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com> <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com> <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com> <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com> <20080130170451.GP7233@v2.random> <20080130173009.GT26420@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130173009.GT26420@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 11:30:09AM -0600, Robin Holt wrote:
> I don't think I saw the answer to my original question.  I assume your
> original patch, extended in a way similar to what Christoph has done,
> can be made to work to cover both the KVM and GRU (Jack's) case.

Yes, I think so.

> XPMEM, however, does not look to be solvable due to the three simultaneous
> issues above.  To address that, I think I am coming to the conclusion
> that we need an accompanying but seperate pair of callouts.  The first

The mmu_rmap_notifiers are already one separate pair of callouts and
we can add more of them of course.

> will ensure the remote page tables and TLBs are cleared and all page
> information is returned back to the process that is granting access to
> its address space.  That will include an implicit block on the address
> range so no further faults will be satisfied by the remote accessor
> (forgot the KVM name for this, sorry).  Any faults will be held off
> and only the processes page tables/TLBs are in play.  Once the normal

Good, this "block" is how you close the race condition, and you need
the second callout to "unblock" (this is why it could hardly work well
before with a single invalidate_range).

> processing of the kernel is complete, an unlock callout would be made
> for the range and then faulting may occur on behalf of the process again.

This sounds good.

> Currently, this is the only direct solution that I can see as a
> possibility.  My question is two fold.  Does this seem like a reasonable
> means to solve the three simultaneous issues above and if so, does it
> seem like the most reasonable means?

Yes.

KVM can deal with both invalidate_page (atomic) and invalidate_range (sleepy)

GRU can only deal with invalidate_page (atomic)

XPMEM requires with invalidate_range (sleepy) +
before_invalidate_range (sleepy). invalidate_all should also be called
before_release (both sleepy).

It sounds we need full overlap of information provided by
invalidate_page and invalidate_range to fit all three models (the
opposite of the zero objective that current V3 is taking). And the
swap will be handled only by invalidate_page either through linux rmap
or external rmap (with the latter that can sleep so it's ok for you,
the former not). GRU can safely use the either the linux rmap notifier
or the external rmap notifier equally well, because when try_to_unmap
is called the page is locked and obviously pinned by the VM itself.
