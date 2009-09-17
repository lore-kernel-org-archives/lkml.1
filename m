Return-Path: <linux-kernel-owner+w=401wt.eu-S1759153AbZIQHYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbZIQHYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759109AbZIQHYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:24:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654AbZIQHYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:24:32 -0400
Date: Thu, 17 Sep 2009 10:22:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com
Subject: [PATCHv3 2/2] mm: reduce atomic use on use_mm fast path
Message-ID: <20090917072239.GC18115@redhat.com>
References: <cover.1253171695.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1253171695.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mm switched to matches that of active mm, we don't need to
increment and then drop the mm count.  In a simple benchmark this
happens in about 50% of time.  Making that conditional reduces
contention on that cache line on SMP systems.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 mm/mmu_context.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index fd473b5..ded9081 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -26,13 +26,16 @@ void use_mm(struct mm_struct *mm)
 
 	task_lock(tsk);
 	active_mm = tsk->active_mm;
-	atomic_inc(&mm->mm_count);
+	if (active_mm != mm) {
+		atomic_inc(&mm->mm_count);
+		tsk->active_mm = mm;
+	}
 	tsk->mm = mm;
-	tsk->active_mm = mm;
 	switch_mm(active_mm, mm, tsk);
 	task_unlock(tsk);
 
-	mmdrop(active_mm);
+	if (active_mm != mm)
+		mmdrop(active_mm);
 }
 
 /*
-- 
1.6.2.5
