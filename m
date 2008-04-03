Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbYDCAnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbYDCAnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759311AbYDCAm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:42:56 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:42889
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbYDCAmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:42:55 -0400
Date: Thu, 3 Apr 2008 02:42:46 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1 of 8] Core of mmu notifiers
Message-ID: <20080403004246.GA16633@duo.random>
References: <a406c0cc686d0ca94a4d.1207171802@duo.random> <Pine.LNX.4.64.0804021527370.31603@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021527370.31603@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 03:34:01PM -0700, Christoph Lameter wrote:
> Still two methods ...

Yes, the invalidate_page is called with the core VM holding a
reference on the page _after_ the tlb flush. The invalidate_end is
called after the page has been freed already and after the tlb
flush. They've different semantics and with invalidate_page there's no
need to block the kvm fault handler. But invalidate_page is only
the most efficient for operations that aren't creating holes in the
vma, for the rest invalidate_range_start/end provides the best
performance by reducing the number of tlb flushes.

> seqlock just taken for checking if everything is ok?

Exactly.

> The critical section could be run multiple times for one callback which 
> could result in multiple callbacks to clear the young bit. Guess not that 
> big of an issue?

Yes, that's ok.

> Ok. Retry would try to invalidate the page a second time which is not a 
> problem unless you would drop the refcount or make other state changes 
> that require correspondence with mapping. I guess this is the reason 
> that you stopped adding a refcount?

The current patch using mmu notifiers is already robust against
multiple invalidates. The refcounting represent a spte mapping, if we
already invalidated it, the spte will be nonpresent and there's no
page to unpin. The removal of the refcount is only a
microoptimization.

> Multiple invalidate_range_starts on the same range? This means the driver 
> needs to be able to deal with the situation and ignore the repeated 
> call?

The driver would need to store current->pid in a list and remove it in
range_stop. And range_stop would need to do nothing at all, if the pid
isn't found in the list.

But thinking more I'm not convinced the driver is safe by ignoring if
range_end runs before range_begin (pid not found in the list). And I
don't see a clear way to fix it not internally to the device driver
nor externally. So the repeated call is easy to handle for the
driver. What is not trivial is to block the secondary page faults when
mmu_notifier_register happens in the middle of range_start/end
critical section. sptes can be established in between range_start/_end
and that shouldn't happen. So the core problem returns to be how to
handle mmu_notifier_register happening in the middle of
_range_start/_end, dismissing it as a job for the driver seems not
feasible (you have the same problem with EMM of course).

> Retry can lead to multiple invalidate_range callbacks with the same 
> parameters? Driver needs to ignore if the range is already clear?

Mostly covered above.

