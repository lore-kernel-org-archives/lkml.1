Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbZBMAVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbZBMAVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 19:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZBMAVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 19:21:09 -0500
Received: from gw.goop.org ([64.81.55.164]:53081 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZBMAVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 19:21:06 -0500
Message-ID: <4994BCF0.30005@goop.org>
Date: Thu, 12 Feb 2009 16:21:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: disable preemption in apply_to_pte_range
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 79d9c90453a7bc9e7613ae889a97ff6b44ab8380
Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date:   Thu Feb 12 13:45:34 2009 -0800

    mm: disable preemption in apply_to_pte_range
    
    Lazy mmu mode needs preemption disabled, so if we're apply to
    init_mm (which doesn't require any pte locks), then explicitly
    disable preemption.
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/mm/memory.c b/mm/memory.c
index baa999e..71b3fb8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1710,9 +1710,11 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	pgtable_t token;
 	spinlock_t *uninitialized_var(ptl);
 
-	pte = (mm == &init_mm) ?
-		pte_alloc_kernel(pmd, addr) :
-		pte_alloc_map_lock(mm, pmd, addr, &ptl);
+	if (mm == &init_mm) {
+		preempt_disable();
+		pte = pte_alloc_kernel(pmd, addr);
+	} else
+		pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
 	if (!pte)
 		return -ENOMEM;
 
@@ -1732,6 +1734,9 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 	if (mm != &init_mm)
 		pte_unmap_unlock(pte-1, ptl);
+	else
+		preempt_enable();
+
 	return err;
 }


