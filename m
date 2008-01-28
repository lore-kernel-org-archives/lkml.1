Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbYA1Uaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbYA1Uaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYA1U3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:29:30 -0500
Received: from relay2.sgi.com ([192.48.171.30]:54530 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757608AbYA1U30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:29:26 -0500
Message-Id: <20080128202924.810792591@sgi.com>
References: <20080128202840.974253868@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Jan 2008 12:28:46 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: [patch 6/6] mmu_notifier: Add invalidate_all()
Content-Disposition: inline; filename=mmu_all
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when a task exits we can remove all external pts at once. At that point the
extern mmu may also unregister itself from the mmu notifier chain to avoid
future calls.

Note the complications because of RCU. Other processors may not see that the
notifier was unlinked until a quiescent period has passed!

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mmu_notifier.h |    4 ++++
 mm/mmap.c                    |    1 +
 2 files changed, 5 insertions(+)

Index: linux-2.6/include/linux/mmu_notifier.h
===================================================================
--- linux-2.6.orig/include/linux/mmu_notifier.h	2008-01-28 11:43:03.000000000 -0800
+++ linux-2.6/include/linux/mmu_notifier.h	2008-01-28 12:21:33.000000000 -0800
@@ -62,6 +62,10 @@ struct mmu_notifier_ops {
 				struct mm_struct *mm,
 				unsigned long address);
 
+	/* Dummy needed because the mmu_notifier() macro requires it */
+	void (*invalidate_all)(struct mmu_notifier *mn, struct mm_struct *mm,
+				int dummy);
+
 	/*
 	 * lock indicates that the function is called under spinlock.
 	 */
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c	2008-01-28 11:47:53.000000000 -0800
+++ linux-2.6/mm/mmap.c	2008-01-28 11:57:45.000000000 -0800
@@ -2034,6 +2034,7 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long end;
 
 	/* mm's last user has gone, and its about to be pulled down */
+	mmu_notifier(invalidate_all, mm, 0);
 	arch_exit_mmap(mm);
 
 	lru_add_drain();

-- 
