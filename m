Return-Path: <linux-kernel-owner+w=401wt.eu-S1763091AbYA3Tuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763091AbYA3Tuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYA3Tu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:50:28 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35366 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753279AbYA3Tu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:50:27 -0500
Date: Wed, 30 Jan 2008 11:50:26 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080130182506.GQ7233@v2.random>
Message-ID: <Pine.LNX.4.64.0801301147330.30568@schroedinger.engr.sgi.com>
References: <20080129162004.GL7233@v2.random>
 <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com>
 <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com>
 <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com>
 <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com>
 <20080130170451.GP7233@v2.random> <20080130173009.GT26420@sgi.com>
 <20080130182506.GQ7233@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008, Andrea Arcangeli wrote:

> XPMEM requires with invalidate_range (sleepy) +
> before_invalidate_range (sleepy). invalidate_all should also be called
> before_release (both sleepy).
> 
> It sounds we need full overlap of information provided by
> invalidate_page and invalidate_range to fit all three models (the
> opposite of the zero objective that current V3 is taking). And the
> swap will be handled only by invalidate_page either through linux rmap
> or external rmap (with the latter that can sleep so it's ok for you,
> the former not). GRU can safely use the either the linux rmap notifier
> or the external rmap notifier equally well, because when try_to_unmap
> is called the page is locked and obviously pinned by the VM itself.

So put the invalidate_page() callbacks in everywhere.

Then we have 

invalidate_range_start(mm)

and

invalidate_range_finish(mm, start, end)

in addition to the invalidate rmap_notifier?

---
 include/linux/mmu_notifier.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/mmu_notifier.h
===================================================================
--- linux-2.6.orig/include/linux/mmu_notifier.h	2008-01-30 11:49:02.000000000 -0800
+++ linux-2.6/include/linux/mmu_notifier.h	2008-01-30 11:49:57.000000000 -0800
@@ -69,10 +69,13 @@ struct mmu_notifier_ops {
 	/*
 	 * lock indicates that the function is called under spinlock.
 	 */
-	void (*invalidate_range)(struct mmu_notifier *mn,
+	void (*invalidate_range_begin)(struct mmu_notifier *mn,
 				 struct mm_struct *mm,
-				 unsigned long start, unsigned long end,
 				 int lock);
+
+	void (*invalidate_range_end)(struct mmu_notifier *mn,
+				 struct mm_struct *mm,
+				 unsigned long start, unsigned long end);
 };
 
 struct mmu_rmap_notifier_ops;
