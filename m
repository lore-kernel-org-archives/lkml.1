Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbZLJHda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbZLJHda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760567AbZLJHd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:33:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56852 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760504AbZLJHd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:33:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH v2  6/8] wipe_page_reference return SWAP_AGAIN if VM pressulre is low and lock contention is detected.
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
In-Reply-To: <20091210154822.2550.A69D9226@jp.fujitsu.com>
References: <20091210154822.2550.A69D9226@jp.fujitsu.com>
Message-Id: <20091210163246.2562.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Dec 2009 16:33:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Woodman reported AIM7 makes serious ptelock and anon_vma_lock
contention on current VM. because SplitLRU VM (since 2.6.28) remove
calc_reclaim_mapped() test, then shrink_active_list() always call
page_referenced() against mapped page although VM pressure is low.
Lightweight VM pressure is very common situation and it easily makes
ptelock contention with page fault. then, anon_vma_lock is holding
long time and it makes another lock contention. then, fork/exit
throughput decrease a lot.

	While running workloads that do lots of forking processes, exiting
	processes and page reclamation(AIM 7) on large systems very high system
	time(100%) and lots of lock contention was observed.

	CPU5:
	 [<ffffffff814afb48>] ? _spin_lock+0x27/0x48
	 [<ffffffff81101deb>] ? anon_vma_link+0x2a/0x5a
	 [<ffffffff8105d3d8>] ? dup_mm+0x242/0x40c
	 [<ffffffff8105e0a9>] ? copy_process+0xab1/0x12be
	 [<ffffffff8105ea07>] ? do_fork+0x151/0x330
	 [<ffffffff81058407>] ? default_wake_function+0x0/0x36
	 [<ffffffff814b0243>] ? _spin_lock_irqsave+0x2f/0x68
	 [<ffffffff810121d3>] ? stub_clone+0x13/0x20
	 [<ffffffff81011e02>] ? system_call_fastpath+0x16/0x1b

	CPU4:
	 [<ffffffff814afb4a>] ? _spin_lock+0x29/0x48
	 [<ffffffff81103062>] ? anon_vma_unlink+0x2a/0x84
	 [<ffffffff810fbab7>] ? free_pgtables+0x3c/0xe1
	 [<ffffffff810fd8b1>] ? exit_mmap+0xc5/0x110
	 [<ffffffff8105ce4c>] ? mmput+0x55/0xd9
	 [<ffffffff81061afd>] ? exit_mm+0x109/0x129
	 [<ffffffff81063846>] ? do_exit+0x1d7/0x712
	 [<ffffffff814b0243>] ? _spin_lock_irqsave+0x2f/0x68
	 [<ffffffff81063e07>] ? do_group_exit+0x86/0xb2
	 [<ffffffff81063e55>] ? sys_exit_group+0x22/0x3e
	 [<ffffffff81011e02>] ? system_call_fastpath+0x16/0x1b

	CPU0:
	 [<ffffffff814afb4a>] ? _spin_lock+0x29/0x48
	 [<ffffffff81101ad1>] ? page_check_address+0x9e/0x16f
	 [<ffffffff81101cb8>] ? page_referenced_one+0x53/0x10b
	 [<ffffffff81102f5a>] ? page_referenced+0xcd/0x167
	 [<ffffffff810eb32d>] ? shrink_active_list+0x1ed/0x2a3
	 [<ffffffff810ebde9>] ? shrink_zone+0xa06/0xa38
	 [<ffffffff8108440a>] ? getnstimeofday+0x64/0xce
	 [<ffffffff810ecaf9>] ? do_try_to_free_pages+0x1e5/0x362
	 [<ffffffff810ecd9f>] ? try_to_free_pages+0x7a/0x94
	 [<ffffffff810ea66f>] ? isolate_pages_global+0x0/0x242
	 [<ffffffff810e57b9>] ? __alloc_pages_nodemask+0x397/0x572
	 [<ffffffff810e3c1e>] ? __get_free_pages+0x19/0x6e
	 [<ffffffff8105d6c9>] ? copy_process+0xd1/0x12be
	 [<ffffffff81204eb2>] ? avc_has_perm+0x5c/0x84
	 [<ffffffff81130db8>] ? user_path_at+0x65/0xa3
	 [<ffffffff8105ea07>] ? do_fork+0x151/0x330
	 [<ffffffff810b7935>] ? check_for_new_grace_period+0x78/0xab
	 [<ffffffff810121d3>] ? stub_clone+0x13/0x20
	 [<ffffffff81011e02>] ? system_call_fastpath+0x16/0x1b

	------------------------------------------------------------------------------
	   PerfTop:     864 irqs/sec  kernel:99.7% [100000 cycles],  (all, 8 CPUs)
	------------------------------------------------------------------------------

	             samples    pcnt         RIP          kernel function
	  ______     _______   _____   ________________   _______________

	             3235.00 - 75.1% - ffffffff814afb21 : _spin_lock
	              670.00 - 15.6% - ffffffff81101a33 : page_check_address
	              165.00 -  3.8% - ffffffffa01cbc39 : rpc_sleep_on  [sunrpc]
	               40.00 -  0.9% - ffffffff81102113 : try_to_unmap_one
	               29.00 -  0.7% - ffffffff81101c65 : page_referenced_one
	               27.00 -  0.6% - ffffffff81101964 : vma_address
	                8.00 -  0.2% - ffffffff8125a5a0 : clear_page_c
	                6.00 -  0.1% - ffffffff8125a5f0 : copy_page_c
	                6.00 -  0.1% - ffffffff811023ca : try_to_unmap_anon
	                5.00 -  0.1% - ffffffff810fb014 : copy_page_range
	                5.00 -  0.1% - ffffffff810e4d18 : get_page_from_freelist

