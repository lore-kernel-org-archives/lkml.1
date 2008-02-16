Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYBPLHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYBPLHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYBPLHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:07:42 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:52683
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbYBPLHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:07:41 -0500
Date: Sat, 16 Feb 2008 12:07:38 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 3/6] mmu_notifier: invalidate_page callbacks
Message-ID: <20080216110738.GJ11732@v2.random>
References: <20080215064859.384203497@sgi.com> <20080215064932.918191502@sgi.com> <20080215193736.9d6e7da3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215193736.9d6e7da3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 07:37:36PM -0800, Andrew Morton wrote:
> The "|" is obviously deliberate.  But no explanation is provided telling us
> why we still call the callback if ptep_clear_flush_young() said the page
> was recently referenced.  People who read your code will want to understand
> this.

This is to clear the young bit in every pte and spte to such physical
page before backing off because any young bit was on. So if any young
bit will be on in the next scan, we're guaranteed the page has been
touched recently and not ages before (otherwise it would take a worst
case N rounds of the lru before the page can be freed, where N is the
number of pte or sptes pointing to the page).

> I just don't see how ths can be done if the callee has another thread in
> the middle of establishing IO against this region of memory. 
> ->invalidate_page() _has_ to be able to block.  Confused.

invalidate_page marking the spte invalid and flushing the asid/tlb
doesn't need to block the same way ptep_clear_flush doesn't need to
block for the main linux pte. Infact before invalidate_page and
ptep_clear_flush can touch anything at all, they've to take their own
spinlocks (mmu_lock for the former, and PT lock for the latter).

The only sleeping trouble is for networked driven message passing,
where they want to schedule while they wait the message to arrive or
it'd hang the whole cpu to spin for so long.

sptes are cpu-clocked entities like ptes so scheduling there is by far
not necessary because there's zero delay in invalidating them and
flushing their tlbs. GRU is similar. Because we boost the reference
count of the pages for every spte mapping, only implementing
invalidate_range_end is enough, but I need to figure out the
get_user_pages->rmap_add window too and because get_user_pages can
schedule, and if I want to add a critical section around it to avoid
calling get_user_pages twice during the kvm page fault, a mutex would
be the only way (it sure can't be a spinlock). But a mutex can't be
taken by invalidate_page to stop it. So that leaves me with the idea
of adding a get_user_pages variant that returns the page locked. So
instead of calling get_user_pages a second time after rmap_add
returns, I will only need to call unlock_page which should be faster
than a follow_page. And setting the PG_lock before dropping the PT
lock in follow_page, should be fast enough too.
