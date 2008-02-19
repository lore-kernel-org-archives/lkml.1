Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYBSN7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYBSN7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYBSN6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:58:55 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:53276
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYBSN6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:58:54 -0500
Date: Tue, 19 Feb 2008 14:58:51 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Nick Piggin <npiggin@suse.de>
Cc: akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] my mmu notifiers
Message-ID: <20080219135851.GI7128@v2.random>
References: <20080219084357.GA22249@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219084357.GA22249@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 09:43:57AM +0100, Nick Piggin wrote:
> are rather similar. However I have tried to make a point of minimising the
> impact the the core mm/. I don't see why we need to invalidate or flush

I also tried hard to minimise the impact of the core mm/, I also
argued with Christoph that cluttering mm/ wasn't a good idea for
things like age_page that could be a 1 liner change instead of a
multiple-liner change, without any loss of flexibility or readability.

> anything when changing the pte to be _more_ permissive, and I don't

Note that in my patch the invalidate_pages in mprotect can be
trivially switched to a mprotect_pages with proper params. This will
prevent page faults completely in the secondary MMU (there will only
be tlb misses after the tlb flush just like for the core linux pte),
and it'll allow all the secondary MMU pte blocks (512/1024 at time
with my PT lock design) to be updated to have proper permissions
matching the core linux pte.

> understand the need for invalidate_begin/invalidate_end pairs at all.

The need of the pairs is crystal clear to me: range_begin is needed
for GRU _but_only_if_ range_end is called after releasing the
reference that the VM holds on the page. _begin will flush the GRU tlb
and at the same time it will take a mutex that will block further GRU
tlb-miss-interrupts (no idea how they manange those nightmare locking,
I didn't even try to add more locking to KVM and I get away with the
fact KVM takes the pin on the page itself).

My patch calls invalidate_page/pages before the reference is released
on the page, so GRU will work fine despite lack of
range_begin. Furthermore with my patch GRU will be auto-serialized by
the PT lock w/o the need of any additional locking.

> What I have done is basically create it so that the notifiers get called
> basically in the same place as the normal TLB flushing is done, and nowhere
> else.

That was one of my objectives too.

> I also wanted to avoid calling notifier code from inside eg. hardware TLB
> or pte manipulation primitives. These things are already pretty well
> spaghetti, so I'd like to just place them right where needed first... I
> think eventually it will need a bit of a rethink to make it more consistent
> and more general. But I prefer to do put them in the caller for the moment.

Your patch should also work for KVM but it's suboptimal, my patch can
be orders of magnitude more efficient for GRU thanks to the
invalidate_pages optimization. Christoph complained about having to
call one method per pte.

And adding invalidate_range is useless unless you fully support
xpmem. You're calling invalidate_range in places that can't sleep...

No idea why xpmem needs range_begin, I perfectly understand why GRU
needs _begin with Chrisotph's patch (gru lacks the page pin) but I
dunno why xpmem needs range_begin (xpmem has the page pin so I also
think it could avoid using range_begin). Still to support GRU you need
both to call invalidate_range in places that can sleep and you need
the external rmap notifier. The moment you add xpmem into the equation
your and my clean patches become Christoph's one...