Then, We use trylock for avoiding ptelock contention if VM pressure is
low.

Reported-by: Larry Woodman <lwoodman@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 include/linux/rmap.h |    4 ++++
 mm/rmap.c            |   16 ++++++++++++----
 mm/vmscan.c          |    1 +
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 564d981..499972e 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -110,6 +110,10 @@ static inline void page_dup_rmap(struct page *page)
 
 struct page_reference_context {
 	int is_page_locked;
+
+	/* if 1, we might give up to wipe when find lock contention. */
+	int soft_try;
+
 	unsigned long referenced;
 	unsigned long exec_referenced;
 	int maybe_mlocked;	/* found VM_LOCKED, but it's unstable result */
diff --git a/mm/rmap.c b/mm/rmap.c
index b84f350..5ae7c81 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -373,6 +373,9 @@ int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
 /*
  * Subfunctions of wipe_page_reference: wipe_page_reference_one called
  * repeatedly from either wipe_page_reference_anon or wipe_page_reference_file.
+ *
+ * SWAP_SUCCESS  - success
+ * SWAP_AGAIN    - give up to take lock, try later again
  */
 int wipe_page_reference_one(struct page *page,
 			    struct page_reference_context *refctx,
@@ -381,6 +384,7 @@ int wipe_page_reference_one(struct page *page,
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte;
 	spinlock_t *ptl;
+	int ret = SWAP_SUCCESS;
 
 	/*
 	 * Don't want to elevate referenced for mlocked page that gets this far,
@@ -392,10 +396,14 @@ int wipe_page_reference_one(struct page *page,
 		goto out;
 	}
 
-	pte = page_check_address(page, mm, address, &ptl, 0);
-	if (!pte)
+	pte = __page_check_address(page, mm, address, &ptl, 0,
+				   refctx->soft_try);
+	if (IS_ERR(pte)) {
+		if (PTR_ERR(pte) == -EAGAIN) {
+			ret = SWAP_AGAIN;
+		}
 		goto out;
-
+	}
 	if (ptep_clear_flush_young_notify(vma, address, pte)) {
 		/*
 		 * Don't treat a reference through a sequentially read
@@ -421,7 +429,7 @@ int wipe_page_reference_one(struct page *page,
 	pte_unmap_unlock(pte, ptl);
 
 out:
-	return SWAP_SUCCESS;
+	return ret;
 }
 
 static int wipe_page_reference_anon(struct page *page,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a01cf5e..c235059 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1329,6 +1329,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 		int ret;
 		struct page_reference_context refctx = {
 			.is_page_locked = 0,
+			.soft_try = (priority < DEF_PRIORITY - 2) ? 0 : 1,
 		};
 
 		cond_resched();
-- 
1.6.5.2



