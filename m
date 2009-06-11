Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbZFKOyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbZFKOyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759474AbZFKOxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:53:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:31949 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897AbZFKOxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:53:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="153176989"
Message-Id: <20090611144430.540500784@intel.com>
References: <20090611142239.192891591@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Jun 2009 22:22:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 2/5] HWPOISON: fix tasklist_lock/anon_vma locking order
Content-Disposition: inline; filename=hwpoison-lock-order.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid possible deadlock. Proposed by Nick Piggin:

  You have tasklist_lock(R) nesting outside i_mmap_lock, and inside anon_vma
  lock. And anon_vma lock nests inside i_mmap_lock.

  This seems fragile. If rwlocks ever become FIFO or tasklist_lock changes
  type (maybe -rt kernels do it), then you could have a task holding
  anon_vma lock and waiting for tasklist_lock, and another holding tasklist
  lock and waiting for i_mmap_lock, and another holding i_mmap_lock and
  waiting for anon_vma lock.

CC: Nick Piggin <npiggin@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- sound-2.6.orig/mm/memory-failure.c
+++ sound-2.6/mm/memory-failure.c
@@ -215,12 +215,14 @@ static void collect_procs_anon(struct pa
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
-	struct anon_vma *av = page_lock_anon_vma(page);
+	struct anon_vma *av;
 
+	read_lock(&tasklist_lock);
+
+	av = page_lock_anon_vma(page);
 	if (av == NULL) /* Not actually mapped anymore */
-		return;
+		goto out;
 
-	read_lock(&tasklist_lock);
 	for_each_process (tsk) {
 		if (!tsk->mm)
 			continue;
@@ -230,6 +232,7 @@ static void collect_procs_anon(struct pa
 		}
 	}
 	page_unlock_anon_vma(av);
+out:
 	read_unlock(&tasklist_lock);
 }
 

-- 

