Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZJVGCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZJVGCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZJVGCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:02:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39453 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZJVGC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:02:29 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] HWPOISON: Fix page count leak in hwpoison late kill in do_swap_page
Date: Thu, 22 Oct 2009 08:02:28 +0200
Message-Id: <1256191352-6903-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1256191352-6903-4-git-send-email-andi@firstfloor.org>
References: <i>
 <1256191352-6903-1-git-send-email-andi@firstfloor.org>
 <1256191352-6903-2-git-send-email-andi@firstfloor.org>
 <1256191352-6903-3-git-send-email-andi@firstfloor.org>
 <1256191352-6903-4-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When returning due to a poisoned page drop the page count.

It wasn't a fatal problem because noone cares about the page count
on a poisoned page (except when it wraps), but it's cleaner to fix it.

Pointed out by Linus.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7e91b5f..7a3b0ad 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2539,7 +2539,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	} else if (PageHWPoison(page)) {
 		ret = VM_FAULT_HWPOISON;
 		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
-		goto out;
+		goto out_release;
 	}
 
 	lock_page(page);
@@ -2611,6 +2611,7 @@ out_nomap:
 	pte_unmap_unlock(page_table, ptl);
 out_page:
 	unlock_page(page);
+out_release:
 	page_cache_release(page);
 	return ret;
 }
-- 
1.6.0.2

