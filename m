Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbYEESq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbYEESq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762570AbYEESeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:34:11 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:44169
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762548AbYEESeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:34:08 -0400
Date: Mon, 5 May 2008 20:34:05 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Jack Steiner <steiner@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 01 of 11] mmu-notifier-core
Message-ID: <20080505183405.GI8470@duo.random>
References: <patchbomb.1209740703@duo.random> <1489529e7b53d3f2dab8.1209740704@duo.random> <20080505162113.GA18761@sgi.com> <20080505171434.GF8470@duo.random> <20080505172506.GA9247@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505172506.GA9247@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 12:25:06PM -0500, Jack Steiner wrote:
> Agree. My apologies... I should have caught it.

No problem.

> __mmu_notifier_register/__mmu_notifier_unregister seems like a better way to
> go, although either is ok.

If you also like __mmu_notifier_register more I'll go with it. The
bitflags seems like a bit of overkill as I can't see the need of any
other bitflag other than this one and they also can't be removed as
easily in case you'll find a way to call it outside the lock later.

> Let me finish my testing. At one time, I did not use ->release but
> with all the locking & teardown changes, I need to do some reverification.

If you didn't implement it you shall apply this patch but you shall
read carefully the comment I written that covers that usage case.

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -29,10 +29,25 @@ struct mmu_notifier_ops {
 	/*
 	 * Called either by mmu_notifier_unregister or when the mm is
 	 * being destroyed by exit_mmap, always before all pages are
-	 * freed. It's mandatory to implement this method. This can
-	 * run concurrently with other mmu notifier methods and it
+	 * freed. This can run concurrently with other mmu notifier
+	 * methods (the ones invoked outside the mm context) and it
 	 * should tear down all secondary mmu mappings and freeze the
-	 * secondary mmu.
+	 * secondary mmu. If this method isn't implemented you've to
+	 * be sure that nothing could possibly write to the pages
+	 * through the secondary mmu by the time the last thread with
+	 * tsk->mm == mm exits.
+	 *
+	 * As side note: the pages freed after ->release returns could
+	 * be immediately reallocated by the gart at an alias physical
+	 * address with a different cache model, so if ->release isn't
+	 * implemented because all memory accesses through the
+	 * secondary mmu implicitly are terminated by the time the
+	 * last thread of this mm quits, you've also to be sure that
+	 * speculative hardware operations can't allocate dirty
+	 * cachelines in the cpu that could not be snooped and made
+	 * coherent with the other read and write operations happening
+	 * through the gart alias address, leading to memory
+	 * corruption.
 	 */
 	void (*release)(struct mmu_notifier *mn,
 			struct mm_struct *mm);
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -59,7 +59,8 @@ void __mmu_notifier_release(struct mm_st
 		 * from establishing any more sptes before all the
 		 * pages in the mm are freed.
 		 */
-		mn->ops->release(mn, mm);
+		if (mn->ops->release)
+			mn->ops->release(mn, mm);
 		srcu_read_unlock(&mm->mmu_notifier_mm->srcu, srcu);
 		spin_lock(&mm->mmu_notifier_mm->lock);
 	}
@@ -251,7 +252,8 @@ void mmu_notifier_unregister(struct mmu_
 		 * guarantee ->release is called before freeing the
 		 * pages.
 		 */
-		mn->ops->release(mn, mm);
+		if (mn->ops->release)
+			mn->ops->release(mn, mm);
 		srcu_read_unlock(&mm->mmu_notifier_mm->srcu, srcu);
 	} else
 		spin_unlock(&mm->mmu_notifier_mm->lock);
