Return-Path: <linux-kernel-owner+w=401wt.eu-S1764412AbYDZA5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764412AbYDZA5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbYDZA5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:57:30 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:60919
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759909AbYDZA53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:57:29 -0400
Date: Sat, 26 Apr 2008 02:57:26 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robin Holt <holt@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 1 of 9] Lock the entire mm to prevent any mmu related
	operation to happen
Message-ID: <20080426005726.GA9514@duo.random>
References: <ec6d8f91b299cf26cce5.1207669444@duo.random> <200804221506.26226.rusty@rustcorp.com.au> <20080425165639.GA23300@duo.random> <20080425192532.GA19717@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425192532.GA19717@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 02:25:32PM -0500, Robin Holt wrote:
> I think you still need mm_lock (unless I miss something).  What happens
> when one callout is scanning mmu_notifier_invalidate_range_start() and
> you unlink.  That list next pointer with LIST_POISON1 which is a really
> bad address for the processor to track.

Ok, _release list_del_init qcan't race with that because it happens in
exit_mmap when no other mmu notifier can trigger anymore.

_unregister can run concurrently but it does list_del_rcu, that only
overwrites the pprev pointer with LIST_POISON2. The
mmu_notifier_invalidate_range_start won't crash on LIST_POISON1 thanks
to srcu.

Actually I did more changes than necessary, for example I noticed the
mmu_notifier_register can return a list_add_head instead of
list_add_head_rcu. _register can't race against _release thanks to the
mm_users temporary or implicit pin. _register can't race against
_unregister thanks to the mmu_notifier_mm->lock. And register can't
race against all other mmu notifiers thanks to the mm_lock.

At this time I've no other pending patches on top of v14-pre3 other
than the below micro-optimizing cleanup. It'd be great to have
confirmation that v14-pre3 passes GRU/XPMEM regressions tests as well
as my KVM testing already passed successfully on it. I'll forward
v14-pre3 mmu-notifier-core plus the below to Andrew tomorrow, I'm
trying to be optimistic here! ;)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -187,7 +187,7 @@ int mmu_notifier_register(struct mmu_not
 	 * current->mm or explicitly with get_task_mm() or similar).
 	 */
 	spin_lock(&mm->mmu_notifier_mm->lock);
-	hlist_add_head_rcu(&mn->hlist, &mm->mmu_notifier_mm->list);
+	hlist_add_head(&mn->hlist, &mm->mmu_notifier_mm->list);
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 out_unlock:
 	mm_unlock(mm, &data);
