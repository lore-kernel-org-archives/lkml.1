Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZC0SC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZC0SC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZC0SCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:02:47 -0400
Received: from gw.goop.org ([64.81.55.164]:58130 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751294AbZC0SCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:02:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/8] mm: disable preemption in apply_to_pte_range
Date: Fri, 27 Mar 2009 11:02:36 -0700
Message-Id: <1238176963-21093-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238176963-21093-1-git-send-email-jeremy@goop.org>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: bugfix

Lazy mmu mode needs preemption disabled, so if we're apply to
init_mm (which doesn't require any pte locks), then explicitly
disable preemption.  (Do it unconditionally after checking we've
successfully done the allocation to simplify the error handling.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 mm/memory.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ef11ac6..27f8677 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1722,6 +1722,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 	BUG_ON(pmd_huge(*pmd));
 
+	preempt_disable();
 	arch_enter_lazy_mmu_mode();
 
 	token = pmd_pgtable(*pmd);
@@ -1733,6 +1734,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	arch_leave_lazy_mmu_mode();
+	preempt_enable();
 
 	if (mm != &init_mm)
 		pte_unmap_unlock(pte-1, ptl);
-- 
1.6.0.6

