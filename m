Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbYFZJan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbYFZJan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbYFZJ3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:29:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48383 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279AbYFZJ3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:29:22 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 26 Jun 2008 14:59:18 +0530
Message-Id: <20080626092918.16841.74883.sendpatchset@balbir-laptop>
In-Reply-To: <20080626092815.16841.54817.sendpatchset@balbir-laptop>
References: <20080626092815.16841.54817.sendpatchset@balbir-laptop>
Subject: [5/5] memrlimit correct mremap and move_vma accounting
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The memrlimit patches did not account for move_vma() since we account for
address space usage in do_mremap(). The code flow actually increments
total_vm twice (once in do_mremap() and once in move_vma()), the excess
is removed in remove_vma_list() via do_munmap(). Since we did not do the
duplicate accounting, the code was seeing the extra uncharge, causing
our accounting to break. This patch fixes the problem

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/mremap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/mremap.c~memrlimit-fix-move-vma-accounting mm/mremap.c
--- linux-2.6.26-rc5/mm/mremap.c~memrlimit-fix-move-vma-accounting	2008-06-26 14:48:25.000000000 +0530
+++ linux-2.6.26-rc5-balbir/mm/mremap.c	2008-06-26 14:48:25.000000000 +0530
@@ -177,10 +177,15 @@ static unsigned long move_vma(struct vm_
 	if (mm->map_count >= sysctl_max_map_count - 3)
 		return -ENOMEM;
 
+	if (memrlimit_cgroup_charge_as(mm, new_len >> PAGE_SHIFT))
+		return -ENOMEM;
+
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff);
-	if (!new_vma)
+	if (!new_vma) {
+		memrlimit_cgroup_uncharge_as(mm, new_len >> PAGE_SHIFT);
 		return -ENOMEM;
+	}
 
 	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len);
 	if (moved_len < old_len) {
@@ -386,6 +391,8 @@ unsigned long do_mremap(unsigned long ad
 		}
 	}
 
+	memrlimit_cgroup_uncharge_as(mm, (new_len - old_len) >> PAGE_SHIFT);
+
 	/*
 	 * We weren't able to just expand or shrink the area,
 	 * we need to create a new one and move it..
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
